# *****************************************************************************
#  Name           : wertgutschrift_rls.feature
#  Autor          : dago
#  Verantwortlich : dago
#  Kontrolle      : foe
#  Funktion       : Testet Funktionen rund um die Wertgutschrift und den Ruecklieferungen
#
# *****************************************************************************
#
@persistent
Feature: Zusammenspiel zwischen Ruecklieferungen und Wertgutschrift
Background:
Given I set the fake date to "02.01.1995"

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
| ndienstl   | such   | namebspr     | preis | lief | efrist | epr   |
| hdienstl   | dl-ANA | Analyse in h | 60.00 |      |        |       |
| repdienstl | dl-REP | Reparatur    | 85.00 | 1    | 1      | 85.00 |

# ----------------------------------------------------------------------------------------------
Scenario Outline: STAMMDATEN - neutrale Zusatzposition / AU/BE anlegen
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
And I save the current editor

Examples: Artikel
| zusatzpos   | such    | namebspr          | zptyp             | vkbez             | vbez              | ebez              | vpr | epr |
| neutralePOS | NEUPOS  | Neutrale Position | Neutrale Position | Neutrale Position | Neutrale Position | Neutrale Position | 500 | 400 |
| AUBEPOS     | AUBEPOS | AUBE              | AU/BE             | AUBE Position     | AUBE Position     | AUBE Position     | 200 | 175 |

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Setartikel anlegen
# ----------------------------------------------------------------------------------------------

# Komponenten des Sets anlegen
Given I open an editor "KOMP1" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | KOMP1            |
   | namebspr | Komp1            |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
   | vpr      | 2                |
   | lief     | 1                |
   | epr      | 1                |
And I save the current editor

Given I open an editor "KOMP2" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | KOMP2            |
   | namebspr | Komp2            |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
   | vpr      | 12               |
   | lief     | 1                |
   | epr      | 10               |
And I save the current editor

# Setartikel
Given I open an editor "SETART" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | SETART           |
   | namebspr | Setartikel       |
   | bsart    | Eigenfertigung   |
   | dispoa   | auftragsbezogen  |
   | vpr      | 90               |
   | lief     | 1                |
   | epr      | 80               |
   | eart     | (UsingBOM)       |
And I append rows
   | elex  | anzahl |
   | KOMP1 | 5      |
   | KOMP2 | 0.5    |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Artikel mit Beistellung anlegen
# ----------------------------------------------------------------------------------------------

# Artikel anlegen
Given I open an editor "ABEIST" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | ABEIST                  |
   | namebspr | Artikel mit Beistellung |
   | lief     | 1                       |
   | epr      | 1000                    |
   | bsart    | Fremdbeschaffung        |
   | dispoa   | bedarfsbezogen          |
And I save the current editor

Given I open an editor "BEIST" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | BEIST                   |
   | namebspr | Beistellartikel         |
   | lief     | 1                       |
   | epr      | 100                     |
   | bsart    | Fremdbeschaffung        |
   | dispoa   | bedarfsbezogen          |
And I save the current editor

# Beistellung im Artikel eintragen
Given I open an editor "ABEIST" from table "(Part):(Product)" with command "UPDATE" for record from editor "ABEIST"
And I append rows
   | elex  | elanzahl | bua                    |
   | BEIST | 2        | Lieferantenbeistellung |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Artikel und Zusatzposition anlegen mit Handelseinheit ungleich Lagereinheit
# ----------------------------------------------------------------------------------------------

Given I open an editor "VPE" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | nummer   | 1VPE             |
   | such     | VPE1             |
   | namebspr | VPE1             |
   | bsart    | Fremdbeschaffung |
   | dispoa   | bedarfsbezogen   |
   | fvhle    | 2                |
   | fvple    | 2                |
   | fehle    | 2                |
   | feple    | 2                |
   | le       | kg               |
   | lief     | 1                |
And I save the current editor

Given I open an editor "AUBEPOS2" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set fields
   | nummer   | 2AUBEPOS         |
   | such     | AUBEPOS2         |
   | namebspr | AUBE Position 2  |
   | zptyp    | AU/BE            |
   | vkbez    | AUBE Position 2  |
   | vbez     | AUBE Position 2  |
   | ebez     | AUBE Position 2  |
   | vpr      | 10               |
   | epr      | 7                |
   | le       | Stück            |
   | vhe      | Paar             |
   | vpe      | Paar             |
   | ehe      | Paar             |
   | epe      | Paar             |
   | fvhle    | 2                |
   | fvple    | 2                |
   | fehle    | 2                |
   | feple    | 2                |
And I save the current editor

# ---------------------------------------------------------------------------------------------------
Scenario Outline: Artikel V1 mit Bestand versorgen, damit Bewertungsorigs zur Verfuegung stehen
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
	| artikel	| wert	| mge	| platz | verw |
	|     E1	| 60	| 100	| F2	|      |
	|     V1	| 20	| 1000	| F1	|      |
	|     V2	| 30	| 100	| F1	|      |
	|     V2	| 40	| 1000	| F2	|      |
	|  KOMP1	| 10	| 100	| F1	|      |
	|  KOMP2	| 50	| 100	| F1	|      |
	|  BEIST	|  5	| 200	| F1	|      |
	|   VPE1	|  7	| 300	| F1	|      |

# ----------------------------------------------------------------------------------------------
Scenario: VK-LS-RE-RLS-01: AU, LS, RE, RLS ungebucht -> WG nicht erlaubt.
# In der gebuchten RE muss beim Buchen des RLS die remge aktualisiert werden.
# Fall WG2 (Komplette Ruecklieferung)
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU01" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU01 |
   | kunde   | 1     |
   | such    | AU01  |
And I append rows
   | artikel | mge | preis |
   | V1      | 100 |   100 |
And I save the current editor

# Lieferschein
Given I open an editor "1LS01" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU01"
And I set fields
   | nummer | 1LS01 |
   | such   | LS01  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE01" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS01"
And I set fields
   | nummer | 1RE01 |
   | such   | RE01  |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS01" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS01"
And I set fields
   | such   | RLS01 |
   | ueb    | nein  |
   | tterm  | .     |
   | budat  | .     |
And I press button "offueb" in row 1
And I save the current editor
Then field "remge" from editor "1RE01" in row 1 has value "-100"
Then field "ofwert" from editor "1RE01" in row 1 has value "-10000.00"

# Wertgutschrift bei ungebuchten RLS nicht moeglich.
# "Wertgutschrift erstellen nicht moeglich, es gibt noch ungebuchte Ruecklieferscheine."
Then opening an editor from table "(Sales):(Invoice)" with command "INVOICE" for record "+1RE01" throws the exception "6823"


# ----------------------------------------------------------------------------------------------
Scenario: VK-LS-RE-RLS-02: AU, LS, RE, RLS (aus LS) (Teilrechnung kommt nach RLS)
# In der gebuchten RE muss beim Buchen des RLS die remge aktualisiert werden.
# Eine 100% WG ist nicht mehr moeglich.
# Fall WG3 (Teil RLS)
# ----------------------------------------------------------------------------------------------
#
# AU ------------------- LS -------------------- RE --------------------------- RE (TWG)
# 100 St.                100 St. buchen          100 St. buchen (1!)            -48 St. buchen (3!)
# | Aktion | remge  |    | Aktion | remge  |     | Aktion | remge   |           | Aktion | remge  |
# |        | 100 St.|    |        | 100 St.|     |        |  100 St.|           |        | -48 St.|
#                        | (1)    | 100 St.|     | (1)    | -100 St.|           | (3)    |   0 St.|
#                        | (2)    |   0 St.|     | (2)    |  -48 St.|
#                        | (3)    |   0 St.|     | (3)    |    0 St.|
#                           \
#                            \
#                             ---------------------------------------- RLS ---------------------- KGS
#                                                                      -52 St. buchen (2!)        -52 St. buchen (4!)
#                                                                      | Aktion | remge |         | Aktion | remge  |
#                                                                      |        |    0  |         |        | -52 St.|
#                                                                      | (2)    |  -52  |         |   (4)  |   0 St.|
#                                                                      | (4)    |    0  |

# Auftrag
Given I open an editor "1AU02" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU02 |
   | kunde   | 1     |
   | such    | AU02  |
And I append rows
   | artikel | mge | preis |
   | V1      | 100 |   100 |
And I save the current editor

# Lieferschein
Given I open an editor "1LS02" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU02"
And I set fields
   | nummer | 1LS02 |
   | such   | LS02  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE02" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS02"
And I set fields
   | nummer | 1RE02 |
   | such   | RE02  |
   | ueb    | ja    |
   | tterm  | .     |
Then field "ident" is modifiable
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS02" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS02"
And I set fields
   | nummer | 1RLS02 |
   | such   | RLS02  |
   | ueb    | nein   |
   | tterm  | .      |
   | budat  | .      |
And I set field "mge" to "-52" in row 1
And I save the current editor
Then field "remge" from editor "1RE02" in row 1 has value "-100"
Then field "ofwert" from editor "1RE02" in row 1 has value "-10000.00"

# Wertgutschrift bei ungebuchten RLS nicht moeglich.
# "Wertgutschrift erstellen nicht moeglich, es gibt noch ungebuchte Ruecklieferscheine."
Then opening an editor from table "(Sales):(Invoice)" with command "INVOICE" for record "+1RE02" throws the exception "6823"

# Ruecklieferung buchen
Given I open an editor "RLS02" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS02"
And I set fields
   | ueb    |   ja  |
And I save the current editor
# remge wurde in RE02 reduziert
Then field "remge" from editor "1RE02" in row 1 has value "-48"
Then field "ofwert" from editor "1RE02" in row 1 has value "-4800.00"

# Teil-Wertgutschrift
Given I open an editor "1WG02" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE02"
And I set fields
   | nummer | 1WG02 |
   | such   | WG02  |
   | ueb    | ja    |
   | tterm  | .     |
Then field "ident" is modifiable
And I press button "offueb" in row 1
Then field "mge" has value "-48" in row 1
And I save the current editor

# TWGS mindert remge in Rechnung nicht, der Wert auf die Gesamtmenge umgelegt wird
Then field "remge" from editor "1RE02" in row 1 has value "-48"
# TWGS mindert ofwert in Rechnung
Then field "ofwert" from editor "1RE02" in row 1 has value "0.00"
Then field "remge" from editor "1LS02" in row 1 has value "0"

# KGS
Given I open an editor "KGS02" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS02"
And I set fields
   | nummer | 1KGS02 |
   | such   | KGS02  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
Then field "ident" is modifiable
And I set field "mge" to "-52" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
Then field "remge" from editor "RLS02" in row 1 has value "0"
Then field "remge" from editor "KGS02" in row 1 has value "0"


# ----------------------------------------------------------------------------------------------
Scenario: VK-LS-RE-RLS-04: AU, LS, RE, 100% WG
# In der gebuchten RE muss beim Buchen des RLS die remge aktualisiert werden.
# Siehe https://miro.com/app/board/uXjVPPtvPa4=/ Fall WG4 (100% WG)
# Siehe u.a. EVS-4972
# ----------------------------------------------------------------------------------------------
#
# AU ------------------ LS ------------------ RE ------------------- WG
# 100 St.               100 St. buchen        100 St. buchen (1!)    -100 St. buchen (2!)
# | Aktion | remge  |   | Aktion | remge  |   | Aktion | remge   |   | Aktion | remge   |
# |        | 100 St.|   |        | 100 St.|   |        |  100 St.|   |        | -100 St.|
#                       | (1)    |   0 St.|   | (1)    | -100 St.|   | (2)    |    0 St.|
#                       | (2)    | 100 St.|   | (2)    |    0 St.|
#                       | (3)    |   0 St.|
#                       | (4)    |   0 St.|
#                            \     \
#                             \     ------------------------------------- RE (RE-Korrektur)
#                              \                                          100 St. (3!)
#                               \                                         | Aktion |  remge  | preis |
#                                \                                        | (3)    | -100 St.|    50 |
#                                 \                                       | (4)    |  -96 St.|    50 |
#                                  \
#                                   ------------------------------------------- RLS ------------------- KGS
#                                                                               -4 St. buchen (4!)      -4 St. buchen (5!)
#                                                                               | Aktion | remge |      | Aktion | remge  |
#                                                                               |        |  0 St.|      |        |  -4 St.|
#                                                                               | (4)    | -4 St.|      |   (5)  |   0 St.|
#                                                                               | (5)    |  0 St.|

# Auftrag
Given I open an editor "1AU04" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU04 |
   | kunde   | 1     |
   | such    | AU04  |
And I append rows
   | artikel | mge | preis |
   | V1      |  10 |   100 |
And I save the current editor

# Lieferschein
Given I open an editor "1LS04" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU04"
And I set fields
   | nummer | 1LS04 |
   | such   | LS04  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE04" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS04"
And I set fields
   | nummer | 1RE04 |
   | such   | RE04  |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 100% Wertgutschrift
Given I open an editor "1WG04" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE04"
And I set fields
   | nummer | 1WG04 |
   | such   | WG04  |
   | ueb    | ja    |
   | tterm  | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnungskorrektur
Given I open an editor "1REK04" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS04"
And I set fields
   | nummer | 1REK04 |
   | such   | REK04  |
   | ueb    | ja     |
   | tterm  | .      |
Then field "rekorrektur" has value "ja" in row 1
And I set field "preis" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS04" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS04"
And I set fields
   | such   | RLS04 |
   | ueb    |    ja |
   | tterm  | .     |
   | budat  | .     |
And I set field "mge" to "-4" in row 1
And I save the current editor
Then field "remge" from editor "1LS04" in row 1 has value "0"
# RLS hat Einfluss auf die remge in der RE
Then field "remge" from editor "1REK04" in row 1 has value "-6"

# KGS
Given I open an editor "KGS04" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS04"
And I set fields
   | ueb    | ja    |
   | vom    | .     |
   | tterm  | .     |
   | such   | KGS04 |
And I set field "mge" to "-4" in row 1
# Preis kommt aus der Rechnungskorrektur
Then field "preis" has value "50.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK-LS-RE-RLS-05: AU, LS, RE1, RE2, 100% WG zu RE1, Re-Korrektur zu RE1, RLS, KGS
# In der gebuchten RE muss beim Buchen des RLS die remge aktualisiert werden.
# Preis kommt aus RE2 und der RE-Korrektur.
# Siehe https://miro.com/app/board/uXjVPPtvPa4=/ Fall WG5 (100% WG)
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU05" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU05 |
   | kunde   | 1     |
   | such    | AU05  |
And I append rows
   | artikel | mge | preis |
   | V1      |  50 |   100 |
And I save the current editor

# Lieferschein
Given I open an editor "1LS05" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU05"
And I set fields
   | nummer | 1LS05 |
   | such   | LS05  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Teil-Rechnung 1
Given I open an editor "1RE05_1" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS05"
And I set fields
   | nummer | 1RE05_1 |
   | such   | RE05_1  |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "20" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil-Rechnung 2
Given I open an editor "1RE05_2" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS05"
And I set fields
   | nummer | 1RE05_2 |
   | such   | RE05_2  |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "30" in row 1
And I set field "preis" to "102" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 100% Wertgutschrift zu RE05_1
Given I open an editor "1WG05" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE05_1"
And I set fields
   | nummer | 1WG05 |
   | such   | WG05  |
   | ueb    | ja    |
   | tterm  | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnungskorrektur zu RE05_1
Given I open an editor "1REK05" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS05"
And I set fields
   | nummer | 1REK05 |
   | such   | REK05  |
   | ueb    | ja     |
   | tterm  | .      |
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "20" in row 1
And I set field "preis" to "110" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 100% Ruecklieferung
Given I open an editor "RLS05" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS05"
And I set fields
   | nummer | 1RLS05 |
   | such   | RLS05  |
   | ueb    | ja     |
   | tterm  | .      |
   | budat  | .      |
And I set field "mge" to "-50" in row 1
And I save the current editor

# 100% KGS
Given I open an editor "KGS05" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS05"
And I set fields
   | such   | KGS05 |
   | ueb    | ja    |
   | vom    | .     |
   | tterm  | .     |
And I set field "mge" to "-30" in row 1
And I set field "mge" to "-20" in row 2
Then field "preis" has value "102.00" in row 1
# Preis kommt aus der Rechnungskorrektur
Then field "preis" has value "110.00" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK-LS-RE-RLS-08: AU, LS, RLS, RE, 100% WG, Re-Korrektur
# 100% WG nach RLS
# Fall WG8/WG9 (100% WG)
# ----------------------------------------------------------------------------------------------

# Fall WG8 ---------------------------------------
# Auftrag
Given I open an editor "1AU08" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU08 |
   | kunde   | 1     |
   | such    | AU08  |
And I append rows
   | artikel | mge | preis |
   | V2      | 200 |   200 |
And I save the current editor

# Lieferschein
Given I open an editor "1LS08" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU08"
And I set fields
   | nummer | 1LS08 |
   | such   | LS08  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Teil Ruecklieferung - 40 Steuck von 200
Given I open an editor "RLS08" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS08"
And I set fields
   | nummer | 1RLS08 |
   | such   | RLS08  |
   | ueb    | ja     |
   | tterm  | .      |
   | budat  | .      |
And I set field "mge" to "-40" in row 1
And I save the current editor

# Rechnung ueber restliche 160 Stueck
Given I open an editor "1RE08" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS08"
And I set fields
   | nummer | 1RE08 |
   | such   | RE08  |
   | ueb    | ja    |
   | tterm  | .     |
And I set field "mge" to "160" in row 1
And I set field "preis" to "201" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 100% Wertgutschrift zu RE08
Given I open an editor "1WG08" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE08"
And I set fields
   | nummer | 1WG08 |
   | such   | WG08  |
   | ueb    | ja    |
   | tterm  | .     |
And I press button "offueb" in row 1
Then field "mge" has value "-160" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
And I save the current editor

# Rechnungskorrektur zu RE08
Given I open an editor "1REK08" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS08"
And I set fields
   | nummer | 1REK08 |
   | such   | REK08  |
   | ueb    | ja     |
   | tterm  | .      |
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "160" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Fall WG9 ---------------------------------------
# Auftrag
Given I open an editor "1AU09" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU09 |
   | kunde   | 1     |
   | such    | AU09  |
And I append rows
   | artikel | mge | preis |
   | V2      | 200 |   200 |
And I save the current editor

# Lieferschein
Given I open an editor "1LS09" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU09"
And I set fields
   | nummer | 1LS09 |
   | such   | LS09  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Teil Ruecklieferung - 40 Stueck von 200
Given I open an editor "RLS09" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS09"
And I set fields
   | nummer | 1RLS09 |
   | such   | RLS09  |
   | ueb    | ja     |
   | tterm  | .      |
   | budat  | .      |
And I set field "mge" to "-40" in row 1
And I save the current editor

# Rechnung ueber 20 Stueck
Given I open an editor "1RE09" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS09"
And I set fields
   | nummer | 1RE09 |
   | such   | RE09  |
   | ueb    | ja    |
   | tterm  | .     |
And I set field "mge" to "20" in row 1
And I set field "preis" to "202" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 100% Wertgutschrift zu RE09 ueber 20 Stueck
Given I open an editor "1WG09" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE09"
And I set fields
   | nummer | 1WG09 |
   | such   | WG09  |
   | ueb    | ja    |
   | tterm  | .     |
