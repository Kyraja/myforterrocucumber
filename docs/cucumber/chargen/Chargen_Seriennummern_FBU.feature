@persistent
Feature: Chargen_Seriennummern_FBU.feature

Background:
And I set the fake date to "16.01.1995"

# **********************************************************************************
#  Name             : Chargen_Seriennummern_FBU.feature
#  Autor            : bschiga
#  Verantwortlich   : bschiga
#  Kontrolle        : carue
#  Funktion         : Testet Chargen-/Seriennummernverwaltung
#  ref              : ref_chargen_seriennr_cu
#
# **********************************************************************************

Scenario: Chargenpflicht in Konfiguration einschalten

Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set fields
    | chpflicht   | ja  |
And I save the current editor

    # Lagerstruktur fuer Kundenanlieferung und Umlagerungslieferschein
Scenario Outline: Lagergruppen, Lager und Lagerplätze
Given I open an editor "<such>" from table "<table>" with command "STORE" for record "<such>"
And I set fields
  | such              | <such>                |
  | namebspr          | <namebspr>            |
  | zkonsilg          | <zkonsilg>            |
  | <lager>           | <lager2>              |
  | <ruecklieferung>  | <vkruecklieferung>    |
  | <kundenanliefer>  | <vkkundenanlieferung> |
And I save the current editor
Examples:
  | table                         | Hinweis     | such        | namebspr                  | lager   | lager2    | ruecklieferung    | vkruecklieferung  | kundenanliefer      | vkkundenanlieferung | zkonsilg    |
  | (Warehouse):(WarehouseGroup)  | LAGERGRUPPE | KONSI       | Konsignationslagergruppe  | ans     | KONSI     | staat             | Deutschland       | !dontChange         | !dontChange         | ja          |
  | (Warehouse):(Warehouse)       | LAGER       | K1          | Konsignationslager        | lgruppe | !KONSI^id | staat             | Deutschland       | !dontChange         | !dontChange         | !dontChange |
  | (Location):(Location)         | LAGERPLATZ  | KONSI1      | Konsignationslagerplatz 1 | lager   | !K1^id    | lplaenge          | 5                 | !dontChange         | !dontChange         | !dontChange |
  | (Location):(Location)         | LAGERPLATZ  | KONSI2      | Konsignationslagerplatz 2 | lager   | !K1^id    | lplaenge          | 5                 | !dontChange         | !dontChange         | !dontChange |
  | (Location):(Location)         | LAGERPLATZ  | L2F3        | Lagerplatz Hongkong 3     | lager   | L2        | lplaenge          | 5                 | !dontChange         | !dontChange         | !dontChange |
  | (Warehouse):(WarehouseGroup)  | LAGERGRUPPE | KARLSRUHE   | !dontChange               | ans     | KARLSRUHE | vkruecklieferung  | F3                | vkkundenanlieferung | KONSI1              | !dontChange |

Scenario Outline: Lieferanten und Kunden
Given I open an editor "<such>" from table "<table>" with command "STORE" for record "<such>"
And I set fields
    | such        | <such>        |
    | namebspr    | <namebspr>    |
    | ans         | <ans>         |
    | str         | <str>         |
    | plz         | <plz>         |
    | nort        | <nort>        |
    | staat       | <staat>       |
    | konsi       | <konsi>       |
    | zbed        | <zbed>        |
    | waehr       | <waehr>       |
And I save the current editor
Examples:
    | table                   | such       | namebspr              | ans      | str                 | plz         | nort            | staat       | konsi       | zbed      | waehr       |
    | (Vendor):(Vendor)       | LIEFCHA1   | Lieferant 1 Chargen  | LIEFCHA1  | Chargen Straße 1    | 12345       | Chargenstadt    | !dontChange | !dontChange | ZSOFORT   | !dontChange |
    | (Vendor):(Vendor)       | LIEFCHA2   | Lieferant 2 Chargen  | LIEFCHA2  | Chargen Straße 2    | 23456       | Chargenstadt    | !dontChange | !dontChange | Z10.3     | !dontChange |
    | (Customer):(Customer)   | KUNDECH1   | Kunde 1 Chargen      | KUNDECH1  | CHSN Straße 1       | 56789       | CHSNstadt       | !dontChange | !dontChange | ZSOFORT   | !dontChange |
    | (Customer):(Customer)   | KUNDECH2   | Kunde 2 Chargen      | KUNDECH1  | CHSN Straße 2       | 67890       | CHSNstadt       | !dontChange | KONSI2      | Z10.3     | !dontChange |


Scenario Outline: Einkaufsartikel
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such          | <such>            |
    | namebspr      | <namebspr>        |
    | bsart         | Fremdbeschaffung  |
    | dispoa        | <dispoa>          |
    | chverfolgung  | <chverfolgung>    |
    | chimlager     | <chimlager>       |
    | lief          | <lief>            |
    | efrist        | <efrist>          |
    | epr           | <epr>             |
    | vpr           | <vpr>             |
And I save the current editor

