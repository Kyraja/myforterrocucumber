# *****************************************************************************
#  Name           : wertgutschrift.feature
#  Autor          : dago
#  Verantwortlich : dago
#  Kontrolle      : foe
#  Funktion       : Testet Funktionen rund um die Wertgutschrift
#
# *****************************************************************************
#
@persistent
Feature: Wertgutschriften
Background:
Given I set the fake date to "05.01.1995"

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Neue Artikel anlegen
# ----------------------------------------------------------------------------------------------

# Nicht bestandsgefuehrte Warengruppe
Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set fields
| nummer  | 56NB |
| befuehr | nein |
And I save the current editor

Given I open an editor "TE007" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
| such     | TE007                |
| num2     | 007S-VK              |
| namebspr | Schraube Gewinde 007 |
| vpr      | 12                   |
| epr      | 12                   |
| bsart    | Fremdbeschaffung     |
| dispoa   | auftragsbezogen      |
And I save the current editor

Given I open an editor "TE008" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
| such     | TE008            |
| namebspr | Teil 008         |
| bsart    | Fremdbeschaffung |
| dispoa   | auftragsbezogen  |
| vpr      | 10               |
| epr      | 10               |
| wgruppe  | 56NB             |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario Outline: STAMMDATEN - Artikeln mit Materialzuschlag und Provisionssatz anlegen.
# ----------------------------------------------------------------------------------------------

# Provisionssatz anlegen
Given I open an editor "provision" from table "(Commission):(Commission)" with command "STORE" for record "PROV1"
And I set fields
    | such   | PROV1 |
    | artpg  | PROV1 |
    | provis | 10    |
And I save the current editor

# Materialzuschlag anlegen
Given I open an editor "matzuschlag" from table "(Company):(MaterialSurchargeHeader)" with command "STORE" for record "30"
And I append rows
	| matart | matbasis | matnotiz |
	| CU     | 100      | 110      |
And I save the current editor

# Provisionsgruppe im Materialzuschlag hinterlegen
Given I open an editor "zumatzu" from table "(Part):(SupplementaryItem)" with command "UPDATE" for record "MATZU"
And I set field "prov" to "PROV1"
And I save the current editor

Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
| such     | <such>     |
| namebspr | <namebspr> |
| vkbez    | <vkbez>    |
| vbez     | <vbez>     |
| ebez     | <ebez>     |
| vpr      | <vpr>      |
| bsart    | <bsart>    |
| dispoa   | <dispoa>   |
| lief     | <lief>     |
| epr      | <epr>      |
| efrist   | <efrist>   |
| matart   | <matart>   |
| zmge     | <zmge>     |
| matvrel  | <matvrel>  |
| materel  | <materel>  |
| prov     | <prov>     |
And I save the current editor
Examples: Artikel
| such    | namebspr   | vkbez     | vbez    | ebez      | vpr   | bsart            | dispoa         | lief | epr  | efrist | matart | zmge | matvrel | materel | prov  |
| TECH005 | Schraube 5 | Gewinde 5 | Tech005 | Gewinde 5 | 10000 | Fremdbeschaffung | bedarfsbezogen | 1    | 9000 | 15     | CU     | 0,5  | ja      | ja      | PROV1 |
| TECH006 | Schraube 6 | Gewinde 6 | Tech006 | Gewinde 6 | 9000  | Fremdbeschaffung | bedarfsbezogen | 1    | 7000 | 10     | CU     | 1    | ja      | ja      | PROV1 |

# ----------------------------------------------------------------------------------------------
Scenario Outline: STAMMDATEN - Neue Dienstleistungen mit Preiseinheit h anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "<ndienstl>" from table "(Part):(Service)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vpr" to "<preis>"
And I set field "vpe" to "h"
And I set field "vhe" to "h"
And I set field "lief" to "<lief>"
And I set field "efrist" to "<efrist>"
And I set field "epr" to "<epr>"
And I save the current editor

Examples: Dienstleistungen
| ndienstl   | such         | namebspr     | preis | lief | efrist | epr   |
| hdienstl   | dl-hanalyse  | Analyse in h | 60.00 |      |        |       |
| repdienstl | dl-reparatur | Reparatur    | 70.00 | 1    | 1      | 70.00 |


# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Prozentposition (Zusatzposition) anlegen.
# ----------------------------------------------------------------------------------------------

Given I open an editor "5Prozent" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set fields
    | nummer | 5PROZ |
    | such   | PROZ5 |
    | zptyp  | Prozentposition |
    | evproz | 5     |
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario Outline: STAMMDATEN - neutrale Zusatzposition / AU/BE anlegen / UMLAGE
# ----------------------------------------------------------------------------------------------

Given I open an editor "<zusatzpos>" from table "(Part):(SupplementaryItem)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "zptyp" to "<zptyp>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "epr" to "<epr>"
And I set field "umlage" to "<uml>"
And I save the current editor

Examples: Artikel
| zusatzpos   | such    | namebspr          | zptyp             | vkbez             | vbez              | ebez              | vpr | epr | uml |
| neutralePOS | NEUPOS  | Neutrale Position | Neutrale Position | Neutrale Position | Neutrale Position | Neutrale Position | 500 | 400 |     |
| AUBEPOS     | AUBEPOS | AU/BE             | AU/BE             | AU/BE Position    | AU/BE Position    | Neutrale Position | 200 | 175 |     |
| UMLAGPOS    | UMLPOS  | Umlage            |                   | Umlage VK         | Umlage            | Umlage EK         |  10 |  11 | ja  |

# ----------------------------------------------------------------------------------------------
Scenario Outline: Allen Artikeln einen Zugangspreis geben
# ----------------------------------------------------------------------------------------------

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel	| <artikel>   |
	| buart		| Zugang      |
	| beleg		| mpr-erzwing |
	| beldat	| .           |
	| wert		| <wert>      |
And I append rows
	| mge   | platz2  | verw      |
	| <mge> | <platz> | <verw>    |
And I save the current editor

Examples:
	| artikel	| wert	| mge	| platz	| verw    |
	| E1		|  2	| 100	| F1	| e1_mpr  |
	| E1		|  3	| 200	| F2	| e1_mp   |
	| E2		|  4	| 150	| F1	| e2_mp   |
	| E2		|  5	| 50	| F2	| e2_mp   |
	| EINK		|  6	| 150	| F1	| eink_mpr|
	| EINK		|  7	| 50	| F2	| eink_mpr|
	| V1		|  8	| 200	| F1	| v1_mp   |
	| V1		|  9	| 100	| F2	| v1_mp   |
	| V2		| 10	| 100	| F1	| v2_mp   |
	| V2		| 11	| 200	| F2	| v2_mp   |
	| V3		| 12	| 100	| F1	| v3_mp   |
	| V3		| 13	| 50	| F2	| v3_mp   |
	| TE007		| 14	| 100	| F1	| te07_mpr|
	| TE007		| 15	| 50	| F2	| te07_mpr|
	| E3		| 16	| 150	| F1	| e2_mp   |
	| E3		| 17	| 50	| F2	| e2_mp   |


# ----------------------------------------------------------------------------------------------
Scenario: VK-Wertgut-01: Auftrag, RE mit LB, Wertgutschrift erstellen
# ----------------------------------------------------------------------------------------------

Given I open an editor "AUFTRAG-01" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 01AU     |
   | kunde   | 1        |
   | such    | AU01     |
   | betreff | AU1-WERT |
And I append rows
   | artikel | mge | preis |
   | !TE007  | 20  | 6     |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "LS-01EK" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "AUFTRAG-01"
And I set fields
 | such   | LS-01EK |
 | nummer | 01EKLS  |
 | ueb    | ja      |
 | vom    | .       |
And I set field "mge" to "5" in row 1
And I save the current editor

# Rechnung mit LB - ungebucht
Given I open an editor "RE1-ZU-AU01" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "01AU"
And I set fields
   | such   | RE-AU01 |
   | nummer | 01VKRE  |
   | ueb    | nein    |
   | tterm  | .       |
   | budat  | .       |
And I set field "mge" to "12" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift: Rechnung -> Rechnung
Given I open an editor "WERT-ZU-AU01" from table "(Sales):(Invoice)" with command "NEW" for record ""
# Aus einer ungebuchten Rechnung darf keine Wertgutschrift entstehen
Then setting field "beleg" to "01VKRE" throws the exception "4615"
And I close the current editor

# Rechnung mit LB - ungebucht
Given I open an editor "RE2-ZU-AU01" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "01AU"
And I set fields
   | such   | RE2-AU01 |
   | nummer | 02VKRE   |
   | ueb    | nein     |
   | tterm  | .        |
   | budat  | .        |
Then field "schreib" is modifiable
And I set field "mge" to "2" in row 1
And I set field "preis" to "5,2" in row 1
# AU/BE Position
And I create a new row at position 2
And I set field "artex" to "a." in row 2
And I set field "mge" to "2" in row 2
And I set field "preis" to "2" in row 2
# Dienstleistung
And I create a new row at position 3
And I set field "artex" to "DL-HANALYSE" in row 3
And I set field "mge" to "3" in row 3
And I set field "preis" to "3" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 01VKRE buchen
Given I open an editor "RE1-ZU-AU01" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE1-ZU-AU01"
And I set fields
   | ueb    | ja         |
Then field "schreib" is not modifiable
And I save the current editor

# In gebuchter Rechnung: remge und nwert gefuellt
Then field "remge" from editor "RE1-ZU-AU01" in row 1 has value "-12"
Then field "ofwert" from editor "RE1-ZU-AU01" in row 1 has value "-72.00"

# Wertgutschrift: Rechnung -> Rechnung
Given I open an editor "WERT-ZU-AU01" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE1-ZU-AU01"
And I set fields
   | nummer | 01WERT     |
   | such   | VK-WERT01  |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
Then the table has 4 rows
Then field "preis" has value "6.00" in row 1
And I set field "mge" to "-2" in row 1
And I set field "preis" to "5" in row 1
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "treart" has value "Kaufmännische Gutschrift" in row 1
Then field "tlsart" has value "" in row 1
# Nur gebuchte Rechnungen duerfen angefuegt werden
Then setting field "beleg" to "01EKLS" throws the exception "4615"
Then setting field "beleg" to "02VKRE" throws the exception "6822"
And I save the current editor

# Stornieren der Rechnung nicht moeglich, da bereits Wertgutschriften vorhanden sind.
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE1-ZU-AU01" throws the exception "6729"

# Rechnung 01VKRE buchen
Given I open an editor "RE2-ZU-AU01" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE2-ZU-AU01"
And I set fields
   | ueb    | ja         |
And I save the current editor

Given I open an editor "WERT2-ZU-AU01" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE2-ZU-AU01"
And I set fields
   | nummer | 02WERT     |
   | such   | VK-WERT02  |
   | ueb    | nein       |
   | tterm  | .          |
   | budat  | .          |
Then field "preis" has value "5.20" in row 1
Then field "mge" has value "0" in row 1
Then field "pwert" has value "0.00" in row 1
Then field "fixpwert" has value "ja" in row 1
Then field "rabmge" has value "0" in row 1
Then field "proz" has value "0" in row 1
Then field "herkunft" has value "" in row 1
Then field "ofmge" has value "-2" in row 1
And I set field "mge" to "-1" in row 1
Then field "schreib" is modifiable
Then field "fixpwert" is not modifiable in row 1
Then field "fixpwert" is not modifiable in row 2
Then field "fixpwert" is not modifiable in row 3
Then field "lehe" is not modifiable in row 1
Then field "lehe" is not modifiable in row 2
Then field "lehe" is not modifiable in row 3
Then field "pehe" is not modifiable in row 1
Then field "pehe" is not modifiable in row 2
Then field "pehe" is not modifiable in row 3
Then field "zrahmen" is not modifiable in row 1
Then field "zrahmen" is not modifiable in row 2
Then field "zrahmen" is not modifiable in row 3
Then field "zignrahmen" is not modifiable in row 1
Then field "zignrahmen" is not modifiable in row 2
Then field "zignrahmen" is not modifiable in row 3
And I save the current editor

# Wertgutschrift erstellen nicht moeglich, da bereits eine ungebuchte Wertgutschrift vorhanden ist.
Then opening an editor from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE2-ZU-AU01" throws the exception "10362"

Given I open an editor "WERT2-ZU-AU01" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "WERT2-ZU-AU01"
And I set fields
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
Then field "schreib" is not modifiable
And I save the current editor

# Nun ist Wertgutschrift erstellen moeglich
Given I open an editor "WERT3-ZU-AU01" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE2-ZU-AU01"
And I close the current editor

# Rechnung kann nicht storniert werden, da Wertgutschrift vorhanden ist
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE2-ZU-AU01" throws the exception "6729"

# ----------------------------------------------------------------------------------------------
Scenario: VK-Wertgut-02: Anfuegen von Rechnungen mit unterschiedlichen Warenempfaengern wird verhindert
# ----------------------------------------------------------------------------------------------

# Rechnung mit LB
Given I open an editor "RE03-VK-Kunde2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | such   | RE03KU2 |
   | nummer | 03VKRE  |
   | kunde  | 2       |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
And I append rows
   | artikel | mge | preis |
   | !TE007  | 40  | 5     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK-Wertgut-03: Rechnung anlegen und buchen
# ----------------------------------------------------------------------------------------------

Given I open an editor "vkrechnung03" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "nummer" to "03VKREB"
And I set field "such" to "RE-VK03B"
And I set field "ueb" to "ja"
And I set field "tterm" to "."
And I append rows
   | artex    | mge         | proz        | pwert       | preis       |
   | v1       | 10          | -5          | !dontChange | !dontChange | # Artikel
   | 4        | !dontChange | -10         | !dontChange | !dontChange | # Gesamtrabatt
   | text     | !dontChange | !dontChange | 10          | !dontChange | # Text
   | NEUPOS   | !dontChange | !dontChange | 15          | !dontChange | # Neutrale Position
   | dl-repar | 1           | !dontChange | !dontChange | !dontChange | # Dienstleistung
   | 5        | !dontChange | !dontChange | !dontChange | 100         | # Mindestbestellwert
   | 3        | !dontChange | !dontChange | !dontChange | !dontChange | # Zwischensumme
   | 4        | !dontChange | -20         | !dontChange | !dontChange | # Gesamtrabatt
   | a.       | 10          | !dontChange | !dontChange | 5           | # AU/BE Position
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" has value "-10" in row 1
Then field "ofwert" has value "-237.50" in row 1
Then field "remge" has value "0" in row 2
Then field "ofwert" has value "23.75" in row 2
Then field "remge" has value "-10" in row 3
Then field "ofwert" has value "-10.00" in row 3
Then field "remge" has value "-15" in row 4
Then field "ofwert" has value "-15.00" in row 4
Then field "remge" has value "-1" in row 5
Then field "ofwert" has value "-70.00" in row 5
Then field "remge" has value "0" in row 6
Then field "ofwert" has value "-30.00" in row 6
Then field "remge" has value "0" in row 7
Then field "ofwert" has value "0.00" in row 7
Then field "remge" has value "0" in row 8
Then field "ofwert" has value "67.75" in row 8
Then field "remge" has value "-10" in row 9
Then field "ofwert" has value "-50.00" in row 9
Then field "remge" has value "0" in row 10
Then field "ofwert" has value "0.00" in row 10
Then field "remge" has value "0" in row 11
Then field "ofwert" has value "0.00" in row 11
Then field "remge" has value "0" in row 12
Then field "ofwert" has value "0.00" in row 12

# Wertgutschrift: alle Positionen ausser den Rechnungsabschlusspositionen uebernehmen
Given I open an editor "WERT-ZU-VKRE03" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "vkrechnung03"
Then the table has 12 rows
And I close the current editor

#Rechnung stornieren
Given I open an editor "restorno03" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "vkrechnung03"
And I set field "num3" to "03REVKS"
And I save the current editor

#Stornierte Rechnung pruefen
Given I open an editor "vkrechv03" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "vkrechnung03"
Then field "remge" has value "0" in row 1
Then field "ofwert" has value "0.00" in row 1
And I close the current editor

#Storno-Rechnung pruefen
Given I open an editor "vkstornorechv03" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "restorno03"
Then field "remge" has value "0" in row 1
Then field "ofwert" has value "0.00" in row 1
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-Wertgut-04: Anzahlungsrechnung
# ----------------------------------------------------------------------------------------------

#Auftrag anlegen
Given I open an editor "auftrag04" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1       |
   | such   | AU-VK04 |
   | nummer | 04VKAU  |
And I append rows
   | artikel | mge |
   | v1      | 10  |
And I save the current editor

#Fakturaplan anlegen
Given I open an editor "fakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "auftrag04"
And I set field "namebspr" to "Fakturaplan zu Auftrag"
And I append rows
   | reart     | proz | ptext | zbed |
   | Anzahlung | 20   | 1.    | 203  |

#Anzahlungsrechnung anlegen
And I press button "anzahlungsrechn" to open a subeditor for "fakturaplan_auf" in row 1
And I set field "nummer" to "04VKRE"
And I set field "such" to "RE-VK04"
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "fakturaplan"
And I save the current editor

#Anzahlungsrechnung pruefen
Given I open an editor "anzrech" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "fakturaplan_auf"
Then field "remge" has value "-50" in row 1
Then field "ofwert" has value "-50.00" in row 1
Then field "remge" has value "0" in row 2
Then field "ofwert" has value "0.00" in row 2
Then field "remge" has value "0" in row 3
Then field "ofwert" has value "0.00" in row 3
Then field "remge" has value "0" in row 4
Then field "ofwert" has value "0.00" in row 4
And I close the current editor

#Anzahlungsrechnung stornieren
Given I open an editor "vkstornoanzre" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "fakturaplan_auf"
And I set field "num3" to "04VKRES"
And I save the current editor

#Stornierte Anzahlungsrechnung pruefen
Given I open an editor "vkrechv04" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "fakturaplan_auf"
Then field "remge" has value "0" in row 1
Then field "ofwert" has value "0.00" in row 1
And I close the current editor

#Storno-Anzahlungsrechnung pruefen
Given I open an editor "vkstornorechv04" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "vkstornoanzre"
Then field "remge" has value "0" in row 1
Then field "ofwert" has value "0.00" in row 1
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - Fakturierung ueber den Lieferschein. Komplettwertgutschrift zu Rechnung anlegen
# ----------------------------------------------------------------------------------------------

# AU  -------------------------  LS  (buchen)------------------ RE (buchen) ----------- RE (WGS 100%)
# 10 St.                         10 St.                         10 St. (1!)             -10 St. (2! buchen)
# | Aktion | remge  | ablage |   | Aktion | remge  | ablage |   | Aktion | remge   |    | Aktion | remge  |
# |        |  0 St. |  ja    |   |        | 10 St. |  nein  |   | (1)    | -10 St. |    | (2)    |  0 St. |
#                                | (1)    |  0 St. |  ja    |   | (2)    |   0 St. |
#                                | (2)    | 10 St. |  nein  |

# Auftrag
Given I open an editor "1AU001" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU001   |
   | kunde   | 1        |
   | such    | AU001    |
And I append rows
   | artikel | mge | preis |
   | V1      | 10  | 10    |
And I save the current editor

# Lieferschein
Given I open an editor "1LS001" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU001"
And I set fields
   | nummer | 1LS001  |
   | such   | LS001   |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE001" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS001"
And I set fields
   | nummer | 1RE001  |
   | such   | RE001   |
   | ueb    | ja      |
   | tterm  | .       |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "1WG001" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE001"
And I set fields
   | nummer | 1WG001  |
   | such   | WG001   |
   | ueb    | nein    |
   | tterm  | .       |
And I set field "mge" to "-10" in row 1
And I save the current editor

# Pruefen von remge und ofwert in Rechnung vor Buchen der Komplettwertgutschrift
Then field "remge" from editor "1RE001" in row 1 has value "-10"
Then field "ofwert" from editor "1RE001" in row 1 has value "-100.00"

# Weitere Wertgutschrift nach Komplettgutschrift nicht moeglich
Given opening an editor from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE001" throws the exception "2620"

Given I open an editor "1AU001" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1LS001" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "1LS001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1RE001" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1RE001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1WG001" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1WG001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - Fakturierung ueber den Lieferschein. Komplettwertgutschrift buchen; fakturierbarer Vorgang wieder offen
# ----------------------------------------------------------------------------------------------

Given I open an editor "1WG001" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "1WG001"
And I set field "ueb" to "ja"
And I save the current editor

# Pruefen von remge und ofwert in Rechnung nach Buchen der Komplettwertgutschrift
Then field "remge" from editor "1RE001" in row 1 has value "0"
Then field "ofwert" from editor "1RE001" in row 1 has value "0.00"

Given I open an editor "1AU001" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1LS001" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "1LS001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1RE001" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1RE001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1WG001" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1WG001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - Fakturierung ueber den Lieferschein. Korrekturrechnung erstellen und buchen
# ----------------------------------------------------------------------------------------------

# Korrekturrechnung
Given I open an editor "2RE001" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS001"
And I set fields
   | nummer | 2RE001  |
   | such   | RE001-2 |
   | ueb    | ja      |
   | tterm  | .       |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "1AU001" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1LS001" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "1LS001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1RE001" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1RE001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1WG001" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1WG001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "2RE001" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "2RE001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - Fakturierung ueber den Auftrag. Komplettwertgutschrift wird gebucht; fakturierbarer Vorgang wieder offen
# ----------------------------------------------------------------------------------------------

# AU  --------------------------  LS  (buchen)
# 10 St.                          10 St.
# | Aktion | remge  | ablage |    | Aktion | remge  | ablage |
# |        | 10 St. |  nein  |    |        |  0 St. |  ja    |
# | (1)    |  0 St. |  ja    |
# | (2)    | 10 St. |  nein  |
#  \
#   \
#    \--------------------------  RE (buchen) ----------- RE (WGS 100%)
#                                 10 St. (1!)             -10 St. (2! buchen)
#                                 | Aktion | remge    |   | Aktion | remge  |
#                                 | (1)    |  -10 St. |   | (2)    |  0 St. |
#                                 | (2)    |    0 St. |

# Auftrag
Given I open an editor "1AU002" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU002   |
   | kunde   | 1        |
   | such    | AU002    |
And I append rows
   | artikel | mge | preis |
   | V1      | 10  | 10    |
And I save the current editor

# Lieferschein
Given I open an editor "1LS002" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU002"
And I set fields
   | nummer | 1LS002  |
   | such   | LS002   |
   | ueb    | ja      |
   | vom    | .       |
   | fakt   | nein    |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE002" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU002"
And I set fields
   | nummer | 1RE002  |
   | such   | RE002   |
   | ueb    | ja      |
   | tterm  | .       |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefen von remge und ofwert in Rechnung vor Buchen der Komplettwertgutschrift
Then field "remge" from editor "1RE002" in row 1 has value "-10"
Then field "ofwert" from editor "1RE002" in row 1 has value "-100.00"

# Wertgutschrift
Given I open an editor "1WG002" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE002"
And I set fields
   | nummer | 1WG002  |
   | such   | WG002   |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-10" in row 1
And I save the current editor

# Pruefen von remge und ofwert in Rechnung nach Buchen der Komplettwertgutschrift
Then field "remge" from editor "1RE002" in row 1 has value "0"
Then field "ofwert" from editor "1RE002" in row 1 has value "0.00"

Given I open an editor "1AU002" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1LS002" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "1LS002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1RE002" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1RE002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1WG002" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1WG002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - Fakturierung ueber den Auftrag. Korrekturrechnung erstellen und buchen
# ----------------------------------------------------------------------------------------------

# Korrekturrechnung
Given I open an editor "2RE002" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU002"
And I set fields
   | nummer | 2RE002  |
   | such   | RE002-2 |
   | ueb    | ja      |
   | tterm  | .       |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "1AU002" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1LS002" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "1LS002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1RE002" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1RE002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1WG002" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1WG002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "2RE002" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "2RE002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK-Wertgut-01: Bestellung, RE mit LB, Wertgutschrift erstellen
# ----------------------------------------------------------------------------------------------

Given I open an editor "BE-01" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
| lief   | 001   |
| nummer | 01BE  |
| such   | BE-01 |
| ebeleg | BE-01 |
| tterm  | .     |
| budat  | .     |
And I append rows
| artikel | mge | preis |
| !TE007  |  8  | 11.50 |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "LS-01VK" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE-01"
And I set fields
 | such   | LS-01VK |
 | nummer | 01VKLS  |
 | ebeleg | LS-01VK |
 | ueb    | ja      |
 | vom    | .       |
And I set field "mge" to "3" in row 1
And I save the current editor

# Rechnung mit LB - ungebucht
Given I open an editor "RE-ZU-BE01" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "01BE"
And I set fields
   | nummer | 01EKRE     |
   | ebeleg | RE-LB-01BE |
   | such   | RE-01BE    |
   | ueb    | nein       |
   | vom    | .          |
   | tterm  | .          |
   | fakt   | ja         |
And I set field "mge" to "6" in row 1
And I set field "preis" to "11.40" in row 1
# AU/BE Position
And I create a new row at position 2
And I set field "artex" to "a." in row 2
And I set field "mge" to "2" in row 2
And I set field "preis" to "2" in row 2
# Dienstleistung
And I create a new row at position 3
And I set field "artex" to "DL-HANALYSE" in row 3
And I set field "mge" to "3" in row 3
And I set field "preis" to "3" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift: Rechnung -> Rechnung
Given I open an editor "WERT-ZU-BE01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# Aus einer ungebuchten Rechnung darf keine Wertgutschrift entstehen
Then setting field "beleg" to "01EKRE" throws the exception "4615"
And I close the current editor

# Rechnung 01EKRE buchen
Given I open an editor "RE-ZU-BE01" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE-ZU-BE01"
And I set fields
   | ueb    | ja         |
And I save the current editor

# Wertgutschrift: Rechnung -> Rechnung
Given I open an editor "WERT-ZU-BE01" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-ZU-BE01"
And I set fields
   | nummer | 01WERT     |
   | such   | EK-WERT01  |
   | tterm  | .          |
   | budat  | .          |
   | vom    | .          |
Then the table has 6 rows
Then field "preis" has value "11.40" in row 1
Then field "mge" has value "0" in row 1
Then field "pwert" has value "0.00" in row 1
Then field "fixpwert" has value "ja" in row 1
Then field "rabmge" has value "0" in row 1
Then field "proz" has value "0" in row 1
Then field "herkunft" has value "" in row 1
Then field "ofmge" has value "-6" in row 1
And I set field "mge" to "-6" in row 1
And I set field "preis" to "1" in row 1
Then field "fixpwert" is not modifiable in row 1
Then field "fixpwert" is not modifiable in row 2
Then field "fixpwert" is not modifiable in row 3
Then field "lehe" is not modifiable in row 1
Then field "lehe" is not modifiable in row 2
Then field "lehe" is not modifiable in row 3
Then field "pehe" is not modifiable in row 1
Then field "pehe" is not modifiable in row 2
Then field "pehe" is not modifiable in row 3
Then field "zrahmen" is not modifiable in row 1
Then field "zrahmen" is not modifiable in row 2
Then field "zrahmen" is not modifiable in row 3
Then field "zignrahmen" is not modifiable in row 1
Then field "zignrahmen" is not modifiable in row 2
Then field "zignrahmen" is not modifiable in row 3
Then field "treart" has value "Kaufmännische Gutschrift" in row 1
Then field "tlsart" has value "" in row 1
Then field "vorganga" has value "Kaufmännische Gutschrift"
# Nur gebuchte Rechnungen duerfen angefuegt werden
Then setting field "beleg" to "01VKLS" throws the exception "4615"
And I save the current editor

# Rechnung kann nicht storniert werden, da Wertgutschrift vorhanden ist
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE-ZU-BE01" throws the exception "6729"

# Ist eine Wertgutschrift gesperrt, darf sie nicht gebucht werden.
Given I open an editor "WERT-ZU-BE01" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "WERT-ZU-BE01"
And I set fields
   | ueb     | ja |
   | vsperre | ja |
# Der Vorgang ist gesperrt und darf deswegen nicht gebucht werden.
Then saving the current editor throws the exception "2525"
And I close the current editor

Given I open an editor "WERT-ZU-BE01" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "WERT-ZU-BE01"
And I set fields
   | ueb    | ja         |
# Preis in der Wertgutschrift darf nicht hoeher sein als der Preis in der Rechnungsposition
Then setting field "preis" to "33" in row 1 throws the exception "11063"
And I close the current editor

# nur damit das spaeter bei Jahresabschluss nicht stoert.
Given I open an editor "gutbuch1" from table "(Purchasing):(Invoice)" with command "TRANSFER" for record "EK-WERT01"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK-Wertgut-03: Rechnung mit verschiedenen Positionen anlegen
# ----------------------------------------------------------------------------------------------

Given I open an editor "ekrechnung03" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "nummer" to "03EKRE"
And I set field "ebeleg" to "RE-LB-03"
And I set field "such" to "RE-EK03"
And I set field "ueb" to "ja"
And I set field "tterm" to "."
And I set field "vom" to "."
And I set field "ebeleg" to "WG"
And I append rows
	| artex    | mge         | proz        | pwert       | preis       |
	| e2       | 10          | -5          | !dontChange | !dontChange | # Artikel
	| 4        | !dontChange | -10         | !dontChange | !dontChange | # Gesamtrabatt
	| text     | !dontChange | !dontChange | 10          | !dontChange | # Text
	| NEUPOS   | !dontChange | !dontChange | 15          | !dontChange | # Neutrale Position
	| dl-repar | 1           | !dontChange | !dontChange | !dontChange | # Dienstleistung
	| 5        | !dontChange | !dontChange | !dontChange | 100         | # Mindestbestellwert
	| 3        | !dontChange | !dontChange | !dontChange | !dontChange | # Zwischensumme
	| 4        | !dontChange | -20         | !dontChange | !dontChange | # Gesamtrabatt
	| a.       | 5           | !dontChange | !dontChange | 6           | # AU/BE Position
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" has value "-10" in row 1
Then field "ofwert" has value "-304.00" in row 1
Then field "remge" has value "0" in row 2
Then field "ofwert" has value "30.40" in row 2
Then field "remge" has value "-10" in row 3
Then field "ofwert" has value "-10.00" in row 3
Then field "remge" has value "-15" in row 4
Then field "ofwert" has value "-15.00" in row 4
Then field "remge" has value "-1" in row 5
Then field "ofwert" has value "-70.00" in row 5
Then field "remge" has value "0" in row 6
Then field "ofwert" has value "-30.00" in row 6
Then field "remge" has value "0" in row 7
Then field "ofwert" has value "0.00" in row 7
Then field "remge" has value "0" in row 8
Then field "ofwert" has value "79.72" in row 8
Then field "remge" has value "-5" in row 9
Then field "ofwert" has value "-30.00" in row 9
Then field "remge" has value "0" in row 10
Then field "ofwert" has value "0.00" in row 10
Then field "remge" has value "0" in row 11
Then field "ofwert" has value "0.00" in row 11
Then field "remge" has value "0" in row 12
Then field "ofwert" has value "0.00" in row 12

# Wertgutschrift: alle Positionen ausser den Rechnungsabschlusspositionen uebernehmen
Given I open an editor "WERT-ZU-EKRE03" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "ekrechnung03"
Then the table has 12 rows
# Versand - EDI
Then field "ident" is modifiable
And I close the current editor

# Rechnung stornieren
Given I open an editor "restorno03" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "ekrechnung03"
And I set field "num4" to "03EKRES"
And I save the current editor

# Stornierte Rechnung pruefen
Given I open an editor "ekrechv03" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "ekrechnung03"
Then field "remge" has value "0" in row 1
Then field "ofwert" has value "0.00" in row 1
And I close the current editor

# Storno-Rechnung pruefen
Given I open an editor "ekstornorechv03" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "restorno03"
Then field "remge" has value "0" in row 1
Then field "ofwert" has value "0.00" in row 1
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK-Wertgut-04: Anzahlungsrechnung
# ----------------------------------------------------------------------------------------------

#Bestellung anlegen
Given I open an editor "bestellung04" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1       |
   | nummer | 04EKBE  |
   | such   | BE-04   |
   | ebeleg | BE-04   |
And I append rows
   | artex | mge |
   | e2    | 10  |
And I save the current editor

#Fakturaplan anlegen
Given I open an editor "ekfakturaplan" from table "(BillingPlan):(BillingPlan)" with command "NEW" for record ""
And I set field "evvorgang" to id from editor "bestellung04"
And I set field "namebspr" to "Fakturaplan zu Bestellung"
And I append rows
	| reart     | proz | ptext        | zbed |
	| Anzahlung | 20   | 1. Anzahlung | 203  |

#Anzahlungsrechnung anlegen
And I press button "anzahlungsrechn" to open a subeditor for "fakturaplan_be" in row 1
And I set fields
   | nummer | 04EKRE  |
   | such   | RE-EK04 |
   | ueb    | ja      |
   | vom    | .       |
   | ebeleg | anz     |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "ekfakturaplan"
And I save the current editor

#Anzahlungsrechnung pruefen
Given I open an editor "ekanzrech" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "fakturaplan_be"
Then field "remge" has value "-64" in row 1
Then field "ofwert" has value "-64.00" in row 1
Then field "remge" has value "0" in row 2
Then field "ofwert" has value "0.00" in row 2
Then field "remge" has value "0" in row 3
Then field "ofwert" has value "0.00" in row 3
Then field "remge" has value "0" in row 4
Then field "ofwert" has value "0.00" in row 4
And I close the current editor

# Anzahlungsrechnung stornieren
Given I open an editor "ekstornoanzre" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "fakturaplan_be"
And I set field "num4" to "04EKRES"
And I save the current editor

#Stornierte Anzahlungsrechnung pruefen
Given I open an editor "ekanzrechv" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "fakturaplan_be"
Then field "remge" has value "0" in row 1
Then field "ofwert" has value "0.00" in row 1
And I close the current editor

#Storno-Anzahlungsrechnung pruefen
Given I open an editor "ekstornoanzrechv" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "ekstornoanzre"
Then field "remge" has value "0" in row 1
Then field "ofwert" has value "0.00" in row 1
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Hinweismeldung wenn offene Menge positiv RE+LB, WG
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE06" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| kunde        | 1      |
	| such         | RE06   |
	| ueb          | ja     |
	| tterm        | .      |
	| vom          | .      |
	| fakt         | ja     |
And I append rows
	| artikel      | mge    | preis |
	| V1           | 4      | 20    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "WG06" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE06"
And I set fields
   | such   | WG06       |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
Then field "preis" has value "20.00" in row 1
Then field "mge" has value "0" in row 1
Then field "ofmge" has value "-4" in row 1
And I set field "mge" to "-3" in row 1
Then field "ofmge" has value "-1" in row 1
# Gutgeschriebene Menge zu hoch
Then setting field "mge" to "-5" in row 1 throws the exception "2022"
# Positive Menge bei Gutschriftpositionen nicht erlaubt
Then setting field "mge" to "1" in row 1 throws the exception "2024"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Hinweismeldung wenn offene Menge positiv AU, LS Teil, RE Teil, WG
# ----------------------------------------------------------------------------------------------

Given I open an editor "AU07" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| kunde        | 1      |
	| such         | AU07   |
	| vom          | .      |
And I append rows
	| artikel      | mge    | preis |
	| V1           | 5      | 25    |
And I save the current editor

Given I open an editor "LS07" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU07"
And I set fields
   | such   | LS07       |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
And I set field "mge" to "4" in row 1
And I save the current editor

Given I open an editor "RE07" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS07"
And I set fields
   | such   | WRE07      |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
And I set field "mge" to "3" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "WG07" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE07"
And I set fields
   | such   | WG07       |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
Then field "preis" has value "25.00" in row 1
Then field "ofmge" has value "-3" in row 1
# Gutgeschriebene Menge zu hoch
Then setting field "mge" to "-4" in row 1 throws the exception "2022"
# Positive Menge bei Gutschriftpositionen nicht erlaubt
Then setting field "mge" to "1" in row 1 throws the exception "2024"
And I set field "mge" to "-2" in row 1
Then field "ofmge" has value "-1" in row 1
Then field "wertgutschrift" has value "ja"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Hinweismeldung wenn offene Menge positiv AU, LS Teil, RE aus AU Teil, WG
# ----------------------------------------------------------------------------------------------

Given I open an editor "AU08" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| kunde        | 1      |
	| such         | AU08   |
	| vom          | .      |
And I append rows
	| artikel      | mge    | preis |
	| V1           | 5      | 25    |
And I save the current editor

Given I open an editor "LS08" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU08"
And I set fields
   | such   | LS08       |
   | ueb    | ja         |
   | fakt   | nein       |
   | tterm  | .          |
   | budat  | .          |
And I set field "mge" to "2" in row 1
And I save the current editor

Given I open an editor "RE08" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU08"
And I set fields
   | such   | RE08       |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
And I set field "mge" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "WG08" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE08"
And I set fields
   | such   | WG08       |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
Then field "preis" has value "25.00" in row 1
Then field "ofmge" has value "-4" in row 1
# Gutgeschriebene Menge zu hoch
Then setting field "mge" to "-5" in row 1 throws the exception "2022"
# Positive Menge bei Gutschriftpositionen nicht erlaubt
Then setting field "mge" to "1" in row 1 throws the exception "2024"
And I set field "mge" to "-4" in row 1
Then field "ofmge" has value "0" in row 1
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Hinweismeldung wenn offene Menge positiv AU, Teil LS, Teil RLS, RE aus AU Teil, WG
# ----------------------------------------------------------------------------------------------

# AU09  --------> LS09 Teil--> RLS09
# 30 St.      \   10 St.       6 St.
#   \          \
#    \          -------------------> LS09B Teil --> RLS09B
#     \                              8 St.          5 St.
#      \
#       -->  RE09 Teil ---------------------------------------> WG09 Teil
#            22 St.                                             11 St.

Given I open an editor "AU09" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| kunde        | 1      |
	| such         | AU09   |
	| vom          | .      |
And I append rows
	| artikel      | mge    | preis |
	| V1           | 30     | 20    |
And I save the current editor

Given I open an editor "RE09" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU09"
And I set fields
   | such   | RE09       |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
   | fakt   | nein       |
And I set field "mge" to "22" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "LS09" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU09"
And I set fields
   | such   | LS09       |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "RLS09" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS09"
And I set fields
   | such   | RLS09      |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
And I set field "mge" to "-6" in row 1
And I save the current editor

Given I open an editor "LS09B" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU09"
And I set fields
   | such   | LS09B      |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