And I press button "offueb" in row 1
Then field "mge" has value "-20" in row 1
Then field "komplettgutschrift" has value "ja" in row 1
And I save the current editor

# Rechnungskorrektur zu RE09
Given I open an editor "1REK09" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS09"
And I set fields
   | nummer | 1REK09 |
   | such   | REK09  |
   | ueb    | ja     |
   | tterm  | .      |
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "20" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK-LS-RE-RLS-10: AU, LS, RLS, RE, RLS, KGS, TWG
# Nur TWG moeglich, keine 100% WG
# Fall WG10 (100% WG)
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU10" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU10 |
   | kunde   | 1     |
   | such    | AU10  |
And I append rows
   | artikel | mge | preis |
   | V2      | 100 |   100 |
And I save the current editor

# Lieferschein
Given I open an editor "1LS10" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU10"
And I set fields
   | nummer | 1LS10   |
   | such   | LS10    |
   | ueb    | ja      |
   | vom    | .       |
And I press button "offueb" in row 1
And I save the current editor

# Teil Ruecklieferung 1 - 20 Stueck von 100
Given I open an editor "RLS10_1" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS10"
And I set fields
   | nummer | 1RLS10_1 |
   | such   | RLS10_1  |
   | ueb    | ja       |
   | tterm  | .        |
   | budat  | .        |
And I set field "mge" to "-20" in row 1
And I save the current editor

# Rechnung ueber 75 Stueck
Given I open an editor "1RE10" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS10"
And I set fields
   | nummer | 1RE10 |
   | such   | RE10  |
   | ueb    | ja    |
   | tterm  | .     |
And I set field "mge" to "75" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil Ruecklieferung 2 - 10 Stueck von 100
Given I open an editor "RLS10_2" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS10"
And I set fields
   | nummer | 1RLS10_2 |
   | such   | RLS10_2  |
   | ueb    | ja       |
   | tterm  | .        |
   | budat  | .        |
And I set field "mge" to "-10" in row 1
And I save the current editor

# KGS ueber 5 Stueck
Given I open an editor "KGS10" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS10_2"
And I set fields
   | such   | KGS10 |
   | ueb    | ja    |
   | vom    | .     |
   | tterm  | .     |
And I set field "mge" to "-5" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# 100 % Wertgutschrift (ueber volle Menge der RE10) nicht moeglich.
Given I open an editor "WERT-ZU-AU10" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to "+1RE10"
# Keine 100% WG mehr moeglich: Gutzuschreibende Menge zu hoch.
Then setting field "mge" to "-75" in row 1 throws the exception "2022"
And I set field "mge" to "-70" in row 1
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-LS-RE-RLS-11: AU, LS, RE1 + RE2 + RE3, RLS (aus LS), KGS, TWG
# Bei mehreren Teilrechnungen muss die remge und der ofwert auf die Rechnungen verteilt
# reduziert werden. (Fall WG11)
# Zuerst R1, R2 und dann R3.
# ----------------------------------------------------------------------------------------------
# AU ------------------- LS -------------------- RE1 ------------------------------------------- 100% WGS (7!)
# 100 St.                100 St. buchen          40 St. buchen (1!)                              -40 St
# | Aktion | remge  |    | Aktion | remge  |     | Aktion | remge  | ofwert |
# |        | 100 St.|    |        | 100 St.|     | (1)    | -40 St.| -2.000 |
#                        | (1)    |  60 St.|     | (2)    | -40 St.| -2.000 |
#                        | (2)    |  25 St.|     | (3)    | -40 St.| -2.000 |
#                        | (3)    |   0 St.|     | (7)    |   0 St.|      0 |
#                         \   \       \    \
#                          \   \       \    \
#                           \   \       \    ------ RE2 ------------------------------------ RE (TWG)
#                            \   \       \          35 St. buchen (2!)                       -10 St. (6!)
#                             \   \       \         | Aktion | remge  | ofwert |
#                              \   \       \        | (2)    | -35 St.| -1.750 |
#                               \   \       \       | (3)    | -35 St.| -1.750 |
#                                \   \       \      | (4)    | -15 St.|   -750 |
#                                 \   \       \     | (6)    |  -5 St.|   -250 |
#                                  \   \       \
#                                   \   \       --------- RE3
#                                    \   \                25 St. buchen (3!)
#                                     \   \               | Aktion | remge  | ofwert |
#                                      \   \              | (3)    | -25 St.| -1.250 |
#                                       \   \             | (4)    |   0 St.|      0 |
#                                        \   \
#                                         \   ----------------------------- RLS ---------- KGS
#                                          \                                -45 St. (4!)   -45 (-40, -5) St. (5!)
#                                           \
#                                            ------------------------------------------------------------------- RE-Korr. (8!)
#                                                                                                               -40 St.
# Auftrag
Given I open an editor "AU11" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1     |
   | such    | AU11  |
And I append rows
   | artikel | mge | preis |
   | V1      | 100 |    50 |
And I save the current editor
# Lieferschein
Given I open an editor "LS11" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU11"
And I set fields
   | such   | LS11  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor
# Rechnung 1 - Menge 40
Given I open an editor "RE11_1" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS11"
And I set fields
   | such   | RE11_1  |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "40" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# Rechnung 2 - Menge 35
Given I open an editor "RE11_2" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS11"
And I set fields
   | such   | RE11_2  |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "35" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# Rechnung 3 - Menge 25
Given I open an editor "RE11_3" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS11"
And I set fields
   | such   | RE11_3  |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "25" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
# Ruecklieferung -45
Given I open an editor "RLS11" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS11"
And I set fields
   | such   | RLS11 |
   | tterm  | .     |
   | budat  | .     |
   | ueb    | ja    |
And I set field "mge" to "-45" in row 1
And I save the current editor
Then field "remge" from editor "RE11_1" in row 1 has value "-40"
Then field "remge" from editor "RE11_2" in row 1 has value "-15"
Then field "remge" from editor "RE11_3" in row 1 has value "0"
Then field "ofwert" from editor "RE11_1" in row 1 has value "-2000.00"
Then field "ofwert" from editor "RE11_2" in row 1 has value "-750.00"
Then field "ofwert" from editor "RE11_3" in row 1 has value "0.00"

# KGS zu Ruecklieferung
Given I open an editor "KGS11" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS11"
And I set fields
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS11 |
And I set field "mge" to "-20" in row 1
And I set field "mge" to "-25" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil-Wertgutschrift zu RE11_3 ist nicht moeglich, da RLS von unten her beruecksichtigt wird
# Die Gutschreibeaktion sollte doch besser eine Fehlermeldung bringen anstatt gar keine Meldung (Besprechen!)
Then opening an editor from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE11_3" throws the exception "2620"

# Teil-Wertgutschrift zu RE11_2
Given I open an editor "WG11" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE11_2"
And I set fields
   | nummer | 1WG11 |
   | such   | WG11  |
   | ueb    | ja    |
   | tterm  | .     |
And I set field "mge" to "-10" in row 1
# Wegen vorheriger RLS nur max Menge 10 erlaubt
Then setting field "mge" to "-16" in row 1 throws the exception "2022"
And I save the current editor

# WGS reduziert den ofwert der Vorgaengerrechnung, remge bleibt unveraendert
Then field "remge" from editor "RE11_2" in row 1 has value "-15"
Then field "ofwert" from editor "RE11_2" in row 1 has value "-250.00"

# 100 % Wertgutschrift fuer RE11_1.
Given I open an editor "WERT-ZU-AU11" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to "!RE11_1^id"
And I set fields
   | nummer | 1WG11K |
   | such   | WG11K  |
   | ueb    | ja     |
   | tterm  | .      |
# Gutzuschreibende Menge zu hoch.
Then setting field "mge" to "-41" in row 1 throws the exception "2022"
And I set field "mge" to "-40" in row 1
And I close the current editor

# TODO: remge wird im Lieferschein nicht erhoeht
Then field "remge" from editor "LS11" in row 1 has value "0"
Then field "rekorrektur" from editor "LS11" in row 1 has value "nein"

# Rechnungskorrektur ueber 40 Stueck
Given I open an editor "REK11" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS11"
And I set fields
   | such   | REK11  |
   | ueb    | ja     |
   | tterm  | .      |
# TODO: Kenner rekorrektur wird noch nicht richtig gesetzt
# Then field "rekorrektur" has value "ja" in row 1
# And I set field "mge" to "40" in row 1
# And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-RE+LB-RLS-WGS-KGS
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE12" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| kunde        | 1      |
	| such         | RE12   |
	| ueb          | ja     |
	| tterm        | .      |
	| vom          | .      |
	| fakt         | ja     |
And I append rows
	| artikel | mge         | preis       | proz  |
	| V1      | 10          | 20          |   0   |
	| PR.     | !dontChange | !dontChange |  -1   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
Then field "remge" from editor "RE12" in row 1 has value "-10"
Then field "ofwert" from editor "RE12" in row 1 has value "-200.00"

# Ruecklieferung 4
Given I open an editor "RLS12" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "RE12"
And I set fields
   | such   | RLS12 |
   | tterm  | .     |
   | budat  | .     |
   | ueb    | ja    |
And I set field "mge" to "-4" in row 1
And I save the current editor
Then field "remge" from editor "RE12" in row 1 has value "-6"
Then field "ofwert" from editor "RE12" in row 1 has value "-120.00"

# KGS zu Ruecklieferung Versuch
Given I open an editor "KGS12" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS12"
And I set fields
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS12 |
And I press button "offueb" in row 1
Then field "mge" has value "-4" in row 1
Then field "preis" has value "20.00" in row 1
Then field "pwert" has value "-80.00" in row 1
And I close the current editor

# Teil-WGS zu RE+LB
Given I open an editor "WG12" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE12"
And I set fields
   | such   | WG12       |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
Then field "ofwert" has value "-120.00" in row 1

And I press button "offueb" in row 1
Then field "preis" has value "20.00" in row 1
Then field "mge" has value "-6" in row 1
Then field "pwert" has value "-120.00" in row 1
And I set field "pwert" to "-100" in row 1
And I save the current editor

# KGS zu Ruecklieferung (TWGS hat Einfluss)
Given I open an editor "KGS12" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS12"
And I set fields
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS12 |
And I press button "offueb" in row 1
Then field "mge" has value "-4" in row 1
Then field "pwert" has value "-80.00" in row 1
Then field "preis" has value "20.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rest Teil-WGS zu RE+LB
Given I open an editor "WG12B" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE12"
And I set fields
   | such   | WG12B      |
   | ueb    | ja         |
   | tterm  | .          |
   | budat  | .          |
Then field "ofwert" has value "-20.00" in row 1

And I press button "offueb" in row 1
Then field "preis" has value "20.00" in row 1
Then field "mge" has value "-6" in row 1
Then field "pwert" has value "-20.00" in row 1
Then field "proz" has value "-83.33" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-LS-RE-RLS-14: AU, LS, RE1, RE2, RLS, KGS -> keine 100% WGS bzw. RE-Korr erlaubt
# EVS-3358
# Siehe https://miro.com/app/board/uXjVPPtvPa4=/ Fall WG14 (keine 100% WG moeglich)
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU14" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU14 |
   | kunde   | 1     |
   | such    | AU14  |
And I append rows
   | artikel | mge | preis |
   | V2      | 100 |   100 |
And I save the current editor

# Lieferschein
Given I open an editor "1LS14" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU14"
And I set fields
   | nummer | 1LS14 |
   | such   | LS14  |
   | ueb    | ja    |
   | fakt   | nein  |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Teil-Rechnung 1 uber 40 Stueck
Given I open an editor "1RE14_1" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU14"
And I set fields
   | nummer | 1RE14_1 |
   | such   | RE14_1  |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "40" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil-Rechnung 2 uber 60 Stueck
Given I open an editor "1RE14_2" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU14"
And I set fields
   | nummer | 1RE14_2 |
   | such   | RE14_2  |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "60" in row 1
And I set field "preis" to "102" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 100% Ruecklieferung
Given I open an editor "RLS14" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS14"
And I set fields
   | nummer | 1RLS14 |
   | such   | RLS14  |
   | ueb    | ja     |
   | tterm  | .      |
   | budat  | .      |
And I set field "mge" to "-100" in row 1
And I save the current editor
# RLS reduziert remge in RE1 und RE2
Then field "remge" from editor "1RE14_1" in row 1 has value "0"
Then field "remge" from editor "1RE14_2" in row 1 has value "0"

# KGS ueber 60 Stueck
Given I open an editor "KGS14" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS14"
And I set fields
   | such   | KGS14 |
   | ueb    | ja    |
   | vom    | .     |
   | tterm  | .     |
And I set field "mge" to "-40" in row 1
Then field "preis" has value "100.00" in row 1
And I set field "mge" to "-60" in row 2
Then field "preis" has value "102.00" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Nicht erlaubt: 100 % Wertgutschrift fuer 1RE14_2
Given I open an editor "WERT-ZU-AU08" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to "+1RE14_2"
Then the table has 0 rows
And I close the current editor

# Nicht erlaubt: Rechnungskorrektur
Given I open an editor "1REK14" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU14"
Then field "rekorrektur" has value "nein" in row 1
Then field "ofmge" has value "0" in row 1
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK-WG-RLS-01 - Keine Wertgutschrift bei ungebuchten Ruecklieferscheinen moeglich
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "2BE01" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 2BE01 |
   | lief    | 1     |
   | such    | BE01  |
And I append rows
   | artikel | mge | preis |
   | E1      | 20  | 10    |
And I save the current editor

# Lieferschein
Given I open an editor "2LS01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "2BE01"
And I set fields
   | nummer | 2LS01  |
   | such   | LS01   |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "10" in row 1
And I set field "platz" to "F2" in row 1
And I save the current editor

# Rechnung
Given I open an editor "2RE01" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "2LS01"
And I set fields
   | nummer | 2RE01 |
   | such   | RE01  |
   | ebeleg | RE01  |
   | ueb    | ja    |
   | vom    | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "2RLS01" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "2LS01"
And I set fields
   | nummer | 2RLS01 |
   | such   | RLS01  |
   | ueb    | nein   |
   | tterm  | .      |
And I set field "mge" to "-5" in row 1
# Versendungsland in RLS aenderbar
Then field "vstaat" is modifiable
And I save the current editor

# Wertgutschrift nicht moeglich
Then opening an editor from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE01" throws the exception "6823"

# Ruecklieferschein buchen
Given I open an editor "2RLS01B" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "2RLS01"
And I set fields
   | ueb  | ja |
And I save the current editor

# Wertgutschrift
Given I open an editor "2WG01" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE01"
And I set fields
   | nummer | 2WG01 |
   | such   | WG01  |
   | ebeleg | WG01  |
   | ueb    | nein  |
   | vom    | .     |
And I set field "mge" to "-5" in row 1
# Versendungsland in KGS aenderbar
Then field "vstaat" is modifiable
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-WG-RLS-02 - Keine Wertgutschrift bei ungebuchten Ruecklieferscheinen moeglich
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "2AU02" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 2AU02 |
   | kunde   | 1     |
   | such    | AU02  |
And I append rows
   | artikel | mge | preis |
   | V1      | 10  | 50    |
And I save the current editor

# Lieferschein
Given I open an editor "2LS02" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "2AU02"
And I set fields
   | nummer | 2LS02 |
   | such   | LS02  |
   | ueb    | ja    |
   | vom    | .     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "2RE02" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "2LS02"
And I set fields
   | nummer | 2RE02 |
   | such   | RE02  |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung ungebucht
Given I open an editor "2RLS02" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "2LS02"
And I set fields
   | nummer | 2RLS02 |
   | such   | RLS02  |
   | ueb    | nein   |
   | tterm  | .      |
   | budat  | .      |
And I set field "mge" to "-5" in row 1
# Bestimmungsland in RLS aenderbar
Then field "vstaat" is modifiable
And I save the current editor

# Wertgutschrift nicht moeglich
Then opening an editor from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "2RE02" throws the exception "6823"

# Ruecklieferschein buchen
Given I open an editor "2RLS02B" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "2RLS02"
And I set fields
   | ueb  | ja |
And I save the current editor

# Wertgutschrift moeglich
Given I open an editor "2WG02" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "2RE02"
And I set fields
    | nummer | 2WG02 |
	| such   | WG02  |
	| ueb    | nein  |
	| tterm  | .     |
	| vom    | .     |
	| budat  | .     |
Then field "wertgutschrift" has value "ja"
Then field "twertgutschrift" has value "ja" in row 1
And I press button "offueb" in row 1
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK-WG-RLS-03 - Kein Ruecklieferschein bei ungebuchter Wertgutschrift moeglich - Fakturieren ueber Lieferschein
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "2BE03" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 2BE03 |
   | lief    | 1     |
   | such    | BE03  |
And I append rows
   | artikel | mge | preis |
   | E1      | 20  | 10    |
And I save the current editor

# Lieferschein
Given I open an editor "2LS03" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "2BE03"
And I set fields
   | nummer | 2LS03 |
   | such   | LS03  |
   | ueb    | ja    |
   | vom    | .     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "2RE03" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "2LS03"
And I set fields
   | nummer | 2RE03 |
   | such   | RE03  |
   | ebeleg | RE03  |
   | ueb    | ja    |
   | vom    | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift ungebucht
Given I open an editor "2WG03" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE03"
And I set fields
   | nummer | 2WG03 |
   | such   | WG03  |
   | ebeleg | WG03  |
   | ueb    | nein  |
   | vom    | .     |
And I set field "mge" to "-10" in row 1
And I save the current editor

# Ruecklieferung nicht moeglich
Then opening an editor from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "2LS03" throws the exception "6824"

# Wertgutschrift buchen
Given I open an editor "2WG03B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "2WG03"
And I set fields
   | ueb  | ja |
And I save the current editor

# Ruecklieferschein moeglich
Given I open an editor "2RLS03" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "2LS03"
And I set fields
   | such   | RLS03 |
   | ueb    | nein  |
   | tterm  | .     |
And I set field "mge" to "-5" in row 1
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK-WG-RLS-04 - Kein Ruecklieferschein bei ungebuchter Wertgutschrift moeglich - Fakturieren ueber Lieferschein
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "2AU04" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 2AU04 |
   | kunde   | 1     |
   | such    | AU04  |
And I append rows
   | artikel | mge | preis |
   | V1      | 10  | 50    |
And I save the current editor

# Lieferschein
Given I open an editor "2LS04" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "2AU04"
And I set fields
   | nummer | 2LS04 |
   | such   | LS04  |
   | ueb    | ja    |
   | vom    | .     |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "2RE04" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "2LS04"
And I set fields
   | nummer | 2RE04 |
   | such   | RE04  |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift ungebucht
Given I open an editor "2WG04" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "2RE04"
And I set fields
    | nummer | 2WG04 |
	| such   | WG04  |
	| ueb    | nein  |
	| tterm  | .     |
	| vom    | .     |
	| budat  | .     |
And I press button "offueb" in row 1
And I save the current editor

# Ruecklieferschein nicht moeglich
Then opening an editor from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "2LS04" throws the exception "6824"

# Wertgutschrift buchen
Given I open an editor "2WG04B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "2WG04"
And I set fields
   | ueb  | ja |
And I save the current editor

# Ruecklieferung moeglich
Given I open an editor "2RLS04" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "2LS04"
And I set fields
   | such   | RLS04 |
   | ueb    | nein  |
   | tterm  | .     |
   | budat  | .     |
