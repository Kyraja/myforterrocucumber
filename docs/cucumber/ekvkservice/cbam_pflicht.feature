# *****************************************************************************
#  Name           : cbampflicht.feature
#  Autor          : dago
#  Verantwortlich : teampss
#  Funktion       : Testet Funktionen rund um die CBAM-Meldepflicht im Einkauf
#
# *****************************************************************************
#
@persistent
Feature: CBAM-Meldepflicht
Background:
Given I set the fake date to "05.01.1995"

# ----------------------------------------------------------------------------------------------
Scenario: STAMMDATEN - Neue Warengruppen anlegen
# ----------------------------------------------------------------------------------------------
# Warengruppe mit CBAM-Meldepflicht anlegen
Given I open an editor "Warennummer-CBAM" from table "(Company):(Summary)" with command "NEW" for record ""
And I set fields
  | nummer      | 111           |
  | such        | WGRCBAM       |
  | namebspr    | Warennummer 1 |
  | ahnum       | 1             |
  | cbampflicht | ja            |
And I save the current editor

# Warengruppe ohne CBAM-Meldepflicht anlegen
Given I open an editor "WGR-OHNE-CBAM" from table "(Company):(Summary)" with command "NEW" for record ""
And I set fields
  | nummer      | 112           |
  | such        | WGR2          |
  | namebspr    | Warennummer 2 |
  | ahnum       | 1             |
  | cbampflicht | nein          |
And I save the current editor

# Waehrungskurs Dollar auf 1,5 setzen
Given I open an editor "waehrung" from table "(ExchangeRate):(ExchangeRate)" with command "NEW" for record ""
And I set field "fwaehr" to "USD"
And I set field "ikurs" to "2.0"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Im Artikel die Warennummer wechseln, CBAM-Meldepflicht pruefen
# ----------------------------------------------------------------------------------------------
Given I open an editor "ART-CBAM" from table "(Part):(Product)" with command "UPDATE" for record "E3"
And I set field "ahnum" to "111"
Then field "artikelcbampflicht" has value "ja"
And I set field "ahnum" to "112"
Then field "artikelcbampflicht" has value "nein"
And I save the current editor


# ---------------------------------------------------------------------------------------------------
Scenario: Artikel vorbelegen aus Warennummer
# ---------------------------------------------------------------------------------------------------
Given I open an editor "Warennummer333" from table "(Company):(Summary)" with command "NEW" for record ""
And I set fields
  | nummer      | 333           |
  | such        | WGRCBAM333    |
  | namebspr    | Warennummer 3 |
  | ahnum       | 1             |
  | cbampflicht | nein          |
And I save the current editor

Given I open an editor "ACBAM33" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set fields
	| such               | ACBAM33  |
	| namebspr           | A_CBAM33 |
  | ahnum              | 333      |
Then field "cbampflicht" has value "nein"
And I save the current editor

Given I open an editor "ACBAM34" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set fields
	| such               | ACBAM34  |
	| namebspr           | A_CBAM34 |
  | ahnum              | 333      |
Then field "cbampflicht" has value "nein"
And I save the current editor

Given I open an editor "ACBAM35" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set fields
	| such               | ACBAM35  |
	| namebspr           | A_CBAM35 |
  | ahnum              | 333      |
Then field "cbampflicht" has value "nein"
And I save the current editor

Given I open an editor "Warennummer-CBAM" from table "(Company):(Summary)" with command "UPDATE" for record from editor "Warennummer333"
And I set field "cbampflicht" to "ja"
And I save the current editor

Then field "artikelcbampflicht" from editor "ART-CBAM" in row 0 has value "nein"
Then field "artikelcbampflicht" from editor "ACBAM33" in row 0 has value "ja"
Then field "artikelcbampflicht" from editor "ACBAM34" in row 0 has value "ja"
Then field "artikelcbampflicht" from editor "ACBAM35" in row 0 has value "ja"

Given I open an editor "Warennummer-CBAM" from table "(Company):(Summary)" with command "UPDATE" for record from editor "Warennummer333"
And I set field "cbampflicht" to "nein"
And I save the current editor

Then field "artikelcbampflicht" from editor "ART-CBAM" in row 0 has value "nein"
Then field "artikelcbampflicht" from editor "ACBAM33" in row 0 has value "nein"
Then field "artikelcbampflicht" from editor "ACBAM34" in row 0 has value "nein"
Then field "artikelcbampflicht" from editor "ACBAM35" in row 0 has value "nein"

# ----------------------------------------------------------------------------------------------
Scenario: CBAM-Meldepflicht fuer Lieferanten/-kontakt bei Aenderungen des Landes pruefen
# ----------------------------------------------------------------------------------------------
# Algerien wird CBAM meldepflichtig
Given I open an editor "country" from table "(Regions):(RegionCountryEconomicArea)" with command "UPDATE" for record "ALGERIEN"
And I set field "cbampflicht" to "ja"
And I save the current editor

# Lieferant anlegen, Land aendern, CBAM-Meldepflicht pruefen
Given I open an editor "Lieferant_mit_CBAM" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
	| such     | L_CBAM1    |
	| namebspr | L_mit_CBAM |
Then field "staat" has value "DEUTSCHLAND"
Then field "cbampflicht" has value "nein"
And I set field "staat" to "ALGERIEN"
Then field "cbampflicht" has value "ja"
And I save the current editor

# Lieferantenkontakt anlegen, CBAM-Meldpflicht pruefen
Given I open an editor "Lieferantenkontakt_CBAM2" from table "(Vendor):(VendorContact)" with command "NEW" for record ""
And I set fields
	| firma | L_CBAM1 |
	| such  | LK_DE   |
Then field "staat" has value "ALGERIEN"
Then field "cbampflicht" has value "ja"
And I set field "staat" to ""
Then field "cbampflicht" has value "nein"
And I set field "staat" to "DEUTSCHLAND"
Then field "cbampflicht" has value "nein"
And I set field "staat" to "ALGERIEN"
Then field "cbampflicht" has value "ja"
And I save the current editor

# CBAM-Meldepflicht fuer Tunesien setzen. Diese wird im Lieferantenkontakt aus dem Lieferanten uebernommen.
Given I open an editor "Lieferant_mit_CBAM" from table "(Vendor):(Vendor)" with command "UPDATE" for record "L_CBAM1"
Then field "staat" has value "ALGERIEN"
Then field "cbampflicht" has value "ja"
And I set field "staat" to "TUNESIEN"
Then field "cbampflicht" has value "nein"
And I set field "cbampflicht" to "ja"
And I save the current editor

# Lieferantenkontakt 2 anlegen, CBAM-Meldepflicht pruefen
Given I open an editor "Lieferantenkontakt_CBAM2" from table "(Vendor):(VendorContact)" with command "NEW" for record ""
And I set fields
	| firma | L_CBAM1 |
	| such  | LK2_DE  |
# Aus dem Lieferanten geholt
Then field "staat" has value "TUNESIEN"
Then field "cbampflicht" has value "ja"
And I set field "staat" to "FRANKREICH"
Then field "cbampflicht" has value "nein"
# Hier wird es aus dem Land selbst geholt
And I set field "staat" to "TUNESIEN"
Then field "cbampflicht" has value "nein"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: CBAM-Meldepflicht für Artikel und Lieferanten
# ----------------------------------------------------------------------------------------------
# Lieferant2 CBAM meldepflichtig
Given I open an editor "Lieferant2_cbam" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
  | such     | L_CBAM2     |
  | namebspr | L_mit_CBAM2 |
  | staat    | ALGERIEN    |