Examples:
    | such            | namebspr                            | dispoa            | chverfolgung            | chimlager     | lief        | efrist      | epr         | vpr         |
    | EK01_CHARGE     | chargenpflichtiges Teil 1           | bedarfsbezogen    | Chargenverfolgung       | ja            | LIEFCHA1    | 3           | 5           | 10          |
    | EK02_CHARGE     | chargenpflichtiges Teil 2           | bedarfsbezogen    | Chargenverfolgung       | ja            | LIEFCHA2    | 3           | 5           | 10          |
    | EK03_CHARGE     | chargenpflichtiges Teil 3           | bedarfsbezogen    | Chargenverfolgung       | ja            | LIEFCHA1    | 3           | 5           | 10          |
    | EK04_SN         | seriennummernpflichtiges Teil 4     | bedarfsbezogen    | Seriennummernverfolgung | ja            | LIEFCHA1    | 3           | 5           | 10          |
    | CHIMLAGERNEIN   | chargenpflicht ohne chimlager       | bedarfsbezogen    | Chargenverfolgung       | nein          | LIEFCHA2    | 3           | 5           | 10          |
    | NOCHARGE        | ohne Chargenpflicht                 | bedarfsbezogen    |                         | !dontChange   | TEST        | 3           | 5           | 10          |
    | NOCHARGE2       | ohne Chargenpflicht                 | bedarfsbezogen    |                         | !dontChange   | TEST        | 3           | 5           | 10          |
    | EK-UMLAGER      | chargenpflichtiges Teil umlagern    | bedarfsbezogen    | Chargenverfolgung       | ja            | LIEFCHA1    | 3           | 5           | 10          |
    | INVCHIMLAGERNO  | Inventur chimlager nein             | auftragsbezogen   |                         | !dontChange   | TEST        | 3           | 5           | 10          |
    | INVCHIMLAGERYES | Inventur chimlager ja               | auftragsbezogen   |                         | !dontChange   | TEST        | 3           | 5           | 10          |
    | INVNOCHARGE     | Inventur ohne Charge                | auftragsbezogen   |                         | !dontChange   | TEST        | 3           | 5           | 10          |
    | KOPPELNOCHARGE  | Koppelprodukt ohne Charge           | bedarfsbezogen    |                         | !dontChange   | TEST        | 3           | 5           | 10          |
    | KOPPELCHARGE    | Koppelprodukt mit Charge            | bedarfsbezogen    | Chargenverfolgung       | !dontChange   | TEST        | 3           | 5           | 10          |
    | EKBEI           | chargenpflichtiges Beistellteil     | bedarfsbezogen    | Chargenverfolgung       | ja            | TEST        | 3           | 5           | 10          |
    | SET_KOMP01_CH   | chargenpflichtig Setkomponente 1    | bedarfsbezogen    | Chargenverfolgung       | ja            | TEST        | 3           | 5           | 10          |
    | SET_KOMP02_CH   | chargenpflichtig Setkomponente 2    | bedarfsbezogen    | Chargenverfolgung       | ja            | TEST        | 3           | 5           | 10          |


Scenario Outline: Baugruppen mit zwei Komponenten und zwei Arbeitsgängen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such          | <such>            |
    | namebspr      | <namebspr>        |
    | dispoa        | <dispoa>          |
    | bsart         | Eigenfertigung    |
    | chverfolgung  | <chverfolgung>    |
And I delete all rows
And I append rows
    | elex      | anzahl    | ikompeig      | manbu         |
    | <elex1>   | <anzahl1> | !dontChange   | <manbu>       |
    | <elex2>   | <anzahl2> | <ikompeig>    | !dontChange   |
    | <elex3>   | <anzahl3> | !dontChange   | !dontChange   |
    | <elex4>   | <anzahl4> | !dontChange   | !dontChange   |
And I save the current editor
Examples:
    | such              | namebspr                          | dispoa          | chverfolgung            | elex1          | anzahl1 | elex2          | ikompeig      | manbu | anzahl2   | elex3          | anzahl3   | elex4   | anzahl4 |
    | BG01_CHARGE       | chargenpflichtige Baugruppe 1     | bedarfsbezogen  | Chargenverfolgung       | EK01_CHARGE    | 1       | A AG2          | !dontChange   | nein  | 1         | EK02_CHARGE    | 1         | A AG3   | 1       |
    | BG02_CHARGE       | chargenpflichtige Baugruppe 2     | bedarfsbezogen  | Chargenverfolgung       | EINK           | 1       | A AG2          | !dontChange   | nein  | 1         | BAUT           | 1         | A AG3   | 1       |
#    | BG_CHARGE_KOPPEL  | chargenpflicht BG Koppelprodukt   | bedarfsbezogen  | Chargenverfolgung       | EK01_CHARGE    | 1       | KOPPELNOCHARGE | Koppelprodukt | nein | 1         | A AG2          | 1         | A AG3   | 1       |
#    | BG_KOPPEL_CHARGE  | chargenpflicht BG Koppelprodukt   | bedarfsbezogen  | Chargenverfolgung       | EK01_CHARGE    | 1       | KOPPEL_CHARGE  | Koppelprodukt | nein | 1         | A AG2          | 1         | A AG3   | 1       |
    | BG_CHARGE_KOPPEL  | chargenpflicht BG Koppelprodukt   | bedarfsbezogen  | Chargenverfolgung       | EK01_CHARGE    | 1       | KOPPELCHARGE   | Koppelprodukt | nein  | 1         | A AG2          | 1         | A AG3   | 1       |
    | BG_M_CHARGE       | chargenpflichtige Baugruppe 1     | bedarfsbezogen  | Chargenverfolgung       | EK01_CHARGE    | 1       | A AG2          | !dontChange   | ja    | 1         | EK02_CHARGE    | 1         | A AG3   | 1       |
    | BG03_SN           | seriennrpflichtige Baugruppe 3    | bedarfsbezogen  | Seriennummernverfolgung | EK04_SN        | 1       | A AG2          | !dontChange   | ja    | 1         | BAUT           | 1         | A AG3   | 1       |


Scenario Outline: Baugruppen chargenrein mit einer Komponente und zwei Arbeitsgängen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set fields
    | such              | <such>            |
    | namebspr          | <namebspr>        |
    | dispoa            | <dispoa>          |
    | bsart             | Eigenfertigung    |
    | chverfolgung      | <chverfolgung>    |
    | chargenreinstd    | <chargenreinstd>  |
And I delete all rows
And I append rows
    | elex      | anzahl    |
    | <elex1>   | <anzahl1> |
    | <elex2>   | <anzahl2> |
    | <elex3>   | <anzahl3> |
And I save the current editor
Examples:
    | such              | namebspr              | dispoa          | chverfolgung        | chargenreinstd    | elex1 | anzahl1 | elex2   | anzahl2   | elex3   | anzahl3 |
    | BG_CHA_REIN_MANBU | chargenrein manbu     | bedarfsbezogen  | Chargenverfolgung   | ja                | EINK  | 1       | A AG2   | 1         | A AG3   | 1       |
    | BG_CHA_REIN_RETRO | chargenrein retrograd | bedarfsbezogen  | Chargenverfolgung   | ja                | EINK  | 1       | A AG2   | 1         | A AG3   | 1       |