And I set field "mge" to "-5" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK-WG-RLS-05 - Kein Ruecklieferschein bei ungebuchter Wertgutschrift moeglich - Fakturieren ueber Bestellung
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "2BE05" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 2BE05 |
   | lief    | 1     |
   | such    | BE05  |
And I append rows
   | artikel | mge | preis |
   | E1      | 20  | 10    |
And I save the current editor

# Lieferschein
Given I open an editor "2LS05" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "2BE05"
And I set fields
   | nummer | 2LS05  |
   | such   | LS05   |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | nein   |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "2RE05" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "2BE05"
And I set fields
   | nummer | 2RE05 |
   | such   | RE05  |
   | ebeleg | RE05  |
   | ueb    | ja    |
   | vom    | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift ungebucht
Given I open an editor "2WG05" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE05"
And I set fields
   | nummer | 2WG05 |
   | such   | WG05  |
   | ebeleg | WG05  |
   | ueb    | nein  |
   | vom    | .     |
And I set field "mge" to "-10" in row 1
And I save the current editor

# Ruecklieferung nicht moeglich
Then opening an editor from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "2LS05" throws the exception "6824"

# Wertgutschrift buchen
Given I open an editor "2WG05B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "2WG05"
And I set fields
   | ueb  | ja |
And I save the current editor

# Ruecklieferschein moeglich
Given I open an editor "2RLS05" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "2LS05"
And I set fields
   | such   | RLS05 |
   | ueb    | nein  |
   | tterm  | .     |
And I set field "mge" to "-5" in row 1
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK-WG-RLS-06 - Kein Ruecklieferschein bei ungebuchter Wertgutschrift moeglich - Fakturieren ueber Auftrag
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "2AU06" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 2AU06 |
   | kunde   | 1     |
   | such    | AU06  |
And I append rows
   | artikel | mge | preis |
   | V1      | 10  | 50    |
And I save the current editor

# Lieferschein
Given I open an editor "2LS06" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "2AU06"
And I set fields
   | nummer | 2LS06  |
   | such   | LS06   |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | nein   |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung
Given I open an editor "2RE06" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "2AU06"
And I set fields
   | nummer | 2RE06  |
   | such   | RE06   |
   | ueb    | ja     |
   | tterm  | .      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift ungebucht
Given I open an editor "2WG06" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "2RE06"
And I set fields
    | nummer | 2WG06 |
	| such   | WG06  |
	| ueb    | nein  |
	| tterm  | .     |
	| vom    | .     |
	| budat  | .     |
And I press button "offueb" in row 1
And I save the current editor

# Ruecklieferschein nicht moeglich
Then opening an editor from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "2LS06" throws the exception "6824"

# Wertgutschrift buchen
Given I open an editor "2WG06B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "2WG06"
And I set fields
   | ueb  | ja |
And I save the current editor

# Ruecklieferung moeglich
Given I open an editor "2RLS06" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "2LS06"
And I set fields
   | such   | RLS06 |
   | ueb    | nein  |
   | tterm  | .     |
   | budat  | .     |
And I set field "mge" to "-5" in row 1
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK-WG-RLS-07 - Kein Ruecklieferschein bei ungebuchter Wertgutschrift moeglich - Rechnung mit Lagerbewegung
# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "2RE07" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 2RE07 |
   | lief   | 1     |
   | such   | RE07  |
   | ebeleg | RE07  |
   | ueb    | ja    |
   | vom    | .     |
   | fakt   | ja    |
And I append rows
   | artikel | mge | preis |
   | V1      | 50  | 12    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift ungebucht
Given I open an editor "2WG07" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "2RE07"
And I set fields
   | nummer | 2WG07 |
   | such   | WG07  |
   | ebeleg | WG07  |
   | ueb    | nein  |
   | vom    | .     |
And I set field "mge" to "-10" in row 1
And I save the current editor

# Ruecklieferung nicht moeglich
Then opening an editor from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "2RE07" throws the exception "6824"

# Wertgutschrift buchen
Given I open an editor "2WGS07B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "2WG07"
And I set fields
   | ueb  | ja |
And I save the current editor

# Ruecklieferschein moeglich
Given I open an editor "2RLS07" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "2RE07"
And I set fields
   | such   | RLS07 |
   | ueb    | nein  |
   | tterm  | .     |
And I set field "mge" to "-5" in row 1
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK-WG-RLS-08 - Kein Ruecklieferschein bei ungebuchter Wertgutschrift moeglich - Rechnung mit Lagerbewegung
# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "2RE08" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 2RE08 |
   | kunde  | 1     |
   | such   | RE08  |
   | ueb    | ja    |
   | tterm  | .     |
   | fakt   | ja    |
And I append rows
   | artikel | mge | preis |
   | V1      | 50  | 12    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift ungebucht
Given I open an editor "2WG08" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "2RE08"
And I set fields
   | nummer | 2WG08 |
   | such   | WG08  |
   | ueb    | nein  |
   | tterm  | .     |
   | vom    | .     |
   | budat  | .     |
And I press button "offueb" in row 1
And I save the current editor

# Ruecklieferschein nicht moeglich
Then opening an editor from table "(Sales):(Invoice)" with command "RETURN" for record from editor "2RE08" throws the exception "6824"

# Wertgutschrift buchen
Given I open an editor "2WGS08B" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "2WG08"
And I set fields
   | ueb  | ja |
And I save the current editor

# Ruecklieferung moeglich
Given I open an editor "2RLS08" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "2RE08"
And I set fields
   | such   | RLS08 |
   | ueb    | nein  |
   | tterm  | .     |
   | budat  | .     |
And I set field "mge" to "-5" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-WG-TLS-13 - Ruecklieferschein aus Rechnung mit Lagerbewegung
# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "RE13" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE13  |
   | kunde  | 1      |
   | such   | RE13   |
   | ueb    | ja     |
   | tterm  | .      |
   | fakt   | ja     |
And I append rows
   | artikel | mge  | preis |
   | E1      | 100  | 12    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS13" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "RE13"
And I set fields
   | such   | RLS02 |
   | ueb    | ja    |
   | tterm  | .     |
   | budat  | .     |
And I set field "mge" to "-40" in row 1
And I save the current editor

Then field "remge" from editor "RE13" in row 1 has value "-60"

# Wertgutschrift
Given I open an editor "WG13" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE13"
And I set fields
   | nummer | 1WG13 |
   | such   | WG13  |
   | ueb    | ja    |
   | tterm  | .     |
   | vom    | .     |
   | budat  | .     |
And I press button "offueb" in row 1
Then field "mge" has value "-60" in row 1
And I press button "komplettieren"
Then field "mge" has value "-60" in row 1
And I close the current editor

# Ruecklieferung
Given I open an editor "RLS13B" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "RE13"
And I set fields
   | such   | RLS13B |
   | ueb    | ja     |
   | tterm  | .      |
   | budat  | .      |
And I set field "mge" to "-20" in row 1
And I save the current editor

Then field "remge" from editor "RE13" in row 1 has value "-40"

# Wertgutschrift
Given I open an editor "WG13_2" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE13"
And I set fields
   | nummer | 1WG13_2 |
   | such   | WG13_2  |
   | ueb    | ja      |
   | tterm  | .       |
   | vom    | .       |
   | budat  | .       |
And I press button "offueb" in row 1
Then field "mge" has value "-40" in row 1
And I press button "komplettieren"
Then field "mge" has value "-40" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-RE+LB-Teil RLS-WGS Button Komplettgutschrift
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE15" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| kunde | 1    |
	| such  | RE15 |
	| ueb   | ja   |
	| tterm | .    |
	| vom   | .    |
	| fakt  | ja   |
And I append rows
	| artikel  | mge         | preis       | proz       | pwert      |
	| V1       | 10          | 8           |!dontChange |!dontChange |
	| PR.      | !dontChange | !dontChange |         10 |!dontChange |
	| V2       | 12          | 6           |!dontChange |!dontChange |
	| TEXT     | !dontChange | !dontChange |!dontChange |        100 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS15" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "RE15"
And I set fields
   | such   | RLS15 |
   | ueb    | ja    |
   | tterm  | .     |
   | budat  | .     |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Wertgutschrift
Given I open an editor "WG15" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE15"
And I set fields
   | such   | WGS15 |
   | ueb    | ja    |
   | tterm  | .     |
   | vom    | .     |
   | budat  | .     |
And I press button "komplettieren"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "komplettgutschrift" has value "nein" in row 2
Then field "komplettgutschrift" has value "ja" in row 3
Then field "komplettgutschrift" has value "ja" in row 4
Then field "komplettgutschrift" has value "nein" in row 5
Then field "komplettgutschrift" has value "nein" in row 6
Then field "komplettgutschrift" has value "nein" in row 7
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift_rls.out"
Then I append text "WGS nach Button Komplettieren: RE+LB bei vorheriger Teil-RLS" to output file "cucumber/refs/wertgutschrift_rls.out"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-AU-LS-RE-RLS-WGS Button Komplettgutschrift
# ----------------------------------------------------------------------------------------------

# AU -------------------  LS ---------------------RE -------------------     - WGS (Button komplett)
# | Artikel | mge.   |    | Artikel | mge    |    | Artikel | mge    |         | komplett | Artikel | mge      |
# | V1      | 100 St.|    | V1      | 100 St.|    | V1      | 100 St.|         | nein     | V1.     |  -60 St. |
# | V2      | 100 St.|    | V2      | 100 St.|    | V2      | 100 St.|         | ja       | V2      | -100 St. |
#              \
#               \
#                 -----------------------------------------------  RLS
#                                                                  Teil
#                                                                  | Artikel | mge |
#                                                                  | V1      | -40 |
#
# Auftrag
Given I open an editor "AU16" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1    |
   | such    | AU16 |
And I append rows
   | artikel | mge | preis |
   | V1      | 100 |   100 |
   | V2      | 100 |   100 |
And I save the current editor

# Lieferschein
Given I open an editor "LS16" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU16"
And I set fields
   | such   | LS16 |
   | ueb    | ja   |
   | vom    | .    |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

# Rechnung
Given I open an editor "RE16" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS16"
And I set fields
   | such   | RE16 |
   | ueb    | ja   |
   | tterm  | .    |
And I set field "mge" to "100" in row 1
And I set field "mge" to "100" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil-Ruecklieferung
Given I open an editor "RLS16" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS16"
And I set fields
   | such   | RLS16 |
   | ueb    | ja    |
   | tterm  | .     |
   | budat  | .     |
And I set field "mge" to "-40" in row 1
And I save the current editor

# Wertgutschrift
Given I open an editor "WG16" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE16"
And I set fields
   | such   | WGS16 |
   | ueb    | ja    |
   | tterm  | .     |
   | vom    | .     |
   | budat  | .     |
And I press button "komplettieren"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "komplettgutschrift" has value "ja" in row 2
Then field "komplettgutschrift" has value "nein" in row 3
Then field "komplettgutschrift" has value "nein" in row 4
Then field "komplettgutschrift" has value "nein" in row 5
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift_rls.out"
Then I append text "WGS nach Button Komplettieren: AU-LS-RE-RLS-WGS" to output file "cucumber/refs/wertgutschrift_rls.out"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK-AU-LS-RE aus AU-Teil RLS-WGS Button Komplettgutschrift
# ----------------------------------------------------------------------------------------------

# AU -------------------  LS ----------------------------------- RLS
# | Artikel | mge.   |    | Artikel | mge    |                   | Artikel | mge |
# | V1      | 100 St.|    | V1      | 100 St.|                   | V1      | -40 |
# | V2      | 100 St.|    | V2      | 100 St.|
#              \
#               \
#                 ------------------------- RE ---------------------- WGS (Button komplett)
#                                           | Artikel | mge    |      | komplett | Artikel | mge      |
#                                           | V1      | 100 St.|      | nein     | V1.     |  -60 St. |
#                                           | V2      | 100 St.|      | ja       | V2      | -100 St. |
#

# Auftrag
Given I open an editor "AU17" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1    |
   | such    | AU17 |
And I append rows
   | artikel | mge | preis |
   | V1      | 100 |   100 |
   | V2      | 100 |   100 |
And I save the current editor

# Lieferschein
Given I open an editor "LS17" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU17"
And I set fields
   | such   | LS17 |
   | ueb    | ja   |
   | fakt   | nein |
   | vom    | .    |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

# Rechnung
Given I open an editor "RE17" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU17"
And I set fields
   | such   | RE17 |
   | ueb    | ja   |
   | tterm  | .    |
And I set field "mge" to "100" in row 1
And I set field "mge" to "100" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil-Ruecklieferung
Given I open an editor "RLS17" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS17"
And I set fields
   | such   | RLS17 |
   | ueb    | ja    |
   | tterm  | .     |
   | budat  | .     |
And I set field "mge" to "-40" in row 1
And I save the current editor

# Wertgutschrift
Given I open an editor "WG17" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE17"
And I set fields
   | such   | WGS17 |
   | ueb    | ja    |
   | tterm  | .     |
   | vom    | .     |
   | budat  | .     |
And I press button "komplettieren"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "komplettgutschrift" has value "ja" in row 2
Then field "komplettgutschrift" has value "nein" in row 3
Then field "komplettgutschrift" has value "nein" in row 4
Then field "komplettgutschrift" has value "nein" in row 5
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift_rls.out"
Then I append text "WGS nach Button Komplettieren: -AU-LS-RE aus AU-Teil RLS-WGS" to output file "cucumber/refs/wertgutschrift_rls.out"

And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK-RE+LB-Teil RLS-WGS Button Komplettgutschrift
# ----------------------------------------------------------------------------------------------

Given I open an editor "RE15" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
	| lief   | 1    |
	| such   | RE15 |
	| ebeleg | RE15 |
	| ueb    | ja   |
	| tterm  | .    |
	| vom    | .    |
	| fakt   | ja   |
And I append rows
	| artikel  | mge         | preis       | proz       | pwert      |
	| V1       | 10          | 8           |!dontChange |!dontChange |
	| PR.      | !dontChange | !dontChange |         10 |!dontChange |
	| V2       | 12          | 6           |!dontChange |!dontChange |
	| TEXT     | !dontChange | !dontChange |!dontChange |        100 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS15" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RE15"
And I set fields
| such   | RLS15 |
| ebeleg | RLS15 |
| ueb    | ja    |
| tterm  | .     |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Wertgutschrift
Given I open an editor "WG15" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE15"
And I set fields
| such   | WGS15 |
| ebeleg | WGS15 |
| ueb    | ja    |
| tterm  | .     |
| vom    | .     |
| budat  | .     |
And I press button "komplettieren"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "komplettgutschrift" has value "nein" in row 2
Then field "komplettgutschrift" has value "ja" in row 3
Then field "komplettgutschrift" has value "ja" in row 4
Then field "komplettgutschrift" has value "nein" in row 5
Then field "komplettgutschrift" has value "nein" in row 6
Then field "komplettgutschrift" has value "nein" in row 7
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift_rls.out"
Then I append text "WGS nach Button Komplettieren: RE+LB bei vorheriger Teil-RLS" to output file "cucumber/refs/wertgutschrift_rls.out"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK-BE-LS-RE-RLS-WGS Button Komplettgutschrift
# ----------------------------------------------------------------------------------------------

# BE -------------------  LS ---------------------RE -------------------     - WGS (Button komplett)
# | Artikel | mge.   |    | Artikel | mge    |    | Artikel | mge    |         | komplett | Artikel | mge      |
# | V1      | 100 St.|    | V1      | 100 St.|    | V1      | 100 St.|         | nein     | V1.     |  -60 St. |
# | V2      | 100 St.|    | V2      | 100 St.|    | V2      | 100 St.|         | ja       | V2      | -100 St. |
#              \
#               \
#                 -----------------------------------------------  RLS
#                                                                  Teil
#                                                                  | Artikel | mge |
#                                                                  | V1      | -40 |
#
# Bestellung
Given I open an editor "BE16" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
| lief   | 1    |
| such   | BE16 |
| ebeleg | BE16 |
And I append rows
| artikel | mge | preis |
| V1      | 100 |   100 |
| V2      | 100 |   100 |
And I save the current editor

# Lieferschein
Given I open an editor "LS16" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE16"
And I set fields
| such   | LS16 |
| ebeleg | LS16 |
| ueb    | ja   |
| vom    | .    |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

# Rechnung
Given I open an editor "RE16" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS16"
And I set fields
| such   | RE16 |
| ebeleg | RE16 |
| ueb    | ja   |
| tterm  | .    |
| vom    | .    |
And I set field "mge" to "100" in row 1
And I set field "mge" to "100" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil-Ruecklieferung
Given I open an editor "RLS16" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS16"
And I set fields
| such   | RLS16 |
| ebeleg | RLS16 |
| ueb    | ja    |
| tterm  | .     |
And I set field "mge" to "-40" in row 1
And I save the current editor

# Wertgutschrift
Given I open an editor "WG16" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE16"
And I set fields
| such   | WGS16 |
| ebeleg | WGS16 |
| ueb    | ja    |
| tterm  | .     |
| vom    | .     |
| budat  | .     |
And I press button "komplettieren"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "komplettgutschrift" has value "ja" in row 2
Then field "komplettgutschrift" has value "nein" in row 3
Then field "komplettgutschrift" has value "nein" in row 4
Then field "komplettgutschrift" has value "nein" in row 5
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift_rls.out"
Then I append text "WGS nach Button Komplettieren: BE-LS-RE-RLS-WGS" to output file "cucumber/refs/wertgutschrift_rls.out"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK-BE-LS-RE aus BE-Teil RLS-WGS Button Komplettgutschrift
# ----------------------------------------------------------------------------------------------

# BE -------------------  LS ----------------------------------- RLS
# | Artikel | mge.   |    | Artikel | mge    |                   | Artikel | mge |
# | V1      | 100 St.|    | V1      | 100 St.|                   | V1      | -40 |
# | V2      | 100 St.|    | V2      | 100 St.|
#              \
#               \
#                 ------------------------- RE ---------------------- WGS (Button komplett)
#                                           | Artikel | mge    |      | komplett | Artikel | mge      |
#                                           | V1      | 100 St.|      | nein     | V1.     |  -60 St. |
#                                           | V2      | 100 St.|      | ja       | V2      | -100 St. |
#

# Bestellung
Given I open an editor "BE17" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
| lief   | 1     |
| such   | BE17  |
| ebeleg | BE17  |
And I append rows
| artikel | mge | preis |
| V1      | 100 |   100 |
| V2      | 100 |   100 |
And I save the current editor

# Lieferschein
Given I open an editor "LS17" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE17"
And I set fields
| such   | LS17  |
| ebeleg | LS17  |
| ueb    | ja    |
| fakt   | nein  |
| vom    | .     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

# Rechnung
Given I open an editor "RE17" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE17"
And I set fields
| such   | RE17 |
| ebeleg | RE17 |
| ueb    | ja   |
| tterm  | .    |
| vom    | .    |
And I set field "mge" to "100" in row 1
And I set field "mge" to "100" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil-Ruecklieferung
Given I open an editor "RLS17" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS17"
And I set fields
| such   | RLS17 |
| ebeleg | RLS17 |
| ueb    | ja    |
| tterm  | .     |
And I set field "mge" to "-40" in row 1
And I save the current editor