And I set field "mge" to "8" in row 1
And I save the current editor

Given I open an editor "RLS09B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS09B"
And I set fields
   | such   | RLS09B     |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
And I set field "mge" to "-5" in row 1
And I save the current editor

Given I open an editor "WG09" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE09"
And I set fields
   | such   | WG09       |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
Then field "wertgutschrift" has value "ja"
Then field "twertgutschrift" has value "ja" in row 1
Then field "preis" has value "20.00" in row 1
# Ruecklieferungen werden beruecksichtigt. Es kann nicht mehr die volle Mengen gutgeschrieben werden.
Then field "ofmge" has value "-11" in row 1
# Gutgeschriebene Menge zu hoch
Then setting field "mge" to "-23" in row 1 throws the exception "2022"
# Positive Menge bei Gutschriftpositionen nicht erlaubt
Then setting field "mge" to "1" in row 1 throws the exception "2024"
And I set field "mge" to "-11" in row 1
Then field "ofmge" has value "0" in row 1
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Komplette gebuchte Wertgutschrift erstellen
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE10" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| kunde        | 1      |
	| such         | RE10   |
	| ueb          | nein   |
	| tterm        | .      |
	| vom          | .      |
	| fakt         | ja     |
And I append rows
	| artikel | mge         | preis       | proz  |
	| E1      | 12          | 20          |   0   |
	| V1      | 10          | 25          | -10   |
	| PR.     | !dontChange | !dontChange |  -1   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Button ist in Rechnung schreibgeschuetzt
# Rechnung buchen
Given I open an editor "RE10" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE10"
Then field "komplettieren" is not modifiable
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "WG10" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE10"
And I set fields
   | such   | WG10       |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
And I press button "komplettieren"
Then field "preis" has value "20.00" in row 1
Then field "mge" has value "-12" in row 1
Then field "pwert" has value "-240.00" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
Then field "preis" has value "25.00" in row 2
Then field "mge" has value "-10" in row 2
Then field "proz" has value "-10" in row 2
Then field "pwert" has value "-225.00" in row 2
Then field "komplettgutschrift" has value "ja" in row 2
Then field "pwert" is not modifiable in row 3
Then field "fixpwert" is not modifiable in row 3
Then field "proz" is not modifiable in row 3
And I save the current editor

Then field "remge" from editor "RE10" in row 1 has value "12"
Then field "remge" from editor "RE10" in row 2 has value "10"
Then field "rekorrektur" from editor "RE10" in row 1 has value "ja"
Then field "rekorrektur" from editor "RE10" in row 2 has value "ja"

# Weitere Wertgutschrift nach Komplettgutschrift nicht moeglich
# Given opening an editor from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE10" throws the exception "2620"


# ----------------------------------------------------------------------------------------------
Scenario: Komplette Wertgutschrift erstellen und dann aendern
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE11" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| kunde        | 1      |
	| such         | RE11   |
	| ueb          | ja     |
	| tterm        | .      |
	| vom          | .      |
	| fakt         | ja     |
And I append rows
	| artikel      | mge         | preis       | proz |
	| E3           | 10          | 20          |   0  |
	| V1           | 20          | 25          |  -5  |
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row 3
And I set field "pwert" to "125" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "WG11" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE11"
And I set fields
   | such   | WG11       |
   | ueb    | nein       |
   | tterm  | .          |
   | budat  | .          |
Then field "wertgutschrift" has value "ja"
Then field "twertgutschrift" has value "ja" in row 1
Then field "twertgutschrift" has value "ja" in row 2
And I press button "komplettieren"
Then field "preis" has value "20.00" in row 1
Then field "mge" has value "-10" in row 1
Then field "pwert" has value "-200.00" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
Then field "preis" has value "25.00" in row 2
Then field "mge" has value "-20" in row 2
Then field "proz" has value "-5" in row 2
Then field "pwert" has value "-475.00" in row 2
Then field "komplettgutschrift" has value "ja" in row 2
And I set field "mge" to "-8" in row 1
Then field "komplettgutschrift" has value "nein" in row 1
And I set field "preis" to "15" in row 2
And I set field "pwert" to "-460.00" in row 2
Then field "komplettgutschrift" has value "nein" in row 2
And I set field "mge" to "-10" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
And I set field "mge" to "-8" in row 1
And I set field "preis" to "20" in row 1
And I set field "mge" to "-10" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
And I set field "preis" to "9" in row 1
Then field "komplettgutschrift" has value "nein" in row 1
And I set field "preis" to "20" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
And I set field "mge" to "0" in row 1
Then field "komplettgutschrift" has value "nein" in row 1
And I set field "mge" to "-10" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
And I set field "pwert" to "0" in row 1
Then field "pwert" has value "-200.00" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
And I set field "pwert" to "-200.00" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
And I set field "pwert" to "-100" in row 3
Then field "komplettgutschrift" has value "nein" in row 3
And I set field "pwert" to "-125.00" in row 3
Then field "komplettgutschrift" has value "ja" in row 3
And I save the current editor

Given I open an editor "WG11U" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "WG11"
And I press button "komplettieren"
And I save the current editor

# Aenderbarkeit der Felder pruefen
Given I open an editor "WG11S" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "WG11"
# Schreibbar Kopf
Then field "such" is modifiable
Then field "nummer" is modifiable
Then field "vom" is modifiable
Then field "budat" is modifiable
Then field "bukenn" is modifiable
Then field "butext" is modifiable
Then field "zbed" is modifiable
Then field "vrgstrgl" is modifiable
Then field "kenn" is modifiable
Then field "bem" is modifiable
Then field "betreff" is modifiable
Then field "ftext" is modifiable
Then field "atext" is modifiable
Then field "batext" is modifiable
Then field "baktext" is modifiable
Then field "baftext" is modifiable
Then field "stext" is modifiable
Then field "bstext" is modifiable
Then field "bsktext" is modifiable
Then field "bsftext" is modifiable
Then field "zbedschl" is modifiable
Then field "emailftext" is modifiable
Then field "emailtext" is modifiable
Then field "komplettieren" is modifiable
Then field "ueb" is modifiable
Then field "tterm" is modifiable
Then field "beleg" is modifiable
Then field "vorganga" is modifiable
Then field "frzeich" is modifiable
Then field "navom" is modifiable
Then field "zeich" is modifiable
Then field "druck" is modifiable
Then field "kopien" is modifiable
Then field "betreuer" is modifiable
Then field "pbed" is modifiable
Then field "gewaehr" is modifiable
Then field "rechturnus" is modifiable
Then field "erechok" is modifiable
Then field "erechmail" is modifiable
Then field "ans" is modifiable
Then field "ans2" is modifiable
Then field "str" is modifiable
Then field "str2" is modifiable
Then field "plz" is modifiable
Then field "plz2" is modifiable
Then field "nort" is modifiable
Then field "nort2" is modifiable
Then field "region" is modifiable
Then field "region2" is modifiable
Then field "staat" is modifiable
Then field "staat2" is modifiable
Then field "tele" is modifiable
Then field "tele2" is modifiable
Then field "mtele" is modifiable
Then field "mtele2" is modifiable
Then field "anrufen" is modifiable
Then field "anrufen2" is modifiable
Then field "manrufen" is modifiable
Then field "manrufen2" is modifiable
Then field "fax" is modifiable
Then field "fax2" is modifiable
Then field "email" is modifiable
Then field "email2" is modifiable
Then field "mailto" is modifiable
Then field "mailto2" is modifiable
# Schreibgeschuetzt Kopf
Then field "ewekurs" is not modifiable
# Schreibbar Position
Then field "mge" is modifiable in row 1
Then field "preis" is modifiable in row 1
Then field "pwert" is modifiable in row 1
Then field "konto" is modifiable in row 1
Then field "strgl" is modifiable in row 1
Then field "offueb" is modifiable in row 1
Then field "ptext" is modifiable in row 1
Then field "pftext" is modifiable in row 1
And I close the current editor

# Konfigurationskenner Materialkostenverbuchung muss gesetzt sein
Given I open an editor "konfig" from table "(Company):(Configuration)" with command "VIEW" for record "KONFIG"
Then field "bew" has value "ja"
And I close the current editor

Given I open an editor "WG11S" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "WG11"
Then field "fixvrgstrgl" is modifiable
Then field "rechnustid" is modifiable
Then field "versustid" is modifiable
Then field "vstaat" is modifiable
Then field "klsteunr" is modifiable
Then field "datevbel" is modifiable
Then field "konto" is modifiable in row 1
Then field "kstelle" is modifiable in row 1
Then field "fixkonto" is modifiable in row 1
Then field "fixstrgl" is modifiable in row 1
Then field "fixkstelle" is modifiable in row 1
And I close the current editor

# wegbuchen damit das spaeter bei Jahresabschluss nicht stoert. buchung ggf. auch spaeter vor Jahresabschluss moeglich
Given I open an editor "rechbuch" from table "(Sales):(Invoice)" with command "TRANSFER" for record "WG11"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Komplette Wertgutschrift im Einkauf erstellen
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE12" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
	| lief    | 1     |
	| such    | RE12  |
	| ebeleg  | RE-12 |
	| ueb     | ja    |
	| tterm   | .     |
	| vom     | .     |
	| fakt    | ja    |
And I append rows
	| artikel | mge         | preis       | proz        |
	| E1      | 4           | 10          | !dontChange |
	| ZS.     | !dontChange | !dontChange | !dontChange |
	| V3      | 3           | 50          | !dontChange |
	| SU.     | !dontChange | !dontChange | !dontChange |
	| PR.     | !dontChange | !dontChange | -1          |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "WG12" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE12"
And I set fields
    | such   | WG12       |
	| ebeleg | WG-12      |
	| ueb    | nein       |
	| tterm  | .          |
	| vom    | .          |
	| budat  | .          |
Then the table has 8 rows
Then field "wertgutschrift" has value "ja"
Then field "twertgutschrift" has value "ja" in row 1
Then field "twertgutschrift" has value "ja" in row 2
And I press button "komplettieren"
Then field "preis" has value "10.00" in row 1
Then field "mge" has value "-4" in row 1
Then field "pwert" has value "-40.00" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
Then field "artex" has value "ZS." in row 2
Then field "preis" has value "50.00" in row 3
Then field "mge" has value "-3" in row 3
Then field "pwert" has value "-150.00" in row 3
Then field "komplettgutschrift" has value "ja" in row 3
Then field "artex" has value "SU." in row 4
Then field "artex" has value "PR." in row 5
Then field "pwert" is not modifiable in row 5
Then field "proz" is not modifiable in row 5
And I save the current editor

# Aenderbarkeit der Felder pruefen
Given I open an editor "WG12S" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "WG12"
# Schreibbar Kopf
Then field "such" is modifiable
Then field "nummer" is modifiable
Then field "vom" is modifiable
Then field "budat" is modifiable
Then field "bukenn" is modifiable
Then field "butext" is modifiable
Then field "zbed" is modifiable
Then field "vrgstrgl" is modifiable
Then field "kenn" is modifiable
Then field "bem" is modifiable
Then field "betreff" is modifiable
Then field "ftext" is modifiable
Then field "atext" is modifiable
Then field "batext" is modifiable
Then field "baktext" is modifiable
Then field "baftext" is modifiable
Then field "stext" is modifiable
Then field "bstext" is modifiable
Then field "bsktext" is modifiable
Then field "bsftext" is modifiable
Then field "zbedschl" is modifiable
Then field "anlagen" is modifiable
Then field "komplettieren" is modifiable
Then field "ueb" is modifiable
Then field "tterm" is modifiable
Then field "beleg" is modifiable
Then field "vorganga" is modifiable
Then field "frzeich" is modifiable
Then field "navom" is modifiable
Then field "zeich" is modifiable
# Schreibbar Position
Then field "mge" is modifiable in row 3
Then field "preis" is modifiable in row 3
Then field "pwert" is modifiable in row 3
Then field "strgl" is modifiable in row 3
Then field "offueb" is modifiable in row 3
Then field "ptext" is modifiable in row 3
Then field "pftext" is modifiable in row 3
And I close the current editor

# Konfigurationskenner Materialkostenverbuchung ist gesetzt.
Given I open an editor "konfig" from table "(Company):(Configuration)" with command "VIEW" for record "KONFIG"
Then field "bew" has value "ja"
And I close the current editor

# Aenderbarkeit der Felder pruefen
Given I open an editor "WG12S" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "WG12"
Then field "fixvrgstrgl" is modifiable
Then field "rechnustid" is modifiable
Then field "versustid" is modifiable
Then field "vstaat" is modifiable
Then field "klsteunr" is modifiable
Then field "datevbel" is modifiable
Then field "konto" is not modifiable in row 3
Then field "kstelle" is not modifiable in row 3
Then field "fixkonto" is not modifiable in row 3
Then field "fixstrgl" is modifiable in row 3
Then field "fixkstelle" is not modifiable in row 3
And I close the current editor

# nur damit das spaeter bei Jahresabschluss nicht stoert, noch wegbuchen. ggf. auch spaeter moeglich..
Given I open an editor "gutbuch2" from table "(Purchasing):(Invoice)" with command "TRANSFER" for record "WG12"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK - Wertgutschrift erstellen und anschliessend buchen, evre in Rechnung pruefen
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE13" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
	| lief         | 1      |
	| such         | RE13   |
	| ebeleg       | RE-13  |
	| ueb          | ja     |
	| tterm        | .      |
	| vom          | .      |
	| fakt         | ja     |
And I append rows
	| artikel      | mge    | preis |
	| EINK         | 25     | 7     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "WG13" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE13"
And I set fields
	| such   | WG13       |
	| ebeleg | WG-13      |
	| ueb    | nein       |
	| tterm  | .          |
	| vom    | .          |
	| budat  | .          |
Then field "wertgutschrift" has value "ja"
Then field "twertgutschrift" has value "ja" in row 1
And I press button "offueb" in row 1
Then field "preis" has value "7.00" in row 1
Then field "mge" has value "-25" in row 1
Then field "pwert" has value "-175.00" in row 1
And I save the current editor

# Ungebuchte WGS in Rechnung RE13 pruefen
Given I open an editor "RE13P" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE13"
Then field "re" has value "1" in row 1
Then field "remge" has value "-25" in row 1
Then field "offfolgepos" has value "1"
And I close the current editor
# WGS buchen
Given I open an editor "WG13B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "WG13"
And I set field "ueb" to "ja"
And I save the current editor

# Keine ungebuchte WGS zu Rechnung RE13
Given I open an editor "RE13P2" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE13"
Then field "re" has value "0" in row 1
Then field "remge" has value "25" in row 1
Then field "offfolgepos" has value "0"
# Rechnungskorrektur fuer Zeile 1 moeglich
Then field "rekorrektur" has value "ja" in row 1
And I close the current editor

# Kennzeichen Rechnungskorrektur wird nicht kopiert
Given I open an editor "RE13C" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "RE13"
Then field "rekorrektur" has value "nein" in row 1
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - Wertgutschrift erstellen und anschliessend buchen, evre in Rechnung pruefen
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE14" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| kunde        | 1      |
	| such         | RE14   |
	| ueb          | ja     |
	| tterm        | .      |
	| vom          | .      |
	| fakt         | ja     |
And I append rows
	| artikel      | mge    | preis |
	| EINK         | 5      | 19    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "WG14" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE14"
And I set fields
	| such   | WG14       |
	| ueb    | nein       |
	| tterm  | .          |
	| vom    | .          |
	| budat  | .          |
Then field "wertgutschrift" has value "ja"
Then field "twertgutschrift" has value "ja" in row 1
And I press button "offueb" in row 1
Then field "preis" has value "19.00" in row 1
Then field "mge" has value "-5" in row 1
Then field "pwert" has value "-95.00" in row 1
And I save the current editor

# Ungebuchte WGS in Rechnung RE14 pruefen
Given I open an editor "RE14P" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE14"
Then field "re" has value "1" in row 1
Then field "offfolgepos" has value "1"
Then field "remge" has value "-5" in row 1
And I close the current editor

Given I open an editor "WG14B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "WG14"
And I set field "ueb" to "ja"
And I save the current editor

# Keine ungebuchte WGS zu Rechnung RE14
Given I open an editor "RE14P2" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE14"
Then field "re" has value "0" in row 1
Then field "remge" has value "5" in row 1
Then field "offfolgepos" has value "0"
# Rechnungskorrektur fuer Zeile 1 moeglich
Then field "rekorrektur" has value "ja" in row 1
And I close the current editor

# Kennzeichen Rechnungskorrektur wird nicht kopiert
Given I open an editor "RE14C" from table "(Sales):(Invoice)" with command "COPY" for record from editor "RE14"
Then field "rekorrektur" has value "nein" in row 1
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - Wertgutschrift mit 2 Zeilen erstellen und 1 Zeile loeschen, evre und evoffolgepos in Rechnung pruefen
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE15" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| kunde        | 1      |
	| such         | RE15   |
	| ueb          | ja     |
	| tterm        | .      |
	| vom          | .      |
	| fakt         | ja     |
And I append rows
	| artikel      | mge    | preis |
	| EINK         | 5      | 19    |
	| E1           | 10     | 5     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "WG15" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE15"
And I set fields
	| such   | WG15       |
	| ueb    | nein       |
	| tterm  | .          |
	| vom    | .          |
	| budat  | .          |
And I press button "komplettieren"
Then field "pwert" has value "-95.00" in row 1
Then field "pwert" has value "-50.00" in row 2
And I save the current editor

# Ungebuchte WGS in Rechnung RE15 pruefen
Given I open an editor "RE15P" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE15"
Then field "re" has value "1" in row 1
Then field "re" has value "1" in row 2
Then field "offfolgepos" has value "2"
And I close the current editor

Given I open an editor "WG15B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "WG15"
And I delete row at position 2
And I save the current editor

# Eine ungebuchte WGS-Position zu Rechnung RE15
Given I open an editor "RE15P2" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE15"
Then field "re" has value "1" in row 1
Then field "re" has value "0" in row 2
Then field "offfolgepos" has value "1"
And I close the current editor


# wegbuchen damit das spaeter bei Jahresabschluss nicht stoert. buchung ggf. auch spaeter vor Jahresabschluss moeglich
Given I open an editor "rechbuch" from table "(Sales):(Invoice)" with command "TRANSFER" for record "WG15"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK - Fakturierung ueber den Lieferschein. Komplettwertgutschrift zu Rechnung anlegen
# ----------------------------------------------------------------------------------------------

# BE  -------------------------  LS  (buchen)------------------ RE (buchen) ----------- RE (WGS 100%)
# 10 St.                         10 St.                         10 St. (1!)             -10 St. (2! buchen)
# | Aktion | remge  | ablage |   | Aktion | remge  | ablage |   | Aktion | remge   |    | Aktion | remge  |
# |        |  0 St. |  ja    |   |        | 10 St. |  nein  |   | (1)    | -10 St. |    | (2)    |  0 St. |
#                                | (1)    |  0 St. |  ja    |   | (2)    |   0 St. |
#                                | (2)    | 10 St. |  nein  |

# Bestellung
Given I open an editor "1BE001" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE001   |
   | lief    | 1        |
   | such    | BE001    |
And I append rows
   | artikel | mge | preis |
   | E2      | 10  | 10    |
And I save the current editor

# Lieferschein
Given I open an editor "1LS001" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE001"
And I set fields
   | nummer | 1LS001  |
   | such   | LS001   |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS001"
And I set fields
   | nummer | 1RE001  |
   | such   | RE001   |
   | ueb    | ja      |
   | vom    | .       |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "1WG001" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE001"
And I set fields
   | nummer | 1WG001  |
   | such   | WG001   |
   | ueb    | nein    |
   | vom    | .       |
And I set field "mge" to "-10" in row 1
And I save the current editor

Given I open an editor "1BE001" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1LS001" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS001"
# Rechnungskorrektur fuer Lieferposition erst nach Buchen der Wertgutschrift moeglich
Then field "rekorrektur" has value "nein" in row 1
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1RE001" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "1RE001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1WG001" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "1WG001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK - Fakturierung ueber den Lieferschein. Komplettwertgutschrift buchen; fakturierbarer Vorgang wieder offen
# ----------------------------------------------------------------------------------------------

Given I open an editor "1WG001" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "1WG001"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "1BE001" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1LS001" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
# Rechnungskorrektur fuer Lieferposition moeglich
Then field "rekorrektur" has value "ja" in row 1
And I close the current editor

# Kennzeichen Rechnungskorrektur wird nicht kopiert
Given I open an editor "1LS001C" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "1LS001"
Then field "rekorrektur" has value "nein" in row 1
And I close the current editor

Given I open an editor "1RE001" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "1RE001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1WG001" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "1WG001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK - Fakturierung ueber den Lieferschein. Korrekturrechnung erstellen und buchen
# ----------------------------------------------------------------------------------------------

# Korrekturrechnung
Given I open an editor "2RE001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS001"
And I set fields
   | nummer | 2RE001  |
   | such   | RE001-2 |
   | ueb    | ja      |
   | vom    | .       |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "1BE001" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1LS001" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1RE001" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "1RE001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1WG001" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "1WG001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "2RE001" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "2RE001"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK - Fakturierung ueber die Bestellung. Komplettwertgutschrift wird gebucht; fakturierbarer Vorgang wieder offen
# ----------------------------------------------------------------------------------------------

# BE  --------------------------  LS  (buchen)
# 10 St.                          10 St.
# | Aktion | remge  | ablage |    | Aktion | remge  | ablage |
# |        | 10 St. |  nein  |    |        |  0 St. |  ja    |
# | (1)    |  0 St. |  ja    |
# | (2)    | 10 St. |  nein  |
#  \
#   \
#    \--------------------------  RE (buchen) ----------- RE (WGS 100%)
#                                 10 St. (1!)             -10 St. (2! buchen)
#                                 | Aktion | remge    |   | Aktion | remge  |
#                                 | (1)    |  -10 St. |   | (2)    |  0 St. |
#                                 | (2)    |    0 St. |

# Bestellung
Given I open an editor "1BE002" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE002   |
   | lief    | 1        |
   | such    | BE002    |
And I append rows
   | artikel | mge | preis |
   | E2      | 10  | 10    |
And I save the current editor

# Lieferschein
Given I open an editor "1LS002" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE002"
And I set fields
   | nummer | 1LS002  |
   | such   | LS002   |
   | ueb    | ja      |
   | vom    | .       |
   | fakt   | nein    |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE002"
And I set fields
   | nummer | 1RE002  |
   | such   | RE002   |
   | ueb    | ja      |
   | vom    | .       |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "1WG002" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE002"
And I set fields
   | nummer | 1WG002  |
   | such   | WG002   |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-10" in row 1
And I save the current editor

Given I open an editor "1BE002" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
# Rechnungskorrektur fuer Bestellposition moeglich
Then field "rekorrektur" has value "ja" in row 1
And I close the current editor

# Kennzeichen Rechnungskorrektur wird nicht kopiert
Given I open an editor "1BE002C" from table "(Purchasing):(PurchaseOrder)" with command "COPY" for record from editor "1BE002"
Then field "rekorrektur" has value "nein" in row 1
And I close the current editor

Given I open an editor "1LS002" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1RE002" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "1RE002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1WG002" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "1WG002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK - Fakturierung ueber die Bestellung. Korrekturrechnung erstellen und buchen
# ----------------------------------------------------------------------------------------------

# Korrekturrechnung
Given I open an editor "2RE002" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE002"
And I set fields
   | nummer | 2RE002  |
   | such   | RE002-2 |
   | ueb    | ja      |
   | vom    | .       |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "1BE002" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1LS002" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "1LS002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1RE002" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "1RE002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1WG002" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "1WG002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "2RE002" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "2RE002"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - 100% Wertgutschrift Plausibilitaeten fuer Menge, Preis und Positionswert ueberpruefen
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE16" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| kunde | 1    |
	| such  | RE16 |
	| ueb   | ja   |
	| tterm | .    |
	| vom   | .    |
	| fakt  | ja   |
And I append rows
	| artikel | mge         | preis       | pwert       |
	| V1      | 5           | 20          | !dontChange |
	| TEXT    | !dontChange | !dontChange |  99         |
	| 13      | !dontChange | !dontChange | 111         |
	| DL-HANA | 10          | !dontChange | !dontChange |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "WERT-ZU-RE16" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE16"
And I set fields
   | nummer | 16WERT     |
   | such   | VK-WERT16  |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
Then the table has 7 rows
Then field "preis" has value "20.00" in row 1
And I press button "komplettieren"
# Gutzuschreibender Preis zu hoch.
Then setting field "preis" to "22" in row 1 throws the exception "6758"
# Negative Preise bei Gutschriftpositionen nicht erlaubt.
Then setting field "preis" to "-20" in row 1 throws the exception "131"
And I set field "preis" to "20" in row 1
# Positiver Positionswert bei Gutschriftpositionen nicht erlaubt.
Then setting field "pwert" to "100" in row 1 throws the exception "131"
# Gutzuschreibender Positionswert zu hoch.
Then setting field "pwert" to "-102" in row 1 throws the exception "11241"
# Textposition
Then setting field "pwert" to "100" in row 2 throws the exception "131"
Then setting field "pwert" to "-100" in row 2 throws the exception "11241"
# Neutrale Position
Then setting field "pwert" to "100" in row 3 throws the exception "131"
Then setting field "pwert" to "-112" in row 3 throws the exception "11241"
# Dienstleistung
# Positive Menge bei Gutschriftpositionen nicht erlaubt.
Then setting field "mge" to "10" in row 4 throws the exception "2024"
# Gutzuschreibende Menge zu hoch.
Then setting field "mge" to "-11" in row 4 throws the exception "2022"
Then setting field "preis" to "-20" in row 4 throws the exception "131"
Then setting field "preis" to "220" in row 1 throws the exception "6758"
Then setting field "pwert" to "100" in row 4 throws the exception "131"
Then setting field "pwert" to "-2222" in row 4 throws the exception "11241"
And I save the current editor

# Rechnungskorrektur fuer 1. Position moeglich
Then field "rekorrektur" from editor "RE16" in row 1 has value "ja"


# ----------------------------------------------------------------------------------------------
Scenario: VK - Kopieren einer Wertgutschrift verbieten
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE04-VK-Kunde2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | such   | RE03KU2 |
   | nummer | 03VKRE  |
   | kunde  | 2       |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
And I append rows
   |   artikel   |    mge    |  preis	|
   |     201     |    10     |   100	|
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung wertgutschreiben
Given I open an editor "RE04-VK-Kunde2WGS" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE04-VK-Kunde2"
And I set fields
   | such   | WGSRE03 |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
Then I set field "mge" to "-2" in row 1
And I save the current editor

# Kopieren einer Wertgutschrift ist nicht erlaubt
Then opening an editor from table "(Sales):(Invoice)" with command "COPY" for record from editor "RE04-VK-Kunde2WGS" throws the exception "10323"


# ----------------------------------------------------------------------------------------------
Scenario: VK - Teilwertgutschrift Plausibilitaeten fuer Menge, Preis und Positionswert ueberpruefen
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE17" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| kunde | 1    |
	| such  | RE17 |
	| ueb   | ja   |
	| tterm | .    |
	| vom   | .    |
	| fakt  | ja   |
And I append rows
	| artikel | mge         | preis       | pwert       | proz        |
	| V1      | 10          | 10          | !dontChange | !dontChange |
	| V1      | 5           | 10          | !dontChange | 10          |
	| V1      | 20          | 10          | !dontChange | -10         |
	| V1      | 30          |  0          | 250         | !dontChange |
	| DL-HANA | 10          | !dontChange | !dontChange | !dontChange |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "WERT-ZU-RE17" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE17"
And I set fields
   | nummer | 17WERT     |
   | such   | VK-WERT17  |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
Then the table has 8 rows
Then field "preis" has value "10.00" in row 1
# And I press button "komplettieren"
And I set field "mge" to "-9" in row 1
# Gutzuschreibender Preis zu hoch.
Then setting field "preis" to "11" in row 1 throws the exception "6758"
# Negative Preise bei Gutschriftpositionen nicht erlaubt.
Then setting field "preis" to "-1" in row 1 throws the exception "131"
And I set field "preis" to "10" in row 1
# Positiver Positionswert bei Gutschriftpositionen nicht erlaubt.
Then setting field "pwert" to "100" in row 1 throws the exception "131"
And I set field "pwert" to "-92" in row 1
And I set field "pwert" to "-81" in row 1
# Position mit Zuschlag
And I set field "mge" to "-4" in row 2
# Gutzuschreibender Preis zu hoch.
Then setting field "preis" to "12" in row 2 throws the exception "6758"
And I set field "preis" to "10" in row 2
# Gutzuschreibender Positionswert zu hoch.
Then setting field "pwert" to "-56" in row 2 throws the exception "11241"
And I set field "pwert" to "-42" in row 2
# Position mit Abschlag
And I set field "mge" to "-10" in row 3
# Gutzuschreibender Preis zu hoch.
Then setting field "preis" to "15" in row 3 throws the exception "6758"
And I set field "preis" to "10" in row 3
# Gutzuschreibender Positionswert zu hoch.
Then setting field "pwert" to "-181" in row 3 throws the exception "11241"
And I set field "pwert" to "-89" in row 3
And I set field "pwert" to "-90" in row 3
# Position mit Pauschalpreis
Then field "preis" is not modifiable in row 4
And I press button "offueb" in row 4
Then field "mge" has value "-30" in row 4
Then field "pwert" has value "-250.00" in row 4
And I set field "mge" to "-25" in row 4
Then setting field "pwert" to "-310" in row 4 throws the exception "11241"
# Dienstleistung
And I set field "mge" to "-5" in row 5
# Gutzuschreibende Menge zu hoch.
# Then setting field "mge" to "-11" in row 5 throws the exception "2022"
Then setting field "preis" to "-20" in row 5 throws the exception "131"
Then setting field "pwert" to "-2222" in row 5 throws the exception "11241"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - fixpwert bei Prozentpositionen in der Wertgutschrift schreibschuetzen
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE04-VK-Kunde2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | kunde  | 2       |
   | such   | RE03KU2 |
   | nummer | 03VKRE  |
   | ueb    | ja      |
   | tterm  | .       |
   | budat  | .       |
And I append rows
   | artikel | mge         | preis        | proz        |
   | V1      | 10          |  100         | 10          |
   | PR.     | !dontChange |  !dontChange | !dontChange |
   | NEUPOS  | !dontChange |  !dontChange | !dontChange |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung wertgutschreiben
Given I open an editor "RE04-VK-Kunde2WGS" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE04-VK-Kunde2"
# Artikelposition
Then field "fixpwert" is not modifiable in row 1
# Prozentposition
Then field "fixpwert" is not modifiable in row 2
# Weitere Zusatzposition
Then field "fixpwert" is not modifiable in row 3
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - Teilwertgutschrift mit Pauschalpreis Plausibilitaeten fuer Menge, Preis und Positionswert ueberpruefen
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE18" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| kunde | 1    |
	| such  | RE18 |
	| ueb   | ja   |
	| tterm | .    |
	| vom   | .    |
	| fakt  | ja   |
And I append rows
	| artikel | mge         | preis       | pwert       | proz        |
	| EINK    | 12          | 10          | !dontChange | !dontChange |
	| EINK    | 10          | 10          | !dontChange | 10          |
	| EINK    | 20          | 10          | !dontChange | -10         |
	| EINK    | 15          |  0          | 120         | !dontChange |
	| EINK    | 11          |  0          | !dontChange | !dontChange |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Test, dass beim Komplettieren nichts uebernommen wird, wenn nichts gutzuschreiben ist.
Given I open an editor "WERT-ZU-RE18T" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE18"
And I set fields
   | nummer | 18WERT_T   |
Then the table has 8 rows
And I press button "komplettieren"
# Position ohne Preis und Wert. Es ist nichts gutzuschreiben. Komplette Menge wird trotzdem uebernommmen.
Then field "mge" has value "-11" in row 5
Then field "preis" has value "0.00" in row 5
Then field "pwert" has value "0.00" in row 5
And I close the current editor

Given I open an editor "WERT-ZU-RE18" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE18"
And I set fields
   | nummer | 18WERT     |
   | such   | VK-WERT18  |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
Then the table has 8 rows
# Position ohne Ab-/Zuschlag
And I press button "offueb" in row 1
Then field "mge" has value "-12" in row 1
Then field "pwert" has value "-120.00" in row 1
And I set field "mge" to "-6" in row 1
And I set field "preis" to "0" in row 1
# Gutzuschreibender Positionswert zu hoch.
Then setting field "pwert" to "-61" in row 1 throws the exception "11241"
And I set field "pwert" to "-59" in row 1
# Komplettgutschrift mit Pauschalpreis
And I set field "mge" to "-12" in row 1
And I set field "pwert" to "-120" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
# Keine Komplettgutschrift mit Preis
And I set field "preis" to "7" in row 1
Then field "komplettgutschrift" has value "nein" in row 1
# Keine Komplettgutschrift mit Pauschalpreis
And I set field "preis" to "0" in row 1
And I set field "pwert" to "-100" in row 1
Then field "komplettgutschrift" has value "nein" in row 1
# Keine Komplettgutschrift mit Preis
And I set field "preis" to "10" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
# Position mit Zuschlag
And I press button "offueb" in row 2
Then field "mge" has value "-10" in row 2
Then field "pwert" has value "-110.00" in row 2
Then field "proz" has value "10" in row 2
And I set field "mge" to "-4" in row 2
And I set field "preis" to "0" in row 2
Then field "proz" has value "0" in row 2
# Gutzuschreibender Positionswert zu hoch.
Then setting field "pwert" to "-45" in row 2 throws the exception "11241"
And I set field "pwert" to "-42" in row 2
# Position mit Abschlag
And I press button "offueb" in row 3
Then field "mge" has value "-20" in row 3
Then field "pwert" has value "-180.00" in row 3
Then field "proz" has value "-10" in row 3
And I set field "mge" to "-15" in row 3
And I set field "preis" to "0" in row 3
Then field "proz" has value "0" in row 3
# Gutzuschreibender Positionswert zu hoch.
Then setting field "pwert" to "-137" in row 3 throws the exception "11241"
And I set field "pwert" to "-135" in row 3
# Position mit Pauschalpreis
Then field "preis" is not modifiable in row 4
And I press button "offueb" in row 4
Then field "mge" has value "-15" in row 4
Then field "pwert" has value "-120.00" in row 4
And I set field "mge" to "-10" in row 4
Then field "pwert" has value "-80.00" in row 4
Then setting field "pwert" to "-121" in row 4 throws the exception "11241"
# Position ohne Preis
And I press button "offueb" in row 5
# Es ist nichts gutzuschreiben. Komplette Menge wird trotzdem uebernommmen.
Then field "mge" has value "-11" in row 5
Then field "preis" has value "0.00" in row 5
Then field "pwert" has value "0.00" in row 5
Then field "komplettgutschrift" has value "ja" in row 5
And I set field "mge" to "0" in row 5
Then field "komplettgutschrift" has value "nein" in row 5
And I set field "mge" to "-11" in row 5
Then field "komplettgutschrift" has value "ja" in row 5
Then setting field "mge" to "-1" in row 5 throws the exception "3228"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - Wertgutschrift mit Pauschalpreis und nicht ganzzahliger Menge
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE19" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| kunde | 1    |
	| such  | RE19 |
	| ueb   | ja   |
	| tterm | .    |
	| vom   | .    |
	| fakt  | ja   |
And I append rows
	| artikel | mge   | pwert |
	| EINK    | 12,5  | 125   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "WERT-ZU-RE19" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE19"
And I set fields
   | nummer | 19WERT     |
   | such   | VK-WERT19  |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
# Zunaechst Werte durch Kommplettieren uebernehmen
And I press button "komplettieren"
Then field "mge" has value "-12.5" in row 1
Then field "pwert" has value "-125.00" in row 1
And I set field "mge" to "0" in row 1
And I set field "pwert" to "0" in row 1
# Offene Menge uebernehmen
And I press button "offueb" in row 1
Then field "mge" has value "-12.5" in row 1
Then field "pwert" has value "-125.00" in row 1
Then setting field "mge" to "-12,6" in row 1 throws the exception "2022"
And I set field "mge" to "-12,2" in row 1
And I set field "pwert" to "-120,00" in row 1


#----------------------------------------------------------------------------------------------
Scenario: VK - Bei WGS nur Textpositionen als neue Zeilen erlauben
#----------------------------------------------------------------------------------------------

Given I create a SalesOrder "AU20" for Customer "1" with Product "V1" and quantity "20"
Given I deliver the SalesOrder "AU20" with PackingSlip "LS20"
Given I invoice the PackingSlip "LS20" with Invoice "RE20"

# Rechnung wertgutschreiben
Given I open an editor "RE20WGS" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE20"
And I set fields
   | such   | RE20WGS  |
   | ueb    | nein     |
   | tterm  | .        |
   | budat  | .        |
And I set field "mge" to "-20" in row 1
And I create a new row at the end of the table
# Nur neue Text-/Abschlussposition sind in WGS erlaubt
Then field "pwert" is not modifiable in row !lastRow
Then setting field "artex" to "V2" in row !lastRow throws the exception "10328"
Then setting field "artex" to "DL-REPARATUR" in row !lastRow throws the exception "10328"
Then setting field "artex" to "PR." in row !lastRow throws the exception "10328"
Then setting field "artex" to "AUBEPOS" in row !lastRow throws the exception "10328"
And I set field "artex" to "Text" in row !lastRow
Then field "pwert" is not modifiable in row !lastRow
Then field "fixpwert" is not modifiable in row !lastRow
And I save the current editor

# WGS editieren
Given I open an editor "RE20WGSE" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE20WGS"
Then the table has 5 rows
Then field "artex" is not modifiable in row 1
Then field "pwert" is modifiable in row 1
# WGS aendern: Nur Text Position ist erlaubt
And I create a new row at the end of the table
Then field "pwert" is not modifiable in row !lastRow
Then setting field "artex" to "V2" in row !lastRow throws the exception "10328"
And I set field "artex" to "Text" in row !lastRow
Then field "pwert" is not modifiable in row !lastRow
Then field "fixpwert" is not modifiable in row !lastRow
And I set field "ueb" to "Ja"
And I save the current editor

# WGS erneut oeffnen und Werte ausgeben
Given I open an editor "RE20WGSE" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE20WGSE"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK - Rechnungsstellung beim Rechnungsabschluss in WGS nicht erlaubt
# ----------------------------------------------------------------------------------------------

Given I open an editor "1RS003" from table "(Company):(Invoicing)" with command "NEW" for record ""
And I set fields
   | nummer  | 1RS003   |
   | such    | RS003    |