Scenario: Einkaufsartikel mit Beistellung und Setartikel anlegen

Given I open an editor "KT-BEISTELL" from table "(Part):(Product)" with command "STORE" for record "KT-BEISTELL"
And I set fields
    | such          | KT-BEISTELL                |
    | namebspr      | Kaufteil mit Beistellung   |
    | bsart         | Fremdbeschaffung           |
    | lief          | LIEFCHA2                   |
    | chverfolgung  | Chargenverfolgung          |
And I delete all rows
And I append rows
    | elex  | elanzahl  | bua                       |
    | EKBEI | 1         | Lieferantenbeistellung    |
And I save the current editor

Given I open an editor "SET-CHARGE" from table "(Part):(Product)" with command "STORE" for record "SET-CHARGE"
And I set fields
    | such          | SET-CHARGE                    |
    | namebspr      | chargenpflichtiger Setartikel |
    | earta         | über Stückliste               |
    | chverfolgung  | Chargenverfolgung             |
And I delete all rows
And I append rows
    | elex          | elanzahl  |
    | SET_KOMP01_CH | 1         |
    | SET_KOMP02_CH | 2         |
And I save the current editor

Scenario: Baugruppe anlegen

# Baugruppe mit 2 Komponenten und 3 Arbeitsgaengen anlegen
Given I open an editor "BG01_CHARGE" from table "(Part):(Product)" with command "COPY" for record "BG01_CHARGE"
And I set fields
    | such          | BG03_CHARGE                |
    | namebspr      | Baugruppe 3 Arbeitsgaenge  |
    | bsart         | Eigenfertigung             |
    | chverfolgung  | Chargenverfolgung          |
And I append rows
    | elex  | elanzahl  |
    | A AG2 | 1         |
And I save the current editor

# Baugruppe mit 1 Komponente retrograd und 1 Arbeitsgang anlegen
Given I open an editor "BG01_CHARGE" from table "(Part):(Product)" with command "COPY" for record "BG01_CHARGE"
And I set fields
    | such          | BG11_CHARGE                |
    | namebspr      | Baugruppe 1 Mat und 1 AG   |
    | bsart         | Eigenfertigung             |
    | chverfolgung  | Chargenverfolgung          |
And I delete row at position 4
And I delete row at position 3
And I save the current editor
#
#
#
################################################################################
### neue Fälle zu FBU mit zcharge, s. FDA-5067
#
##  zcha01 Fall 1 - keine MZ, keine Kopfcharge, keine Zeilencharge, MZ in FBU erfassen
#    # gmgevorschl = 3, Menge FV = 5, bumge = 3, gebucht => 3
##  zcha02 Fall 2 - keine MZ, FBU Kopfcharge, Zeilencharge = Kopfcharge und schreibgeschützt, MZ = Kopfcharge und schreibgeschützt, Entnahmecharge in der FBU-MZ erfassen
#        # gmgevorschl = 3, Menge FV = 5, bumge = 3, gebucht => 3
##  Fall 3 - MZ mit zcharge, FBU Kopfcharge anders als MZ, Zeilencharge = Kopfcharge und schreibgeschützt, MZ wie angelegt, ncharge LJ wie zcharge aus MZ
#        # gmgevorschl = 3, Menge FV = 5, bumge = 3, gebucht => 3
##  Fall 4 - MZ mit zcharge, FBU ohne Kopfcharge, Zeilencharge, irgendeine eintragen, MZ wie angelegt, ncharge LJ wie zcharge aus MZ
#        # gmgevorschl = 0, Menge FV = 5, bumge = 5, gebucht => 5
##  Fall 5 - MZ ohne zcharge, FBU Kopfcharge, Zeilencharge = Kopfcharge und schreibgeschützt, MZ nur Entnahmecharge wie angelegt, ncharge LJ ist Kopfcharge
#        # gmgevorschl = 0, Menge FV = 5, bumge = 5, gebucht => 5
##  Fall 6 - MZ mit zcharge, aber nur 3 weil 2 bereits entnommen, FBU Kopfcharge anders als MZ, Zeilencharge = Kopfcharge und schreibgeschützt, MZ weitere Zeile mit 2 und passender zcharge vorbelegt, ncharge LJ 3 aus MZ und 2 aus Kopfcharge
#        # gmgevorschl = 5, Menge FV = 10, bumge = 5, gebucht => 5
#        # vorher schon 2 entnehmen und MZ nur für 5 statt 10
#
#    # Fälle mit "Restmenge stornieren" und "Restmenge mitbuchen" erweitern oder neue Fälle anlegen
#
Scenario: ZCHA01 zcharge in der FBU - keine MZ, keine Kopfcharge, keine Zeilencharge, in der FBU die MZ erfassen

Given I create a work order "ZCHA01" for Product "BG_M_CHARGE" with quantity "5" and search word "ZCHA01_"

Given I create a Lot "ZCHA01_ZU" for Product "BG_M_CHARGE"

# FBU mit Mengenvorschlag und Angabe Kopfcharge
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | ZCHA01_001    |
    | gmgevorschl   | 3             |
    | bem           | Entnahme      |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu | treszcharge   | tvcharge  |
    | EK01_CHARGE   | 3     | ja    |               |           |
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
And I modify table
    | !row  | zuomge    | zcharge       | tcharge       |
    | 1     | 1         | !ZCHA01_ZU^id | ZCHA01_AB1    |
    | +2    | 2         | !ZCHA01_ZU^id | ZCHA01_AB2    |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# gebuchte Materialentnahme oeffnen um Zugriff auf Belegnummer barmex zu haben
Given I open an editor "FBUBELEG" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZCHA01_001;bem=Entnahme;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "barmex" in row 0
And I close the current editor

Given I open an editor "ZCHA01_AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=ZCHA01_AB1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "ZCHA01_AB2" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=ZCHA01_AB2;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