# Wertgutschrift
Given I open an editor "WG17" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE17"
And I set fields
| such   | WGS17 |
| ebeleg | WGS17 |
| ueb    | ja    |
| tterm  | .     |
| vom    | .     |
| budat  | .     |
And I press button "komplettieren"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "komplettgutschrift" has value "ja" in row 2
Then field "komplettgutschrift" has value "nein" in row 3
Then field "komplettgutschrift" has value "nein" in row 4
Then field "komplettgutschrift" has value "nein" in row 5
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift_rls.out"
Then I append text "WGS nach Button Komplettieren: -BE-LS-RE aus BE-Teil RLS-WGS" to output file "cucumber/refs/wertgutschrift_rls.out"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-AU-RE-RLS - WGS Verschiedene Positionstypen
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU18" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
| kunde  | 1    |
| such   | AU18 |
And I append rows
| artikel | mge         | preis       | pwert       |
| V1      | 100         | 100         | !dontChange |
| AUBEPOS | 50          | 15          | !dontChange |
| TEXT    | !dontChange | !dontChange |  90         |
| NEUPOS  | !dontChange | !dontChange | 240         |
| DL-REP  | 2           | 85          | !dontChange |
And I save the current editor

# Rechnung mit Lagerbewegung
Given I open an editor "RE18" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU18"
And I set fields
| such   | RE18 |
| ueb    | ja   |
| tterm  | .    |
| vom    | .    |
And I set field "mge" to "100" in row 1
And I set field "mge" to "50" in row 2
And I set field "pwert" to "90" in row 3
And I set field "pwert" to "240" in row 4
And I set field "mge" to "2" in row 5
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil-Ruecklieferung
Given I open an editor "RLS18" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "RE18"
And I set fields
| such   | RLS18 |
| ueb    | ja    |
| tterm  | .     |
| budat  | .     |
And I set field "mge" to "-35" in row 1
And I set field "mge" to "-20" in row 2
And I set field "pwert" to "-50" in row 3
And I set field "pwert" to "-180" in row 4
And I set field "mge" to "-1" in row 5
And I save the current editor

# Wertgutschrift nicht speichern
# Beruecksichtigung der Ruecklieferung beim Komplettieren funktioniert nicht fuer Text- und neutrale Positionen
Given I open an editor "WG18" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE18"
And I set fields
| such   | WGS18 |
| ueb    | ja    |
| tterm  | .     |
| vom    | .     |
| budat  | .     |
And I press button "komplettieren"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "komplettgutschrift" has value "nein" in row 2
Then field "komplettgutschrift" has value "nein" in row 3
Then field "komplettgutschrift" has value "nein" in row 4
Then field "komplettgutschrift" has value "nein" in row 5
Then field "mge" has value "-65" in row 1
Then field "mge" has value "-30" in row 2
Then field "pwert" has value "-40.00" in row 3
Then field "pwert" has value "-60.00" in row 4
Then field "mge" has value "-1" in row 5
And I close the current editor

# Wertgutschrift
# Beruecksichtigung der Ruecklieferung beim Uebertragen der offenen Menge funktioniert nicht fuer Text- und neutrale Positionen
Given I open an editor "WG18" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE18"
And I set fields
| such   | WGS18 |
| ueb    | ja    |
| tterm  | .     |
| vom    | .     |
| budat  | .     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I press button "offueb" in row 4
And I press button "offueb" in row 5
Then field "mge" has value "-65" in row 1
Then field "mge" has value "-30" in row 2
Then field "pwert" has value "-40.00" in row 3
Then field "pwert" has value "-60.00" in row 4
Then field "mge" has value "-1" in row 5
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-AU-LS-RE aus AU - Ruecklieferung eines Setartikel
# ----------------------------------------------------------------------------------------------

# AU -------------------  LS ----------------------------------- RLS
# | Artikel | mge.   |    | Artikel | mge   |                   | Artikel | mge |
# | SETART  | 10 St. |    | SETART  | 10 St.|                   | SETART  | -2  |
#              \
#               \
#                 ------------------------- RE ---------------------- WGS (Button komplett)
#                                           | Artikel | mge   |      | komplett | Artikel | mge     |
#                                           | SETART  | 10 St.|      | nein     | V1.     |  -8 St. |
#

# Auftrag
Given I open an editor "AU19" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1    |
   | such    | AU19 |
And I append rows
   | artikel | mge | preis |
   | SETART  | 10  |   35  |
And I save the current editor

# Lieferschein
Given I open an editor "LS19" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU19"
And I set fields
   | such   | LS19 |
   | ueb    | ja   |
   | fakt   | nein |
   | vom    | .    |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE19" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU19"
And I set fields
   | such   | RE19 |
   | ueb    | ja   |
   | tterm  | .    |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil-Ruecklieferung
Given I open an editor "RLS19" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS19"
And I set fields
   | such   | RLS19 |
   | ueb    | ja    |
   | tterm  | .     |
   | budat  | .     |
And I set field "mge" to "-2" in row 1
And I save the current editor

# Wertgutschrift
Given I open an editor "WG19" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE19"
And I set fields
   | such   | WGS19 |
   | ueb    | ja    |
   | tterm  | .     |
   | vom    | .     |
   | budat  | .     |
And I press button "komplettieren"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "mge" has value "-8" in row 1
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift_rls.out"
Then I append text "WGS nach Button Komplettieren: -AU-LS-RE aus AU-Setartikel RLS-WGS" to output file "cucumber/refs/wertgutschrift_rls.out"
And I save the current editor

#-------------------------------------------------------------------------------------
Scenario: EK-BE-LS-RE aus BE - Ruecklieferung mit Beistellung
#-------------------------------------------------------------------------------------

# Bestellung mit Beistellteil anlegen
Given I open an editor "BE20" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE20 |
   | lief   | 1     |
And I append rows
   | artex  | mge |
   | ABEIST | 10  |
And I save the current editor

# Lieferung ueber komplette Menge
Given I open an editor "LS20" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE20"
And I set fields
   | nummer | 1LS20  |
   | vom    | .      |
   | fakt   | nein   |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE20" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE20"
And I set fields
   | nummer | 1RE20  |
   | such   | RE20   |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil-Ruecklieferung
Given I open an editor "RLS20" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS20"
And I set fields
   | nummer | 1RLS20 |
   | such   | RLS20  |
   | ueb    | ja     |
   | tterm  | .      |
And I set field "mge" to "-3" in row 1
And I save the current editor

# Wertgutschrift
Given I open an editor "WG20" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE20"
And I set fields
   | nummer | 1WGS20 |
   | such   | WGS20  |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
   | budat  | .      |
And I press button "komplettieren"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "mge" has value "-7" in row 1
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift_rls.out"
Then I append text "WGS nach Button Komplettieren: -BE-LS-RE aus BE-Beistellartikel RLS-WGS" to output file "cucumber/refs/wertgutschrift_rls.out"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK-BE-LS-RE - KGS zu Ruecklieferung nach WGS und REKO
# Fall WG4 Einkauf
# Preis in KGS muss aus Rechnungskorrektur kommen
# ----------------------------------------------------------------------------------------------

# BE ------------------ LS ------------------ RE ------------------- WG
# 100 St.               100 St. buchen        100 St. buchen (1!)    -100 St. buchen (2!)
# | Aktion | remge  |   | Aktion | remge  |   | Aktion | remge   |   | Aktion | remge   |
# |        | 100 St.|   |        | 100 St.|   |        |  100 St.|   |        | -100 St.|
#                       | (1)    |   0 St.|   | (1)    | -100 St.|   | (2)    |    0 St.|
#                       | (2)    | 100 St.|   | (2)    |    0 St.|
#                       | (3)    |   0 St.|
#                       | (4)    |   0 St.|
#                            \     \
#                             \     ------------------------------------- RE (RE-Korrektur)
#                              \                                          100 St. (3!)
#                               \                                         | Aktion |  remge  | preis |
#                                \                                        | (3)    | -100 St.|     8 |
#                                 \                                       | (4)    |  -60 St.|     8 |
#                                  \
#                                   ------------------------------------------- RLS ------------------- KGS
#                                                                               -40 St. buchen (4!)     -40 St. buchen (5!)
#                                                                               | Aktion | remge   |    | Aktion | remge   | preis |
#                                                                               |        |   0 St. |    |        |  -40 St.|     8 |
#                                                                               | (4)    | -40 St. |    |   (5)  |   0  St.|       |
#                                                                               | (5)    |   0 St. |


# Bestellung
Given I open an editor "BE21" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE21|
   | lief    | 1    |
   | such    | BE21 |
And I append rows
   | artikel | mge  | preis |
   | V1      | 100  |   10  |
And I save the current editor

# Lieferschein
Given I open an editor "LS21" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE21"
And I set fields
   | nummer | 1LS21|
   | such   | LS21 |
   | ueb    | ja   |
   | fakt   | ja   |
   | vom    | .    |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE21" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS21"
And I set fields
   | nummer | 1RE21|
   | such   | RE21 |
   | ebeleg | 1RE21|
   | ueb    | ja   |
   | vom    | .    |
   | tterm  | .    |
And I set field "mge" to "100" in row 1
And I set field "preis" to "9" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "WG21" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE21"
And I set fields
   | nummer | 1WGS21|
   | such   | WGS21 |
   | ueb    | ja    |
   | tterm  | .     |
   | vom    | .     |
   | budat  | .     |
And I press button "komplettieren"
Then field "komplettgutschrift" has value "ja" in row 1
Then field "mge" has value "-100" in row 1
And I save the current editor

# Rechnungskorrektur
Given I open an editor "RK21" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS21"
And I set fields
   | nummer | 1RK21|
   | such   | RK21 |
   | ebeleg | RK21 |
   | ueb    | ja   |
   | tterm  | .    |
   | vom    | .    |
And I set field "mge" to "100" in row 1
And I set field "preis" to "8" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil-Ruecklieferung
Given I open an editor "RLS21" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS21"
And I set fields
   | nummer | 1RLS21|
   | such   | RLS21 |
   | ueb    | ja    |
   | tterm  | .     |
And I set field "mge" to "-40" in row 1
And I save the current editor

# Kaufmaennische Gutschrift
Given I open an editor "KGS21" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS21"
And I set fields
   | nummer | 1KGS21|
   | such   | KGS21 |
   | ebeleg | KGS21 |
   | ueb    | ja    |
   | tterm  | .     |
   | vom    | .     |
   | budat  | .     |
Then field "mge" has value "-40" in row 1
Then field "preis" has value "8.00" in row 1
# Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift_rls.out"
# Then I append text "KGS nach WGS und REKO" to output file "cucumber/refs/wertgutschrift_rls.out"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-LS-RE-RLS-22: LS, RE, 100% WG
# Siehe https://miro.com/app/board/uXjVPPtvPa4=/ Fall WG30A (100% WG)
# Siehe u.a. EVS-4972
# ----------------------------------------------------------------------------------------------
#
#  LS ------------------ RE1
#  100 St. buchen        20 St. buchen (1!)   preis 100
#  | Aktion | remge  |   | Aktion | remge   |
#  |        | 100 St.|   |        |   20 St.|
#  | (1)    |  80 St.|   | (1)    |  -20 St.|
#  | (2)    |   0 St.|
#  | (3)    |  80 St.|
#  | (4)    |   0 St.|
#   \                 \
#    \                 \
#     \                 \
#      \                  RE2 ------------------- WG
#       \                 100 St. buchen (2!)    -100 St. buchen (3!)
#        \                | Aktion | remge   |   | Aktion | remge   |
#         \               |        |   80 St.|   |        | -100 St.|
#          \              | (1)    |  -80 St.|   | (2)    |    0 St.|
#           \             | (2)    |    0 St.|
#            \
#             \
#              \------------------------------------- RE (RE-Korrektur)
#               \                                     100 St. (4!)
#                \                                    | Aktion |  remge  | preis |
#                 \                                   | (3)    |  -80 St.|    50 |
#                  \                                  | (4)    |    0 St.|    50 |
#                   \
#                    ------------------------------------------- RLS ------------------- KGS
#                                                          -100 St. buchen (5!)      -100 St. buchen (6!)
#                                                          | Aktion | remge   |      | Aktion | remge   |
#                                                          |        | -100 St.|      |        | -100 St.|
#                                                          | (5)    | -100 St.|      |   (6)  |    0 St.|
#                                                          | (6)    |    0 St.|

# Lieferschein
Given I open an editor "1LS22" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS22 |
   | kunde  | 1     |
   | such   | LS22  |
   | ueb    | ja    |
   | vom    | .     |
And I append rows
   | artikel | mge |
   | V1      | 100 |
And I save the current editor

# 1. Rechnung
Given I open an editor "1RE22" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS22"
And I set fields
   | nummer | 1RE22 |
   | such   | RE22_1|
   | ueb    | ja    |
   | tterm  | .     |
And I set field "mge" to "20" in row 1
And I set field "preis" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 2. Rechnung
Given I open an editor "2RE22" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS22"
And I set fields
   | nummer | 2RE22 |
   | such   | RE22_2|
   | ueb    | ja    |
   | tterm  | .     |
And I set field "mge" to "80" in row 1
And I set field "preis" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 100% Wertgutschrift zu Rechnung 2
Given I open an editor "2WG22" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "2RE22"
And I set fields
   | nummer | 2WG22 |
   | such   | WG22  |
   | ueb    | ja    |
   | tterm  | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnungskorrektur
Given I open an editor "1REK22" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS22"
And I set fields
   | nummer | 1REK22 |
   | such   | REK22  |
   | ueb    | ja     |
   | tterm  | .      |
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "80" in row 1
And I set field "preis" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung der gesamten Menge
Given I open an editor "RLS22" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS22"
And I set fields
   | such   | RLS22 |
   | ueb    |    ja |
   | tterm  | .     |
And I set field "mge" to "-100" in row 1
# Bestimmungsland in RLS aenderbar
Then field "vstaat" is modifiable
And I save the current editor
Then field "remge" from editor "1LS22" in row 1 has value "0"

# KGS
Given I open an editor "KGS22" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS22"
And I set fields
   | ueb    | ja    |
   | vom    | .     |
   | tterm  | .     |
   | such   | KGS22 |
And I set field "mge" to "-20" in row 1
And I set field "preis" to "100" in row 1
And I set field "mge" to "-80" in row 2
# Bestimmungsland in KGS aenderbar
Then field "vstaat" is modifiable
# Preis kommt aus der Rechnungskorrektur
And I set field "preis" to "50" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK-LS-RE-RLS-04: AU, LS, RE, 100% WG
# In der gebuchten RE muss beim Buchen des RLS die remge aktualisiert werden.
# Siehe u.a. EVS-4972
# ----------------------------------------------------------------------------------------------
#
# AU ------------------ LS ------------------------------------------------ RLS ------------------- KGS
# 100 St.               100 St. buchen                                      -4 St. buchen (4!)      -4 St. buchen (5!)
# | Aktion   | remge  | | Aktion | remge  |                                 | Aktion | remge |      | Aktion | remge  |
# |          | 100 St.| |        | 100 St.|                                 |        |  0 St.|      |        | -30 St.|
#  \   | (1) |   0 St.|                                                     | (4)    |-30 St.|      |   (5)  |   0 St.|
#   \  | (2) | 100 St.|                                                     | (5)    |  0 St.|
#    \ | (3) |   0 St.|
#     \| (4) |   0 St.|
#      \
#       \-----------------  RE ------------------- WG
#        \                 100 St. buchen (1!)    -100 St. buchen (2!)
#         \                 | Aktion | remge   |   | Aktion | remge   |
#          \                |        |  100 St.|   |        | -100 St.|
#           \               | (1)    | -100 St.|   | (2)    |    0 St.|
#            \              | (2)    |    0 St.|
#             \
#              --------------------------------------------------- RE (RE-Korrektur)
#                                                                  100 St. (3!)
#                                                                  | Aktion |  remge  | preis |
#                                                                  | (3)    | -100 St.|    50 |
#                                                                  | (4)    |  -70 St.|    50 |
#

# Auftrag
Given I open an editor "1AU23" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU23 |
   | kunde   | 1     |
   | such    | AU23  |
And I append rows
   | artikel | mge         | preis       | proz        | pwert       |
   | V1      | 100         | 100         | !dontChange | !dontChange |
   | AUBEPOS | 50          | 15          | !dontChange | !dontChange |
   | DL-REP  | 10          | 90          | -20         | !dontChange |
   | TEXT    | !dontChange | !dontChange | !dontChange | 150         |
   | NEUPOS  | !dontChange | !dontChange | !dontChange | 110         |
And I save the current editor

# Lieferschein
Given I open an editor "1LS23" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU23"
And I set fields
   | nummer | 1LS23 |
   | such   | LS23  |
   | ueb    | ja    |
   | fakt   | nein  |
   | vom    | .     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I press button "offueb" in row 4
And I press button "offueb" in row 5
And I save the current editor

# Rechnung
Given I open an editor "1RE23" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU23"
And I set fields
   | nummer | 1RE23 |
   | such   | RE23  |
   | ueb    | ja    |
   | tterm  | .     |
And I set field "proz" to "-10" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# 100% Wertgutschrift
Given I open an editor "1WG23" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE23"
And I set fields
   | nummer | 1WG23 |
   | such   | WG23  |
   | ueb    | ja    |
   | tterm  | .     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I press button "offueb" in row 4
And I press button "offueb" in row 5
And I save the current editor

# Rechnungskorrektur
Given I open an editor "1REK23" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU23"
And I set fields
   | nummer | 1REK23 |
   | such   | REK23  |
   | ueb    | ja     |
   | tterm  | .      |
Then field "rekorrektur" has value "ja" in row 1
And I set field "preis" to "50" in row 1
Then field "rekorrektur" has value "ja" in row 2
And I set field "preis" to "20" in row 2
Then field "rekorrektur" has value "ja" in row 3
And I set field "preis" to "75" in row 3
And I set field "proz" to "-4" in row 3
Then field "rekorrektur" has value "ja" in row 4
And I set field "pwert" to "140" in row 4
Then field "rekorrektur" has value "ja" in row 5
And I set field "pwert" to "120" in row 5
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS23" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS23"
And I set fields
   | nummer | 1RLS23 |
   | such   | RLS23  |
   | ueb    |    ja  |
   | tterm  | .      |
And I set field "mge" to "-30" in row 1
And I set field "mge" to "-15" in row 2
And I set field "mge" to "-5" in row 3
And I save the current editor
Then field "remge" from editor "1LS23" in row 1 has value "0"
# RLS hat Einfluss auf die remge in der RE
Then field "remge" from editor "1REK23" in row 1 has value "-70"

# Kaufmaennische Gutschrift
Given I open an editor "KGS23" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS23"
And I set fields
   | nummer | 1KGS23 |
   | such   | KGS23  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "-30" in row 1
# Preis kommt aus der Rechnungskorrektur
Then field "preis" has value "50.00" in row 1
And I set field "mge" to "-15" in row 2
# Preis kommt aus der Rechnungskorrektur
Then field "preis" has value "20.00" in row 2
And I set field "mge" to "-5" in row 3
# Preis kommt aus der Rechnungskorrektur
Then field "preis" has value "75.00" in row 3
# Abschlag wird aus Rechnungskorrektur uebernommen
Then field "proz" has value "-4" in row 3
Then field "pwert" has value "-360.00" in row 3
Then field "nwert" has value "-360.00" in row 3
# Keine Beschraenkung des Positionswert fuer Textpositionen
And I set field "pwert" to "-300" in row 4
And I set field "pwert" to "-110" in row 5
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK-REL-WG-REKO-RLS-24 - Rechnung mit Lagerbewegung
# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "1RE24" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | nummer | 1RE24 |
   | lief   | 1     |
   | such   | RE24  |
   | ebeleg | RE24  |
   | ueb    | ja    |
   | vom    | .     |
   | fakt   | ja    |
