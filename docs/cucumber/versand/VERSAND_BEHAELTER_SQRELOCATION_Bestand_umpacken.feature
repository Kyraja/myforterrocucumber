@persistent
Feature: VERSAND_BEHAELTER_SQRELOCATION_Bestand_umpacken.feature

# *****************************************************************************
#  Name             : VERSAND_BEHAELTER_SQRELOCATION_Bestand_umpacken.feature
#  Autor            : lschneider
#  Verantwortlich   : carue
#  Kontrolle        : drpf
#  Funktion         : Testet das Umpacken mit Behaeltern ueber IS SQRELOCATION
#  ref              : ref_la_sqrelocation_cu
# *****************************************************************************

Background:
Given I set the fake date to "03.04.95"


@testvorbereitung
Scenario Outline: Lagerplaetze
Given I open an editor "<editor>" from table "<table>" with command "STORE" for record "<such>"
And I set fields
    | such     | <such>     |
    | namebspr | <namebspr> |
    | lager    | <lager>    |
    | abplatz  | ja         |
And I save the current editor

Examples: Lagerplaetze
| editor     | table                 | such      | namebspr                         | lager |
| Lagerplatz | (Location):(Location) | LP-ZU     | Neuer Zugangslagerplatz          | L3    |
| Lagerplatz | (Location):(Location) | LP-AB     | Neuer Abgangslagerplatz          | L3    |
| Lagerplatz | (Location):(Location) | LP-TAUSCH | Artikel auf gleichen LP umbuchen | L1    |

@testvorbereitung
Scenario Outline: Artikel anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such         | <such>            |
    | namebspr     | <namebspr>        |
    | dispoa       | <dispoa>          |
    | chverfolgung | Chargenverfolgung |
    | chimlager    | ja                |
And I save the current editor

Examples: Artikel
| such            | namebspr                        | dispoa          |
| SQRELOC_BEH-1   | Artikel 1 in Behaelter          | auftragsbezogen |
| SQRELOC_BEH-2   | Artikel 2 in Behaelter          | auftragsbezogen |
| SQRELOC_BEH-3   | Fehlermeldung Behaelter pruefen | auftragsbezogen |

@testvorbereitung
Scenario: Baugruppe mit zwei Komponenten und zwei Arbeitsgängen
Given I open an editor "BG3-BEDARF" from table "(Part):(Product)" with command "STORE" for record "BG3-BEDARF"
And I set fields
    | such      | BG3-BEDARF             |
    | namebspr  | Zwei Komp und zwei AGs |
    | bsart     | Eigenfertigung         |
And I delete all rows
And I append rows
    | elex         | anzahl    |
    | EK1-BEDARF   | 1         |
    | A AG-LOHN1   | 1         |
    | EK2-BEDARF   | 1         |
    | A AG-LOHN2   | 1         |
And I save the current editor

@testvorbereitung
Scenario: Projekte anlegen
Given I open an editor "UMBUCHUNG1" from table "(Transaction):(Project)" with command "STORE" for record "UMBUCHUNG1"
And I set fields
    | such     | UMBUCHUNG1             |
    | namebspr | Umbuchung SQRELOCATION |
And I save the current editor

@testvorbereitung
Scenario: Chargen anlegen
Given I create a Lot "CH_SQRELOC_BEH-1.3" for Product "SQRELOC_BEH-1"
Given I create a Lot "CH_SQRELOC_BEH-3.3" for Product "SQRELOC_BEH-3"

##################################################################################################################


Scenario Outline: 01 Mehrere Artikel ohne Behaelter in leere Behaelter auf Lagerplatz umpacken
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | SQ-01     |
    | beldat  | .         |
And I append rows
    | mge | platz2 | verw       | charge2  | projekt   |
    | 10  | F1     | LEERERBEH1 | <charge> | <projekt> |
And I save the current editor

Examples:
| behaelter     | artikel       | charge              | projekt     |
| LEERERBEH_1   | SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1.3 | !UMBUCHUNG1 |
| LEERERBEH_2   | SQRELOC_BEH-1 |                     |             |
| LEERERBEH_3   | SQRELOC_BEH-2 |                     | !UMBUCHUNG1 |