# ncharge ist Kopfcharge
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | amge     | tvcharge    | vcharge^id     | tncharge  | ncharge^id    |
    | 1        | ZCHA01_AB1  | !ZCHA01_AB1^id | ZCHA01_ZU | !ZCHA01_ZU^id |
    | 2        | ZCHA01_AB2  | !ZCHA01_AB2^id | ZCHA01_ZU | !ZCHA01_ZU^id |
And I close the current editor


Scenario: ZCHA02 zcharge in der FBU - keine MZ, FBU mit Kopfcharge, Zeilencharge vorbelegt und schreibgeschuetzt, Entnahmecharge in der MZ der FBU erfassen

Given I create a work order "ZCHA02" for Product "BG_M_CHARGE" with quantity "5" and search word "ZCHA02_"

Given I create a Lot "ZCHA02_ZU" for Product "BG_M_CHARGE"

# FBU mit Mengenvorschlag und Angabe Kopfcharge
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | ZCHA02_001    |
    | gmgevorschl   | 3             |
    | bem           | Entnahme      |
    | charge        | !ZCHA02_ZU^id |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu | reszcharge^id | tvcharge  |
    | EK01_CHARGE   | 3     | ja    | !ZCHA02_ZU^id |           |
Then field "reszcharge" is not modifiable in row 1
Then field "treszcharge" is not modifiable in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
Then table has values
    | zcharge^id    | charge    |
    | !ZCHA02_ZU^id |           |
Then field "zcharge" is not modifiable in row 1
And I close the current subeditor to switch back to the parent editor
And I set field "tvcharge" to "ZCHA02_AB1" in row 1
And I save the current editor

# gebuchte Materialentnahme oeffnen um Zugriff auf Belegnummer barmex zu haben
Given I open an editor "FBUBELEG" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZCHA02_001;bem=Entnahme;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "barmex" in row 0
And I close the current editor

Given I open an editor "ZCHA02_AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=ZCHA02_AB1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

# ncharge ist Kopfcharge
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | amge     | tvcharge    | vcharge^id     | tncharge  | ncharge^id    |
    | 3        | ZCHA02_AB1  | !ZCHA02_AB1^id | ZCHA02_ZU | !ZCHA02_ZU^id |
And I close the current editor


Scenario: ZCHA03 zcharge in der FBU - MZ mit zcharge, FBU Kopfcharge anders als MZ, Zeilencharge = Kopfcharge und schreibgeschützt, MZ wie angelegt, ncharge LJ wie zcharge aus MZ

Given I create a work order "ZCHA03" for Product "BG_M_CHARGE" with quantity "5" and search word "ZCHA03_"

Given I create a Lot "ZCHA03_ZU" for Product "BG_M_CHARGE"
Given I create a Lot "ZCHA03_ANDERE" for Product "BG_M_CHARGE"

# EntnahmeMZ anlegen, mit zcharge
Given I open an editor "ZCHA03" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZCHA03_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       | zcharge       |
    | +1    | F1     | 2        | ZCHA03_AB1    | !ZCHA03_ZU^id |
    | +2    | F1     | 3        | ZCHA03_AB2    | !ZCHA03_ZU^id |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       | zcharge       |
    | +1    | F1     | 2        | ZCHA03_AB3    | !ZCHA03_ZU^id |
    | +2    | F1     | 3        | ZCHA03_AB4    | !ZCHA03_ZU^id |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "ZCHA03"
And I save the current editor

# FBU mit Mengenvorschlag und Angabe Kopfcharge
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | ZCHA03_001        |
    | gmgevorschl   | 3                 |
    | bem           | Entnahme          |
    | charge        | !ZCHA03_ANDERE^id |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu | reszcharge^id     | tvcharge  |
    | EK01_CHARGE   | 3     | ja    | !ZCHA03_ANDERE^id |           |
Then field "reszcharge" is not modifiable in row 1
Then field "treszcharge" is not modifiable in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
Then table has values
    | zuomge    | zcharge^id    | tcharge       |
    | 2         | !ZCHA03_ZU^id | ZCHA03_AB1    |
    | 3         | !ZCHA03_ZU^id | ZCHA03_AB2    |
And I close the current subeditor to switch back to the parent editor
# Zugangscharge in der MZ des FV und der Zeile der RES (reszcharge) unterscheiden sich -> Rückfrage
And I respond with answer "ja" to the dialog with id "Widersprüchliche Angaben in Chargen/SN für das Fertigteil in der Materialentnahme und MZ. Trotzdem lt. MZ buchen?"
And I save the current editor

# gebuchte Materialentnahme oeffnen um Zugriff auf Belegnummer barmex zu haben
Given I open an editor "FBUBELEG" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZCHA03_001;bem=Entnahme;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "barmex" in row 0
And I close the current editor

Given I open an editor "ZCHA03_AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=ZCHA03_AB1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "ZCHA03_AB2" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=ZCHA03_AB2;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

# ncharge ist zcharge aus MZ und nicht die Kopfcharge
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | tncharge  | ncharge^id    | amge     | tvcharge    | vcharge^id     |
    | ZCHA03_ZU | !ZCHA03_ZU^id | 2        | ZCHA03_AB1  | !ZCHA03_AB1^id |
    | ZCHA03_ZU | !ZCHA03_ZU^id | 1        | ZCHA03_AB2  | !ZCHA03_AB2^id |
And I close the current editor

# es gab noch keine Rueckmeldung und entnommen wurden 3, also noch 2 offen, Kopfcharge in der Rueckmeldung ist anders als in der MZ
Given I open an editor "RM1_ZCHA03" from table "(Workorder):(WorkOrders)" with command "DONE" for record "ZCHA03_001"
And I set fields
    | sofort    | ja            |
    | bem       | RM1_ZCHA03    |
    | tkcharge  | CHARGE_AUS_RM |
    | manrest   | ja            |
And I set field "gutmge" to "5" in row 1
And I save the current editor

Given I open an editor "CHARGE_AUS_RM" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=CHARGE_AUS_RM;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

