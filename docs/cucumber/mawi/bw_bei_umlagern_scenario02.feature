# *****************************************************************************
#  Name             : bw_bei_umlagern_scenario02.feature
#  Autor            : carue
#  Verantwortlich   : carue
#  Kontrolle        : ak
#  Funktion         : Bewertungen im Umlagerungskontext (mit Transportkosten etc.)
#
# Getestet wird das Scenario aus FDA-1876:
#  - Artikel SATTEL, Bewertungsverfahren: Preis des Zugangs/Vorgangspreis
#  - Bestellung im EK (100 Stueck, Preis 15 �)
#  - EK-Lieferschein (100 Stueck, Preis 15 �)
#  - 100 Stueck Umlagern in externe Lagergruppe mit Transportkosten (3 �/Stueck)
#  - EK-Rechnung fuer Zugang (100 Stueck, 17 �)
#
# *****************************************************************************
@persistent
Feature: bw_bei_umlagern_scenario02.feature
Background:
Given I set the fake date to "12.01.95"


Scenario: 01 Artikel kopieren
Given I open an editor "SATTEL-01" from table "(Part):(Product)" with command "COPY" for record "SATTEL"
And I set field "such" to "SATTEL-01"
And I set field "chverfolgung" to ""
# Bewertungsverfahren "Preis des Zugangs/Vorgangspreis"
And I set field "ekbewverf" to "5"
And I set field "zuplatz" to "WELA"
And I set field "abplatz" to "WELA"
And I press button "alge" to open a subeditor for "LGEigenschaften"
And I append rows
    | lgruppe | dispoa                 | bsart    | mindest | umllg     | lief |
    | BERLIN  | mindestbestandsbezogen | Umlagern | 100     | KARLSRUHE | PUKY |
And I save the current subeditor to switch back to the parent editor
And I save the current editor


# Dispo starten, um Bestell- und Umlagerungsvorschlag zu erzeugen
And I run Scheduling

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 02 Sattel einkaufen
# Bestellvorschlag in LG Karlsruhe freigeben
And I open an editor "BestVor_02" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set fields
    | artikel | SATTEL-01 |
    | lgruppe | KARLSRUHE |
And I press button "ladetab"
And I set field "mfreig" to "JA" in row !lastRow
And I press button "freig" to open a subeditor for "EK_Be_02"
And I set field "lief" to "PUKY"
And I set field "such" to "EK_Be_02"
And I save the current subeditor to switch back to the parent editor
And I close the current editor


# Lieferschein buchen
Given I open an editor "EK_Ls_02" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "EK_Be_02"
And I set fields
    | nummer   | 2zu      |
    | vom      | .        |
    | ebeleg   | EK_Ls_02 |
    | ueb      | ja       |
    | erfwaehr | DEM      |
And I modify table
    | !row | mge | preis |
    | 1    | 100 | 15.00 |
And I save the current editor


# Journaleintraege pruefen
Given I open an editor "JournalZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SATTEL-01;buarta==Zugang;"
Then field "buarta" has value "Zugang"
Then field "platz" has value "WELA"
Then field "gmge" has value "100"
Then field "mge" has value "100"
And I close the current editor


# Platzmenge pruefen
Given I query StorageQuantity for Product "SATTEL-01" on StorageLocation "WELA"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 100    | Stück  | !JournalZu^id | !JournalZu^id | 100    | !JournalZu^id | !JournalZu^id |
And I close the current editor


# Bewertungen pruefen
Given I open latest Valuation "BewertungZu_01" for Product "SATTEL-01" and valuation transaction "JournalZu" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr  | addkosten | bewertet   |
    | 100  | !JournalZu^id | !JournalZu^id | 15.0000 | 0.0000    | vorläufig |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 03 Sattel umlagern in externe Lagergruppe
# Umlagerungsvorschlag
Given I open an editor "UmVor_02" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set fields
    | artikel | SATTEL-01 |
    | lgruppe |           |
And I press button "ladetab"
And I modify table
    | !row | mge |  mfreig |
    | 1    | 100 |  ja     |
And I press button "freig" to open a subeditor for "EK_UMBe_02"
And I set field "such" to "Uml_02"
And I save the current subeditor to switch back to the parent editor
And I close the current editor


# Lieferschein buchen
Given I open an editor "EK_Umlief_02" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "EK_UMBe_02"
And I set fields
    | nummer   | 2um1         |
    | vom      | .            |
    | ebeleg   | EK_Umlief_02 |
    | ueb      | ja           |
    | erfwaehr | DEM          |