Then field "cbampflicht" has value "ja"
And I save the current editor

# CBAM meldepflichtigen Artikel anlegen
Given I open an editor "Artikel_mit_CBAM" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
  | such  | A_CBAM1      |
  | name  | Artikel_CBAM |
  | ahnum | 111          |
  | gewicht | 123.45        |
Then field "artikelcbampflicht" has value "ja"
And I save the current editor

# Artikel CBAM meldepflichtig
# Lieferantenauswahl -> CBAM-Pflicht wird mit ja vorbelegt, falls Artikel und Lieferant meldepflichtig sind
Given I open an editor "Artikel_mit_CBAM" from table "(Part):(Product)" with command "UPDATE" for record "A_CBAM1"
And I set fields
  | lief               | L_CBAM2  |
  | direkteemission    | 0.000011 |
  | indirekteemission  | 0.000001 |
  | lief2              | 002      |
  | lief3              | L_CBAM1  |
  | direkteemission3   | 1.000000 |
  | indirekteemission3 | 0.999999 |
Then field "cbampflicht" has value "ja"
Then field "direkteemission" is modifiable
Then field "indirekteemission" is modifiable
Then field "cbampflicht2" has value "nein"
Then field "direkteemission2" is not modifiable
Then field "indirekteemission2" is not modifiable
# CBAM-Meldepflicht aktivieren
And I set field "cbampflicht2" to "ja"
Then field "direkteemission2" is modifiable
Then field "indirekteemission2" is modifiable
Then field "cbampflicht3" has value "ja"
Then field "direkteemission3" is modifiable
Then field "indirekteemission3" is modifiable
# Lieferant 3 loeschen -> CBAM-Felder werden geleert.
And I set field "lief3" to ""
Then field "cbampflicht3" has value "nein"
Then field "direkteemission3" has value "0.000000"
Then field "indirekteemission3" has value "0.000000"
Then field "direkteemission3" is not modifiable
Then field "indirekteemission3" is not modifiable
# Lieferant 3 wieder setzen
And I set fields
  | lief3              | L_CBAM1  |
  | direkteemission3   | 1.000000 |
  | indirekteemission3 | 0.999999 |
Then field "cbampflicht3" has value "ja"
And I save the current editor

# Artikel nicht CBAM meldepflichtig -> CBAM-Meldepflicht wird nein vorbelegt
Given I open an editor "Artikel_ohne_CBAM" from table "(Part):(Product)" with command "UPDATE" for record "E3"
And I set fields
  | lief4 | L_CBAM2 |
  | lief5 | 002     |
Then field "cbampflicht4" has value "nein"
Then field "cbampflicht5" has value "nein"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: CBAM-Meldepflicht & Emissionen beim Wechsel des Erstlieferanten uebernehmen
# ----------------------------------------------------------------------------------------------
Given I open an editor "Artikel_CBAM_1" from table "(Part):(Product)" with command "UPDATE" for record "A_CBAM1"
# Drittlieferant wird Erstlieferant
And I press button "ersterlief3"
Then field "cbampflicht" has value "ja"
Then field "direkteemission" has value "1.000000"
Then field "indirekteemission" has value "0.999999"
# Wechsel des Erstlieferanten - CBAM-Felder werden getauscht
Then field "cbampflicht3" has value "ja"
Then field "direkteemission3" has value "0.000011"
Then field "indirekteemission3" has value "0.000001"
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Ueberpruefen der Aenderbarkeit von Emissionsfeldern in Anfrage, Bestellung, Lieferschein, Rechnung
# ----------------------------------------------------------------------------------------------
# Nur bei reinen Artikeln und angekreuzter CBAM-Pflicht aenderbar
# Anfrage
Given I open an editor "ANF-01" from table "(Purchasing):(Request)" with command "NEW" for record ""
And I set fields
  | lief | L_CBAM1  |
  | such | ANF-01   |
And I append rows
  | artikel    | mge         |
  | E2         | 10          |
  | AU/BE      | !dontChange |
  | DL-ANALYSE | !dontChange |
# Keine CBAM-Meldepflicht
Then field "cbampflicht" has value "nein" in row 1
Then field "direkteemission" is not modifiable in row 1
Then field "indirekteemission" is not modifiable in row 1
# CBAM-Meldepflicht angekreuzt
And I set field "cbampflicht" to "ja" in row 1
Then field "direkteemission" is modifiable in row 1
Then field "indirekteemission" is modifiable in row 1
# AU/BE Position
Then field "cbampflicht" is not modifiable in row 2
Then field "direkteemission" is not modifiable in row 2
Then field "indirekteemission" is not modifiable in row 2
# Dienstleistung
Then field "cbampflicht" is not modifiable in row 3
Then field "direkteemission" is not modifiable in row 3
Then field "indirekteemission" is not modifiable in row 3
And I save the current editor

# Bestellung
Given I open an editor "BE-01" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
  | nummer | 01BE    |
  | lief   | L_CBAM1 |
  | such   | BE-01   |
And I append rows
  | artikel    | mge         |
  | TEXT       | !dontChange |
  | AU/BE      | !dontChange |
  | DL-ANALYSE | !dontChange |
# Position ist kein Artikel
Then field "cbampflicht" is not modifiable in row 1
Then field "direkteemission" is not modifiable in row 1
Then field "indirekteemission" is not modifiable in row 1
# Artikel
And I set field "artikel" to "A_CBAM1" in row 1
And I set field "mge" to "10" in row 1
Then field "cbampflicht" is modifiable in row 1
Then field "cbampflicht" has value "ja" in row 1
And I set field "cbampflicht" to "ja" in row 1
Then field "direkteemission" is modifiable in row 1
Then field "indirekteemission" is modifiable in row 1
And I set field "direkteemission" to "0.000002" in row 1
And I set field "indirekteemission" to "0.000022" in row 1
And I set field "cbampflicht" to "nein" in row 1
Then field "direkteemission" is not modifiable in row 1
Then field "indirekteemission" is not modifiable in row 1
Then field "direkteemission" has value "0.000000" in row 1
Then field "indirekteemission" has value "0.000000" in row 1
# AU/BE Position
Then field "cbampflicht" is not modifiable in row 2
Then field "direkteemission" is not modifiable in row 2
Then field "indirekteemission" is not modifiable in row 2
# Dienstleistung
Then field "cbampflicht" is not modifiable in row 3
Then field "direkteemission" is not modifiable in row 3
Then field "indirekteemission" is not modifiable in row 3
And I save the current editor

# Lieferschein
Given I open an editor "LS-01" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | nummer | 01LS    |
  | ebeleg | 01LS    |
  | lief   | L_CBAM1 |
  | such   | LS-01   |
  | vom    | .       |
  | tterm  | .       |
And I append rows
  | artikel    | mge         | cbampflicht | direkteemission | indirekteemission |
  | A_CBAM1    | 10          |          ja |        0.000002 |          0.000022 |
  | AU/BE      | !dontChange | !dontChange |    !dontChange  |       !dontChange |
  | DL-ANALYSE | !dontChange | !dontChange |    !dontChange  |       !dontChange |