### noch zu klaeren
### ncharge aus MZ oder aus Kopfcharge der RM
#And I open the infosystem "LJ"
#And I set field "adatum" to "."
#And I set field "beleg" to "!RM1_ZCHA03^barmex"
#And I set field "artikel" to "EK01_CHARGE"
#And I set field "richtung" to "rückwärts"
#And I press start
#Then table has values
#    | tncharge        | ncharge^id        | amge     | tvcharge    | vcharge^id     |
#    | CHARGE_AUS_RM   | !CHARGE_AUS_RM^id | 2        | ZCHA03_AB2  | !ZCHA03_AB2^id |
#	 | ZCHA03_ZU       | !ZCHA03_ZU^id     | 2        | ZCHA03_AB2  | !ZCHA03_AB2^id |
#And I close the current editor


Scenario: ZCHA04 zcharge in der FBU - MZ mit zcharge, FBU ohne Kopfcharge, Zeilencharge eine der angelegten zchargen, MZ wie angelegt, ncharge LJ wie zcharge aus MZ

Given I create a work order "ZCHA04" for Product "BG_M_CHARGE" with quantity "5" and search word "ZCHA04_"

Given I create a Lot "ZCHA04_ZU" for Product "BG_M_CHARGE"
Given I create a Lot "ZCHA04_ZU2" for Product "BG_M_CHARGE"

# EntnahmeMZ anlegen, mit zcharge
Given I open an editor "ZCHA04" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZCHA04_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       | zcharge        |
    | +1    | F1     | 2        | ZCHA04_AB1    | !ZCHA04_ZU^id  |
    | +2    | F1     | 3        | ZCHA04_AB2    | !ZCHA04_ZU2^id |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       | zcharge        |
    | +1    | F1     | 2        | ZCHA04_AB3    | !ZCHA04_ZU^id  |
    | +2    | F1     | 3        | ZCHA04_AB4    | !ZCHA04_ZU2^id |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "ZCHA04"
And I save the current editor

# FBU ohne Kopfcharge
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | ZCHA04_001        |
    | bem           | Entnahme          |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu | treszcharge   | tvcharge  |
    | EK01_CHARGE   | 5     | ja    |               |           |
Then field "reszcharge" is modifiable in row 1
Then field "treszcharge" is modifiable in row 1
And I set field "reszcharge" to "!ZCHA04_ZU2^id" in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
Then table has values
    | zuomge    | zcharge^id     | tcharge       |
    | 2         | !ZCHA04_ZU^id  | ZCHA04_AB1    |
    | 3         | !ZCHA04_ZU2^id | ZCHA04_AB2    |
And I close the current subeditor to switch back to the parent editor
# Zugangscharge in der MZ des FV und der Zeile der RES (reszcharge) unterscheiden sich -> Rückfrage
And I respond with answer "ja" to the dialog with id "Widersprüchliche Angaben in Chargen/SN für das Fertigteil in der Materialentnahme und MZ. Trotzdem lt. MZ buchen?"
And I save the current editor

# gebuchte Materialentnahme oeffnen um Zugriff auf Belegnummer barmex zu haben
Given I open an editor "FBUBELEG" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZCHA04_001;bem=Entnahme;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "barmex" in row 0
And I close the current editor

Given I open an editor "ZCHA04_AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=ZCHA04_AB1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "ZCHA04_AB2" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=ZCHA04_AB2;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

# ncharge ist zcharge aus MZ
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | tncharge   | ncharge^id     | amge     | tvcharge    | vcharge^id     |
    | ZCHA04_ZU  | !ZCHA04_ZU^id  | 2        | ZCHA04_AB1  | !ZCHA04_AB1^id |
    | ZCHA04_ZU2 | !ZCHA04_ZU2^id | 3        | ZCHA04_AB2  | !ZCHA04_AB2^id |
And I close the current editor


Scenario: ZCHA05 zcharge in der FBU - MZ ohne zcharge, FBU Kopfcharge, Zeilencharge = Kopfcharge und schreibgeschützt, MZ nur Entnahmecharge wie angelegt, ncharge LJ ist Kopfcharge

Given I create a work order "ZCHA05" for Product "BG_M_CHARGE" with quantity "5" and search word "ZCHA05_"

# EntnahmeMZ anlegen, Zugangscharge nicht angeben
Given I open an editor "ZCHA05" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZCHA05_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | F1     | 3        | ZCHA05_AB1    |
    | +2    | F1     | 2        | ZCHA05_AB2    |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | F1     | 3        | ZCHA05_AB3    |
    | +2    | F1     | 2        | ZCHA05_AB4    |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "ZCHA05"
And I save the current editor

Given I create a Lot "ZCHA05_ZU" for Product "BG_M_CHARGE"

# FBU ohne Mengenvorschlag, mit Angabe Kopfcharge
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | ZCHA05_001    |
    | bem           | Entnahme      |
    | charge        | !ZCHA05_ZU^id |
And I press button "stlvblad"
Then table has values
    | elex          | manbu | reszcharge^id | tvcharge  |
    | EK01_CHARGE   | ja    | !ZCHA05_ZU^id |           |
Then field "reszcharge" is not modifiable in row 1
Then field "treszcharge" is not modifiable in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
Then table has values
    | zcharge | tcharge       |
    |  		  | ZCHA05_AB1    |
    |         | ZCHA05_AB2    |
Then field "zcharge" is not modifiable in row 1
And I close the current subeditor to switch back to the parent editor
And I set field "bumge" to "5" in row 1
And I set field "tvcharge" to "ZCHA05_AB1" in row 1
And I save the current editor

# gebuchte Materialentnahme oeffnen um Zugriff auf Belegnummer barmex zu haben
Given I open an editor "FBUBELEG" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZCHA05_001;bem=Entnahme;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "barmex" in row 0
And I close the current editor

Given I open an editor "ZCHA05_AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=ZCHA05_AB1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "ZCHA05_AB2" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=ZCHA05_AB2;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