Scenario: 01 Mehrere Artikel ohne Behaelter in leere Behaelter auf Lagerplatz umpacken
# In leere Behaelter auf Lagerplatz umpacken
Given I open the infosystem "SQRELOCATION"
And I set fields
    | belnr    | SQ-01            |
    | verw     | LEERERBEH1       |
    | workflow | Bestand umpacken |
And I press start
And I modify table
    | tbehzugang      | tlplatzzu | tmark  | !row   |
    | !LEERERBEH_1^id | LP-ZU     | ja     | 1      |
    | !LEERERBEH_2^id | LP-ZU     | ja     | 2      |
    | !LEERERBEH_3^id | LP-ZU     | ja     | 3      |
And I press button "umbuch"
And I close the current editor

# Behaelter pruefen
Given I switch the current editor to editor "LEERERBEH_1"
Then the table has 1 rows
Then field "artikel" has value "SQRELOC_BEH-1" in row 1
And I close the current editor

Given I switch the current editor to editor "LEERERBEH_2"
Then the table has 1 rows
Then table has values
    | artikel       | charge^such         | projekt    |
    | SQRELOC_BEH-1 | CH_SQRELOC_BEH-1.3  | UMBUCHUNG1 |
And I close the current editor

Given I switch the current editor to editor "LEERERBEH_3"
Then the table has 1 rows
Then table has values
    | artikel       | projekt    |
    | SQRELOC_BEH-2 | UMBUCHUNG1 |
And I close the current editor


Scenario Outline: 02 Mehrere Artikel ohne Behaelter in einen leeren Behaelter auf anderem Lagerplatz umpacken
Given I set the fake date to "04.04.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | SQ-02     |
    | beldat  | .         |
And I append rows
    | mge | platz2 | verw       | charge2  | projekt   |
    | 10  | F1     | LEERERBEH2 | <charge> | <projekt> |
And I save the current editor

Examples:
| behaelter     | artikel       | charge              | projekt     |
| EINBEHAELTER  | SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1.3 | !UMBUCHUNG1 |
|               | SQRELOC_BEH-1 |                     |             |
|               | SQRELOC_BEH-2 |                     | !UMBUCHUNG1 |

Scenario: 02 Mehrere Artikel ohne Behaelter in einen leeren Behaelter auf anderem Lagerplatz umpacken
Given I set the fake date to "04.04.95"
# In einen leeren Behaelter auf anderem Lagerplatz umpacken
Given I open the infosystem "SQRELOCATION"
And I set fields
    | belnr    | SQ-02            |
    | verw     | LEERERBEH2       |
    | workflow | Bestand umpacken |
And I press start
And I modify table
    | tbehzugang       | tlplatzzu | tmark | !row |
    | !EINBEHAELTER^id | LP-ZU     | ja    | 1    |
    | !EINBEHAELTER^id | LP-ZU     | ja    | 2    |
    | !EINBEHAELTER^id | LP-ZU     | ja    | 3    |
And I press button "umbuch"
And I close the current editor

# Behaelter pruefen
Given I switch the current editor to editor "EINBEHAELTER"
Then table has values
    | artikel       | charge^such        | projekt    |
    | SQRELOC_BEH-1 |                    |            |
    | SQRELOC_BEH-1 | CH_SQRELOC_BEH-1.3 | UMBUCHUNG1 |
    | SQRELOC_BEH-2 |                    | UMBUCHUNG1 |
And I close the current editor


Scenario Outline: 03 Mehrere Artikel ohne Behaelter in leere Behaelter auf Lagerplatz umpacken
Given I set the fake date to "05.04.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | SQ-03     |
    | beldat  | .         |
And I append rows
    | mge | platz2 | verw            | charge2 | projekt   |
    | 10  | LP-ZU  | LEER_NEUERPLATZ | <charge>| <projekt> |
And I save the current editor

Examples:
| behaelter         | artikel       | charge              | projekt     |
| LEER_NEUERPLATZ_1 | SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1.3 | !UMBUCHUNG1 |
| LEER_NEUERPLATZ_2 | SQRELOC_BEH-1 |                     |             |
|                   | SQRELOC_BEH-2 |                     | !UMBUCHUNG1 |