Then field "cbampflicht" has value "ja" in row 1
And I set field "cbampflicht" to "ja" in row 1
Then field "direkteemission" is modifiable in row 1
Then field "indirekteemission" is modifiable in row 1
And I set field "direkteemission" to "0.000012" in row 1
And I set field "indirekteemission" to "0.000123" in row 1
And I set field "cbampflicht" to "nein" in row 1
Then field "direkteemission" is not modifiable in row 1
Then field "indirekteemission" is not modifiable in row 1
Then field "direkteemission" has value "0.000000" in row 1
Then field "indirekteemission" has value "0.000000" in row 1
# AU/BE Position
Then field "cbampflicht" is not modifiable in row 2
Then field "direkteemission" is not modifiable in row 2
Then field "indirekteemission" is not modifiable in row 2
# Dienstleistung
Then field "cbampflicht" is not modifiable in row 3
Then field "direkteemission" is not modifiable in row 3
Then field "indirekteemission" is not modifiable in row 3
And I save the current editor

# Rechnung
Given I open an editor "RE-01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
  | nummer  | 01RE    |
  | ebeleg  | 01RE    |
  | lief    | L_CBAM1 |
  | such    | RE-01   |
  | vom     | .       |
  | tterm   | .       |
And I append rows
  | artikel    | mge         | cbampflicht | direkteemission | indirekteemission |
  | A_CBAM1    | 24          |          ja |        0.000002 |          0.000022 |
  | AU/BE      | !dontChange | !dontChange |    !dontChange  |       !dontChange |
  | DL-ANALYSE | !dontChange | !dontChange |    !dontChange  |       !dontChange |
Then field "cbampflicht" has value "ja" in row 1
Then field "direkteemission" is modifiable in row 1
Then field "indirekteemission" is modifiable in row 1
And I set field "cbampflicht" to "nein" in row 1
Then field "direkteemission" is not modifiable in row 1
Then field "indirekteemission" is not modifiable in row 1
# AU/BE Position
Then field "cbampflicht" is not modifiable in row 2
Then field "direkteemission" is not modifiable in row 2
Then field "indirekteemission" is not modifiable in row 2
# Dienstleistung
Then field "cbampflicht" is not modifiable in row 3
Then field "direkteemission" is not modifiable in row 3
Then field "indirekteemission" is not modifiable in row 3
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Ruecklieferschein & Storno: Emissionsvorzeichen bleiben gleich - Mengen sind negativ
# ----------------------------------------------------------------------------------------------
# Lieferschein -> Ruecklieferschein -> Storno Ruecklieferschein
Given I open an editor "LS-02" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | nummer  | 02LS    |
  | ebeleg  | 02LS    |
  | lief    | L_CBAM1 |
  | such    | LS-02   |
  | vom     | .       |
  | tterm   | .       |
  | ueb     | ja      |
And I append rows
  | artikel | mge  | preis | cbampflicht | direkteemission | indirekteemission |
  | A_CBAM1 |  24  |  5,99 |          ja |        0.000002 |          0.000022 |
And I save the current editor
Then field "cbamposvorhanden" has value "ja"

# Ruecklieferschein
Given I open an editor "RLS-02" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "02LS"
And I set fields
  | nummer  | 02RLS   |
  | ebeleg  | 02RLS   |
  | such    | RLS-02  |
  | vom     | .       |
  | tterm   | .       |
  | ueb     | ja      |
And I set field "mge" to "-1" in row 1
Then field "cbampflicht" has value "ja" in row 1
Then field "direkteemission" has value "0.000002" in row 1
Then field "indirekteemission" has value "0.000022" in row 1
And I save the current editor
# Storno des Ruecklieferscheins
Given I open an editor "Storno-RLS-02" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+02RLS"
Then field "cbampflicht" has value "ja" in row 1
Then field "direkteemission" has value "0.000002" in row 1
Then field "indirekteemission" has value "0.000022" in row 1
And I save the current editor

# Ruecklieferschein2 -> Kopffeld cbamposvorhanden pruefen
Given I open an editor "RLS-02" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "02LS"
And I set fields
  | nummer  | 02RLS2 |
  | ebeleg  | 02RLS2 |
  | vom     | .      |
  | tterm   | .      |
And I delete all rows
And I append rows
  | artikel |
  | TEXT    |
Then field "cbamposvorhanden" has value "ja"
And I save the current editor
Then field "cbamposvorhanden" has value "nein"

# Rechnung mit Lagerbewegung -> Ruecklieferschein -> Storno Ruecklieferschein
Given I open an editor "RE-03" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
  | nummer   | 1RE03 |
  | ueb      |    ja |
  | lief     |     1 |
  | tterm    |     . |
  | vom      |     . |
  | erfwaehr |   EUR |
And I append rows
  | artikel | mge | preis | cbampflicht | direkteemission | indirekteemission |
  | A_CBAM1 |  24 |  5,99 |          ja |        1.000002 |          1.000022 |
  | AU/BE   |  -6 |     1 | !dontChange |     !dontChange |       !dontChange |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# Ruecklieferschein
Given I open an editor "RLS-03" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE03"
And I set fields
  | nummer  | 03RLS   |
  | ebeleg  | 03RLS   |
  | such    | RLS-03  |
  | vom     | .       |
  | tterm   | .       |
  | ueb     | ja      |
And I set field "mge" to "-1" in row 1
Then field "cbampflicht" has value "ja" in row 1
Then field "direkteemission" has value "1.000002" in row 1
Then field "indirekteemission" has value "1.000022" in row 1
And I save the current editor
# Storno des Ruecklieferscheins
Given I open an editor "Storno-RLS-03" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "03RLS"
Then field "direkteemission" has value "1.000002" in row 1
Then field "indirekteemission" has value "1.000022" in row 1
And I close the current editor


# ----------------------------------------------------------------------------------------------
 Scenario: Storno Lieferschein: Emissionsvorzeichen bleiben gleich - Mengen sind negativ
# ----------------------------------------------------------------------------------------------
# Lieferschein -> Storno Lieferschein
Given I open an editor "LS1-02" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | nummer  | 02LS1   |
  | ebeleg  | 02LS1   |
  | lief    | L_CBAM1 |
  | such    | LS1-02  |
  | vom     | .       |
  | tterm   | .       |
  | ueb     | ja      |
And I append rows
  | artikel | mge  | preis | cbampflicht | direkteemission | indirekteemission |
  | A_CBAM1 |  24  |  5,99 |          ja |        0.000002 |          0.000022 |
And I save the current editor
# Storno Lieferschein
Given I open an editor "Storno-LS1-02" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "02LS1"
Then field "cbampflicht" is not modifiable in row 1
Then field "direkteemission" is not modifiable in row 1
Then field "indirekteemission" is not modifiable in row 1
Then field "cbampflicht" has value "ja" in row 1
Then field "direkteemission" has value "0.000002" in row 1
Then field "indirekteemission" has value "0.000022" in row 1
And I save the current editor

# Rechnung mit Lagerbewegung -> Storno RE mit LB
Given I open an editor "RE-LB-01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
  | nummer | 01RELB   |
  | ebeleg | RE-LB-02 |
  | lief   | L_CBAM1  |
  | such   | RE-LB-02 |
  | ueb    | ja       |
  | vom    | .        |
  | tterm  | .        |
  | fakt   | ja       |