And I append rows
   | artikel | mge         | preis       | proz        | pwert       |
   | E1      | 40          | 9           | !dontChange | !dontChange |
   | AUBEPOS | 20          | 15          | -5          | !dontChange |
   | DL-REP  | 15          | 70          | !dontChange | !dontChange |
   | TEXT    | !dontChange | !dontChange | !dontChange | 50          |
   | NEUPOS  | !dontChange | !dontChange | !dontChange | 65          |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "1WG24" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE24"
And I set fields
   | nummer | 1WG24 |
   | such   | WG24  |
   | ebeleg | WG24  |
   | ueb    | ja    |
   | vom    | .     |
And I set field "mge" to "-40" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I press button "offueb" in row 4
And I press button "offueb" in row 5
And I save the current editor

# Rechnungskorrektur
Given I open an editor "1RK24" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE24"
And I set fields
   | nummer | 1RK24  |
   | such   | RK24   |
   | ebeleg | RK24   |
   | ueb    | ja     |
   | vom    | .      |
And I press button "burekorrektur"
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "40" in row 1
And I set field "preis" to "7" in row 1
Then field "rekorrektur" has value "ja" in row 2
And I set field "mge" to "20" in row 2
And I set field "preis" to "22" in row 2
And I set field "proz" to "-10" in row 2
Then field "rekorrektur" has value "ja" in row 3
And I set field "mge" to "15" in row 3
And I set field "preis" to "72" in row 3
Then field "rekorrektur" has value "ja" in row 4
And I set field "pwert" to "140" in row 4
Then field "rekorrektur" has value "ja" in row 5
And I set field "pwert" to "120" in row 5
And I save the current editor

# Ruecklieferschein
Given I open an editor "1RLS24" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "1RE24"
And I set fields
   | nummer | 1RLS24 |
   | such   | RLS24  |
   | ueb    | ja     |
   | tterm  | .      |
And I set field "mge" to "-12" in row 1
And I set field "mge" to "-10" in row 2
And I set field "mge" to "-7" in row 3
And I save the current editor

Then field "remge" from editor "1RE24" in row 1 has value "0"
Then field "remge" from editor "1RK24" in row 1 has value "-28"

# Kaufmaennische Gutschrift
Given I open an editor "KGS24" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS24"
And I set fields
   | nummer | 1KGS24 |
   | such   | KGS24  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
Then field "mge" has value "-12" in row 1
# Preis kommt aus der Rechnungskorrektur
Then field "preis" has value "7.00" in row 1
Then field "mge" has value "-10" in row 2
# Preis kommt aus der Rechnungskorrektur
Then field "preis" has value "22.00" in row 2
# Abschlag kommt aus der Rechnungskorrektur
Then field "proz" has value "-10" in row 2
Then field "mge" has value "-7" in row 3
# Preis kommt aus der Rechnungskorrektur
Then field "preis" has value "72.00" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-AU-LS-RE-RLS - Storno RLS WG17
# ----------------------------------------------------------------------------------------------

# AU -------------------  LS ---------------------RE ----------------------- WGS (Button komplett)
# | Artikel | mge.   |    | Artikel | mge    |    | Artikel | mge    |         | komplett | Artikel | mge      |
# | V1      | 100 St.|    | V1      | 100 St.|    | V1      | 100 St.|         | nein     | V1      | -100 St. |
#                          \
#                           \
#                            - -----------------------------------  RLS ----------------- Storno_RLS
#                            \                                     | Artikel | mge  |    | Artikel | mge  |
#                             \                                    | V1      | -100 |    | V1      | -100 |
#                              \
#                                --------------------------------------------------------------------------- REKO
#                                                                                                            | Artikel | mge    |
#                                                                                                            | V1      | 100 St.|
#
#
# Auftrag
Given I open an editor "AU25" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1     |
   | nummer  | 1AU25 |
   | such    | AU25  |
And I append rows
   | artikel | mge | preis |
   | V1      | 100 |   100 |
And I save the current editor

# Lieferschein
Given I open an editor "LS25" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU25"
And I set fields
   | nummer | 1LS25 |
   | such   | LS25  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE25" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS25"
And I set fields
| nummer | 1RE25 |
| such   | RE25  |
| ueb    | ja    |
| tterm  | .     |
| vom    | .     |
And I set field "mge" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS25" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS25"
And I set fields
| nummer | 1RLS25 |
| such   | RLS25  |
| ueb    | ja     |
| tterm  | .      |
| budat  | .      |
And I set field "mge" to "-100" in row 1
And I save the current editor

# RLS hat Einfluss auf die remge in der RE
Then field "remge" from editor "RE25" in row 1 has value "0"

# Storno Ruecklieferung
Given I open an editor "ST_RLS25" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS25"
And I save the current editor

# Storno-RLS hat Einfluss auf die remge in der RE
Then field "remge" from editor "RE25" in row 1 has value "-100"

# Wertgutschrift
Given I open an editor "WG25" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE25"
And I set fields
| nummer | 1WGS25 |
| such   | WGS25  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
| budat  | .      |
And I press button "offueb" in row 1
Then field "mge" has value "-100" in row 1
And I save the current editor

# Rechnungskorrektur
Given I open an editor "REK25" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS25"
And I set fields
   | nummer | 1REK25 |
   | such   | REK25  |
   | ueb    | ja     |
   | tterm  | .      |
Then field "rekorrektur" has value "ja" in row 1
Then field "mge" has value "100" in row 1
And I set field "preis" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK-BE-LS-RE-RLS - Storno Teil-RLS WG18
# ----------------------------------------------------------------------------------------------

# BE -------------------  LS ---------------------RE ----------------------- WGS (Button komplett)
# | Artikel | mge.   |    | Artikel | mge    |    | Artikel | mge    |         | komplett | Artikel | mge      |
# | V1      | 100 St.|    | V1      | 100 St.|    | V1      | 100 St.|         | nein     | V1      | -100 St. |
#                          \
#                           \
#                            - -----------------------------------  RLS ----------------- Storno_RLS
#                             \                                     | Artikel | mge  |    | Artikel | mge  |
#                              \                                    | V1      | -20  |    | V1      | -20 |
#                               \
#                                --------------------------------------------------------------------------- REKO
#                                                                                                            | Artikel | mge    |
#                                                                                                            | V1      | 100 St.|
#
#
# Bestellung
Given I open an editor "BE26" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE26 |
   | lief   | 1     |
   | such   | BE26  |
And I append rows
   | artikel | mge | preis |
   | E1      | 100 |   100 |
And I save the current editor

# Lieferschein
Given I open an editor "LS26" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE26"
And I set fields
   | nummer | 1LS26 |
   | such   | LS26  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE26" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS26"
And I set fields
| nummer | 1RE26 |
| such   | RE26  |
| ueb    | ja    |
| tterm  | .     |
| vom    | .     |
And I set field "mge" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS26" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS26"
And I set fields
| nummer | 1RLS26 |
| such   | RLS26  |
| ueb    | ja     |
| tterm  | .      |
And I set field "mge" to "-100" in row 1
And I save the current editor

# RLS hat Einfluss auf die remge in der RE
Then field "remge" from editor "RE26" in row 1 has value "0"

# Storno Ruecklieferung
Given I open an editor "ST_RLS26" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS26"
And I save the current editor

# Storno-RLS hat Einfluss auf die remge in der RE
Then field "remge" from editor "RE26" in row 1 has value "-100"

# Wertgutschrift
Given I open an editor "WG26" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE26"
And I set fields
| nummer | 1WGS26 |
| such   | WGS26  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
| budat  | .      |
And I press button "offueb" in row 1
Then field "mge" has value "-100" in row 1
And I save the current editor

# Rechnungskorrektur
Given I open an editor "REK26" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS26"
And I set fields
   | nummer | 1REK26 |
   | such   | REK26  |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
Then field "rekorrektur" has value "ja" in row 1
Then field "mge" has value "100" in row 1
And I set field "preis" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-AU-LS-RE-TWGS RLS-KGS
# TWG9a
# ----------------------------------------------------------------------------------------------

# AU -------------------  LS ---------------------RE -------------------- WGS1
# | Artikel | mge.   |    | Artikel | mge    |    | Artikel | mge    |      | Artikel | mge     | preis | pwert |
# | V1      | 100 St.|    | V1      | 100 St.|    | V1      | 100 St.|      | V1      | -30 St. | 10    | 300   |
#                          \
#                           \
#                            ---------------------------------------------- WGS2
#                             \                                               | Artikel | mge     | preis| pwert |
#                              \                                              | V1      | -20 St. | 10   | 200   |
#                               \
#                                \
#                                 ---------------------------------------------- RLS1 ------------------ KGS1
#                                  \                                               | Artikel | mge    |    | Artikel | mge  | preis |
#                                   \                                              | V1      | -40 St.|    | V1      | -40  | 5     |
#                                    \
#                                      ------------------------------------------------RLS2 ---------------- KGS2
#                                                                                    | Artikel | mge    |    | Artikel | mge  | preis |
#                                                                                    | V1      | -50 St.|    | V1      | -50  | 5     |
#
#
# Auftrag
Given I open an editor "AU27" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1     |
   | nummer  | 1AU27 |
   | such    | AU27  |
And I append rows
   | artikel | mge | preis |
   | V1      | 100 |    10 |
And I save the current editor

# Lieferschein
Given I open an editor "LS27" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU27"
And I set fields
   | nummer | 1LS27 |
   | such   | LS27  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE27" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS27"
And I set fields
| nummer | 1RE27 |
| such   | RE27  |
| ueb    | ja    |
| tterm  | .     |
| vom    | .     |
And I set field "mge" to "100" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift 1
Given I open an editor "TWG27A" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE27"
And I set fields
| nummer | 1TWG27A |
| such   | TWG27A  |
| ueb    | ja      |
| tterm  | .       |
| vom    | .       |
| budat  | .       |
And I set field "mge" to "-30" in row 1
Then field "pwert" has value "-300.00" in row 1
And I save the current editor

Given I open an editor "TWG27B" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE27"
And I set fields
   | nummer | 1TWG27B |
   | such   | TWG27B  |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-20" in row 1
Then field "pwert" has value "-200.00" in row 1
And I save the current editor

# Ruecklieferung 1
Given I open an editor "RLS27A" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS27"
And I set fields
| nummer | 1RLS27A |
| such   | RLS27A  |
| ueb    | ja      |
| tterm  | .       |
| budat  | .       |
And I set field "mge" to "-40" in row 1
And I save the current editor

# Ruecklieferung 2
Given I open an editor "RLS27B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS27"
And I set fields
| nummer | 1RLS27B |
| such   | RLS27B  |
| ueb    | ja      |
| tterm  | .       |
| budat  | .       |
And I set field "mge" to "-50" in row 1
And I save the current editor

# Kaufmaennische Gutschrift 1
Given I open an editor "KGS27A" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS27A"
And I set fields
   | nummer | 1KGS27A |
   | such   | KGS27A  |
   | ueb    | ja      |
   | vom    | .       |
   | tterm  | .       |
Then field "mge" has value "-40" in row 1
# Preis muss durch Teilwertgutschriften reduziert sein
Then field "preis" has value "5.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Kaufmaennische Gutschrift 2
Given I open an editor "KGS27B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS27B"
And I set fields
   | nummer | 1KGS27B |
   | such   | KGS27B  |
   | ueb    | ja      |
   | vom    | .       |
   | tterm  | .       |
Then field "mge" has value "-50" in row 1
# Preis muss durch Teilwertgutschriften reduziert sein
Then field "preis" has value "5.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK-BE-LS-RE-TWGS RLS-KGS
# TWG18
# ----------------------------------------------------------------------------------------------

# BE ------------------- LS ------------------- RE ------------------- WGS
# | Artikel | mge.  |    | Artikel | mge   |    | Artikel | mge   |    | Artikel | mge    | preis | pwert |
# | V1      | 10 St.|    | V1      | 10 St.|    | V1      | 10 St.|    | V1      | -4 St. | 10    | 40    |
#                          \
#                           \
#                            \
#                             ------------------------------------------ RLS1 ------------------ KGS1
#                              \                                         | Artikel | mge   |    | Artikel | mge | preis |
#                               \                                        | V1      | -3 St.|    | V1      | -3  | 6     |
#                                \
#                                  ---------------------------------------------------------------- RLS2 ---------------- KGS2
#                                                                                                    | Artikel | mge   |    | Artikel | mge | preis |
#                                                                                                    | V1      | -4 St.|    | V1      | -4  | 6     |
#
#
# Bestellung
Given I open an editor "BE28" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | 1     |
   | nummer  | 1BE28 |
   | such    | BE28  |
And I append rows
   | artikel | mge | preis | proz        |
   | V1      | 10  |    10 | !dontChange |
   | E1      | 100 |     5 | -10         |
And I save the current editor

# Lieferschein
Given I open an editor "LS28" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE28"
And I set fields
   | nummer | 1LS28 |
   | such   | LS28  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

# Rechnung
Given I open an editor "RE28" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS28"
And I set fields
| nummer | 1RE28 |
| such   | RE28  |
| ueb    | ja    |
| tterm  | .     |
| vom    | .     |
And I set field "mge" to "10" in row 1
And I set field "mge" to "100" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift 1
Given I open an editor "TWG28" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE28"
And I set fields
| nummer | 1TWG28 |
| such   | TWG28  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
| budat  | .      |
And I set field "mge" to "-4" in row 1
Then field "pwert" has value "-40.00" in row 1
And I set field "mge" to "-50" in row 2
Then field "proz" has value "-10" in row 2
And I save the current editor

# Ruecklieferung 1
Given I open an editor "RLS28A" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS28"
And I set fields
| nummer | 1RLS28A |
| such   | RLS28A  |
| ueb    | ja      |
| tterm  | .       |
And I set field "mge" to "-3" in row 1
And I set field "mge" to "-30" in row 2
And I save the current editor

# Kaufmaennische Gutschrift 1
Given I open an editor "KGS28A" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS28A"
And I set fields
   | nummer | 1KGS28A |
   | such   | KGS28A  |
   | ueb    | ja      |
   | vom    | .       |
   | tterm  | .       |
Then field "mge" has value "-3" in row 1
# Preis muss durch Teilwertgutschriften reduziert sein
Then field "preis" has value "6.00" in row 1
Then field "mge" has value "-30" in row 2
# Preis muss durch Teilwertgutschriften reduziert sein
Then field "preis" has value "2.50" in row 2
# Rabatte korrekt beruecksichtigt
Then field "proz" has value "-10" in row 2
Then field "pwert" has value "-67.50" in row 2
Then field "nwert" has value "-67.50" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung 2
Given I open an editor "RLS28B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS28"
And I set fields
| nummer | 1RLS28B |
| such   | RLS28B  |
| ueb    | ja      |
| tterm  | .       |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Kaufmaennische Gutschrift 2
Given I open an editor "KGS28B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS28B"
And I set fields
   | nummer | 1KGS28B |
   | such   | KGS28B  |
   | ueb    | ja      |
   | vom    | .       |
   | tterm  | .       |
Then field "mge" has value "-4" in row 1
# Preis muss durch Teilwertgutschriften reduziert sein
Then field "preis" has value "6.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK-AU-LS-RE-TWGS RLS-KGS
# TWG19
# ----------------------------------------------------------------------------------------------
#
#  LS -------------------- RE1
#  | Artikel | mge    |     | Artikel | mge   | preis |
#  | V1      | 100 St.|     | V1      | 20 St.| 15    |
#    \                  \
#     \                  \
#      \                  \
#       \                   RE2 ------------------------- WGS
#        \                  | Artikel | mge   | preis |   | Artikel | mge     | preis | pwert |
#         \                 | V1      | 80 St.| 10    |   | V1      | -40 St. | 9,5   | 380   |
#          \
#           \
#            \
#             -------------------------------------------- RLS1 ------------------ KGS1
#                                                          | Artikel | mge     |   | Artikel | mge | preis |
#                                                          | V1      | -100 St.|   | V1      | -20 | 15    |
#                                                                                  | V1      | -80 | 5,25  |
#
# Lieferschein
Given I open an editor "LS29" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1     |
   | nummer | 1LS29 |
   | such   | LS29  |
   | ueb    | ja    |
   | vom    | .     |
And I append rows
   | artikel | mge  | preis |
   | V1      | 100  |    10 |
And I save the current editor

# Rechnung 1
Given I open an editor "RE29A" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS29"
And I set fields
| nummer | 1RE29A |
| such   | RE29A  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
And I set field "mge" to "20" in row 1
And I set field "preis" to "15" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 2
Given I open an editor "RE29B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS29"
And I set fields
| nummer | 1RE29B |
| such   | RE29B  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
And I set field "mge" to "80" in row 1
And I set field "preis" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift 1
Given I open an editor "TWG29" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE29B"
And I set fields
| nummer | 1TWG29 |
| such   | TWG29  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
| budat  | .      |
And I set field "mge" to "-40" in row 1
And I set field "preis" to "9,5" in row 1
Then field "pwert" has value "-380.00" in row 1
And I save the current editor

# Ruecklieferung 1
Given I open an editor "RLS29" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS29"
And I set fields
| nummer | 1RLS29 |
| such   | RLS29  |
| ueb    | ja     |
| tterm  | .      |
| budat  | .      |
And I set field "mge" to "-100" in row 1
And I save the current editor

# Kaufmaennische Gutschrift
Given I open an editor "KGS29" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS29"
And I set fields
   | nummer | 1KGS29 |
   | such   | KGS29  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
Then field "mge" has value "-20" in row 1
Then field "preis" has value "15.00" in row 1
Then field "mge" has value "-80" in row 2
# Preis muss durch Teilwertgutschriften reduziert sein
Then field "preis" has value "5.25" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-LS-RE-TWGS RLS-KGS
# TWG34
# ----------------------------------------------------------------------------------------------
#
#  LS -------------------- RE1 ------------------------------WGS
#  | Artikel | mge    |     | Artikel | mge    | preis |      | Artikel | mge      | preis |
#  | V1      | 100 St.|     | V1      | 100 St.| 10    |      | V1      | -100 St. | 10    |
#        \
#         \
#          \
#           --------------------------------------------------- RLS1 ------------------ KGS1
#                                                               | Artikel | mge     |    | Artikel | mge  |
#                                                               | V1      | -100 St.|    | V1      | -100 |
#
#
# Lieferschein
Given I open an editor "LS30" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1     |
   | nummer | 1LS30 |
   | such   | LS30  |
   | ueb    | ja    |
   | vom    | .     |
And I append rows
   | artikel | mge  | preis |
   | V1      | 100  |    10 |
And I save the current editor

# Rechnung 1
Given I open an editor "RE30" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS30"
And I set fields
| nummer | 1RE30 |
| such   | RE30  |
| ueb    | ja    |
| tterm  | .     |
| vom    | .     |
And I set field "mge" to "100" in row 1
And I set field "preis" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift 1
Given I open an editor "TWG30" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE30"
And I set fields
| nummer | 1TWG30 |
| such   | TWG30  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
| budat  | .      |
And I set field "mge" to "-100" in row 1
And I save the current editor

