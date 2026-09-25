# *****************************************************************************
#  Name           : ev_basisartikel_cu.feature
#  Autor          : dago
#  Verantwortlich : dago
#  Kontrolle      : foe
#  Funktion       : Cucumber Tests fuer die Basisartikel im Einkauf und Verkauf
#
#
# *****************************************************************************
#
@persistent
Feature: Basisartikel im Einkauf und Verkauf
Background:
And I set the fake date to "01.01.2000"
Given I enable the flag 39 

#----------------------------------------------------------------------------------------------
Scenario: Artikel anlegen als Versionen fuer die Basisartikel
#----------------------------------------------------------------------------------------------
# STAMMDATEN - V1 kopieren
Given I open an editor "V1-blau" from table "(Part):(Product)" with command "COPY" for record "V1"
And I set field "such" to "V1-blau"
And I save the current editor

Given I open an editor "V1-rot" from table "(Part):(Product)" with command "COPY" for record "V1"
And I set field "such" to "V1-rot"
And I save the current editor

# STAMMDATEN - E1 kopieren
Given I open an editor "E1-gelb" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-gelb"
And I set field "le" to "Stück"
And I save the current editor

Given I open an editor "E1-grün" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-grün"
And I set field "le" to "Stück"
And I save the current editor

Given I open an editor "E1-EF-grün" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1-EF-gruen"
And I set field "bsart" to "Eigenfertigung"
And I set field "le" to "Stück"
And I save the current editor

# STAMMDATEN - E3 kopieren
Given I open an editor "E3-LILA" from table "(Part):(Product)" with command "COPY" for record "E3"
And I set field "such" to "E3-LILA"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Lohnfertigungsteil anlegen
#----------------------------------------------------------------------------------------------
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "1-TEIL-LOH"
And I set field "num2" to "1-TEIL-LOH"
And I set field "such" to "TEIL-1-LOH"
And I set field "namebspr" to "Teil 1 Lohnfertigung"
And I set field "bsart" to "Lohnfertigung"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario Outline: Basisartikel anlegen
#----------------------------------------------------------------------------------------------
Given I open an editor "<such>" from table "(Part):(BaseProduct)" with command "STORE" for record "<such>"
And I set fields
  | such     | <such>     |
  | namebspr | <namebspr> |
And I save the current editor
Examples:
  | such    | namebspr             |
  | VERS-V1 | Basisartikel für V1  |
  | VERS-E1 | Basisartikel Einkauf |
  | VERS-E3 | Basisartikel E3      |
  | VERS-T1 | Basisartikel Test1   |
  | VERS-E1-EF | Basisasrtikel Eigenfertigung E1 |

#----------------------------------------------------------------------------------------------
Scenario: VK - Versionen zum Basisartikel anlegen, Standardversion setzen
#----------------------------------------------------------------------------------------------
Given I open an editor "BASIS-V1" from table "(Part):(BaseProduct)" with command "UPDATE" for record "VERS-V1"
And I append rows
  | tversion | tindex | tstdvers |
  | V1-blau  | 1      | ja       |
  | V1-rot   | 2      | nein     |
And I save the current editor

Given I query "such" from table "(Part):(Product)" where "@ablageart=lebendig;basisartikel=VERS-V1"
Then query has values
   | such    |
   | V1-BLAU |
   | V1-ROT  |

#----------------------------------------------------------------------------------------------
Scenario: EK - Versionen zum Basisartikel anlegen, Standardversion setzen
#----------------------------------------------------------------------------------------------
Given I open an editor "BASIS-E1" from table "(Part):(BaseProduct)" with command "UPDATE" for record "VERS-E1"
And I append rows
  | tversion | tindex | tstdvers |
  | E1-gruen | 1      | ja       |
  | E1-gelb  | 2      | nein     |
And I save the current editor

Given I open an editor "BASIS-E3" from table "(Part):(BaseProduct)" with command "UPDATE" for record "VERS-E3"
And I append rows
  | tversion | tindex | tstdvers |
  | E3-LILA  | 1      | ja       |
And I save the current editor

Given I open an editor "BASIS-E1-EF" from table "(Part):(BaseProduct)" with command "UPDATE" for record "VERS-E1-EF"
And I append rows
  | tversion    | tindex | tstdvers |
  | E1-EF-gruen | 1      | ja       |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario:  1 Version zum Basisartikel anlegen, Standardversion setzen