And I append rows
  | artikel | mge  | preis | cbampflicht | direkteemission | indirekteemission |
  | A_CBAM1 |  12  |  5,99 |          ja |        0.000002 |          0.000022 |
  | AU/BE   |  -6  |     1 | !dontChange |     !dontChange |       !dontChange |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# Storno Rechnung mit LB
Given I open an editor "Storno-RE-LB-01" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record "+01RELB"
Then field "cbampflicht" is not modifiable in row 1
Then field "direkteemission" is not modifiable in row 1
Then field "indirekteemission" is not modifiable in row 1
Then field "cbampflicht" has value "ja" in row 1
Then field "direkteemission" has value "0.000002" in row 1
Then field "indirekteemission" has value "0.000022" in row 1
And I save the current editor


# ----------------------------------------------------------------------------------------------
Scenario: CBAM-Meldepflicht bei LI-Kontakt, wenn nur Hauptlieferant im Artikel eingetragen ist
# ----------------------------------------------------------------------------------------------
# Wird ein Lieferantenkontakt angegeben und im Artikel ist dieser nicht direkt aufgelistet, so werden
# die Emissionswerte des Hauptlieferanten herangezogen, falls dieser direkt im Artikel aufgelistet ist.
#
# Lieferschein
Given I open an editor "LS-102" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | nummer | 102LS   |
  | ebeleg | 102LS   |
  | lief   | LK2_DE  |
  | such   | LS-102  |
  | vom    | .       |
  | tterm  | .       |
And I append rows
  | artikel    | mge         |
  | A_CBAM1    | 10          |
Then field "cbampflicht" has value "nein" in row 1
Then field "direkteemission" has value "0.000000" in row 1
Then field "indirekteemission" has value "0.000000" in row 1
And I save the current editor

# Lieferantenkontakt wird CBAM-pflichtig
Given I open an editor "Lieferantenkontakt_CBAM2" from table "(Vendor):(VendorContact)" with command "UPDATE" for record from editor "Lieferantenkontakt_CBAM2"
And I set field "cbampflicht" to "ja"
And I save the current editor

Given I open an editor "LS-102" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS-102"
And I delete row at position 1
And I append rows
  | artikel    | mge         |
  | A_CBAM1    | 10          |
# Emissionswerte stammen aus dem Hauptlieferanten
Then field "cbampflicht" has value "ja" in row 1
# Emissionswerte stammen aus dem Hauptlieferanten
Then field "direkteemission" has value "1.000000" in row 1
Then field "indirekteemission" has value "0.999999" in row 1
And I save the current editor

# CBAM-Werte fuer Lieferantenkontakt direkt in den Artikel eintragen
Given I open an editor "Artikel_mit_CBAM" from table "(Part):(Product)" with command "UPDATE" for record "A_CBAM1"
And I set fields
  | lief4               | LK2_DE  |
  | direkteemission4    | 8.000000 |
  | indirekteemission4  | 7.000000 |
And I save the current editor

# Werte kommen nun direkt aus der LI-Kontakt-Zeile im Artikel
Given I open an editor "LS-102" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "LS-102"
And I delete row at position 1
And I append rows
  | artikel    | mge         |
  | A_CBAM1    | 10          |
# Emissionswerte stammen aus dem Hauptlieferanten
Then field "cbampflicht" has value "ja" in row 1
# Emissionswerte stammen aus dem Lieferantenkontakt
Then field "direkteemission" has value "8.000000" in row 1
Then field "indirekteemission" has value "7.000000" in row 1
And I save the current editor


#---------------------------------------------------------------------------------------------
Scenario: Umlagerungslieferschein kopieren -> CBAM-Felder leeren
#---------------------------------------------------------------------------------------------
# Umlagerungslieferschein anlegen
Given I open an editor "1LS04UML" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | lief    | 1        |
  | nummer  | 1LS04UML |
  | bsart   | Umlagern |
  | vom     | .        |
And I append rows
  | artex      | mge | cbampflicht | direkteemission | indirekteemission | abplatz      | platz       |
  | A_CBAM1    | 10  |          ja |        1.234567 |          0.123456 | F1           | L2F1        |
  | AU/BE      | 20  | !dontChange |     !dontChange |       !dontChange | !dontChange  | !dontChange |
  | DL-ANALYSE | 1   | !dontChange |     !dontChange |       !dontChange | !dontChange  | !dontChange |
And I save the current editor

# Kopieren des Umlagerungslieferscheins
Given I open an editor "1LS04UML_KOPIE" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "1LS04UML"
And I set fields
  | nummer | 1LS4UML2 |
  | vom    | .        |
Then field "cbampflicht" is modifiable in row 1
Then field "cbampflicht" has value "nein" in row 1
Then field "direkteemission" has value "0.000000" in row 1
Then field "indirekteemission" has value "0.000000" in row 1
Then field "cbampflicht" is not modifiable in row 2
Then field "cbampflicht" is not modifiable in row 3
And I set field "cbampflicht" to "ja" in row 1
Then field "direkteemission" is modifiable in row 1
Then field "indirekteemission" is modifiable in row 1
And I close the current editor


# ----------------------------------------------------------------------------------------------
Scenario: Aktualisierung CBAM-Felder in EK Vorgaengen Anfrage, Bestellung, Lieferschein, Rechnung
# ----------------------------------------------------------------------------------------------

# Drei Test Lieferanten anlegen
Given I open an editor "Lieferanten" from table "(Vendor):(Vendor)" with command "COPY" for record "1"
And I set fields
	| such        | LCBAM11      |
	| namebspr    | L_mit_CBAM11 |
	| cbampflicht | ja           |
	| waehr       | EUR          |
And I save the current editor

Given I open an editor "Lieferanten" from table "(Vendor):(Vendor)" with command "COPY" for record "1"
And I set fields
	| such        | LOCBAM12      |
	| namebspr    | L_ohne_CBAM12 |
  | cbampflicht | nein          |
	| waehr       | EUR           |
And I save the current editor


Given I open an editor "Lieferanten" from table "(Vendor):(Vendor)" with command "COPY" for record "1"
And I set fields
	| such        | LOCBAM13      |
	| namebspr    | L_ohne_CBAM13 |
  | cbampflicht | nein          |
	| waehr       | EUR           |
And I save the current editor

# Drei Testartikel anlegen.
# Artikel CBAM pflichtig, keine Lieferantenzeilen
Given I open an editor "ACBAM" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set fields
	| such               | ACBAM11  |
	| namebspr           | A_CBAM11 |
  | ahnum              | 111      | # CBAM pflichtig
And I save the current editor

# Artikel CBAM pflichtig, Lieferantenzeilen
Given I open an editor "ACBAM" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set fields
  | such                 | ACBAM12    |
  | namebspr             | ACBAM12    |
  | ahnum                | 111        | # CBAM pflichtig
  | lief2                | L_CBAM1    |
  | cbampflicht2         | ja         |
  | direkteemission2     | 11         |
  | lief3                | LCBAM11    |
  | cbampflicht3         | ja         |
  | direkteemission3     | 44         |
  | indirekteemission3   | 55         |
  | lief4                | LOCBAM12   |
  | cbampflicht4         | ja         |
  | direkteemission4     | 66         |
  | indirekteemission4   | 77         |
  | lief5                | LOCBAM13   |
  | cbampflicht5         | nein       |