Scenario: 03 Mehrere Artikel ohne Behaelter in leere Behaelter auf Lagerplatz umpacken
Given I set the fake date to "05.04.95"
# In leere Behaelter auf Lagerplatz umpacken
Given I open the infosystem "SQRELOCATION"
And I set fields
    | belnr    | SQ-03            |
    | verw     | LEER_NEUERPLATZ  |
    | lplatz   | LP-ZU            |
    | workflow | Bestand umpacken |
And I press start
And I modify table
    | tbehzugang            | tlplatzzu | tmark | !row |
    | !LEER_NEUERPLATZ_2^id | LP-ZU     | ja    | 1    |
    | !LEER_NEUERPLATZ_1^id | LP-ZU     | ja    | 2    |
    | !LEER_NEUERPLATZ_1^id | LP-ZU     | ja    | 3    |
And I press button "umbuch"
And I close the current editor

Scenario Outline: 03 Mehrere Artikel ohne Behaelter in leere Behaelter auf Lagerplatz umpacken
Given I set the fake date to "05.04.95"
# Behaelter pruefen
Given I switch the current editor to editor "<behaelter>"
Then field "artikel" has value "<artikel>" in row <row>
Then field "charge^such" has value "<charge>" in row <row>
Then field "projekt" has value "<projekt>" in row <row>

Examples:
| behaelter         | artikel       | charge              | projekt     | row |
| LEER_NEUERPLATZ_2 | SQRELOC_BEH-1 |                     |             | 1   |
| LEER_NEUERPLATZ_1 | SQRELOC_BEH-1 | CH_SQRELOC_BEH-1.3  | UMBUCHUNG1  | 1   |
| LEER_NEUERPLATZ_1 | SQRELOC_BEH-2 |                     | UMBUCHUNG1  | 2   |


Scenario Outline: 04 Mehrere Artikel ohne Behaelter in gefuellte Behaelter auf anderem Lagerplatz umpacken
Given I set the fake date to "06.04.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | SQ-04     |
    | beldat  | .         |
And I append rows
    | mge   | platz2   | verw   | charge2  | projekt   | behaelter          |
    | <mge> | <platz2> | <verw> | <charge> | <projekt> | <behaelter_editor> |
And I save the current editor

Examples:
| behaelter         | Zugang      | artikel       | mge | platz2 | verw       | charge              | projekt     | behaelter_editor    |
| GEFUELLTERBEH_1   | 1 Bestand   | SQRELOC_BEH-1 | 10  | F1     | 1_GEFUELLT | !CH_SQRELOC_BEH-1.3 | !UMBUCHUNG1 |                     |
| GEFUELLTERBEH_2   | 2 Bestand   | SQRELOC_BEH-1 | 10  | F1     | 1_GEFUELLT |                     |             |                     |
| GEFUELLTERBEH_3   | 3 Bestand   | SQRELOC_BEH-2 | 10  | F1     | 1_GEFUELLT |                     | !UMBUCHUNG1 |                     |
|                   | 1 Behaelter | SQRELOC_BEH-3 | 1   | LP-ZU  |            |                     |             | !GEFUELLTERBEH_1    |
|                   | 2 Behaelter | SQRELOC_BEH-3 | 1   | LP-ZU  |            |                     | !UMBUCHUNG1 | !GEFUELLTERBEH_2    |
|                   | 3 Behaelter | SQRELOC_BEH-3 | 1   | LP-ZU  |            | !CH_SQRELOC_BEH-3.3 |             | !GEFUELLTERBEH_3    |

Scenario: 04 Mehrere Artikel ohne Behaelter in gefuellte Behaelter auf anderem Lagerplatz umpacken
Given I set the fake date to "06.04.95"
# In gefuellte Behaelter auf anderem Lagerplatz umpacken
Given I open the infosystem "SQRELOCATION"
And I set fields
    | belnr    | SQ-04            |
    | verw     | 1_GEFUELLT       |
    | lplatz   | F1               |
    | workflow | Bestand umpacken |
And I press start
And I modify table
    | tbehzugang          | tmark | !row |
    | !GEFUELLTERBEH_2^id | ja    | 2    |
    | !GEFUELLTERBEH_1^id | ja    | 1    |
    | !GEFUELLTERBEH_3^id | ja    | 3    |