And I append rows
   | posex   |
   | TEXT    |
And I save the current editor

# Bestellung
Given I open an editor "1BE003" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE003   |
   | lief    | 1        |
   | such    | BE003    |
And I append rows
   | artikel | mge | preis |
   | E2      | 10  | 10    |
And I save the current editor

# Lieferschein
Given I open an editor "1LS003" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE003"
And I set fields
   | nummer | 1LS003  |
   | such   | LS003   |
   | ueb    | ja      |
   | vom    | .       |
   | fakt   | nein    |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung mit Rechnungsstellung
Given I open an editor "1RE003" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE003"
And I set fields
   | nummer   | 1RE003 |
   | such     | RE003  |
   | ueb      | ja     |
   | vom      | .      |
   | rechnung | RS003  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "1RE003" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "1RE003"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

# Wertgutschrift, Textposition aus der Rechnung loeschen, buchen
Given I open an editor "1WG003" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE003"
And I set fields
   | nummer | 1WG003  |
   | such   | WG003   |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-10" in row 1
And I delete row at position 2
And I save the current editor

Given I open an editor "1WG003" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "1WG003"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK - Komplett wertgutgeschriebene Positionen werden nicht in weitere Wertgutschrift uebernommen
# ----------------------------------------------------------------------------------------------

# Rechnung mit Lagerbewegung
Given I open an editor "1RE004" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE004  |
   | lief   | 1       |
   | such   | RE004   |
   | ueb    | ja      |
   | vom    | .       |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | E2      | 10          | 10          | !dontChange |
   | E3      | 10          | 10          | !dontChange |
   | TEXT    | !dontChange | !dontChange | 120         |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettgutschrift erste Position
Given I open an editor "1WG004" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE004"
And I set fields
   | nummer | 1WG004  |
   | such   | WG004-1 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-10" in row 1
And I set field "pwert" to "-120" in row 3
And I save the current editor

# Weitere Wertgutschrift
Given I open an editor "2WG004" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE004"
And I set fields
   | nummer | 2WG004  |
   | such   | WG004-2 |
# Rechnungskorrekturzeilen muessen beim Erstellen einer Wertgutschrift geloescht werden
And I press button "buwertgutschrift"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK-Wertgut-005 Wertgutschrift zu Rechnung aus Lieferschein mit Neutraler Position
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU005" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU005 |
   | kunde   | 1      |
   | such    | AU005  |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | V1      | 10          | 10          | !dontChange |
   | NEUPOS  | !dontChange | !dontChange | 50          |
And I save the current editor

# Lieferschein
Given I open an editor "LS005" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU005"
And I set fields
   | nummer | 1LS005 |
   | such   | LS005  |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung 1
Given I open an editor "1RE005" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS005"
And I set fields
   | nummer | 1RE005  |
   | such   | RE005-1 |
   | ueb    | ja      |
   | vom    | 2.1.95  |
   | tterm  | .       |
And I set field "mge" to "10" in row 1
And I delete row at position 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Sales):(PackingSlip)" with the editor id "LS005" is not filed

# Rechnung 2
Given I open an editor "2RE005" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS005"
And I set fields
   | nummer | 2RE005  |
   | such   | RE005-2 |
   | ueb    | ja      |
   | vom    | 3.1.95  |
   | tterm  | .       |
And I set field "pwert" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Sales):(PackingSlip)" with the editor id "LS005" is filed


# Wertgutschrift
Given I open an editor "1WG005" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "2RE005"
And I set fields
   | nummer | 2WG005  |
   | such   | WG005   |
   | ueb    | ja      |
   | tterm  | .       |
# WGS hat immer Valutadatum = Vom-Datum = Tagesdatum
Then field "vom" has value "05.01.95"
Then field "vdat" has value "05.01.95"
# Valutadatum wird mit vom-datum geaendert
And I set field "vom" to "03.01.95"
Then field "vom" has value "03.01.95"
Then field "vdat" has value "03.01.95"
# Valutadatum ist auch einzeln ueberschreibbar
And I set field "vdat" to "04.01.95"
# Weiteres...
And I set field "pwert" to "-50" in row 1
Then field "mge" is not modifiable in row 1
Then field "preis" is not modifiable in row 1
And I save the current editor

Then "(Sales):(PackingSlip)" with the editor id "LS005" is not filed


# ----------------------------------------------------------------------------------------------
Scenario: EK-Wertgut-005 Wertgutschrift zu Rechnung aus Lieferschein mit Neutraler Position
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "BE005" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE005   |
   | lief    | 1        |
   | such    | BE005    |
   | ebeleg  | BE005    |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | V1      | 10          | 10          | !dontChange |
   | NEUPOS  | !dontChange | !dontChange | 50          |
And I save the current editor

# Lieferschein
Given I open an editor "LS005" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE005"
And I set fields
   | nummer | 1LS005 |
   | such   | LS005  |
   | ebeleg | LS005  |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung 1
Given I open an editor "1RE005" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS005"
And I set fields
   | nummer | 1RE005  |
   | such   | RE005-1 |
   | ebeleg | RE005-1 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I delete row at position 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "LS005" is not filed

# Rechnung 2
Given I open an editor "2RE005" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS005"
And I set fields
   | nummer | 2RE005  |
   | such   | RE005-2 |
   | ebeleg | RE005-2 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "pwert" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "LS005" is filed

# Wertgutschrift
Given I open an editor "WG005" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE005"
And I set fields
   | nummer | 1WG005 |
   | ebeleg | WG005  |
   | such   | WG005  |
   | ueb    | ja     |
   | vom    | .      |
And I set field "pwert" to "-50" in row 1
Then field "mge" is not modifiable in row 1
Then field "preis" is not modifiable in row 1
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "LS005" is not filed


# ----------------------------------------------------------------------------------------------
Scenario: VK-Wertgut-006 Wertgutschrift zu Rechnung aus Auftrag mit Neutraler Position
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU006" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU006 |
   | kunde   | 1      |
   | such    | AU006  |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | V1      | 10          | 10          | !dontChange |
   | NEUPOS  | !dontChange | !dontChange | 50          |
And I save the current editor

# Lieferschein
Given I open an editor "LS006" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU006"
And I set fields
   | nummer | 1LS006 |
   | such   | LS006  |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | nein   |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung 1
Given I open an editor "1RE006" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU006"
And I set fields
   | nummer | 1RE006  |
   | such   | RE006_1 |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "10" in row 1
And I delete row at position 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Sales):(SalesOrder)" with the editor id "AU006" is not filed

# Rechnung 2
Given I open an editor "2RE006" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU006"
And I set fields
   | nummer | 2RE006  |
   | such   | RE006-2 |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "pwert" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Sales):(SalesOrder)" with the editor id "AU006" is filed

# Wertgutschrift
Given I open an editor "WG006" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "2RE006"
And I set fields
   | nummer | 1WG006  |
   | such   | WG006   |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "pwert" to "-50" in row 1
And I save the current editor

Then "(Sales):(SalesOrder)" with the editor id "AU006" is not filed


# ----------------------------------------------------------------------------------------------
Scenario: EK-Wertgut-006 Wertgutschrift zu Rechnung aus Auftrag mit Neutraler Position
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "BE006" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE006   |
   | lief    | 1        |
   | such    | BE006    |
   | ebeleg  | BE006    |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | V1      | 10          | 10          | !dontChange |
   | NEUPOS  | !dontChange | !dontChange | 50          |
And I save the current editor

# Lieferschein
Given I open an editor "LS006" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE006"
And I set fields
   | nummer | 1LS006 |
   | such   | LS006  |
   | ebeleg | LS006  |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | nein   |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung 1
Given I open an editor "1RE006" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE006"
And I set fields
   | nummer | 1RE006  |
   | such   | RE006-1 |
   | ebeleg | RE006-1 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I delete row at position 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Purchasing):(PurchaseOrder)" with the editor id "BE006" is not filed

# Rechnung 2
Given I open an editor "2RE006" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE006"
And I set fields
   | nummer | 2RE006  |
   | such   | RE006-2 |
   | ebeleg | RE006-2 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "pwert" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Purchasing):(PurchaseOrder)" with the editor id "BE006" is filed

# Wertgutschrift
Given I open an editor "WG006" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE006"
And I set fields
   | nummer | 1WG006 |
   | ebeleg | WG006  |
   | such   | WG006  |
   | ueb    | ja     |
   | vom    | .      |
And I set field "pwert" to "-50" in row 1
And I save the current editor

Then "(Purchasing):(PurchaseOrder)" with the editor id "BE006" is not filed


# ----------------------------------------------------------------------------------------------
Scenario: VK-Wertgut-007 Wertgutschrift zu Rechnung aus Auftrag mit einer Neutralen Position
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU007" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU007 |
   | kunde   | 1      |
   | such    | AU007  |
And I append rows
   | artikel | pwert |
   | NEUPOS  | 50    |
And I save the current editor

# Rechnung
Given I open an editor "RE007" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU007"
And I set fields
   | nummer | 1RE007  |
   | such   | RE007   |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "pwert" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Sales):(SalesOrder)" with the editor id "AU007" is filed

# Wertgutschrift
Given I open an editor "WG007" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE007"
And I set fields
   | nummer | 1WG007  |
   | such   | WG007   |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "pwert" to "-50" in row 1
And I save the current editor

Then "(Sales):(SalesOrder)" with the editor id "AU007" is not filed


# ----------------------------------------------------------------------------------------------
Scenario: EK-Wertgut-007 Wertgutschrift zu Rechnung aus Auftrag mit einer Neutralen Position
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "BE007" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE007   |
   | lief    | 1        |
   | such    | BE007    |
   | ebeleg  | BE007    |
And I append rows
   | artikel | pwert |
   | NEUPOS  | 50    |
And I save the current editor

# Rechnung
Given I open an editor "RE007" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE007"
And I set fields
   | nummer | 1RE007  |
   | such   | RE007   |
   | ebeleg | RE007   |
   | ueb    | ja      |
   | vom    | .       |
And I set field "pwert" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Purchasing):(PurchaseOrder)" with the editor id "BE007" is filed

# Wertgutschrift
Given I open an editor "WG007" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE007"
And I set fields
   | nummer | 1WG007 |
   | ebeleg | WG007  |
   | such   | WG007  |
   | ueb    | ja     |
   | vom    | .      |
And I set field "pwert" to "-50" in row 1
And I save the current editor

Then "(Purchasing):(PurchaseOrder)" with the editor id "BE007" is not filed


# ----------------------------------------------------------------------------------------------
Scenario: VK-Wertgut-008 Wertgutschrift zu Rechnung aus Auftrag mit Neutraler Position
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU008" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU008 |
   | kunde   | 1      |
   | such    | AU008  |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | V1      | 10          | 10          | !dontChange |
   | NEUPOS  | !dontChange | !dontChange | 50          |
And I save the current editor

# Lieferschein
Given I open an editor "LS008" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU008"
And I set fields
   | nummer | 1LS008 |
   | such   | LS008  |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | nein   |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE008" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU008"
And I set fields
   | nummer | 1RE008  |
   | such   | RE008   |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "10" in row 1
And I set field "pwert" to "50" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Sales):(SalesOrder)" with the editor id "AU008" is filed

# Wertgutschrift
Given I open an editor "WG008" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE008"
And I set fields
   | nummer | 1WG008  |
   | such   | WG008   |
   | ueb    | ja      |
   | tterm  | .       |
And I delete row at position 1
And I set field "pwert" to "-50" in row 1
And I save the current editor

Then "(Sales):(SalesOrder)" with the editor id "AU008" is not filed


# ----------------------------------------------------------------------------------------------
Scenario: EK-Wertgut-008 Wertgutschrift zu Rechnung aus Auftrag mit Neutraler Position
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "BE008" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE008   |
   | lief    | 1        |
   | such    | BE008    |
   | ebeleg  | BE008    |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | V1      | 10          | 10          | !dontChange |
   | NEUPOS  | !dontChange | !dontChange | 50          |
And I save the current editor

# Lieferschein
Given I open an editor "LS008" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE008"
And I set fields
   | nummer | 1LS008 |
   | such   | LS008  |
   | ebeleg | LS008  |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | nein   |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE008" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE008"
And I set fields
   | nummer | 1RE008  |
   | such   | RE008-1 |
   | ebeleg | RE008-1 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I set field "pwert" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Purchasing):(PurchaseOrder)" with the editor id "BE008" is filed

# Wertgutschrift
Given I open an editor "WG008" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE008"
And I set fields
   | nummer | 1WG008 |
   | ebeleg | WG008  |
   | such   | WG008  |
   | ueb    | ja     |
   | vom    | .      |
And I delete row at position 1
And I set field "pwert" to "-50" in row 1
And I save the current editor

Then "(Purchasing):(PurchaseOrder)" with the editor id "BE008" is not filed


# ----------------------------------------------------------------------------------------------
Scenario: EK - Stornierung Komplettwertgutschrift (Fakturierung ueber Bestellung) - vor der Stornierung
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE009" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE009   |
   | lief    | 1        |
   | such    | BE009    |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | E2      | 10          | 10          | !dontChange |
   | TEXT    | !dontChange | !dontChange | 100         |
And I save the current editor

# Lieferschein
Given I open an editor "1LS009" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE009"
And I set fields
   | nummer | 1LS009  |
   | such   | LS009   |
   | ueb    | ja      |
   | vom    | .       |
   | fakt   | nein    |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE009" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE009"
And I set fields
   | nummer   | 1RE009 |
   | such     | RE009  |
   | ueb      | ja     |
   | vom      | .      |
Then field "artikel" has value "E2" in row 1
# fuer die Pruefung der Bewertungsdaten nach Storno WGS ist eine zum LS abweichender RE-preis notwendig:
And I set field "preis" to "12" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Pruefen von remge und ofwert in Rechnung vor Buchen der Komplettwertgutschrift
Then field "remge" from editor "1RE009" in row 1 has value "-10"
Then field "ofwert" from editor "1RE009" in row 1 has value "-120.00"

# Komplettwertgutschrift
Given I open an editor "1WG009" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE009"
And I set fields
   | nummer | 1WG009  |
   | such   | WG009   |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-10" in row 1
And I set field "pwert" to "-100" in row 2
Then field "mge" is not modifiable in row 2
Then field "preis" is not modifiable in row 2
And I save the current editor

# Pruefen von remge und ofwert in Rechnung nach Buchen der Komplettwertgutschrift
Then field "remge" from editor "1RE009" in row 1 has value "0"
Then field "ofwert" from editor "1RE009" in row 1 has value "0.00"

Given I open an editor "1BE009" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE009"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1RE009" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "1RE009"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1WG009" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "1WG009"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK - Stornierung Komplettwertgutschrift (Fakturierung ueber Bestellung) - nach der Stornierung
# ----------------------------------------------------------------------------------------------

# Komplettwertgutschrift stornieren
Given I open an editor "1WG009S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1WG009"
And I set fields
   | nummer | 1WG009S  |
And I save the current editor

# Pruefen von remge und ofwert in Rechnung nach Stornieren der Komplettwertgutschrift
Then field "remge" from editor "1RE009" in row 1 has value "-10"
Then field "ofwert" from editor "1RE009" in row 1 has value "-120.00"

Given I open an editor "1BE009" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE009"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1RE009" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "1RE009"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1WG009" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "1WG009"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1WG009S" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "1WG009S"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK - Stornierung Komplettwertgutschrift (Fakturierung ueber Bestellung) - neue Komplettwertgutschrift
# ----------------------------------------------------------------------------------------------

# Neue Komplettwertgutschrift
Given I open an editor "2WG009" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE009"
And I set fields
   | nummer | 2WG009  |
   | such   | WG009-2 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-10" in row 1
And I set field "pwert" to "-100" in row 2
Then field "mge" is not modifiable in row 2
Then field "preis" is not modifiable in row 2
And I save the current editor

Given I open an editor "1BE009" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "1BE009"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1RE009" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "1RE009"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "2WG009" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "2WG009"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - Stornierung Komplettwertgutschrift (Fakturierung ueber Lieferschein) - vor der Stornierung
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU009" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU009   |
   | kunde   | 1        |
   | such    | AU009    |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | V1      | 10          | 10          | !dontChange |
   | TEXT    | !dontChange | !dontChange | 100         |
And I save the current editor

# Lieferschein
Given I open an editor "1LS009" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU009"
And I set fields
   | nummer | 1LS009  |
   | such   | LS009   |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE009" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS009"
And I set fields
   | nummer | 1RE009  |
   | such   | RE009   |
   | ueb    | ja      |
   | tterm  | .       |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "1WG009" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE009"
And I set fields
   | nummer | 1WG009  |
   | such   | WG009   |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-10" in row 1
And I set field "pwert" to "-100" in row 2
And I save the current editor

Given I open an editor "1LS009" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "1LS009"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1RE009" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1RE009"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1WG009" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1WG009"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - Stornierung Komplettwertgutschrift (Fakturierung ueber Lieferschein) - nach der Stornierung
# ----------------------------------------------------------------------------------------------

# Komplettwertgutschrift stornieren
Given I open an editor "1WG009S" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "1WG009"
And I set fields
   | nummer | 1WG009S  |
And I save the current editor

Given I open an editor "1LS009" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "1LS009"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1RE009" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1RE009"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1WG009" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1WG009"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1WG009S" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1WG009S"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - Stornierung Komplettwertgutschrift (Fakturierung ueber Lieferschein) - neue Komplettwertgutschrift
# ----------------------------------------------------------------------------------------------

# Neue Komplettwertgutschrift
Given I open an editor "1WG009" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE009"
And I set fields
   | nummer | 2WG009  |
   | such   | WG009-2 |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-10" in row 1
And I set field "pwert" to "-100" in row 2
And I save the current editor

Given I open an editor "1LS009" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "1LS009"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "1RE009" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1RE009"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor

Given I open an editor "2WG009" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1WG009"
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK - Wertgutschrift mit Materialzuschlag
# ----------------------------------------------------------------------------------------------

# EK-Bestellung anlegen
Given I open an editor "BE11" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE011 |
   | lief    | 1      |
   | such    | BE011  |
   | ebeleg  | BE011  |
And I append rows
   | artikel  | mge |
   | !TECH005 | 10  |
   | !TECH006 | 10  |
And I save the current editor

# EK-Lieferschein erzeugen
Given I open an editor "ekls_11" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | beleg  | 1BE011  |
   | nummer | 1EKLS11 |
   | such   | LS011-1 |
   | ebeleg | LS011-1 |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 4 rows
And I press button "offueb" in row 1
And I press button "offueb" in row 3
And I save the current editor

# Rechnung zu LS erzeugen
Given I open an editor "ekrech_11" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg  | 1EKLS11 |
   | nummer | 1EKRE11 |
   | such   | RE011-1 |
   | ebeleg | RE011-1 |
   | ueb    | ja      |
   | vom    | .       |
   | term   | .       |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
Then field "pwert" from editor "ekrech_11" in row 7 has value "184172.50"

# Wertgutschrift anlegen
Given I open an editor "ek_wertgut_11" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "ekrech_11"
And I set fields
   | nummer | 1WG011  |
   | such   | WG011-1 |
   | ebeleg | WG011-1 |
   | vom    | .       |
And I press button "komplettieren"
Then the table has 7 rows
And I press button "offueb" in row 1
Then field "fixpwert" is not modifiable in row 2
Then field "preis" is not modifiable in row 2
Then field "proz" is not modifiable in row 2
Then field "platz" is not modifiable in row 2
Then field "verw" is not modifiable in row 2
Then field "kstelle" is not modifiable in row 2
Then field "skfaehig" is not modifiable in row 2
Then field "fixkonto" is not modifiable in row 2
Then field "fixstrgl" is not modifiable in row 2
Then field "pnum" is not modifiable in row 2
Then field "lgruppe" is not modifiable in row 2
Then field "oterm" is not modifiable in row 2
Then field "abnrpo" is not modifiable in row 2
# VK: Then field "ganr" is not modifiable in row 2
# VK: Then field "gaedinr" is not modifiable in row 2
Then field "fixkstelle" is not modifiable in row 2
Then field "teartdleist" is not modifiable in row 2
And I press button "offueb" in row 3
Then field "pwert" has value "-184172.50" in row 7
Then the table has 7 rows
And I save the current editor

# Materialzuschlagsposition kann nicht geloescht werden
Given I open an editor "ek_wertgut_11" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "1WG011"
And deleting the row at position 2 throws the exception "3885"
And deleting the row at position 4 throws the exception "3885"
And I set field "ueb" to "ja"
And I save the current editor

# Wertgutschrift ansehen
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "ek_wertgut_11"
And I press start
Then the table has 12 rows
Then field "textgrwechsel" contains value "Bestellung" in row 1
Then field "mge" has value "10" in row 4
Then field "epreis" has value "-9000.00" in row 4
Then field "gpreis" has value "-90000.00" in row 4
Then field "mzda" has value "0" in row 4
Then field "artikelsuch" in row 4 has value equal to field "such" from editor "TECH005" in row 0
# Materialzuordnung
Then field "mge" has value "5" in row 5
Then field "epreis" has value "-10.00" in row 5
Then field "gpreis" has value "-50.00" in row 5
Then field "artikelsuch" has value "MATZU" in row 5
#
Then field "mge" has value "10" in row 6
Then field "epreis" has value "-7000.00" in row 6
Then field "gpreis" has value "-70000.00" in row 6
Then field "mzda" has value "0" in row 6
# Materialzuordnung
Then field "mge" has value "10" in row 7
Then field "epreis" has value "-10.00" in row 7
Then field "gpreis" has value "-100.00" in row 7
Then field "artikelsuch" has value "MATZU" in row 7
#
Then field "artikelsuch" in row 6 has value equal to field "such" from editor "TECH006" in row 0
And I close the current editor

# Rechnung 2 zu LS erzeugen
Given I open an editor "ekrech_11_2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg  | 1EKLS11 |
   | nummer | 2EKRE11 |
   | such   | RE011-2 |
   | ebeleg | RE011-2 |
   | ueb    | ja      |
   | vom    | .       |
   | term   | .       |
And I set field "mge" to "10" in row 1
# MATZU-Position zu TECH006 loeschen
And I delete row at position 4
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift anlegen, MATZU-Position wird in der WG nicht ergaenzt, weil diese in RE geloescht wurde.
Given I open an editor "ek_wertgut_11_2" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "ekrech_11_2"
And I set fields
   | nummer | 2WG011  |
   | such   | WG011-2 |
   | ebeleg | WG011-2 |
   | vom    | .       |
Then the table has 6 rows
And I set field "mge" to "-1" in row 3
Then the table has 6 rows
And I set field "mge" to "-10" in row 3
Then the table has 6 rows
And I set field "mge" to "0" in row 3
Then the table has 6 rows
And I close the current editor


# ---------------------------------------------------------------------------------------------------
Scenario Outline: Artikel TECH006 mit Bestand versorgen, damit Bewertungsorigs zur Verfuegung stehen
# ---------------------------------------------------------------------------------------------------
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel	| <artikel>   |
	| buart		| Zugang      |
	| beleg		| mpr-erzwing |
	| beldat	| .           |
	| wert		| <wert>      |
And I append rows
	| mge   | platz2  | verw      |
	| <mge> | <platz> | <verw>    |
And I save the current editor

Examples:
	| artikel	| wert	| mge	| platz |	verw	|
	| TECH006	| 3		| 100	| F1	|	tec006	|


# ----------------------------------------------------------------------------------------------
Scenario: VK - Wertgutschrift mit Materialzuschlag - MATZU-Position kann nicht geloescht werden
# ----------------------------------------------------------------------------------------------

# VK-Auftrag anlegen
Given I open an editor "AU12" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 12AU      |
   | kunde   | 1         |
   | such    | AU12      |
   | betreff | AU12-WERT |
And I append rows
   | artikel  | mge | preis |
   | !TECH006 | 20  | 6     |
   | !TECH005 | 10  | 8     |
And I save the current editor

# Rechnung zu 12AU erzeugen
Given I open an editor "vk_rech_12" from table "(Sales):(Invoice)" with command "NEW" for record from editor "AU12"
And I set fields
   | nummer | 1VKRE12 |
   | such   | RE012-1 |
   | ueb    | ja      |
   | vom    | .       |
   | term   | .       |
And I set field "mge" to "10" in row 1
And I set field "mge" to "8" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "vk_rech_12" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "vk_rech_12"
Then the table has 7 rows
And I close the current editor

# Materialzuordnung fuer Artikel TECH005 loeschen
Given I open an editor "TECH005_ohne_MATZU" from table "(Part):(Product)" with command "UPDATE" for record "TECH005"
And I set fields
	| matart |  |
And I save the current editor

# VK-Wertgutschrift anlegen, MATZU werden aus der Rechnung uebernommen (im Artikel TECH005 ist diese geloescht)
Given I open an editor "vk_wertgut_12" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "vk_rech_12"
And I set fields
   | nummer | 1WG012  |
   | such   | WG012-1 |
   | vom    | .       |
   | term   | .       |
Then the table has 7 rows
Then field "artikel" has value "MATZU" in row 2
Then field "artikel" has value "MATZU" in row 4
And I press button "komplettieren"
And I press button "offueb" in row 1
Then field "mge" has value "-4" in row 4
Then field "pwert" has value "-32.00" in row 4
Then field "fixpwert" is not modifiable in row 2
Then field "preis" is not modifiable in row 2
Then field "proz" is not modifiable in row 2
Then field "platz" is not modifiable in row 2
Then field "verw" is not modifiable in row 2
Then field "kstelle" is not modifiable in row 2
Then field "skfaehig" is not modifiable in row 2
Then field "fixkonto" is not modifiable in row 2
Then field "fixstrgl" is not modifiable in row 2
Then field "pros" is modifiable in row 2
Then field "pnum" is not modifiable in row 2
Then field "lgruppe" is not modifiable in row 2
Then field "oterm" is not modifiable in row 2
Then field "abnrpo" is not modifiable in row 2
Then field "ganr" is not modifiable in row 2
Then field "gaedinr" is not modifiable in row 2
Then field "fixkstelle" is not modifiable in row 2
Then field "teartdleist" is not modifiable in row 2
And I save the current editor

# WG: Materialzuschlagsposition kann nicht geloescht werden
Given I open an editor "vk_wertgut_12" from table "(Sales):(Invoice)" with command "UPDATE" for record "1WG012"
And deleting the row at position 2 throws the exception "3885"
And I set field "ueb" to "ja"
And I save the current editor

# Wertgutschrift ansehen
Given I open the infosystem "EVVORGANG"
And I set field "vorgang" to id from editor "vk_wertgut_12"
And I press start
Then the table has 11 rows
Then field "mge" has value "10" in row 3
Then field "epreis" has value "-9000.00" in row 3
Then field "gpreis" has value "-90000.00" in row 3
Then field "mzda" has value "0" in row 3
Then field "artikelsuch" in row 3 has value equal to field "such" from editor "TECH006" in row 0
# Materialzuordnung
Then field "mge" has value "10" in row 4
Then field "epreis" has value "-6.00" in row 4
Then field "gpreis" has value "-60.00" in row 4
Then field "artikelsuch" has value "MATZU" in row 4
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK2 - Wertgutschrift mit Materialzuschlag
# ----------------------------------------------------------------------------------------------

# VK-Auftrag 2 anlegen
Given I open an editor "AU12_2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 12AU2       |
   | kunde   | 1           |
   | such    | AU12_2      |
   | betreff | AU12-2-WERT |
And I append rows
   | artikel  | mge | preis |
   | !TECH006 |  2  | 20    |
   | !TECH005 | 11  | 11    |
And I save the current editor

# Rechnung zu 12AU2 erzeugen
Given I open an editor "vk_rech_12_2" from table "(Sales):(Invoice)" with command "NEW" for record from editor "AU12_2"
And I set fields
   | nummer | 2VKRE12 |
   | such   | RE012-2 |
   | ueb    | ja      |
   | vom    | .       |
   | term   | .       |
And I set field "mge" to "2" in row 1
And I set field "mge" to "11" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "vk_rech_12_2" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "vk_rech_12_2"
Then the table has 6 rows
And I close the current editor

# Materialzuordnung fuer Artikel TECH005
Given I open an editor "TECH005_mit_MATZU" from table "(Part):(Product)" with command "UPDATE" for record "TECH005"
And I set fields
	| matart  | CU  |
	| zmge    | 0,5 |
	| matvrel | ja  |
And I save the current editor

# VK-Wertgutschrift anlegen, MATZU werden aus der Rechnung uebernommen (im Artikel TECH005 ist diese geloescht)
Given I open an editor "vk_wertgut_12_2" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "vk_rech_12_2"
And I set fields
   | nummer | 2WG012  |
   | such   | WG012-2 |
   | vom    | .       |
   | term   | .       |
Then the table has 6 rows
Then field "artikel" has value "MATZU" in row 2
And I press button "komplettieren"
And I press button "offueb" in row 1
Then the table has 6 rows
And I set field "mge" to "-2" in row 3
Then the table has 6 rows
And I save the current editor

# Wegbuchen, damit das spaeter beim Jahresabschluss nicht stoert. Buchung ggf. auch spaeter vor Jahresabschluss moeglich
Given I open an editor "gutbuch1" from table "(Sales):(Invoice)" with command "TRANSFER" for record "WG012-2"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK3 - 100% Wertgutschrift mit Materialzuschlag und Prozentposition buchen
# ----------------------------------------------------------------------------------------------

# VK-Auftrag 3 anlegen
Given I open an editor "AU12_3" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 12AU3       |
   | kunde   | 1           |
   | such    | AU12_3      |
   | betreff | AU12-3-WERT |
And I append rows
   | artikel  | mge | preis |
   | !TECH006 |  3  | 20    |
   | !TECH005 | 33  | 11    |
And I save the current editor

# Rechnung zu 12AU3 erzeugen
Given I open an editor "vk_rech_12_3" from table "(Sales):(Invoice)" with command "NEW" for record from editor "AU12_3"
And I set fields
   | nummer | 3VKRE12 |
   | such   | RE012-3 |
   | ueb    | ja      |
   | vom    | .       |
   | term   | .       |
And I press button "offueb" in row 1
And I create a new row at position 2
And I set field "artex" to "PROZ5" in row 2
And I press button "offueb" in row 4
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Materialzuordnung fuer Artikel TECH005 loeschen
Given I open an editor "TECH005_ohne_MATZU" from table "(Part):(Product)" with command "UPDATE" for record "TECH005"
And I set fields
	| matart  |  |
	| zmge    |  |
	| matvrel |  |
And I save the current editor

# VK-Wertgutschrift anlegen, MATZU werden aus der Rechnung uebernommen (im Artikel TECH005 ist diese geloescht)
Given I open an editor "vk_wertgut_12_3" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "vk_rech_12_3"
And I set fields
   | nummer | 3WG012  |
   | such   | WG012-3 |
   | vom    | .       |
   | term   | .       |
Then the table has 8 rows
Then field "artikel" has value "MATZU" in row 3
And I set field "mge" to "-1" in row 1
Then field "pwert" has value "-20.00" in row 3
And I set field "mge" to "-3" in row 4
Then field "pwert" has value "-16.50" in row 5
And I set field "mge" to "-33" in row 4
Then field "pwert" has value "-181.50" in row 5
And I close the current editor

# WG komplett gutschreiben und buchen
Given I open an editor "VK_WGS_12_3" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "vk_rech_12_3"
And I set fields
   | nummer | 3WG012  |
   | such   | WG012-3 |
   | vom    | .       |
   | term   | .       |
   | ueb    | ja      |
Then the table has 8 rows
And I press button "offueb" in row 1
And I press button "offueb" in row 4
Then field "pwert" has value "-60.00" in row 3
Then field "pwert" has value "-181.50" in row 5
And I press button "komplettieren"
And I save the current editor
# MATZU-Positionen: ofwert leer?
Then field "ofwert" from editor "VK_WGS_12_3" in row 3 has value "0.00"
Then field "ofwert" from editor "VK_WGS_12_3" in row 5 has value "0.00"

# Materialzuordnung fuer Artikel TECH005
Given I open an editor "TECH005_mit_MATZU" from table "(Part):(Product)" with command "UPDATE" for record "TECH005"
And I set fields
	| matart  | CU  |
	| zmge    | 0.5 |
	| matvrel | ja  |
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK4 - TWertgutschrift mit Materialzuschlag speichern danach buchen - orig in MATZU pruefen
# ----------------------------------------------------------------------------------------------

# VK-Auftrag 4 anlegen
Given I open an editor "AU12_4" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 12AU4       |
   | kunde   | 1           |
   | such    | AU12_4      |
   | betreff | AU12-4-WERT |
And I append rows
   | artikel  | mge | preis |
   | !TECH006 |  4  | 20    |
   | !TECH005 | 44  | 11    |
And I save the current editor

# Rechnung zu 12AU4 erzeugen
Given I open an editor "vk_rech_12_4" from table "(Sales):(Invoice)" with command "NEW" for record from editor "AU12_4"
And I set fields
   | nummer | 4VKRE12 |
   | such   | RE012-4 |
   | ueb    | ja      |
   | vom    | .       |
   | term   | .       |
And I press button "offueb" in row 1
And I press button "offueb" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Materialzuordnung fuer Artikel TECH005 loeschen
Given I open an editor "TECH005_ohne_MATZU" from table "(Part):(Product)" with command "UPDATE" for record "TECH005"
And I set fields
	| matart  |  |
	| zmge    |  |
	| matvrel |  |
And I save the current editor

# VK-Wertgutschrift anlegen, MATZU werden aus der Rechnung uebernommen (im Artikel TECH005 ist diese geloescht)
# Speichern ohne zu buchen
Given I open an editor "vk_WGS_12_4" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "vk_rech_12_4"
And I set fields
   | nummer | 4WG012  |
   | such   | WG012-4 |
   | vom    | .       |
   | term   | .       |
Then the table has 7 rows
Then field "artikel" has value "MATZU" in row 2
And I set field "mge" to "-2" in row 1
Then field "pwert" has value "-40.00" in row 2
And I set field "mge" to "-4" in row 3
Then field "pwert" has value "-22.00" in row 4
And I save the current editor

# VK-Wertgutschrift: Mengen aendern und buchen
Given I open an editor "vk_wertgut_12_4" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "vk_WGS_12_4"
And I set fields
   | ueb    | ja      |
And I set field "mge" to "-4" in row 1
Then field "pwert" has value "-80.00" in row 2
And I set field "mge" to "-40" in row 3
Then field "pwert" has value "-220.00" in row 4
And I save the current editor

# Materialzuordnung fuer Artikel TECH005
Given I open an editor "TECH005_mit_MATZU" from table "(Part):(Product)" with command "UPDATE" for record "TECH005"
And I set fields
	| matart  | CU  |
	| zmge    | 0.5 |
	| matvrel | ja  |
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK-Wertgut-010 Wertgutschrift zu Rechnung aus Lieferschein mit einer neutralen Position
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU010" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU010 |
   | kunde   | 1      |
   | such    | AU010  |
And I append rows
   | artikel | pwert |
   | NEUPOS  | 50    |
And I save the current editor

# Lieferschein
Given I open an editor "LS010" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU010"
And I set fields
   | nummer | 1LS010 |
   | such   | LS010  |
   | ueb    | ja     |
   | vom    | .      |
And I save the current editor

Then field "remge" from editor "LS010" in row 1 has value "50"
Then "(Sales):(PackingSlip)" with the editor id "LS010" is not filed
Then field "remge" from editor "AU010" in row 1 has value "0"
Then "(Sales):(SalesOrder)" with the editor id "AU010" is filed

# Rechnung
Given I open an editor "RE010" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS010"
And I set fields
   | nummer | 1RE010  |
   | such   | RE010   |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "pwert" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "LS010" in row 1 has value "0"
Then "(Sales):(PackingSlip)" with the editor id "LS010" is filed

# Wertgutschrift
Given I open an editor "1WG010" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE010"
And I set fields
   | nummer | 1WG010  |
   | such   | WG010   |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "pwert" to "-50" in row 1
And I save the current editor

Then field "remge" from editor "LS010" in row 1 has value "50"
Then "(Sales):(PackingSlip)" with the editor id "LS010" is not filed


# ----------------------------------------------------------------------------------------------
Scenario: EK-Wertgut-010 Wertgutschrift zu Rechnung aus Lieferschein mit einer neutraler Position
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "BE010" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE010   |
   | lief    | 1        |
   | such    | BE010    |
   | ebeleg  | BE010    |
And I append rows
   | artikel | pwert |
   | NEUPOS  | 50    |
And I save the current editor

# Lieferschein
Given I open an editor "LS010" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE010"
And I set fields
   | nummer | 1LS010 |
   | such   | LS010  |
   | ebeleg | LS010  |
   | ueb    | ja     |
   | vom    | .      |
And I save the current editor

Then field "remge" from editor "LS010" in row 1 has value "50"
Then "(Purchasing):(PackingSlip)" with the editor id "LS010" is not filed
Then field "remge" from editor "BE010" in row 1 has value "0"
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE010" is filed

# Rechnung
Given I open an editor "RE010" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS010"
And I set fields
   | nummer | 1RE010 |
   | such   | RE010  |
   | ebeleg | RE010  |
   | ueb    | ja     |
   | vom    | .      |
And I set field "pwert" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "LS010" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "LS010" is filed

# Wertgutschrift
Given I open an editor "WG010" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE010"
And I set fields
   | nummer | 1WG010 |
   | ebeleg | WG010  |
   | such   | WG010  |
   | ueb    | ja     |
   | vom    | .      |
And I set field "pwert" to "-50" in row 1
And I save the current editor

Then field "remge" from editor "LS010" in row 1 has value "50"
Then "(Purchasing):(PackingSlip)" with the editor id "LS010" is not filed


# ----------------------------------------------------------------------------------------------
Scenario: VK-Wertgut-013 Wertgutschrift zu Rechnung mit einer negativen Textposition
# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "RE013" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE013 |
   | such   | RE013  |
   | kunde  | 1      |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | V1      | 1           | 25          | !dontChange |
   | TEXT    | !dontChange | !dontChange | -10         |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "WG013" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE013"
And I set fields
   | nummer | 1WG013 |
   | such   | WG013  |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