#----------------------------------------------------------------------------------------------
Given I open an editor "BASIS-T1" from table "(Part):(BaseProduct)" with command "UPDATE" for record "VERS-T1"
And I append rows
  | tversion | tindex | tstdvers |
  | TEST     | 1      | ja       |
And I save the current editor

Given I query "such" from table "(Part):(Product)" where "@ablageart=lebendig;basisartikel=VERS-T1"
Then query has values
   | such |
   | TEST |

#----------------------------------------------------------------------------------------------
#             VERKAUF
#----------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------
Scenario: VK - Deaktivieren der Konfiguration Versionsnummerverwaltung im Verkauf
#----------------------------------------------------------------------------------------------
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "verskontr" to "0"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Rahmenauftrag mit Artikel anlegen, Artikel loeschen, mit Basisartikel scheitert es
#----------------------------------------------------------------------------------------------
Given I open an editor "RA-V1-VERSIONEN" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
  | kunde | KUNDE1    |
  | such  | RA_V1BLAU |
  | vom   | .         |
And I create a new row at the end of the table
Then setting field "basisartikel" to "VERS-V1" in row 1 throws the exception "1912"
And I set field "artikel" to "V1-blau" in row 1
Then field "basisartikel" has value "VERS-V1" in row 1
And I set field "artikel" to "" in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Aktivieren der Konfiguration Versionsnummerverwaltung im Verkauf
#----------------------------------------------------------------------------------------------
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "verskontr" to "1"
And I save the current editor

Given I open an editor "RA-V1-VERSIONEN" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
  | kunde | KUNDE1    |
  | such  | RA_V1BLAU |
  | vom   | .         |
And I append rows
  | basisartikel | artikel | mge | preis |
  | VERS-V1      | V1-blau |  20 | 18    |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Rahmenauftrag mit Artikel und Basisartikel, Gegenseitiges Loeschen pruefen: Artikel <-> Basisartikel
#----------------------------------------------------------------------------------------------
Given I open an editor "RA-BA01" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record from editor "RA-V1-VERSIONEN"
Then setting field "basisartikel" to " " in row 1 throws the exception "203"
And I append rows
  | artikel | mge | preis |
  | V1-rot  |  20 | 19    |
Then field "basisartikel" has value "VERS-V1" in row 1
And I set field "basisartikel" to "" in row 2
Then field "artikel" has value "" in row 2
And I delete row at position 2
And I append rows
  | basisartikel | artikel | mge | preis |
  | VERS-V1      | V1-rot  |  20 | 20    |
And I set field "artikel" to "" in row 2
Then field "basisartikel" has value "" in row 2
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Auftrag mit Basisartikel, Automatisches Setzen des Artikel, da einzige Version
#----------------------------------------------------------------------------------------------
Given I open an editor "AU-BA01" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
  | kunde | KUNDE1  |
  | such  | AU_TEST |
  | vom   | .       |
And I append rows
  | Basisartikel | mge | preis |
  | VERS-T1      |  12 | 24    |
Then field "artikel" has value "TEST" in row 1
Then setting field "artikel" to "E1" in row 1 throws the exception "1361"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Auftrag mit Basisartikel, AU/BE Positionen, Dienstleistungen -> Kein Basisartikel
#----------------------------------------------------------------------------------------------
Given I open an editor "AU-02" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
  | kunde | KUNDE1   |
  | such  | AU2_TEST |
  | vom   | .        |
And I append rows
  | Basisartikel | mge | preis |
  | VERS-T1      |  12 | 24    |
And I create a new row at the end of the table
And I set field "artikel" to "DL-ANALYSE" in row 2
Then field "basisartikel" has value "" in row 2
Then field "basisartikel" is not modifiable in row 2
And I set field "artikel" to "AU/BE" in row 2
Then field "basisartikel" is not modifiable in row 2
And I set field "mge" to "1" in row 2
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: VK - Kundenartikeleigenschaften aus Basisartikel bzw. Version uebernehmen
#----------------------------------------------------------------------------------------------
# AU - KuArtEigenschaft aus der Version uebernehmen
Given I open an editor "AU1-KuArtEig" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
  | kunde | KUNDE1    |
  | such  | AU1_KUART |
  | vom   | .         |