And I press button "umbuch"
And I close the current editor

Scenario Outline: 04 Mehrere Artikel ohne Behaelter in gefuellte Behaelter auf anderem Lagerplatz umpacken
Given I set the fake date to "06.04.95"
# Behaelter pruefen
Given I switch the current editor to editor "<behaelter>"
Then table has values
    | artikel   | charge^such | projekt   |
    | <artikel> | <charge>    | <projekt> |
And I close the current editor

Examples:
| behaelter       | artikel       | charge              | projekt     |
| GEFUELLTERBEH_1 | SQRELOC_BEH-1 |                     |             |
| GEFUELLTERBEH_2 | SQRELOC_BEH-1 | CH_SQRELOC_BEH-1.3  | UMBUCHUNG1  |
| GEFUELLTERBEH_3 | SQRELOC_BEH-2 |                     | UMBUCHUNG1  |


Scenario Outline: 05 Mehrere Artikel ohne Behaelter in einen gefuellten Behaelter auf anderem Lagerplatz umpacken
Given I set the fake date to "07.04.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | SQ-05     |
    | beldat  | .         |
And I append rows
    | mge   | platz2   | verw   | charge2  | projekt   | behaelter          |
    | <mge> | <platz2> | <verw> | <charge> | <projekt> | <behaelter_editor> |
And I save the current editor

Examples:
| behaelter     | Zugang      | artikel       | mge | platz2 | verw          | charge              | projekt     | behaelter_editor  |
| EINGEFUELLTER | 1 Bestand   | SQRELOC_BEH-1 | 10  | F1     | EINGEFUELLTER | !CH_SQRELOC_BEH-1.3 | !UMBUCHUNG1 |                   |
|               | 2 Bestand   | SQRELOC_BEH-1 | 10  | F1     | EINGEFUELLTER |                     |             |                   |
|               | 3 Bestand   | SQRELOC_BEH-2 | 10  | F1     | EINGEFUELLTER |                     | !UMBUCHUNG1 |                   |
|               | 1 Behaelter | SQRELOC_BEH-3 | 1   | LP-ZU  |               |                     |             | !EINGEFUELLTER    |

Scenario: 05 Mehrere Artikel ohne Behaelter in einen gefuellten Behaelter auf anderem Lagerplatz umpacken
Given I set the fake date to "07.04.95"
# In einen gefuellten Behaelter auf anderem Lagerplatz umpacken
Given I open the infosystem "SQRELOCATION"
And I set fields
    | belnr    | SQ-05            |
    | verw     | EINGEFUELLTER    |
    | lplatz   | F1               |
    | workflow | Bestand umpacken |
And I press start
And I modify table
    | tbehzugang        | tmark | !row |
    | !EINGEFUELLTER^id | ja    | 1    |
    | !EINGEFUELLTER^id | ja    | 2    |
    | !EINGEFUELLTER^id | ja    | 3    |
And I press button "umbuch"
And I close the current editor

# Behaelter pruefen
Given I switch the current editor to editor "EINGEFUELLTER"
Then table has values
    | artikel       | charge^such        | projekt    |
    | SQRELOC_BEH-1 |                    |            |
    | SQRELOC_BEH-1 | CH_SQRELOC_BEH-1.3 | UMBUCHUNG1 |
    | SQRELOC_BEH-2 |                    | UMBUCHUNG1 |
    | SQRELOC_BEH-3 |                    |            |
And I close the current editor


Scenario Outline: 06 Mehrere Artikel ohne Behaelter in gefuellte Behaelter auf Lagerplatz umpacken
Given I set the fake date to "08.04.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | SQ-06     |
    | beldat  | .         |
And I append rows
    | mge   | platz2   | verw   | charge2  | projekt   | behaelter          |
    | <mge> | <platz2> | <verw> | <charge> | <projekt> | <behaelter_editor> |
And I save the current editor