And I save the current editor

# Artikel nicht CBAM pflichtig
Given I open an editor "ACBAM" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set fields
	| such               | ACBAM13  |
	| namebspr           | A_CBAM13 |
  | ahnum              | 112      | # nicht CBAM pflichtig
And I save the current editor

# ---------------------------------------------------------------------------------------------------
Scenario Outline: Bestellung anlegen und Werte aendern
# ---------------------------------------------------------------------------------------------------
Given I open an editor "CBAMEK" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
  | such   | BECB   |
  | lief   | <lief> |
# Bestellung mit gemischten Positionen
And I append rows
  | artikel      | mge          |
  | <artikel>    | 10           |
  | ACBAM12      | 20           |
  | TEXT         | !dontChange  |
  | ZS.          | !dontChange  |
  | DL-REPARATUR | 3            |
Then table has values
  | !row | artikel      | mge | cbampflicht         | direkteemission | indirekteemission |
  | 1    | <artikel>    | 10  | <soll_cbampflicht1> | <soll_de1>      | <soll_ie1>        |
  | 2    | ACBAM12      | 20  | <soll_cbampflicht2> | <soll_de2>      | <soll_ie2>        |
  | 3    | TEXT         | 0   | nein                | 0.000000        | 0.000000          |
  | 4    | ZS.          | 0   | nein                | 0.000000        | 0.000000          |
  | 5    | DL-REPARATUR | 3   | nein                | 0.000000        | 0.000000          |

# Artikel-Wechsel
And I set field "artikel" to "ACBAM12" in row 1
And I set field "mge" to "10" in row 1
Then table has values
  | !row | artikel      | mge | cbampflicht         | direkteemission | indirekteemission |
  | 1    | ACBAM12      | 10  | <soll_cbampflicht2> | <soll_de2>      | <soll_ie2>        |
  | 2    | ACBAM12      | 20  | <soll_cbampflicht2> | <soll_de2>      | <soll_ie2>        |
# zuruecksetzen
And I set field "artikel" to "<artikel>" in row 1
And I set field "mge" to "10" in row 1

# Lieferanten-Wechsel
And I set field "lief" to "LCBAM11"
Then table has values
  | !row | artikel      | mge | cbampflicht         | direkteemission | indirekteemission |
  | 1    | <artikel>    | 10  | <soll_cbampflicht1> | <soll_de1>      | <soll_ie1>        |
  | 2    | ACBAM12      | 20  | <soll_cbampflicht3> | 44.000000       | 55.000000         |
  | 3    | TEXT         | 0   | nein                | 0.000000        | 0.000000          |
  | 4    | ZS.          | 0   | nein                | 0.000000        | 0.000000          |
  | 5    | DL-REPARATUR | 3   | nein                | 0.000000        | 0.000000          |
And I save the current editor

Examples:
	| index | lief      	| artikel	| soll_cbampflicht1 | soll_de1 | soll_ie1  | soll_cbampflicht2 | soll_de2  | soll_ie2  | soll_cbampflicht3 |
	| 0     | !dontChange	| ACBAM11	| ja                | 0.000000 | 0.000000  | ja                | 0.000000  | 0.000000  | ja                |
	| 1     | !dontChange	| ACBAM13	| nein              | 0.000000 | 0.000000  | ja                | 0.000000  | 0.000000  | ja                |
	| 2     | LOCBAM12    | ACBAM13	| nein              | 0.000000 | 0.000000  | ja                | 66.000000 | 77.000000 | ja                |
	| 3     | LOCBAM13    | ACBAM13	| nein              | 0.000000 | 0.000000  | nein              | 0.000000  | 0.000000  | ja                |


# Testfaelle
#
# | Kein Lieferant | Lieferant          | Lieferant    || Artikel hat Lieferantenzeile | Artikel hat Lieferantenzeile |  Artikel hat Lieferantenzeile | Artikel hat keine |
# |                | keine CBAM Pflicht | CBAM Pflicht || CBAM Pflicht keine Werte     | CBAM Pflicht hat Werte       |  Keine CBAM Pflicht           | Lieferantenzeile  |
# |      X         |                    |              ||                              |                              |                               |        X          |
# |                |        X           |              ||            X                 |                              |                               |                   |
# |                |        X           |              ||                              |            X                 |                               |                   |
# |                |        X           |              ||                              |                              |               X               |                   |
# |                |        X           |              ||                              |                              |                               |        X          |
# |      X         |                    |              ||                              |                              |                               |        X          |
# |                |                    |      X       ||            X                 |                              |                               |                   |
# |                |                    |      X       ||                              |            X                 |                               |                   |
# |                |                    |      X       ||                              |                              |               X               |                   |
# |                |                    |      X       ||                              |                              |                               |         X         |

# ---------------------------------------------------------------------------------------------------
Scenario: CBAM Pflicht geben und nehmen
# ---------------------------------------------------------------------------------------------------
Given I open an editor "CBAMEK2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
  | such   | BECB2   |
  | lief   | LOCBAM12 |
# Bestellung mit gemischten Positionen
And I append rows
  | artikel    | mge   |
  | ACBAM12    | 10    |
Then table has values
  | artikel  | cbampflicht | direkteemission | indirekteemission |
  | ACBAM12  | ja          | 66.000000       | 77.000000         |
And I set field "direkteemission" to "23" in row 1
And I set field "indirekteemission" to "24" in row 1
Then table has values
  | artikel  | cbampflicht | direkteemission | indirekteemission |
  | ACBAM12  | ja          | 23.000000       | 24.000000         |
And I set field "cbampflicht" to "nein" in row 1
Then table has values
  | artikel  | cbampflicht | direkteemission | indirekteemission |
  | ACBAM12  | nein          | 0.000000      | 0.000000          |
And I set field "cbampflicht" to "ja" in row 1
Then table has values
  | artikel  | cbampflicht | direkteemission | indirekteemission |
  | ACBAM12  | ja          | 66.000000       | 77.000000         |
And I close the current editor

# Bein einer normalen Rechnung wird nicht initialisiert. Der Klick auf die Checkbox wirkt aber genauso
Given I open an editor "CBAMER2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
  | such   | RECB2    |
  | lief   | LOCBAM12 |
  | fakt   | nein     |
# Bestellung mit gemischten Positionen
And I append rows
  | artikel    | mge   |
  | ACBAM12    | 10    |
Then table has values
  | artikel  | cbampflicht | direkteemission | indirekteemission |
  | ACBAM12  | nein          | 0.000000      | 0.000000          |
And I set field "cbampflicht" to "ja" in row 1
Then table has values
  | artikel  | cbampflicht | direkteemission | indirekteemission |
  | ACBAM12  | ja          | 66.000000       | 77.000000         |
And I set field "direkteemission" to "23" in row 1
And I set field "indirekteemission" to "24" in row 1
Then table has values
  | artikel  | cbampflicht | direkteemission | indirekteemission |
  | ACBAM12  | ja          | 23.000000       | 24.000000         |
And I set field "cbampflicht" to "nein" in row 1
Then table has values
  | artikel  | cbampflicht | direkteemission | indirekteemission |
  | ACBAM12  | nein          | 0.000000      | 0.000000          |