And I press button "offueb" in row 1
Then field "pwert" has value "-25.00" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
And I press button "offueb" in row 2
Then field "pwert" has value "10.00" in row 2
Then field "komplettgutschrift" has value "ja" in row 2
And I set field "pwert" to "0" in row 2
Then setting field "pwert" to "-2" in row 2 throws the exception "2158"
Then setting field "pwert" to "12" in row 2 throws the exception "11241"
And I set field "pwert" to "9" in row 2
Then field "komplettgutschrift" has value "nein" in row 2
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set field "pwert" to "10" in row 2
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK-Wertgut-013 Wertgutschrift zu Rechnung mit einer neutralen, negativen Position
# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "RE013" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE013 |
   | such   | RE013  |
   | ebeleg | RE013  |
   | lief   | 1      |
   | ueb    | ja     |
   | vom    | .      |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | V1      | 1           | 25          | !dontChange |
   | NEUPOS  | !dontChange | !dontChange | -10         |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "WG013" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE013"
And I set fields
   | nummer | 1WG013 |
   | ebeleg | WG013  |
   | such   | WG013  |
   | ueb    | ja     |
   | vom    | .      |
And I press button "offueb" in row 1
Then field "pwert" has value "-25.00" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
And I press button "offueb" in row 2
Then field "pwert" has value "10.00" in row 2
Then field "komplettgutschrift" has value "ja" in row 2
And I set field "pwert" to "0" in row 2
Then setting field "pwert" to "-2" in row 2 throws the exception "2158"
Then setting field "pwert" to "12" in row 2 throws the exception "11241"
And I set field "pwert" to "9" in row 2
Then field "komplettgutschrift" has value "nein" in row 2
Then field "vorganga" has value "Kaufmännische Gutschrift"
# Feld dfuesenden ist in Wertgutschrift nicht gesetzt und schreibgeschuetzt
Then field "dfuesenden" is not modifiable
Then field "dfuesenden" has value "nein"
And I set field "pwert" to "10" in row 2
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK-Wertgut-014 Wertgutschrift zu Rechnung mit einer negativer Gesamtsumme
# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "RE014" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE014 |
   | such   | RE014  |
   | kunde  | 1      |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | V1      | 2           | 25          | !dontChange |
   | TEXT    | !dontChange | !dontChange | -60         |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "WG014" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE014"
And I set fields
   | nummer | 1WG014 |
   | such   | WG014  |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
And I press button "komplettieren"
Then field "pwert" has value "-50.00" in row 1
Then field "pwert" has value "60.00" in row 2
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK-Wertgut-014 Wertgutschrift zu Rechnung mit einer negativen Gesamtsumme
# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "RE014" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE014 |
   | such   | RE014  |
   | ebeleg | RE014  |
   | lief   | 1      |
   | ueb    | ja     |
   | vom    | .      |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | V1      | 1           | 25          | !dontChange |
   | NEUPOS  | !dontChange | !dontChange | -30         |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "WG014" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE014"
And I set fields
   | nummer | 1WG014 |
   | ebeleg | WG014  |
   | such   | WG014  |
   | ueb    | ja     |
   | vom    | .      |
And I press button "komplettieren"
Then field "pwert" has value "-25.00" in row 1
Then field "pwert" has value "30.00" in row 2
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK - Wertgutschrift zu Rechnung in Fremdwaehrung
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE21" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| kunde | 1    |
	| such  | RE21 |
	| ueb   | ja   |
	| tterm | .    |
	| vom   | .    |
	| fakt  | ja   |
	| waehr | USD  |
And I append rows
	| artikel | mge   | preis | pwert |
	| EINK    | 5     | 8     | 40    |
Then field "kursumr" is modifiable
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Waehrungskurs auf 0,9 setzen
Given I open an editor "waehrung" from table "(ExchangeRate):(ExchangeRate)" with command "NEW" for record ""
And I set field "fwaehr" to "USD"
And I set field "ikurs" to "1.5"
And I save the current editor

Given I open an editor "WERT-ZU-RE21" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE21"
And I set fields
   | nummer | 21WERT     |
   | such   | VK-WERT21  |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
# Offene Menge uebernehmen
And I press button "offueb" in row 1
Then field "mge" has value "-5" in row 1
Then field "ewekurs" is not modifiable
Then field "kursumr" is not modifiable
Then field "kursumr" has value "nein"
Then field "kursfix" has value "ja"
Then field "ewekurs" has value "1.680000"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK - Fakturierung ueber den Lieferschein. Komplettwertgutschrift zu Rechnung und Korrekturrechnung buchen
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU22" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU22   |
   | kunde   | 1       |
   | such    | AU22    |
And I append rows
   | artikel | mge | preis |
   | E2      | 10  | 10    |
And I save the current editor

# Lieferschein
Given I open an editor "1LS22" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU22"
And I set fields
   | nummer | 1LS22  |
   | such   | LS22   |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE22" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS22"
And I set fields
   | nummer | 1RE22  |
   | such   | RE22   |
   | ueb    | ja     |
   | tterm  | .      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "1WG22" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE22"
And I set fields
   | nummer | 1WG22  |
   | such   | WG22   |
   | ueb    | ja     |
   | tterm  | .      |
And I set field "mge" to "-10" in row 1
And I save the current editor

Given I open an editor "1LS22V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "1LS22"
# Rechnungskorrektur fuer Lieferposition moeglich
Then field "rekorrektur" has value "ja" in row 1
And I close the current editor

# Rechnungskorrektur
Given I open an editor "1REK22" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS22"
And I set fields
   | nummer | 1REK22 |
   | such   | REK22  |
   | ueb    | ja     |
   | tterm  | .      |
# Position ist Rechnungskorrektur
Then field "rekorrektur" has value "ja" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "1LS22V2" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "1LS22"
# Rechnungskorrektur fuer Lieferposition erledigt
Then field "rekorrektur" has value "nein" in row 1
And I close the current editor

# Kennzeichen Rechnungskorrektur wird nicht kopiert
Given I open an editor "1REK22C" from table "(Sales):(Invoice)" with command "COPY" for record from editor "1REK22"
Then field "rekorrektur" has value "nein" in row 1
And I close the current editor

# Storno Rechnungskorrektur
Given I open an editor "1REK22S" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "1REK22"
And I set field "num3" to "1REK22S"
Then field "druck" is modifiable
Then field "rekorrektur" has value "ja" in row 1
And I save the current editor

Given I open an editor "1LS22V3" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "1LS22"
# Rechnungskorrektur fuer Lieferposition wieder moeglich
Then field "rekorrektur" has value "ja" in row 1
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK - Wertgutschrift zu Rechnung mit negativer Zusatzposition und Dienstleistung
# ----------------------------------------------------------------------------------------------

# Rechnung mit Lagerbewegung
Given I open an editor "1RE23" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE23  |
   | kunde  | 1      |
   | such   | RE23   |
   | ueb    | ja     |
   | tterm  | .      |
And I append rows
   | artikel | mge | preis |
   | E1      | 10  | 35    |
   | AUBEPOS | -3  |  5    |
   | DL-HANA | -1  | 20    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "1WG23" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE23"
And I set fields
   | nummer | 1WG23  |
   | such   | WG23   |
   | ueb    | ja     |
   | tterm  | .      |
Then the table has 6 rows
And I press button "komplettieren"
Then field "komplettgutschrift" has value "ja" in row 2
Then field "mge" has value "3" in row 2
# Gutzuschreibender Menge zu hoch.
Then setting field "mge" to "4" in row 2 throws the exception "2022"
# Negative Werte nicht erlaubt.
Then setting field "mge" to "-1" in row 2 throws the exception "2158"
And I set field "mge" to "2" in row 2
Then field "komplettgutschrift" has value "nein" in row 2
# Negativer Positionswert nicht erlaubt.
Then setting field "pwert" to "-10" in row 2 throws the exception "2158"
# Gutzuschreibender Positionswert zu hoch.
Then setting field "pwert" to "20" in row 2 throws the exception "11241"
And I set field "mge" to "3" in row 2
And I set field "pwert" to "15" in row 2
Then field "komplettgutschrift" has value "ja" in row 3
Then field "mge" has value "1" in row 3
# Gutzuschreibender Menge zu hoch.
Then setting field "mge" to "2" in row 3 throws the exception "2022"
# Negative Werte nicht erlaubt.
Then setting field "mge" to "-1" in row 3 throws the exception "2158"
# Negativer Positionswert nicht erlaubt.
Then setting field "pwert" to "-1" in row 3 throws the exception "2158"
# Gutzuschreibender Positionswert zu hoch.
Then setting field "pwert" to "21" in row 3 throws the exception "11241"
And I set field "pwert" to "15" in row 3
Then field "komplettgutschrift" has value "nein" in row 3
And I set field "pwert" to "20" in row 3
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK - Wertgutschrift zu Rechnung aus Auftrag mit negativer Zusatzposition und Dienstleistung
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU24" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU24   |
   | kunde   | 1       |
   | such    | AU24    |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | V1      | 10          | 50          | !dontChange |
   | AUBEPOS | -5          |  5          | !dontChange |
   | DL-HANA | -2          | 10          | !dontChange |
   | NEUPOS  | !dontChange | !dontChange | -12         |
   | TEXT    | !dontChange | !dontChange | -4          |
And I save the current editor

# Rechnung ohne Lagerbewegung (keine Bewertung ohne Lagerbewegung)
Given I open an editor "1RE24" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU24"
And I set fields
   | nummer | 1RE24  |
   | such   | RE24   |
   | ueb    | ja     |
   | tterm  | .      |
Then field "fakt" has value "nein"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I press button "offueb" in row 4
And I press button "offueb" in row 5
Then pressing button "burekorrektur" in row 0 throws the exception "203"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "1WG24" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE24"
And I set fields
   | nummer | 1WG24  |
   | such   | WG24   |
   | ueb    | ja     |
   | tterm  | .      |
Then the table has 8 rows
And I press button "komplettieren"
Then field "komplettgutschrift" has value "ja" in row 2
Then field "mge" has value "5" in row 2
Then field "komplettgutschrift" has value "ja" in row 3
Then field "mge" has value "2" in row 3
Then field "komplettgutschrift" has value "ja" in row 4
Then field "pwert" has value "12.00" in row 4
Then field "komplettgutschrift" has value "ja" in row 5
Then field "pwert" has value "4.00" in row 5
And I save the current editor

Given I open an editor "1AU24V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU24"
# Rechnungskorrektur fuer Auftragspositionen moeglich
Then field "rekorrektur" has value "ja" in row 1
Then field "remge" has value "10" in row 1
Then field "rekorrektur" has value "ja" in row 2
Then field "remge" has value "-5" in row 2
Then field "rekorrektur" has value "ja" in row 3
Then field "remge" has value "-2" in row 3
Then field "rekorrektur" has value "ja" in row 4
Then field "remge" has value "-12" in row 4
Then field "rekorrektur" has value "ja" in row 5
Then field "remge" has value "-4" in row 5
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK - Wertgutschrift zu Rechnung aus Lieferschein mit negativer Zusatzposition und Dienstleistung
# ----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS25" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 1LS25   |
   | kunde   | 1       |
   | such    | LS25    |
   | ueb     | ja      |
   | vom     | .       |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | E1      | 10          | 50          | !dontChange |
   | AUBEPOS | -5          |  5          | !dontChange |
   | DL-HANA | -2          | 10          | !dontChange |
   | NEUPOS  | !dontChange | !dontChange | -12         |
   | TEXT    | !dontChange | !dontChange | -4          |
And I save the current editor

# Rechnung
Given I open an editor "1RE25" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS25"
And I set fields
   | nummer | 1RE25  |
   | such   | RE25   |
   | ueb    | ja     |
   | tterm  | .      |
Then field "fakt" has value "nein"
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I press button "offueb" in row 4
And I press button "offueb" in row 5
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "1WG25" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE25"
And I set fields
   | nummer | 1WG25  |
   | such   | WG25   |
   | ueb    | ja     |
   | tterm  | .      |
Then the table has 8 rows
# Feld dfuesenden ist Wertgutschrift nicht gesetzt
Then field "dfuesenden" is not modifiable
Then field "dfuesenden" has value "nein"
And I press button "komplettieren"
Then field "komplettgutschrift" has value "ja" in row 1
Then field "artikel" has value "E1" in row 1
Then field "mge" has value "-10" in row 1
Then field "komplettgutschrift" has value "ja" in row 2
Then field "mge" has value "5" in row 2
Then field "komplettgutschrift" has value "ja" in row 3
Then field "mge" has value "2" in row 3
Then field "komplettgutschrift" has value "ja" in row 4
Then field "pwert" has value "12.00" in row 4
Then field "komplettgutschrift" has value "ja" in row 5
Then field "pwert" has value "4.00" in row 5
And I save the current editor

Given I open an editor "1LS25V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "1LS25"
# Rechnungskorrektur fuer Lieferscheinpositionen moeglich
Then field "rekorrektur" has value "ja" in row 1
Then field "remge" has value "10" in row 1
Then field "rekorrektur" has value "ja" in row 2
Then field "remge" has value "-5" in row 2
Then field "rekorrektur" has value "ja" in row 3
Then field "remge" has value "-2" in row 3
Then field "rekorrektur" has value "ja" in row 4
Then field "remge" has value "-12" in row 4
Then field "rekorrektur" has value "ja" in row 5
Then field "remge" has value "-4" in row 5
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK - Keine Wertgutschrift zu Rechnung aus Lieferschein mit Beschaffunsgart Umlagern
# ----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS26" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 1LS26   |
   | lief    | 1       |
   | such    | LS26    |
   | ueb     | ja      |
   | vom     | .       |
   | bsart   | Umlagern|
And I append rows
   | artikel | mge | preis | platz | abplatz |
   | E1      | 10  | 15    | L3F1  | F1      |
And I save the current editor

# Rechnung
Given I open an editor "1RE26" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS26"
And I set fields
   | nummer | 1RE26  |
   | such   | RE26   |
   | ueb    | ja     |
   | vom    | .      |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Keine Wertgutschrift moeglich
Given opening an editor from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE26" throws the exception "2619"

# ----------------------------------------------------------------------------------------------
Scenario: EK - Keine Wertgutschrift aus Rechnung mit Lagerbewegung aus Umlagerbestellung
# ----------------------------------------------------------------------------------------------

Given I open an editor "1BE27" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE27   |
   | lief    | 1       |
   | such    | BE27    |
   | vom     | .       |
   | bsart   | Umlagern|
And I append rows
   | artikel | mge | preis | platz | abplatz |
   | E2      | 10  | 10    | L3F1  | F1      |
And I save the current editor

Given I open an editor "1RE27" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE27"
And I set fields
   | nummer | 1RE27  |
   | such   | RE27   |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | ja     |
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Keine Wertgutschrift moeglich
Given opening an editor from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE27" throws the exception "2619"

# ----------------------------------------------------------------------------------------------
Scenario: EK - Keine Wertgutschrift aus Umlagerungsrechnung mit Lagerbewegung
# ----------------------------------------------------------------------------------------------

Given I open an editor "1RE28" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer  | 1RE28   |
   | lief    | 1       |
   | such    | RE28    |
   | fakt    | ja      |
   | bsart   | Umlagern|
   | ueb     | ja      |
   | vom     | .       |
And I append rows
   | artikel | mge | preis | platz | abplatz |
   | V1      | 10  | 30    | L3F1  | F1      |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given opening an editor from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE28" throws the exception "2619"


# ----------------------------------------------------------------------------------------------
Scenario: EK - Beleg anfuegen bei Wertgutschrift nicht erlaubt
# ----------------------------------------------------------------------------------------------

# Lieferschein
Given I open an editor "1LS29" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 1LS29   |
   | lief    | 1       |
   | such    | LS29    |
   | ueb     | ja      |
   | vom     | .       |
And I append rows
   | artikel | mge | preis |
   | E1      | 10  | 15    |
   | E2      | 10  | 20    |
   | V1      | 10  | 100   |
And I save the current editor

# 1. Rechnung
Given I open an editor "1RE29A" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS29"
And I set fields
   | nummer | 1RE29A |
   | such   | RE29A  |
   | ueb    | ja     |
   | vom    | .      |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I delete row at position 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Rechnung
Given I open an editor "1RE29B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS29"
And I set fields
   | nummer | 1RE29B |
   | such   | RE29B  |
   | ueb    | ja     |
   | vom    | .      |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "1WG29" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE29A"
And I set fields
   | nummer | 1WG29  |
   | such   | WG29   |
   | ueb    | ja     |
   | vom    | .      |
And I press button "offueb" in row 1
And I delete row at position 2
And setting field "beleg" to "+1RE29A" throws the exception "6822"
And setting field "beleg" to "+1RE29B" throws the exception "6822"
And I press button "komplettieren"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - RE+LB mehrfach gutschreiben und Rechnungskorrektur erstellen
# ----------------------------------------------------------------------------------------------
Given I open an editor "RE30" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| kunde | 1    |
	| such  | RE30 |
	| ueb   | ja   |
	| tterm | .    |
	| vom   | .    |
	| fakt  | ja   |
And I append rows
	| artikel  | mge         | preis       | proz       | pwert      |
	| V1       | 10          | 8           |!dontChange |!dontChange |
	| !TECH006 | 6           | 7           |!dontChange |!dontChange |
	| PR.      | !dontChange | !dontChange |         10 |!dontChange |
	| V2       | 12          | 6           |!dontChange |!dontChange |
	| TEXT     | !dontChange | !dontChange |!dontChange |        100 |
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
Then I append text "Rechnung mit 3 Positionen und abhaengigen Preisfindungspositionen" to output file "cucumber/refs/wertgutschrift.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettgutschrift der ersten Position (V1) und der Textposition
Given I open an editor "WGS30A" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE30"
And I set fields
   | such   | WGS30A     |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
And I set field "mge" to "-10" in row 1
And I set field "pwert" to "-100" in row 6
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
Then I append text "Komplettgutschrift der 1. Position und Textposition" to output file "cucumber/refs/wertgutschrift.out"
And I save the current editor

# TWGS der zweiten Position (TECH006)
Given I open an editor "WGS30B" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE30"
And I set fields
   | such   | WGS30B     |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
And I set field "mge" to "-4" in row 2
Then saving the current editor throws the exception "6825"
And I press button "buwertgutschrift"
Then field "artikel" has value "TECH006" in row 1
And I set field "mge" to "-4" in row 1
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
Then I append text "Gutschrift der 2. Position - Rechnungskorrekturposition und Textposition wurde ausgeblendet" to output file "cucumber/refs/wertgutschrift.out"
And I save the current editor

# Teilrechnungskorrektur zur ersten Position (V1)
Given I open an editor "WGS30ARK" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE30"
And I set fields
   | such   | REK30      |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
And I press button "burekorrektur"
Then field "artikel" has value "V1" in row 1
And I set field "mge" to "4" in row 1
And I set field "pwert" to "17" in row 2
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift.out"
Then I append text "Rechnungskorrektur der 1. Position und Textposition - WG-Positionen wurden inklusive Preisfindungspositionen ausgeblendet" to output file "cucumber/refs/wertgutschrift.out"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-RE+LB-TWGS-TWGS Offene Menge uebertragen
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE31" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| kunde        | 1      |
	| such         | RE31   |
	| ueb          | ja     |
	| tterm        | .      |
	| vom          | .      |
	| fakt         | ja     |
And I append rows
   | artikel      | mge         | preis       | pwert       | proz        |
   | V1           |         100 |         100 | !dontChange | !dontChange |
   | TEXT         | !dontChange | !dontChange |      100.00 | !dontChange |
   | dl-reparatur |           2 |       50.00 | !dontChange | !dontChange |
   | AUBEPOS      |          10 |        7.00 | !dontChange | !dontChange |
   | NEUPOS       | !dontChange | !dontChange |      200.00 | !dontChange |
   | PR.          | !dontChange | !dontChange | !dontChange | -1          |

And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# TWGS 1
Given I open an editor "WG31" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE31"
And I set fields
   | such   | WG31 |
   | ueb    | ja   |
   | tterm  | .    |
   | budat  | .    |

And I set field "mge" to "-80" in row 1
And I set field "pwert" to "-20" in row 2
And I set field "mge" to "-1" in row 3
And I set field "mge" to "-6" in row 4
And I set field "pwert" to "-70" in row 5

 Then table has values
   | artikel      | mge | preis   | proz | ofwert    | pwert    |
   | V1           | -80 |   100.00 | 0   | -10000.00 | -8000.00 |
   | TEXT         |   0 |     0.00 | 0   |   -100.00 |   -20.00 |
   | DL-REPARATUR |  -1 |    50.00 | 0   |   -100.00 |   -50.00 |
   | AUBEPOS      |  -6 |     7.00 | 0   |    -70.00 |   -42.00 |
   | NEUPOS       |   0 |     0.00 | 0   |   -200.00 |   -70.00 |
   | PR.          |   0 |   -70.00 | -1  |      2.00 |     0.70 |
   | NS.          |   0 |     0.00 | 0   |      0.00 | -8181.30 |
   | ST.          |   0 | -8181.30 | 15  |      0.00 | -1227.20 |
   | ES.          |   0 |     0.00 | 0   |      0.00 | -9408.50 |
And I save the current editor

# TWGS 2 mit offene Mengen uebertragen
Given I open an editor "WG31" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE31"
And I set fields
   | such   | WG31B |
   | ueb    | ja    |
   | tterm  | .     |
   | budat  | .     |

And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I press button "offueb" in row 4
And I press button "offueb" in row 5

 Then table has values
   | artikel      | mge  | preis    | proz | ofwert    | pwert    |
   | V1           | -100 |   100.00 |  -80 |  -2000.00 | -2000.00 |
   | TEXT         |    0 |     0.00 |    0 |    -80.00 |   -80.00 |
   | DL-REPARATUR |   -2 |    50.00 |  -50 |    -50.00 |   -50.00 |
   | AUBEPOS      |  -10 |     7.00 |  -60 |    -28.00 |   -28.00 |
   | NEUPOS       |    0 |     0.00 |    0 |   -130.00 |  -130.00 |
   | PR.          |    0 |  -130.00 |   -1 |      1.30 |     1.30 |
   | NS.          |    0 |     0.00 |    0 |      0.00 | -2286.70 |
   | ST.          |    0 | -2286.70 |   15 |      0.00 |  -343.01 |
   | ES.          |    0 |     0.00 |    0 |      0.00 | -2629.71 |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-Wertgut-33: Rechnung mit Artikel samt Anzahlungsrechnung -> Wertgutschrift
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU033" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU033 |
   | kunde   | 1      |
   | such    | AU033  |
And I append rows
   | artikel | mge    |
   | V1      | 50     |
And I press button "fktaplanabsteigen" to open a subeditor for "ANZ_RE"
And I append rows
| reart     | anzpwert | ptext        | zbed |
| Anzahlung | 100      | 1. Anzahlung | 201  |
| Anzahlung | 200      | 2. Anzahlung | 201  |
And I press button "anzahlungsrechn" to open a subeditor for "anz1_re" in row 1
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "ANZ_RE"
And I press button "anzahlungsrechn" to open a subeditor for "anz2_re" in row 2
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I switch the current editor to editor "ANZ_RE"
And I save the current editor
And I switch the current editor to editor "AU033"
And I save the current editor

# Rechnung mit Lagerbewegung
Given I open an editor "RE033" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU033"
And I set fields
   | nummer | 1RE033  |
   | such   | RE033   |
   | ueb    | ja      |
   | tterm  | .       |
   | zbed   | 201     |
And I set field "reanzpossteuer" to "ja"
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# Anzahl Tabellenzeilen pruefen
Given I open an editor "RE033_VIEW" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE033"
Then the table has 9 rows
And I close the current editor

# Wertgutschrift: RE -> RE
Given I open an editor "1WG033" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE033"
And I set fields
   | nummer | 1WG033  |
   | such   | WG033   |
   | ueb    | ja      |
   | tterm  | .       |
Then field "reanzpossteuer" has value "ja"
Then the table has 9 rows
# Steuerpositionen aus Rechnung sind uebernommen?
Then field "artikel" has value "ST." in row 3
Then field "artikel" has value "ST." in row 6
Then field "artikel" has value "ST." in row 8
And I press button "offueb" in row 1
# Anzahlung 1
And I press button "offueb" in row 5
# Anzahlung 2
And I press button "offueb" in row 7
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK - Wertgutschrift aus Rechnungskorrektur - Fakturieren ueber Lieferschein
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "BE41" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE41   |
   | lief    | 1       |
   | such    | BE41    |
And I append rows
   | artikel | mge | preis |
   | E1      | 20  | 10    |
And I save the current editor

# Lieferschein
Given I open an editor "LS41" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE41"
And I set fields
   | nummer | 1LS41  |
   | such   | LS41   |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE41" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS41"
And I set fields
   | nummer | 1RE41  |
   | such   | RE41   |
   | ebeleg | RE41   |
   | ueb    | ja     |
   | vom    | .      |
Then field "artikel" has value "E1" in row 1
# fuer die Pruefung der Bewertungsdaten nach Storno WGS ist eine zum LS abweichender RE-preis notwendig:
And I set field "preis" to "14" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "WG41" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE41"
And I set fields
   | nummer | 1WG41  |
   | such   | WG41   |
   | ebeleg | WG41   |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "-10" in row 1
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "LS41" is not filed
Then field "rekorrektur" from editor "LS41" in row 1 has value "ja"
Then field "remge" from editor "LS41" in row 1 has value "10"
Then field "lifrg" from editor "LS41" in row 1 has value "10"

# Rechnungskorrektur
Given I open an editor "RK41" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS41"
And I set fields
   | nummer | 1RK41  |
   | such   | RK41   |
   | ebeleg | RK41   |
   | ueb    | ja     |
   | vom    | .      |
Then field "artikel" has value "E1" in row 1
# fuer die Pruefung der Bewertungsdaten nach Storno WGS ist eine zum LS abweichender RE-preis notwendig:
And I set field "preis" to "13" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "LS41" is filed
Then field "rekorrektur" from editor "LS41" in row 1 has value "nein"
Then field "remge" from editor "LS41" in row 1 has value "0"
Then field "lifrg" from editor "LS41" in row 1 has value "10"
Then field "rekorrektur" from editor "RK41" in row 1 has value "ja"

# Komplettwertgutschrift
Given I open an editor "WG41K" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RK41"
And I set fields
   | nummer | 1WG41K  |
   | such   | WG41K   |
   | ebeleg | WG41K   |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 4 rows
Then field "rekorrektur" has value "nein" in row 1
And I set field "mge" to "-10" in row 1
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "LS41" is not filed
Then field "rekorrektur" from editor "LS41" in row 1 has value "ja"
Then field "remge" from editor "LS41" in row 1 has value "10"
Then field "lifrg" from editor "LS41" in row 1 has value "10"

Then field "rekorrektur" from editor "RK41" in row 1 has value "ja"
Then field "remge" from editor "RK41" in row 1 has value "0"

# Storno der Wertgutschrift 2
Given I open an editor "ST_WG41K" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WG41K"
Then field "druck" is modifiable
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "LS41" is filed
Then field "rekorrektur" from editor "LS41" in row 1 has value "nein"
Then field "remge" from editor "LS41" in row 1 has value "0"
Then field "lifrg" from editor "LS41" in row 1 has value "10"

Then field "rekorrektur" from editor "RK41" in row 1 has value "ja"
Then field "remge" from editor "RK41" in row 1 has value "-10"

# Storno der Rechnungskorrektur
Given I open an editor "ST_RK41" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RK41"
Then field "druck" is modifiable
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "LS41" is not filed
Then field "rekorrektur" from editor "LS41" in row 1 has value "ja"
Then field "remge" from editor "LS41" in row 1 has value "10"
Then field "lifrg" from editor "LS41" in row 1 has value "10"

# ---------------------------------------------------------------------------------------------------
Scenario Outline: Artikel V1 mit Bestand versorgen, damit in folgenden Abgaengen Bewertungsorigs zur Verfuegung stehen
# ---------------------------------------------------------------------------------------------------
Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
	| artikel	| <artikel>   |
	| buart		| Zugang      |
	| beleg		| v1-bestand  |
	| beldat	| .           |
	| wert		| <wert>      |
And I append rows
	| mge   | platz2  | verw      |
	| <mge> | <platz> | <verw>    |
And I save the current editor

Examples:
	| artikel | wert	| mge	| platz | verw |
	| V1      | 3		| 100	| F1	|      |

# ----------------------------------------------------------------------------------------------
Scenario: VK - Wertgutschrift aus Rechnungskorrektur - Fakturieren ueber Auftrag
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU42" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU42   |
   | kunde   | 1       |
   | such    | AU42    |
And I append rows
   | artikel | mge | preis |
   | V1      | 10  | 50    |
And I save the current editor

# Lieferschein
Given I open an editor "LS42" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU42"
And I set fields
   | nummer | 1LS42  |
   | such   | LS42   |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | nein   |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE42" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU42"
And I set fields
   | nummer | 1RE42  |
   | such   | RE42   |
   | ueb    | ja     |
   | tterm  | .      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "WG42" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE42"
And I set fields
   | nummer | 1WG42      |
   | such   | WG42       |
   | ueb    | ja         |
   | tterm  | .          |
   | vom    | .          |
   | budat  | .          |
And I press button "offueb" in row 1
And I save the current editor

Then field "rekorrektur" from editor "AU42" in row 1 has value "ja"
Then field "remge" from editor "AU42" in row 1 has value "10"
Then field "lifrg" from editor "AU42" in row 1 has value "0"

# Rechnungskorrektur
Given I open an editor "RK42" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU42"
And I set fields
   | nummer | 1RK42  |
   | such   | RK42   |
   | ueb    | ja     |
   | tterm  | .      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "AU42" in row 1 has value "nein"
Then field "remge" from editor "AU42" in row 1 has value "0"
Then field "lifrg" from editor "AU42" in row 1 has value "0"

# Wertgutschrift kann nicht storniert werden, da Rechnungskorrektur vorhanden ist
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG42" throws the exception "3335"

# Wertgutschrift aus Rechnungskorrektur RK42
Given I open an editor "WG42K" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RK42"
And I set fields
   | nummer | 1WG42K     |
   | such   | WG42K      |
   | ueb    | ja         |
   | tterm  | .          |
   | vom    | .          |
   | budat  | .          |
Then the table has 4 rows
Then field "rekorrektur" has value "nein" in row 1
And I press button "offueb" in row 1
And I save the current editor

Then field "rekorrektur" from editor "AU42" in row 1 has value "ja"
Then field "remge" from editor "AU42" in row 1 has value "10"
Then field "lifrg" from editor "AU42" in row 1 has value "0"

Then field "rekorrektur" from editor "RK42" in row 1 has value "ja"
Then field "remge" from editor "RK42" in row 1 has value "0"

# Storno der Wertgutschrift 2
Given I open an editor "ST_WG42K" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG42K"
Then field "druck" is modifiable
And I save the current editor

Then "(Sales):(SalesOrder)" with the editor id "AU42" is filed
Then field "rekorrektur" from editor "AU42" in row 1 has value "nein"
Then field "remge" from editor "AU42" in row 1 has value "0"
Then field "lifrg" from editor "AU42" in row 1 has value "0"

Then field "rekorrektur" from editor "RK42" in row 1 has value "ja"
Then field "remge" from editor "RK42" in row 1 has value "-10"

# Storno der Rechnungskorrektur
Given I open an editor "ST_RK42" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RK42"
Then field "druck" is modifiable
And I save the current editor

Then "(Sales):(SalesOrder)" with the editor id "AU42" is not filed
Then field "rekorrektur" from editor "AU42" in row 1 has value "ja"
Then field "remge" from editor "AU42" in row 1 has value "10"
Then field "lifrg" from editor "AU42" in row 1 has value "0"


# ----------------------------------------------------------------------------------------------
Scenario: EK - Wertgutschrift aus Rechnungskorrektur - Rechnung mit Lagerbewegung
# ----------------------------------------------------------------------------------------------

# Rechnung mit Lagerbewegung
Given I open an editor "RE43" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE43  |
   | lief   | 1      |
   | such   | RE43   |
   | ebeleg | RE43   |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | ja     |
And I append rows
   | artikel | mge | preis |
   | V1      | 50  | 12    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "WG43" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE43"
And I set fields
   | nummer | 1WG43  |
   | such   | WG43   |
   | ebeleg | WG43   |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "-50" in row 1
And I save the current editor

Then field "rekorrektur" from editor "RE43" in row 1 has value "ja"
Then field "remge" from editor "RE43" in row 1 has value "50"
Then field "lifrg" from editor "RE43" in row 1 has value "-50"

# Rechnungskorrektur
Given I open an editor "RK43" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE43"
And I set fields
   | nummer | 1RK43  |
   | such   | RK43   |
   | ebeleg | RK43   |
   | ueb    | ja     |
   | vom    | .      |
And I press button "burekorrektur"
And I set field "mge" to "50" in row 1
And I save the current editor

Then field "rekorrektur" from editor "RE43" in row 1 has value "nein"
Then field "remge" from editor "RE43" in row 1 has value "0"
Then field "lifrg" from editor "RE43" in row 1 has value "-50"

# Weitere Rechnungskorrektur nicht moeglich
Given opening an editor from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE43" throws the exception "2620"

# Wertgutschrift kann nicht storniert werden, da Rechnungskorrektur vorhanden ist
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WG43" throws the exception "3335"

# Wertgutschrift aus Rechnungskorrektur
Given I open an editor "WG43K" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RK43"
And I set fields
   | nummer | 1WG43K  |
   | such   | WG43K   |
   | ebeleg | WG43K   |
   | ueb    | ja      |
   | vom    | .       |
And I press button "buwertgutschrift"
Then the table has 4 rows
Then field "rekorrektur" has value "nein" in row 1
And I set field "mge" to "-50" in row 1
And I save the current editor

Then field "rekorrektur" from editor "RE43" in row 1 has value "ja"
Then field "remge" from editor "RE43" in row 1 has value "50"
Then field "lifrg" from editor "RE43" in row 1 has value "-50"

Then field "rekorrektur" from editor "RK43" in row 1 has value "ja"
Then field "remge" from editor "RK43" in row 1 has value "0"

# Storno der Wertgutschrift 2
Given I open an editor "ST_WG43K" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WG43K"
And I save the current editor

Then field "rekorrektur" from editor "RE43" in row 1 has value "nein"
Then field "remge" from editor "RE43" in row 1 has value "0"
Then field "lifrg" from editor "RE43" in row 1 has value "-50"

Then field "rekorrektur" from editor "RK43" in row 1 has value "ja"
Then field "remge" from editor "RK43" in row 1 has value "-50"

# Storno der Rechnungskorrektur
Given I open an editor "ST_RK43" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RK43"
And I save the current editor

Then field "rekorrektur" from editor "RE43" in row 1 has value "ja"
Then field "remge" from editor "RE43" in row 1 has value "50"
Then field "lifrg" from editor "RE43" in row 1 has value "-50"

# Storno der 1. Komplettwertgutschrift
Given I open an editor "ST_WG43" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WG43"
Then field "druck" is modifiable
And I save the current editor

Then field "rekorrektur" from editor "RE43" in row 1 has value "nein"
Then field "remge" from editor "RE43" in row 1 has value "-50"
Then field "lifrg" from editor "RE43" in row 1 has value "-50"

# Neue Komplettwertgutschrift
Given I open an editor "WG43" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE43"
And I set fields
   | nummer | 1WG43N |
   | such   | WG43N  |
   | ebeleg | WG43N  |
   | ueb    | ja     |
   | vom    | .      |
And I press button "komplettieren"
And I save the current editor

Then field "rekorrektur" from editor "RE43" in row 1 has value "ja"
Then field "remge" from editor "RE43" in row 1 has value "50"
Then field "lifrg" from editor "RE43" in row 1 has value "-50"

# ----------------------------------------------------------------------------------------------
Scenario: VK - Wertgutschrift aus Rechnungskorrektur - Rechnung mit Lagerbewegung
# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "RE44" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE44  |
   | kunde  | 1      |
   | such   | RE44   |
   | ueb    | ja     |
   | tterm  | .      |
   | fakt   | ja     |
And I append rows
   | artikel | mge | preis |
   | V1      | 50  | 12    |
Then field "ofmge" has value "-50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "WG44" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE44"
And I set fields
   | nummer | 1WG44      |
   | such   | WG44       |
   | ueb    | ja         |
   | tterm  | .          |
   | vom    | .          |
   | budat  | .          |
And I press button "komplettieren"
And I save the current editor

Then field "rekorrektur" from editor "RE44" in row 1 has value "ja"
Then field "remge" from editor "RE44" in row 1 has value "50"
Then field "lifrg" from editor "RE44" in row 1 has value "-50"

# Rechnungskorrektur
Given I open an editor "RK44" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE44"
And I set fields
   | nummer | 1RK44      |
   | such   | RK44       |
   | ueb    | ja         |
   | tterm  | .          |
   | vom    | .          |
   | budat  | .          |
And I press button "burekorrektur"
And I press button "offueb" in row 1
And I save the current editor

Then field "rekorrektur" from editor "RE44" in row 1 has value "nein"
Then field "remge" from editor "RE44" in row 1 has value "0"
Then field "lifrg" from editor "RE44" in row 1 has value "-50"

# Weitere Rechnungskorrektur nicht moeglich
Given opening an editor from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE44" throws the exception "2620"

# Wertgutschrift kann nicht storniert werden, da Rechnungskorrektur vorhanden ist
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG44" throws the exception "3335"

# Wertgutschrift aus Rechnungskorrektur
Given I open an editor "WG44K" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RK44"
And I set fields
   | nummer | 1WG44K     |
   | such   | WG44K      |
   | ueb    | ja         |
   | tterm  | .          |
   | vom    | .          |
   | budat  | .          |
And I press button "buwertgutschrift"
Then the table has 4 rows
Then field "rekorrektur" has value "nein" in row 1
And I press button "offueb" in row 1
And I save the current editor

Then field "rekorrektur" from editor "RE44" in row 1 has value "ja"
Then field "remge" from editor "RE44" in row 1 has value "50"
Then field "lifrg" from editor "RE44" in row 1 has value "-50"

Then field "rekorrektur" from editor "RK44" in row 1 has value "ja"
Then field "remge" from editor "RK44" in row 1 has value "0"

# Rechnung kann nicht storniert werden, da Wertgutschrift vorhanden ist
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE44" throws the exception "6729"

# Storno der Wertgutschrift 2
Given I open an editor "ST_WG44K" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG44K"
And I save the current editor

Then field "rekorrektur" from editor "RE44" in row 1 has value "nein"
Then field "remge" from editor "RE44" in row 1 has value "0"
Then field "lifrg" from editor "RE44" in row 1 has value "-50"

Then field "rekorrektur" from editor "RK44" in row 1 has value "ja"
Then field "remge" from editor "RK44" in row 1 has value "-50"