Examples:
| behaelter         | Zugang      | artikel       | mge | platz2 | verw       | charge              | projekt     | behaelter_editor    |
| GLEICHERPLATZ_1   | 1 Bestand   | SQRELOC_BEH-1 | 10  | F1     | A_GEFUELLT | !CH_SQRELOC_BEH-1.3 | !UMBUCHUNG1 |                     |
| GLEICHERPLATZ_2   | 2 Bestand   | SQRELOC_BEH-1 | 10  | F1     | A_GEFUELLT |                     |             |                     |
|                   | 3 Bestand   | SQRELOC_BEH-2 | 10  | F1     | A_GEFUELLT |                     | !UMBUCHUNG1 |                     |
|                   | 1 Behaelter | SQRELOC_BEH-3 | 1   | F1     |            |                     |             | !GLEICHERPLATZ_1    |
|                   | 2 Behaelter | SQRELOC_BEH-3 | 1   | F1     |            |                     | !UMBUCHUNG1 | !GLEICHERPLATZ_2    |

Scenario: 06 Mehrere Artikel ohne Behaelter in gefuellte Behaelter auf Lagerplatz umpacken
Given I set the fake date to "08.04.95"
# In gefuellte Behaelter auf Lagerplatz umpacken
Given I open the infosystem "SQRELOCATION"
And I set fields
    | belnr    | SQ-06            |
    | verw     | A_GEFUELLT       |
    | lplatz   | F1               |
    | workflow | Bestand umpacken |
And I press start
Then field "tlplatzzu" is not modifiable in row 1
And I modify table
    | tbehzugang       | tmark | !row |
    | !GLEICHERPLATZ_1 | ja    | 1    |
    | !GLEICHERPLATZ_1 | ja    | 2    |
    | !GLEICHERPLATZ_2 | ja    | 3    |
And I press button "umbuch"

Then table has values
    | tartikel      | tbehabgang^such | !row |
    | SQRELOC_BEH-1 | GLEICHERPLATZ_1 | 1    |
    | SQRELOC_BEH-1 | GLEICHERPLATZ_1 | 2    |
    | SQRELOC_BEH-2 | GLEICHERPLATZ_2 | 3    |
And I close the current editor


Scenario Outline: 07 Mehrere Artikel im Behaelter in verschiedene leere auf anderen Lagerplatz Behaelter umpacken
Given I set the fake date to "09.04.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | SQ-07     |
    | beldat  | .         |
And I append rows
    | mge | platz2 | verw       | charge2  | projekt   | behaelter           |
    | 10  | F1     | VOLLINLEER | <charge> | <projekt> | <behaelter_editor>  |
And I save the current editor

Examples:
| behaelter     | artikel       | charge              | projekt     | behaelter_editor  |
| SQRELOC_1     | SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1.3 | !UMBUCHUNG1 | !SQRELOC_1        |
| SQRELOC_2     | SQRELOC_BEH-1 |                     |             | !SQRELOC_2        |
| SQRELOC_3     | SQRELOC_BEH-2 |                     | !UMBUCHUNG1 | !SQRELOC_3        |

Scenario: 07 Mehrere Artikel im Behaelter in verschiedene leere Behaelter auf anderen Lagerplatz umpacken
Given I set the fake date to "09.04.95"
# Leere Behaelter anlegen
Given I create a Container "LEERERBEH_4" for packaging material "BEHAELTER" and search word "LEERERBEH_4"
Given I create a Container "LEERERBEH_5" for packaging material "BEHAELTER" and search word "LEERERBEH_5"
Given I create a Container "LEERERBEH_6" for packaging material "BEHAELTER" and search word "LEERERBEH_6"

# In verschiedene leere auf anderen Lagerplatz Behaelter umpacken
Given I open the infosystem "SQRELOCATION"
And I set fields
    | belnr    | SQ-07            |
    | verw     | VOLLINLEER       |
    | workflow | Bestand umpacken |
And I press start
And I modify table
    | tbehzugang     | tlplatzzu | tmark | !row  |
    | !LEERERBEH_4   | LP-ZU     | ja     | 1    |
    | !LEERERBEH_5   | LP-ZU     | ja     | 2    |
    | !LEERERBEH_6   | LP-ZU     | ja     | 3    |
And I press button "umbuch"
And I close the current editor