And I append rows
  | Basisartikel | artikel   | mge | preis |
  | BAS-FL       | VERS-FL01 |   1 |    23 |
Then field "zkuartnr" has value "12345NEU" in row 1
Then field "vorlauf" has value "5" in row 1
Then field "packanw" has value "501" in row 1
Then field "fmenge" has value "25" in row 1
And I save the current editor

# Artikel: KuArtEigenschaft ohne Kundenbezug
Given I open an editor "V1-rot" from table "(Part):(Product)" with command "UPDATE" for record "V1-rot"
And I press button "akle" to open a subeditor for "KuartEigenschaft"
And I append rows
  | kl     | kuartnr        | zeichn  | index | packanwversand | fmengeversand | vorlauf |
  |        | V1ROTALLGEMEIN | ZV1ALG  |    11 |                |           10  |       5 |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Basisartikel: KuArtEigenschaft ohne/mit Kundenbezug
Given I open an editor "VERS-V1" from table "(Part):(BaseProduct)" with command "UPDATE" for record "VERS-V1"
And I press button "akle" to open a subeditor for "KuartEigenschaft"
And I append rows
  | kl     | kuartnr | zeichn  | index | packanwversand  | fmengeversand | vorlauf |
  |        | V1XYZ   | Z_XYZV1 |   08  |                 |             7 |       2 |
  | KUNDE1 | V1123   | ZV1123  |   10  | VERSAND_EINFACH |            22 |       1 |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# KuArtEigenschaft des Kunden KUNDE1 werden aus dem Basisartikel uebernommen, in der Version sind keine kunddenspezifische vorhanden
Given I open an editor "AU2-KuArtEig" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
  | kunde | KUNDE1    |
  | such  | AU2_KUART |
  | vom   | .         |
And I append rows
  | Basisartikel | artikel | mge | preis |
  | VERS-V1      | V1-rot  |   2 |    12 |
Then field "zkuartnr" has value "V1123" in row 1
Then field "vorlauf" has value "1" in row 1
Then field "packanw^such" has value "VERSAND_EINFACH" in row 1
Then field "fmenge" has value "22" in row 1
And I save the current editor

# KUNDE2: keine KuArtEigenschaft im Basisartikel -> aus der Version ohne Kundenbezug uebernehmen
Given I open an editor "AU3-KuArtEig" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
  | kunde | KUNDE2    |
  | such  | AU3_KUART |
  | vom   | .         |
And I append rows
  | Basisartikel | artikel | mge | preis |
  | VERS-V1      | V1-rot  |   2 |    11 |
Then field "zkuartnr" has value "V1ROTALLGEMEIN" in row 1
Then field "vorlauf" has value "5" in row 1
Then field "packanw" has value "" in row 1
Then field "fmenge" has value "10" in row 1
And I save the current editor

# Artikel: KuArtEigenschaft mit Kundenbezug
Given I open an editor "V1-blau" from table "(Part):(Product)" with command "UPDATE" for record "V1-blau"
And I press button "akle" to open a subeditor for "KuartEigenschaft"
And I append rows
  | kl     | kuartnr | zeichn  | index | packanwversand  | fmengeversand | vorlauf |
  | KUNDE1 | V1BLAU  | ZV1BLAU |    10 | VERSAND_EINFACH |            12 |       2 |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Artikel: keine KuArtEigenschaft ohne Kundenbezug, aus Basisartikel ohne Kundenbezug (Kunde KUNDE2) uebernehmen
Given I open an editor "AU4-KuArtEig" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
  | kunde | KUNDE2    |
  | such  | AU4_KUART |
  | vom   | .         |
And I append rows
  | Basisartikel | artikel | mge | preis |
  | VERS-V1      | V1-blau |   2 |     2 |
Then field "zkuartnr" has value "V1XYZ" in row 1
Then field "vorlauf" has value "2" in row 1
Then field "packanw" has value "" in row 1
Then field "fmenge" has value "7" in row 1
And I save the current editor


#----------------------------------------------------------------------------------------------
#             EINKAUF
#----------------------------------------------------------------------------------------------