# Ruecklieferung 1
Given I open an editor "RLS30" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS30"
And I set fields
| nummer | 1RLS30 |
| such   | RLS30  |
| ueb    | ja     |
| tterm  | .      |
| budat  | .      |
And I set field "mge" to "-100" in row 1
And I save the current editor

# Ruecklieferschein in Ablage
Then field "remge" from editor "RLS30" in row 1 has value "0"
Then "(Sales):(PackingSlip)" with the editor id "RLS30" is filed

# Kaufmaennische Gutschrift: nichts mehr gutzuschreiben
Given I open an editor "KGS30" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS30"
And I set fields
   | nummer | 1KGS30 |
   | such   | KGS30  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
Then field "mge" has value "0" in row 1
Then field "preis" has value "10.00" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK-LS-RE-TWGS RLS-KGS
# TWG34 mit Storno WGS
# ----------------------------------------------------------------------------------------------
#
#  LS -------------------- RE1 ----------------------------- WGS ----------------- Storno-WGS
#  | Artikel | mge   |     | Artikel | mge   | preis |      | Artikel | mge     |  | Artikel | mge      |
#  | E1      | 35 St.|     | E1      | 35 St.| 5     |      | E1      | -35 St. |  | E1      | -35 St. |
#        \
#         \
#          \
#           --------------------------------------------------------- RLS -------------------- KGS
#                                                                      | Artikel | mge    |    | Artikel | mge  |
#                                                                      | E1      | -35 St.|    | E1      | -35  |
#
#
# Lieferschein
Given I open an editor "LS31" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lief   | 1     |
   | nummer | 1LS31 |
   | such   | LS31  |
   | ueb    | ja    |
   | vom    | .     |
And I append rows
   | artikel | mge | preis |
   | E1      | 35  |     5 |
And I save the current editor

# Rechnung 1
Given I open an editor "RE31" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS31"
And I set fields
| nummer | 1RE31 |
| such   | RE31  |
| ueb    | ja    |
| tterm  | .     |
| vom    | .     |
And I set field "mge" to "35" in row 1
And I set field "preis" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift 1
Given I open an editor "WGS31" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE31"
And I set fields
| nummer | 1WGS31 |
| such   | WGS31  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
| budat  | .      |
And I set field "mge" to "-35" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS31" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS31"
And I set fields
| nummer | 1RLS31 |
| such   | RLS31  |
| ueb    | ja     |
| tterm  | .      |
And I set field "mge" to "-35" in row 1
And I save the current editor

# Ruecklieferschein in Ablage
Then field "remge" from editor "RLS31" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "RLS31" is filed

# Kaufmaennische Gutschrift nicht speichern
Given I open an editor "KGS31V" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS31"
And I set fields
   | nummer | 1KGS31 |
   | such   | KGS31  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
Then field "mge" has value "0" in row 1
Then field "preis" has value "5.00" in row 1
And I close the current editor

# Storno Wertgutschrift
Given I open an editor "ST_WGS31" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WGS31"
And I save the current editor

# Ruecklieferschein wieder lebendig
Then field "remge" from editor "RLS31" in row 1 has value "-35"
Then "(Purchasing):(PackingSlip)" with the editor id "RLS31" is not filed

# Kaufmaennische Gutschrift
Given I open an editor "KGS31" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS31"
And I set fields
   | nummer | 1KGS31 |
   | such   | KGS31  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
# Menge gutschreibbar
Then field "mge" has value "-35" in row 1
Then field "preis" has value "5.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-AU-LS-RE-TWGS RLS-KGS mit Pauschalpreis und geaenderter Einheit
# TWG18
# ----------------------------------------------------------------------------------------------

# AU -------------------- LS ------------------- RE ---------------------------- WGS
# | Artikel | mge.   |    | Artikel | mge    |    | Artikel | mge    | pwert |   | Artikel | mge     | pwert |
# | VPE     | 100 St.|    | VPE     | 100 St.|    | VPE     | 100 St.| 700   |   | VPE     | -50 St. | -350  |
#                          \
#                           \
#                            \
#                             ------------------------------------------------------- RLS ------------------- KGS       (2 Kg = 1 St.)
#                                                                                     | Artikel | mge    |    | Artikel | mge  | pwert |
#                                                                                     | VPE     | -40 kg.|    | VPE     | -40  | 70    |
#
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU32" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1     |
   | nummer  | 1AU32 |
   | such    | AU32  |
And I append rows
   | artikel | mge | preis | pwert |
   | VPE1    | 100 |     0 | 750   |
And I save the current editor

# Lieferschein
Given I open an editor "LS32" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU32"
And I set fields
   | nummer | 1LS32 |
   | such   | LS32  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE32" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS32"
And I set fields
| nummer | 1RE32 |
| such   | RE32  |
| ueb    | ja    |
| tterm  | .     |
| vom    | .     |
And I set field "mge" to "100" in row 1
And I set field "pwert" to "700" in row 1
Then field "he" has value "Stück" in row 1
Then field "pe" has value "Stück" in row 1
Then field "lehe" has value "2" in row 1
Then field "pehe" has value "1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift 1
Given I open an editor "TWG32" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE32"
And I set fields
| nummer | 1TWG32 |
| such   | TWG32  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
| budat  | .      |
And I set field "mge" to "-50" in row 1
And I set field "pwert" to "-350.00" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS32" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS32"
And I set fields
| nummer | 1RLS32 |
| such   | RLS32  |
| ueb    | ja     |
| tterm  | .      |
And I set field "he" to "kg" in row 1
# Hier kommt der Hinweis 2892: Bitte Faktor der Preiseinheit pruefen.
# Umrechnungsfaktor eintragen, da er nicht angepasst worden ist.
And I set field "pehe" to "0,5" in row 1
Then field "he" has value "kg" in row 1
Then field "pe" has value "Stück" in row 1
Then field "lehe" has value "1" in row 1
Then field "pehe" has value "0.5" in row 1
And I set field "mge" to "-40" in row 1
And I save the current editor

# Kaufmaennische Gutschrift
Given I open an editor "KGS32" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS32"
And I set fields
   | nummer | 1KGS32 |
   | such   | KGS32  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
Then field "mge" has value "-40" in row 1
# Preis muss durch Teilwertgutschriften reduziert sein
Then field "preis" has value "3.50" in row 1
Then field "pwert" has value "-70.00" in row 1
Then field "he" has value "kg" in row 1
Then field "pe" has value "Stück" in row 1
Then field "lehe" has value "1" in row 1
Then field "pehe" has value "0.5" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-AU-LS-RE-TWGS RLS-KGS
# RLS nach TWGS Gesamtrabatte
# ----------------------------------------------------------------------------------------------

# AU ------------------- LS ------------------- RE -------------------- WGS1
# | Artikel | mge.  |    | Artikel | mge   |    | Artikel | mge   |     | Artikel | mge     | preis | pwert |
# | V1      | 50 St.|    | V1      | 50 St.|    | V1      | 50 St.|     | V1      | -20 St. | 10    | 200   |
#                          \
#                           \
#                            ---------------------------------------------- RLS ------------------ KGS1
#                                                                           | Artikel | mge    |    | Artikel | mge  | preis |
#                                                                           | V1      | -25 St.|    | V1      | -25  | 5     |
#
#
# Auftrag
Given I open an editor "AU33" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1     |
   | nummer  | 1AU33 |
   | such    | AU33  |
And I append rows
   | artikel | mge         | preis       | proz        |
   | V1      | 50          | 10          | !dontChange |
   | 4       | !dontChange | !dontChange | -20         |
And I save the current editor

# Lieferschein
Given I open an editor "LS33" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU33"
And I set fields
   | nummer | 1LS33 |
   | such   | LS33  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE33" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS33"
And I set fields
| nummer | 1RE33 |
| such   | RE33  |
| ueb    | ja    |
| tterm  | .     |
| vom    | .     |
And I set field "mge" to "50" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "TWG33" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE33"
And I set fields
| nummer | 1TWG33 |
| such   | TWG33  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
| budat  | .      |
And I set field "mge" to "-20" in row 1
Then field "pwert" has value "-200.00" in row 1
Then field "nwert" has value "-160.00" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS33" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS33"
And I set fields
| nummer | 1RLS33 |
| such   | RLS33  |
| ueb    | ja     |
| tterm  | .      |
And I set field "mge" to "-25" in row 1
And I save the current editor

# Kaufmaennische Gutschrift
Given I open an editor "KGS33" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS33"
And I set fields
   | nummer | 1KGS33 |
   | such   | KGS33  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
Then field "mge" has value "-25" in row 1
# Preis muss durch Teilwertgutschriften reduziert sein
Then field "preis" has value "6.00" in row 1
Then field "pwert" has value "-150.00" in row 1
Then field "nwert" has value "-120.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK-REmitLG-TWGS RLS-KGS
# ----------------------------------------------------------------------------------------------
#
#  RE ------------------------------WGS
#   | Artikel | mge    | preis |     | Artikel | mge      | preis |
#   | E1      | 200 St.| 5     |     | E1      | -200 St. | 10    |
#        \
#         \
#          \
#           --------------------------------------------------- RLS1 ------------------ keine KGS1
#                                                               | Artikel | mge     |
#                                                               | E1      | -100 St.|
#
#

# Rechnung mit Lagerbewegung
Given I open an editor "RE34" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | lief   | 1     |
   | nummer | 1RE34 |
   | such   | RE34  |
   | ueb    | ja    |
   | tterm  | .     |
   | vom    | .     |
And I append rows
   | artikel | mge  | preis |
   | V1      | 200  |     5 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "TWG34" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE34"
And I set fields
| nummer | 1TWG34 |
| such   | TWG34  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
| budat  | .      |
And I set field "mge" to "-200" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS34" from table "(Purchasing):(Invoice)" with command "RETURN" for record from editor "RE34"
And I set fields
| nummer | 1RLS34 |
| such   | RLS34  |
| ueb    | ja     |
| tterm  | .      |
And I set field "mge" to "-100" in row 1
And I save the current editor

# Ruecklieferschein in Ablage und remge = 0
Then field "remge" from editor "RLS34" in row 1 has value "0"
Then "(Purchasing):(PackingSlip)" with the editor id "RLS34" is filed

# Kaufmaennische Gutschrift: nichts mehr gutzuschreiben
Given I open an editor "KGS34" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS34"
And I set fields
   | nummer | 1KGS34 |
   | such   | KGS34  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
Then field "mge" has value "0" in row 1
Then field "preis" has value "5.00" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK-BE-LS-RE-TWGS RLS-KGS Waehrungswechsel
# TWG18 mit Waehrungswechsel
# ----------------------------------------------------------------------------------------------

# BE ------------------- LS ------------------- RE ------------------- WGS
# | Artikel | mge.  |    | Artikel | mge   |    | Artikel | mge   |    | Artikel | mge    | preis | pwert |
# | E1      | 20 St.|    | E1      | 20 St.|    | V1      | 20 St.|    | E1      | -5 St. | 5     | 25    |
#                          \
#                           \
#                            \
#                             ------------------------------------------ RLS ------------------- KGS
#                                                                        | Artikel | mge    |    | Artikel | mge  | preis |
#                                                                        | E1      | -12 St.|    | E1      | -12  | 6     |
#
#
# Bestellung
Given I open an editor "BE35" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | 1     |
   | nummer  | 1BE35 |
   | such    | BE35  |
And I append rows
   | artikel | mge | preis |
   | E1      | 20  |    10 |
And I save the current editor

# Lieferschein
Given I open an editor "LS35" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE35"
And I set fields
   | nummer | 1LS35 |
   | such   | LS35  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Waehrungskurs Dollor auf 1,5 setzen
Given I open an editor "waehrung" from table "(ExchangeRate):(ExchangeRate)" with command "NEW" for record ""
And I set field "fwaehr" to "USD"
And I set field "ikurs" to "2.0"
And I save the current editor

# Rechnung in anderer Waehrung
Given I open an editor "RE35" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS35"
And I set fields
| nummer    | 1RE35 |
| such      | RE35  |
| ueb       | ja    |
| tterm     | .     |
| vom       | .     |
| erfwaehr  | USD   |
And I set field "mge" to "20" in row 1
Then field "preis" has value "5.00" in row 1
Then field "pwert" has value "100.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "TWG35" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE35"
And I set fields
| nummer | 1TWG35 |
| such   | TWG35  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
| budat  | .      |
And I set field "mge" to "-5" in row 1
Then field "pwert" has value "-25.00" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS35" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS35"
And I set fields
| nummer | 1RLS35 |
| such   | RLS35  |
| ueb    | ja     |
| tterm  | .      |
And I set field "mge" to "-12" in row 1
And I save the current editor

# Kaufmaennische Gutschrift
Given I open an editor "KGS35" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS35"
And I set fields
   | nummer | 1KGS35 |
   | such   | KGS35  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
Then field "erfwaehr" has value "DEM"
Then field "mge" has value "-12" in row 1
# Preis muss durch Teilwertgutschriften reduziert und in DM sein
Then field "preis" has value "7.50" in row 1
Then field "pwert" has value "-90.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-REmitLG-WGS-REKO-RLS-STREKO-(KGS)
# ----------------------------------------------------------------------------------------------
#
#  RE ----------------------------WGS
#  | Artikel | mge   | preis |    | Artikel | mge      | preis |
#  | V1      | 65 St.| 15    |    | V1      | -65 St.  | 15    |
#     \
#      \
#       \
#        ------------------------------- REKO -------------------------Storno REKO
#        \                               | Artikel | mge   | preis |
#         \                              | V1      | 65 St.| 12    |
#          \
#           \
#            \
#             --------------------------------- RLS1 -------------------------- keine KGS1
#                                               | Artikel | mge     |
#                                               | V1      | -10 St. |
#

# Rechnung mit Lagerbewegung
Given I open an editor "RE36" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | kunde  | 1     |
   | nummer | 1RE36 |
   | such   | RE36  |
   | ueb    | ja    |
   | tterm  | .     |
   | vom    | .     |
And I append rows
   | artikel | mge  | preis |
   | V1      | 65   |    15 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "TWG36" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE36"
And I set fields
| nummer | 1TWG36 |
| such   | TWG36  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
| budat  | .      |
And I set field "mge" to "-65" in row 1
And I save the current editor

# Rechnungskorrektur
Given I open an editor "REK36" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE36"
And I set fields
   | nummer | 1REK36 |
   | such   | REK36  |
   | ueb    | ja     |
   | tterm  | .      |
And I press button "burekorrektur"
Then field "rekorrektur" has value "ja" in row 1
And I set field "mge" to "65" in row 1
And I set field "preis" to "12" in row 1
# And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS36" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "RE36"
And I set fields
| nummer | 1RLS36 |
| such   | RLS36  |
| ueb    | ja     |
| tterm  | .      |
| budat  | .      |
And I set field "mge" to "-10" in row 1
And I save the current editor

# Ruecklieferschein lebendig, offene Rechnungsmenge vorhanden
Then field "remge" from editor "RLS36" in row 1 has value "-10"
Then "(Sales):(PackingSlip)" with the editor id "RLS36" is not filed

# Storno Rechnungskorrektur
Given I open an editor "ST_REKO26" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "REK36"
And I save the current editor

# Storno-REKO hat Einfluss auf die remge in der RE und im RLS
Then field "remge" from editor "RE36" in row 1 has value "65"
Then field "remge" from editor "RLS36" in row 1 has value "0"
Then "(Sales):(PackingSlip)" with the editor id "RLS36" is filed

# Kaufmaennische Gutschrift: nichts mehr gutzuschreiben
Given I open an editor "KGS36" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS36"
And I set fields
   | nummer | 1KGS36 |
   | such   | KGS36  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
Then field "mge" has value "0" in row 1
Then field "preis" has value "15.00" in row 1
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK-AU-LS-RE1+RE2+RE3 -RLS - WGS Verschiedene Positionstypen
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU37" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
| kunde  | 1    |
| such   | AU37 |
And I append rows
| artikel  | mge         | preis       | pwert       |
| V1       | 90          | 15          | !dontChange |
| AUBEPOS2 | 60          | 10          | !dontChange |
| TEXT     | !dontChange | !dontChange |  90         |
| NEUPOS   | !dontChange | !dontChange | 210         |
| DL-REP   | 5           | 75          | !dontChange |
And I save the current editor

# Lieferschein
Given I open an editor "LS37" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU37"
And I set fields
   | nummer | 1LS37 |
   | such   | LS37  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I press button "offueb" in row 4
And I press button "offueb" in row 5
And I save the current editor

# Rechnung A
Given I open an editor "RE37A" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS37"
And I set fields
| nummer | 1RE37A |
| such   | RE37A  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
And I set field "mge" to "10" in row 1
And I set field "mge" to "15" in row 2
And I set field "pwert" to "15" in row 3
And I set field "pwert" to "15" in row 4
And I set field "mge" to "1" in row 5
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung B
Given I open an editor "RE37B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS37"
And I set fields
| nummer | 1RE37B |
| such   | RE37B  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
And I set field "mge" to "30" in row 1
And I set field "mge" to "15" in row 2
And I set field "pwert" to "25" in row 3
And I set field "pwert" to "45" in row 4
And I set field "mge" to "1" in row 5
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung C
Given I open an editor "RE37C" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS37"
And I set fields
| nummer | 1RE37C |
| such   | RE37C  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
And I set field "mge" to "50" in row 1
And I set field "mge" to "30" in row 2
And I set field "pwert" to "50" in row 3
And I set field "pwert" to "150" in row 4
And I set field "mge" to "3" in row 5
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil-Ruecklieferung
Given I open an editor "RLS37" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS37"
And I set fields
| nummer | 1RLS37 |
| such   | RLS37  |
| ueb    | ja     |
| tterm  | .      |
| budat  | .      |
And I set field "mge" to "-65" in row 1
And I set field "he" to "Stück" in row 2
Then field "lehe" has value "1" in row 2
And I set field "mge" to "-100" in row 2
And I set field "pwert" to "-80" in row 3
And I set field "pwert" to "-200" in row 4
And I set field "mge" to "-3" in row 5
And I save the current editor

# RLS hat Einfluss auf die remge in den Rechnungen
Given I open an editor "RE37CV" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE37C"
Then table has values
   | artikel  | remge |  ofwert|
   | V1       |     0 |  0.00  |
   | AUBEPOS2 |     0 |  0.00  |
   | TEXT     |     0 |  0.00  |
   | NEUPOS   |     0 |  0.00  |
   | DL-REP   |     0 |  0.00  |
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift_rls.out"
Then I append text "RE37C nach vorherigem Teil-RLS" to output file "cucumber/refs/wertgutschrift_rls.out"
And I close the current editor

Given I open an editor "RE37BV" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE37B"
Then table has values
   | artikel  | remge |  ofwert |
   | V1       |   -15 | -225.00 |
   | AUBEPOS2 |     0 |    0.00 |
   | TEXT     |     0 |    0.00 |
   | NEUPOS   |     0 |    0.00 |
   | DL-REP   |    -1 |  -75.00 |
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift_rls.out"
Then I append text "RE37B nach vorherigem Teil-RLS" to output file "cucumber/refs/wertgutschrift_rls.out"
And I close the current editor