Scenario Outline: 07 Mehrere Artikel im Behaelter in verschiedene leere Behaelter auf anderen Lagerplatz umpacken
Given I set the fake date to "09.04.95"
# Behaelter pruefen
Given I switch the current editor to editor "<behaelter>"
Then the table has 1 rows
Then table has values
    | artikel   | charge^such | projekt   |
    | <artikel> | <charge>    | <projekt> |
And I close the current editor

Examples:
| behaelter   | artikel       | charge              | projekt     |
| LEERERBEH_4 | SQRELOC_BEH-1 |                     |             |
| LEERERBEH_5 | SQRELOC_BEH-1 | CH_SQRELOC_BEH-1.3  | UMBUCHUNG1  |
| LEERERBEH_6 | SQRELOC_BEH-2 |                     | UMBUCHUNG1  |


Scenario Outline: 08 Mehrere Artikel im Behaelter in einen leeren Behaelter auf anderem Lagerplatz umpacken
Given I set the fake date to "10.04.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | SQ-08     |
    | beldat  | .         |
And I append rows
    | mge | platz2 | verw        | charge2  | projekt   | behaelter          |
    | 10  | F1     | VOLLINLEER2 | <charge> | <projekt> | <behaelter_editor> |
And I save the current editor

Examples:
| behaelter     | artikel       | charge              | projekt     | behaelter_editor  |
| SQRELOC_B1    | SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1.3 | !UMBUCHUNG1 | !SQRELOC_B1       |
| SQRELOC_B2    | SQRELOC_BEH-1 |                     |             | !SQRELOC_B1       |
|               | SQRELOC_BEH-2 |                     | !UMBUCHUNG1 | !SQRELOC_B2       |

Scenario: 08 Mehrere Artikel im Behaelter in einen leeren Behaelter auf anderem Lagerplatz umpacken
Given I set the fake date to "10.04.95"
# Leeren Behaelter anlegen
Given I create a Container "EINLEERER" for packaging material "BEHAELTER" and search word "EINLEERER"

# In einen leeren Behaelter auf anderem Lagerplatz umpacken
Given I open the infosystem "SQRELOCATION"
And I set fields
    | belnr    | SQ-08            |
    | verw     | VOLLINLEER2      |
    | workflow | Bestand umpacken |
And I press start
And I modify table
    | tbehzugang    | tlplatzzu | !row |
    | !EINLEERER^id | LP-ZU     | 1    |
    | !EINLEERER^id | LP-ZU     | 2    |
    | !EINLEERER^id | LP-ZU     | 3    |
And I press button "allmark"
And I press button "umbuch"
And I close the current editor

# Behaelter pruefen
Given I switch the current editor to editor "EINLEERER"
Then table has values
    | artikel       | charge^such         | projekt     |
    | SQRELOC_BEH-1 |                     |             |
    | SQRELOC_BEH-1 | CH_SQRELOC_BEH-1.3  | UMBUCHUNG1  |
    | SQRELOC_BEH-2 |                     | UMBUCHUNG1  |
And I close the current editor

Then Container "SQRELOC_B1" is empty
Then Container "SQRELOC_B2" is empty


Scenario Outline: 09 Mehrere Artikel im Behaelter in verschiedene leere Behaelter auf Lagerplatz umpacken
Given I set the fake date to "11.04.95"
# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "<behaelter>" for packaging material "BEHAELTER" and search word "<behaelter>"

Given I open an editor "Lagerbuchung" for tip command "(Stockadjustment)" and arguments ""
And I set fields
    | artikel | <artikel> |
    | buart   | Zugang    |
    | beleg   | SQ-09     |
    | beldat  | .         |
And I append rows
    | mge | platz2 | verw        | charge2  | projekt   | behaelter          |
    | 10  | LP-ZU  | VOLLINLEER3 | <charge> | <projekt> | <behaelter_editor> |
And I save the current editor

Examples:
| behaelter         | artikel       | charge              | projekt     | behaelter_editor  |
| SQRELOC_V1        | SQRELOC_BEH-1 | !CH_SQRELOC_BEH-1.3 | !UMBUCHUNG1 | !SQRELOC_V1       |
| SQRELOC_V2        | SQRELOC_BEH-1 |                     |             | !SQRELOC_V2       |
| SQRELOC_V3        | SQRELOC_BEH-2 |                     | !UMBUCHUNG1 | !SQRELOC_V3       |