And I set field "cbampflicht" to "ja" in row 1
Then table has values
  | artikel  | cbampflicht | direkteemission | indirekteemission |
  | ACBAM12  | ja          | 66.000000       | 77.000000         |
And I close the current editor


# ---------------------------------------------------------------------------------------------------
Scenario: Rechnung mit LB und CBAM-Pflicht
# ---------------------------------------------------------------------------------------------------
Given I open an editor "CBAMEK" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
  | nummer | 01BECB  |
  | lief   | LCBAM11 |
  | such   | BECB    |
# Rechnung mit gemischten Positionen
And I append rows
  | artikel      | mge          |
  | ACBAM11      | 10           |
  | ACBAM12      | 20           |
  | TEXT         | !dontChange  |
  | ZS.          | !dontChange  |
  | DL-REPARATUR | 3            |
Then table has values
  | !row | artikel      | mge | cbampflicht | direkteemission | indirekteemission |
  | 1    | ACBAM11      | 10  | ja          | 0.000000        | 0.000000          |
  | 2    | ACBAM12      | 20  | ja          | 44.000000       | 55.000000         |
  | 3    | TEXT         | 0   | nein        | 0.000000        | 0.000000          |
  | 4    | ZS.          | 0   | nein        | 0.000000        | 0.000000          |
  | 5    | DL-REPARATUR | 3   | nein        | 0.000000        | 0.000000          |
And I set field "cbampflicht" to "nein" in row 2
Then field "direkteemission" has value "0.000000" in row 2
And I save the current editor

Given I open an editor "CBAMEK" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "CBAMEK"
And I set fields
  | nummer | 01RBECB  |
  | such   | RECB    |
  | lief   | LCBAM11 |
# Default ist  RE ohne LB

# Rechnung mit gemischten Positionen
And I append rows
  | artikel      | mge          |
  | ACBAM11      | 10           |
  | ACBAM12      | 20           |
  | TEXT         | !dontChange  |
  | ZS.          | !dontChange  |
  | DL-REPARATUR | 3            |
Then table has values
  | !row | artikel      | mge | cbampflicht | direkteemission | indirekteemission |
  | 1    | ACBAM11      | 0   | ja          | 0.000000        | 0.000000          |
  | 2    | ACBAM12      | 0   | nein        | 0.000000        | 0.000000          |
  | 3    | TEXT         | 0   | nein        | 0.000000        | 0.000000          |
  | 4    | ZS.          | 0   | nein        | 0.000000        | 0.000000          |
  | 5    | DL-REPARATUR | 0   | nein        | 0.000000        | 0.000000          |

# RE -> RE+LB
And I set field "fakt" to "ja"
Then table has values
  | !row | artikel      | mge | cbampflicht | direkteemission | indirekteemission |
  | 1    | ACBAM11      | 0   | ja          | 0.000000        | 0.000000          |
  | 2    | ACBAM12      | 0   | ja          | 44.000000       | 55.000000         |
  | 3    | TEXT         | 0   | nein        | 0.000000        | 0.000000          |
  | 4    | ZS.          | 0   | nein        | 0.000000        | 0.000000          |
  | 5    | DL-REPARATUR | 0   | nein        | 0.000000        | 0.000000          |

# RE+LB ->  RE zurueck
And I set field "fakt" to "nein"
Then table has values
  | !row | artikel      | mge | cbampflicht | direkteemission | indirekteemission |
  | 1    | ACBAM11      | 0   | ja          | 0.000000        | 0.000000          |
  | 2    | ACBAM12      | 0   | ja          | 44.000000       | 55.000000         |
  | 3    | TEXT         | 0   | nein        | 0.000000        | 0.000000          |
  | 4    | ZS.          | 0   | nein        | 0.000000        | 0.000000          |
  | 5    | DL-REPARATUR | 0   | nein        | 0.000000        | 0.000000          |
  And I close the current editor

# ---------------------------------------------------------------------------------------------------
Scenario: Maskenpruefung auf CBAM Felder
# ---------------------------------------------------------------------------------------------------
# Lieferschein
Given I open an editor "CBAMMP" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | such   | LSCBMP  |
  | lief   | LCBAM11 |
  | ebeleg | 123     |
  | tterm  | .       |
  | vom    | .       |
  | ueb    | ja      |
# Rechnung mit gemischten Positionen
And I append rows
  | artikel      | mge          | direkteemission | indirekteemission |
  | ACBAM11      | 10           | 0.000000        | 0.000000          |
  | ACBAM12      | 20           | 0.000000        | 0.000000          |
  | ACBAM12      | 30           | 0.000000        | 0.000000          |
  | TEXT         | !dontChange  | !dontChange     | !dontChange       |
  | ZS.          | !dontChange  | !dontChange     | !dontChange       |
  | DL-REPARATUR | 3            | !dontChange     | !dontChange       |
# Es wurden nicht alle CBAM Emmissionswerte eingegeben. Trotzdem weiter?
And I respond with answer "nein" to the dialog with id "4970"
Then saving the current editor throws the exception "10418"
And I set field "direkteemission" to "1" in row 1
And I respond with answer "nein" to the dialog with id "4970"
Then saving the current editor throws the exception "10418"
And I set field "indirekteemission" to "2" in row 2
# Es wurden nicht alle CBAM Emmissionswerte eingegeben. Trotzdem weiter?
And I respond with answer "ja" to the dialog with id "4970"
And I save the current editor

# RE+LB
Given I open an editor "CBAMMP" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
  | lief   | LCBAM11 |
  | such   | BECBMP  |
  | ebeleg | 123     |
  | tterm  | .       |
  | vom    | .       |
# Bestellung mit gemischten Positionen
And I append rows
  | artikel      | mge          | direkteemission | indirekteemission |
  | ACBAM11      | 10           | 0.000000        | 0.000000          |
  | ACBAM12      | 20           | 0.000000        | 0.000000          |
  | ACBAM12      | 30           | 0.000000        | 0.000000          |
  | TEXT         | !dontChange  | !dontChange     | !dontChange       |
  | ZS.          | !dontChange  | !dontChange     | !dontChange       |
  | DL-REPARATUR | 3            | !dontChange     | !dontChange       |
 And I save the current editor

Given I open an editor "CBAMMP" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "CBAMMP"
And I set fields
  | lief   | LCBAM11 |
  | such   | LSCBMPR |
  | ebeleg | 1234    |
  | tterm  | .       |
  | vom    | .       |
  | fakt   | ja      |
  | ueb    | ja      |
And I modify table
  | !row | mge | direkteemission | indirekteemission |
  | 1    | 10  | 0.000000        | 0.000000          |
  | 2    | 20  | 0.000000        | 0.000000          |
  | 3    | 30  | 0.000000        | 0.000000          |
#And I save the current editor
#Rechnungsabschlusspositionen wurden ergaenzt - ok?
And I respond with answer "ja" to the dialog with id "4841"
# Es wurden nicht alle CBAM Emmissionswerte eingegeben. Trotzdem weiter?
And I respond with answer "nein" to the dialog with id "4970"
Then saving the current editor throws the exception "10418"
And I set field "direkteemission" to "1" in row 1
# Es wurden nicht alle CBAM Emmissionswerte eingegeben. Trotzdem weiter?
And I respond with answer "nein" to the dialog with id "4970"
Then saving the current editor throws the exception "10418"
And I set field "indirekteemission" to "2" in row 2
# Es wurden nicht alle CBAM Emmissionswerte eingegeben. Trotzdem weiter?
And I respond with answer "ja" to the dialog with id "4970"
And I save the current editor