And I modify table
    | !row | mge | preis |
    | 1    | 100 | 2.00  |
And I save the current editor


# Journaleintraege pruefen
Given I open an editor "JournalUmAb" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SATTEL-01;buarta==Abgang;detursache==Umlagerungslieferschein Einkauf;"
Then field "buarta" has value "Abgang"
Then field "gmge" has value "100"
Then field "mge" has value "100"
Then field "platz" has value "WELA"
Then table has values
    | mge | lj^id         | orig^id       | bewmge | bewlj^id      | beworig^id    |
    | 100 | !JournalZu^id | !JournalZu^id | 100    | !JournalZu^id | !JournalZu^id |
And I close the current editor

Given I open an editor "JournalUmZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SATTEL-01;buarta==Zugang;detursache==Umlagerungslieferschein Einkauf"
Then field "buarta" has value "Zugang"
Then field "gmge" has value "100"
Then field "mge" has value "100"
Then field "platz" has value "L3F1"
And I close the current editor


# Platzmengen pruefen
Given I query StorageQuantity for Product "SATTEL-01" on StorageLocation "WELA"
Then StorageQuantity is zero
And I close the current editor

Given I query StorageQuantity for Product "SATTEL-01" on StorageLocation "L3F1"
Then StorageQuantities have values
    | gebmge | gebeinh | lj^id           | orig^id       | bewmge | bewlj^id        | beworig^id    |
    | 100    | Stück  | !JournalUmZu^id | !JournalZu^id | 100    | !JournalUmZu^id | !JournalZu^id |
And I close the current editor


# Umlagerungsbewertungen pruefen - wichtig ist der Status
Given I open latest Valuation "BewertungUmAb_01" for Product "SATTEL-01" and valuation transaction "JournalUmAb" with command "VIEW"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Umlagerungslieferschein Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "umlkostenvorh" has value "ja"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr  | addkosten | bewertet   |
    | 100  | !JournalZu^id | !JournalZu^id | 15.0000 | 0.0000    | vorläufig |
And I close the current editor

# Da der Originalzugang noch nicht berechnet wurde, darf die Zugangsbewertung nicht direkt bewertet sein
# Das darf erst nach Verbuchen der Rechnung auf den Zugang passieren
Given I open latest Valuation "BewertungUmZu_01" for Product "SATTEL-01" and valuation transaction "JournalUmZu" with command "VIEW"
Then field "buart" has value "Zugang"
Then field "detursache" has value "Umlagerungslieferschein Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "umlkostenvorh" has value "ja"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr  | addkosten | bewertet   |
    | 100  | !JournalZu^id | !JournalZu^id | 17.0000 | 2.0000    | vorläufig |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 04 Umlagerungsrechnung buchen (Transportkosten)
Given I open an editor "EK_Umre_02" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "EK_Umlief_02"
And I set fields
    | nummer   | 2um2       |
    | vom      | .          |
    | ueb      | ja         |
    | budat    | .          |
And I modify table
    | !row | mge | preis |
    | 1    | 100 | 3.00  |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Journaleintraege nachladen
Given I open an editor "JournalUmAb" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SATTEL-01;buarta==Abgang;detursache==Umlagerungslieferschein Einkauf;"
And I close the current editor

Given I open an editor "JournalUmZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SATTEL-01;buarta==Zugang;detursache==Umlagerungslieferschein Einkauf"
And I close the current editor


# Umlagerungsbewertungen pruefen
Given I open latest Valuation "BewertungUmAb_02" for Product "SATTEL-01" and valuation transaction "JournalUmAb" with command "VIEW"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Umlagerungslieferschein Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "umlkostenvorh" has value "ja"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr  | addkosten | bewertet   |
    | 100  | !JournalZu^id | !JournalZu^id | 15.0000 | 0.0000    | vorläufig |
And I close the current editor

# Da der Originalzugang noch nicht berechnet wurde, darf die Zugangsbewertung nicht direkt bewertet sein
# Das darf erst nach Verbuchen der Rechnung auf den Zugang passieren
Given I open latest Valuation "BewertungUmZu_02" for Product "SATTEL-01" and valuation transaction "JournalUmZu" with command "VIEW"
Then field "buart" has value "Neubewertung"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "umlkostenvorh" has value "ja"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmZu_01"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr  | addkosten | bewertet   |
    | 100  | !JournalZu^id | !JournalZu^id | 18.0000 | 3.0000    | vorläufig |