# ncharge ist Kopfcharge
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | amge     | tvcharge    | vcharge^id     | tncharge  | ncharge^id    |
    | 3        | ZCHA05_AB1  | !ZCHA05_AB1^id | ZCHA05_ZU | !ZCHA05_ZU^id |
    | 2        | ZCHA05_AB2  | !ZCHA05_AB2^id | ZCHA05_ZU | !ZCHA05_ZU^id |
And I close the current editor


Scenario: ZCHA06 zcharge in der FBU - MZ mit zcharge, aber nur 3 weil 2 bereits entnommen, FBU Kopfcharge anders als MZ, Zeilencharge = Kopfcharge und schreibgeschützt, MZ weitere Zeile mit 2 und passender zcharge vorbelegt, ncharge LJ 3 aus MZ und 2 aus Kopfcharge
        # gmgevorschl = 5, Menge FV = 10, bumge = 5, gebucht => 5
        # vorher schon 2 entnehmen und MZ nur für 5 statt 10

Given I create a work order "ZCHA06" for Product "BG_M_CHARGE" with quantity "10" and search word "ZCHA06_"

Given I create a Lot "ZCHA06_ZU" for Product "BG_M_CHARGE"
Given I create a Lot "ZCHA06_ANDERE" for Product "BG_M_CHARGE"

# EntnahmeMZ anlegen, mit zcharge
Given I open an editor "ZCHA06" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZCHA06_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       | zcharge       |
    | +1    | F1     | 2        | ZCHA06_AB1    | !ZCHA06_ZU^id |
    | +2    | F1     | 3        | ZCHA06_AB2    | !ZCHA06_ZU^id |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       | zcharge       |
    | +1    | F1     | 2        | ZCHA06_AB3    | !ZCHA06_ZU^id |
    | +2    | F1     | 3        | ZCHA06_AB4    | !ZCHA06_ZU^id |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "ZCHA06"
And I save the current editor

# FBU ueber 2 Stueck, ohne weitere Angaben
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | ZCHA06_001        |
    | gmgevorschl   | 2                 |
    | bem           | Entnahme          |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu |
    | EK01_CHARGE   | 2     | ja    |
And I save the current editor

# FBU mit Mengenvorschlag und Angabe Kopfcharge
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | ZCHA06_001        |
    | gmgevorschl   | 5                 |
    | bem           | Entnahme          |
    | charge        | !ZCHA06_ANDERE^id |
And I press button "stlvblad"
Then table has values
    | elex          | bumge | manbu | reszcharge^id     | tvcharge  |
    | EK01_CHARGE   | 5     | ja    | !ZCHA06_ANDERE^id |           |
Then field "reszcharge" is not modifiable in row 1
Then field "treszcharge" is not modifiable in row 1
And I press button "mzsubm" to open a subeditor for "MZ" in row 1
# fuer 3 Stueck zcharge us der angelegten MZ und fuer restliche 2 neue Zeile mit zcharge aus der Kopfcharge
Then table has values
    | zuomge    | zcharge^id        | tcharge       |
    | 3         | !ZCHA06_ZU^id     | ZCHA06_AB2    |
# neue MZ-Zeile anlegen fuer die restliche Menge, zcharge ist schreibgeschuetzt, wird NICHT vorbelegt, wird gebucht aus der Kopf- bzw. Zeilenangabe
And I append rows
    | zuomge    | tcharge       |
    | 2         | ZCHA06_AB2neu |
Then field "zcharge" is not modifiable in row 2	
And I save the current subeditor to switch back to the parent editor
And I respond with answer "ja" to the dialog with id "Widersprüchliche Angaben in Chargen/SN für das Fertigteil in der Materialentnahme und MZ. Trotzdem lt. MZ buchen?"
And I save the current editor

# gebuchte Materialentnahme oeffnen um Zugriff auf Belegnummer barmex zu haben
Given I open an editor "FBUBELEG" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZCHA06_001;bem=Entnahme;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "barmex" in row 0
And I close the current editor

Given I open an editor "ZCHA06_AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=ZCHA06_AB1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "ZCHA06_AB2" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=ZCHA06_AB2;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "ZCHA06_AB2neu" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=ZCHA06_AB2neu;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

# 2 Stueck aus erster RM und weitere 5 aus 2. RM: ncharge ist zcharge aus MZ fuer 3 Stueck, die noch angelegt war und fuer weitere Mengen aus der Kopfcharge
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | tncharge      | ncharge^id        | amge     | tvcharge        | vcharge^id        |
    | ZCHA06_ZU     | !ZCHA06_ZU^id     | 2        | ZCHA06_AB1      | !ZCHA06_AB1^id    |
    | ZCHA06_ZU     | !ZCHA06_ZU^id     | 3        | ZCHA06_AB2      | !ZCHA06_AB2^id    |
    | ZCHA06_ANDERE | !ZCHA06_ANDERE^id | 2        | ZCHA06_AB2neu   | !ZCHA06_AB2neu^id |
And I close the current editor


Scenario: ZCHA05A zcharge in der FBU - MZ ohne zcharge, FBU Kopfcharge, MZ nur Entnahmecharge wie angelegt, FBU mit stornorest, MZ wird geloescht

Given I create a work order "ZCHA05A" for Product "BG_M_CHARGE" with quantity "5" and search word "ZCHA05A_"

# EntnahmeMZ anlegen, Zugangscharge nicht angeben
Given I open an editor "ZCHA05A" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZCHA05A_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | F1     | 3        | ZCHA05A_AB1   |
    | +2    | F1     | 2        | ZCHA05A_AB2   |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | tcharge       |
    | +1    | F1     | 3        | ZCHA05A_AB3   |
    | +2    | F1     | 2        | ZCHA05A_AB4   |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "ZCHA05A"
And I save the current editor

Given I create a Lot "ZCHA05A_ZU" for Product "BG_M_CHARGE"

# FBU ohne Mengenvorschlag, mit Angabe Kopfcharge und Restmenge stornieren
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | ZCHA05A_001       |
    | bem           | Entnahme          |
    | charge        | !ZCHA05A_ZU^id    |
And I press button "stlvblad"
Then table has values
    | elex          | manbu | reszcharge^id     | rescharge |
    | EK01_CHARGE   | ja    | !ZCHA05A_ZU^id    |           |