# ---------------------------------------------------------------------------------------------------
Scenario: Kopieren LS, RE+LB CBAM-Meldepflicht Felder aus dem Artikelstamm initialisieren
# ---------------------------------------------------------------------------------------------------
# Lieferschein -> Kopieren
Given I open an editor "LS-CBAM-10" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
  | nummer | 10LS    |
  | ebeleg | 10LS    |
  | lief   | L_CBAM1 |
  | such   | LS-10   |
  | vom    | .       |
  | tterm  | .       |
And I append rows
  | artikel    | mge | cbampflicht | direkteemission | indirekteemission |
  | A_CBAM1    | 10  |          ja |        0.000001 |          0.000011 |
  | ACBAM12    | 88  |          ja |        1.000000 |          2.000000 |
  | AU/BE      |  2  | !dontChange |     !dontChange |       !dontChange |
  | ACBAM13    | 14  |          ja |              13 |          0.000000 |
Then field "cbamposvorhanden" has value "nein"
And I save the current editor
Then field "cbamposvorhanden" has value "ja"
# Kopieren
Given I open an editor "LS-CBAM-10-Kopie" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "LS-CBAM-10"
And I set fields
  | ebeleg | LS-CBAM10-K |
  | tterm  | .           |
  | vom    | .           |
Then table has values
  | !row | artikel    | mge | cbampflicht | direkteemission | indirekteemission |
  | 1    | A_CBAM1    | 10  |          ja |        1.000000 |          0.999999 |
  | 2    | ACBAM12    | 88  |          ja |       11.000000 |          0.000000 |
  | 3    | AU/BE      |  2  |        nein |        0.000000 |          0.000000 |
  | 4    | ACBAM13    | 14  |        nein |        0.000000 |          0.000000 |
Then field "cbamposvorhanden" has value "nein"
And I save the current editor
Then field "cbamposvorhanden" has value "ja"
# Kopieren - Mengenpostionen ausnullen fuer CBAM-Meldepflicht Positionen
Given I open an editor "LS-CBAM-10-Kopie2" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "LS-CBAM-10"
And I set fields
  | ebeleg | LS-CBAM10-K2 |
  | tterm  | .            |
  | vom    | .            |
And I set field "mge" to "0" in row 1
And I set field "mge" to "0" in row 2
Then field "cbamposvorhanden" has value "nein"
And I save the current editor
Then field "cbamposvorhanden" has value "nein"
# Kopieren - CBAM-Meldepflicht Positionen loeschen
Given I open an editor "LS-CBAM-10-Kopie2" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "LS-CBAM-10"
And I set fields
  | ebeleg | LS-CBAM10-K2 |
  | tterm  | .           |
  | vom    | .           |
And I delete row at position 2
And I delete row at position 1
Then field "cbamposvorhanden" has value "nein"
And I save the current editor
Then field "cbamposvorhanden" has value "nein"

# Rechnung mit Lagerbewegung -> Kopieren
Given I open an editor "RELB-10" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
  | nummer   | 1RE10   |
  | ueb      |    ja   |
  | lief     | L_CBAM1 |
  | tterm    |     .   |
  | vom      |     .   |
  | erfwaehr |   EUR   |
And I append rows
  | artikel    | mge | cbampflicht | direkteemission | indirekteemission |
  | A_CBAM1    |  24 |          ja |        1.000002 |          1.000022 |
  | ACBAM12    |  42 |          ja |        1.000000 |          2.000000 |
  | AU/BE      |   2 | !dontChange |     !dontChange |       !dontChange |
  | ACBAM13    |  14 |          ja |              13 |          0.000000 |
Then field "fakt" has value "ja"
Then field "cbamposvorhanden" has value "nein"
And I save the current editor
Then field "cbamposvorhanden" has value "ja"
# Kopieren
Given I open an editor "RELB-10-Kopie" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "RELB-10"
And I set fields
  | ebeleg | RELB-10-K |
  | tterm  | .         |
  | vom    | .         |
Then table has values
  | !row | artikel | mge | cbampflicht | direkteemission | indirekteemission |
  | 1    | A_CBAM1 | 24  |          ja |        1.000000 |          0.999999 |
  | 2    | ACBAM12 | 42  |          ja |       11.000000 |          0.000000 |
  | 3    | AU/BE   |  2  |        nein |        0.000000 |          0.000000 |
  | 4    | ACBAM13 | 14  |        nein |        0.000000 |          0.000000 |
Then field "cbamposvorhanden" has value "nein"
And I save the current editor
Then field "cbamposvorhanden" has value "ja"

# ---------------------------------------------------------------------------------------------------
Scenario: Bestellung mit und ohne CBAM pflichtigen Positionen, LS mit Menge 0 fuer CBAM Position
# ---------------------------------------------------------------------------------------------------
# Bestellung mit und ohne CBAM pflichtigen Position
Given I open an editor "CBAM_10" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
  | lief   | LCBAM11 |
  | such   | BECBM10 |
  | ebeleg | 10      |
  | tterm  | .       |
  | vom    | .       |
# Bestellung mit gemischten Positionen
And I append rows
  | artikel  | mge          | cbampflicht |
  | ACBAM11  | 10           |          ja |
  | TEXT     | !dontChange  | !dontChange |
  | E2       | 30           |        nein |
And I save the current editor

# Lieferschein mit Menge 0 fuer CBAM Position
Given I open an editor "LS-101" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "CBAM_10"
And I set fields
  | nummer | 101LS    |
  | ebeleg | 101LS    |
  | such   | LS-101   |
  | vom    | .        |
  | tterm  | .        |
And I set field "mge" to "10" in row 3
And I save the current editor
Then field "cbamposvorhanden" has value "nein"

# ---------------------------------------------------------------------------------------------------
Scenario: Vererbung CBAM in der Vorgangskette
# ---------------------------------------------------------------------------------------------------
# Nur bei reinen Artikeln und angekreuzter CBAM-Pflicht aenderbar
# Anfrage
Given I open an editor "ANF-V" from table "(Purchasing):(Request)" with command "NEW" for record ""
And I set fields
  | lief | LOCBAM12 |
  | such | ANF-V    |
And I append rows
  | artikel    | mge |
  | E3         | 10  |
  | ACBAM12    | 20  |
  | ACBAM12    | 30  |
  | ACBAM12    | 40  |
# In der Anfrage wird lediglich die CBAM Pflicht vorbelegt. Emissionswerte bleiben frei (Werden beim Lieferanten angefragt)
Then table has values
  | !row | artikel  | mge | cbampflicht | direkteemission | indirekteemission |
  | 1    | E3       | 10  | nein        | 0.000000        | 0.000000          |
  | 2    | ACBAM12  | 20  | ja          | 0.000000        | 0.000000          |
  | 3    | ACBAM12  | 30  | ja          | 0.000000        | 0.000000          |
  | 4    | ACBAM12  | 40  | ja          | 0.000000        | 0.000000          |