# Storno der Rechnungskorrektur
Given I open an editor "ST_RK44" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RK44"
And I save the current editor

# Then field "rekorrektur" from editor "RE44" in row 1 has value "ja"
Then field "remge" from editor "RE44" in row 1 has value "50"
Then field "lifrg" from editor "RE44" in row 1 has value "-50"

# ----------------------------------------------------------------------------------------------
Scenario: EK - Wertgutschrift aus Rechnungskorrektur - Fakturieren ueber Bestellung
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "BE45" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE45   |
   | lief    | 1       |
   | such    | BE45    |
And I append rows
   | artikel | mge | preis |
   | E1      | 30  | 10    |
And I save the current editor

# Lieferschein
Given I open an editor "LS45" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE45"
And I set fields
   | nummer | 1LS45  |
   | such   | LS45   |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | nein   |
And I set field "mge" to "30" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE45" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE45"
And I set fields
   | nummer | 1RE45  |
   | such   | RE45   |
   | ebeleg | RE45   |
   | ueb    | ja     |
   | vom    | .      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "WG45" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE45"
And I set fields
   | nummer | 1WG45  |
   | such   | WG45   |
   | ebeleg | WG45   |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "-30" in row 1
And I save the current editor

Then "(Purchasing):(PurchaseOrder)" with the editor id "BE45" is not filed
Then field "rekorrektur" from editor "BE45" in row 1 has value "ja"
Then field "remge" from editor "BE45" in row 1 has value "30"
Then field "lifrg" from editor "BE45" in row 1 has value "0"

# Rechnungskorrektur
Given I open an editor "RK45" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE45"
And I set fields
   | nummer | 1RK45  |
   | such   | RK45   |
   | ebeleg | RK45   |
   | ueb    | ja     |
   | vom    | .      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Purchasing):(PurchaseOrder)" with the editor id "BE45" is filed
Then field "rekorrektur" from editor "BE45" in row 1 has value "nein"
Then field "remge" from editor "BE45" in row 1 has value "0"
Then field "lifrg" from editor "BE45" in row 1 has value "0"

# Wertgutschrift kann nicht storniert werden, da Rechnungskorrektur vorhanden ist
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WG45" throws the exception "3335"

# Komplettwertgutschrift
Given I open an editor "WG45K" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RK45"
And I set fields
   | nummer | 1WG45K  |
   | such   | WG45K   |
   | ebeleg | WG45K   |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 4 rows
Then field "rekorrektur" has value "nein" in row 1
And I set field "mge" to "-30" in row 1
And I save the current editor

Then "(Purchasing):(PurchaseOrder)" with the editor id "BE45" is not filed
Then field "rekorrektur" from editor "BE45" in row 1 has value "ja"
Then field "remge" from editor "BE45" in row 1 has value "30"
Then field "lifrg" from editor "BE45" in row 1 has value "0"

Then field "rekorrektur" from editor "RK45" in row 1 has value "ja"
Then field "remge" from editor "RK45" in row 1 has value "0"

# Storno der Wertgutschrift 2
Given I open an editor "ST_WG45K" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WG45K"
And I save the current editor

Then "(Purchasing):(PurchaseOrder)" with the editor id "BE45" is filed
Then field "rekorrektur" from editor "BE45" in row 1 has value "nein"
Then field "remge" from editor "BE45" in row 1 has value "0"
Then field "lifrg" from editor "BE45" in row 1 has value "0"

Then field "rekorrektur" from editor "RK45" in row 1 has value "ja"
Then field "remge" from editor "RK45" in row 1 has value "-30"

# Storno der Rechnungskorrektur
Given I open an editor "ST_RK45" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RK45"
And I save the current editor

Then "(Purchasing):(PurchaseOrder)" with the editor id "BE45" is not filed
Then field "rekorrektur" from editor "BE45" in row 1 has value "ja"
Then field "remge" from editor "BE45" in row 1 has value "30"
Then field "lifrg" from editor "BE45" in row 1 has value "0"

# ----------------------------------------------------------------------------------------------
Scenario: VK - Wertgutschrift aus Rechnungskorrektur - Fakturieren ueber Lieferschein
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU46" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU46   |
   | kunde   | 1       |
   | such    | AU46    |
And I append rows
   | artikel | mge | preis |
   | V1      | 10  | 50    |
And I save the current editor

# Lieferschein
Given I open an editor "LS46" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU46"
And I set fields
   | nummer | 1LS46  |
   | such   | LS46   |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | ja     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE46" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS46"
And I set fields
   | nummer | 1RE46  |
   | such   | RE46   |
   | ueb    | ja     |
   | tterm  | .      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "WG46" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE46"
And I set fields
   | nummer | 1WG46      |
   | such   | WG46       |
   | ueb    | ja         |
   | tterm  | .          |
   | vom    | .          |
   | budat  | .          |
And I press button "offueb" in row 1
And I save the current editor

Then "(Sales):(PackingSlip)" with the editor id "LS46" is not filed
Then field "rekorrektur" from editor "LS46" in row 1 has value "ja"
Then field "remge" from editor "LS46" in row 1 has value "10"
Then field "lifrg" from editor "LS46" in row 1 has value "0"

# Rechnungskorrektur
Given I open an editor "RK46" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS46"
And I set fields
   | nummer | 1RK46  |
   | such   | RK46   |
   | ueb    | ja     |
   | tterm  | .      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then "(Sales):(PackingSlip)" with the editor id "LS46" is filed
Then field "rekorrektur" from editor "LS46" in row 1 has value "nein"
Then field "remge" from editor "LS46" in row 1 has value "0"
Then field "lifrg" from editor "LS46" in row 1 has value "0"

# Wertgutschrift kann nicht storniert werden, da Rechnungskorrektur vorhanden ist
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG46" throws the exception "3335"

# Wertgutschrift aus Rechnungskorrektur
Given I open an editor "WG46K" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RK46"
And I set fields
   | nummer | 1WG46K     |
   | such   | WG46K      |
   | ueb    | ja         |
   | tterm  | .          |
   | vom    | .          |
   | budat  | .          |
Then the table has 4 rows
Then field "rekorrektur" has value "nein" in row 1
And I press button "offueb" in row 1
And I save the current editor

Then "(Sales):(PackingSlip)" with the editor id "LS46" is not filed
Then field "rekorrektur" from editor "LS46" in row 1 has value "ja"
Then field "remge" from editor "LS46" in row 1 has value "10"
Then field "lifrg" from editor "LS46" in row 1 has value "0"

Then field "rekorrektur" from editor "RK46" in row 1 has value "ja"
Then field "remge" from editor "RK46" in row 1 has value "0"

# Storno der Wertgutschrift 2
Given I open an editor "ST_WG46K" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG46K"
And I save the current editor

Then "(Sales):(PackingSlip)" with the editor id "LS46" is filed
Then field "rekorrektur" from editor "LS46" in row 1 has value "nein"
Then field "remge" from editor "LS46" in row 1 has value "0"
Then field "lifrg" from editor "LS46" in row 1 has value "0"

Then field "rekorrektur" from editor "RK46" in row 1 has value "ja"
Then field "remge" from editor "RK46" in row 1 has value "-10"

# Storno der Rechnungskorrektur
Given I open an editor "ST_RK46" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RK46"
And I save the current editor

Then "(Sales):(PackingSlip)" with the editor id "LS46" is not filed
Then field "rekorrektur" from editor "LS46" in row 1 has value "ja"
Then field "remge" from editor "LS46" in row 1 has value "10"
Then field "lifrg" from editor "LS46" in row 1 has value "0"

# ----------------------------------------------------------------------------------------------
Scenario: EK - Wertgutschrift aus Rechnungskorrektur und Storno - Rechnung mit Lagerbewegung
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "BE47" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE47   |
   | lief    | 1       |
   | such    | BE47    |
And I append rows
   | artikel | mge | preis |
   | E1      | 25  | 6     |
   | V1      | 2   | 35    |
And I save the current editor

# Rechnung mit Lagerbewegung aus Bestellung
Given I open an editor "RE47" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE47"
And I set fields
   | nummer | 1RE47  |
   | such   | RE47   |
   | ebeleg | RE47   |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | ja     |
And I set field "mge" to "25" in row 1
And I set field "mge" to "2" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "RE47" in row 1 has value "-25"
Then field "lifrg" from editor "RE47" in row 1 has value "0"

# Komplettwertgutschrift fuer erste Position
Given I open an editor "WG47" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE47"
And I set fields
   | nummer | 1WG47  |
   | such   | WG47   |
   | ebeleg | WG47   |
   | ueb    | ja     |
   | vom    | .      |
And I press button "offueb" in row 1
And I set field "mge" to "-1" in row 2
And I save the current editor

Then field "rekorrektur" from editor "RE47" in row 1 has value "ja"
Then field "remge" from editor "RE47" in row 1 has value "25"
Then field "lifrg" from editor "RE47" in row 1 has value "0"

# Rechnungskorrektur
Given I open an editor "RK47" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE47"
And I set fields
   | nummer | 1RK47  |
   | such   | RK47   |
   | ebeleg | RK47   |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "-1" in row 2
Then saving the current editor throws the exception "6825"
And I press button "burekorrektur"
And I set field "mge" to "25" in row 1
And I save the current editor

Then field "rekorrektur" from editor "RE47" in row 1 has value "nein"
Then field "remge" from editor "RE47" in row 1 has value "0"
Then field "lifrg" from editor "RE47" in row 1 has value "0"

# Wertgutschrift kann nicht storniert werden, da Rechnungskorrektur vorhanden ist
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WG47" throws the exception "3335"

# Storno der Rechnungskorrektur
Given I open an editor "ST_RK47" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RK47"
And I save the current editor

Then field "rekorrektur" from editor "RE47" in row 1 has value "ja"
Then field "remge" from editor "RE47" in row 1 has value "25"
Then field "lifrg" from editor "RE47" in row 1 has value "0"


# ----------------------------------------------------------------------------------------------
Scenario: VK - Wertgutschrift darf nicht storniert werden: es ist eine Rechnungskorrektur vorhanden
# SWG1
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU48" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU48 |
   | kunde   | 1     |
   | such    | AU48  |
And I append rows
   | artikel | mge | preis |
   | V1      | 10  | 50    |
And I save the current editor

# Lieferschein
Given I open an editor "LS48" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU48"
And I set fields
   | nummer | 1LS48 |
   | such   | LS48  |
   | ueb    | ja    |
   | vom    | .     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE48" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS48"
And I set fields
   | nummer | 1RE48 |
   | such   | RE48  |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "WG48" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE48"
And I set fields
   | nummer | 1WG48 |
   | such   | WG48  |
   | ueb    | ja    |
   | tterm  | .     |
   | vom    | .     |
   | budat  | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnungskorrektur
Given I open an editor "RK48" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS48"
And I set fields
   | nummer | 1RK48 |
   | such   | RK48  |
   | ueb    | ja    |
   | tterm  | .     |
And I set field "mge" to "6" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift kann nicht storniert werden, da Rechnungskorrektur vorhanden ist
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG48" throws the exception "3335"

# Storno der Rechnungskorrektur
Given I open an editor "ST_RK48" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RK48"
And I save the current editor

# Storno der Wertgutschrift nun erlaubt
Given I open an editor "ST_WG48" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG48"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK - Rechnung darf nicht storniert werden: es ist eine Rechnungskorrektur vorhanden
# SWG2
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU49" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU49 |
   | kunde   | 1     |
   | such    | AU49  |
And I append rows
   | artikel | mge | preis |
   | V1      | 20  | 50    |
And I save the current editor

# Lieferschein
Given I open an editor "LS49" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU49"
And I set fields
   | nummer | 1LS49 |
   | such   | LS49  |
   | ueb    | ja    |
   | vom    | .     |
And I set field "mge" to "20" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE49" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS49"
And I set fields
   | nummer | 1RE49 |
   | such   | RE49  |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "WG49" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE49"
And I set fields
   | nummer | 1WG49 |
   | such   | WG49  |
   | ueb    | ja    |
   | tterm  | .     |
   | vom    | .     |
   | budat  | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnungskorrektur ueber 20 St.
Given I open an editor "RK49" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS49"
And I set fields
   | nummer | 1RK49 |
   | such   | RK49  |
   | ueb    | ja    |
   | tterm  | .     |
Then field "mge" has value "20" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Storno der Rechnung nicht erlaubt
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE49" throws the exception "6729"

# Storno der RK49
Given I open an editor "ST_RK49" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RK49"
And I save the current editor

# Storno der Wertgutschrift
Given I open an editor "ST_WG49" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG49"
And I save the current editor

# Storno der Rechnung nun erlaubt
Given I open an editor "ST_RE49" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE49"
Then field "druck" is modifiable
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - Rechnung mit LB darf nicht storniert werden: es ist eine Rechnungskorrektur vorhanden
# SWG4
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU50" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU50 |
   | kunde   | 1     |
   | such    | AU50  |
And I append rows
   | artikel | mge | preis |
   | V1      | 50  | 55    |
And I save the current editor

# Rechnung mit LB
Given I open an editor "RE_ZU_AU50" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU50"
And I set fields
   | nummer | 1RE50 |
   | such   | RE50  |
   | ueb    | ja    |
   | tterm  | .     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "WG50" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE_ZU_AU50"
And I set fields
   | nummer | 1WG50 |
   | such   | WG50  |
   | ueb    | ja    |
   | tterm  | .     |
   | vom    | .     |
   | budat  | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnungskorrektur
Given I open an editor "RK50" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE_ZU_AU50"
And I set fields
   | nummer | 1RK50      |
   | such   | RK50       |
   | ueb    | ja         |
   | tterm  | .          |
   | vom    | .          |
   | budat  | .          |
And I press button "burekorrektur"
And I press button "offueb" in row 1
And I save the current editor

# Wertgutschrift kann nicht storniert werden, da Rechnungskorrektur vorhanden ist
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG50" throws the exception "3335"

# Storno der Rechnungskorrektur
Given I open an editor "ST_RK50" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RK50"
And I save the current editor

# Storno der Wertgutschrift nun erlaubt
Given I open an editor "ST_WG50" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG50"
And I save the current editor


# ----------------------------------------------------------------------------------------------
# Rechnungskorrektur gebucht
# Rechnung mit LB
Given I open an editor "RE51_LB" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE51  |
   | kunde  | 1      |
   | such   | RE51   |
   | ueb    | ja     |
   | tterm  | .      |
   | fakt   | ja     |
And I append rows
   | artikel | mge | preis |
   | E1      | 51  | 6     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "WG51" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE51_LB"
And I set fields
   | nummer | 1WG51 |
   | such   | WG51  |
   | ueb    | ja    |
   | tterm  | .     |
   | vom    | .     |
   | budat  | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnungskorrektur
Given I open an editor "RK51" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE51_LB"
And I set fields
   | nummer | 1RK51 |
   | such   | RK51  |
   | ueb    | ja    |
   | tterm  | .     |
   | vom    | .     |
   | budat  | .     |
And I press button "burekorrektur"
And I press button "offueb" in row 1
And I save the current editor

# Wertgutschrift kann nicht storniert werden, da Rechnungskorrektur vorhanden ist
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG51" throws the exception "3335"

# ----------------------------------------------------------------------------------------------
# Rechnungskorrektur ungebucht
# Rechnung mit LB
Given I open an editor "RE51_LB_UNGEBUCHT" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE51_1 |
   | kunde  | 1       |
   | such   | RE51_1  |
   | ueb    | ja      |
   | tterm  | .       |
   | fakt   | ja      |
And I append rows
   | artikel | mge | preis |
   | E1      | 51  | 6     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "WG51_1" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE51_LB_UNGEBUCHT"
And I set fields
   | nummer | 1WG51_1 |
   | such   | WG51_1  |
   | ueb    | ja      |
   | tterm  | .       |
   | vom    | .       |
   | budat  | .       |
And I press button "offueb" in row 1
And I save the current editor

# Rechnungskorrektur
Given I open an editor "RK51_UNGEB" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE51_LB_UNGEBUCHT"
And I set fields
   | nummer | 1RK51_1 |
   | such   | RK51_1  |
   | ueb    | nein    |
   | tterm  | .       |
   | vom    | .       |
   | budat  | .       |
And I press button "burekorrektur"
And I press button "offueb" in row 1
And I save the current editor

# Wertgutschrift kann nicht storniert werden, da (ungebuchte) Rechnungskorrektur vorhanden ist
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG51_1" throws the exception "3335"

# Wegbuchen damit das spaeter beim Jahresabschluss nicht stoert. Buchung ggf. auch spaeter vor Jahresabschluss moeglich
Given I open an editor "rechbuch" from table "(Sales):(Invoice)" with command "TRANSFER" for record "RK51_1"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK - Rechnungskorrektur darf storniert werden, auch wenn es eine nicht stornierte WGS gibt.
# SWG3
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU52" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU52 |
   | kunde   | 1     |
   | such    | AU52  |
And I append rows
   | artikel | mge | preis |
   | V1      | 20  | 52    |
And I save the current editor

# Lieferschein
Given I open an editor "LS52" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU52"
And I set fields
   | nummer | 1LS52 |
   | such   | LS52  |
   | ueb    | ja    |
   | vom    | .     |
And I set field "mge" to "20" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE52" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS52"
And I set fields
   | nummer | 1RE52 |
   | such   | RE52  |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "WG52" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE52"
And I set fields
   | nummer | 1WG52 |
   | such   | WG52  |
   | ueb    | ja    |
   | tterm  | .     |
   | vom    | .     |
   | budat  | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnungskorrektur ueber 20 St.
Given I open an editor "RK52" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS52"
And I set fields
   | nummer | 1RK52 |
   | such   | RK52  |
   | ueb    | ja    |
   | tterm  | .     |
Then field "mge" has value "20" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Storno der Rechnungskorrektur
Given I open an editor "ST_RK52" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RK52"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK - Rechnung mit LB: Kein Storno der Komplettwertgutschrift, wenn Rechnungskorrektur fuer neutr. Pos. vorhanden
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU53" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU53 |
   | kunde   | 1     |
   | such    | AU53  |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | V1      | 1           | 25          | !dontChange |
   | NEUPOS  | !dontChange | !dontChange | 75          |
And I save the current editor

# Rechnung mit LB
Given I open an editor "RE_ZU_AU53" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU53"
And I set fields
   | nummer | 1RE53 |
   | such   | RE53  |
   | ueb    | ja    |
   | tterm  | .     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "WG53" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE_ZU_AU53"
And I set fields
   | nummer | 1WG53 |
   | such   | WG53  |
   | ueb    | ja    |
   | tterm  | .     |
   | vom    | .     |
   | budat  | .     |
And I press button "offueb" in row 2
And I save the current editor

# Rechnungskorrektur
Given I open an editor "RK53" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE_ZU_AU53"
And I set fields
   | nummer | 1RK53      |
   | such   | RK53       |
   | ueb    | ja         |
   | tterm  | .          |
   | vom    | .          |
   | budat  | .          |
And I press button "burekorrektur"
And I press button "offueb" in row 1
And I save the current editor

# Wertgutschrift kann nicht storniert werden, da Rechnungskorrektur vorhanden ist
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG53" throws the exception "3335"

# Storno der Rechnungskorrektur
Given I open an editor "ST_RK53" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RK53"
And I save the current editor

# Storno der Wertgutschrift nun erlaubt
Given I open an editor "ST_WG53" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG53"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK - Rechnung aus Lieferschein: Kein Storno der Komplettwertgutschrift, wenn Rechnungskorrektur vorhanden
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "BE54" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE54 |
   | lief    | 1     |
   | such    | BE54  |
And I append rows
   | artikel | mge         | preis       | pwert |
   | NEUPOS  | !dontChange | !dontChange | 125   |
And I save the current editor

# Lieferschein
Given I open an editor "LS54" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE54"
And I set fields
   | nummer | 1LS54  |
   | such   | LS54   |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | ja     |
And I save the current editor

# Rechnung
Given I open an editor "RE54" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS54"
And I set fields
   | nummer | 1RE54  |
   | such   | RE54   |
   | ebeleg | RE54   |
   | ueb    | ja     |
   | vom    | .      |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "WG54" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE54"
And I set fields
   | nummer | 1WG54 |
   | such   | WG54  |
   | ueb    | ja    |
   | tterm  | .     |
   | vom    | .     |
   | budat  | .     |
And I press button "komplettieren"
And I save the current editor

# Rechnungskorrektur
Given I open an editor "RK54" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS54"
And I set fields
   | nummer | 1RK54      |
   | such   | RK54       |
   | ueb    | ja         |
   | tterm  | .          |
   | vom    | .          |
   | budat  | .          |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift kann nicht storniert werden, da Rechnungskorrektur vorhanden ist
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WG54" throws the exception "3335"

# Storno der Rechnungskorrektur
Given I open an editor "ST_RK54" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RK54"
And I save the current editor

# Storno der Wertgutschrift nun erlaubt
Given I open an editor "ST_WG54" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WG54"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK - Rechnung aus AU ohne LB mit Text- und Neutraler Position, nach WG 100% - remge in AU pruefen
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU055" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU055 |
   | kunde   | 1      |
   | such    | AU055  |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | V1      | 55          | 1           | !dontChange |
   | NEUPOS  | !dontChange | !dontChange | 56          |
   | TEXT    | !dontChange | !dontChange | 57          |
And I save the current editor

# Rechnung aus AU ohne LB
Given I open an editor "1RE055" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU055"
And I set fields
   | nummer | 1RE055 |
   | such   | RE055  |
   | ueb    | ja     |
   | tterm  | .      |
   | fakt   | nein   |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "AU055" in row 1 has value "0"
Then field "remge" from editor "AU055" in row 2 has value "0"
Then field "remge" from editor "AU055" in row 3 has value "0"

# Teil-Wertgutschrift: Rechnung -> Rechnung
Given I open an editor "WERT-ZU-RE55" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE055"
And I set fields
   | nummer | 55WERT     |
   | such   | VK-WERT55  |
   | tterm  | .          |
   | budat  | .          |
Then the table has 6 rows
And I set field "mge" to "-9" in row 1
And I set field "pwert" to "-10" in row 2
And I set field "pwert" to "-11" in row 3
And I save the current editor

Then field "remge" from editor "AU055" in row 1 has value "0"
Then field "remge" from editor "AU055" in row 2 has value "0"
Then field "remge" from editor "AU055" in row 3 has value "0"

# Komplettwertgutschrift buchen
Given I open an editor "100WG55" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "WERT-ZU-RE55"
And I set fields
   | ueb    | ja    |
And I press button "komplettieren"
And I save the current editor

Then field "remge" from editor "AU055" in row 1 has value "55"
Then field "remge" from editor "AU055" in row 2 has value "56"
Then field "remge" from editor "AU055" in row 3 has value "57"

# ----------------------------------------------------------------------------------------------
Scenario: VK - Rechnung aus Lieferschein: Kein Storno der Komplettwertgutschrift, wenn Rechnungskorrektur
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU56" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU56 |
   | kunde   | 1     |
   | such    | AU56  |
And I append rows
   | artikel | mge         | preis  |
   | V1      | 15          | 25     |
And I save the current editor

# Lieferschein
Given I open an editor "LS56" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU56"
And I set fields
   | nummer | 1LS56 |
   | such   | LS56  |
   | ueb    | ja    |
   | vom    | .     |
And I set field "mge" to "20" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE56" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS56"
And I set fields
   | nummer | 1RE56 |
   | such   | RE56  |
   | ueb    | ja    |
   | tterm  | .     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 1. Komplettwertgutschrift
Given I open an editor "WG56A" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE56"
And I set fields
   | nummer | 1WG56A |
   | such   | WG56A  |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
   | budat  | .      |
And I press button "offueb" in row 1
And I save the current editor

# 1. Rechnungskorrektur
Given I open an editor "RK56A" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS56"
And I set fields
   | nummer | 1RK56A |
   | such   | RK56A  |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
   | budat  | .      |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Komplettwertgutschrift
Given I open an editor "WG56B" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RK56A"
And I set fields
   | nummer | 1WG56B |
   | such   | WG56B  |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
   | budat  | .      |
And I press button "offueb" in row 1
And I save the current editor

# 2. Rechnungskorrektur
Given I open an editor "RK56B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS56"
And I set fields
   | nummer | 1RK56B |
   | such   | RK56B  |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
   | budat  | .      |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 3. Komplettwertgutschrift
Given I open an editor "WG56C" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RK56B"
And I set fields
   | nummer | 1WG56C |
   | such   | WG56C  |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
   | budat  | .      |
And I press button "offueb" in row 1
And I save the current editor

# Storno der 3. Wertgutschrift erlaubt
Given I open an editor "ST_WG56C" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG56C"
And I save the current editor

# 2. Wertgutschrift kann nicht storniert werden, da 2. Rechnungskorrektur vorhanden ist
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG56B" throws the exception "3335"

# 1. Wertgutschrift kann nicht storniert werden, da 1. Rechnungskorrektur vorhanden ist
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG56A" throws the exception "3335"

# Storno der 2. Rechnungskorrektur
Given I open an editor "ST_RK56B" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RK56B"
And I save the current editor

# Storno der 2. Wertgutschrift nun erlaubt
Given I open an editor "ST_WG56B" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG56B"
And I save the current editor

# 1. Wertgutschrift kann nicht storniert werden, da 1. Rechnungskorrektur vorhanden ist
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "WG56A" throws the exception "3335"


# ----------------------------------------------------------------------------------------------
Scenario: EK - Rechnung aus Lieferschein: Kein Storno der Komplettwertgutschrift, wenn Rechnungskorrektur vorhanden
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "BE57" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE57 |
   | lief    | 1     |
   | such    | BE57  |
And I append rows
   | artikel | mge | preis       |
   | E1      | 120 | 2           |
And I save the current editor

# Rechnung mit Lagerbewegung
Given I open an editor "RL57" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE57"
And I set fields
   | nummer | 1RL57  |
   | such   | RL57   |
   | ebeleg | RL57   |
   | fakt   | ja     |
   | ueb    | ja     |
   | vom    | .      |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 1. Komplettwertgutschrift
Given I open an editor "WG57A" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RL57"
And I set fields
   | nummer | 1WG57A |
   | such   | WG57A  |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
   | budat  | .      |
And I press button "komplettieren"
And I save the current editor

# 1. Rechnungskorrektur
Given I open an editor "RK57A" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RL57"
And I set fields
   | nummer | 1RK57A |
   | such   | RK57A  |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
   | budat  | .      |
And I press button "burekorrektur"
And I press button "offueb" in row 1
And I save the current editor

# 2. Komplettwertgutschrift
Given I open an editor "WG57B" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RK57A"
And I set fields
   | nummer | 1WG57B |
   | such   | WG57B  |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
   | budat  | .      |
And I press button "komplettieren"
And I save the current editor

# 2. Rechnungskorrektur
Given I open an editor "RK57B" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RL57"
And I set fields
   | nummer | 1RK57B |
   | such   | RK57B  |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
   | budat  | .      |
And I press button "burekorrektur"
And I press button "offueb" in row 1
And I save the current editor

# 3. Komplettwertgutschrift
Given I open an editor "WG57C" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RK57B"
And I set fields
   | nummer | 1WG57C |
   | such   | WG57C  |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
   | budat  | .      |
And I press button "komplettieren"
And I save the current editor

# Storno der 3. Wertgutschrift erlaubt
Given I open an editor "ST_WG57C" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WG57C"
And I save the current editor

# 2. Wertgutschrift kann nicht storniert werden, da 2. Rechnungskorrektur vorhanden ist
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WG57B" throws the exception "3335"

# 1. Wertgutschrift kann nicht storniert werden, da 1. Rechnungskorrektur vorhanden ist
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WG57A" throws the exception "3335"

# Storno der 2. Rechnungskorrektur
Given I open an editor "ST_RK57B" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RK57B"
And I save the current editor

# Storno der 2. Wertgutschrift nun erlaubt
Given I open an editor "ST_WG57A" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WG57B"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK - AU mit Umlageposition - RE - WG - Werte pruefen
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU058" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU058 |
   | kunde   | 1      |
   | such    | AU058  |
And I append rows
   | artikel | pwert       | mge         |
   | TEXT    | 100         | !dontChange |
   | PR.     |  -5         | !dontChange |
   | UML     | !dontChange | !dontChange |
   | V1      | !dontChange | 56          |
And I save the current editor

# Rechnung
Given I open an editor "RE058" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU058"
And I set fields
   | nummer | 1RE058 |
   | such   | RE058  |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
And I press button "offueb" in row 4
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift -> Werte pruefen
Given I open an editor "WG058" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE058"
And I press button "komplettieren"
Then field "sumnetto" has value "-1505.00"
Then field "pwert" has value "-100.00" in row 1
Then field "pwert" has value "5.00" in row 2
Then field "pwert" has value "-10.00" in row 3
Then field "ofmge" has value "0" in row 3
And I close the current editor

Given I open an editor "RE1-ZU-AU058" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE058"
And I set fields
   | nummer | 1WG058 |
   | such   | WG058  |
   | tterm  | .      |
   | vom    | .      |
   | budat  | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I press button "offueb" in row 4
Then field "sumnetto" has value "-1495.00"
Then field "pwert" has value "-100.00" in row 1
Then field "pwert" has value "5.00" in row 2
Then field "pwert" has value "0.00" in row 3
Then field "ofmge" has value "-10" in row 3
Then field "status" has value "*" in row 4
# Nettosummen-Position
Then field "pwert" has value "-1495.00" in row 5
# Umlage
And I press button "offueb" in row 3
Then field "pwert" has value "-10.00" in row 3
Then field "sumnetto" has value "-1505.00"
Then field "pwert" has value "-1505.00" in row 5
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK - AU - LS - RE - 100%WG dann RE-Korrektur -> TWG -> Storno TWG
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU059" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU059 |
   | kunde   | 1      |
   | such    | AU059  |
And I append rows
   | artikel | mge | preis |
   | V1      | 10  | 59    |
And I save the current editor

# Lieferschein
Given I open an editor "1LS059" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU059"
And I set fields
   | nummer | 1LS059 |
   | such   | LS059  |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | ja     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE059" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS059"
And I set fields
   | nummer | 1RE059 |
   | such   | RE059  |
   | ueb    | ja     |
   | tterm  | .      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "1WG059" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE059"
And I set fields
   | nummer | 1WG059 |
   | such   | WG059  |
   | ueb    | ja     |
   | tterm  | .      |
And I set field "mge" to "-10" in row 1
And I save the current editor

# Rechnungskorrektur
Given I open an editor "1RE059_Korrektur" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS059"
And I set fields
   | nummer | 1REK059 |
   | such   | REK059  |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "preis" to "599" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift zur Rechnungskorrektur
Given I open an editor "1TWG059" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE059_Korrektur"
And I set fields
   | nummer | 1TWG059 |
   | such   | TWG059  |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-2" in row 1
And I save the current editor

# Storno der Teilwertgutschrift
Given I open an editor "ST_1TWG059" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "1TWG059"
Then field "druck" is modifiable
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK - Bestimmung der Rechnungskorrektur (Artikelposition)
# ----------------------------------------------------------------------------------------------

#
# 1BE060 ----- 1LS060 --------- 1RE060 ------- 1KGS060
# 100          80               40            -40
#               \
#                \ ----- 2RE060 ---------------------- 2RE060S
#                 \      10                           -10
#                  \
#                   \ ---------------- 3RE060 ---------------------------------------------- 3KGS060
#                    \                 20                                                    -20
#                     \
#                      \ -------------------------------------- 4RE060 ------ 4RE060S
#                       \                                       30           -30
#                        \
#                         \ ------------------------------------------ 5RE060
#                          \                                           30
#                           \
#                            \ ----------------------------------------------------- 6RE060
#                                                                                    10

# Bestellung
Given I open an editor "1BE060" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE060  |
   | lief    | 1       |
   | such    | BE060   |
And I append rows
   | artikel | mge | preis |
   | E2      | 100 | 10    |
And I save the current editor

# Lieferschein
Given I open an editor "1LS060" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE060"
And I set fields
   | nummer | 1LS060  |
   | such   | LS060   |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "80" in row 1
And I save the current editor

Then field "rekorrektur" from editor "1LS060" in row 1 has value "nein"

# Rechnung
Given I open an editor "2RE060" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS060"
And I set fields
   | nummer | 2RE060  |
   | such   | RE060-2 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1LS060" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE060" in row 1 has value "nein"

# Rechnung
Given I open an editor "1RE060" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS060"
And I set fields
   | nummer | 1RE060  |
   | such   | RE060   |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "40" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1LS060" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE060" in row 1 has value "nein"

# Rechnung
Given I open an editor "3RE060" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS060"
And I set fields
   | nummer | 3RE060  |
   | such   | RE060-3 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "20" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1LS060" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE060" in row 1 has value "nein"

# Komplettgutschrift
Given I open an editor "1KGS060" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE060"
And I set fields
   | nummer | 1KGS060 |
   | such   | KGS060  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-40" in row 1
And I save the current editor

Then field "rekorrektur" from editor "1LS060" in row 1 has value "ja"
Then field "rekorrektur" from editor "1RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE060" in row 1 has value "nein"

# Rechnung stornieren
Given I open an editor "2RE060S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "2RE060"
And I set fields
   | nummer | 2RE060S |
Then field "druck" is modifiable
And I save the current editor

Then field "rekorrektur" from editor "1LS060" in row 1 has value "ja"
Then field "rekorrektur" from editor "1RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE060" in row 1 has value "nein"

# Rechnung
Given I open an editor "4RE060" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS060"
And I set fields
   | nummer | 4RE060  |
   | such   | RE060-4 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "30" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1LS060" in row 1 has value "ja"
Then field "rekorrektur" from editor "1RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "4RE060" in row 1 has value "ja"

# Rechnung
Given I open an editor "5RE060" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS060"
And I set fields
   | nummer | 5RE060  |
   | such   | RE060-5 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "30" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1LS060" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "4RE060" in row 1 has value "ja"
Then field "rekorrektur" from editor "5RE060" in row 1 has value "ja"

# Rechnung stornieren
Given I open an editor "4RE060S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "4RE060"
And I set fields
   | nummer | 4RE060S |
And I save the current editor

Then field "rekorrektur" from editor "1LS060" in row 1 has value "ja"
Then field "rekorrektur" from editor "1RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "4RE060" in row 1 has value "ja"
Then field "rekorrektur" from editor "5RE060" in row 1 has value "ja"

# Rechnung
Given I open an editor "6RE060" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS060"
And I set fields
   | nummer | 6RE060  |
   | such   | RE060-6 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1LS060" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "4RE060" in row 1 has value "ja"
Then field "rekorrektur" from editor "5RE060" in row 1 has value "ja"
Then field "rekorrektur" from editor "6RE060" in row 1 has value "ja"

# Komplettgutschrift
Given I open an editor "3KGS060" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "3RE060"
And I set fields
   | nummer | 3KGS060  |
   | such   | KGS060-3 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "mge" to "-20" in row 1
And I save the current editor

Then field "rekorrektur" from editor "1LS060" in row 1 has value "ja"
Then field "rekorrektur" from editor "1RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE060" in row 1 has value "nein"
Then field "rekorrektur" from editor "4RE060" in row 1 has value "ja"
Then field "rekorrektur" from editor "5RE060" in row 1 has value "ja"
Then field "rekorrektur" from editor "6RE060" in row 1 has value "ja"

# ----------------------------------------------------------------------------------------------
Scenario: EK - Bestimmung der Rechnungskorrektur (positive und negative Neutrale Positionen)
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE061" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE061  |
   | lief    | 1       |
   | such    | BE061   |
And I append rows
   | artikel | pwert |
   | NEUPOS  | 100   |
   | NEUPOS  | -100  |
And I save the current editor

# Lieferschein
Given I open an editor "1LS061" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE061"
And I set fields
   | nummer | 1LS061  |
   | such   | LS061   |
   | ueb    | ja      |
   | vom    | .       |
And I set field "pwert" to "80" in row 1
And I set field "pwert" to "-80" in row 2
And I save the current editor

Then field "rekorrektur" from editor "1LS061" in row 1 has value "nein"
Then field "rekorrektur" from editor "1LS061" in row 2 has value "nein"

# Rechnung
Given I open an editor "2RE061" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS061"
And I set fields
   | nummer | 2RE061  |
   | such   | RE061-2 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "pwert" to "10" in row 1
And I set field "pwert" to "-10" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1LS061" in row 1 has value "nein"
Then field "rekorrektur" from editor "1LS061" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 2 has value "nein"

# Rechnung
Given I open an editor "1RE061" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS061"
And I set fields
   | nummer | 1RE061  |
   | such   | RE061   |
   | ueb    | ja      |
   | vom    | .       |
And I set field "pwert" to "40" in row 1
And I set field "pwert" to "-40" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1LS061" in row 1 has value "nein"
Then field "rekorrektur" from editor "1LS061" in row 2 has value "nein"
Then field "rekorrektur" from editor "1RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 2 has value "nein"

# Rechnung
Given I open an editor "3RE061" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS061"
And I set fields
   | nummer | 3RE061  |
   | such   | RE061-3 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "pwert" to "20" in row 1
And I set field "pwert" to "-20" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1LS061" in row 1 has value "nein"
Then field "rekorrektur" from editor "1LS061" in row 2 has value "nein"
Then field "rekorrektur" from editor "1RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "3RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE061" in row 2 has value "nein"

# Komplettgutschrift
Given I open an editor "1KGS061" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE061"
And I set fields
   | nummer | 1KGS061 |
   | such   | KGS061  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "pwert" to "-40" in row 1
And I set field "pwert" to "40" in row 2
And I save the current editor

Then field "rekorrektur" from editor "1LS061" in row 1 has value "ja"
Then field "rekorrektur" from editor "1LS061" in row 2 has value "ja"
Then field "rekorrektur" from editor "1RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "3RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE061" in row 2 has value "nein"

# Rechnung stornieren
Given I open an editor "2RE061S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "2RE061"
And I set fields
   | nummer | 2RE061S |
And I save the current editor

Then field "rekorrektur" from editor "1LS061" in row 1 has value "ja"
Then field "rekorrektur" from editor "1LS061" in row 2 has value "ja"
Then field "rekorrektur" from editor "1RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "3RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE061" in row 2 has value "nein"

# Rechnung
Given I open an editor "4RE061" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS061"
And I set fields
   | nummer | 4RE061  |
   | such   | RE061-4 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "pwert" to "30" in row 1