Scenario: 09 Mehrere Artikel im Behaelter in verschiedene leere Behaelter auf Lagerplatz umpacken
Given I set the fake date to "11.04.95"
# Leere Behaelter anlegen
Given I create a Container "LEERERBEH_V4" for packaging material "BEHAELTER"
Given I create a Container "LEERERBEH_V5" for packaging material "BEHAELTER"
Given I create a Container "LEERERBEH_V6" for packaging material "BEHAELTER"

# In verschiedene leere Behaelter auf Lagerplatz umpacken
Given I open the infosystem "SQRELOCATION"
And I set fields
    | belnr    | SQ-09            |
    | verw     | VOLLINLEER3      |
    | lgruppe  |                  |
    | workflow | Bestand umpacken |
And I press start
And I modify table
    | tbehzugang    | tlplatzzu | tmark | !row |
    | !LEERERBEH_V4 | LP-ZU     | ja    | 1    |
    | !LEERERBEH_V5 | LP-ZU     | ja    | 2    |
    | !LEERERBEH_V6 | LP-ZU     | ja    | 3    |
And I press button "umbuch"

Then table has values
    | tartikel      | tcharge^such       | tprojekt   | tbehabgang^such | !row |
    | SQRELOC_BEH-1 |                    |            | LEERERBEH_V4    | 1    |
    | SQRELOC_BEH-1 | CH_SQRELOC_BEH-1.3 | UMBUCHUNG1 | LEERERBEH_V5    | 2    |
    | SQRELOC_BEH-2 |                    | UMBUCHUNG1 | LEERERBEH_V6    | 3    |
And I close the current editor


Scenario: 10 Mehrere Artikel mit und ohne Behaelter in gefuellte Behaelter auf Lagerplatz umpacken
Given I set the fake date to "12.04.95"
# Bestaende auf 0 setzen
Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F2"
Given I set StorageQuantity to zero for Product "EK2-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EK2-BEDARF" on StorageLocation "F2"
Given I set StorageQuantity to zero for Product "EK3-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EK3-BEDARF" on StorageLocation "F2"
Given I set StorageQuantity to zero for Product "BEHAELTER" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "BEHAELTER" on StorageLocation "F2"

# Behaelter anlegen und Lagerzugaenge buchen
Given I post a receipt via ManualStockAdjustment for Product "BEHAELTER" and quantity "4" on StorageLocation "LP1-PACK" with document "BEH10"
Given I create a Container "GEFUELLT_B1" for packaging material "BEHAELTER"
Given I create a Container "GEFUELLT_B2" for packaging material "BEHAELTER"
Given I create a Container "LEER_B3" for packaging material "BEHAELTER"
Given I create a Container "LEER_B4" for packaging material "BEHAELTER"

Given I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "2" on StorageLocation "F1" with document "SQ101" and Container "!GEFUELLT_B1"
Given I post a receipt via ManualStockAdjustment for Product "EK2-BEDARF" and quantity "2" on StorageLocation "F1" with document "SQ102" and Container "!GEFUELLT_B1"
Given I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "5" on StorageLocation "F1" with document "SQ103" and Container "!GEFUELLT_B2"
Given I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "10" on StorageLocation "F1" with document "SQ104"
Given I post a receipt via ManualStockAdjustment for Product "EK3-BEDARF" and quantity "10" on StorageLocation "F1" with document "SQ105"

# In verschiedene Behaelter auf Lagerplatz umpacken
Given I open the infosystem "SQRELOCATION"
And I set fields
    | belnr    | SQ-10            |
    | lplatz   | F1               |
    | workflow | Bestand umpacken |
And I press start
And I modify table
    | tmge   | tbehzugang    | tlplatzzu    | !row |
    | 5      | !LEER_B3      | F2           | 1    |
    | 1      | !GEFUELLT_B2  | !dontChange  | 2    |
    | 1      | !LEER_B4      | F1           | 3    |
    | 1      | !LEER_B3      | F2           | 4    |
    | 5      | !GEFUELLT_B1  | !dontChange  | 5    |