# Konfig-Schalter "verskontreink" ist nicht aktiv
#----------------------------------------------------------------------------------------------
Scenario: EK - Bestellung mit Basisartikel und Artikel anlegen
#----------------------------------------------------------------------------------------------
Given I open an editor "BE-E1-VERSIONEN" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
  | lief | 1        |
  | such | BE_E1GRU |
  | vom  | .        |
And I create a new row at the end of the table
Then setting field "basisartikel" to "VERS-E1" in row 1 throws the exception "1912"
And I set field "artikel" to "E1-gruen" in row 1
Then setting field "artikel" to "V1-rot" in row 1 throws the exception "1361"
Then field "basisartikel" has value "VERS-E1" in row 1
And I set field "artikel" to "" in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Aktivieren der Konfiguration Versionsnummerverwaltung im Einkauf
#----------------------------------------------------------------------------------------------
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "verskontreink" to "1"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Bestellung mit Basisartikel und Artikel anlegen
#----------------------------------------------------------------------------------------------
Given I open an editor "BE-E1-VERSIONEN" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
  | lief | 1        |
  | such | BE_E1GRU |
  | vom  | .        |
And I append rows
  | basisartikel | artex    | mge  | preis |
  | VERS-E1      | E1-gruen |  20  | 22    |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Bestellung mit Artikel und Basisartikel, Gegenseitiges Loeschen pruefen: Artikel <-> Basisartikel
#----------------------------------------------------------------------------------------------
Given I open an editor "BE-BAE1" from table "(Purchasing):(PurchaseOrder)" with command "UPDATE" for record from editor "BE-E1-VERSIONEN"
Then setting field "basisartikel" to "" in row 1 throws the exception "203"
And I append rows
  | artikel  | mge |
  | E1-gruen |  20 |
Then field "basisartikel" has value "VERS-E1" in row 1
And I set field "basisartikel" to "" in row 2
Then field "artikel" has value "" in row 2
And I delete row at position 2
And I append rows
  | basisartikel | artikel | mge |
  | VERS-E1      | E1-gelb |  20 |
And I set field "artikel" to "" in row 2
Then field "basisartikel" has value "" in row 2
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Lohnfertigungsvorschlag anlegen
#----------------------------------------------------------------------------------------------
Given I open an editor "lohn-basis" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I create a new row at the end of the table
# Then field "basisartikel" is not modifiable in row 1
And I delete row at position 1
And I append rows
  | artikel    | lffert   | basisartikel | mge |
  | 1-TEIL-LOH | E1-gruen | VERS-E1      |  20 |
And I set field "basisartikel" to "" in row 1
Then field "lffert" has value "" in row 1
And I set field "lffert" to "E1-gruen" in row 1
And I set field "basisartikel" to "VERS-E1" in row 1
Then setting field "basisartikel" to "VERS-T1" in row 1 throws the exception "1163"
And I set field "lffert" to " " in row 1
Then field "basisartikel" has value "" in row 1
And I set field "lffert" to "DL-ANALYSE" in row 1
Then field "basisartikel" is not modifiable in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Bestellung mit Basisartikel, Automatisches Setzen des Artikel, da einzige Version
#----------------------------------------------------------------------------------------------
Given I open an editor "BE-BA01" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
  | lief | 1       |
  | such | BE_TEST |
  | vom  | .       |
And I append rows
  | Basisartikel | mge | preis |
  | VERS-T1      |   3 | 14    |
Then field "artikel" has value "TEST" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Ausschreibung anlegen
#----------------------------------------------------------------------------------------------
# Ausschreibung mit Artikel
Given I open an editor "AUSS01" from table "(BiddingProcess):(BiddingProcess)" with command "NEW" for record ""
And I set fields
  | such  | AUSS01 |
And I append rows
  | tlief | artikel | mge | verw   | anfrposgrp |
  | 1     | E1-gelb | 50  | AUSS01 | 2          |
  | 1     | E2      | 60  | AUSS01 | 3          |
Then field "lffert" is not modifiable in row 1
Then field "tbasisartikel" has value "VERS-E1" in row 1
Then field "tbasisartikel" has value "" in row 2
Then setting field "tbasisartikel" to "VERS-E1" in row 2 throws the exception "1163"
And I create a new row at the end of the table
And I set field "tbasisartikel" to "VERS-E3" in row 3
Then field "artikel" has value "E3-LILA" in row 3
And I set field "tbasisartikel" to "" in row 3
Then field "artikel" has value "" in row 3
And I set field "tlief" to "1" in row 3
And I close the current editor