And I set field "pwert" to "-30" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1LS061" in row 1 has value "ja"
Then field "rekorrektur" from editor "1LS061" in row 2 has value "ja"
Then field "rekorrektur" from editor "1RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "3RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "4RE061" in row 1 has value "ja"
Then field "rekorrektur" from editor "4RE061" in row 2 has value "ja"

# Rechnung
Given I open an editor "5RE061" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS061"
And I set fields
   | nummer | 5RE061  |
   | such   | RE061-5 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "pwert" to "30" in row 1
And I set field "pwert" to "-30" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1LS061" in row 1 has value "nein"
Then field "rekorrektur" from editor "1LS061" in row 2 has value "nein"
Then field "rekorrektur" from editor "1RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "3RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "4RE061" in row 1 has value "ja"
Then field "rekorrektur" from editor "4RE061" in row 2 has value "ja"
Then field "rekorrektur" from editor "5RE061" in row 1 has value "ja"
Then field "rekorrektur" from editor "5RE061" in row 2 has value "ja"

# Rechnung stornieren
Given I open an editor "4RE061S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "4RE061"
And I set fields
   | nummer | 4RE061S |
And I save the current editor

Then field "rekorrektur" from editor "1LS061" in row 1 has value "ja"
Then field "rekorrektur" from editor "1LS061" in row 2 has value "ja"
Then field "rekorrektur" from editor "1RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "3RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "4RE061" in row 1 has value "ja"
Then field "rekorrektur" from editor "4RE061" in row 2 has value "ja"
Then field "rekorrektur" from editor "5RE061" in row 1 has value "ja"
Then field "rekorrektur" from editor "5RE061" in row 2 has value "ja"

# Rechnung
Given I open an editor "6RE061" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS061"
And I set fields
   | nummer | 6RE061  |
   | such   | RE061-6 |
   | ueb    | ja      |
   | vom    | .       |
And I set field "pwert" to "10" in row 1
And I set field "pwert" to "-10" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1LS061" in row 1 has value "nein"
Then field "rekorrektur" from editor "1LS061" in row 2 has value "nein"
Then field "rekorrektur" from editor "1RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "3RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "4RE061" in row 1 has value "ja"
Then field "rekorrektur" from editor "4RE061" in row 2 has value "ja"
Then field "rekorrektur" from editor "5RE061" in row 1 has value "ja"
Then field "rekorrektur" from editor "5RE061" in row 2 has value "ja"
Then field "rekorrektur" from editor "6RE061" in row 1 has value "ja"
Then field "rekorrektur" from editor "6RE061" in row 2 has value "ja"

# Komplettgutschrift
Given I open an editor "3KGS061" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "3RE061"
And I set fields
   | nummer | 3KGS061  |
   | such   | KGS061-3 |
   | ueb    | ja       |
   | vom    | .        |
And I set field "pwert" to "-20" in row 1
And I set field "pwert" to "20" in row 2
And I save the current editor

Then field "rekorrektur" from editor "1LS061" in row 1 has value "ja"
Then field "rekorrektur" from editor "1LS061" in row 2 has value "ja"
Then field "rekorrektur" from editor "1RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "3RE061" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE061" in row 2 has value "nein"
Then field "rekorrektur" from editor "4RE061" in row 1 has value "ja"
Then field "rekorrektur" from editor "4RE061" in row 2 has value "ja"
Then field "rekorrektur" from editor "5RE061" in row 1 has value "ja"
Then field "rekorrektur" from editor "5RE061" in row 2 has value "ja"
Then field "rekorrektur" from editor "6RE061" in row 1 has value "ja"
Then field "rekorrektur" from editor "6RE061" in row 2 has value "ja"

# ----------------------------------------------------------------------------------------------
Scenario: VK - Bestimmung der Rechnungskorrektur (AU/BE Zusatzpositionen und Dienstleistungen)
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU062" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU062  |
   | kunde   | 1       |
   | such    | BE062   |
And I append rows
   | artikel      | mge | preis |
   | AUBEPOS      | 100 | 10    |
   | DL-HANALYSE  | 100 | 10    |
And I save the current editor

# Lieferschein
Given I open an editor "1LS062" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU062"
And I set fields
   | nummer | 1LS062  |
   | such   | LS062   |
   | ueb    | ja      |
   | tterm  | .       |
   | fakt   | nein    |
And I set field "mge" to "80" in row 1
And I set field "mge" to "80" in row 2
And I save the current editor

Then field "rekorrektur" from editor "1AU062" in row 1 has value "nein"
Then field "rekorrektur" from editor "1AU062" in row 2 has value "nein"

# Rechnung
Given I open an editor "2RE062" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU062"
And I set fields
   | nummer | 2RE062  |
   | such   | RE062-2 |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1AU062" in row 1 has value "nein"
Then field "rekorrektur" from editor "1AU062" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 2 has value "nein"

# Rechnung
Given I open an editor "1RE062" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU062"
And I set fields
   | nummer | 1RE062  |
   | such   | RE062   |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "40" in row 1
And I set field "mge" to "40" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1AU062" in row 1 has value "nein"
Then field "rekorrektur" from editor "1AU062" in row 2 has value "nein"
Then field "rekorrektur" from editor "1RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 2 has value "nein"

# Rechnung
Given I open an editor "3RE062" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU062"
And I set fields
   | nummer | 3RE062  |
   | such   | RE062-3 |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "20" in row 1
And I set field "mge" to "20" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1AU062" in row 1 has value "nein"
Then field "rekorrektur" from editor "1AU062" in row 2 has value "nein"
Then field "rekorrektur" from editor "1RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "3RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE062" in row 2 has value "nein"

# Komplettgutschrift
Given I open an editor "1KGS062" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE062"
And I set fields
   | nummer | 1KGS062 |
   | such   | KGS062  |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-40" in row 1
And I set field "mge" to "-40" in row 2
And I save the current editor

Then field "rekorrektur" from editor "1AU062" in row 1 has value "ja"
Then field "rekorrektur" from editor "1AU062" in row 2 has value "ja"
Then field "rekorrektur" from editor "1RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "3RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE062" in row 2 has value "nein"

# Rechnung stornieren
Given I open an editor "2RE062S" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "2RE062"
And I set fields
   | nummer | 2RE062S |
And I save the current editor

Then field "rekorrektur" from editor "1AU062" in row 1 has value "ja"
Then field "rekorrektur" from editor "1AU062" in row 2 has value "ja"
Then field "rekorrektur" from editor "1RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "3RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE062" in row 2 has value "nein"

# Rechnung
Given I open an editor "4RE062" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU062"
And I set fields
   | nummer | 4RE062  |
   | such   | RE062-4 |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "30" in row 1
And I set field "mge" to "30" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1AU062" in row 1 has value "ja"
Then field "rekorrektur" from editor "1AU062" in row 2 has value "ja"
Then field "rekorrektur" from editor "1RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "3RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "4RE062" in row 1 has value "ja"
Then field "rekorrektur" from editor "4RE062" in row 2 has value "ja"

# Rechnung
Given I open an editor "5RE062" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU062"
And I set fields
   | nummer | 5RE062  |
   | such   | RE062-5 |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "30" in row 1
And I set field "mge" to "30" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1AU062" in row 1 has value "nein"
Then field "rekorrektur" from editor "1AU062" in row 2 has value "nein"
Then field "rekorrektur" from editor "1RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "3RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "4RE062" in row 1 has value "ja"
Then field "rekorrektur" from editor "4RE062" in row 2 has value "ja"
Then field "rekorrektur" from editor "5RE062" in row 1 has value "ja"
Then field "rekorrektur" from editor "5RE062" in row 2 has value "ja"

# Rechnung stornieren
Given I open an editor "4RE062S" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "4RE062"
And I set fields
   | nummer | 4RE062S |
And I save the current editor

Then field "rekorrektur" from editor "1AU062" in row 1 has value "ja"
Then field "rekorrektur" from editor "1AU062" in row 2 has value "ja"
Then field "rekorrektur" from editor "1RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "3RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "4RE062" in row 1 has value "ja"
Then field "rekorrektur" from editor "4RE062" in row 2 has value "ja"
Then field "rekorrektur" from editor "5RE062" in row 1 has value "ja"
Then field "rekorrektur" from editor "5RE062" in row 2 has value "ja"

# Rechnung
Given I open an editor "6RE062" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU062"
And I set fields
   | nummer | 6RE062  |
   | such   | RE062-6 |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1AU062" in row 1 has value "nein"
Then field "rekorrektur" from editor "1AU062" in row 2 has value "nein"
Then field "rekorrektur" from editor "1RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "3RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "4RE062" in row 1 has value "ja"
Then field "rekorrektur" from editor "4RE062" in row 2 has value "ja"
Then field "rekorrektur" from editor "5RE062" in row 1 has value "ja"
Then field "rekorrektur" from editor "5RE062" in row 2 has value "ja"
Then field "rekorrektur" from editor "6RE062" in row 1 has value "ja"
Then field "rekorrektur" from editor "6RE062" in row 2 has value "ja"

# Komplettgutschrift
Given I open an editor "3KGS062" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "3RE062"
And I set fields
   | nummer | 3KGS062  |
   | such   | KGS062-3 |
   | ueb    | ja       |
   | tterm  | .        |
And I set field "mge" to "-20" in row 1
And I set field "mge" to "-20" in row 2
And I save the current editor

Then field "rekorrektur" from editor "1AU062" in row 1 has value "ja"
Then field "rekorrektur" from editor "1AU062" in row 2 has value "ja"
Then field "rekorrektur" from editor "1RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "3RE062" in row 1 has value "nein"
Then field "rekorrektur" from editor "3RE062" in row 2 has value "nein"
Then field "rekorrektur" from editor "4RE062" in row 1 has value "ja"
Then field "rekorrektur" from editor "4RE062" in row 2 has value "ja"
Then field "rekorrektur" from editor "5RE062" in row 1 has value "ja"
Then field "rekorrektur" from editor "5RE062" in row 2 has value "ja"
Then field "rekorrektur" from editor "6RE062" in row 1 has value "ja"
Then field "rekorrektur" from editor "6RE062" in row 2 has value "ja"

# ----------------------------------------------------------------------------------------------
Scenario: VK - Bestimmung der Rechnungskorrektur (gemischte Fakturierung ueber AU/BE und LS)
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU063" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU063  |
   | kunde   | 1       |
   | such    | AU063   |
And I append rows
   | artikel | mge | preis |
   | V1      | 100 | 10    |
And I save the current editor

# Lieferschein
Given I open an editor "1LS063" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU063"
And I set fields
   | nummer | 1LS063  |
   | such   | LS063   |
   | ueb    | ja      |
   | fakt   | ja      |
And I set field "mge" to "60" in row 1
And I save the current editor

# Rechnung aus Auftrag
Given I open an editor "1RE063" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU063"
And I set fields
   | nummer | 1RE063  |
   | such   | RE063-1 |
   | ueb    | ja      |
   | fakt   | nein    |
   | tterm  | .       |
And I set field "mge" to "40" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1AU063" in row 1 has value "nein"
Then field "rekorrektur" from editor "1LS063" in row 1 has value "nein"

# Komplettgutschrift
Given I open an editor "1KGS063" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE063"
And I set fields
   | nummer | 1KGS063  |
   | such   | KGS063-1 |
   | ueb    | ja       |
   | tterm  | .        |
And I set field "mge" to "-40" in row 1
And I save the current editor

Then field "rekorrektur" from editor "1AU063" in row 1 has value "ja"
Then field "rekorrektur" from editor "1LS063" in row 1 has value "nein"

# Rechnung aus Lieferschein
Given I open an editor "2RE063" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS063"
And I set fields
   | nummer | 2RE063  |
   | such   | RE063-2 |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "60" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1AU063" in row 1 has value "ja"
Then field "rekorrektur" from editor "1LS063" in row 1 has value "nein"

# Lieferschein
Given I open an editor "2LS063" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU063"
And I set fields
   | nummer | 2LS063  |
   | such   | LS063-2 |
   | ueb    | ja      |
   | fakt   | nein    |
And I set field "mge" to "40" in row 1
And I save the current editor

Then field "rekorrektur" from editor "1AU063" in row 1 has value "ja"
Then field "rekorrektur" from editor "1LS063" in row 1 has value "nein"

# Rechnungskorrektur
Given I open an editor "3RE063" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU063"
And I set fields
   | nummer | 3RE063  |
   | such   | RE063-3 |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "40" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1AU063" in row 1 has value "nein"
Then field "rekorrektur" from editor "1LS063" in row 1 has value "nein"

# ----------------------------------------------------------------------------------------------
Scenario: EK - Ungebuchte moegliche Rechnungskorrekturen parallel
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE064" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE064  |
   | lief    | 1       |
   | such    | BE064   |
And I append rows
   | artikel | mge | preis |
   | E2      | 100 | 10    |
And I save the current editor

# Rechnung
Given I open an editor "1RE064" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE064"
And I set fields
   | nummer | 1RE064  |
   | such   | RE064   |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1BE064" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE064" in row 1 has value "nein"

# Komplettgutschrift
Given I open an editor "1KGS064" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE064"
And I set fields
   | nummer | 1KGS064 |
   | such   | KGS064  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-50" in row 1
And I save the current editor

Then field "rekorrektur" from editor "1BE064" in row 1 has value "ja"
Then field "rekorrektur" from editor "1RE064" in row 1 has value "nein"

# Rechnung
Given I open an editor "2RE064" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE064"
And I set fields
   | nummer | 2RE064  |
   | such   | RE064-2 |
   | vom    | .       |
And I set field "mge" to "30" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1BE064" in row 1 has value "ja"
Then field "rekorrektur" from editor "1RE064" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE064" in row 1 has value "ja"

# Rechnung
Given I open an editor "3RE064" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE064"
And I set fields
   | nummer | 3RE064  |
   | such   | RE064-3 |
   | vom    | .       |
And I set field "mge" to "30" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1BE064" in row 1 has value "ja"
Then field "rekorrektur" from editor "1RE064" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE064" in row 1 has value "ja"
Then field "rekorrektur" from editor "3RE064" in row 1 has value "ja"

# Rechnung
Given I open an editor "4RE064" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE064"
And I set fields
   | nummer | 4RE064  |
   | such   | RE064-4 |
   | vom    | .       |
And I set field "mge" to "30" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "rekorrektur" from editor "1BE064" in row 1 has value "ja"
Then field "rekorrektur" from editor "1RE064" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE064" in row 1 has value "ja"
Then field "rekorrektur" from editor "3RE064" in row 1 has value "ja"
Then field "rekorrektur" from editor "4RE064" in row 1 has value "ja"

# Rechnungsbuchung
Given I open an editor "2RE064" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "2RE064"
And I set fields
   | ueb    | ja      |
And I save the current editor

Then field "rekorrektur" from editor "1BE064" in row 1 has value "ja"
Then field "rekorrektur" from editor "1RE064" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE064" in row 1 has value "ja"
Then field "rekorrektur" from editor "3RE064" in row 1 has value "ja"
Then field "rekorrektur" from editor "4RE064" in row 1 has value "ja"

# Rechnungbuchung
Given I open an editor "3RE064" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "3RE064"
And I set fields
   | ueb    | ja      |
And I save the current editor

Then field "rekorrektur" from editor "1BE064" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE064" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE064" in row 1 has value "ja"
Then field "rekorrektur" from editor "3RE064" in row 1 has value "ja"
Then field "rekorrektur" from editor "4RE064" in row 1 has value "ja"

# Rechnungbuchung
Given I open an editor "4RE064" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "4RE064"
And I set fields
   | ueb    | ja      |
And I save the current editor

Then field "rekorrektur" from editor "1BE064" in row 1 has value "nein"
Then field "rekorrektur" from editor "1RE064" in row 1 has value "nein"
Then field "rekorrektur" from editor "2RE064" in row 1 has value "ja"
Then field "rekorrektur" from editor "3RE064" in row 1 has value "ja"
# Bei der Rechnungsbuchung wurde festgestellt, dass (ev)rekorrektur = ja bei 4RE064 nicht mehr korrekt ist.
Then field "rekorrektur" from editor "4RE064" in row 1 has value "nein"

# ----------------------------------------------------------------------------------------------
Scenario: EK: Statusaktualisierung in der Wertgutschrift
# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "RE065" from table "(Purchasing):(Invoice)" with command "NEW" for record ""

And I set fields
   | nummer | 1RE065 |
   | lief   | 1      |
   | such   | RE065  |
   | ebeleg | RE065  |
   | ueb    | ja     |
   | vom    | .      |
And I append rows
   | artikel     | mge         | preis       | pwert       | proz        |
   | V1          | 10          | 10          | !dontChange | !dontChange |
   | NEUPOS      | !dontChange | !dontChange | 10          | !dontChange |
   | NEUPOS      | !dontChange | !dontChange | -10         | !dontChange |
   | AUBEPOS     | 10          | 10          | !dontChange | !dontChange |
   | DL-HANALYSE | 10          | 10          | !dontChange | !dontChange |
   | PR.         | !dontChange | !dontChange | !dontChange | -10         |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "WG065" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE065"
And I set fields
   | nummer | 1WG065 |
   | ebeleg | WG065  |
   | such   | WG065  |
   | ueb    | ja     |
   | vom    | .      |
And I press button "komplettieren"
Then field "status" has value "*" in row 1
Then field "status" has value "*" in row 2
Then field "status" has value "*" in row 3
Then field "status" has value "*" in row 4
Then field "status" has value "*" in row 5
Then field "status" has value "%" in row 6
And I set field "mge" to "-5" in row 1
And I set field "pwert" to "-5" in row 2
And I set field "pwert" to "5" in row 3
And I set field "mge" to "-5" in row 4
And I set field "mge" to "-5" in row 5
Then field "status" has value "" in row 1
Then field "status" has value "" in row 2
Then field "status" has value "" in row 3
Then field "status" has value "" in row 4
Then field "status" has value "" in row 5
Then field "status" has value "%" in row 6
And I press button "komplettieren"
Then field "status" has value "*" in row 1
Then field "status" has value "*" in row 2
Then field "status" has value "*" in row 3
Then field "status" has value "*" in row 4
Then field "status" has value "*" in row 5
Then field "status" has value "%" in row 6
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK - Plausis fuer maximalen offenen Gutschriftswert AU-LS-RE-TWGS1-TWGS2-TWGS3
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU011" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1     |
   | such    | AU011 |
And I append rows
   | artikel      | mge         | preis       | pwert       |
   | V1           |         100 |         100 | !dontChange |
   | TEXT         | !dontChange | !dontChange |      100.00 |
   | dl-reparatur |           2 |       50.00 | !dontChange |
   | AUBEPOS      |          10 |        7.00 | !dontChange |
   | NEUPOS       | !dontChange | !dontChange |      200.00 |
And I save the current editor

# Lieferschein
Given I open an editor "1LS011" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU011"
And I set fields
   | such   | LS0111 |
   | ueb    | ja     |
   | vom    | .      |
And I press button "offueb" in row 1
And I press button "offueb" in row 3
And I press button "offueb" in row 4
And I save the current editor

# Rechnung
Given I open an editor "1RE011" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS011"
And I set fields
   | such   | RE011 |
   | ueb    | ja    |
   | tterm  | .     |
   | budat  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil-Wertgutschrift
Given I open an editor "1WG011" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE011"
And I set fields
   | such   | WG011 |
   | ueb    | ja    |
   | tterm  | .     |
And I set field "mge" to "-47" in row 1
And I set field "pwert" to "-60" in row 2
And I set field "mge" to "-1" in row 3
And I set field "mge" to "-6" in row 4
And I set field "pwert" to "-110" in row 5
And I append rows
   | artikel | pwert  |
   | NEUPOS  | 100.00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# Artikelposition
Then field "remge" from editor "1RE011" in row 1 has value "-100"
Then field "ofwert" from editor "1RE011" in row 1 has value "-5300.00"
Then field "remge" from editor "1LS011" in row 1 has value "0"

# Text-Position
Then field "remge" from editor "1RE011" in row 2 has value "-100"
Then field "ofwert" from editor "1RE011" in row 2 has value "-40.00"
Then field "remge" from editor "1LS011" in row 2 has value "0"

# Dienstleistungsposition
Then field "remge" from editor "1RE011" in row 3 has value "-2"
Then field "ofwert" from editor "1RE011" in row 3 has value "-50.00"
Then field "remge" from editor "1LS011" in row 3 has value "0"

# AU/BE-Position
Then field "remge" from editor "1RE011" in row 4 has value "-10"
Then field "ofwert" from editor "1RE011" in row 4 has value "-28.00"
Then field "remge" from editor "1LS011" in row 4 has value "0"

# Neutrale-Position
Then field "remge" from editor "1RE011" in row 5 has value "-200"
Then field "ofwert" from editor "1RE011" in row 5 has value "-90.00"
Then field "remge" from editor "1LS011" in row 5 has value "0"


# 2. Teil-Wertgutschrift (Plausitests)
Given I open an editor "1WG0112" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE011"
And I set fields
   | such   | WG0112 |
   | ueb    | ja     |
   | tterm  | .      |

# Plausis Artikelposition
Then field "ofwert" has value "-5300.00" in row 1
Then field "pwert" has value "0.00" in row 1

And I set field "mge" to "-53" in row 1
Then field "pwert" has value "-5300.00" in row 1
Then field "proz" has value "0" in row 1

# Max. pwert wuerde ueberschritten werden -> Ausgleich durch Zu-/Abschlag
And I set field "mge" to "-54" in row 1
Then field "pwert" has value "-5300.00" in row 1
Then field "proz" has value "-1.85" in row 1

And I set field "mge" to "-100" in row 1
Then field "pwert" has value "-5300.00" in row 1
Then field "proz" has value "-47" in row 1

# Niedriger Preis grosse Menge moeglich
And I set field "preis" to "0" in row 1
And I set field "mge" to "-1" in row 1
And I set field "preis" to "10" in row 1
And I set field "mge" to "-70" in row 1
Then field "pwert" has value "-700.00" in row 1
Then field "proz" has value "0" in row 1

# Durch Preiserhoehung wuerde max. pwert ueberschritten werden -> Ausgleich durch Zu-/Abschlag
And I set field "preis" to "100" in row 1
Then field "pwert" has value "-5300.00" in row 1
Then field "proz" has value "-24.29" in row 1

# Zuruecksetzen Zu-Abschlag durch preis=0, mge=0
And I set field "preis" to "0" in row 1
And I set field "mge" to "0" in row 1
And I set field "preis" to "100" in row 1
Then field "pwert" has value "0.00" in row 1
Then field "proz" has value "0" in row 1

# Offene Menge uebernehmen, uebernimmt maximale Menge
# dadurch wuerde max. pwert ueberschritten werden -> Ausgleich durch Zu-/Abschlag
And I press button "offueb" in row 1
Then field "pwert" has value "-5300.00" in row 1
Then field "preis" has value "100.00" in row 1
Then field "proz" has value "-47" in row 1

# Textposition
Then setting field "pwert" to "-41" in row 2 throws the exception "11241"
And I set field "pwert" to "-39" in row 2
And I press button "offueb" in row 2
Then field "pwert" has value "-40.00" in row 2
Then field "preis" has value "0.00" in row 2
Then field "proz" has value "0" in row 2

# Dienstleistungsposition
#   | REPARIEREN |           2 |       50.00 | !dontChange |
And I set field "mge" to "-1" in row 3
Then setting field "pwert" to "-51" in row 3 throws the exception "11241"
And I set field "pwert" to "0" in row 3
And I set field "mge" to "-2" in row 3
Then field "pwert" has value "-50.00" in row 3
Then field "preis" has value "50.00" in row 3
Then field "proz" has value "-50" in row 3
# AU/BE-Position
And I set field "mge" to "-1" in row 4
Then setting field "pwert" to "-29" in row 4 throws the exception "11241"
And I set field "pwert" to "0" in row 4
And I set field "mge" to "-10" in row 4
Then field "pwert" has value "-28.00" in row 4
Then field "preis" has value "7.00" in row 4
Then field "proz" has value "-60" in row 4
And I set field "preis" to "0" in row 4
And I set field "mge" to "0" in row 4
And I set field "pwert" to "0" in row 4
And I set field "preis" to "7" in row 4
And I press button "offueb" in row 4
Then field "pwert" has value "-28.00" in row 4
Then field "preis" has value "7.00" in row 4
Then field "proz" has value "-60" in row 4

# Neutrale-Position
Then setting field "pwert" to "-91" in row 5 throws the exception "11241"
And I set field "pwert" to "-89" in row 5
And I press button "offueb" in row 5
Then field "pwert" has value "-90.00" in row 5
Then field "preis" has value "0.00" in row 5
Then field "proz" has value "0" in row 5

And I save the current editor

# WGS mindert remge in Rechnung
Then field "remge" from editor "1RE011" in row 1 has value "-100"
Then field "ofwert" from editor "1RE011" in row 1 has value "0.00"

# 3. Teil-Wertgutschrift Versuch - Ist nicht moeglich, da kein offener Gutschriftsbetrag mehr uebrig
Given I open an editor "1WG0113" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE011"
And I set fields
   | such   | WG0113 |
   | ueb    | ja     |
   | tterm  | .      |
Then field "mge" has value "0" in row 1
Then field "pwert" has value "0.00" in row 1
Then field "preis" has value "100.00" in row 1

# Offene Menge uebernehmen, tut nichts
And I press button "offueb" in row 1
Then field "mge" has value "0" in row 1
Then field "pwert" has value "0.00" in row 1
Then field "preis" has value "100.00" in row 1

Then setting field "mge" to "-1" in row 1 throws the exception "3227"
And I set field "mge" to "0" in row 1
And I set field "pwert" to "-1" in row 1
Then field "pwert" has value "0.00" in row 1

And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK - Plausis fuer maximalen offenen Gutschriftswert BE-LS-RE-TWGS1-TWGS2-TWGS3
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE012" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
| lief   | 1     |
| such   | BE012 |
| ebeleg | BE012 |
And I append rows
| artikel      | mge         | preis       | pwert       |
| V1           |         100 |         100 | !dontChange |
| TEXT         | !dontChange | !dontChange |      100.00 |
| dl-reparatur |           2 |       50.00 | !dontChange |
| AUBEPOS      |          10 |        7.00 | !dontChange |
| NEUPOS       | !dontChange | !dontChange |      200.00 |
And I save the current editor

# Lieferschein
Given I open an editor "1LS012" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE012"
And I set fields
| such   | LS0121 |
| ebeleg | LS0121 |
| ueb    | ja     |
| vom    | .      |
And I press button "offueb" in row 1
And I press button "offueb" in row 3
And I press button "offueb" in row 4
And I save the current editor

# Rechnung
Given I open an editor "1RE012" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS012"
And I set fields
| such   | RE012 |
| ebeleg | RE012 |
| ueb    | ja    |
| tterm  | .     |
| budat  | .     |
| vom    | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil-Wertgutschrift
Given I open an editor "1WG012" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE012"
And I set fields
| such   | WG012 |
| ebeleg | WG012 |
| ueb    | ja    |
| tterm  | .     |
| vom    | .     |
And I set field "mge" to "-47" in row 1
And I set field "pwert" to "-60" in row 2
And I set field "mge" to "-1" in row 3
And I set field "mge" to "-6" in row 4
And I set field "pwert" to "-110" in row 5
And I save the current editor

# Artikelposition
Then field "remge" from editor "1RE012" in row 1 has value "-100"
Then field "ofwert" from editor "1RE012" in row 1 has value "-5300.00"
Then field "remge" from editor "1LS012" in row 1 has value "0"

# Text-Position
Then field "remge" from editor "1RE012" in row 2 has value "-100"
Then field "ofwert" from editor "1RE012" in row 2 has value "-40.00"
Then field "remge" from editor "1LS012" in row 2 has value "0"

# Dienstleistungsposition
Then field "remge" from editor "1RE012" in row 3 has value "-2"
Then field "ofwert" from editor "1RE012" in row 3 has value "-50.00"
Then field "remge" from editor "1LS012" in row 3 has value "0"

# AU/BE-Position
Then field "remge" from editor "1RE012" in row 4 has value "-10"
Then field "ofwert" from editor "1RE012" in row 4 has value "-28.00"
Then field "remge" from editor "1LS012" in row 4 has value "0"

# Neutrale-Position
Then field "remge" from editor "1RE012" in row 5 has value "-200"
Then field "ofwert" from editor "1RE012" in row 5 has value "-90.00"
Then field "remge" from editor "1LS012" in row 5 has value "0"


# 2. Teil-Wertgutschrift (Plausitests)
Given I open an editor "1WG0122" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE012"
And I set fields
| such   | WG0122 |
| ebeleg | WG0122 |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |

# Plausis Artikelposition
Then field "ofwert" has value "-5300.00" in row 1
Then field "pwert" has value "0.00" in row 1

And I set field "mge" to "-53" in row 1
Then field "pwert" has value "-5300.00" in row 1
Then field "proz" has value "0" in row 1

# Max. pwert wuerde ueberschritten werden -> Ausgleich durch Zu-/Abschlag
And I set field "mge" to "-54" in row 1
Then field "pwert" has value "-5300.00" in row 1
Then field "proz" has value "-1.85" in row 1

And I set field "mge" to "-100" in row 1
Then field "pwert" has value "-5300.00" in row 1
Then field "proz" has value "-47" in row 1

# Niedriger Preis grosse Menge moeglich
And I set field "preis" to "0" in row 1
And I set field "mge" to "-1" in row 1
And I set field "preis" to "10" in row 1
And I set field "mge" to "-70" in row 1
Then field "pwert" has value "-700.00" in row 1
Then field "proz" has value "0" in row 1

# Durch Preiserhoehung wuerde max. pwert ueberschritten werden -> Ausgleich durch Zu-/Abschlag
And I set field "preis" to "100" in row 1
Then field "pwert" has value "-5300.00" in row 1
Then field "proz" has value "-24.29" in row 1

# Zuruecksetzen Zu-Abschlag durch preis=0, mge=0
And I set field "preis" to "0" in row 1
And I set field "mge" to "0" in row 1
And I set field "preis" to "100" in row 1
Then field "pwert" has value "0.00" in row 1
Then field "proz" has value "0" in row 1

# Offene Menge uebernehmen, uebernimmt maximale Menge
# dadurch wuerde max. pwert ueberschritten werden -> Ausgleich durch Zu-/Abschlag
And I press button "offueb" in row 1
Then field "pwert" has value "-5300.00" in row 1
Then field "preis" has value "100.00" in row 1
Then field "proz" has value "-47" in row 1

# Textposition
Then setting field "pwert" to "-41" in row 2 throws the exception "11241"
And I set field "pwert" to "-39" in row 2
And I press button "offueb" in row 2
Then field "pwert" has value "-40.00" in row 2
Then field "preis" has value "0.00" in row 2
Then field "proz" has value "0" in row 2

# Dienstleistungsposition
And I set field "mge" to "-1" in row 3
Then setting field "pwert" to "-51" in row 3 throws the exception "11241"
And I set field "pwert" to "0" in row 3
And I set field "mge" to "-2" in row 3
Then field "pwert" has value "-50.00" in row 3
Then field "preis" has value "50.00" in row 3
Then field "proz" has value "-50" in row 3
# AU/BE-Position
And I set field "mge" to "-1" in row 4
Then setting field "pwert" to "-29" in row 4 throws the exception "11241"
And I set field "pwert" to "0" in row 4
And I set field "mge" to "-10" in row 4
Then field "pwert" has value "-28.00" in row 4
Then field "preis" has value "7.00" in row 4
Then field "proz" has value "-60" in row 4
And I set field "preis" to "0" in row 4
And I set field "mge" to "0" in row 4
And I set field "pwert" to "0" in row 4
And I set field "preis" to "7" in row 4
And I press button "offueb" in row 4
Then field "pwert" has value "-28.00" in row 4
Then field "preis" has value "7.00" in row 4
Then field "proz" has value "-60" in row 4

# Neutrale-Position
Then setting field "pwert" to "-91" in row 5 throws the exception "11241"
And I set field "pwert" to "-89" in row 5
And I press button "offueb" in row 5
Then field "pwert" has value "-90.00" in row 5
Then field "preis" has value "0.00" in row 5
Then field "proz" has value "0" in row 5

And I save the current editor

# WGS mindert remge in Rechnung
Then field "remge" from editor "1RE012" in row 1 has value "-100"
Then field "ofwert" from editor "1RE012" in row 1 has value "0.00"

# 3. Teil-Wertgutschrift Versuch - Ist nicht moeglich, da kein offener Gutschriftsbetrag mehr uebrig
Given I open an editor "1WG0123" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE012"
And I set fields
| such   | WG0123 |
| ebeleg | WG0123 |
| ueb    | ja     |
| tterm  | .      |
Then field "mge" has value "0" in row 1
Then field "pwert" has value "0.00" in row 1
Then field "preis" has value "100.00" in row 1

# Offene Menge uebernehmen, tut nichts
And I press button "offueb" in row 1
Then field "mge" has value "0" in row 1
Then field "pwert" has value "0.00" in row 1
Then field "preis" has value "100.00" in row 1

Then setting field "mge" to "-1" in row 1 throws the exception "3227"
And I set field "mge" to "0" in row 1
And I set field "pwert" to "-1" in row 1
Then field "pwert" has value "0.00" in row 1

# ----------------------------------------------------------------------------------------------
Scenario: RE+LB mehrere TWGS inkl Gesamtrabatt - Pruefung beim Speichern, ob max GS Betrag nicht ueberschritten wird
# ----------------------------------------------------------------------------------------------

# Rechnung mit LB
Given I open an editor "RE67" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| kunde        | 1      |
	| such         | RE67   |
	| ueb          | ja     |
	| tterm        | .      |
	| vom          | .      |
	| fakt         | ja     |
And I append rows
	| artikel | mge         | preis       | proz        |
	| V1      | 10          | 20          |   0         |
	| V2      | 20          | 20          |   0         |
	| PR.     | !dontChange | !dontChange |  -10        |
	| V1      | 5           | 20          |   0         |
	| V2      | 8           | 20          |   0         |
	| ZS.     | !dontChange | !dontChange | !dontChange |
	| PR.     | !dontChange | !dontChange |  -20        |

And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
Then field "ofwert" from editor "RE67" in row 1 has value "-200.00"
Then field "ofwert" from editor "RE67" in row 2 has value "-400.00"
Then field "ofwert" from editor "RE67" in row 3 has value "40.00"
Then field "ofwert" from editor "RE67" in row 4 has value "-100.00"
Then field "ofwert" from editor "RE67" in row 5 has value "-160.00"
Then field "ofwert" from editor "RE67" in row 6 has value "0.00"
Then field "ofwert" from editor "RE67" in row 7 has value "164.00"

# Teil-WGS Versuch wegen Loeschen Gesamtrabatt auf Zwischensumme
Given I open an editor "WG67" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE67"
And I set fields
   | such   | WG67X      |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
And I press button "komplettieren"
Then table has values
  | komplettgutschrift |
  |                 ja |
  |                 ja |
  |               nein |
  |                 ja |
  |                 ja |
  |               nein |
  |               nein |
  |               nein |
  |               nein |
# Rabattzeile loeschen
And I delete row at position 3
Then table has values
  | komplettgutschrift |
  |                 ja |
  |               nein |
  |                 ja |
  |                 ja |
  |               nein |
  |               nein |
  |               nein |
  |               nein |

# Rabattzeile nach Zwischensumme loeschen -> Alles wird zur TWG
And I delete row at position 6
Then field "komplettgutschrift" has value "nein" in row 2
Then table has values
  | komplettgutschrift |
  |               nein |
  |               nein |
  |               nein |
  |               nein |
  |               nein |
  |               nein |
  |               nein |
And I close the current editor

# Teil-WGS zu RE+LB
Given I open an editor "WG67" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE67"
And I set fields
   | such   | WG67       |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
Then field "komplettgutschrift" has value "nein" in row 2
And I press button "komplettieren"
Then field "komplettgutschrift" has value "ja" in row 2
# Rabattzeile loeschen
And I delete row at position 3
Then field "komplettgutschrift" has value "nein" in row 2

# Erwarteter Fehler: Gutzuschreibender Betrag zu hoch.
Then saving the current editor throws the exception "2792"
And I set field "pwert" to "-300" in row 2
And I save the current editor

Then field "ofwert" from editor "RE67" in row 1 has value "-200.00"
Then field "rekorrektur" from editor "RE67" in row 1 has value "ja"
Then field "ofwert" from editor "RE67" in row 2 has value "-100.00"
Then field "ofwert" from editor "RE67" in row 3 has value "40.00"

# 2. Teil-WGS zu RE+LB
Given I open an editor "WG67B" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE67"
And I set fields
   | such   | WG67B      |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
And I press button "buwertgutschrift"
Then field "artikel" has value "V2" in row 1
And I set field "mge" to "-20" in row 1
And I set field "pwert" to "-20" in row 1
And I append rows
   | artikel | pwert  |
   | NEUPOS  | 90.00  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "ofwert" from editor "RE67" in row 1 has value "-200.00"
Then field "rekorrektur" from editor "RE67" in row 1 has value "ja"
Then field "ofwert" from editor "RE67" in row 2 has value "-80.00"
Then field "ofwert" from editor "RE67" in row 3 has value "38.00"

# 3. Teil-WGS zu RE+LB Rest
Given I open an editor "WG67B" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE67"
And I set fields
   | such   | WG67C      |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
And I press button "buwertgutschrift"
Then field "artikel" has value "V2" in row 1
And I set field "mge" to "-20" in row 1
Then field "pwert" has value "-80.00" in row 1
# Rabattzeile loeschen
And I delete row at position 2
And I set field "pwert" to "-43" in row 1
# Erwarteter Fehler: Gutzuschreibender Betrag zu hoch.
Then saving the current editor throws the exception "2792"
And I set field "pwert" to "-42" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK - AU - LS - RE - TWG1 - TWG2 -> Storno TWG2 zuerst, dann erst TWG1 (LIFO - Vorgehen)
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU060" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU060 |
   | kunde   | 1      |
   | such    | AU060  |
And I append rows
   | artikel | mge | preis |
   | V1      | 10  | 59    |
And I save the current editor

# Lieferschein
Given I open an editor "1LS060" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU060"
And I set fields
   | nummer | 1LS060 |
   | such   | LS060  |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | ja     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE060" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS060"
And I set fields
   | nummer | 1RE060 |
   | such   | RE060  |
   | ueb    | ja     |
   | tterm  | .      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift 1
Given I open an editor "1WG060" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE060"
And I set fields
   | nummer | 1WG060 |
   | such   | WG060  |
   | ueb    | ja     |
   | tterm  | .      |
And I set field "mge" to "-2" in row 1
And I save the current editor

