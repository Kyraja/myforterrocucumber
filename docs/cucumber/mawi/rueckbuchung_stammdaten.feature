# *****************************************************************************
#  Name             : rueckbuchung_stammdaten.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Legt Stammdaten zum Testen von Rueckbuchungen an
#
# *****************************************************************************
@persistent
Feature: rueckbuchung_stammdaten.feature
Background:
Given I set the fake date to "02.01.95"

@Stammdaten
Scenario: Bewertungsverfahren konfigurieren
Given I open an editor "firma" from table "(Company):(ValuationConfiguration)" with command "UPDATE" for record "10"

And I append rows
  | bewverf | bewab             | bewzu         |
  | 2       | letzter           | Vorgangspreis |
  | 4       | frühester        | Vorgangspreis |
  | 5       | Preis des Zugangs | Vorgangspreis |

And I save the current editor

@Stammdaten
Scenario: 00 Stammdaten anlegen - Lieferant PUKY
Given I open an editor "PUKY" from table "(Vendor):(Vendor)" with command "STORE" for record "PUKY"

And I set fields
    | such     | PUKY         |
    | namebspr | PUKY Fahrrad |
    | zbed     | 201          |

And I save the current editor

@Stammdaten
Scenario: 00 Stammdaten anlegen - Kunde RADSHOP
Given I open an editor "RADSHOP" from table "(Customer):(Customer)" with command "STORE" for record "RADSHOP"

And I set fields
    | such     | RADSHOP                |
    | namebspr | Radshop Maier, Rastatt |
    | ans      | Radshop Maier          |
    | str      | Riedstr. 24-28         |
    | plz      | 76437                  |
    | nort     | Rastatt                |
    | betreuer | .                      |
    | ustid    | DE56454651             |
    | lbed     | EXW                    |
    | zbed     | 201                    |

And I save the current editor


Scenario Outline: 00 Stammdaten anlegen - Lager
Given I open an editor "<suchw>" from table "(Warehouse):(Warehouse)" with command "STORE" for record "<suchw>"

And I set fields
    | such     | <suchw>   |
    | namebspr | <name>    |
    | lgruppe  | KARLSRUHE |
    | disporel | <dispo>   |
    | lnullm   | <lnullm>  |
And I save the current editor

Examples:

| suchw    | name                    | dispo | lnullm |
| MATERIAL | Materiallager Fertigung | ja    | nein   |
| QMLAGER  | Zwischenlager QM        | nein  | nein   |
| WARENAB  | Warenausgangslager      | nein  | nein   |
| MGEWEG   | Lager, Mengen loeschen  | nein  | ja     |

Scenario Outline: 00 Stammdaten anlegen - Lagerplaetze
Given I open an editor "<suchw>" from table "(Location):(Location)" with command "STORE" for record "<suchw>"

And I set fields
    | such     | <suchw>   |
    | namebspr | <name>    |
    | lager    | <lager>   |
    | disporel | <dispo>   |
    | zuplatz  | <zuplatz> |
    | abplatz  | <abplatz> |

And I save the current editor

Examples:
| suchw | name               | lager     | dispo | zuplatz | abplatz |
| MLF01 | Material, Platz 01 | !MATERIAL | ja    | ja      | ja      |
| ZLQM  | Zwischenlager QM   | !QMLAGER  | nein  | nein    | nein    |
| ABLA  | Abgangslagerplatz  | !WARENAB  | nein  | nein    | nein    |
| WELA  | Zugangslagerplatz  | !WARENAB  | nein  | nein    | nein    |
| MGEL1 | Mengen loeschen 01 | !MGEWEG   | nein  | nein    | nein    |
| MGEL2 | Mengen loeschen 02 | !MGEWEG   | nein  | nein    | nein    |

@Stammdaten
Scenario Outline: 00 Stammdaten anlegen - Einkaufsartikel
Given I open an editor "<suchw>" from table "(Part):(Product)" with command "STORE" for record "<suchw>"

And I set fields
    | such      | <suchw>    |
    | namebspr  | <namebspr> |
    | dispoa    | <dispoa>   |
    | fehe      | <fehe>     |
    | ehe       | <ehe>      |
    | fehle     | <fehle>    |
    | feple     | <feple>    |
    | lief      | !PUKY      |
    | efrist    | <efrist>   |
    | epr       | <epr>      |
    | epe1      | <epe1>     |
    | chverfolgung | Chargenverfolgung         |
    | chimlager | ja         |
    | vhe       | <vhe>      |
    | vpe       | <vpe>      |
    | epe       | <epe>      |
    | ve        | <ve>       |
    | ge        | <ge>       |
    | fvhe      | <fvhe>     |
    | fvpe      | <fvpe>     |
    | fepe      | <fepe>     |
    | fve       | <fve>      |
    | fge       | <fge>      |
    | gebehe    | <gebehe>   |
    | gebvhe    | <gebvhe>   |
    | gebve     | <gebve>    |
    | gebvpe    | <gebvpe>   |
    | gebepe    | <gebepe>   |
    | gebge     | <gebge>    |
    | zuplatz   | !MLF01     |
    | abplatz   | !MLF01     |