And I close the current editor


# Nachbewerten
And I run Revaluation


# Nachbewerten traegt den korrekten Preisstatus in der Zugangsbewertung ein
Given I open latest Valuation "BewertungUmAb_03" for Product "SATTEL-01" and valuation transaction "JournalUmAb" with command "VIEW"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Umlagerungslieferschein Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "umlkostenvorh" has value "ja"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr  | addkosten | bewertet   |
    | 100  | !JournalZu^id | !JournalZu^id | 15.0000 | 0.0000    | vorläufig |
And I close the current editor

Given I open latest Valuation "BewertungUmZu_03" for Product "SATTEL-01" and valuation transaction "JournalUmZu" with command "VIEW"
# Durch Korrektur von ak muss das Nachbewerten hier nichts mehr tun
Then field "id" has value equal to field "id" from editor "BewertungUmZu_02"
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #

Scenario: 05 Zugang berechnen - jetzt darf der Preisstatus im Umlagerungszugang auf direkt gehen

Given I open an editor "EK_Re_02" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "EK_Ls_02"
And I set fields
    | nummer   | 2re        |
    | vom      | .          |
    | ueb      | ja         |
    | budat    | .          |
    | erfwaehr | DEM      |
And I modify table
    | !row | mge | preis |
    | 1    | 100 | 17.00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Journaleintraege nachladen
Given I open an editor "JournalZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SATTEL-01;buarta==Zugang;detursache==Lieferschein Einkauf;"
And I close the current editor

Given I open an editor "JournalUmAb" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SATTEL-01;buarta==Abgang;detursache==Umlagerungslieferschein Einkauf;"
And I close the current editor

Given I open an editor "JournalUmZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==SATTEL-01;buarta==Zugang;detursache==Umlagerungslieferschein Einkauf"
And I close the current editor


# Bewertungen pruefen
Given I open latest Valuation "BewertungZu_02" for Product "SATTEL-01" and valuation transaction "JournalZu" with command "VIEW"
Then field "ppsrefid" has value equal to field "id" from editor "JournalZu"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungZu_01"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr  | addkosten | bewertet |
    | 100  | !JournalZu^id | !JournalZu^id | 17.0000 | 0.0000    | direkt   |
And I close the current editor

# Umlagerungsbewertungen aendern sich nicht sofort
Given I open latest Valuation "BewertungUmAb_04" for Product "SATTEL-01" and valuation transaction "JournalUmAb" with command "VIEW"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Umlagerungslieferschein Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "umlkostenvorh" has value "ja"
Then field "vorgaenger" is empty
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr  | addkosten | bewertet   |
    | 100  | !JournalZu^id | !JournalZu^id | 15.0000 | 0.0000    | vorläufig |
And I close the current editor

Given I open latest Valuation "BewertungUmZu_04" for Product "SATTEL-01" and valuation transaction "JournalUmZu" with command "VIEW"
# Keine neue Bewertung nach Korrektur von ak
Then field "id" has value equal to field "id" from editor "BewertungUmZu_02"
And I close the current editor


# Nochmal Nachbewerten
And I run Revaluation


# Bewertungen pruefen
# Zugangsbewertung bekommt keinen Nachfolger
Given I open an editor "BewertungZu_02" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "BewertungZu_02"
Then field "nachfolger" is empty
And I close the current editor

# Aenderungen kommen in Umlagerungsbewertungen an
Given I open latest Valuation "BewertungUmAb_05" for Product "SATTEL-01" and valuation transaction "JournalUmAb" with command "VIEW"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Umlagerungslieferschein Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmAb"
Then field "umlkostenvorh" has value "ja"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmAb_04"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr  | addkosten | bewertet |
    | 100  | !JournalZu^id | !JournalZu^id | 17.0000 | 0.0000    | direkt   |
And I close the current editor

Given I open latest Valuation "BewertungUmZu_05" for Product "SATTEL-01" and valuation transaction "JournalUmZu" with command "VIEW"
Then field "buart" has value "Neubewertung"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "umlkostenvorh" has value "ja"
Then field "vorgaenger^id" has value equal to field "id" from editor "BewertungUmZu_04"
Then field "nachfolger" is empty
Then table has values
    | tmge | orig^id       | beworig^id    | tbewpr  | addkosten | bewertet |
    | 100  | !JournalZu^id | !JournalZu^id | 20.0000 | 3.0000    | direkt   |
And I close the current editor