# Teilwertgutschrift 2
Given I open an editor "2WG060" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE060"
And I set fields
   | nummer | 2WG060  |
   | such   | WG060_2 |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Erste Teilwertgutschrift darf nicht vor der spaeter erfassten TWG storniert werden. LIFO - Prinzip.
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "1WG060" throws the exception "3335"

# Storno der 2ten TWG erlaubt
Given I open an editor "ST_2WG060" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "2WG060"
And I save the current editor

# Storno der ersten TWG nun erlaubt
Given I open an editor "ST_1WG060" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "1WG060"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK - AU - RE mit LB - TWG1 - TWG2 -> Storno TWG2 zuerst, dann erst TWG1 (LIFO - Vorgehen)
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU061" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU061 |
   | kunde   | 1      |
   | such    | AU061  |
And I append rows
   | artikel | mge | preis |
   | V1      | 12  | 61    |
And I save the current editor

# Rechnung mit LB
Given I open an editor "1RE061" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "1AU061"
And I set fields
   | such   | RE-AU061 |
   | nummer | 1RE061   |
   | ueb    | ja       |
   | tterm  | .        |
   | budat  | .        |
And I set field "mge" to "12" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift 1
Given I open an editor "1WG061" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE061"
And I set fields
   | nummer | 1WG061  |
   | such   | WG061_1 |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-2" in row 1
And I save the current editor

# Teilwertgutschrift 2
Given I open an editor "2WG061" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE061"
And I set fields
   | nummer | 2WG061  |
   | such   | WG061_2 |
   | ueb    | nein    |
   | tterm  | .       |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Storno TWG1 erlaubt, da TWG2 noch nicht gebucht
Given I open an editor "ST_1WG061" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "1WG061"
And I close the current editor

# TWG2 buchen
Given I open an editor "2WG061" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "2WG061"
And I set field "ueb" to "ja"
And I save the current editor

# TWG1 darf nicht vor der spaeter erfassten TWG2 storniert werden. LIFO - Prinzip.
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "1WG061" throws the exception "3335"

# Storno TWG2 erlaubt
Given I open an editor "ST_2WG061" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "2WG061"
And I save the current editor

# Storno TWG1 nun erlaubt
Given I open an editor "ST_1WG061" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "1WG061"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - AU - RE mit LB - 100%WG -> RK -> TWG1 dann TWG2 -> Storno TWG2 zuerst, dann erst TWG1 (LiFo - Vorgehen)
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU066" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU066 |
   | kunde   | 1      |
   | such    | AU066  |
And I append rows
   | artikel | mge | preis |
   | V1      | 12  | 66    |
And I save the current editor

# Rechnung mit LB
Given I open an editor "1RE066" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "1AU066"
And I set fields
   | such   | RE-AU066 |
   | nummer | 1RE066   |
   | ueb    | ja       |
   | tterm  | .        |
   | budat  | .        |
And I set field "mge" to "12" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "WERT-ZU-RE066" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE066"
And I set fields
   | nummer | 1WG066K  |
   | such   | WG066_K  |
   | ueb    | ja       |
   | tterm  | .        |
   | budat  | .        |
Then the table has 4 rows
And I set field "mge" to "-12" in row 1
And I press button "komplettieren"
And I save the current editor

# Rechnungskorrektur
Given I open an editor "RK066" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE066"
And I set fields
   | nummer | 1RK066 |
   | such   | RK066  |
   | ueb    | ja     |
   | tterm  | .      |
   | budat  | .      |
And I press button "burekorrektur"
And I set field "mge" to "12" in row 1
And I save the current editor

# Teilwertgutschrift 1
Given I open an editor "1WG066" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RK066"
And I set fields
   | nummer | 1WG066  |
   | such   | WG066_1 |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-2" in row 1
And I save the current editor

# Teilwertgutschrift 2
Given I open an editor "2WG066" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RK066"
And I set fields
   | nummer | 2WG066  |
   | such   | WG066_2 |
   | ueb    | nein    |
   | tterm  | .       |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Storno TWG1 erlaubt, da TWG2 noch nicht gebucht
Given I open an editor "ST_1WG066" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "1WG066"
And I close the current editor

# TWG2 buchen
Given I open an editor "2WG066" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "2WG066"
And I set field "ueb" to "ja"
And I save the current editor

# TWG1 darf nicht vor der spaeter erfassten TWG2 storniert werden. LIFO - Prinzip.
Then opening an editor from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "1WG066" throws the exception "3335"

# Storno TWG2 erlaubt
Given I open an editor "ST_2WG066" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "2WG066"
And I save the current editor

# Storno TWG1 nun erlaubt
Given I open an editor "ST_1WG066" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "1WG066"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - AU - LS - RE Barzahlung - 100%WG
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU068" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1     |
   | such    | AU068 |
And I append rows
   | artikel | mge | preis |
   | V1      | 12  | 67    |
And I save the current editor

# Lieferschein
Given I open an editor "LS068" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU068"
And I set fields
   | such   | LS068 |
   | ueb    | ja    |
   | vom    | .     |
   | fakt   | ja    |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung Barzahlung
Given I open an editor "RE068" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS068"
And I set fields
   | such   | RE068  |
   | ueb    | ja     |
   | tterm  | .      |
And I set field "vorganga" to "Barzahlung"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettgutschrift
Given I open an editor "WG068" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE068"
And I set fields
   | such   | WG068 |
   | ueb    | ja    |
   | tterm  | .     |
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "wertgutschrift" has value "ja"
And I set field "mge" to "-10" in row 1
And I save the current editor

# Rechnungskorrektur Barzahlung
Given I open an editor "REK068" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS068"
And I set fields
   | such   | REK068 |
   | ueb    | ja     |
   | tterm  | .      |
# Bei RE aus LS wird auf "Rechnung" gestellt. Der Anwender kann entscheiden, ob er wieder eine Barrechnung moechte
Then field "vorganga" has value "Rechnung"
And I press button "offueb" in row 1
And I set field "preis" to "1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: RE+LB Barrechnung - 100%WG - REKorr
# ----------------------------------------------------------------------------------------------

# Rechnung Barzahlung
Given I open an editor "RE069" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | kunde  | 1     |
   | such   | RE069 |
   | ueb    | ja    |
   | tterm  | .     |
   | fakt   | ja    |
And I append rows
   | artikel | mge | preis |
   | V1      | 12  | 67    |
And I set field "vorganga" to "Barzahlung"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "WG069" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE069"
And I set fields
   | such   | WG069 |
   | ueb    | ja    |
   | tterm  | .     |
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "wertgutschrift" has value "ja"
And I set field "mge" to "-12" in row 1
And I save the current editor

# Rechnungskorrektur Barzahlung
Given I open an editor "REK069" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE069"
And I set fields
   | such   | REK069 |
   | ueb    | ja     |
   | tterm  | .      |
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I press button "burekorrektur"
Then field "vorganga" has value "Barzahlung"
And I press button "offueb" in row 1
And I set field "preis" to "1" in row 1
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - AU - LS - RE1 + RE2 - 100%WG ueber Beleg anfuegen nach Eingabe des Kunden
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU070" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU070 |
   | kunde   | 1      |
   | such    | AU070  |
And I append rows
   | artikel | mge | preis |
   | V1      | 20  | 15    |
And I save the current editor

# Lieferschein
Given I open an editor "1LS070" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU070"
And I set fields
   | nummer | 1LS070 |
   | such   | LS070  |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | ja     |
And I set field "mge" to "20" in row 1
And I save the current editor

# Rechnung 1
Given I open an editor "1RE070A" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS070"
And I set fields
   | nummer | 1RE070A |
   | such   | RE070A  |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "16" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 2
Given I open an editor "1RE070B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS070"
And I set fields
   | nummer | 1RE070B |
   | such   | RE070B  |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift ueber Beleg anfuegen nach Eingabe des Kunden
Given I open an editor "1WG070" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1WG070 |
   | such   | WG070  |
   | ueb    | ja     |
   | kunde  | 1      |
   | tterm  | .      |
   | vom    | .      |
And I create a new row at position 1
And I set field "artex" to "V1" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "20" in row 1
# An eine Rechnung mit nicht leerer Tabellle darf keine Rechnung angefuegt werden
And setting field "beleg" to "+1RE070A" throws the exception "4615"
# Zeile loeschen -> leere Tabelle
And I delete row at position 1
# Beleg anfuegen moeglich
And I set field "beleg" to "+1RE070A"
Then field "wertgutschrift" has value "ja"
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I press button "komplettieren"
Then field "mge" has value "-16" in row 1
# Weitere Rechnungen duerfen nicht angefuegt werden
And setting field "beleg" to "+1RE070B" throws the exception "6822"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK - Wertgutschrift aus Rechnungskorrektur - Rechnung mit Lagerbewegung
# ----------------------------------------------------------------------------------------------

# Rechnung mit Lagerbewegung
Given I open an editor "RE071" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE071 |
   | lief   | 1      |
   | such   | RE071  |
   | ebeleg | RE071  |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | ja     |
And I append rows
   | artikel | mge         | preis        | pwert       |
   | E1      | 30          | 14           | !dontChange |
   | EINK    | 20          | 11           | !dontChange |
   | TEXT    | !dontChange | !dontChange  | 45          |
   | TEXT    | !dontChange | !dontChange  | 76          |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift fuer Position 1
Given I open an editor "WG071A" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE071"
And I set fields
   | nummer | 1WG071A |
   | such   | WG071   |
   | ebeleg | WG071   |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-30" in row 1
And I set field "pwert" to "-45" in row 3
And I delete row at position 2
And I delete row at position 4
And I save the current editor

Then field "rekorrektur" from editor "RE071" in row 1 has value "ja"
Then field "rekorrektur" from editor "RE071" in row 2 has value "nein"
Then field "rekorrektur" from editor "RE071" in row 3 has value "ja"
Then field "rekorrektur" from editor "RE071" in row 4 has value "nein"
Then field "remge" from editor "RE071" in row 1 has value "30"
Then field "remge" from editor "RE071" in row 2 has value "-20"
Then field "remge" from editor "RE071" in row 3 has value "45"
Then field "remge" from editor "RE071" in row 4 has value "-76"

# Komplettwertgutschrift fuer Position 2 ueber Beleg anfuegen
Given I open an editor "WG071B" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg  | +1RE071 |
   | nummer | 1WG071B |
   | such   | WG071   |
   | ebeleg | WG071   |
   | ueb    | ja      |
   | vom    | .       |
Then field "wertgutschrift" has value "ja"
# Es werden nur Wertgutschriftszeilen uebernommen
Then the table has 5 rows
And I set field "mge" to "-20" in row 1
And I set field "pwert" to "-76" in row 2
And I save the current editor

Then field "rekorrektur" from editor "RE071" in row 2 has value "ja"
Then field "remge" from editor "RE071" in row 2 has value "20"
Then field "rekorrektur" from editor "RE071" in row 4 has value "ja"
Then field "remge" from editor "RE071" in row 4 has value "76"

# ----------------------------------------------------------------------------------------------
Scenario: VK - Wertgutschrift mit Materialzuschlag + Provisionssatz - Provision wir aus der RE uebernommen
# ----------------------------------------------------------------------------------------------

# Auftrag anlegen
Given I open an editor "AU072" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU072 |
   | kunde   | 1      |
   | such    | AU072  |
   And I append rows
   | artikel  | mge | preis |
   | !TECH006 | 72  | 7     |
And I save the current editor

# VK-Lieferschein erzeugen
Given I open an editor "VK_LS_72" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU072"
And I set fields
   | nummer | 1VKLS72 |
   | such   | LS072-1 |
   | ueb    | ja      |
   | vom    | .       |
Then the table has 2 rows
And I press button "offueb" in row 1
And I save the current editor

# Rechnung zu LS erzeugen
Given I open an editor "VK_RE_72" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "VK_LS_72"
And I set fields
   | nummer | 1VKRE72 |
   | such   | RE072-1 |
   | ueb    | ja      |
   | vom    | .       |
   | term   | .       |
Then field "pros" has value "10" in row 1
Then field "pros" has value "10" in row 2
And I set field "mge" to "70" in row 1
And I set field "pros" to "8" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift anlegen
Given I open an editor "VK_WG_72" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "VK_RE_72"
And I set fields
   | nummer | 1WG072  |
   | such   | WG072-1 |
   | vom    | .       |
Then field "pros" has value "10" in row 1
Then field "pros" has value "8" in row 2
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK: Vorgangsverkettung BE - RE ohne LB - 100% WG - LS (fakturierbar) - Storno 100% WG
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE072" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE072 |
   | lief    | 1      |
   | such    | BE072  |
And I append rows
   | artikel | mge  | preis |
   | TE007   | 100  | 10    |
And I save the current editor

# Rechnung ohne Lagerbewegung
Given I open an editor "1RE072" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE072"
And I set fields
   | nummer | 1RE072 |
   | such   | RE072  |
   | fakt   | nein   |
   | ueb    | ja     |
   | vom    | .      |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "1WG072" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE072"
And I set fields
   | nummer | 1WG072 |
   | such   | WG072  |
   | ueb    | ja     |
   | vom    | .      |
And I press button "komplettieren"
And I save the current editor

# Lieferschein (fakturierbar)
Given I open an editor "1LS072" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE072"
And I set fields
   | nummer | 1LS072 |
   | such   | LS072  |
   | fakt   | ja     |
   | ueb    | nein   |
   | vom    | .      |
And I press button "offueb" in row 1
And I save the current editor

# Storno der Wertgutschrift - Nicht erlaubt, weil sonst Ueberberechnung moeglich
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1WG072" throws the exception "3335"

# Lieferschein buchen
Given I open an editor "1LS072" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "1LS072"
And I set fields
   | ueb    | ja     |
And I save the current editor

# Storno der Wertgutschrift - weiterhin nicht erlaubt
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1WG072" throws the exception "3335"

# Storno LS
Given I open an editor "1LS072_STORNO" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "1LS072"
Then field "druck" is modifiable
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK - RE mit LB - WG 100% - REK1 ungebucht - weitere WGS/REK nicht erlaubt
# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "1RE073" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | nummer | 1RE073 |
   | such   | RE073  |
   | ueb    | ja     |
   | tterm  | .      |
   | fakt   | ja     |
And I append rows
   | artikel | mge | preis |
   | V1      | 11  | 73    |
   | V2      | 22  | 66    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift
Given I open an editor "WG073" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE073"
And I set fields
   | nummer | 1WG073 |
   | such   | WG073  |
   | ueb    | ja     |
   | tterm  | .      |
And I press button "offueb" in row 1
And I save the current editor

# Rechnungskorrektur ungebucht
Given I open an editor "REK073" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE073"
And I set fields
   | such   | REK073_1 |
   | ueb    | nein     |
   | tterm  | .        |
And I press button "burekorrektur"
And I set field "mge" to "2" in row 1
And I save the current editor

# Weitere Rechnungskorrektur nicht erlaubt, da bereits eine ungebuchte Rechnungskorrektur vorhanden ist.
# Unterscheidung Rechnungskorrektur/Wertgutschrift nicht moeglich
Then opening an editor from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE073" throws the exception "10362"

# Rechnung mit LB
Given I open an editor "1RE074" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | nummer | 1RE074 |
   | such   | RE074  |
   | ueb    | ja     |
   | tterm  | .      |
   | fakt   | ja     |
And I append rows
   | artikel | mge | preis |
   | V1      | 14  | 74    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift, ungebucht
Given I open an editor "WG074" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE074"
And I set fields
   | nummer | 1WG074 |
   | such   | WG074  |
   | ueb    | nein   |
   | tterm  | .      |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Wertgutschrift/Rechnungskorrektur erstellen nicht moeglich, da bereits eine ungebuchte Wertgutschrift vorhanden ist.
Then opening an editor from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE074" throws the exception "10362"


# ----------------------------------------------------------------------------------------------
Scenario: EK - RE ohne LB - WG 100% ungebucht - weitere WGS nicht erlaubt
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE076" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE076 |
   | lief    | 1      |
   | such    | BE076  |
And I append rows
   | artikel | mge  | preis |
   | TE007   | 100  | 10    |
And I save the current editor

# Rechnung ohne Lagerbewegung
Given I open an editor "1RE076" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE076"
And I set fields
   | nummer | 1RE076 |
   | such   | RE076  |
   | fakt   | nein   |
   | ueb    | ja     |
   | vom    | .      |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift ungebucht
Given I open an editor "1WG076" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE076"
And I set fields
   | nummer | 1WG076 |
   | such   | WG076  |
   | ueb    | nein   |
   | vom    | .      |
And I press button "komplettieren"
And I save the current editor

# Wertgutschrift erstellen nicht moeglich, da bereits eine ungebuchte Wertgutschrift vorhanden ist.
Then opening an editor from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE076" throws the exception "2455"

# ----------------------------------------------------------------------------------------------
Scenario: EK - Komplettwertgutschrift zu Nullrechnung
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE75" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
	| lief   | 1     |
	| nummer | 1RE75 |
	| such   | RE75  |
	| ueb    | ja    |
	| tterm  | .     |
	| vom    | .     |
	| fakt   | ja    |
And I append rows
	| artikel | mge | preis |
	| EINK    | 34  |  0    |
	| AUBEPOS |  3  |  0    |
	| DL-HANA |  1  |  0    |
And I save the current editor

Given I open an editor "WERT-ZU-RE75" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE75"
And I set fields
   | nummer | 1WGS75 |
   | such   | WGS75  |
   | ueb    | ja     |
   | vom    | .      |
   | budat  | .      |
Then the table has 3 rows
And I press button "komplettieren"
# 1 Position ohne Preis
# Es ist nichts gutzuschreiben. Komplette Menge wird trotzdem uebernommmen.
Then table has values
   | artikel     | mge | preis | pwert | komplettgutschrift |
   | EINK        | -34 | 0.00  | 0.00  | ja                 |
   | AUBEPOS     |  -3 | 0.00  | 0.00  | ja                 |
   | DL-HANALYSE |  -1 | 0.00  | 0.00  | ja                 |
# Komplette Menge wird uebertragen
And I set field "mge" to "0" in row 1
And I press button "offueb" in row 1
Then field "mge" has value "-34" in row 1
And I set field "mge" to "0" in row 2
And I press button "offueb" in row 2
Then field "mge" has value "-3" in row 2
And I set field "mge" to "0" in row 3
And I press button "offueb" in row 3
Then field "mge" has value "-1" in row 3
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario:  WGS Ab-Zuschlag, preis, pwert aendern keinen Einfluss auf Komplettwertgutschrift
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE77" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "such" to "RE77"
And I set field "ueb" to "ja"
And I set field "tterm" to "."
And I append rows
    | artex    | mge         | proz        |
    | v1       | 10          | !dontChange |
    | v2       | 10          | 10          |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "WGS77" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE77"
Then table has values
   | artikel | mge | preis  | proz | pwert   | komplettgutschrift |
   | V1      |   0 |  25.00 | 0    |    0.00 | nein               |
   | V2      |   0 |  20.00 | 10   |    0.00 | nein               |

And I press button "komplettieren"
Then table has values
   | artikel | mge | preis  | proz | pwert   | komplettgutschrift |
   | V1      | -10 |  25.00 | 0    | -250.00 | ja                 |
   | V2      | -10 |  20.00 | 10   | -220.00 | ja                 |

And I set field "mge" to "-9" in row 1
And I set field "preis" to "10" in row 2
And I set field "pwert" to "-80" in row 2

Then table has values
   | artikel | mge | preis  | proz | pwert   | komplettgutschrift |
   | V1      | -9  |  25.00 | 0    | -225.00 | nein               |
   | V2      | -10 |  10.00 | -20  |  -80.00 | nein               |

And I press button "komplettieren"
Then table has values
   | artikel | mge | preis  | proz | pwert   | komplettgutschrift |
   | V1      | -10 |  25.00 | 0    | -250.00 | ja                 |
   | V2      | -10 |  20.00 | 10   | -220.00 | ja                 |
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario:  WGS Preis aendern auch bei negativem Abschlag
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE90" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "such" to "RE90"
And I set field "ueb" to "ja"
And I set field "tterm" to "."
And I append rows
    | artex    | mge | proz        |
    | V1       | 10  | !dontChange |
    | V2       | 10  | -10         |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "WGS90" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE90"
And I press button "komplettieren"
Then table has values
   | artikel | mge | preis  | proz | pwert   | komplettgutschrift |
   | V1      | -10 |  25.00 | 0    | -250.00 | ja                 |
   | V2      | -10 |  20.00 | -10  | -180.00 | ja                 |

And I set field "preis" to "18" in row 2
Then table has values
   | artikel | mge | preis  | proz | pwert   | komplettgutschrift |
   | V1      | -10 |  25.00 | 0    | -250.00 | ja                 |
   | V2      | -10 |  18.00 | 0    | -180.00 | nein               |

# Gutzuschreibender Positionswert zu hoch.
Then setting field "pwert" to "-181" in row 2 throws the exception "11241"
And I set field "preis" to "19" in row 2
Then field "proz" has value "-5.26" in row 2
And I set field "preis" to "10" in row 2
And I set field "pwert" to "-170" in row 2

Then table has values
   | artikel | mge | preis  | proz | pwert   | komplettgutschrift |
   | V1      | -10 |  25.00 | 0    | -250.00 | ja                 |
   | V2      | -10 |  10.00 | 70   | -170.00 | nein               |

And I press button "komplettieren"
Then table has values
   | artikel | mge | preis  | proz | pwert   | komplettgutschrift |
   | V1      | -10 |  25.00 | 0    | -250.00 | ja                 |
   | V2      | -10 |  20.00 | -10  | -180.00 | ja                 |

# Bei einer Komplettgutschrift werden Preisaenderungen ignoriert:
# (Ursprungs)preis wird wieder herangezogen. (pwert und mge sind gleich)
And I set field "preis" to "18" in row 2
And I press button "komplettieren"
Then table has values
   | artikel | mge | preis  | proz | pwert   | komplettgutschrift |
   | V1      | -10 |  25.00 | 0    | -250.00 | ja                 |
   | V2      | -10 |  20.00 | -10  | -180.00 | ja                 |
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK - Pruefung von Vorgangs- und Buchungsdatum in der Wertgutschrift
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE76" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
	| lief   | 1     |
	| nummer | 1RE76 |
	| such   | RE76  |
	| ueb    | ja    |
	| vom    | .     |
	| fakt   | ja    |
And I append rows
	| artikel | mge | preis |
	| EINK    | 10  | 100   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "WERT-ZU-RE76" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE76"
And I set fields
    | nummer | 1WGS76 |
    | such   | WGS76  |
    | ueb    | ja     |
    | vom    | -1     |
    | budat  | -1     |
    | ophist |        |
And I press button "komplettieren"
Then saving the current editor throws the exception "3268"
And I set field "vom" to "."
Then saving the current editor throws the exception "3238"
And I set field "budat" to "."
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK: AU - RE ohne LB - 100% WG - REK1 alle Positionen aus dem AU uebernehmen
# ----------------------------------------------------------------------------------------------

Given I open an editor "1AU075" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1AU075 |
	| kunde  | 1      |
	| such   | AU075  |
	| vom    | .      |
And I append rows
	| artikel | mge         | preis       | pwert       |
	| V1      |  30         | 20          | !dontChange |
	| TEXT    | !dontChange | !dontChange | -10         |
	| NEUPOS  | !dontChange | !dontChange | -20         |
And I save the current editor

# Rechnung
Given I open an editor "1RE075" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU075"
And I set fields
	| nummer | 1RE075 |
	| such   | RE075  |
	| ueb    | ja     |
	| tterm  | .      |
	| budat  | .      |
	| fakt   | nein   |
And I press button "offueb" in row 1
Then field "status" has value "*" in row 1
Then field "status" has value "*" in row 2
Then field "status" has value "*" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift 100%
Given I open an editor "1WGS075" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE075"
And I set fields
	| nummer | 1WG075 |
	| such   | WG075  |
	| vom    | .      |
	| tterm  | .      |
And I press button "komplettieren"
Then field "status" has value "*" in row 1
Then field "status" has value "*" in row 2
Then field "status" has value "*" in row 3
And I save the current editor

# Status in der Rechnung pruefen
Given I open an editor "1RE075" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1RE075"
Then field "status" has value "*" in row 1
Then field "status" has value "*" in row 2
Then field "status" has value "*" in row 3
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK: AU mit negativen TEXT/Neutrale-Positionen - RE ohne LB - 100% WG - REK1 -> AU Status leer
# ----------------------------------------------------------------------------------------------

Given I open an editor "1AU078" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
	| nummer | 1AU078 |
	| kunde  | 1      |
	| such   | AU078  |
	| vom    | .      |
And I append rows
	| artikel | mge         | preis       | pwert       |
	| V1      |  30         | 20          | !dontChange |
	| TEXT    | !dontChange | !dontChange | -11         |
	| NEUPOS  | !dontChange | !dontChange | -21         |
And I save the current editor

# Rechnung
Given I open an editor "1RE078" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU078"
And I set fields
	| nummer | 1RE078 |
	| such   | RE078  |
	| ueb    | ja     |
	| tterm  | .      |
	| budat  | .      |
	| fakt   | nein   |
And I press button "offueb" in row 1
Then field "status" has value "*" in row 1
Then field "status" has value "*" in row 2
Then field "status" has value "*" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
Given I open an editor "1AU078" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU078"
Then field "remge" has value "0" in row 1
Then field "remge" has value "0" in row 2
Then field "remge" has value "0" in row 3
And I close the current editor

# Wertgutschrift 100%
Given I open an editor "1WGS078" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE078"
And I set fields
	| nummer | 1WG078 |
	| such   | WG078  |
	| vom    | .      |
	| tterm  | .      |
	| ueb    | ja     |
And I press button "komplettieren"
Then field "status" has value "*" in row 1
Then field "status" has value "*" in row 2
Then field "status" has value "*" in row 3
And I save the current editor
Given I open an editor "1AU078" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU078"
Then field "remge" has value "30" in row 1
Then field "remge" has value "-11" in row 2
Then field "remge" has value "-21" in row 3
And I close the current editor

# Status in der Rechnung/Auftrag pruefen
Given I open an editor "1RE078" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "1RE078"
Then field "status" has value "*" in row 1
Then field "status" has value "*" in row 2
Then field "status" has value "*" in row 3
And I close the current editor
Given I open an editor "1AU078" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "1AU078"
Then field "status" has value "" in row 1
Then field "status" has value "" in row 2
Then field "status" has value "" in row 3
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: TWGS Zeilen loeschen keine Auswirkung auf ofwert: AU-LS-RE-TWGS
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU079" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde | 1     |
    | such  | AU079 |
    | tterm | .     |
    | vom   | .     |
And I append rows
    | artikel  | mge         | pwert       | preis       |
    | V1       | 10          | !dontChange | 10          |
    | V2       | 10          | !dontChange | 10          |
    | text     | !dontChange | 100         | !dontChange |
    | NEUPOS   | !dontChange | 100         | !dontChange |
    | dl-repar | 10          | !dontChange | 10          |
    | AUBEPOS  | 10          | !dontChange | 10          |
And I save the current editor

Given I deliver the SalesOrder "AU079" with PackingSlip "LS079"
Given I invoice the PackingSlip "LS079" with Invoice "RE079"

# Teil-WGS ohne buchen
Given I open an editor "WGS079" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE079"
And I set fields
   | such   | WGS079 |
   | ueb    | nein   |
   | tterm  | .      |
   | budat  | .      |
And I set field "mge" to "-5" in row 1
And I set field "mge" to "-5" in row 2
And I set field "pwert" to "-50" in row 3
And I set field "pwert" to "-50" in row 4
And I set field "mge" to "-5" in row 5
And I set field "mge" to "-5" in row 6
And I save the current editor

# TWGS oeffnen und Positionen loeschen, dann buchen
Given I open an editor "WG079U" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "WGS079"
And I set fields
   | ueb    | ja |
And I delete row at position 6
And I delete row at position 5
And I delete row at position 4
And I delete row at position 3
And I delete row at position 2
And I save the current editor

Then field "ofwert" from editor "RE079" in row 1 has value "-50.00"
Then field "ofwert" from editor "RE079" in row 2 has value "-100.00"
Then field "ofwert" from editor "RE079" in row 3 has value "-100.00"
Then field "ofwert" from editor "RE079" in row 4 has value "-100.00"
Then field "ofwert" from editor "RE079" in row 5 has value "-100.00"
Then field "ofwert" from editor "RE079" in row 6 has value "-100.00"

# ----------------------------------------------------------------------------------------------
Scenario: TWGS Zeilen loeschen keine Auswirkung auf ofwert: RE+LB
# ----------------------------------------------------------------------------------------------

# Rechnung mit LB
Given I open an editor "RE080" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
    | kunde        | 1     |
    | such         | RE080 |
    | ueb          | ja    |
    | tterm        | .     |
    | vom          | .     |
    | budat        | .     |
    | fakt         | ja    |
And I append rows
    | artikel  | mge         | pwert       | preis       |
    | V1       | 10          | !dontChange | 10          |
    | V2       | 10          | !dontChange | 10          |
    | text     | !dontChange | 100         | !dontChange |
    | NEUPOS   | !dontChange | 100         | !dontChange |
    | dl-repar | 10          | !dontChange | 10          |
    | AUBEPOS  | 10          | !dontChange | 10          |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil-WGS ohne buchen
Given I open an editor "WGS080" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE080"
And I set fields
   | such   | WGS080 |
   | ueb    | nein   |
   | tterm  | .      |
   | budat  | .      |
And I set field "mge" to "-5" in row 1
And I set field "mge" to "-5" in row 2
And I set field "pwert" to "-50" in row 3
And I set field "pwert" to "-50" in row 4
And I set field "mge" to "-5" in row 5
And I set field "mge" to "-5" in row 6
And I save the current editor

# TWGS oeffnen und Positionen loeschen, dann buchen
Given I open an editor "WG080U" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "WGS080"
And I set fields
   | ueb    | ja       |
And I delete row at position 6
And I delete row at position 5
And I delete row at position 4
And I delete row at position 3
And I delete row at position 2
And I save the current editor

Then field "ofwert" from editor "RE080" in row 1 has value "-50.00"
Then field "ofwert" from editor "RE080" in row 2 has value "-100.00"
Then field "ofwert" from editor "RE080" in row 3 has value "-100.00"
Then field "ofwert" from editor "RE080" in row 4 has value "-100.00"
Then field "ofwert" from editor "RE080" in row 5 has value "-100.00"
Then field "ofwert" from editor "RE080" in row 6 has value "-100.00"

# ----------------------------------------------------------------------------------------------
Scenario: VK - Wertgutschrift zu Rechnung mit Konto nicht GuV
# ----------------------------------------------------------------------------------------------

# Konto 43001 nicht GuV
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "43000"
And I set field "nummer" to "43001"
And I set field "such" to "KO43001"
And I set field "gv" to "nein"
And I save the current editor

# Rechnung erzeugen
Given I open an editor "1RE081" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer  | 1RE081  |
   | kunde   | 1       |
   | such    | RE081-1 |
   | ueb     | ja      |
   | vom     | .       |
   | term    | .       |
And I append rows
   | artikel  | pwert | konto       |
   | TEXT     | 110   | 43001       |
   | TEXT     | 90    | !dontChange |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# VK-Wertgutschrift anlegen
Given I open an editor "1WG081" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE081"
And I set fields
   | nummer | 1WG081  |
   | such   | WG081-1 |
   | vom    | .       |
   | term   | .       |
And I press button "komplettieren"
Then field "konto" is not modifiable in row 1
Then field "fixkonto" is not modifiable in row 1
Then field "kstelle" is not modifiable in row 1
Then field "fixkstelle" is not modifiable in row 1
Then field "konto" is modifiable in row 2
Then field "fixkonto" is modifiable in row 2
Then field "kstelle" is modifiable in row 2
Then field "fixkstelle" is modifiable in row 2
And I set field "konto" to "43001" in row 2
Then field "konto" is modifiable in row 2
Then field "fixkstelle" is not modifiable in row 2
And I set field "konto" to "44000" in row 2
Then field "fixkstelle" is modifiable in row 2
And I set field "kstelle" to "101" in row 2
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK: BE-LS-RE-TWG1-(RLS mit KGS1)-TWG2-(RLS2 mit KGS2)-Storno TWG1 nicht erlaubt
# ----------------------------------------------------------------------------------------------
# Artikelposition
# Bestellung
Given I open an editor "1BE082" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE082 |
   | lief   | 1      |
   | such   | BE082  |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | E2      | 10          | 80          | !dontChange |
   | a.      | 9           | 1           | !dontChange |
   | TEXT    | !dontChange | !dontChange | -10         |
   | AUBEPOS | 6           | !dontChange | !dontChange |
And I save the current editor

# Lieferschein
Given I open an editor "1LS082" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE082"
And I set fields
   | nummer | 1LS082 |
   | such   | LS082  |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "10" in row 1
And I set field "mge" to "9" in row 2
And I set field "mge" to "4" in row 4
And I save the current editor
Then field "remge" from editor "1LS082" in row 1 has value "10"

# Rechnung ueber E2, Platzhalter und Textposition
Given I open an editor "1RE082" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS082"
And I set fields
   | nummer | 1RE082 |
   | such   | RE082  |
   | ueb    | ja     |
   | vom    | .      |
And I delete row at position 4
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
Then field "remge" from editor "1RE082" in row 1 has value "-10"

# Teilwertgutschrift ueber E2, Platzhalter und Textposition
Given I open an editor "1TWG082" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE082"
And I set fields
   | nummer | 1TWG082 |
   | such   | TWG082  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-3" in row 1
And I set field "mge" to "-3" in row 2
And I save the current editor
Then field "remge" from editor "1TWG082" in row 4 has value "0"

# Ruecklieferung 1 ueber AUBE-Pos
Given I open an editor "1RLS082" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS082"
And I set fields
   | nummer | 1RLS082 |
   | such   | RLS082  |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-2" in row 4
And I delete row at position 3
And I delete row at position 2
And I delete row at position 1
And I save the current editor
Then field "remge" from editor "1RLS082" in row 4 has value "0"

# Kaufmaenische Gutschrift AUBE-Pos zum RLS 1
Given I open an editor "KG-ZU-RLS082" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS082"
And I set fields
   | nummer | 1KG082   |
   | such   | EK-KG082 |
   | ueb    | ja       |
   | tterm  | .        |
   | budat  | .        |
   | vom    | .        |
Then the table has 1 rows
Then table has values
   | art     | mge | remge |
   | AUBEPOS | 0   | 0     |
And I close the current editor

# Storno Teilwertgutschrift
Given I open an editor "1WG082ST" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1TWG082"
And I close the current editor

# Ruecklieferung 2
Given I open an editor "2RLS082" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS082"
And I set fields
   | nummer | 2RLS082  |
   | such   | RLS082_2 |
   | ueb    | ja       |
   | tterm  | .        |
And I set field "mge" to "-2" in row 1
And I set field "mge" to "-2" in row 2
And I delete row at position 4
And I save the current editor

# KGS 2 zur Ruecklieferung 2
Given I open an editor "KG2-ZU-RLS082" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "2RLS082"
And I set fields
   | nummer | 2KG082    |
   | such   | EK-2KG082 |
   | ueb    | ja        |
   | tterm  | .         |
   | budat  | .         |
   | vom    | .         |
Then the table has 3 rows
And I create a new row at position 1
# Platzhalterposition hinzufuegen
And I set field "artex" to "a." in row 1
And I set field "mge" to "-2" in row 1
And I set field "preis" to "2" in row 1
And I delete row at position 4
And I delete row at position 3
And I delete row at position 2
And I create a new row at the end of the table
And I set field "artex" to "AUBEPOS" in row !lastRow
And I set field "mge" to "-1" in row !lastRow
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# Storno der TWG moeglich
Given I open an editor "1WG082ST" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1TWG082"
And I close the current editor

# KGS 3 zur Ruecklieferung 2
Given I open an editor "KG2-ZU-RLS082" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "2RLS082"
And I set fields
   | nummer | 3KG082    |
   | such   | EK-3KG082 |
   | ueb    | ja        |
   | tterm  | .         |
   | budat  | .         |
   | vom    | .         |
# Feld dfuesenden ist in kaufm. Gutschrift nicht gesetzt, aber aenderbar
Then field "dfuesenden" is modifiable
Then field "dfuesenden" has value "nein"
# Versand - EDI
Then field "ident" is modifiable
Then the table has 3 rows
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# Storno der TWG nicht erlaubt: Es existiert eine kaufmaennische Gutschrift.
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1TWG082" throws the exception "3335"


# ----------------------------------------------------------------------------------------------
Scenario: EK: BE - RE mit LB - TWG1 - RLS - KGS (Storno TWG1 nicht erlaubt)
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE083" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE083 |
   | lief   | 1      |
   | such   | BE083  |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | E2      | 10          | 80          | !dontChange |
   | a.      | 9           | 1           | !dontChange |
   | TEXT    | !dontChange | !dontChange | -10         |
   | AUBEPOS | 6           | !dontChange | !dontChange |
And I save the current editor

# Rechnung
Given I open an editor "1RE083" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE083"
And I set fields
   | nummer | 1RE083  |
   | such   | RE083   |
   | ebeleg | RE-83BE |
   | ueb    | ja      |
   | term   | .       |
   | vom    | .       |
   | fakt   | ja      |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I press button "offueb" in row 4
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift
Given I open an editor "1TWG083" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE083"
And I set fields
   | nummer | 1TWG083 |
   | such   | TWG083  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-3" in row 1
And I set field "mge" to "-3" in row 2
And I set field "mge" to "-3" in row 4
And I save the current editor

# Ruecklieferung 1
Given I open an editor "1RLS083" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "1RE083"
And I set fields
   | nummer | 1RLS083 |
   | such   | RLS083  |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-3" in row 1
And I set field "mge" to "-3" in row 2
And I set field "mge" to "-2" in row 4
And I save the current editor

# Kaufmaenische Gutschrift AUBE-Pos zum 1RLS083
Given I open an editor "KG-ZU-RLS083" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS083"
And I set fields
   | nummer | 1KG083   |
   | such   | EK-KG083 |
   | ueb    | nein     |
   | tterm  | .        |
   | budat  | .        |
   | vom    | .        |
Then the table has 4 rows
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# Storno der TWG nicht erlaubt: Es existiert eine ungebuchte kaufmaennische Gutschrift.
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1TWG083" throws the exception "3335"

Given I open an editor "KG-ZU-RLS083" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "KG-ZU-RLS083"
And I set fields
   | ueb    | ja     |