And I press button "allmark"
And I press button "umbuch"

Then table has values
    | tartikel      | gebmge    | tbehabgang^such   | !row |
    | EK1-BEDARF    | 5         |                   | 1    |
    | EK1-BEDARF    | 1         | GEFUELLT_B1       | 2    |
    | EK1-BEDARF    | 5         | GEFUELLT_B2       | 3    |
    | EK1-BEDARF    | 1         | LEER_B4           | 4    |
    | EK2-BEDARF    | 1         | GEFUELLT_B1       | 5    |
    | EK3-BEDARF    | 5         |                   | 6    |
    | EK3-BEDARF    | 5         | GEFUELLT_B1       | 7    |
And I close the current editor


Scenario: 11 Eine groessere Menge als die Abgangsmenge in der Zeile kann nicht in einen Behaelter gelegt werden
Given I set the fake date to "13.04.95"
# Bestaende auf 0 setzen
Given I set StorageQuantity to zero for Product "EK3-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EK3-BEDARF" on StorageLocation "F2"

# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "MENGE_B1" for packaging material "BEHAELTER"
Given I post a receipt via ManualStockAdjustment for Product "EK3-BEDARF" and quantity "10" on StorageLocation "F1" with document "SQ111" and Container "!MENGE_B1"

# tmge bleibt auf maximal umzubuchendem Wert
Given I open the infosystem "SQRELOCATION"
And I set fields
    | belnr        | SQ-11            |
    | container    | !MENGE_B1        |
    | workflow     | Bestand umpacken |
And I press start
And I set field "tmge" to "20" in row 1
Then field "tmge" has value "10" in row 1
And I close the current editor


Scenario: 12 Ein Artikel kann ohne Aenderung einer Gebindeinformation nicht in den Behaelter gebucht werden, in dem der Artikel bereits ist
Given I set the fake date to "14.04.95"
# Bestaende auf 0 setzen
Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F1"
Given I set StorageQuantity to zero for Product "EK1-BEDARF" on StorageLocation "F2"

# Behaelter anlegen und Lagerzugaenge buchen
Given I create a Container "GEBINDE_B1" for packaging material "BEHAELTER"
Given I create a Container "GEBINDE_BA1" for packaging material "BEHAELTER"
Given I post a receipt via ManualStockAdjustment for Product "EK1-BEDARF" and quantity "2" on StorageLocation "F1" with document "SQ121" and Container "!GEBINDE_B1"

# Feld thinweis zeigt Hinweis, dass der gleiche Behälter angegeben wurde, Umbuchung nicht möglich
Given I open the infosystem "SQRELOCATION"
And I set fields
    | belnr        | SQ-12            |
    | container    | !GEBINDE_B1      |
    | workflow     | Bestand umpacken |
And I press start
And I set field "tbehzugang" to "!GEBINDE_B1" in row 1
Then field "tmark" is not modifiable in row 1
Then field "thinweis" has value "icon:attention" in row 1
And I modify table
	| tbehzugang	| tmark	| !row	|
	| !GEBINDE_BA1	| ja	| 1		|
And I set field "tbehzugang" to "!GEBINDE_B1" in row 1
Then table has values
	| tbehzugang			| tmark	| thinweis			|
	| !GEBINDE_B1^nummer	| nein	| icon:attention	|
Then field "tmark" is not modifiable in row 1
And I close the current editor


# über Materialzuordnung im Betriebsauftrag gebuchte Mengen in Behälter werden nicht angezeigt, die Felder in der Tabelle sind daher schreibgeschützt   
# Grund ist, dass der Behäter nicht in die Platzmenge integriert ist 
# Scenario: 13 Selektion nach Betriebsauftrag zeigt das benötigte Material in Behaeltern an, Material wird umgepackt


# über Materialzuordnung im Lieferschein gebuchte Mengen in Behälter werden nicht angezeigt, die Felder in der Tabelle sind daher schreibgeschützt   
# Grund ist, dass der Behäter nicht in die Platzmenge integriert ist 
# Scenario: 14 Selektion nach Einkaufszugang zeigt Teile in Behaeltern an, Teile werden umgelagert