# Ausschreibung mit Lohnfertigung
Given I open an editor "AUSS02LOHN" from table "(BiddingProcess):(BiddingProcess)" with command "NEW" for record ""
And I set fields
  | such  | AUSS02 |
And I append rows
  | tlief | artikel    | mge | verw   | anfrposgrp |
  | 1     | 1-TEIL-LOH | 50  | AUSS02 | 2          |
Then field "lffert" is modifiable in row 1
Then setting field "lffert" to "E1-gruen" in row 1 throws the exception "5271"
And I set field "lffert" to "E1-EF-gruen" in row 1
Then field "tbasisartikel" has value "VERS-E1-EF" in row 1
And I create a new row at the end of the table
Then field "lffert" is not modifiable in row 2
#Then setting field "tbasisartikel" to "VERS-E3" in row 2 throws the exception "5271"
Then setting field "artikel" to "E3-LILA" in row 2 throws the exception "5271"
Then field "tbasisartikel" has value "" in row 2
And I set field "tlief" to "1" in row 1
And I delete row at position 2
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: EK - Wechsel von Lohnfertigungsartikel zu anderem Artikel in Bestellung
#----------------------------------------------------------------------------------------------
Given I open an editor "BE-BA02" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
  | lief | 1       |
  | such | BE_BA02 |
  | vom  | .       |
And I append rows
  | artikel    | lffert   | mge |
  | 1-TEIL-LOH | E1-gruen |  15 |
Then field "basisartikel" has value " VERS-E1" in row 1
Then setting field "basisartikel" to "VERS-T1" in row 1 throws the exception "1163"
# Artikel ohne Lohnfertigung eintragen
And I set field "artikel" to "V1" in row 1
# Fertigteil Lohnfertigung wird geleert und ist schreibgeschützt
Then field "lffert" has value "" in row 1
Then field "lffert" is not modifiable in row 1
# Basisartikel zu Artikel V1 fehlt
Then field "basisartikel" has value "" in row 1
# Lohnfertigungsartikel nochmal eintragen
And I set field "artikel" to "1-TEIL-LOH" in row 1
And I set field "lffert" to "E1-gelb" in row 1
# Artikel leeren
And I set field "artikel" to "" in row 1
# Fertigteil Lohnfertigung wird geleert und ist schreibgeschützt
Then field "lffert" has value "" in row 1
Then field "lffert" is not modifiable in row 1
# Lohnfertigungsartikel nochmal eintragen
And I set field "artikel" to "1-TEIL-LOH" in row 1
And I set field "lffert" to "E1-gelb" in row 1
And I set field "mge" to "15" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Basisartikel in der Serviceproduktstückliste
#----------------------------------------------------------------------------------------------
# Serviceprodukt anlegen
Given I open an editor "Serviceprodukt" from table "(ServiceProduct):(ServiceProduct)" with command "NEW" for record ""
And I set field "such" to "SPROD-B1"
And I set field "artikel" to "V1"
# Stückliste anlegen und erweitern
And I press button "stlanlegen" to open a subeditor for "Stückliste"
And I create a new row at the end of the table
And I set field "elex" to "V1-blau" in row 3
Then field "basisartikel" has value "VERS-V1" in row 3
Then setting field "elex" to "E1-gelb" in row 3 throws the exception "1361"
And I set field "elex" to "V1-rot" in row 3
And I create a new row at the end of the table
And I set field "basisartikel" to "VERS-E3" in row 4
Then field "elex" has value "E3-LILA" in row 4
And I set field "basisartikel" to "" in row 4
Then field "elex" has value "" in row 4
And I set field "basisartikel" to "VERS-E3" in row 4
And I save the current editor
And I switch the current editor to editor "Serviceprodukt"
And I save the current editor

# Im Aendern-Modus sind die Felder schreibgeschützt
Given I open an editor "SERVPSTL" from table "(ServiceProduct):(ServiceProductBOM)" with command "UPDATE" for search criteria "$,,artikel=V1;serprod=SPROD-B1;@richtung=vorwaerts;@maxtreffer=1"
Then field "elex" is not modifiable in row 1
Then field "basisartikel" is not modifiable in row 4
And I close the current editor