And I save the current editor

# Storno der TWG nicht erlaubt: Es existiert eine gebuchte kaufmaennische Gutschrift.
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1TWG083" throws the exception "3335"


# ----------------------------------------------------------------------------------------------
Scenario: EK: BE084 - LS - RE - TWG1 - RLS - KGS (Storno TWG1 nicht erlaubt)
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE084" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE084 |
   | lief   | 1      |
   | such   | BE084  |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | E2      | 10          | 80          | !dontChange |
   | a.      | 9           | 1           | !dontChange |
   | TEXT    | !dontChange | !dontChange | -10         |
   | AUBEPOS | 6           | !dontChange | !dontChange |
And I save the current editor

# Lieferschein
Given I open an editor "1LS084" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE084"
And I set fields
   | nummer | 1LS084 |
   | such   | LS084  |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | nein   |
And I set field "mge" to "10" in row 1
And I set field "mge" to "9" in row 2
And I set field "mge" to "4" in row 4
And I save the current editor

# Rechnung aus 1BE084
Given I open an editor "1RE084" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "1BE084"
And I set fields
   | nummer | 1RE084 |
   | such   | RE084  |
   | ueb    | ja     |
   | vom    | .      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift ueber E2, Platzhalter und Textposition
Given I open an editor "1TWG084" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE084"
And I set fields
   | nummer | 1TWG084 |
   | such   | TWG084  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-1" in row 1
And I set field "mge" to "-2" in row 2
And I set field "mge" to "-4" in row 4
And I save the current editor

# Ruecklieferung 1 ueber AUBE-Pos
Given I open an editor "1RLS084" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS084"
And I set fields
   | nummer | 1RLS084 |
   | such   | RLS084  |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-1" in row 1
And I set field "mge" to "-2" in row 2
And I set field "mge" to "-2" in row 4
And I save the current editor

# Kaufmaenische Gutschrift AUBE-Pos zum RLS 1
Given I open an editor "KG-ZU-RLS084" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS084"
And I set fields
   | nummer | 1KG084   |
   | such   | EK-KG084 |
   | ueb    | ja       |
   | tterm  | .        |
   | budat  | .        |
   | vom    | .        |
Then the table has 3 rows
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Storno der TWG nicht erlaubt: Es existiert eine gebuchte kaufmaennische Gutschrift.
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1TWG084" throws the exception "3335"

# ----------------------------------------------------------------------------------------------
Scenario: EK - Wertgutschrift zu Rechnung mit Konto nicht GuV
# ----------------------------------------------------------------------------------------------

# Rechnung erzeugen
Given I open an editor "1RE085" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer  | 1RE085  |
   | lief    | 1       |
   | such    | RE085-1 |
   | ueb     | ja      |
   | vom     | .       |
   | term    | .       |
And I append rows
   | artikel  | pwert | konto       |
   | TEXT     | 110   | 10000       |
   | TEXT     | 90    | !dontChange |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# EK-Wertgutschrift anlegen
Given I open an editor "1WG085" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE085"
And I set fields
   | nummer | 1WG085  |
   | such   | WG085-1 |
   | vom    | .       |
   | term   | .       |
And I press button "komplettieren"
Then field "konto" is not modifiable in row 1
Then field "fixkonto" is not modifiable in row 1
Then field "kstelle" is not modifiable in row 1
Then field "fixkstelle" is not modifiable in row 1
Then field "konto" is modifiable in row 2
Then field "fixkonto" is modifiable in row 2
Then field "kstelle" is modifiable in row 2
Then field "fixkstelle" is modifiable in row 2
And I set field "konto" to "10000" in row 2
Then field "konto" is modifiable in row 2
Then field "fixkstelle" is not modifiable in row 2
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK - RE mit LB - TWG1 mit negativer Textposition
# ----------------------------------------------------------------------------------------------
# Rechnung mit LB
Given I open an editor "1RL086" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | lief   | 1        |
   | nummer | 1RL086   |
   | ebeleg | RE-LB-86 |
   | such   | RE086    |
   | ueb    | ja       |
   | vom    | .        |
   | tterm  | .        |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | E1      | 5           |  11         | !dontChange |
   | TEXT    | !dontChange | !dontChange | -20         |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift
Given I open an editor "1WG086" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RL086"
And I set fields
   | nummer | 1WG086 |
   | such   | WG086  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "-5" in row 1
And I set field "pwert" to "10" in row 2
# Erwarteter Fehler: Gutzuschreibender Betrag zu hoch.
Then saving the current editor throws the exception "2792"
And I set field "mge" to "-4" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK - AU - LS - RE - TWG1 mit negativer Text- und AUBE-Position
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU087" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU087 |
   | kunde   | 1      |
   | such    | AU087  |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | V1      | 12          |  22         | !dontChange |
   | NEUPOS  | !dontChange | !dontChange | -33         |
   | TEXT    | !dontChange | !dontChange | -44         |
And I save the current editor

# Lieferschein
Given I open an editor "1LS087" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU087"
And I set fields
   | nummer | 1LS087 |
   | such   | LS087  |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | ja     |
And I set field "mge" to "12" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE087" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS087"
And I set fields
   | nummer | 1RE087 |
   | such   | RE087  |
   | ueb    | ja     |
   | tterm  | .      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift
Given I open an editor "1WG087" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE087"
And I set fields
   | nummer | 1WG087 |
   | such   | WG087  |
   | ueb    | ja     |
   | tterm  | .      |
And I set field "mge" to "-12" in row 1
And I set field "pwert" to "22" in row 2
And I set field "pwert" to "31" in row 3
# Erwarteter Fehler: Gutzuschreibender Betrag zu hoch.
Then saving the current editor throws the exception "2792"
And I set field "mge" to "-10" in row 1
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK: BE - LS - RE - TWG1 - (RLS mit KGS1) - TWG2 - (RLS2 mit KGS2) - Storno TWG1 nicht erlaubt
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE088" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE088 |
   | lief   | 1      |
   | such   | BE088  |
And I append rows
   | artikel | mge         | preis       | pwert       |
   | TEXT    | !dontChange | !dontChange | -10         |
   | AUBEPOS | 6           | !dontChange | !dontChange |
And I save the current editor

# Lieferschein
Given I open an editor "1LS088" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE088"
And I set fields
   | nummer | 1LS088 |
   | such   | LS088  |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "6" in row 2
And I save the current editor

# Rechnung ueber AUBE-Position
Given I open an editor "1RE088" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS088"
And I set fields
   | nummer | 1RE088 |
   | such   | RE088  |
   | ueb    | ja     |
   | vom    | .      |
And I delete row at position 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift ueber AUBE-Pos
Given I open an editor "1TWG088" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE088"
And I set fields
   | nummer | 1TWG088 |
   | such   | TWG088  |
   | ueb    | ja      |
   | vom    | .       |
And I set field "mge" to "-3" in row 1
And I save the current editor

# Ruecklieferung 1 ueber Textposition
Given I open an editor "1RLS088" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS088"
And I set fields
   | nummer | 1RLS088 |
   | such   | RLS088  |
   | ueb    | ja      |
   | tterm  | .       |
And I delete row at position 2
And I save the current editor

# Kaufmaenische Gutschrift Textposition zum RLS 1
Given I open an editor "KG-ZU-RLS088" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS088"
And I set fields
   | nummer | 1KG088   |
   | such   | EK-KG088 |
   | ueb    | ja       |
   | tterm  | .        |
   | budat  | .        |
   | vom    | .        |
Then the table has 1 rows
And I save the current editor
Given I open an editor "1WG088ST" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1TWG088"
And I close the current editor

# Ruecklieferung 2 uber AUBE-Position
Given I open an editor "2RLS088" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS088"
And I set fields
   | nummer | 2RLS088  |
   | such   | RLS088_2 |
   | ueb    | ja       |
   | tterm  | .        |
And I set field "mge" to "-3" in row 2
And I delete row at position 1
And I save the current editor

# KGS 2 zur Ruecklieferung 2
Given I open an editor "KG2-ZU-RLS088" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "2RLS088"
And I set fields
   | nummer | 2KG088    |
   | such   | EK-2KG088 |
   | ueb    | ja        |
   | tterm  | .         |
   | budat  | .         |
   | vom    | .         |
Then the table has 1 rows
And I create a new row at position 1
# Platzhalterposition hinzufuegen
And I set field "artex" to "a." in row 1
And I set field "mge" to "-2" in row 1
And I set field "preis" to "2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# Storno der TWG nicht erlaubt: Es existiert eine kaufmaennische Gutschrift.
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "1TWG088" throws the exception "3335"


# ----------------------------------------------------------------------------------------------
Scenario: VK: Wertgutschrift -> keine Rundungsfehler, kann gebucht werden.
# ----------------------------------------------------------------------------------------------

# Rechnung anlegen
Given I open an editor "RE089" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE089 |
   | ueb    |    ja  |
   | kunde  |     1  |
   | tterm  |     .  |
   | budat  |     .  |
And I append rows
   | artikel | mge   | preis | proz |
   | TECH005 |  24   |  5,99 |  -28 |
   | TECH006 |   6   |     1 |    0 |
   | TECH005 |  24   |  5,99 |  -13 |
   | TECH005 | 111   |  5,99 |   99 |
   |   TE007 |  24,9 | 11,89 |  -22 |
   |   TE008 |   1   |  5,49 |  -11 |
   | TECH006 |   6   |  0,19 |   -4 |
   |      V2 |  10   |  0,66 |  -33 |
   |      V1 |  99,1 |  9,99 |   -9 |
   |      V3 |  99   |    10 |   -1 |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift zu Rechnung anlegen
Given I open an editor "WERT-ZU-RE089" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg  | +1RE089 |
   | nummer |  1WG089 |
   | such   |  WG-089 |
   | ueb    |      ja |
   | tterm  |       . |
And I press button "komplettieren"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario Outline: Wertgutschrift mit AU/BE, Text, Umlage oder Neutrale Position stornieren
# ----------------------------------------------------------------------------------------------

#EK-LS erfassen
Given I open an editor "EK-LS" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
 | nummer | 1LS<num> |
 | lief   | 1        |
 | such   | LS<such> |
 | vom    | .        |
 | ueb    | ja       |
And I append rows
   | artikel | mge |
   | E1      | 10  |
And I save the current editor

#EKLS: Rechnung
Given I open an editor "RE-EK-LS" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "EK-LS"
And I set fields
	| nummer | 1RE<num> |
	| such   | RE<such> |
	| ueb    | ja       |
	| kenn   | LS<num>  |
	| vom    | .	     |
# AU/BE, Text, Umlage oder Neutrale Position in Rechnung anfuegen
And I append rows
	| artikel   | mge   |
   | <artikel> | <mge> |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# EKLS: Rechnung gutschreiben
Given I open an editor "GUT-EK-LS" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-EK-LS"
And I set fields
	| nummer | 1GU<num> |
	| such   | GU<such> |
	| ueb    | ja       |
	| vom    | .        |

And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

# Storno der Gutschrift
Given I open an editor "STORNO-RE-EK-LS" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "GUT-EK-LS"
And I save the current editor

Examples:
	| artikel | mge         | such   | num |
	| AUBEPOS | 1           | AUBE   | 111 |
	| TEXT    | !dontChange | TEXT   | 112 |
	| NEUPOS  | !dontChange | NEUPOS | 113 |
	| UMLPOS  | !dontChange | UMLPOS | 114 |


# ----------------------------------------------------------------------------------------------
Scenario: Rechnung mit einem Artikel und einer Zusatzposition mit Typ AU/BE mit negativer Menge anlegen
# ----------------------------------------------------------------------------------------------
Given I open an editor "RE-090" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE090 |
   | ueb    |    ja  |
   | kunde  |     1  |
   | tterm  |     .  |
And I append rows
   | artikel | mge | preis |
   |      V1 |  24 |  5,99 |
   | AUBEPOS |  -6 |     1 |
Then field "fakt" has value "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Gebuchte Rechnung kopieren und fakt ueberpruefen
And I open an editor "RE-090-KOPIE" from table "(Sales):(Invoice)" with command "COPY" for record "+1RE090"
Then field "fakt" is modifiable
Then field "fakt" has value "ja"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Rechnung mit einem Artikel und einer Dienstleistung mit negativer Menge anlegen
# ----------------------------------------------------------------------------------------------
Given I open an editor "RE-091" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE091 |
   | ueb    |    ja  |
   | kunde  |     1  |
   | tterm  |     .  |
And I append rows
   |     artikel | mge | preis |
   |          V1 |  24 |  5,99 |
   | DL-HANALYSE | -10 | 10    |
Then field "fakt" has value "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Gebuchte Rechnung kopieren und fakt ueberpruefen
And I open an editor "RE-091-KOPIE" from table "(Sales):(Invoice)" with command "COPY" for record "+1RE091"
Then field "fakt" is modifiable
Then field "fakt" has value "ja"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Rechnung neu, Angaben mit 2 Nachkommastellen, Wertgutschrift, Button "komplettieren", (ev)proz pruefen: gerundet?
# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "RE-092" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | such   | RE092  |
   | nummer | 1RE092 |
   | kunde  |      1 |
   | ueb    |     ja |
   | tterm  |      . |
   | budat  |      . |
And I append rows
   | artikel |   mge | preis |
   |      V1 | 4,432 |  5,99 |
   |      V2 | 3,987 |  6,23 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift: Button "Rechnung gutschreiben"
Given I open an editor "WERT-ZU-RE092" from table "(Sales):(Invoice)" with command "INVOICE" for record "+1RE092"
And I press button "komplettieren"
# Kein Ab-/Zuschlag (keine Rundungsdifferenzen)
Then field "proz" has value "0" in row 1
Then field "proz" has value "0" in row 2
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-Rechnung und Gutschrift, Waehrungsrundung: 2 NK-Stellen, Preisrundung: 4 NK-Stellen
# ----------------------------------------------------------------------------------------------

Given I'm logged in with password "annette"

Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set fields
    | decpreis | 4 |
And I save the current editor

Given I'm logged in with password "sy"

# Rechnung
Given I open an editor "RE-093" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE093 |
   | ueb    | ja     |
   | kunde  | 1      |
   | tterm  | .      |
And I append rows
   | artikel | mge  | preis | proz |
   | V1      | 0,5  | 351   | -25  |
And I respond with answer "Yes" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift: Button "Rechnung gutschreiben"
And I open an editor "WGS-093" from table "(Sales):(Invoice)" with command "INVOICE" for record "+1RE093"
And I set fields
   | nummer | 1WGS093 |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
Then field "pwert" has value "0.00" in row 1
Then field "ofwert" has value "-131.63" in row 1
And I press button "komplettieren"
# Positionswert nach Waehrungsrundung (2 NK) gerundet
Then field "pwert" has value "-131.63" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-Rechnung und Gutschrift, Waehrungsrundung: 0 NK-Stellen, Preisrundung: 4 NK-Stellen
# ----------------------------------------------------------------------------------------------

Given I'm logged in with password "annette"

Given I open an editor "Currency" from table "(Currency):(Currency)" with command "UPDATE" for record "DEM"
And I set field "nkst" to "0" in row 0
And I save the current editor

Given I'm logged in with password "sy"

# Rechnung
Given I open an editor "RE-094" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE094 |
   | kunde  | 1      |
   | ueb    | ja     |
   | tterm  | .      |
   | budat  | .      |
And I append rows
   | artikel | mge   | preis |
   | V1      | 4,432 | 5,99  |
   | V2      | 3,987 | 6,23  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift: Button "Rechnung gutschreiben"
Given I open an editor "WWGS-094" from table "(Sales):(Invoice)" with command "INVOICE" for record "+1RE094"
And I press button "komplettieren"
# Kein Ab-/Zuschlag (keine Rundungsdifferenzen)
Then field "proz" has value "0" in row 1
Then field "proz" has value "0" in row 2
And I close the current editor

# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "RE-095" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE095 |
   | ueb    | ja     |
   | kunde  | 1      |
   | tterm  | .      |
And I append rows
   | artikel | mge  | preis | proz |
   | V1      | 0,5  | 351   | -25  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift: Button "Rechnung gutschreiben"
And I open an editor "WGS-095" from table "(Sales):(Invoice)" with command "INVOICE" for record "+1RE095"
And I set fields
   | nummer | 1WGS095 |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
Then field "pwert" has value "0.00" in row 1
Then field "ofwert" has value "-131.63" in row 1
And I press button "komplettieren"
# Positionswert nach Waehrungsrundung (0 NK) gerundet
Then field "pwert" has value "-132.00" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-Rechnung und Gutschrift, Waehrungsrundung: 3 NK-Stellen, Preisrundung: 6 NK-Stellen
# ----------------------------------------------------------------------------------------------

Given I'm logged in with password "annette"

Given I open an editor "Currency" from table "(Currency):(Currency)" with command "UPDATE" for record "DEM"
And I set field "nkst" to "3" in row 0
And I save the current editor

Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set fields
    | decpreis | 6 |
And I save the current editor

Given I'm logged in with password "sy"

# Rechnung
Given I open an editor "RE-096" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE096 |
   | kunde  | 1      |
   | ueb    | ja     |
   | tterm  | .      |
   | budat  | .      |
And I append rows
   | artikel | mge   | preis |
   | V1      | 4,432 | 5,99  |
   | V2      | 3,987 | 6,23  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift: Button "Rechnung gutschreiben"
Given I open an editor "WGS-096" from table "(Sales):(Invoice)" with command "INVOICE" for record "+1RE096"
And I press button "komplettieren"
# Kein Ab-/Zuschlag (keine Rundungsdifferenzen)
Then field "proz" has value "0" in row 1
Then field "proz" has value "0" in row 2
And I close the current editor

# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "RE-097" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE097 |
   | ueb    | ja     |
   | kunde  | 1      |
   | tterm  | .      |
And I append rows
   | artikel | mge  | preis | proz |
   | V1      |  0,5 | 351   | -25  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift: Button "Rechnung gutschreiben"
And I open an editor "WGS-097" from table "(Sales):(Invoice)" with command "INVOICE" for record "+1RE097"
And I set fields
   | nummer | 1WGS095 |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
Then field "pwert" has value "0.00" in row 1
Then field "ofwert" has value "-131.63" in row 1
And I press button "komplettieren"
# Positionswert nach Waehrungsrundung (3 NK) gerundet, aber nicht sichtbar, da benannte Art des Betragsfeld nur 2 NK hat
Then field "pwert" has value "-131.63" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-Rechnung und Gutschrift, Waehrungsrundung: 3 NK-Stellen, Preisrundung: 2 NK-Stellen
# ----------------------------------------------------------------------------------------------

Given I'm logged in with password "annette"

Given I open an editor "Currency" from table "(Currency):(Currency)" with command "UPDATE" for record "DEM"
And I set field "nkst" to "3" in row 0
And I save the current editor

Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set fields
    | decpreis | 2 |
And I save the current editor

Given I'm logged in with password "sy"

# Rechnung
Given I open an editor "RE098" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE098 |
   | ueb    | ja     |
   | kunde  | 1      |
   | tterm  | .      |
   | budat  | .      |
And I append rows
   | artikel | mge   | preis | proz |
   | TECH005 | 24    | 5,99  | -28  |
   | TECH006 | 6     | 1     | 0    |
   | TECH005 | 24    | 5,99  | -13  |
   | TECH005 | 11    | 5,99  | 99   |
   | TE007   | 24,9  | 11,89 | -22  |
   | TE008   | 1     | 5,49  | -11  |
   | TECH006 | 6     | 0,19  | -4   |
   | V2      | 10    | 0,66  | -33  |
   | V1      | 99,1  | 9,99  | -9   |
   | V3      | 99    | 10    | -1   |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift: Button "Rechnung gutschreiben"
Given I open an editor "WGS-098" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg  | +1RE098 |
   | nummer | 1WGS098 |
   | ueb    | ja      |
   | tterm  | .       |
And I press button "komplettieren"
# Gerundete gutzuschreibende Werte koennen verbucht werden (nicht zu hoch)
And I save the current editor

# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "RE-099" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE099 |
   | kunde  | 1      |
   | ueb    | ja     |
   | tterm  | .      |
   | budat  | .      |
And I append rows
   | artikel | mge   | preis |
   | V1      | 4,432 | 5,99  |
   | V2      | 3,987 | 6,23  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift: Button "Rechnung gutschreiben"
Given I open an editor "WERT-ZU-RE099" from table "(Sales):(Invoice)" with command "INVOICE" for record "+1RE099"
And I press button "komplettieren"
# Kein Ab-/Zuschlag (keine Rundungsdifferenzen)
Then field "proz" has value "0" in row 1
Then field "proz" has value "0" in row 2
And I close the current editor

# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "RE-100" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE100 |
   | ueb    | ja     |
   | kunde  | 1      |
   | tterm  | .      |
And I append rows
   | artikel | mge | preis | proz |
   | V1      | 0,5 | 351   | -25  |
And I respond with answer "Yes" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift: Button "Rechnung gutschreiben"
And I open an editor "WGS-100" from table "(Sales):(Invoice)" with command "INVOICE" for record "+1RE100"
And I set fields
   | nummer | 1WGS100 |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
Then field "pwert" has value "0.00" in row 1
Then field "ofwert" has value "-131.63" in row 1
And I press button "komplettieren"
# Positionswert nach Waehrungsrundung (3 NK) gerundet, aber nicht sichtbar, da benannte Art des Betragsfeld nur 2 NK hat
Then field "pwert" has value "-131.63" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
# Waehrungsrundung zurueck auf 2 NK-Stellen setzen
# ----------------------------------------------------------------------------------------------

Given I'm logged in with password "annette"

Given I open an editor "Currency" from table "(Currency):(Currency)" with command "UPDATE" for record "DEM"
And I set field "nkst" to "2" in row 0
And I save the current editor

Given I'm logged in with password "sy"

# ----------------------------------------------------------------------------------------------
Scenario: VK: Rechnung mit Zwischensumme und Umlagen
# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "RE-101" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE101 |
   | kunde  | 1      |
   | ueb    | ja     |
   | tterm  | .      |
   | budat  | .      |
And I append rows
   | artikel | mge         | preis       | proz        |
   | V1      | 12          | 142,30      | -25         |
   | V1      | 30          | 6,23        | -25         |
   | V1      | 10          | 35,90       | -25         |
   | V1      | 12          | 193,00      | -25         |
   | ZS.     | !dontChange | !dontChange | !dontChange |
   | PR.     | !dontChange | !dontChange | -30         |
   | ES.     | !dontChange | !dontChange | !dontChange |
And I save the current editor

# Wertgutschrift: Button "Rechnung gutschreiben"
Given I open an editor "WGS-101" from table "(Sales):(Invoice)" with command "INVOICE" for record "+1RE101"
And I set fields
   | nummer | 1WGS101 |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I press button "komplettieren"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK: Rechnung mit Zwischensumme und Umlagen
# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "RE-101" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
	| nummer | 1RE101 |
	| lief   | 1      |
	| ueb    | ja     |
	| vom    | .      |
	| budat  | .      |
And I append rows
	| artikel | mge         | preis       | proz        |
	| E2      | 12          | 142,30      | -25         |
	| E2      | 30          | 6,23        | -25         |
	| E2      | 10          | 35,90       | -25         |
	| E2      | 12          | 193,00      | -25         |
	| ZS.     | !dontChange | !dontChange | !dontChange |
	| PR.     | !dontChange | !dontChange | -30         |
	| ES.     | !dontChange | !dontChange | !dontChange |
And I save the current editor

# Wertgutschrift: Button "Rechnung gutschreiben"
Given I open an editor "WGS-101" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+1RE101"
And I set fields
	| nummer | 1WGS101 |
	| vom    | .       |
	| ueb    | ja      |
And I press button "komplettieren"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK: Wertgutschrift mit atlasrelevanten Artikel
# ----------------------------------------------------------------------------------------------
# Lieferant bekommt Konsi-Lager
Given I open an editor "lieferant1" from table "(Vendor):(Vendor)" with command "STORE" for record "1"
And I set fields
   | konsi | L3F2 |
   | staat | USA  |
And I save the current editor

# EK-Rechnung mit nicht gesetzter Atlasrelevanz -> WGS

Given I open an editor "EK1_ATLAS" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 01EKATL   |
   | lief   | 1         |
   | such   | RE1-ATLAS |
   | ebeleg | RE-ATLAS  |
   | ueb    | ja        |
   | tterm  | .         |
   | budat  | .         |
   | vom    | .         |
And I append rows
   | artex  | mge | proz |
   | e1     | 10  | -5   |
   | e2     | 10  | -5   |
   | e1     | 11  | -1   |
Then field "patlasrel" has value "nein" in row 1
Then field "patlasrel" has value "nein" in row 2
Then field "patlasrel" has value "nein" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "WG-ZU-EK1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "EK1_ATLAS"
And I set fields
   | nummer | 01WGATLA  |
   | such   | WG01ATLAS |
   | tterm  | .         |
   | budat  | .         |
   | vom    | .         |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
# Aus der Rechnung uebernehmen
Then field "patlasrel" has value "nein" in row 1
Then field "patlasrel" has value "nein" in row 2
Then field "patlasrel" has value "nein" in row 3
And I save the current editor

# EK-Rechnung mit nicht gesetzter Atlasrelevanz -> Ruecklieferung -> Wertgutschrift

Given I open an editor "02EKREATL" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 02EKREAT |
   | lief   | 1        |
   | such   | RE-EK02  |
   | ueb    | ja       |
   | tterm  | .        |
   | budat  | .        |
   | vom    | .        |
   | vstaat | USA      |
And I append rows
   | artex | mge | proz  |
   | e1    | 1   | -5    |
   | e2    | 1   | -5    |
   | e1    | 2   | -1    |
Then field "patlasrel" has value "nein" in row 1
Then field "patlasrel" has value "nein" in row 2
Then field "patlasrel" has value "nein" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "1RUECK02" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+02EKREAT"
And I set fields
   | nummer | 1RUECK02 |
   | such   | RUECK02  |
   | ueb    | ja       |
   | vom    | .        |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I set field "patlasrel" to "ja" in row 3
And I save the current editor

# Wertgutschrift
Given I open an editor "WG-ZU-RUECK02" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RUECK02"
And I set fields
   | nummer | 02WGATLA  |
   | such   | WG02ATLAS |
   | tterm  | .         |
   | budat  | .         |
   | vom    | .         |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
# Aus der Rechnung uebernehmen
Then field "patlasrel" has value "nein" in row 1
Then field "patlasrel" has value "nein" in row 2
Then field "patlasrel" has value "ja" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK - Keine Wertgutschrift aus Umlagerbestellung mit Beleg anfuegen
# ----------------------------------------------------------------------------------------------

# Umlagerungsvorschlag anlegen
Given I open an editor "Umlagerungsvorschlag_Neu" from table "(Purchasing):(RelocationSuggestions)" with command "NEW" for record ""
And I append rows
   | artikel | mge | preis | platz | abplatz |
   | E2      | 50  | 10    | L2F1  | F1      |
And I save the current editor

# Umlagerungsvorschlag freigeben zu Bestellung
Given I open an editor "Umlagerungsvorschlag" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "E2"
And I press button "ladetab"
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BE-102"
Then field "mge" has value "50" in row 1
Then field "preis" has value "10.00" in row 1
Then field "platz" has value "L2F1" in row 1
Then field "abplatz" has value "F1" in row 1
And I set fields
   | nummer  | 1BE102  |
   | lief    | 1       |
   | such    | BE102   |
   | vom     | .       |
And I save the current editor
And I switch the current editor to editor "Umlagerungsvorschlag"
And I close the current editor

# Lieferschein anlegen
Given I open an editor "LS-102BE" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE-102"
And I set fields
 | such   | LS-102EK |
 | nummer | 102EKLS  |
 | ueb    | ja      |
 | vom    | .       |
And I set field "mge" to "5" in row 1
And I save the current editor

# Rechnung anlegen
Given I open an editor "RE-102" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS-102BE"
And I set fields
   | nummer | 1RE102 |
   | such   | RE102  |
   | ueb    | ja     |
   | vom    | .      |
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Keine Wertgutschrift moeglich
Given I open an editor "RE-102" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# Zu einer Rechnung mit Beschaffungsart Umlagern kann keine Wertgutschrift erstellt werden.
Then setting field "beleg" to "+1RE102" throws the exception "6821"
And I close the current editor

#-----------------------------------------------------------------------------------------------
# Umlagerungsrechnung -> Wertgutschrift nicht erlaubt
Given I open an editor "RE-103" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
	| nummer | 1RE103   |
	| lief   | 1        |
	| ueb    | ja       |
	| vom    | .        |
	| budat  | .        |
   | bsart  | Umlagern |
And I append rows
	| artikel | mge  | preis  | ablgruppe | lgruppe   |
	| E2      | 12   | 142,30 | HONGKONG  | KARLSRUHE |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Keine Wertgutschrift moeglich
Given I open an editor "RE-103" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
# Zu einer Rechnung mit Beschaffungsart Umlagern kann keine Wertgutschrift erstellt werden.
Then setting field "beleg" to "+1RE103" throws the exception "4615"
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK: Komplettwertgutschrift zu Rechnung mit zwei Artikelpositionen, Zwischensumme und zwei Prozentpositionen
# ----------------------------------------------------------------------------------------------

# Rechnung anlegen mit zwei Artikelpositionen, Zwischensummen und 2 Prozentpositionen
Given I open an editor "RE-104" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE104 |
   | kunde  | 1      |
   | ueb    | ja     |
   | tterm  | .      |
   | budat  | .      |
And I append rows
   | artikel | mge         | preis       | proz        |
   | V1      | 1           | 79,50       | !dontChange |
   | V2      | 1           | 6,68        | !dontChange |
   | ZS.     | !dontChange | !dontChange | !dontChange |
   | PR.     | !dontChange | !dontChange | 10,1        |
   | PR.     | !dontChange | !dontChange | 14,1        |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift zu Rechnung erstellen, Button komplettieren druecken und buchen
Given I open an editor "WG-104" from table "(Sales):(Invoice)" with command "INVOICE" for record "+1RE104"
And I set fields
   | nummer | 1WG104 |
   | ueb    | ja     |
   | tterm  | .      |
   | budat  | .      |
And I press button "komplettieren"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Rechnung mit einem Artikel, neutrale Position in der Komplettwertgutschrift hinzufuegen
# ----------------------------------------------------------------------------------------------
# Verkauf
Given I open an editor "VK-RE105" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1VKRE105 |
   | ueb    |    ja    |
   | kunde  |     1    |
   | tterm  |     .    |
And I append rows
   | artikel | mge | preis |
   |      V1 |  24 |  5,99 |
Then field "fakt" has value "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift: Rechnung -> Rechnung
Given I open an editor "WERT-ZU-VKRE105" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg  | +1VKRE105 |
   | nummer | 1VWGS105  |
   | ueb    | ja        |
   | tterm  | .         |
And I press button "offueb" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
Then field "ofwert" has value "-143.76" in row 1
And I append rows
	| artikel | pwert |
	| NEUPOS  | 495   |
Then field "komplettgutschrift" has value "ja" in row 1
Then field "ofwert" has value "-143.76" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
Then field "komplettgutschrift" from editor "WERT-ZU-VKRE105" in row 1 has value "ja"

# Einkauf
Given I open an editor "EK-RE105" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1EKRE105 |
   | ueb    |    ja    |
   | lief   |     1    |
   | vom    | .        |
	| budat  | .        |
And I append rows
   | artikel | mge | preis |
   |      E1 |  24 |  5,99 |
Then field "fakt" has value "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift: Rechnung -> Rechnung
Given I open an editor "WERT-ZU-EKRE105" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg  | +1EKRE105 |
   | nummer | 1EWGS105  |
   | ueb    | ja        |
   | vom    | .         |
   | budat  | .         |
And I press button "offueb" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
Then field "ofwert" has value "-143.76" in row 1
And I append rows
	| artikel | pwert |
	| NEUPOS  | 499   |
Then field "komplettgutschrift" has value "ja" in row 1
Then field "ofwert" has value "-143.76" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
Then field "komplettgutschrift" from editor "WERT-ZU-EKRE105" in row 1 has value "ja"


# ----------------------------------------------------------------------------------------------
Scenario: Rechnung mit einem Artikel, neutrale Position in der Teilwertgutschrift hinzufuegen
# ----------------------------------------------------------------------------------------------
Given I open an editor "RE-105-B" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE105B |
   | ueb    |    ja   |
   | kunde  |     1   |
   | tterm  |     .   |
And I append rows
   | artikel | mge | preis |
   |      V1 |  24 |  5,99 |
Then field "fakt" has value "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift: Rechnung -> Rechnung
Given I open an editor "WERT-ZU-RE105-B" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | beleg  | +1RE105B |
   | nummer | 1WGS105B |
   | ueb    | ja       |
   | tterm  | .        |
And I set field "mge" to "-10" in row 1
Then field "komplettgutschrift" has value "nein" in row 1
Then field "ofwert" has value "-143.76" in row 1
And I append rows
	| artikel | pwert |
	| NEUPOS  | 100   |
Then field "komplettgutschrift" has value "nein" in row 1
Then field "ofwert" has value "-143.76" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
Then field "komplettgutschrift" from editor "WERT-ZU-RE105-B" in row 1 has value "nein"


# ----------------------------------------------------------------------------------------------
Scenario: Wertgutschrift: Neutrale Position nur mit positivem Wert darf hinzugefuegt werden
# ----------------------------------------------------------------------------------------------
# Rechnung anlegen und buchen
Given I open an editor "RE106" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE106 |
   | such   | RE106  |
   | kunde  | 1      |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
And I append rows
   | artikel | mge  | preis |
   | V1      | 5    | 50    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift zur Rechnung erstellen
Given I open an editor "WG-106" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE106"
Then field "wertgutschrift" has value "ja"
And I set fields
   | nummer | 1WG106 |
   | such   | WG106  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
And I press button "offueb" in row 1
Then field "pwert" has value "-250.00" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
Then field "vorganga" has value "Kaufmännische Gutschrift"
# Neutrale Position mit positiven Wert hinzuzufuegen
And I create a new row at the end of the table
# Position 5
And I set field "artikel" to "NEUPOS" in row !lastRow
# Negative Menge bei hinzugefuegten neutralen Gutschriftpositionen nicht erlaubt.
Then setting field "pwert" to "-10.00" in row !lastRow throws the exception "2623"
And I set field "pwert" to "10.00" in row !lastRow
And I press button "komplettieren"
Then field "ofmge" has value "-10" in row !lastRow
Then field "pwert" has value "10.00" in row !lastRow
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - Rechnung mit zwei Materialzuschlaegen anlegen und gutschreiben
# ----------------------------------------------------------------------------------------------

# Zwei Materialzuschläge anlegen
Given I open an editor "MATZU1" from table "(Company):(MaterialSurchargeHeader)" with command "STORE" for record "30"
And I append rows
	| matart | matbasis | matnotiz |
	| MATZU1 | 8.50     | 9.50     |
And I save the current editor

Given I open an editor "MATZU2" from table "(Company):(MaterialSurchargeHeader)" with command "STORE" for record "30"
And I append rows
	| matart | matbasis | matnotiz |
	| MATZU2 | 2.60     | 3.10     |
And I save the current editor

# Artikel anlegen mit beiden Materialzuschlaegen
Given I open an editor "ART_DOPPEL_MATZU" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | A_MATZU             |
   | namebspr | Artikel mit 2 MATZU |
   | vpr      | 25.00               |
   | epr      | 20.00               |
   | bsart    | Fremdbeschaffung    |
   | dispoa   | auftragsbezogen     |
   | matart   | MATZU1              |
   | zmge     | 0.8                 |
   | matvrel  | ja                  |
   | matart2  | MATZU2              |
   | zmge2    | 1.2                 |
   | matvrel2 | ja                  |
And I save the current editor

# Rechnung mit Artikel anlegen und buchen - beide Materialzuschlaege werden uebernommen
Given I open an editor "RE_MATZU" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1REMATZU |
   | kunde  | 1        |
   | such   | RE_MATZU |
   | ueb    | ja       |
   | vom    | .        |
   | tterm  | .        |
And I append rows
   | artikel | mge |
   | A_MATZU | 5   |
Then the table has 3 rows
# Artikel
Then field "pwert" has value "125.00" in row 1
# Erste Materialzuschlags-Position (MATZU1): 5 × 0.8 × 1 = 4.00
Then field "pwert" has value "4.00" in row 2
# Zweite Materialzuschlags-Position (MATZU2): 5 × 1.2 × 0.50 = 3.00
Then field "pwert" has value "3.00" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung gutschreiben
Given I open an editor "WG_MATZU" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE_MATZU"
And I set fields
   | nummer | 1WGMATZU |
   | such   | WG_MATZU |
   | ueb    | ja       |
   | vom    | .        |
   | tterm  | .        |
# Alle Positionen werden korrekt in die Wertgutschrift uebernommen
Then the table has 6 rows
Then field "artikel" has value "A_MATZU" in row 1
And I set field "mge" to "-5" in row 1
Then field "artikel" has value "MATZU" in row 2
Then field "mge" has value "-4" in row 2
Then field "artikel" has value "MATZU" in row 3
Then field "mge" has value "-6" in row 3
Then field "artikel" has value "MATZU" in row 3
# Negative Werte in der Gutschrift
Then field "pwert" has value "-125.00" in row 1
Then field "pwert" has value "-4.00" in row 2
Then field "pwert" has value "-3.00" in row 3
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK - Rundungsproblem bei Summenfeldern in EK-/VK-Vorgaengen
# Dadurch falsche Umschaltung auf "Kaufm. Gutschrift" in EK-/VK-Rechungen
# ----------------------------------------------------------------------------------------------

# Betriebsdaten: Kriterium für die kaufmännische Gutschrift (kgskriterium) auf "Nettosumme kleiner null" setzen
Given I open an editor "betriebsdaten" from table "(Company):(CompanyData)" with command "UPDATE" for record "1"
And I set fields
    | kgskriterium | Nettosumme kleiner null |
And I save the current editor

# Rechnung
Given I open an editor "RE-105" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| nummer | 1RE105 |
	| kunde  | 1      |
	| tterm  | .		|
And I append rows
	| artikel | pwert        |
	| TEXT    |  10000000.03 |
	| TEXT    |  10000000.03 |
	| TEXT    |  10000000.03 |
	| TEXT    | -30000000.09 |
And I press button "bureabschluss"
Then field "sumnetto" has value "0.00"
Then field "vorganga" has value "Rechnung"
And I save the current editor