And I save the current editor

Examples: Artikel
| suchw  | namebspr             | dispoa          | fehe | ehe         | fehle | feple | efrist | epr | epe1        | vhe         | vpe         | epe         | ve          | ge          | fvhe | fvpe | fepe | fve | fge | gebehe | gebvhe | gebve | gebvpe | gebepe | gebge |
| RAHMEN | Rahmen Ultralight    | !dontChange     | 5    | kg          | 1     | 1     | 2      | 100 | kg          | kg          | kg          | kg          | kg          | kg          | 5    | 5    | 5    | 5   | 5   | JA     | JA     | JA    | JA     | JA     | JA    |
| RAD    | Reifenset Roadrunner | erweitert bedar | 1    | Paar        | 2     | 2     | 2      | 60  | Paar        | Paar        | Paar        | Paar        | Paar        | Paar        | 1    | 1    | 1    | 1   | 1   |        |        |       |        |        |       |
| SATTEL | Komfortsattel        | auftragsbezogen | 1    | !dontChange | 1     | 1     | 1      | 10  | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | 1    | 1    | 1    | 1   | 1   |        |        |       |        |        |       |
| PEDALE | Pedale N73           | auftragsbezogen | 1    | Paar        | 2     | 2     | 1      | 8   | !dontChange | Paar        | Paar        | Paar        | Paar        | Paar        | 1    | 1    | 1    | 1   | 1   | JA     | JA     | JA    | JA     | JA     | JA    |


@Stammdaten
Scenario Outline: 00 Stamdaten anlegen - Arbeitsgaenge
Given I open an editor "<suchw>" from table "(Operation):(Operation)" with command "STORE" for record "<suchw>"
And I set field "such" to "<suchw>"
And I set field "namebspr" to "<namebspr>"
And I set field "mgr" to "112"
And I set field "lgr" to "2"
And I set field "lgrruesten" to "2"
And I set field "aschein" to "ja"
And I set field "tr" to "<tr>"
And I set field "te" to "<te>"
And I save the current editor

Examples:
| suchw        | namebspr     | tr | te |
| SCHRAUBEN    | Schrauben    | 5  | 10 |
| MONTAGE1     | Montage 1    | 15 | 6  |

@Stammdaten
Scenario: 00 Stammdaten anlegen - Verkaufsteil FAHRRAD
Given I open an editor "FAHRRAD" from table "(Part):(Product)" with command "STORE" for record "FAHRRAD"

And I set fields
    | such      | FAHRRAD           |
    | namebspr  | Superbike MAX2004 |
    | bsart     | Eigenfertigung    |
    | chverfolgung | Chargenverfolgung                |
    | chimlager | ja                |
    | vpr       | 475.00            |
    | vwaehr    | EUR               |

And I delete all rows
And I append rows
    | elex       | elanzahl    |
    | !RAHMEN    | 1           |
    | !RAD       | 2           |
    | !SCHRAUBEN | !dontChange |
    | !SATTEL    | 1           |
    | !PEDALE    | 2           |
    | !MONTAGE1  | !dontChange |

And I save the current editor

@Stammdaten
Scenario Outline: 00 Stammdaten anlegen - Chargen fuer alle Artikel
Given I open an editor "<suchw>" from table "(Lots):(Lots)" with command "STORE" for record "<suchw>"
And I set fields
    | such      | <suchw>     |
    | chname    | <name>      |
    | exnum     | <exnum>     |
    | artikel   | <artikel>   |
    | lief      | <lieferant> |
    | eigcharge | <eigen>     |

And I save the current editor

Examples: Chargen
| suchw      | name                 | exnum         | artikel  | lieferant   | eigen       |
| UL01RAH    | Rahmen Ultralight    | 20031117      | !RAHMEN  | !PUKY       | !dontChange |
| RAD002     | Reifenset Roadrunner | 777777        | !RAD     | !PUKY       | !dontChange |
| SATTELB    | Komfortsattel        | X517998       | !SATTEL  | !PUKY       | !dontChange |
| PEDP471    | Pedale N73           | N73-IV-B_1014 | !PEDALE  | !PUKY       | !dontChange |
| SBMAX2004A | Superbike MAX2004    | SUP-FE-A_2004 | !FAHRRAD | !dontChange | ja          |