Given I open an editor "RE37AV" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE37A"
Then table has values
   | artikel  | remge |  ofwert |
   | V1       |   -10 | -150.00 |
   | AUBEPOS2 |   -10 | -100.00 |
   | TEXT     |   -10 |  -10.00 |
   | NEUPOS   |   -10 |  -10.00 |
   | DL-REP   |    -1 |  -75.00 |
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift_rls.out"
Then I append text "RE37A nach vorherigem Teil-RLS" to output file "cucumber/refs/wertgutschrift_rls.out"
And I close the current editor

# Wertgutschrift nicht speichern
# Beruecksichtigung der Ruecklieferung beim Komplettieren
Given I open an editor "WG37A" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE37A"
And I set fields
| such   | WGS18 |
| ueb    | ja    |
| tterm  | .     |
| vom    | .     |
| budat  | .     |
And I press button "komplettieren"
Then field "komplettgutschrift" has value "ja" in row 1
Then field "komplettgutschrift" has value "nein" in row 2
Then field "komplettgutschrift" has value "nein" in row 3
Then field "komplettgutschrift" has value "nein" in row 4
Then field "komplettgutschrift" has value "ja" in row 5
Then field "mge" has value "-10" in row 1
Then field "mge" has value "-10" in row 2
Then field "pwert" has value "-10.00" in row 3
Then field "pwert" has value "-10.00" in row 4
Then field "mge" has value "-1" in row 5
And I close the current editor

# Storno Ruecklieferung
Given I open an editor "ST_RLS37" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS37"
And I save the current editor

# RLS hat Einfluss auf die remge in den Rechnungen
Given I open an editor "RE37CV" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE37C"
Then table has values
   | artikel  | remge |  ofwert |
   | V1       |   -50 | -750.00 |
   | AUBEPOS2 |   -30 | -300.00 |
   | TEXT     |   -50 |  -50.00 |
   | NEUPOS   |  -150 | -150.00 |
   | DL-REP   |    -3 | -225.00 |
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift_rls.out"
Then I append text "RE37C nach vorherigem Storno eines Teil-RLS" to output file "cucumber/refs/wertgutschrift_rls.out"
And I close the current editor

Given I open an editor "RE37BV" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE37B"
Then table has values
   | artikel  | remge |  ofwert |
   | V1       |   -30 | -450.00 |
   | AUBEPOS2 |   -15 | -150.00 |
   | TEXT     |   -25 |  -25.00 |
   | NEUPOS   |   -45 |  -45.00 |
   | DL-REP   |    -1 |  -75.00 |
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift_rls.out"
Then I append text "RE37B nach vorherigem Storno eines Teil-RLS" to output file "cucumber/refs/wertgutschrift_rls.out"
And I close the current editor

Given I open an editor "RE37AV" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "RE37A"
Then table has values
   | artikel  | remge |  ofwert |
   | V1       |   -10 | -150.00 |
   | AUBEPOS2 |   -15 | -150.00 |
   | TEXT     |   -15 |  -15.00 |
   | NEUPOS   |   -15 |  -15.00 |
   | DL-REP   |    -1 |  -75.00 |
Then I fill template "EV_VORG_MENGEN.ftl" and append it to output file "wertgutschrift_rls.out"
Then I append text "RE37A nach vorherigem Storno eines Teil-RLS" to output file "cucumber/refs/wertgutschrift_rls.out"
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - RE mit LB - TWG1 - RLS - Storno RLS erlaubt
# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "1RE38" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | kunde  | 1     |
   | nummer | 1RE38 |
   | such   | RE38  |
   | ueb    | ja    |
   | tterm  | .     |
   | fakt   | ja    |
And I append rows
   | artikel | mge | preis |
   | V1      | 15  | 38    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift, ungebucht
Given I open an editor "WG38" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE38"
And I set fields
   | nummer | 1WG38 |
   | such   | WG38  |
   | ueb    | ja    |
   | tterm  | .     |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS38" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "1RE38"
And I set fields
   | nummer | 1RLS38 |
   | such   | RLS38  |
   | ueb    | ja     |
   | tterm  | .      |
   | budat  | .      |
And I press button "offueb" in row 1
And I save the current editor

# Storno Ruecklieferung
Given I open an editor "ST_RLS38" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS38"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK - RE mit LB - RLS - TWG1 - Storno RLS nicht erlaubt, wegen Reihenfolge
# ----------------------------------------------------------------------------------------------

# Rechnung
Given I open an editor "1RE39" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | kunde  | 1     |
   | nummer | 1RE39 |
   | such   | RE39  |
   | ueb    | ja    |
   | tterm  | .     |
   | fakt   | ja    |
And I append rows
   | artikel | mge | preis |
   | V1      | 15  | 39    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS39" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "1RE39"
And I set fields
   | nummer | 1RLS39 |
   | such   | RLS39  |
   | ueb    | ja     |
   | tterm  | .      |
   | budat  | .      |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Teilwertgutschrift, ungebucht
Given I open an editor "WG39" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE39"
And I set fields
   | nummer | 1WG39 |
   | such   | WG39  |
   | ueb    | ja    |
   | tterm  | .     |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Storno Ruecklieferung nicht erlaubt
# Ruecklieferschein kann wegen der kaufmaennischen Gutschrift "1WG39 - WG39" nicht storniert werden.
# Zuerst muessen die Gutschriften storniert werden.
Then opening an editor from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS39" throws the exception "3335"

# ----------------------------------------------------------------------------------------------
Scenario: VK-AU-LS-RE- RLS -WGS Artikel- und Dienstleistungsposition
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "AU40" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
| kunde  | 1    |
| such   | AU40 |
And I append rows
| artikel  | mge | preis |
| V1       | 10  | 10    |
| DL-ANA   | 10  | 10    |
And I save the current editor

# Lieferschein
Given I open an editor "LS40" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU40"
And I set fields
   | nummer | 1LS40 |
   | such   | LS40  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

# Rechnung
Given I open an editor "RE40" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS40"
And I set fields
| nummer | 1RE40 |
| such   | RE40  |
| ueb    | ja    |
| tterm  | .     |
| vom    | .     |
And I set field "mge" to "10" in row 1
And I set field "mge" to "10" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teil-Ruecklieferung
Given I open an editor "RLS40" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS40"
And I set fields
| nummer | 1RLS40 |
| such   | RLS40  |
| ueb    | ja     |
| tterm  | .      |
| budat  | .      |
And I set field "mge" to "-5" in row 1
And I set field "mge" to "-5" in row 2
And I save the current editor

# Wertgutschrift
Given I open an editor "WG40" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE40"
And I set fields
| nummer | 1WGS40 |
| such   | WGS40  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
| budat  | .      |
And I press button "komplettieren"
Then field "komplettgutschrift" has value "nein" in row 1
Then field "komplettgutschrift" has value "nein" in row 2
Then field "mge" has value "-5" in row 1
Then field "mge" has value "-5" in row 2
And I save the current editor

# 2. Wertgutschrift: nichts gutzuschreiben
Given I open an editor "WG40V" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE40"
And I set fields
| such   | WGS40V |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
| budat  | .      |
Then the table has 5 rows
And I press button "komplettieren"
Then field "mge" has value "0" in row 1
Then field "mge" has value "0" in row 2
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK-BE-LS-RE-TWGS RLS-KGS
# TWG22
# ----------------------------------------------------------------------------------------------

# BE ------------------- LS ------------------- RE -------------------------- WGS
# | Artikel | mge.   |   | Artikel | mge    |   | Artikel | mge    | preis|    | Artikel | mge     | preis | pwert |
# | E1      | 100 St.|   | E1      | 100 St.|   | E1      | 100 St.| 9,25 |    | E1      | -20 St. | 2     | 40    |
#                          \
#                           \
#                            \
#                             ------------------------ RLS -------------------- KGS
#                              \                        | Artikel | mge    |      | Artikel | mge     | preis | pwert |
#                               \                       | E1      | -20 St.|      | E1      | -20 St. | 9,25  | 185   |
#                                \
#                                 \
#                                  \
#                                   ---------------------------------------------- RLS -------------------- KGS
#                                                                                  | Artikel | mge    |      | Artikel | mge     | preis | pwert |
#                                                                                  | E1      | -20 St.|      | E1      | -20 St. | 8,75  | 350   |
#
#
# Bestellung
Given I open an editor "BE41" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | 1     |
   | nummer  | 1BE41 |
   | such    | BE41  |
And I append rows
   | artikel | mge  | preis |
   | E1      | 100  |  9,25 |
And I save the current editor

# Lieferschein
Given I open an editor "LS41" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE41"
And I set fields
   | nummer | 1LS41 |
   | such   | LS41  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE41" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS41"
And I set fields
| nummer    | 1RE41 |
| such      | RE41  |
| ueb       | ja    |
| tterm     | .     |
| vom       | .     |
And I set field "mge" to "100" in row 1
Then field "preis" has value "9.25" in row 1
Then field "pwert" has value "925.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS41A" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS41"
And I set fields
| nummer | 1RLS41A |
| such   | RLS41A  |
| ueb    | ja      |
| tterm  | .       |
And I set field "mge" to "-20" in row 1
And I save the current editor

# Wertgutschrift
Given I open an editor "TWG41" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE41"
And I set fields
| nummer | 1TWG41 |
| such   | TWG41  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
| budat  | .      |
And I set field "mge" to "-20" in row 1
And I set field "preis" to "2,00" in row 1
Then field "pwert" has value "-40.00" in row 1
And I save the current editor

# Kaufmaennische Gutschrift
Given I open an editor "KGS41A" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS41A"
And I set fields
   | nummer | 1KGS41A |
   | such   | KGS41A  |
   | ueb    | ja      |
   | vom    | .       |
   | tterm  | .       |
Then field "mge" has value "-20" in row 1
# Preis muss durch Teilwertgutschriften reduziert sein
Then field "preis" has value "9.25" in row 1
Then field "pwert" has value "-185.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS41B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS41"
And I set fields
| nummer | 1RLS41B |
| such   | RLS41B  |
| ueb    | ja      |
| tterm  | .       |
And I set field "mge" to "-20" in row 1
And I save the current editor

# Kaufmaennische Gutschrift
Given I open an editor "KGS41B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS41B"
And I set fields
   | nummer | 1KGS41B |
   | such   | KGS41B  |
   | ueb    | ja      |
   | vom    | .       |
   | tterm  | .       |
Then field "mge" has value "-20" in row 1
# Preis muss durch Teilwertgutschrift und kaufm. Gutschrift reduziert
Then field "preis" has value "8.75" in row 1
Then field "pwert" has value "-175.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: VK-AU-LS-RE-TWGS RLS-KGS -TWGS RLS-KGS
# ----------------------------------------------------------------------------------------------

# AU ------------------- LS ------------------- RE ----------------------------------- WGS B
# | Artikel | mge.   |   | Artikel | mge    |   | Artikel | mge   | preis|             | Artikel | mge     | preis | pwert |
# | V1      | 100 St.|   | V1      | 100 St.|   | V1      | 20 St.| 10   |             | V1      | -50 St. | 4     | 200   |
#                          \                     \
#                           \                      WGS A
#                            \                     | Artikel | mge      | preis | pwert |
#                             \                    | V1      | -100 St. | 1     | 40    |
#                              \
#                               ------------------------ - RLS A ------------------ KGSA
#                                \                        | Artikel | mge    |      | Artikel | mge     | preis | pwert |
#                                 \                       | V1      | -20 St.|      | V1      | -20 St. | 9,00  | 100   |
#                                  \
#                                   \
#                                    \
#                                      ------------------------------------------------- RLS B ------------------- KGSB
#                                                                                        | Artikel | mge    |      | Artikel | mge     | preis | pwert |
#                                                                                        | V1      | -15 St.|      | V1      | -15 St. | 6,50  | 97,50 |
#
#
# Auftrag
Given I open an editor "AU42" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde   | 1     |
   | nummer  | 1AU42 |
   | such    | AU42  |
And I append rows
   | artikel | mge  | preis |
   | V1      | 100  |    10 |
And I save the current editor

# Lieferschein
Given I open an editor "LS42" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU42"
And I set fields
   | nummer | 1LS42 |
   | such   | LS42  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE42" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS42"
And I set fields
| nummer    | 1RE42 |
| such      | RE42  |
| ueb       | ja    |
| tterm     | .     |
| vom       | .     |
And I set field "mge" to "100" in row 1
Then field "preis" has value "10.00" in row 1
Then field "pwert" has value "1000.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "TWG42A" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE42"
And I set fields
| nummer | 1TWG42A  |
| such   | TWG42A  |
| ueb    | ja      |
| tterm  | .       |
| vom    | .       |
| budat  | .       |
And I set field "mge" to "-100" in row 1
And I set field "preis" to "1,00" in row 1
Then field "pwert" has value "-100.00" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS42A" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS42"
And I set fields
| nummer | 1RLS42A |
| such   | RLS42A  |
| ueb    | ja      |
| tterm  | .       |
| budat  | .       |
And I set field "mge" to "-20" in row 1
And I save the current editor

# Kaufmaennische Gutschrift
Given I open an editor "KGS42A" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS42A"
And I set fields
   | nummer | 1KGS42A |
   | such   | KGS42A  |
   | ueb    | ja      |
   | vom    | .       |
   | tterm  | .       |
Then field "mge" has value "-20" in row 1
# Preis muss durch Teilwertgutschriften reduziert sein
Then field "preis" has value "9.00" in row 1
Then field "pwert" has value "-180.00" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "TWG42B" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE42"
And I set fields
| nummer | 1TWG42B |
| such   | TWG42B  |
| ueb    | ja      |
| tterm  | .       |
| vom    | .       |
| budat  | .       |
And I set field "mge" to "-50" in row 1
And I set field "preis" to "4,00" in row 1
Then field "pwert" has value "-200.00" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS42B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS42"
And I set fields
| nummer | 1RLS42B |
| such   | RLS42B  |
| ueb    | ja      |
| tterm  | .       |
| budat  | .       |
And I set field "mge" to "-15" in row 1
And I save the current editor

# Kaufmaennische Gutschrift
Given I open an editor "KGS42B" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "RLS42B"
And I set fields
   | nummer | 1KGS42B |
   | such   | KGS42B  |
   | ueb    | ja      |
   | vom    | .       |
   | tterm  | .       |
Then field "mge" has value "-15" in row 1
# Preis muss durch Teilwertgutschrift und kaufm. Gutschrift reduziert
Then field "preis" has value "6.50" in row 1
Then field "pwert" has value "-97.50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK BE-LS-RE-WGS-RLS_ungebucht-REKO-RLS_buchen-KGS.
# ----------------------------------------------------------------------------------------------

# Bestellung
Given I open an editor "1BE43" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1BE43 |
   | lief    | 1     |
   | such    | BE43  |
And I append rows
   | artikel | mge | preis |
   | E1      |  20 |     4 |
   | E1      |  10 |     4 |
And I save the current editor

# Lieferschein
Given I open an editor "1LS43" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE43"
And I set fields
   | nummer | 1LS43 |
   | such   | LS43  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

# Rechnung
Given I open an editor "1RE43" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS43"
And I set fields
   | nummer | 1RE43 |
   | such   | RE43  |
   | ueb    | ja    |
   | vom    | .     |
And I set field "mge" to "20" in row 1
And I set field "mge" to "10" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift fuer die 1. Position
Given I open an editor "1WGS43" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "1RE43"
And I set fields
| nummer | 1WGS43 |
| such   | WGS43  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
| budat  | .      |
And I set field "mge" to "-20" in row 1
And I delete row at position 2
And I save the current editor

# Ruecklieferung
Given I open an editor "1RLS43" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "1LS43"
And I set fields
   | such   | RLS43 |
   | ueb    | nein  |
   | tterm  | .     |
And I set field "mge" to "-10" in row 1
And I set field "mge" to "-5" in row 2
And I save the current editor

# Rechnungskorrektur moeglich
Given I open an editor "1RK43" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1LS43"
And I set fields
   | nummer | 1RK43 |
   | such   | RK43  |
   | ueb    | ja    |
   | vom    | .     |
And I set field "preis" to "4,5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift bei ungebuchten RLS nicht moeglich.
# "Wertgutschrift erstellen nicht moeglich, es gibt noch ungebuchte Ruecklieferscheine."
Then opening an editor from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+1RE43" throws the exception "6823"

# Ruecklieferung buchen
Given I open an editor "1RLS43" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "1RLS43"
And I set fields
   | ueb    |   ja  |
And I save the current editor

# Kaufmaennische Gutschrift
Given I open an editor "1KGS43" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "1RLS43"
And I set fields
   | nummer | 1KGS43 |
   | such   | KGS43  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
Then field "mge" has value "-10" in row 1
# Preis aus Rechnungskorrektur
Then field "preis" has value "4.50" in row 1
Then field "mge" has value "-5" in row 2
# Preis aus Rechnung
Then field "preis" has value "4.00" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK BE-LS-RE-WGS-RLS_ungebucht-REKO-RLS_buchen-KGS
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU44" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU44 |
   | kunde   | 1     |
   | such    | AU44  |
And I append rows
   | artikel | mge | preis |
   | V1      |  10 |    25 |
   | V1      |  20 |    25 |
And I save the current editor

# Lieferschein
Given I open an editor "1LS44" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU44"
And I set fields
   | nummer | 1LS44 |
   | such   | LS44  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

# Rechnung
Given I open an editor "1RE44" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS44"
And I set fields
   | nummer | 1RE44 |
   | such   | RE44  |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettwertgutschrift fuer die 2. Position
Given I open an editor "1WG44" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE44"
And I set fields
   | nummer | 1WG44 |
   | such   | WG44  |
   | ueb    | ja    |
   | tterm  | .     |
And I press button "offueb" in row 2
And I save the current editor

# Ruecklieferung
Given I open an editor "1RLS44" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS44"
And I set fields
   | nummer | 1RLS44 |
   | such   | RLS44  |
   | ueb    | nein   |
   | tterm  | .      |
   | budat  | .      |
And I set field "mge" to "-5" in row 1
And I set field "mge" to "-12" in row 2
And I save the current editor

# Wertgutschrift bei ungebuchten RLS nicht moeglich.
# "Wertgutschrift erstellen nicht moeglich, es gibt noch ungebuchte Ruecklieferscheine."
Then opening an editor from table "(Sales):(Invoice)" with command "INVOICE" for record "+1RE44" throws the exception "6823"

# Rechnungskorrektur moeglich
Given I open an editor "1RK44" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS44"
And I set fields
   | nummer | 1RK44 |
   | such   | RK44  |
   | ueb    | ja    |
   | tterm  | .     |
And I set field "preis" to "24" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung buchen
Given I open an editor "1RLS44" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "1RLS44"
And I set fields
   | ueb    |   ja  |
And I save the current editor

# KGS
Given I open an editor "1KGS44" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "1RLS44"
And I set fields
   | nummer | 1KGS44 |
   | such   | KGS44  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
Then field "mge" has value "-5" in row 1
# Preis aus Rechnung
Then field "preis" has value "25.00" in row 1
Then field "mge" has value "-12" in row 2
# Preis aus Rechnungskorrektur
Then field "preis" has value "24.00" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: EK-BE-LS-RE1-RE2 TWGS1+TWGS2 RLS-KGS
# ----------------------------------------------------------------------------------------------