And I set field "cbampflicht" to "nein" in row 2
Then table has values
  | !row | artikel  | mge | cbampflicht | direkteemission | indirekteemission |
  | 1    | E3       | 10  | nein        | 0.000000        | 0.000000          |
  | 2    | ACBAM12  | 20  | nein        | 0.000000        | 0.000000          |
  | 3    | ACBAM12  | 30  | ja          | 0.000000        | 0.000000          |
  | 4    | ACBAM12  | 40  | ja          | 0.000000        | 0.000000          |
And I set field "cbampflicht" to "ja" in row 2
Then table has values
  | !row | artikel  | mge | cbampflicht | direkteemission | indirekteemission |
  | 1    | E3       | 10  | nein        | 0.000000        | 0.000000          |
  | 2    | ACBAM12  | 20  | ja          | 66.000000       | 77.000000         |
  | 3    | ACBAM12  | 30  | ja          | 0.000000        | 0.000000          |
  | 4    | ACBAM12  | 40  | ja          | 0.000000        | 0.000000          |
And I set field "cbampflicht" to "ja" in row 1
And I set field "direkteemission" to "66.000000" in row 1
And I set field "indirekteemission" to "77.000000" in row 1
And I set field "cbampflicht" to "ja" in row 2
And I set field "direkteemission" to "88.000000" in row 2
And I set field "indirekteemission" to "99.000000" in row 2
Then table has values
  | !row | artikel  | mge | cbampflicht | direkteemission | indirekteemission |
  | 1    | E3       | 10  | ja          | 66.000000       | 77.000000         |
  | 2    | ACBAM12  | 20  | ja          | 88.000000       | 99.000000         |
  | 3    | ACBAM12  | 30  | ja          | 0.000000        | 0.000000          |
  | 4    | ACBAM12  | 40  | ja          | 0.000000        | 0.000000          |
And I save the current editor

# Anfrage bestellen
Given I open an editor "BE-V" from table "(Purchasing):(Request)" with command "RELEASE" for record from editor "ANF-V"
And I set fields
  | such | BE-V    |
Then table has values
  | !row | artikel  | mge | cbampflicht | direkteemission | indirekteemission |
  | 1    | E3       | 10  | ja          | 66.000000       | 77.000000         | # Aus Vorgaenger uebernommen
  | 2    | ACBAM12  | 20  | ja          | 88.000000       | 99.000000         | # Aus Vorgaenger uebernommen
  | 3    | ACBAM12  | 30  | ja          | 0.000000        | 0.000000          | # Aus Vorgaenger uebernommen
  | 4    | ACBAM12  | 40  | ja          | 0.000000        | 0.000000          | # Aus Vorgaenger uebernommen
And I set field "cbampflicht" to "ja" in row 3
And I set field "direkteemission" to "34.000000" in row 3
And I set field "indirekteemission" to "35.000000" in row 3
And I set field "cbampflicht" to "nein" in row 4
And I save the current editor

# RE+LB (Teil)
Given I open an editor "RE-V" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE-V"
And I set fields
  | such   | RE-V   |
  | ebeleg | RE-V-K |
  | tterm  | .      |
  | vom    | .      |

# Default ist  RE ohne LB
Then table has values
  | !row | artikel  | mge | cbampflicht | direkteemission | indirekteemission |
  | 1    | E3       | 0   | ja          | 66.000000       | 77.000000         | # Aus Vorgaenger uebernommen
  | 2    | ACBAM12  | 0   | ja          | 88.000000       | 99.000000         | # Aus Vorgaenger uebernommen
  | 3    | ACBAM12  | 0   | ja          | 34.000000       | 35.000000         | # Aus Vorgaenger uebernommen
  | 4    | ACBAM12  | 0   | nein        | 0.000000        | 0.000000          | # Aus Vorgaenger uebernommen

# RE -> RE+LB
And I set field "cbampflicht" to "nein" in row 4
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
Then table has values
  | !row | artikel  | mge | cbampflicht | direkteemission | indirekteemission |
  | 1    | E3       | 0   | ja          | 66.000000       | 77.000000         | # Aus Vorgaenger uebernommen
  | 2    | ACBAM12  | 0   | ja          | 88.000000       | 99.000000         | # Aus Vorgaenger uebernommen
  | 3    | ACBAM12  | 0   | ja          | 34.000000       | 35.000000         | # Aus Vorgaenger uebernommen
  | 4    | ACBAM12  | 0   | ja          | 66.000000       | 77.000000         | # Initialisiert aus Artikelstamm
And I modify table
  | !row | mge |
  | 1    | 5   |
  | 2    | 10  |
  | 3    | 15  |
  | 4    | 20  |
And I save the current editor

# Rest der BE ueber LS und anschliessender RE
# RE+LB (Teil)
Given I open an editor "LS-V" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE-V"
And I set fields
    | such     | LS-V   |
    | vom      | .      |
    | ueb      | ja     |
    | ebeleg   | LSV    |
    | budat    | .      |
Then table has values
  | !row | artikel  | mge | cbampflicht | direkteemission | indirekteemission |
  | 1    | E3       | 0   | ja          | 66.000000       | 77.000000         | # Aus Vorgaenger uebernommen
  | 2    | ACBAM12  | 0   | ja          | 88.000000       | 99.000000         | # Aus Vorgaenger uebernommen
  | 3    | ACBAM12  | 0   | ja          | 34.000000       | 35.000000         | # Aus Vorgaenger uebernommen
  | 4    | ACBAM12  | 0   | ja          | 66.000000       | 77.000000         | # Initialisiert aus Artikelstamm
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I press button "offueb" in row 3
And I press button "offueb" in row 4
And I set field "direkteemission" to "36.000000" in row 3
And I set field "indirekteemission" to "37.000000" in row 3
And I set field "cbampflicht" to "nein" in row 4
Then table has values
  | !row | artikel  | mge | cbampflicht | direkteemission | indirekteemission |
  | 1    | E3       | 5   | ja          | 66.000000       | 77.000000         | # Aus Vorgaenger uebernommen
  | 2    | ACBAM12  | 10  | ja          | 88.000000       | 99.000000         | # Aus Vorgaenger uebernommen
  | 3    | ACBAM12  | 15  | ja          | 36.000000       | 37.000000         | # Aus Vorgaenger uebernommen
  | 4    | ACBAM12  | 20  | nein        | 0.000000        | 0.000000          | # Wurde 0 gesetzt
And I save the current editor

# RE aus LS
Given I open an editor "RE-V2" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS-V"
And I set fields
  | such   | RE-V2   |
  | vom    | .       |
  | ueb    | ja      |
  | ebeleg | LSV     |
  | budat  | .       |
Then table has values
  | !row | artikel  | mge | cbampflicht | direkteemission | indirekteemission |
  | 1    | E3       | 5   | ja          | 66.000000       | 77.000000         | # Aus Vorgaenger uebernommen
  | 2    | ACBAM12  | 10  | ja          | 88.000000       | 99.000000         | # Aus Vorgaenger uebernommen
  | 3    | ACBAM12  | 15  | ja          | 36.000000       | 37.000000         | # Aus Vorgaenger uebernommen
  | 4    | ACBAM12  | 20  | nein        | 0.000000        | 0.000000          | # Aus Vorgaenger uebernommen
  And I save the current editor