And I set field "bumge" to "4" in row 1
Then field "rescharge" is modifiable in row 1
And I set field "tvcharge" to "ZCHA05A_AB1" in row 1
And I press button "stornorest"
And I save the current editor

# gebuchte Materialentnahme oeffnen um Zugriff auf Belegnummer barmex zu haben
Given I open an editor "FBUBELEG" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZCHA05A_001;bem=Entnahme;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "barmex" in row 0
And I close the current editor

Given I open an editor "ZCHA05A_AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=ZCHA05A_AB1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

Given I open an editor "ZCHA05A_AB2" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=ZCHA05A_AB2;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

# ncharge ist Kopfcharge
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | amge     | tvcharge    | vcharge^id        | tncharge      | ncharge^id        |
    | 3        | ZCHA05A_AB1 | !ZCHA05A_AB1^id   | ZCHA05A_ZU    | !ZCHA05A_ZU^id    |
    | 1        | ZCHA05A_AB2 | !ZCHA05A_AB2^id   | ZCHA05A_ZU    | !ZCHA05A_ZU^id    |
And I close the current editor

# keine EntnahmeMZ mehr vorhanden fuer das Material zun ersten Arbeitsschein
Given I open an editor "ZCHA05A" from table "(Workorder):(WorkOrders)" with command "VIEW" for record "ZCHA05A_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
Then the table has 0 rows
And I press button for next product
Then table has values
    | zuomge   | tcharge       |
    | 3        | ZCHA05A_AB3   |
    | 2        | ZCHA05A_AB4   |
And I close the current editor
And I switch the current editor to editor "AFL"
And I close the current editor
And I switch the current editor to editor "ZCHA05A"
And I close the current editor


Scenario: ZCHA07 zcharge in der FBU - Keine MZ an Entnahmen vorhanden, FBU Kopfcharge und Entnahmecharge, FBU mit voller Entnahme, STL editieren

Given I create a work order "ZCHA07" for Product "BG_M_CHARGE" with quantity "6" and search word "ZCHA07_"

# Manuelle Entnahme setzen
Given I open an editor "ZCHA07" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZCHA07_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I save the current editor
And I switch the current editor to editor "ZCHA07"
And I save the current editor

Given I create a Lot "ZCHA07_ZU" for Product "BG_M_CHARGE"
Given I create a Lot "ZCHA07_AB1" for Product "EK01_CHARGE"
Given I create a Lot "ZCHA07_AB2" for Product "EK02_CHARGE"

# FBU ohne Mengenvorschlag, mit Angabe Kopfcharge für Zugang und Entnahmecharge in der Zeile
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | ZCHA07_001    |
    | bem           | Entnahme      |
    | charge        | !ZCHA07_ZU^id |
And I press button "stlvblad"
Then table has values
    | elex          | manbu | reszcharge^id |
    | EK01_CHARGE   | ja    | !ZCHA07_ZU^id |
And I set field "rescharge" to "ZCHA07_AB1" in row 1
And I save the current editor

# gebuchte Materialentnahme oeffnen um Zugriff auf Belegnummer barmex zu haben
Given I open an editor "FBUBELEG" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=ZCHA07_001;bem=Entnahme;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "barmex" in row 0
And I close the current editor

Given I open an editor "ZCHA07_AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=ZCHA07_AB1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

# ncharge ist Kopfcharge
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "EK01_CHARGE"
And I press start
Then table has values
    | amge     | tvcharge   | vcharge^id     | tncharge  | ncharge^id    |
    | 6        | ZCHA07_AB1 | !ZCHA07_AB1^id | ZCHA07_ZU | !ZCHA07_ZU^id |
And I close the current editor

# Entnahmecharge steht in der STL-Zeile, limge=0. Beim Speichern darf keine MZ mit Menge = 0 angelegt werden, sonst DIAG
Given I open an editor "ZCHA07" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZCHA07_000"
And I press button "absteig" to open a subeditor for "AFL"
Then the table has 4 rows
Then table has values
    | elex        | mge | limge | frgmge |
    | EK01_CHARGE |   6 |     0 |      0 |
    | A AG2       |   6 |     6 |      6 |
    | EK02_CHARGE |   6 |     6 |      6 |
    | A AG3       |   6 |     6 |      6 |
And I set field "charge" to "ZCHA07_AB1" in row 1
And I set field "zcharge" to "ZCHA07_ZU" in row 1
And I save the current editor
And I switch the current editor to editor "ZCHA07"
And I close the current editor


Scenario: ZCHA08 zcharge in der FBU - Test der Restmengen bei Mehrentnahme - MZ an Entnahmen vorhanden
# UA-728: Materialentnahme: Neuer Rest beim Laden von Überbuchungen für chpflichtige Teile falsch

Given I create a work order "ZCHA08" for Product "BG_M_CHARGE" with quantity "8" and search word "ZCHA08_"

Given I create a Lot "ZCHA08_ZU" for Product "BG_M_CHARGE"
Given I create a Lot "ZCHA08_AB1" for Product "EK01_CHARGE"
Given I create a Lot "ZCHA08_AB2" for Product "EK02_CHARGE"

# Zu- und Abgangschargen erfassen
Given I open an editor "ZCHA08MZ" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZCHA08_000"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ"
And I modify table
    | !row  | lpsuch | zuomge   | charge        |
    | +1    | F1     | 8        | !ZCHA08_ZU^id |
And I save the current editor
And I switch the current editor to editor "ZCHA08MZ"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | ztcharge       |
    | +1    | F1     | 8        | !ZCHA08_AB1^id |
And I press button for next product
And I modify table
    | !row  | lpsuch | zuomge   | ztcharge       |
    | +1    | F1     | 8        | !ZCHA08_AB2^id |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "ZCHA08MZ"
And I save the current editor

# FBU ohne Mengenvorschlag, ohne Angabe Kopfcharge für Zugang
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | ZCHA08_002    |
    | maxofmge      | nein          |
    | autorment     | ja            |
    | gmgevorschl   | 11            |
    | bem           | Mehrentnahme  |