# BE ------------------- LS ------------------- RE1 -------------------------- TWGS1
# | Artikel | mge.  |   | Artikel | mge   |   | Artikel | mge  | preis|    | Artikel | mge    | preis | pwert |
# | E1      | 10 St.|   | E1      | 10 St.|   | E1      | 6 St.| 11   |    | E1      | -2 St. | 5,5   | 11    |
#                       \                                            \
#                        ---------------------- RE2                   \
#                         \                     | Art. | mge  | preis| \
#                          \                    | E1   | 4 St.| 12   |  \
#                           \                                            \
#                            \                                            \
#                             \                                            TWGS2
#                              \                                           | Artikel | mge    | preis | pwert |
#                               \                                          | E1      | -5 St. | 11    | 55    |
#                                \
#                                 \
#                                  \
#                                   ---------------------------------------------- RLS -------------------- KGS
#                                                                                  | Artikel | mge   |      | Artikel | mge    | preis | pwert |
#                                                                                  | E1      | -9 St.|      | E1      | -6 St. | 0     |   0   |
#                                                                                                           | E1      | -3 St. | 12    | -36   |
#
# Bestellung
Given I open an editor "BE45" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | 1     |
   | nummer  | 1BE45 |
   | such    | BE45  |
And I append rows
   | artikel | mge  | preis |
   | E1      | 10   |    10 |
And I save the current editor

# Lieferschein
Given I open an editor "LS45" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE45"
And I set fields
   | nummer | 1LS45 |
   | such   | LS45  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Teilrechnung A
Given I open an editor "RE45A" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS45"
And I set fields
| nummer    | 1RE45A |
| such      | RE45A  |
| ueb       | ja     |
| tterm     | .      |
| vom       | .      |
And I set field "mge" to "6" in row 1
And I set field "preis" to "11" in row 1
Then field "pwert" has value "66.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilrechnung B
Given I open an editor "RE45B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS45"
And I set fields
| nummer    | 1RE45B |
| such      | RE45B  |
| ueb       | ja     |
| tterm     | .      |
| vom       | .      |
And I set field "mge" to "4" in row 1
And I set field "preis" to "12" in row 1
Then field "pwert" has value "48.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Teilwertgutschrift A
Given I open an editor "TWG45A" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE45A"
And I set fields
| nummer | 1TWG45A |
| such   | TWG45A  |
| ueb    | ja      |
| tterm  | .       |
| vom    | .       |
| budat  | .       |
And I set field "mge" to "-2" in row 1
And I set field "preis" to "5,50" in row 1
Then field "pwert" has value "-11.00" in row 1
And I save the current editor

# Teilwertgutschrift B
Given I open an editor "TWG45B" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE45A"
And I set fields
| nummer | 1TWG45B |
| such   | TWG45B  |
| ueb    | ja      |
| tterm  | .       |
| vom    | .       |
| budat  | .       |
And I set field "mge" to "-5" in row 1
And I set field "preis" to "11,00" in row 1
Then field "pwert" has value "-55.00" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS45" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS45"
And I set fields
| nummer | 1RLS45 |
| such   | RLS45  |
| ueb    | ja     |
| tterm  | .      |
And I set field "mge" to "-9" in row 1
And I save the current editor

# Kaufmaennische Gutschrift
Given I open an editor "KGS45" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS45"
And I set fields
   | nummer | 1KGS45 |
   | such   | KGS45  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
Then field "mge" has value "-6" in row 1
# Preis ist 0, da durch 2 Teilwertgutschriften alles gutgeschrieben ist.
Then field "preis" has value "0.00" in row 1
Then field "pwert" has value "0.00" in row 1
Then field "mge" has value "-3" in row 2
Then field "preis" has value "12.00" in row 2
Then field "pwert" has value "-36.00" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: EK-BE-LS-RE-TWGS RLS-SRLS
# ----------------------------------------------------------------------------------------------

# BE ------------------- LS ------------------- RE ------------------ WGS
# | Artikel | mge.  |   | Artikel | mge   |   | Artikel | mge  |    | Artikel | mge    |
# | E1      | 10 St.|   | E1      | 10 St.|   | E1      | 8 St.|    | E1      | -2 St. |
#                          \
#                           \
#                            \
#                             --------------------------------------------- RLS ----------------- SRLS
#                                                                         | Artikel | mge   |   | Artikel | mge     |
#                                                                         | E1      | -6 St.|   | E1      |   6 St. |
#
# Bestellung
Given I open an editor "BE46" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | 1     |
   | nummer  | 1BE46 |
   | such    | BE46  |
And I append rows
   | artikel | mge | preis |
   | E1      | 10  |  5,50 |
And I save the current editor

# Lieferschein
Given I open an editor "LS46" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE46"
And I set fields
   | nummer | 1LS46 |
   | such   | LS46  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "RE46" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS46"
And I set fields
| nummer    | 1RE46 |
| such      | RE46  |
| ueb       | ja    |
| tterm     | .     |
| vom       | .     |
And I set field "mge" to "8" in row 1
Then field "preis" has value "5.50" in row 1
Then field "pwert" has value "44.00" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Wertgutschrift
Given I open an editor "TWG46" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE46"
And I set fields
| nummer | 1TWG46 |
| such   | TWG46  |
| ueb    | ja     |
| tterm  | .      |
| vom    | .      |
| budat  | .      |
And I set field "mge" to "-2" in row 1
Then field "pwert" has value "-11.00" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS46" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS46"
And I set fields
| nummer | 1RLS46 |
| such   | RLS46  |
| ueb    | ja     |
| tterm  | .      |
And I set field "mge" to "-6" in row 1
And I save the current editor

# RLS reduziert gutschreibbare Menge (remge) in der RE
Then field "remge" from editor "RE46" in row 1 has value "-4"

# Storno Ruecklieferung
Given I open an editor "ST_RLS46" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS46"
And I save the current editor

# Storno-RLS erhoeht gutschreibbare Menge (remge) in der RE
Then field "remge" from editor "RE46" in row 1 has value "-8"


# ----------------------------------------------------------------------------------------------
Scenario: EK-BE-LS-RE1-RE2 RLS-SRLS
# ----------------------------------------------------------------------------------------------

# BE ------------------- LS ------------------ RE A
# | Artikel | mge.  |   | Artikel | mge   |   | Artikel | mge   |
# | E1      | 50 St.|   | E1      | 50 St.|   | E1      | 22 St.|
#                          \
#                           ------------------------- RE B
#                            \                        | Artikel | mge    |
#                             \                       | E1      | 18 St. |
#                              \
#                               --------------------------------------- RLS ------------------ SRLS
#                                                                       | Artikel | mge    |   | Artikel | mge     |
#                                                                       | E1      | -35 St.|   | E1      |  35 St. |
#
# Bestellung
Given I open an editor "BE47" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief    | 1     |
   | nummer  | 1BE47 |
   | such    | BE47  |
And I append rows
   | artikel | mge | preis |
   | E1      | 50  |  3,80 |
And I save the current editor

# Lieferschein
Given I open an editor "LS47" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE47"
And I set fields
   | nummer | 1LS47 |
   | such   | LS47  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung A
Given I open an editor "RE47A" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS47"
And I set fields
| nummer    | 1RE47A |
| such      | RE47A  |
| ueb       | ja     |
| tterm     | .      |
| vom       | .      |
And I set field "mge" to "22" in row 1
Then field "preis" has value "3.80" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Rechnung B
Given I open an editor "RE47B" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS47"
And I set fields
| nummer    | 1RE47B |
| such      | RE47B  |
| ueb       | ja     |
| tterm     | .      |
| vom       | .      |
And I set field "mge" to "18" in row 1
Then field "preis" has value "3.80" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "RLS47" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS47"
And I set fields
| nummer | 1RLS47 |
| such   | RLS47  |
| ueb    | ja     |
| tterm  | .      |
And I set field "mge" to "-35" in row 1
And I save the current editor

# RLS reduziert gutschreibbare Menge (remge) in der RE
Then field "remge" from editor "RE47A" in row 1 has value "0"
Then field "remge" from editor "RE47B" in row 1 has value "-15"

# Storno Ruecklieferung
Given I open an editor "ST_RLS47" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS47"
And I save the current editor

# Storno-RLS erhoeht gutschreibbare Menge (remge) in der RE
# TODO: remge in RE47A wird nicht erhöht, Soll -22
Then field "remge" from editor "RE47A" in row 1 has value "0"
Then field "remge" from editor "RE47B" in row 1 has value "-18"


# ----------------------------------------------------------------------------------------------
Scenario: VK BE-LS-RE--RLS_STRLS
# ----------------------------------------------------------------------------------------------
#
# BE ------------------- LS ------------------ RE
# | Artikel | mge.  |   | Artikel | mge   |   | Artikel | mge   |
# | V1      | 10 St.|   | V1      | 10 St.|   | V1      | 10 St.|
#                          \
#                           \
#                            ----------------------------- RLS ------------------ SRLS
#                                                          | Artikel | mge    |   | Artikel | mge     |
#                                                          | V1      | -10 St.|   | V1      |  10 St. |

# Auftrag
Given I open an editor "1AU48" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU48 |
   | kunde   | 1     |
   | such    | AU48  |
And I append rows
   | artikel | mge | preis |
   | V1      |  10 |    25 |
And I save the current editor

# Lieferschein
Given I open an editor "1LS48" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU48"
And I set fields
   | nummer | 1LS48 |
   | such   | LS48  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung
Given I open an editor "1RE48" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS48"
And I set fields
   | nummer | 1RE48 |
   | such   | RE48  |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "1RLS48" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS48"
And I set fields
   | nummer | 1RLS48 |
   | such   | RLS48  |
   | ueb    | ja   |
   | tterm  | .      |
   | budat  | .      |
And I set field "mge" to "-10" in row 1
And I save the current editor

# RLS reduziert gutschreibbare Menge (remge) in der RE
Then field "remge" from editor "1RE48" in row 1 has value "0"

# Storno Ruecklieferung
Given I open an editor "ST_RLS48" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "1RLS48"
And I save the current editor

# Storno-RLS erhoeht gutschreibbare Menge (remge) in der RE
Then field "remge" from editor "1RE48" in row 1 has value "-10"

# ----------------------------------------------------------------------------------------------
Scenario: Verkauf, Setartikel, Handelseinheit ungleich Lagereinheit, LS -> RE -> RLS
# ----------------------------------------------------------------------------------------------

# Komponente
Given I open an editor "KOMP3" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | KOMP3            |
   | namebspr | Komponente 3     |
   | bsart    | Fremdbeschaffung |
   | dispoa   | auftragsbezogen  |
   | vpr      | 10               |
   | fve      | 1                |
   | ve       | Satz             |
   | fvele    | 10               |
And I save the current editor

# Setartikel
Given I open an editor "SETART2" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such     | SETART2          |
   | namebspr | Setartikel 2     |
   | bsart    | Eigenfertigung   |
   | dispoa   | auftragsbezogen  |
   | eart     | (UsingBOM)       |
   | vpr      | 10               |
   | fve      | 1                |
   | ve       | Satz             |
   | fvele    | 10               |
And I append rows
   | elex  | anzahl |
   | KOMP3 | 1      |
And I save the current editor

# Lieferschein
Given I open an editor "1LS49" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer | 1LS49 |
   | kunde  | 1     |
   | such   | LS48  |
   | ueb    | ja    |
   | vom    | .     |
And I append rows
   | artikel | mge | he   |
   | SETART2 | 1   | Satz |
And I save the current editor

# Rechnung
Given I open an editor "1RE49" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1LS49"
And I set fields
   | nummer | 1RE49 |
   | such   | RE49  |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung
Given I open an editor "1RLS49" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS49"
And I set fields
   | nummer | 1RLS49 |
   | such   | RLS49  |
   | ueb    | ja     |
And I set field "mge" to "-1" in row 1
And I save the current editor

# (ev)remge in der Rechnungsposition muss den Wert 0 haben, weil alles ueber den RLS gutgeschrieben wird.
Then field "remge" from editor "1RE49" in row 1 has value "0"

# Kaufmaennische Gutschrift
Given I open an editor "1KGS49" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "1RLS49"
And I set fields
   | nummer | 1KGS49|
   | such   | KGS49 |
Then field "mge" has value "-1" in row 1
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Verkauf, Auftrag, Rechnung mit Lagerbewegung, Komplettgutschrift, Storno Komplettgutschrift, Ruecklieferung
# ----------------------------------------------------------------------------------------------

# Auftrag
Given I open an editor "1AU50" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU50 |
   | kunde   | 1     |
   | such    | AU50  |
And I append rows
   | artikel | mge | preis |
   | V1      |  10 |    25 |
And I save the current editor

# Rechnung mit Lagerbewegung
Given I open an editor "1RE50" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU50"
And I set fields
   | nummer | 1RE50 |
   | such   | RE50  |
   | fakt   | ja    |
   | tterm  | .     |
   | ueb    | ja    |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Komplettgutschrift
Given I open an editor "1WGS50" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "1RE50"
And I set fields
   | nummer | 1WGS50 |
   | such   | WGS50  |
   | tterm  | .      |
   | ueb    | ja     |
And I set field "mge" to "-10" in row 1
And I save the current editor

# Storno Komplettgutschrift
Given I open an editor "1WGS50S" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "1WGS50"
And I set fields
   | nummer | 1WGS50S |
And I save the current editor

# Ruecklieferung
Given I open an editor "1RLS50" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "1RE50"
And I set fields
   | nummer | 1RLS50 |
   | such   | RLS50  |
   | ueb    | ja     |
And I set field "mge" to "-10" in row 1
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: VK-AU-LS-RE-RLS-KGS mit Rabattierter Artikelposition
# Testfall: Auftrag mit Rabatt, Lieferung, Rechnung, Ruecklieferung, KGS
# ----------------------------------------------------------------------------------------------

# Auftrag/Bestellung neu mit einer Artikelposition mit Menge 2
Given I open an editor "AU51" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU51 |
   | kunde   | 1     |
   | such    | AU51  |
And I append rows
   | artikel | mge | preis | proz |
   | V1      | 2   |   25  |  -10 |
Then field "pwert" has value "45.00" in row 1
And I save the current editor

# Lieferschein aus Auftrag/Bestellung anlegen und buchen
Given I open an editor "LS51" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU51"
And I set fields
   | nummer | 1LS51 |
   | such   | LS51  |
   | ueb    | ja    |
   | vom    | .     |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung aus Lieferschein anlegen und buchen
Given I open an editor "RE51" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS51"
And I set fields
   | nummer | 1RE51 |
   | such   | RE51  |
   | ueb    | ja    |
   | tterm  | .     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "ofwert" from editor "RE51" in row 1 has value "-45.00"

# Rücklieferschein aus Lieferschein anlegen mit Menge -1 und buchen
Given I open an editor "RLS51" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS51"
And I set fields
   | nummer | 1RLS51 |
   | such   | RLS51  |
   | ueb    | ja     |
   | tterm  | .      |
   | budat  | .      |
And I set field "mge" to "-1" in row 1
And I save the current editor

Then field "ofwert" from editor "RE51" in row 1 has value "-22.50"

# Kaufmännische Gutschrift zu Rücklieferschein anlegen und buchen
Given I open an editor "KGS51" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS51"
And I set fields
   | nummer | 1KGS51 |
   | such   | KGS51  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
Then field "mge" has value "-1" in row 1
Then field "preis" has value "25.00" in row 1
Then field "proz" has value "-10" in row 1
Then field "pwert" has value "-22.50" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Then field "ofwert" from editor "RE51" in row 1 has value "-22.50"

# ----------------------------------------------------------------------------------------------
Scenario: EK-BE-LS-RE-WGS-RLS - ofwert nach Wertgutschrift und Ruecklieferschein korrekt berechnen
# Testfall: Bestellung mit 10 Stueck zu 10 Euro, Rechnung, Lieferschein, Wertgutschrift, Ruecklieferschein
# Erwartung: ofwert in der Rechnung ist nach Wertgutschrift und Ruecklieferschein -45
# ----------------------------------------------------------------------------------------------

# Bestellung mit 10 Stueck zu 10 Euro
Given I open an editor "BE100" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE100 |
   | lief   | 1      |
   | such   | BE100  |
And I append rows
   | artikel | mge | preis |
   | E1      | 10  |   10  |
And I save the current editor

# Lieferschein ueber 10 Stueck
Given I open an editor "LS100" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE100"
And I set fields
   | nummer | 1LS100 |
   | such   | LS100  |
   | ueb    | ja     |
   | vom    | .      |
And I press button "offueb" in row 1
And I save the current editor

# Rechnung ueber 10 Stueck zu 10 Euro
Given I open an editor "RE100" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS100"
And I set fields
   | nummer | 1RE100 |
   | such   | RE100  |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "10" in row 1
And I set field "preis" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
Then field "ofwert" from editor "RE100" in row 1 has value "-100.00"

# Wertgutschrift ueber 10 Stueck zu 1 Euro
Given I open an editor "WG100" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE100"
And I set fields
   | nummer | 1WG100 |
   | such   | WG100  |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "-10" in row 1
And I set field "preis" to "1" in row 1
And I save the current editor
Then field "ofwert" from editor "RE100" in row 1 has value "-90.00"

# Ruecklieferschein ueber 5 Stueck
Given I open an editor "RLS100" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS100"
And I set fields
   | nummer | 1RLS100 |
   | such   | RLS100  |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-5" in row 1
And I save the current editor

# Erwartetes Ergebnis: -45
Then field "ofwert" from editor "RE100" in row 1 has value "-45.00"

# ----------------------------------------------------------------------------------------------
Scenario: VK-AU-LS-RE-WGS-RLS - ofwert nach Wertgutschrift und Ruecklieferschein korrekt berechnen
# Testfall: Auftrag mit 20 Stueck zu 15 Euro, Rechnung, Wertgutschrift, Ruecklieferschein
# Erwartung: ofwert in der Rechnung ist nach Wertgutschrift und Ruecklieferschein -120
# ----------------------------------------------------------------------------------------------

# Auftrag mit 20 Stueck zu 15 Euro
Given I open an editor "AU101" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU101 |
   | kunde  | 1      |
   | such   | AU101  |
And I append rows
   | artikel | mge | preis |
   | V1      | 20  |   15  |
And I save the current editor

# Rechnung mit Lagerbewegung ueber 20 Stueck
Given I open an editor "RE101" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU101"
And I set fields
   | nummer | 1RE101 |
   | such   | RE101  |
   | ueb    | ja     |
   | fakt   | ja     |
   | tterm  | .      |
And I set field "mge" to "20" in row 1
And I set field "preis" to "15" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
Then field "ofwert" from editor "RE101" in row 1 has value "-300.00"

# Wertgutschrift ueber 20 Stueck zu 3 Euro
Given I open an editor "WG101" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE101"
And I set fields
   | nummer | 1WG101 |
   | such   | WG101  |
   | ueb    | ja     |
   | tterm  | .      |
   | vom    | .      |
And I set field "mge" to "-20" in row 1
And I set field "preis" to "3" in row 1
And I save the current editor
Then field "ofwert" from editor "RE101" in row 1 has value "-240.00"

# Ruecklieferschein ueber 10 Stueck
Given I open an editor "RLS101" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "RE101"
And I set fields
   | nummer | 1RLS101 |
   | such   | RLS101  |
   | ueb    | ja      |
   | tterm  | .       |
And I set field "mge" to "-10" in row 1
And I save the current editor

# Erwartetes Ergebnis: ofwert -120
Then field "ofwert" from editor "RE101" in row 1 has value "-120.00"