And I press button "stllad"
Then table has values
    | elex          | manbu | bumge | nlimge |
    | EK01_CHARGE   | ja    | 11    | -3     |
    | EK02_CHARGE   | nein  | 11    | -3     |
And I close the current editor

# FBU ohne Mengenvorschlag, mit Angabe Kopfcharge für Zugang
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | ZCHA08_002    |
    | maxofmge      | nein          |
    | autorment     | ja            |
    | gmgevorschl   | 11            |
    | charge        | !ZCHA08_ZU^id |
    | bem           | Mehrentnahme  |
And I press button "stllad"
Then table has values
    | elex          | manbu | bumge | nlimge |
    | EK01_CHARGE   | ja    | 11    | -3     |
    | EK02_CHARGE   | nein  |  0    |  8     |
And I close the current editor


Scenario: ZCHA09 FT ohne charge in der FBU - Test der Buchungs- und Restmengen - MZ an Entnahmen vorhanden

Given I create a work order "ZCHA08" for Product "BG1" with quantity "9" and search word "ZCHA09_"

Given I create a Lot "ZCHA09_AB1" for Product "EK01_CHARGE"

# Zu- und Abgangschargen erfassen
Given I open an editor "ZCHA09MZ" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "ZCHA09_000"
And I press button "absteig" to open a subeditor for "AFL"
And I modify table
    | !row | elex        | anzahl    | manbu |
    | +1   | EK01_CHARGE | 1         | ja    |
And I press button "mzsubm" to open a subeditor for "EntnahmeMZ" in row 1
And I modify table
    | !row  | lpsuch | zuomge   | ztcharge       |
    | +1    | F1     | 7        | !ZCHA09_AB1^id |
And I save the current editor
And I switch the current editor to editor "AFL"
And I save the current editor
And I switch the current editor to editor "ZCHA09MZ"
And I save the current editor

# FBU mit Mengenvorschlag kleiner als Gesamtmenge
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | ZCHA09_000    |
    | gmgevorschl   | 8             |
    | maxofmge      | nein          |
    | bem           | Mehrentnahme  |
And I press button "stllad"
Then table has values
    | elex          | manbu | bumge | nlimge |
    | EK01_CHARGE   | ja    | 8     | 1      |
And I close the current editor


# FBU mit Mengenvorschlag größer als Gesamtmenge
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | ZCHA09_000    |
    | gmgevorschl   | 11            |
    | maxofmge      | nein          |
    | bem           | Mehrentnahme  |
And I press button "stllad"
Then table has values
    | elex          | manbu | bumge | nlimge |
    | EK01_CHARGE   | ja    | 11    | -2     |
And I close the current editor


Scenario: SN01 zcharge in der FBU - Keine MZ an Entnahmen vorhanden, FBU Kopfcharge und Entnahmecharge, FBU mit voller Entnehme, STL editieren
# UA-1184: Automatische MZ Anlage für SN auch bei limge = 0 nicht durchführen

Given I create a work order "SN01" for Product "BG03_SN" with quantity "1" and search word "SN01_"

Given I create a Lot "SN01_ZU" for Product "BG03_SN"
Given I create a Lot "SN01_AB1" for Product "EK04_SN"

# Manuelle Entnahme setzen, Chargen in Zeile 1 eintragen
Given I open an editor "SN01" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SN01_000"
And I press button "absteig" to open a subeditor for "AFL"
And I press button "setmanbu"
And I set field "charge" to "SN01_AB1" in row 1
And I set field "zcharge" to "SN01_ZU" in row 1
And I save the current editor
And I switch the current editor to editor "SN01"
And I save the current editor

# FBU ohne Mengenvorschlag, mit Angabe Kopfcharge für Zugang und Entnahmecharge in der Zeile
Given I open an editor "MATENT1" for tip command "Fbuchung" and arguments ""
And I set fields
    | auftrag       | SN01_001       |
    | bem           | Entnahme       |
    | charge        | !SN01_ZU^id    |
And I press button "stlvblad"
Then table has values
    | elex    | manbu | reszcharge^id     |
    | EK04_SN | ja    | !SN01_ZU^id    |
And I set field "rescharge" to "SN01_AB1" in row 1
And I save the current editor

# gebuchte Materialentnahme oeffnen um Zugriff auf Belegnummer barmex zu haben
Given I open an editor "FBUBELEG" from table "(Workorder):(CompletionConfirmations)" with command "VIEW" for search criteria "$,,such=SN01_001;bem=Entnahme;@ablage=abgelegt;@richtung=rückwärts;@maxordtreffer=1"
And I save value from field "barmex" in row 0
And I close the current editor

Given I open an editor "SN01_AB1" from table "(Lots):(Lots)" with command "VIEW" for search criteria "$,,exnum=SN01_AB1;@maxtreffer=1;@ablageart=lebendig"
And I close the current editor

# ncharge ist Kopfcharge
And I open the infosystem "LJ"
And I set field "adatum" to "."
And I set field "beleg" in row 0 to saved value
And I set field "artikel" to "EK04_SN"
And I press start
Then table has values
    | amge     | tvcharge | vcharge^id   | tncharge | ncharge^id  |
    | 1        | SN01_AB1 | !SN01_AB1^id | SN01_ZU  | !SN01_ZU^id |
And I close the current editor

# Entnahmecharge steht in der STL-Zeile, limge=0. Beim Speichern darf keine MZ mit Menge = 0 angelegt werden, sonst DIAG
Given I open an editor "SN01" from table "(Workorder):(WorkOrders)" with command "UPDATE" for record "SN01_000"
And I press button "absteig" to open a subeditor for "AFL"
Then the table has 4 rows
Then table has values
    | elex    | mge | limge | frgmge |
    | EK04_SN |   1 |     0 |      0 |
    | A AG2   |   1 |     1 |      1 |
    | BAUT    |   1 |     1 |      1 |
    | A AG3   |   1 |     1 |      1 |
And I save the current editor
And I switch the current editor to editor "SN01"
And I close the current editor

