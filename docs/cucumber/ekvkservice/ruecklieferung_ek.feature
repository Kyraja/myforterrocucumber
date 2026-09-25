# *****************************************************************************
#  Name           : ruecklieferung_ek.feature
#  Autor          : dago
#  Verantwortlich : teampss
#  Funktion       : EK: Behandlung von Ruecklieferungen, Teilruecklieferungen, Storno von Ruecklieferungen
#
# *****************************************************************************
#
@persistent
Feature: Ruecklieferung EK
Background: Test von Ruecklieferungen im Einkauf
Given I set the fake date to "02.01.1995"
Given I enable the flag 39

###############################################################################
# E I N K A U F
###############################################################################

@Testdaten
Scenario: Testdaten (Stammdaten) anlegen
Given I open an editor "konfig" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
And I set field "projekt" to "ja"
And I save the current editor

# Konsilager, Konsilagergruppe anlegen
Given I open an editor "Lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "KONSILG"
And I set field "such" to "KONSILG"
And I set field "zkonsilg" to "Ja"
And I save the current editor

Given I open an editor "Lager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "KONSILAGER"
And I set field "such" to "KONSILAGER"
And I set field "lgruppe" to "KONSILG"
And I save the current editor

Given I open an editor "Lagerplatz" from table "(Location):(Location)" with command "STORE" for record "KONSILP"
And I set field "such" to "KONSILP"
And I set field "lager" to "KONSILAGER"
And I save the current editor

Given I open an editor "AUBEPos" from table "(Part):(SupplementaryItem)" with command "STORE" for record "AUBE"
And I set field "such" to "AUBE"
And I set field "zptyp" to "AU/BE"
And I set field "vpr" to "1100.00"
And I set field "epr" to "1000.00"

And I save the current editor

Scenario Outline: Testdaten (Stammdaten) anlegen Artikel
# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vpr" to "1000"
And I set field "bsart" to "Eigenfertigung"
And I set field "dispoa" to "<dispoa>"
And I set field "le" to "<le>"
And I set field "chimlager" to "<chimlager>"
And I save the current editor

Examples:

 |row |such   |namebspr                        |dispoa                  |le    |chimlager |
 |01  |ARTVARI|Artikel variantenbezogen        |variantenbezogen        |Stück |Nein      |
 |02  |ARTAUFT|Artikel auftragsbezogen         |auftragsbezogen         |Stück |Nein      |
 |03  |ARTERWB|Artikel erweitert bedarfsbezogen|erweitert bedarfsbezogen|Stück |Nein      |
 |04  |ARTBEDA|Artikel bedarfsbezogen          |bedarfsbezogen          |Stück |Nein      |
 |04  |ARTBESZ|Artikel bedarfsbezogen Satz     |bedarfsbezogen          |Satz  |Ja        |
 |05  |ARTAUBE|Artikel AU/BE                   |bedarfsbezogen          |Satz  |Ja        |

Scenario Outline: Testdaten (Stammdaten) anlegen Chargen, Projekte
Given I set the fake date to "22.04.1995"

# Chargen anlegen
Given I open an editor "RLCHARGEN" from table "(Lots):(Lots)" with command "STORE" for record "<charge>"
Then I set field "such" to "<charge>"
Then I set field "artikel" to "<artikel>"
And I save the current editor

# Projekte anlegen
Given I open an editor "RLCHARGEN" from table "(Transaction):(Project)" with command "STORE" for record "<projekt>"
Then I set field "such" to "<projekt>"
And I save the current editor

Examples:

 |row |artikel |projekt   |charge     |
 |01  |ARTBEDA |projekt01 |RLcharge01 |
 |02  |ARTVARI |projekt02 |RLcharge02 |
 |03  |ARTERWB |projekt03 |RLcharge03 |
 |04  |ARTBESZ |projekt04 |RLcharge04 |

#------------------------------------------------------------------------------
# TSQ-RUECK-001: Kommando <retoure> (bzw. <return>)
#------------------------------------------------------------------------------

@Lieferschein
Scenario: Kommando <(Purchasing)> LIEFERSCHEIN <(return)>
# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
# Lieferscheinart kann nicht geandert werden.
Given I open an editor "ruecklief" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS003"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "rueckligrund" to "Transportschaden"
# Nachfolgende Felder duerfen nicht in einem Ruecklieferschein geaendert werden
And setting field "lsart" to "Lieferschein" throws the exception ""
And setting field "kunde" to "1" throws the exception ""
And setting field "warenempf" to "1" throws the exception ""
And setting field "artikel" to "E1" in row 1 throws the exception ""
And setting field "mge" to "2" in row 1 throws the exception ""
Then field "fakt" has value "ja"
And setting field "fakt" to "nein" throws the exception ""
And I close the current editor

@Rechnung+Lagerbewegung
Scenario: Kommando <(Purchasing)> RECHNUNG <(return)>
# Aus einer Rechnung mit Lagerbewegung (abgelegt) wird ueber Kommando RETURN ein Ruecklieferschein
# Lieferscheinart kann nicht geandert werden.
Given I open an editor "ruecklief" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE007"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "vorganga" has value ""
# Nachfolgende Felder duerfen nicht in einem Ruecklieferschein geaendert werden
And setting field "lsart" to "Lieferschein" throws the exception ""
And setting field "lief" to "1" throws the exception ""
And setting field "warenempf" to "1" throws the exception ""
And setting field "artikel" to "E1" in row 1 throws the exception ""
And setting field "mge" to "-12" in row 1 throws the exception ""
# Preis darf nicht negativ sein.
And setting field "preis" to "-12" in row 1 throws the exception ""
Then field "fakt" has value "ja"
And setting field "fakt" to "nein" throws the exception ""
And I close the current editor

@Lieferschein
Scenario: Versuchen gespeicherten Ruecklieferschein zu aendern
# Anlegen eines Lieferscheins / buchen
Given I open an editor "templief" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
Then I set field "lief" to "1"
Then I set field "nummer" to "1LS009"
Then I set field "such" to "LS009"
Then I set field "vom" to "."
Then I set field "ebeleg" to "111"
Then I set field "ueb" to "Ja"
And I create a new row at the end of the table
Then I set field "artikel" to "E2" in row !lastRow
Then I set field "mge" to "8" in row !lastRow
And I save the current editor

# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
# Lieferscheinart kann nicht geandert werden.
Given I open an editor "rueckliefaend" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "LS009"
Then I set field "such" to "RLS009"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then I set field "ebeleg" to "112"
Then I set field "mge" to "-1" in row !lastRow
Then I set field "rueckligrund" to "Falschbestellung" in row !lastRow
And I save the current editor

# Erneutes Oeffnen und versuchen zu aendern
Given I open an editor "rueckliefaend2" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "RLS009"
# Nachfolgende Felder duerfen nicht in einem geanderten Ruecklieferschein geaendert werden
And setting field "lsart" to "Lieferschein" throws the exception ""
And setting field "lief" to "1" throws the exception ""
And setting field "warenempf" to "1" throws the exception ""
And setting field "artikel" to "E1" in row 1 throws the exception ""
And I close the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-002: Teilruecklieferung gebuchter Lieferschein
#------------------------------------------------------------------------------

@TeilruecklieferungLS
Scenario: Teilruecklieferung gebuchter Lieferschein
# 1. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS100"
Then I set field "nummer" to "1LS100R1"
Then I set field "vom" to "."
Then I set field "mge" to "-3" in row 1
Then field "fixpwert" has value "ja" in row 1
# Then I set field "fixpwert" to "nein" in row 1
Then I set field "mge" to "-1" in row 4
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS100"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS100R1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# 2. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS100"
Then I set field "nummer" to "1LS100R2"
Then I set field "vom" to "."
Then I set field "mge" to "-4" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS100"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS100R2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# 3. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS100"
Then I set field "nummer" to "1LS100R3"
Then I set field "vom" to "."
Then I set field "mge" to "-5" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS100"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS100R3"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# 2. Teilruecklieferung zuruecknehmen
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS100R2"
Then I set field "mge" to "0" in row 1
Then I set field "vom" to "."
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS100"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS100R2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# 1. Teilruecklieferung buchen
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS100R1"
Then I set field "ueb" to "ja"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS100"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS100R1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# 4. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS100"
Then I set field "nummer" to "1LS100R4"
Then I set field "ueb" to "ja"
Then I set field "mge" to "-4" in row 1
Then I set field "vom" to "."
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS100"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS100R4"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# 3. Teilruecklieferung buchen
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS100R3"
Then I set field "ueb" to "ja"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS100"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS100R3"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-003: Teilruecklieferung Rechnung mit Lagerbewegung
#------------------------------------------------------------------------------

@TeilruecklieferungRE
Scenario: Teilruecklieferung Rechnung mit Lagerbewegung
# 1. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE101"
Then I set field "nummer" to "1LS101R1"
Then I set field "vom" to "."
Then I set field "mge" to "-3" in row 1
Then field "fixpwert" has value "ja" in row 1
# Then I set field "fixpwert" to "nein" in row 1
Then I set field "mge" to "-1" in row 4
And I save the current editor

# Ausgabe Rechnung mit Lagerbewegung
Given I open an editor "teilrueck" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1RE101"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS101R1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# 2. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE101"
Then I set field "nummer" to "1LS101R2"
Then I set field "vom" to "."
Then I set field "mge" to "-4" in row 1
And I save the current editor

# Ausgabe Rechnung mit Lagerbewegung
Given I open an editor "teilrueck" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1RE101"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS101R2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# 3. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE101"
Then I set field "nummer" to "1LS101R3"
Then I set field "vom" to "."
Then I set field "mge" to "-5" in row 1
And I save the current editor

# Ausgabe Rechnung mit Lagerbewegung
Given I open an editor "teilrueck" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1RE101"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS101R3"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# 2. Teilruecklieferung zuruecknehmen
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS101R2"
Then I set field "mge" to "0" in row 1
And I save the current editor

# Ausgabe Rechnung mit Lagerbewegung
Given I open an editor "teilrueck" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1RE101"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS101R2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# 1. Teilruecklieferung buchen
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS101R1"
Then I set field "ueb" to "ja"
And I save the current editor

# Ausgabe Rechnung mit Lagerbewegung
Given I open an editor "teilrueck" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1RE101"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS101R1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# 4. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE101"
Then I set field "nummer" to "1LS101R4"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
Then I set field "mge" to "-4" in row 1
And I save the current editor

# Ausgabe Rechnung mit Lagerbewegung
Given I open an editor "teilrueck" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1RE101"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS101R4"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# 3. Teilruecklieferung buchen
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS101R3"
Then I set field "ueb" to "ja"
And I save the current editor

# Ausgabe Rechnung mit Lagerbewegung
Given I open an editor "teilrueck" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1RE101"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS101R3"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-004: Gemischte Teillieferung und Teilruecklieferung
#------------------------------------------------------------------------------

@TeillieferRueckliefer
Scenario: Teillieferung und Teilruecklieferung
# 1. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+1LS105"
Then I set field "nummer" to "1LS105R1"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
Then I set field "mge" to "-50" in row 1
And I save the current editor

# Ausgabe Teillieferung
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS105"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferung
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS105R1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Teillieferung
Given I open an editor "teilrueck" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "1BE105"
Then I set field "nummer" to "1LS106"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
Then I set field "mge" to "25" in row 1
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "teilrueck" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "+1BE105"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Teillieferung
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS106"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# 2. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+1LS105"
Then I set field "nummer" to "1LS105R2"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
Then I set field "mge" to "-25" in row 1
Then I set field "beleg" to "1LS106"
Then I set field "mge" to "-25" in row 3
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "teilrueck" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "+1BE105"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Teillieferung
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS105"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Teillieferung
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS106"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferung
Given I open an editor "teilrueck" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS105R2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-007: Storno Teilruecklieferung gebuchter Lieferschein
#------------------------------------------------------------------------------

@TeilruecklieferungLSStorno
Scenario: Storno Teilruecklieferung gebuchter Lieferschein
# 1. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS102"
Then I set field "nummer" to "1LS102R1"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
Then I set field "mge" to "-5" in row 1
Then I set field "mge" to "-1" in row 4
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS102"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS102R1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# 2. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS102"
Then I set field "nummer" to "1LS102R2"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
Then I set field "mge" to "-7" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS102"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS102R2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Storno 1. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+1LS102R1"
Then I set field "nummer" to "1LS102S1"
And I save the current editor
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I close the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS102"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe stornierter Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS102R1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Storno-Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS102S1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Storno 2. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+1LS102R2"
Then I set field "nummer" to "1LS102S2"
And I set field "bem" to "Storno 2. TeilRueckLS"
And I save the current editor
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I close the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS102"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe stornierter Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS102R2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Storno-Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS102S2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# 3. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1LS102"
Then I set field "nummer" to "1LS102R3"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
Then I set field "mge" to "-12" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS102"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS102R3"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-008: Storno Teilruecklieferung Rechnung mit Lagerbewegung
#------------------------------------------------------------------------------

@TeilruecklieferungREStorno
Scenario: Storno Teilruecklieferung Rechnung mit Lagerbewegung
# 1. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE103"
Then I set field "nummer" to "1LS103R1"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
Then I set field "mge" to "-5" in row 1
Then I set field "mge" to "-1" in row 4
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "teilrueckstorno" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1RE103"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS103R1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# 2. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE103"
Then I set field "nummer" to "1LS103R2"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
Then I set field "mge" to "-7" in row 1
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "teilrueckstorno" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1RE103"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS103R2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Storno 1. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "1LS103R1"
Then I set field "nummer" to "1LS103S1"
And I save the current editor
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I close the current editor

# Ausgabe Rechnung
Given I open an editor "teilrueckstorno" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1RE103"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe stornierter Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS103R1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Storno-Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS103S1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Storno 2. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "1LS103R2"
Then I set field "nummer" to "1LS103S2"
And I save the current editor
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I close the current editor

# Ausgabe Rechnung
Given I open an editor "teilrueckstorno" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1RE103"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe stornierter Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS103R2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Storno-Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+1LS103S2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# 3. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE103"
Then I set field "nummer" to "1LS103R3"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
Then I set field "mge" to "-12" in row 1
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "teilrueckstorno" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+1RE103"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "1LS103R3"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I close the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-010: Beleg anfuegen im Ruecklieferschein - ganze Vorgaenge
#------------------------------------------------------------------------------

@RuecklieferungBelegAnfuegen
Scenario: Beleg anfuegen im Ruecklieferschein
Given I open an editor "rliefbeleganf" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE010"
Then I set field "nummer" to "1LS010R1"
Then I set field "vom" to "."
# Bestellung
And setting field "beleg" to "1BE001" throws the exception ""
# Anzahlungsrechnung, gebucht
And setting field "beleg" to "+1RE001A" throws the exception ""
# Schlussrechnung, ohne Lagerbewegung, gebucht
And setting field "beleg" to "+1RE001" throws the exception ""
# Anzahlungsrechnung, nicht gebucht
And setting field "beleg" to "1RE002A" throws the exception ""
# Schlussrechnung, ohne Lagerbewegung, nicht gebucht
And setting field "beleg" to "1RE002" throws the exception ""
# Rechnung aus Lieferschein, gebucht
And setting field "beleg" to "+1RE003" throws the exception ""
# Lieferschein, Rechnung ueber Bestellung, nicht gebucht
And setting field "beleg" to "1LS004" throws the exception ""
# Rechnung aus Bestellung, ohne Lagerbewegung, nicht gebucht
And setting field "beleg" to "1RE004" throws the exception ""
# Stornierter Lieferschein
And setting field "beleg" to "+1LS005" throws the exception ""
# Storno-Lieferschein
And setting field "beleg" to "+1LS005S" throws the exception ""
# Stornierte Rechnung
And setting field "beleg" to "+1RE006" throws the exception ""
# Storno-Rechnung
And setting field "beleg" to "+1RE006S" throws the exception ""
# Rechnung mit Lagerbewegung, nicht gebucht
And setting field "beleg" to "1RE008" throws the exception ""
# Lieferschein, Rechnung ueber Lieferschein, gebucht, nicht abgelegt
Then I set field "beleg" to "1LS003"
# Noch einmal
Then I set field "beleg" to "1LS003"
# Lieferschein, Rechnung ueber Bestellung, gebucht
Then I set field "beleg" to "+1LS004B"
# anfuegbar, aber nicht speicherbar da ungebuchte RE existiert
And I delete row at position !lastRow
And I delete row at position !lastRow
# Rechnung mit Lagerbewegung, gebucht
Then I set field "beleg" to "+1RE007"
# Noch einmal
Then I set field "beleg" to "+1RE007"
# Urspruengliche Rechnung noch einmal
Then I set field "beleg" to "+1RE010"
Then I set field "mge" to "-5" in row 1
Then I set field "mge" to "-4" in row 4
Then I set field "mge" to "-2" in row 6
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I save the current editor

Given I open an editor "rliefbeleganf" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS010R1"
# Lieferschein, Rechnung ueber Lieferschein, gebucht, nicht abgelegt
Then I set field "beleg" to "1LS003"
# Noch einmal
Then I set field "beleg" to "1LS003"
# Lieferschein, Rechnung ueber Bestellung, gebucht
Then I set field "beleg" to "+1LS004B"
# Noch einmal
Then I set field "beleg" to "+1LS004B"
# Rechnung mit Lagerbewegung, gebucht
Then I set field "beleg" to "+1RE007"
# Noch einmal
Then I set field "beleg" to "+1RE007"
# Urspruengliche Rechnung noch einmal
Then I set field "beleg" to "+1RE010"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I delete all rows
And I save the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-011: Beleg anfuegen im Ruecklieferschein - einzelne Positionen
#------------------------------------------------------------------------------

Given I open an editor "rliefbeleganf" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE010"
Then I set field "nummer" to "1LS010R2"
Then I set field "vom" to "."
# Bestellung
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=1BE001" throws the exception ""
# Anzahlungsrechnung, gebucht
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=ANZAHLUNG;kopf=+1RE001A" throws the exception ""
# Schlussrechnung, ohne Lagerbewegung, gebucht
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=+1RE001" throws the exception ""
# Anzahlungsrechnung, nicht gebucht
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=ANZAHLUNG;kopf=1RE002A" throws the exception ""
# Schlussrechnung, ohne Lagerbewegung, nicht gebucht
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=1RE002" throws the exception ""
# Rechnung aus Lieferschein, gebucht
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=+1RE003" throws the exception ""
# Lieferschein, Rechnung ueber Bestellung, nicht gebucht
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=1LS004" throws the exception ""
# Rechnung aus Bestellung, ohne Lagerbewegung, nicht gebucht
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=1RE004" throws the exception ""
# Stornierter Lieferschein
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=+1LS005" throws the exception ""
# Storno-Lieferschein
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=+1LS005S" throws the exception ""
# Stornierte Rechnung
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=+1RE006" throws the exception ""
# Storno-Rechnung
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=+1RE006S" throws the exception ""
# Rechnung mit Lagerbewegung, nicht gebucht
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=1RE008" throws the exception ""
# Lieferschein, Rechnung ueber Lieferschein, gebucht, nicht abgelegt
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=1LS003"
# Noch einmal
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=1LS003"
# Lieferschein, Rechnung ueber Bestellung, gebucht
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=+1LS004B"
# anfuegbar, aber nicht speicherbar da ungebuchte RE existiert
And I delete row at position !lastRow
And I delete row at position !lastRow
# Rechnung mit Lagerbewegung, gebucht
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=+1RE007"
# Noch einmal
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=+1RE007"
# Urspruengliche Rechnung noch einmal
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=+1RE010"
Then I set field "mge" to "-5" in row 1
Then I set field "mge" to "-4" in row 4
Then I set field "mge" to "-2" in row 6
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I save the current editor

Given I open an editor "rliefbeleganf" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "1LS010R2"
# Lieferschein, Rechnung ueber Lieferschein, gebucht, nicht abgelegt
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=1LS003"
# Noch einmal
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=1LS003"
# Lieferschein, Rechnung ueber Bestellung, gebucht
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=+1LS004B"
# Noch einmal
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=+1LS004B"
# Rechnung mit Lagerbewegung, gebucht
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=+1RE007"
# Noch einmal
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=+1RE007"
# Urspruengliche Rechnung noch einmal
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=E1;kopf=+1RE010"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_ek.out"
And I delete all rows
And I save the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-012: Nur positive Mengen in Lieferschein und Rechnung mit Lagerbewegung
#------------------------------------------------------------------------------

@NurPositiveMengenLSundRE
Scenario: Menge im Lieferschein darf nicht negativ sein
Given I open an editor "bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "nummer" to "1BE009"
And I set field "lief" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "E1" in row 1
And I set field "mge" to "-1" in row 1
And I set field "vmge" to "-1" in row 1
And I save the current editor

Given I open an editor "lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "nummer" to "1LS011"
And I create a new row at the end of the table
And I set field "artikel" to "E2" in row 2
And setting field "mge" to "-2" in row 2 throws the exception ""
And I set field "vom" to "."
Then saving the current editor throws the exception ""
And I set field "mge" to "1" in row 1
And I save the current editor

Scenario: Menge in Rechnung mit Lagerbewegung darf nicht negativ sein
Given I open an editor "bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "nummer" to "1BE010"
And I set field "lief" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "E1" in row 1
And I set field "mge" to "-1" in row 1
And I set field "vmge" to "-1" in row 1
And I save the current editor

Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "nummer" to "1RE011"
And I create a new row at the end of the table
# Automatische Umschaltung auf Kaufmaennische. Gutschrift
And I set field "artikel" to "E2" in row 2
And I set field "vom" to "."
And I set field "term" to "."
And I set field "mge" to "1" in row 1
Then saving the current editor throws the exception ""
And I set field "mge" to "1" in row 2
And I save the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-013: Umlagerplatz bei Ruecklieferung, Konsignationslagerplatz in den Positionen
#------------------------------------------------------------------------------

Scenario: Lieferanteneigentum JA -> Positionen haben Konsiplatz
Given I open an editor "RLkonsi" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "nummer" to "1LS013"
And I set field "such" to "LSKONS"
And I set field "vom" to "."
And I set field "ebeleg" to "222"
And I set field "ueb" to "Ja"
And I create a new row at the end of the table
And I set field "artikel" to "AUBE" in row !lastRow
And I set field "mge" to "5" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "AUBE" in row !lastRow
And I set field "mge" to "6" in row !lastRow
And I save the current editor

Given I open an editor "rueck_konsi_ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "LSKONS"
And I set field "vom" to "."
And I set field "such" to "LSKONSRL"
Then I set field "ueb" to "Ja"
Then I set field "nummer" to "1LS012R4"
And I set field "ebeleg" to "1LS012R4"
Then field "umplatz" is empty
Then field "umlgruppe" is empty
Then field "umplatz" is not modifiable
Then field "umlgruppe" is not modifiable
And I set field "mge" to "-1" in row 1
And I set field "platz" to "KONSILP" in row 1
# 3. Zeile AUBE hat keinen Lagerplatz - Speichern geht trotzdem
And I save the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-014: Ruecklieferung mit unterschiedlichen Eigenschaften (Verwendung, Projekt, Charge, Einheit)
#------------------------------------------------------------------------------

Scenario Outline: Ruecklieferung mit unterschiedlichen Eigenschaften (Verwendung, Projekt, Charge, Einheit)

# Lagerjournaleintraege werden hinterher ins Ref ausgegeben
Given I set the fake date to "22.04.1995"
Given I open an editor "LS" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
Then I set field "lief" to "1"
Then I set field "num" to "1<row>XXLS"
Then I set field "vom" to "."
Then I set field "ebeleg" to "222"
Then I set field "ueb" to "Ja"
And I create a new row at the end of the table
Then I set field "artikel" to "<artikel>" in row !lastRow
Then I set field "mge" to "<mge>" in row !lastRow
Then I set field "he" to "Stück" in row !lastRow
Then I set field "verw" to "<verw>" in row !lastRow
Then I set field "charge" to "<charge>" in row !lastRow
Then I set field "projekt" to "<projekt>" in row !lastRow
And I save the current editor

Given I open an editor "RLSUM" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "1<row>XXLS"
And I set field "vom" to "."
And I set field "num" to "1<row>LSR"
Then I set field "ueb" to "Ja"
And I set field "ebeleg" to "3333"
And I set field "he" to "<rueckhe>" in row 1
And I set field "mge" to "-<rueckmge>" in row 1
Then I set field "charge" to "<rueckcharge>" in row !lastRow
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "zuomge" to "-<rueckmge>" in row 1
And I set field "verw" to "<rueckverw>" in row 1
And I set field "projekt" to "<rueckprojekt>" in row 1
And I save the current editor
And I switch the current editor to editor "RLSUM"
And I save the current editor

Examples:
 |row |mge |artikel |verw   |projekt   |charge     |rueckmge|rueckhe |rueckartikel |rueckverw |rueckprojekt |rueckcharge |bem                                  |
 |01  |1   |ARTBEDA |       |          |           |1       |Stück   |ARTBEDA      |          |             |            |                                     |
 |02  |2   |ARTBEDA |verw01 |projekt01 |RLcharge01 |2       |Stück   |ARTBEDA      |          |projekt01    |RLcharge01  |                                     |
 |03  |3   |ARTBEDA |verw02 |projekt02 |           |3       |Stück   |ARTBEDA      |          |projekt02    |            |                                     |
 |04  |4   |ARTBEDA |verw03 |          |           |4       |Stück   |ARTBEDA      |          |             |            |                                     |
 |05  |5   |ARTBEDA |verw05 |          |           |5       |Stück   |ARTBEDA      |          |             |            |Verw egal                            |
 |06  |6   |ARTBEDA |verw06 |          |           |6       |Stück   |ARTBEDA      |          |             |            |Verw egal leer                       |
 |07  |7   |ARTVARI |verw07 |projekt01 |RLcharge02 |7       |Stück   |ARTVARI      |verw07    |projekt01    |RLcharge02  |Verw zwingend Artikel variantenb     |
 |08  |8   |ARTERWB |verw08 |projekt01 |RLcharge03 |8       |Stück   |ARTERWB      |verw08    |projekt01    |RLcharge03  |Verw zwingend Artikel erw. bedb.     |
 |09  |6   |ARTBESZ |verw09 |projekt04 |RLcharge04 |1       |Satz    |ARTERWB      |          |projekt04    |RLcharge04  |Einheitumrechnung Stück -> Satz      |
 |10  |12  |ARTBESZ |verw10 |projekt04 |RLcharge04 |1       |Satz    |ARTERWB      |          |projekt04    |RLcharge04  |Einheitumrechnung Stück -> Satz, Teil|

Scenario Outline: Ruecklieferung mit unterschiedlichen Eigenschaften (Verwendung, Projekt, Charge, Einheit) (Fehlerfaelle)

Given I open an editor "LS" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
Then I set field "lief" to "1"
Then I set field "num" to "2<row>XXLS"
Then I set field "vom" to "."
Then I set field "ebeleg" to "222"
Then I set field "ueb" to "Ja"
And I create a new row at the end of the table
Then I set field "artikel" to "<artikel>" in row !lastRow
Then I set field "mge" to "<mge>" in row !lastRow
Then I set field "he" to "Stück" in row !lastRow
Then I set field "verw" to "<verw>" in row !lastRow
Then I set field "charge" to "<charge>" in row !lastRow
Then I set field "projekt" to "<projekt>" in row !lastRow
And I save the current editor

Given I open an editor "RLSUM" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "2<row>XXLS"
And I set field "vom" to "."
And I set field "num" to "2<row>LSR"
Then I set field "ueb" to "Ja"
And I set field "ebeleg" to "3333"
And I set field "he" to "<rueckhe>" in row 1
And I set field "mge" to "-<rueckmge>" in row 1
Then I set field "charge" to "<rueckcharge>" in row !lastRow
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I set field "verw" to "<rueckverw>" in row 1
And I set field "projekt" to "<rueckprojekt>" in row 1
And I save the current editor
And I switch the current editor to editor "RLSUM"
Then saving the current editor throws the exception ""

Examples:
 |row |mge |artikel |verw   |projekt   |charge     |rueckmge |rueckhe |rueckartikel |rueckverw |rueckprojekt |rueckcharge |bem                                  |
 |02  |2   |ARTBEDA |       |          |RLcharge01 |2        |Stück   |ARTBEDA      |          |projekt01    |RLcharge01  |                                     |
 |07  |7   |ARTVARI |verw07 |projekt01 |RLcharge02 |7        |Stück   |ARTVARI      |xxx       |projekt01    |RLcharge02  |Verw zwingend Artikel variantenb     |
 |08  |8   |ARTBESZ |verw08 |projekt04 |           |8        |Stück   |ARTERWB      |verw08    |projekt04    |RLcharge04  |Verw zwingend Artikel erw. bedb.     |
 |09  |6   |ARTBESZ |verw09 |projekt04 |RLcharge04 |1        |Satz    |ARTERWB      |verw09    |             |RLcharge04  |Einheitumrechnung Stück -> Satz      |
 |10  |12  |ARTBESZ |verw10 |projekt04 |RLcharge04 |1        |Satz    |ARTERWB      |verw10    |projekt04    |            |Einheitumrechnung Stück -> Satz, Teil|
 |11  |9   |ARTERWB |verw11 |projekt01 |RLcharge03 |9        |Stück   |ARTERWB      |xxx       |projekt01    |RLcharge03  |Verw zwingend Artikel erw. bedb.     |

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-015: Plausi fuer Lagergruppen und deren Lagerplaetze-Felder fuer die Ruecklieferung
#----------------------------------------------------------------------------------------------

Scenario: STAMMDATEN - Konsignationslagergruppe anlegen
Given I open an editor "Konsilagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "KONSILG1"
And I set field "such" to "KONSILG1"
And I set field "namebspr" to "Konsignationslagergruppe"
And I set field "zkonsilg" to "ja"
Then field "vkruecklieferung" is not modifiable
Then field "vkkundenanlieferung" is not modifiable
And I save the current editor

Scenario: STAMMDATEN - Konsignationslager anlegen
Given I open an editor "Konsilager" from table "(Warehouse):(Warehouse)" with command "STORE" for record "KONSIL1"
And I set field "such" to "KONSIL1"
And I set field "namebspr" to "Konsignationslager1"
And I set field "lgruppe" to "KONSILG1"
And I save the current editor

Scenario: STAMMDATEN - Konsignationslagerplatz anlegen
Given I open an editor "Konsignationslp" from table "(Location):(Location)" with command "STORE" for record "KONSILP1"
And I set field "such" to "KONSILP1"
And I set field "namebspr" to "Konsignationslagerplatz1"
And I set field "lager" to "KONSIL1"
And I set field "lgruppe" to "KONSILG1"
And I save the current editor

Scenario: STAMMDATEN - Externe Lagergruppe anlegen
Given I open an editor "Externelagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "STORE" for record "EXTERNLG"
And I set field "such" to "EXTERNLG"
And I set field "namebspr" to "Externe Lagergruppe"
And I set field "zkonsilg" to "nein"
Then field "vkruecklieferung" is modifiable
Then field "vkkundenanlieferung" is modifiable
And I save the current editor

Scenario Outline: STAMMDATEN - Konsignationslager und externes Lager anlegen
Given I open an editor "<lager>" from table "(Warehouse):(Warehouse)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "lgruppe" to id from editor "<lgruppe>"
And I save the current editor

Examples: Lager
 |lager           |such     |namebspr           |lgruppe            |
 |Konsignationsla |KONSILG1 |Konsignationslager |Konsilagergruppe   |
 |Externeslager   |EXTERNLG |Externes Lager     |Externelagergruppe |

Scenario Outline: STAMMDATEN - Konsignationslagerplatz und externen Lagerplatz anlegen
Given I open an editor "<lagerplatz>" from table "(Location):(Location)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "lager" to id from editor "<lager>"
And I set field "lgruppe" to id from editor "<lgruppe>"
And I save the current editor

Examples: Lagerplatz
 |lagerplatz      |such     |namebspr            |lager           |lgruppe            |
 |Konsignationslp |KONSILG1 |Konsignationslager  |Konsignationsla |Konsilagergruppe   |
 |Externer1lp 	  |extern   |Externer Lagerplatz |Externeslager   |Externelagergruppe |
 |Externer2lp 	  |extern2  |Externer Lagerplatz |Externeslager   |Externelagergruppe |

Scenario: STAMMDATEN - Neuen Lieferanten anlegen
Given I open an editor "lieferant" from table "(Vendor):(Vendor)" with command "STORE" for record "REUS"
And I set field "such" to "REUS"
And I set field "namebspr" to "Reus Werkzeugbau, Rastatt"
And I set field "ans" to "Reus Werkzeugbau GmbH"
And I set field "str" to "Riedstr. 24-28"
And I set field "plz" to "76437"
And I set field "nort" to "Rastatt"
And I set field "region" to "BADEN"
And I set field "tele" to "+49 (0) 7222/9456-0"
And I set field "email" to "info@bayram-corp.de"
And I set field "betreuer" to "."
And I set field "ustid" to "DE56454651"
And I set field "lbed" to "EXW"
And I set field "zbed" to "201"
And I save the current editor
Then field "name" has value "Reus Werkzeugbau, Rastatt"
Then field "zbed" has value "201"

Scenario Outline: STAMMDATEN - Zwei neue Artikel anlegen
Given I open an editor "<such>" from table "(Part):(Product)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "vkbez" to "<vkbez>"
And I set field "vbez" to "<vbez>"
And I set field "ebez" to "<ebez>"
And I set field "vpr" to "<vpr>"
And I set field "bsart" to "<bsart>"
And I set field "dispoa" to "<dispoa>"
And I set field "lief" to "<lief>"
And I set field "epr" to "<epr>"
And I set field "efrist" to "<efrist>"
And I save the current editor

Examples: Artikel
 |such     |namebspr  |vkbez     |vbez      |ebez      |vpr   |bsart            |dispoa         |lief |epr  |efrist|
 |artikel1 |Artikel 1 |Artikel 1 |Artikel 1 |Artikel 1 |10000 |Fremdbeschaffung |bedarfsbezogen |reus |9000 |15    |
 |artikel2 |Artikel 2 |Artikel 2 |Artikel 2 |Artikel 2 |9000  |Fremdbeschaffung |bedarfsbezogen |reus |7000 |10    |
 |artikel3 |Artikel 3 |Artikel 3 |Artikel 3 |Artikel 3 |8000  |Fremdbeschaffung |bedarfsbezogen |reus |6000 |12    |

Scenario: Bestellung mit 2 normalen Positionen anlegen
Given I open an editor "bestellung" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "REUS"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "artikel1" in row 1
And I set field "mge" to "20" in row 1
And I create a new row at the end of the table
And I set field "artikel" to id from editor "artikel2" in row 2
And I set field "mge" to "20" in row 2
And I set field "platz" to id from editor "Externer1lp" in row 2
And I save the current editor

Scenario: Lieferschein zu obiger Bestellung anlegen und 2 Positionen buchen
Given I open an editor "ek1lieferschein" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung"
And I set field "such" to "RLB1"
And I set field "ebeleg" to "Lieferung"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then setting field "mge" to "-1" in row 1 throws the exception ""
And I set field "mge" to "5" in row 1
And I set field "mge" to "5" in row 2
And I save the current editor

Scenario: Erste Position des obigen Lieferscheins rueckliefern
Given I open an editor "ek1rlieferschein" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "RLB1"
Then field "lsart" has value "Rücklieferschein"
Then field "lief" is not modifiable
Then field "lief2" is not modifiable
And I set field "ebeleg" to "Ruecklieferung1"
And I set field "vom" to "."
And I set field "such" to "RLRB1"
# Ware bleibt in unserem Besitz
Then setting field "umplatz" to "KONSILG1" throws the exception ""
Then setting field "umlgruppe" to "KONSILG1" throws the exception ""
Then the table has 2 rows
And I delete row at position 2
Then field "artikel" is not modifiable in row 1
Then field "ofmge" has value "-5" in row 1
Then field "mge" has value "0" in row 1
And I set field "mge" to "-5" in row 1
Then field "ofmge" has value "0" in row 1
Then field "abplatz" is not modifiable in row 1
And I set field "platz" to "F3" in row 1
Then field "umplatz" is empty
Then field "umlgruppe" is empty
Then field "umplatz" is not modifiable
Then field "umlgruppe" is not modifiable
And I save the current editor

Scenario: 1. Obigen Ruecklieferschein oeffnen und aendern
Given I open an editor "ek1rlieferschein" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "RLRB1"
Then field "lsart" has value "Rücklieferschein"
Then field "lief" is not modifiable
And I set field "ueb" to "ja"
Then field "umplatz" is empty
Then field "umlgruppe" is empty
Then field "umplatz" is not modifiable
Then field "umlgruppe" is not modifiable
Then field "umplatz" is empty
Then field "umlgruppe" is empty
Then the table has 1 rows
Then field "artikel" is not modifiable in row 1
Then field "mge" has value "-5" in row 1
Then field "ofmge" has value "0" in row 1
And I set field "platz" to "F1" in row 1
# Neue Zeile: Nur Zusatzpositionen inkl. AUBE erlaubt
And I create a new row at the end of the table
And I set field "artikel" to "AUBE" in row !lastRow
# In RLS nur Zusatzpositionen als neue Zeile erlaubt
Then setting field "artikel" to "ARTIKEL1" in row !lastRow throws the exception "313"
And I delete row at position !lastRow
And I save the current editor

Scenario: Zweite Position des obigen Lieferscheins rueckliefern
Given I open an editor "ek1rlieferschein" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "RLB1"
Then field "lsart" has value "Rücklieferschein"
Then field "lief" is not modifiable
And I set field "ebeleg" to "Ruecklieferung2"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then setting field "umplatz" to "KONSILG1" throws the exception ""
Then setting field "umlgruppe" to "KONSILG1" throws the exception ""
Then the table has 1 rows
Then field "artikel" is not modifiable in row 1
Then field "ofmge" has value "-5" in row 1
Then field "mge" has value "0" in row 1
And I set field "mge" to "-5" in row 1
Then field "ofmge" has value "0" in row 1
Then field "umplatz" is empty
Then field "umlgruppe" is empty
Then field "umplatz" is not modifiable
Then field "umlgruppe" is not modifiable
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-019: Ruecklieferung bei Konsignationslagerplatz im Kunden/Lieferanten und bei Umlagerrechnung
#----------------------------------------------------------------------------------------------

Scenario: Rücklieferung aus Rechnung mit Lagerbewegung mit Konsignationslagerplatz im Lieferanten
Given I open an editor "1BE020" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "nummer" to "1BE020"
And I set field "lief" to "1LIEF"
And I create a new row at the end of the table
And I set field "artikel" to "E2" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "100" in row 1
And I save the current editor

Given I open an editor "1BE020" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE020"
And I set field "nummer" to "1RE020"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "1RE020" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE020"
And I set field "nummer" to "1RE020R"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I save the current editor

Scenario: Rechnung mit Lagerbewegung aus Umlagerbestellung und Ruecklieferung

Given I open an editor "1BE021" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "nummer" to "1BE021"
And I set field "bsart" to "Umlagern"
And I set field "lief" to "1"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "E2" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "100" in row 1
And I set field "platz" to "L3F1" in row 1
And I set field "abplatz" to "F1" in row 1
And I save the current editor

Given I open an editor "1BE021" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "1BE021"
And I set field "nummer" to "1RE021"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given opening an editor from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE021" throws the exception "1525"

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-020: Zugangslieferschein auf Konsignationslagerplatz mit Teilruecklieferung
#----------------------------------------------------------------------------------------------
Scenario: Zuganslieferschein auf Konsignationslagerplatz mit teilrücklieferung

Given I open an editor "Lief" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "nummer" to "1LS014"
And I set field "such" to "LSRLUMP"
And I set field "vom" to "."
And I set field "ebeleg" to "222"
And I set field "ueb" to "Ja"
And I create a new row at the end of the table
And I set field "artikel" to "E1" in row !lastRow
And I set field "mge" to "5" in row !lastRow
And I set field "platz" to "KONSILP" in row 1
And I save the current editor

# Ruecklieferung
Given I open an editor "Lief" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "LSRLUMP"
And I set field "nummer" to "1LS015"
And I set field "such" to "LSRLUMP"
And I set field "vom" to "."
And I set field "ebeleg" to "222"
And I set field "ueb" to "Ja"
And I set field "mge" to "-1" in row 1
And I set field "platz" to "KONSILP" in row 1
And I save the current editor

Scenario: EK/VK Vorgaenge inkl. RLS mit negativen AUBE Positionen
# Auftrag
Given I open an editor "AU01" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1    |
   | vom    | .    |
   | tterm  | .    |
   | such   | AU01 |
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "AUBE" in row !lastRow
And I set field "mge" to "-10" in row !lastRow
And I save the current editor

# LS
Given I open an editor "LS01" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1    |
   | vom    | .    |
   | tterm  | .    |
   | such   | LS01 |
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "V2" in row !lastRow
# Negative Werte nicht erlaubt
And setting field "mge" to "-10" in row !lastRow throws the exception "2158"
And I set field "artikel" to "AUBE" in row !lastRow
And I set field "mge" to "-10" in row !lastRow
And I save the current editor

# RE mit Lagerbewegung
Given I open an editor "RE01" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | kunde  | 1    |
   | vom    | .    |
   | tterm  | .    |
   | such   | RE01 |
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "V2" in row !lastRow
# Negative Werte nicht erlaubt
And setting field "mge" to "-10" in row !lastRow throws the exception "2158"
And I set field "artikel" to "AUBE" in row !lastRow
And I set field "mge" to "-10" in row !lastRow
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Bestellung
Given I open an editor "BE01" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1    |
   | vom    | .    |
   | tterm  | .    |
   | such   | BE01 |
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row !lastRow
And I set field "preis" to "22" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I set field "artikel" to "V2" in row !lastRow
# Kein Problem in BE
And I set field "mge" to "-10" in row !lastRow
And I set field "artikel" to "AUBE" in row !lastRow
And I set field "mge" to "-10" in row !lastRow
And I save the current editor

# EK LS
Given I open an editor "LS01" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | ebeleg | LS01 |
   | lief   | 1    |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS01 |
And I create a new row at the end of the table
And I set field "artikel" to "E1" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "E2" in row !lastRow
# Negative Werte nicht erlaubt
And setting field "mge" to "-10" in row !lastRow throws the exception "2158"
And I set field "artikel" to "AUBE" in row !lastRow
And I set field "mge" to "-10" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "AUBE" in row !lastRow
And I set field "mge" to "5" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row !lastRow
And I set field "pwert" to "20" in row !lastRow
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row !lastRow
And I set field "pwert" to "-30" in row !lastRow
And I save the current editor

# RE zum LS
Given I open an editor "RE012" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS01"
And I set fields
   | ebeleg | RE012 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RE012 |
Then table has values
    | art  | mge | pwert    |
    | E1   |  10 |   150.00 |
    | AUBE | -10 |-10000.00 |
    | AUBE |   5 |  5000.00 |
    | TEXT |   0 |    20.00 |
    | TEXT |   0 |   -30.00 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung des LS
Given I open an editor "RLS01" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS01"
And I set fields
   | ebeleg | RLS01 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RLS01 |
Then table has values
    | art  | ofmge |
    | E1   | -10   |
    | AUBE |  -5   |
    | TEXT |   0   |
    | TEXT |   0   |
# Nur die positiven Mengen werden uebernommen (und negiert)
#Positive Menge bei Ruecklieferungen nicht erlaubt.
And setting field "mge" to "10" in row 1 throws the exception "10984"
And I set field "mge" to "-10" in row 1
And I set field "mge" to "-5" in row 2
And I create a new row at the end of the table
# Bei Ruecklieferungen duerfen nur Zusatzpositionen und Dienstleistungen neu erfasst werden.
And setting field "artikel" to "E1" in row !lastRow throws the exception "313"
And I set field "artikel" to "TEXT" in row !lastRow
And I set field "artikel" to "AUBE" in row !lastRow
# Postive Mengen sind bei AUBE auch erlaubt
And I set field "mge" to "10" in row !lastRow
And I save the current editor

# KGS zu RLS
Given I open an editor "KGS01" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS01"
# Nur negative Positionen, Textpositionen und AUBE werden uebernommen
# TODO: Noch zu klären: Verhalten bei negativen Textpositionen
# herkunft in 1. Textpositionen fehlt
Then table has values
    | art  | mge | preis   | pwert    | herkunft^kopf^such |
    | E1   | -10 |   15.00 |  -150.00 | RE012              |
    | AUBE |  -5 | 1000.00 | -5000.00 | RE012              |
    | TEXT |   0 |    0.00 |     0.00 |                    |
    | TEXT |   0 |    0.00 |     0.00 | RE012              |
    | AUBE |  10 | 1000.00 | 10000.00 |                    |
#Positive Menge bei Gutschriftpositionen nicht erlaubt.
And setting field "mge" to "10" in row 1 throws the exception "2024"
And I create a new row at the end of the table
# Keine bestandsgef. Artikel
And setting field "artikel" to "E1" in row !lastRow throws the exception "1678"
And I set field "artikel" to "AUBE" in row !lastRow
# Positive Werte bei AUBE erlaubt
And I set field "mge" to "1" in row !lastRow
And I set fields
   | ebeleg | KGS01 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS01 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-021: Anfuegen von LS und RE mit Lagerbewegung an einen leeren Lieferschein
#----------------------------------------------------------------------------------------------

Scenario: Beleg anfuegen LS an LS (ergibt RLS)

# LS anlegen
Given I open an editor "LS02" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | ebeleg | LS02 |
   | lief   | 1    |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS02 |
And I create a new row at the end of the table
And I set field "artikel" to "E1" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I save the current editor

# LS anlegen -> LS anfuegen -> RLS
Given I open an editor "LS03" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | ebeleg | LS03 |
   | lief   | 1    |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS03 |
# LS an LS anfuegen -> RLS
And I set field "beleg" to "nummer" from editor "LS02"
Then field "lsart" has value "Rücklieferschein"
And I press button "offueb" in row 1
# Werte des Quell-LS werden negiert uebernommen
Then table has values
    | art  | mge  | pwert    | herkunft^kopf^such |
    | E1   |  -10 |  -150.00 |                    |
And I save the current editor

Given I open an editor "LS03V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS03"
Then field "lsart" has value "Rücklieferschein"
And I close the current editor

Scenario: Beleg anfuegen LS an LS (ergibt RLS) Kein Mischen erlauben

# Bestellung neu
Given I create a PurchaseOrder "BE04" for Vendor "1" with Product "E1" and quantity "5"

# LS neu
Given I open an editor "LS04" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | ebeleg | LS04 |
   | lief   | 1    |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS04 |
And I append rows
  |artikel  | mge    |
  |E2       | 11     |
And I save the current editor

# LS neu, BE anfuegen, LS anfuegen
Given I open an editor "LS05" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | ebeleg | LS05 |
   | lief   | 1    |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS05 |
And I set field "beleg" to "nummer" from editor "BE04"
Then field "lsart" has value "Lieferschein"
Then the table has 1 rows
# Kein Anfuegen LS an normalen LS
Then setting field "beleg" in row 0 to "id" from editor "LS04" in row 0 throws the exception "4615"
Then the table has 1 rows
# Zeile loeschen
And I delete row at position 1
Then the table has 0 rows
# LS anfuegen an leeren LS erlaubt
And I set field "beleg" to "nummer" from editor "LS04"
Then field "lsart" has value "Rücklieferschein"
# BE an RLS anfuegen-> Dieser Beleg darf nicht angefuegt werden
Then setting field "beleg" in row 0 to "id" from editor "BE04" in row 0 throws the exception "4615"
Then the table has 1 rows
And I close the current editor

Scenario: Beleg anfuegen RE mit Lagerbewegung an LS (ergibt RLS)

# RE mit Lagerbewegung anlegen
Given I open an editor "RE01L" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | ebeleg | RE01L |
   | lief   | 1     |
   | vom    | .     |
   | tterm  | .     |
   | fakt   | ja    |
   | ueb    | ja    |
   | such   | RE01L |
And I create a new row at the end of the table
And I set field "artikel" to "E2" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# LS anlegen -> RE mit Lagerbewegung anfuegen -> RLS
Given I open an editor "LS06" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | ebeleg | LS06 |
   | lief   | 1    |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS06 |
# RE mit Lagerbewegung an LS anfuegen -> RLS
And I set field "beleg" to "id" from editor "RE01L"
Then field "lsart" has value "Rücklieferschein"
And I press button "offueb" in row 1
# Werte des Quell-LS werden negiert uebernommen
Then table has values
    | artikel | mge  |
    | E2      |  -10 |
And I save the current editor

Given I open an editor "LS06V" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record from editor "LS06"
Then field "lsart" has value "Rücklieferschein"
And I close the current editor

Scenario: Beleg anfuegen RE mit Lagerbewegung an LS (ergibt RLS). Kein Mischen erlauben

# Bestellung neu
Given I create a PurchaseOrder "BE05" for Vendor "1" with Product "E2" and quantity "5"

# RE mit Lagerbewegung neu
Given I open an editor "RE02L" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
   | ebeleg | RE02L |
   | lief   | 1     |
   | vom    | .     |
   | tterm  | .     |
   | fakt   | ja    |
   | ueb    | ja    |
   | such   | RE02L |
And I append rows
   | artikel  | mge    |
   | E2       | 11     |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# LS neu, BE anfuegen, RE mit Lagerbewegung anfuegen
Given I open an editor "LS05" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | ebeleg | LS07 |
   | lief   | 1    |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS07 |
And I set field "beleg" to "nummer" from editor "BE05"
Then field "lsart" has value "Lieferschein"
Then the table has 1 rows
# Kein Anfuegen LS an normalen LS
Then setting field "beleg" in row 0 to "id" from editor "RE02L" in row 0 throws the exception "4615"
Then the table has 1 rows
# Zeile loeschen
And I delete row at position 1
Then the table has 0 rows
# RE mit Lagerbewegung anfuegen an leeren LS erlaubt
And I set field "beleg" to "id" from editor "RE02L"
Then field "lsart" has value "Rücklieferschein"
# BE an RLS anfuegen-> Dieser Beleg darf nicht angefuegt werden
Then setting field "beleg" in row 0 to "id" from editor "BE05" in row 0 throws the exception "4615"
Then the table has 1 rows
And I close the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-023: Komplett zurueckliefern ohne Rechnung und Vorgangskette abschliessen
#----------------------------------------------------------------------------------------------

Scenario: Komplett zurueckliefern ohne Rechnung und Vorgangskette abschliessen
# Abschluss der Vorgangskette durch 0 * Rechnungen
#
# BE10 -----> LS10 ---> RLS10 --> KGS10
# (10)        (10)      (-10)     (0*)
#               \
#                RE10
#                (0*)
#

# Bestellung anlegen
Given I create a PurchaseOrder "BE10" for Vendor "1" with Product "V1" and quantity "10" and price "4"

#Bestellung voll liefern LS
Given I deliver the PurchaseOrder "BE10" with PackingSlip "LS10"

# RLS ueber volle Menge
Given I open an editor "RLS10" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS10"
And I set fields
	| such   | RLS10 |
	| ebeleg | RLS10 |
	| ueb    | ja    |
	| vom    | .     |
And I set field "mge" to "-10" in row 1
And I save the current editor

# KGS mit 0* zum Abschliessen
Given I open an editor "KGS10" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS10"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "mge" has value "0" in row 1
Then field "status" has value "*" in row 1
And I set fields
   | ebeleg | KGS101|
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS10 |
And I save the current editor

# 0 Rechnung zum LS
Given I open an editor "RE10" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS10"
And I set fields
  | such   | RE10 |
  | ebeleg | RE10 |
  | ueb    | ja   |
  | tterm  | .    |
  | vom    | .    |
  | budat  | .    |
# Restmenge wird vorgeschlagen -> 10
Then field "mge" has value "10" in row 1
Then setting field "mge" to "11" in row 1 throws the exception "2810"
# Erwarteter Fehler Negative Werte sind nicht erlaubt
Then setting field "mge" to "-1" in row 1 throws the exception "2158"
And I set field "preis" to "0" in row 1
Then field "status" has value "*" in row 1
And I save the current editor

# Alle Objekte muessen abgelegt sein
Then "(Purchasing):(Invoice)" with the editor id "KGS10" is filed
Then "(Purchasing):(Invoice)" with the editor id "RE10" is filed
Then "(Purchasing):(PackingSlip)" with the editor id "RLS10" is filed
Then "(Purchasing):(PackingSlip)" with the editor id "LS10" is filed
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE10" is filed


#----------------------------------------------------------------------------------------------
# TSQ-RUECK-024: Komplett zurueckliefern mit RE und KGS und Vorgangskette abschliessen
#----------------------------------------------------------------------------------------------

Scenario: Komplett zurueckliefern mit RE und KGS und Vorgangskette abschliessen
#
# BE11 -----> LS11 ---> RLS11 --> KGS11
# (10)        (10)      (-10)     (10)
#               \
#                RE11
#                (10)
#

# Bestellung anlegen
Given I create a PurchaseOrder "BE11" for Vendor "1" with Product "V1" and quantity "10" and price "5"

#Bestellung voll liefern LS
Given I deliver the PurchaseOrder "BE11" with PackingSlip "LS11"

# RE zum LS
Given I open an editor "RE11" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS11"
And I set fields
  | such   | RE11 |
  | ebeleg | RE11 |
  | ueb    | ja   |
  | tterm  | .    |
  | vom    | .    |
  | budat  | .    |
# Restmenge wird vorgeschlagen -> 100
Then field "mge" has value "10" in row 1
Then field "status" has value "*" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# RLS ueber volle Menge
Given I open an editor "RLS11" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS11"
And I set fields
	| such   | RLS11 |
	| ebeleg | RLS11 |
	| ueb    | ja    |
	| vom    | .     |
And I set field "mge" to "-10" in row 1
And I save the current editor

# KGS mit 10 zum Abschliessen
Given I open an editor "KGS11" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "RLS11"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "mge" has value "-10" in row 1
Then field "status" has value "*" in row 1
And I set fields
   | ebeleg | KGS111|
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS11 |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Alle Objekte muessen abgelegt sein
Then "(Purchasing):(Invoice)" with the editor id "KGS11" is filed
Then "(Purchasing):(Invoice)" with the editor id "RE11" is filed
Then "(Purchasing):(PackingSlip)" with the editor id "RLS11" is filed
Then "(Purchasing):(PackingSlip)" with the editor id "LS11" is filed
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE11" is filed

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-025: RE ohne Lagerbewegung aus Bestellung darf nicht ueberberechnet werden
#----------------------------------------------------------------------------------------------

Scenario: RE ohne Lagerbewegung aus Bestellung darf nicht ueberberechnet werden
# Bei Rechnung ohne Lagerbewegung aus Bestellung/Auftrag darf die Rechnungsmenge
# nicht groesser sein als die Bestellmenge, bzw. die gelieferte Menge bei Ueberlieferungen,
# Ruecklieferungen, Storno-Vorgaenge und kaufmaennische Gutschriften sind zu beruecksichtigen
#
# BE13 -----> RE13 (abbruch)--> RE13 (abbruch)--> RLS13
# (10)     \  (10!)             (12!)             (10!)
#           \
#            -------LS13---------------> LSS13
#                   (12)                 (Storno)
#
# Bestellung anlegen
Given I create a PurchaseOrder "BE13" for Vendor "1" with Product "V1" and quantity "10" and price "6"

# Rechnung zur Bestellung (Versuch 1)
Given I open an editor "RE13" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE13"
# Im EK Default: Lagerbewegung nein
Then field "fakt" has value "nein"
# Mit Lagerbewegung
And I set field "fakt" to "ja"
Then field "mge" has value "0" in row 1
And I set field "mge" to "10" in row 1
And I set field "mge" to "11" in row 1
# Negative Werte nicht erlaubt
Then setting field "mge" to "-1" in row 1 throws the exception "2158"

# Ohne Lagerbewegung
And I set field "fakt" to "nein"
# Erst mal OK - Muss beim post OK geprueft werden
Then field "mge" has value "11" in row 1
# Ueberberechnung soll scheitern
Then setting field "mge" to "11" in row 1 throws the exception "2810"
# Negative Werte nicht erlaubt
Then setting field "mge" to "-1" in row 1 throws the exception "2158"
And I close the current editor

#LS zu Bestellung - ueberliefern
Given I open an editor "LS13" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE13"
And I set fields
   | ebeleg | LS13  |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | nummer | 1LS13 |
   | such   | LS13  |
   | fakt   | nein  |
And I set field "mge" to "12" in row 1
And I save the current editor

# Rechnung zur Bestellung (Versuch 2)
Given I open an editor "RE13" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE13"
# Mit Lagerbewegung
Then field "fakt" has value "nein"
Then field "mge" has value "12" in row 1
And I set field "mge" to "10" in row 1
# Ueberberechnung soll scheitern - Rechnungsmenge zu hoch
Then setting field "mge" to "13" in row 1 throws the exception "2810"
# Negative Werte nicht erlaubt
Then setting field "mge" to "-1" in row 1 throws the exception "2158"
And I close the current editor

Given I open an editor "LSS13" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "LS13"
And I set field "bem" to "Storno Fehllieferung"
And I save the current editor

# Rechnung zur Bestellung (Versuch 3 Speichern)
Given I open an editor "RE13" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE13"
And I set fields
   | ebeleg | RE13  |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | nummer | 1RE13 |
   | such   | RE13  |
# Mit Lagerbewegung
Then field "fakt" has value "nein"
Then field "mge" has value "0" in row 1
# Ueberberechnung soll scheitern
Then setting field "mge" to "12" in row 1 throws the exception "2810"
#And I set field "mge" to "12" in row 1
# Negative Werte nicht erlaubt
Then setting field "mge" to "-1" in row 1 throws the exception "2158"
And I set field "mge" to "10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Vollstaendig liefern (10)
Given I deliver the PurchaseOrder "BE13" with PackingSlip "LS13B"

# Alle Objekte muessen abgelegt sein
Then "(Purchasing):(Invoice)" with the editor id "RE13" is filed
Then "(Purchasing):(PackingSlip)" with the editor id "LS13" is filed
Then "(Purchasing):(PackingSlip)" with the editor id "LSS13" is filed
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE13" is filed


#----------------------------------------------------------------------------------------------
# TSQ-RUECK-026: Pruefung beim Speichern: RE ohne Lagerbewegung aus Bestellung darf nicht ueberberechnet werden
#----------------------------------------------------------------------------------------------

Scenario: Pruefung beim Speichern: RE ohne Lagerbewegung aus Bestellung darf nicht ueberberechnet werden
# Bestellung anlegen
Given I create a PurchaseOrder "BE11" for Vendor "1" with Product "V1" and quantity "10"

# Rechnung zur Bestellung
Given I open an editor "RE11" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE11"
And I set fields
   | ebeleg | RE11 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE11 |
# Mit Lagerbewegung
And I set field "fakt" to "ja"
# Ueberliefern/Ueberberechnen
And I set field "mge" to "11" in row 1

# Ohne Lagerbewegung
And I set field "fakt" to "nein"
# Rechnungsmenge noch zu hoch beim Speichern pruefen
Then field "mge" has value "11" in row 1
Then saving the current editor throws the exception "2810"


#----------------------------------------------------------------------------------------------
# TSQ-RUECK-027: RLS beruecksichtigen: RE ohne Lagerbewegung aus Bestellung darf nicht ueberberechnet werden
#----------------------------------------------------------------------------------------------

Scenario: RLS beruecksichtigen: RE ohne Lagerbewegung aus Bestellung darf nicht ueberberechnet werden
#
# BE12 ---> ----------------> RE12 (abbr)---> RLS12 (abbr) -----> RE12
# (10)   \                    (16!)           (13!)               (13!)
#         \
#          -----LS12----> RLS12 (ungeb)
#               (16) \ \  (-2)
#                     \ \------------>RLS12B (geb)
#                      \              (-3)
#                       \----------------------> RLS12C --> RLSS12C (Storno)
#                                                (-4)

#
# Bestellung anlegen
Given I create a PurchaseOrder "BE12" for Vendor "1" with Product "V1" and quantity "10"

#LS zu Bestellung - ueberliefern
Given I open an editor "LS12" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE12"
And I set fields
   | ebeleg | LS12  |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | nummer | 1LS12 |
   | such   | LS12  |
   | fakt   | nein  |
And I set field "mge" to "16" in row 1
And I save the current editor

# Ruecklieferung ungebucht
Given I open an editor "RLS12" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS12"
And I set fields
   | ebeleg | RLS12  |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | nein   |
   | nummer | 1RLS12 |
   | such   | RLS12  |
And I set field "mge" to "-2" in row 1
And I save the current editor

# Rechnung zur Bestellung (Versuch 1)
Given I open an editor "RE12" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE12"
# Im EK Default: Lagerbewegung nein
Then field "fakt" has value "nein"
Then field "mge" has value "16" in row 1
And I close the current editor

# Ruecklieferung gebucht
Given I open an editor "RLS12B" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS12"
And I set fields
   | ebeleg | RLS12B  |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
   | nummer | 1RLS12B |
   | such   | RLS12B  |
And I set field "mge" to "-3" in row 1
And I save the current editor

# Rechnung zur Bestellung (Versuch 2)
Given I open an editor "RE12" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE12"
# Im EK Default: Lagerbewegung nein
Then field "fakt" has value "nein"
Then field "mge" has value "16" in row 1
Then setting field "mge" to "17" in row 1 throws the exception "2810"
And I close the current editor

# 2. Ruecklieferung gebucht
Given I open an editor "RLS12C" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS12"
And I set fields
   | ebeleg | RLS12C  |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
   | nummer | 1RLS12C |
   | such   | RLS12C  |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Storno RLS2C
Given I open an editor "RLSS12C" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "RLS12C"
And I save the current editor

# Rechnung zur Bestellung (Versuch 3)
Given I open an editor "RE12" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE12"
And I set fields
   | ebeleg | RE12  |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | nummer | 1RE12 |
   | such   | RE12  |
Then field "fakt" has value "nein"
Then field "mge" has value "16" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-029: RE aus Bestellung mit Ueberlieferung - Prozesskette abschliessen
#----------------------------------------------------------------------------------------------

Scenario: RE aus Bestellung mit Ueberlieferung abschliessen

#
# BE15 ---------------> RE15
# (10) \                (10)
#       \
#         ----------------------> RE15B -------> RE15BS
#         \                       (0*)           (Storno)
#          \                      BE abglegt!    BE lebendig!
#           \
#            \
#              --- LS15-------------------------------> RLS15 --> KGS15
#                  (15)                                 (-8)  \   (-2)
#                                                              \
#                                                                ------> KGS15B -----------> KGS15BS
#                                                                \       (0*)                Storno
#                                                                 \      RLS15 in Ablage!    RLS15 geht wieder auf
#                                                                  \
#                                                                    ------------------------------> KGS15C
#                                                                                                    (0*)
#                                                                                                    RLS15 in Ablage!
#

# Bestellung anlegen
Given I create a PurchaseOrder "BE15" for Vendor "1" with Product "E1" and quantity "10"

# Lieferschein mit Menge 15 erzeugen
Given I open an editor "LS15" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE15"
And I set fields
   | ebeleg | LS15  |
   | vom    | .     |
   | tterm  | .     |
   | fakt   | nein  |
   | ueb    | ja    |
   | such   | LS15  |
And I set field "mge" to "15" in row 1
And I save the current editor

# Rechnung aus Bestellung erzeugen mit Menge 10
Given I open an editor "RE15" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE15"
And I set fields
   | ebeleg | RE15  |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RE15  |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE15" is not filed

# 0*-Rechnung aus Bestellung erzeugen
Given I open an editor "RE15B" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE15"
And I set fields
   | ebeleg | RE15B |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RE15B |
And I set field "mge" to "0" in row 1
And I respond with answer "Ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

# Pruefe, ob Vorgaenge abgelegt sind
Then "(Purchasing):(PackingSlip)" with the editor id "LS15" is filed
Then "(Purchasing):(Invoice)" with the editor id "RE15" is filed
Then "(Purchasing):(Invoice)" with the editor id "RE15B" is filed
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE15" is filed

# 0* Rechnung stornieren -> Bestellung muss wieder aufgehen
Given I open an editor "RE15BS" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE15B"
And I set field "bem" to "Storno 0-Rechnung"
And I save the current editor
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE15" is not filed

Given I open an editor "BE15V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE15"
# Pruefe, ob die remge wieder korrekt restauriert wurde
Then field "remge" has value "5" in row 1
And I close the current editor

# Ruecklieferschein mit Menge -8 erzeugen und noch nicht buchen
Given I open an editor "RLS15" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS15"
And I set fields
   | ebeleg | RLS15 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | nein  |
   | such   | RLS15 |
And I set field "mge" to "-8" in row 1
And I save the current editor

# Wertgutschrift nicht moeglich
Then opening an editor from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE15" throws the exception "6823"

# Ruecklieferschein buchen
Given I open an editor "RLS15B" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS15"
And I set fields
   | ueb  | ja |
And I save the current editor
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE15" is not filed

# Wertgutschrift moeglich, aber nicht speichern, sonst keine kaufm. Gutschrift mehr moeglich
Given I open an editor "WG15" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE15"
And I set fields
	| ebeleg | WG15       |
	| nummer | 1WG15      |
	| such   | WG15       |
	| ueb    | nein       |
	| tterm  | .          |
	| vom    | .          |
	| budat  | .          |
Then field "wertgutschrift" has value "ja"
Then field "twertgutschrift" has value "ja" in row 1
And I press button "offueb" in row 1
Then field "mge" has value "-7" in row 1
And I close the current editor

# KGS mit Menge -2 erzeugen und buchen
Given I open an editor "KGS15" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS15"
And I set fields
   | ebeleg | KGS15 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS15 |
# Nicht voll gutschreiben
And I set field "mge" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# KGS mit Menge 0 erzeugen und buchen
Given I open an editor "KGS15B" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS15"
And I set fields
   | ebeleg | KGS15B |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | such   | KGS15B |
And I set field "mge" to "0" in row 1
# Wollen Sie wirklich stornieren?
And I respond with answer "Ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

Then "(Purchasing):(PackingSlip)" with the editor id "RLS15" is filed

# Storno 0* KGS
Given I open an editor "KGS15BS" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KGS15B"
And I set field "bem" to "Storno 0-KGS"
And I save the current editor
Then "(Purchasing):(PackingSlip)" with the editor id "RLS15" is not filed

# KGS 0* erneut erzeugen und buchen
Given I open an editor "KGS15C" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS15"
And I set fields
   | ebeleg | KGS15C |
   | vom    | .      |
   | tterm  | .      |
   | ueb    | ja     |
   | such   | KGS15C |
And I set field "mge" to "0" in row 1
# Wollen Sie wirklich stornieren?
And I respond with answer "Ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

# Pruefe, ob alle Vorgaenge abgelegt sind
Then "(Purchasing):(Invoice)" with the editor id "KGS15C" is filed
Then "(Purchasing):(Invoice)" with the editor id "KGS15BS" is filed
Then "(Purchasing):(Invoice)" with the editor id "KGS15B" is filed
Then "(Purchasing):(Invoice)" with the editor id "KGS15" is filed
Then "(Purchasing):(PackingSlip)" with the editor id "RLS15" is filed
Then "(Purchasing):(PackingSlip)" with the editor id "LS15" is filed
Then "(Purchasing):(Invoice)" with the editor id "RE15" is filed
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE15" is not filed

#----------------------------------------------------------------------------------------------
# Im Ruecklieferungsfall Teilrechnungen sperren
#----------------------------------------------------------------------------------------------
Scenario: Im Ruecklieferungsfall Teilrechnungen sperren
#
# BE16 -----> RE16 ----------> RE16 (bearbeiten)
# (20)      \  (4)            (RE162 kann nicht bearbeitet werden)
#            -------> RE162
#                    (6)
#
# Bestellung anlegen
Given I create a PurchaseOrder "BE16" for Vendor "1" with Product "E1" and quantity "20" and price "6"
# Teilrechnung zur Bestellung
Given I open an editor "RE16" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE16"
And I set fields
   | ebeleg | RE16  |
   | vom    | .     |
   | tterm  | .     |
   | such   | RE16  |
And I set field "mge" to "4" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# 2. Teilrechnung zur Bestellung
Given I open an editor "RE162" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE16"
And I set fields
   | ebeleg | RE162  |
   | vom    | .      |
   | tterm  | .      |
   | such   | RE162  |
And I set field "mge" to "6" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# 1. Teilrechnung im aendern oeffnen
Given I open an editor "RE16U" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE16"

# Zweiten Benutzer simulieren
Given I'm logged in with password "sy"
# 2. Teilrechnung laesst sich nicht oeffnen
# Es ist bereits eine exklusive Editoraktion offen. - Laeuft auf Sperre
Given opening an editor from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE162" throws the exception "3244"
And I close the current editor

Scenario: RE aus Auftrag Ruecklieferung, trotz noch ungebuchter Rechnung
#
# BE17 -----> RE17 -------------------------------> RE17 buchen
# (10 zu 6)\  (5) ungebucht
#           \
#            \-------> LS17 ----> RLS17
#                      (10)       (-6)
#                                 Speichern moeglich
#                                 trotz ungeb. RE
#
# Bestellung anlegen
#Given I create a PurchaseOrder "BE17" for Vendor "1" with Product "E1" and quantity "10" and price "6"

Given I open an editor "BE17" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | ebeleg | BE17 |
   | lief   | 1    |
   | vom    | .    |
   | tterm  | .    |
   | such   | BE17 |
And I append rows
  | artikel  | mge         | preis       | pwert |
  | NEPO     | !dontChange | !dontChange | 1000  |
  | E1       | 10          | 6           | 60    |
  | TEXT     | !dontChange | !dontChange | 70    |
  | TEXT     | !dontChange | !dontChange | 80    |
And I save the current editor

# Rechnung zur Bestellung / nicht gebucht
Given I open an editor "RE17" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE17"
And I set fields
   | ebeleg | RE17 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | nein |
   | such   | RE17 |
And I set field "mge" to "5" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "LS17" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE17"
And I set fields
   | ebeleg | LS17  |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | nummer | 1LS17 |
   | such   | LS17  |
And I set field "mge" to "10" in row 2
And I save the current editor

# RLS trotz ungebuchter RE
Given I open an editor "RLS17" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS17"
And I set fields
	| such   | RLS17 |
	| ebeleg | RLS17 |
	| ueb    | ja    |
	| vom    | .     |
And I set field "mge" to "-6" in row 2
And I close the current editor

# RE17 verbuchen
Given I open an editor "RE17B" from table "(Purchasing):(Invoice)" with command "UPDATE" for record from editor "RE17"
And I set field "ueb" to "ja"
And I save the current editor

Scenario: Kaufm. GS zu RLS mit geteilten GS Positionen untersch. HE/LE
# Test Preisuebernahme in GS bei mehreren RE
#
#     RE18     RE18B
#     (7 zu 4) (3 zu 5)
#     /       /
# BE18 --------> LS18 ---> RLS18-----> KGS18 (Preise aus RE18, RE18B))
# (10 zu 3)      (5 m²)    (10 Stück)  (7 zu 4)!
#                HE!                   (3 zu 5)!
#

Given I open an editor "E1LEHE" from table "(Part):(Product)" with command "COPY" for record "E1"
And I set field "such" to "E1LEHE"
# Ein Stueck = 5 EUR
# Ein Stueck = halber Quadratmeter m^2
# 1 m² -> 10 EUR
And I set fields
   | vpr   | 5     |
   | vpe   | Stück |
   | fvhe  | 1     |
   | vhe   | Stück |
   | fvhle | 0,5   |
   | le    | m²    |
   | fvpe  | 1     |
   | fvple | 0,5   |
   | fehe  | 1     |
   | ehe   | Stück |
   | fehle | 0,5   |
   | fepe  | 1     |
   | epe   | Stück |
   | feple | 0,5   |
And I save the current editor

# Bestellung anlegen
Given I create a PurchaseOrder "BE18" for Vendor "1" with Product "E1LEHE" and quantity "10" and price "3"

# Berechne (Teil) die Bestellung
Given I open an editor "RE18" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE18"
And I set fields
   | ebeleg | RE18 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | RE18 |
And I set field "mge" to "7" in row 1
And I set field "preis" to "4" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Berechne (Teil) die Bestellung
Given I open an editor "RE12" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record "BE18"
And I set fields
   | ebeleg | RE18B |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RE18B |
And I set field "mge" to "3" in row 1
And I set field "preis" to "5" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Liefere die Bestellung (Teil)
Given I open an editor "LS18" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "BE18"
And I set fields
   | ebeleg | LS18 |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS18 |
And I set field "mge" to "5" in row 1
And I set field "he" to "m²" in row 1
And I set field "preis" to "5" in row 1
And I save the current editor

# Ruecklieferung des LS
# Given I return the PurchasingPackingSlip "LS18" with ReturnPackingSlip "RLS18"

Given I open an editor "RLS18" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS18"
And I set fields
	| such   | RLS18 |
	| ebeleg | RLS18 |
	| ueb    | ja    |
	| vom    | .     |
And I set field "he" to "Stück" in row 1
And I set field "mge" to "-10" in row 1
And I save the current editor


# RLS gutschreiben
Given I open an editor "KGS18" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
Then setting field "vorganga" to "Kaufmännische Gutschrift" throws the exception "131"
# GS erstellen ueber Beleg anfuegen
And I set field "beleg" to id from editor "RLS18"
# Then the table has 3 rows
Then table has values
    | art     | mge | preis | remge | herkunft^kopf^such | pftext |
    | E1LEHE  | -7  | 4.00  | -7    | RE18               |        |
    | E1LEHE  | -3  | 5.00  | -3    | RE18B              |        |

# Der Preis der GS zur RL kommt aus den Rechnungen und der Bestellung!
And I set fields
   | ebeleg | KGS18 |
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | KGS18 |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Nach dem Speichern noch einmal oeffnen
Given I open an editor "KGS18V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "KGS18"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then table has values
    | art     | mge | preis | remge | herkunft^kopf^such | herkunft^verrechmge |
    | E1LEHE  | -7  | 4.00  | 0     | RE18               | 7                   |
    | E1LEHE  | -3  | 5.00  | 0     | RE18B              | 3                   |
And I close the current editor

Scenario: Keine Pruefung auf exteren Nummer bei EK-RLS
Given I open an editor "LS19" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | lief   | 1    |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS19 |
And I append rows
   | artikel  | mge    |
   | E2       | 11     |
# Bitte Identnummer oder externe Belegnummer eintragen.
Then saving the current editor throws the exception "7054"
And I set field "ebeleg" to "LS19"
And I save the current editor

Given I open an editor "RLS19" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS19"
And I set fields
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RLS19 |
And I set field "mge" to "-11" in row 1
# Muss jetzt gehen ohne Nach der Nummer zu fragen
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-030: Rechnungsart Barzahlung bei Gutschriften
#----------------------------------------------------------------------------------------------

Scenario: Rechnungsart Barzahlung bei Gutschriften

Given I open an editor "1RE022G" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "1LS022R"
And I set field "nummer" to "1RE022G"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set field "vorganga" to "Barzahlung"
And I create a new row at the end of the table
And I set field "artikel" to "TEXT" in row !lastRow
And I set field "pwert" to "200000" in row !lastRow
Then field "vorganga" has value "Barzahlung"
And I set field "vorganga" to "Rechnung"
And I delete row at position !lastRow
Then field "vorganga" has value "Kaufmännische Gutschrift"
And I set field "vorganga" to "Barzahlung"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Then field "vorganga" from editor "1RE022G" in row 0 has value "Barzahlung"

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-031: Stornierung von Ueberbelieferungen
#----------------------------------------------------------------------------------------------

Scenario: Stornierung von Ueberbelieferungen

# Bestellung anlegen
Given I create a PurchaseOrder "BE19" for Vendor "1" with Product "E2" and quantity "15" and price "15"

# Lieferscheine erzeugen mit Ueberbelieferung
Given I open an editor "LS19-1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE19"
And I set fields
   | ueb    | ja     |
   | nummer | 1LS19  |
   | such   | LS19-1 |
   | vom    | .      |
And I set field "mge" to "15" in row 1
And I save the current editor

Given I open an editor "LS19-2" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE19"
And I set fields
   | ueb    | ja     |
   | nummer | 2LS19  |
   | such   | LS19-2 |
   | vom    | .      |
And I set field "mge" to "15" in row 1
And I save the current editor

Given I open an editor "LS19-3" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE19"
And I set fields
   | ueb    | ja     |
   | nummer | 3LS19  |
   | such   | LS19-3 |
   | vom    | .      |
And I set field "mge" to "15" in row 1
And I save the current editor

# Lieferscheine stornieren
Given I open an editor "LS19-2S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "LS19-2"
And I save the current editor

Given I open an editor "LS19-1S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "LS19-1"
And I save the current editor

Given I open an editor "LS19-3S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "LS19-3"
And I save the current editor

#-------------------------------------------------------------------------------------
# TSQ-RUECK-034: Storno von Lieferungen aus abgelegten Bestellungen mit Beistellung
#-------------------------------------------------------------------------------------

Scenario: Storno von Lieferungen aus abgelegten Beistellungen mit Beistellung

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

# Bestellung mit Beistellteil anlegen
Given I open an editor "1BE110" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE110 |
   | lief   | 1      |
And I append rows
   | artex  | mge |
   | ABEIST | 10  |
And I press button "absteig" to open a subeditor for "FL" in row 1
And I append rows
   | elex  | elanzahl |
   | BEIST | 2        |
And I save the current editor
And I switch the current editor to editor "1BE110"
And I save the current editor

# Lieferung ueber komplette Menge
Given I open an editor "1LS110" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE110"
And I set fields
   | nummer | 1LS110 |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Weitere Lieferung aus der abgelegten Bestellung
Given I open an editor "2LS110" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE110"
And I set fields
   | nummer | 2LS110 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "3" in row 1
And I save the current editor

# Ueberbelieferung stornieren
Given I open an editor "2LS110" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "2LS110"
And I set field "nummer" to "2LS110S"
And I save the current editor

# Beistellung im Artikel eintragen
Given I open an editor "ABEIST" from table "(Part):(Product)" with command "UPDATE" for record from editor "ABEIST"
And I append rows
   | elex  | elanzahl | bua                    |
   | BEIST | 2        | Lieferantenbeistellung |
And I save the current editor

# Bestellung mit Beistellteil anlegen
Given I open an editor "1BE115" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE115 |
   | lief   | 1      |
And I append rows
   | artex  | mge |
   | ABEIST | 10  |
And I save the current editor

# Lieferung ueber komplette Menge
Given I open an editor "1LS115" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE115"
And I set fields
   | nummer | 1LS115 |
   | vom    | .      |
   | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

# Weitere Lieferung aus der abgelegten Bestellung
Given I open an editor "2LS115" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "1BE115"
And I set fields
   | nummer | 2LS115 |
   | vom    | .      |
   | ueb    | ja     |
And I set field "mge" to "3" in row 1
And I save the current editor

# Ueberbelieferung stornieren
Given I open an editor "2LS115" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "2LS115"
And I set field "nummer" to "2LS115S"
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-035: Ruecklieferung zu Lieferschein mit zusätzlicher Position bei Rechnung aus Bestellung
#----------------------------------------------------------------------------------------------

Scenario: Ruecklieferung zu Lieferschein mit zusaetzlicher Position bei Rechnung aus Bestellung

# Bestellung anlegen
Given I create a PurchaseOrder "BE035" for Vendor "1" with Product "V3" and quantity "10"

# Lieferschein erzeugen (Rechnung aus Bestellung)
# und zusaetzliche Position fuer Packmittel (nicht rechnungsrelevant) ergaenzen
Given I open an editor "LS035" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE035"
And I set fields
    | nummer | 1LS035 |
    | such   | LS035  |
    | vom    | .      |
    | fakt   | nein   |
    | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I append rows
   | artikel  | mge   |
   | PALETTE  | 2     |
And I save the current editor

# Ruecklieferschein erzeugen und nicht buchen
Given I open an editor "RLS035" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS035"
And I set fields
   | such   | RLS035 |
And I set field "mge" to "-8" in row 1
And I set field "mge" to "-1" in row 2
And I save the current editor

# Ruecklieferschein aendern
Given I open an editor "RLS035U" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record from editor "RLS035"
Then field "such" has value "RLS035"
And I set field "mge" to "-5" in row 1
And I save the current editor

Scenario: Remge bei gesplitteten LS Positionen bei RE aus AU

# BE, SplitRE und SplitLS, RLS auf SplitLS, dann RE stornieren
#
#  BE037 ------------------> RE037 --------------------------------------> SRE037 (5!)
#  150 St.   (1!)     \      100 St. split (2!)
#  | Aktion | remge    \      50 St. split (2!)
#  | (1)    | 150 St.   \    | Aktion | remge
#  | (2)    |   0 St.    \   | (2)    |   0 St. (Immer 0)
#  | (3)    |   0 St.     \
#  | (4)    |   0 St.      \
#                           ---------> LS037  ---------------> RLS037
#                                       75 St. split (3!)      -75 St.   (4!)
#                                       75 St. split (3!)      -25 St.   (4!)
#                                      | Aktion | remge       | Aktion | remge
#                                      | (3)    |  0 St.      | (4)    | -75 St.
#                                      | (3)    |  0 St.      | (4)    | -25 St.
#                                                             | (5)    |   0 St.
#                                                             | (5)    |   0 St.
#
# BE
Given I open an editor "BE037" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | nummer | 1BE037 |
   | such   | BE037  |
   | ebeleg | BE037  |
   | vom    | .      |
   | tterm  | .      |
And I append rows
   | artikel | he     | mge |
   | V1      | Stueck | 150 |
And I save the current editor

Given I open an editor "BE037V" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record from editor "BE037"
Then field "remge" has value "150" in row 1
And I close the current editor

# RE ohne LB mit Split
Given I open an editor "RE037" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE037"
And I set fields
   | nummer | 1RE037 |
   | such   | RE037  |
   | ebeleg | RE037  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
   | fakt   | nein   |
And I set field "mge" to "100" in row 1
And I set field "beleg" to id from editor "BE037"
And I set field "mge" to "50" in row 2
And I save the current editor

Then field "remge" from editor "RE037" in row 1 has value "-100"
Then field "remge" from editor "RE037" in row 2 has value "-50"

Then field "remge" from editor "BE037" in row 1 has value "0"

# LS mit Split, sofort buchen
Given I open an editor "LS037" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE037"
And I set fields
   | nummer | 1LS037 |
   | such   | LS037  |
   | ebeleg | LS037  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "75" in row 1
And I set field "beleg" to id from editor "BE037"
And I set field "mge" to "75" in row 2
And I save the current editor

Then field "remge" from editor "RE037" in row 1 has value "-100"
Then field "remge" from editor "RE037" in row 2 has value "-50"

Then field "remge" from editor "BE037" in row 1 has value "0"
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE037" is filed

# RLS zu gesplittetem LS
Given I open an editor "RLS037" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS037"
And I set fields
   | nummer | 1RLS037 |
   | such   | RLS037  |
   | ebeleg | RLS037  |
   | ueb    | ja      |
And I set field "mge" to "-75" in row 1
And I set field "mge" to "-25" in row 2
And I set field "platz" to "F1" in row 1
And I set field "platz" to "F1" in row 2
And I save the current editor
Then field "remge" from editor "RLS037" in row 1 has value "-75"
Then field "remge" from editor "RLS037" in row 2 has value "-25"

Then field "remge" from editor "BE037" in row 1 has value "0"

# Storno der gesplitteten RE
Given I open an editor "SRE037" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE037"
And I save the current editor

Then field "remge" from editor "BE037" in row 1 has value "150"
Then "(Purchasing):(PurchaseOrder)" with the editor id "BE037" is not filed

Then field "remge" from editor "RLS037" in row 1 has value "0"
Then field "remge" from editor "RLS037" in row 2 has value "0"

# BE, SplitRE und SplitLS, LS stornieren
#
#  BE040 ------------------> RE040
#  150 St.            \      100 St. split
#                      \      50 St. split
#                       \
#                         -----------> LS040  ---------------> LS040S
#                                       75 St.                 -75 St.
#                                       75 St.                 -25 St.

# BE
Given I open an editor "BE040" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | lief   | 1      |
   | nummer | 1BE040 |
   | such   | BE040  |
   | ebeleg | BE040  |
   | vom    | .      |
And I append rows
   | artikel | he     | mge |
   | E2      | Stueck | 150 |
And I save the current editor

# RE ohne LB mit Split
Given I open an editor "RE040" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE040"
And I set fields
   | nummer | 1RE040 |
   | such   | RE040  |
   | ebeleg | RE040  |
   | ueb    | ja     |
   | vom    | .      |
   | fakt   | nein   |
And I set field "mge" to "100" in row 1
And I set field "beleg" to id from editor "BE040"
And I set field "mge" to "50" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# LS mit Split, sofort buchen
Given I open an editor "LS040" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE040"
And I set fields
   | nummer | 1LS040 |
   | such   | LS040  |
   | ebeleg | LS040  |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "75" in row 1
And I set field "beleg" to id from editor "BE040"
And I set field "mge" to "75" in row 2
And I save the current editor

# Storno LS
Given I open an editor "LS040S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "LS040"
And I set fields
   | nummer | 1LS040S |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Bestellung mit Beistellung (ATLAS-relevant und aus dem Ausland) - patlasrel testen
#----------------------------------------------------------------------------------------------

# ATLAS einschalten
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set fields
    | atlas | ja |
And I save the current editor

# Lieferant bekommt Konsi-Lager
Given I open an editor "lieferant1" from table "(Vendor):(Vendor)" with command "STORE" for record "1"
And I set fields
   | konsi | L3F2 |
   | staat | USA  |
And I save the current editor

# Artikel aendern
Given I open an editor "ABEIST" from table "(Part):(Product)" with command "STORE" for record "ABEIST"
And I set fields
   | lief   | 1 |
   | efrist | 5 |
   | vorlauf| 3 |
Then field "atlasrel" has value "ja"
And I create a new row at the end of the table
And I set field "elex" to "E3" in row 1
And I set field "elanzahl" to "10" in row 1
And I set field "bua" to "Lieferantenbeistellung" in row 1
And I save the current editor

# Bestellung anlegen
Given I open an editor "BE_041" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE041 |
   | lief   | 1      |
   | such   | BE_041 |
   | ebeleg | BE_041 |
   | vom    | .      |
And I append rows
   | artex  | mge |
   | ABEIST | 2   |
And I save the current editor

And I run Scheduling

# Umlagerungsvorschlag
Given I open an editor "UML_USA" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set field "artikel" to "E3"
And I press button "ladetab"
Then the table has 1 rows
Then table has values
    | ablgruppe | lgruppe | mge | fix  |
    | KARLSRUHE | BERLIN  | 20  | nein |
And I set field "mfreig" to "ja" in row 1
And I press button "freig" to open a subeditor for "BE_freigeben"
And I set fields
   | nummer | 2BE041  |
   | lief   | 1       |
   | such   | BE2_041 |
Then field "vstaat" has value "USA"
# Intrastat-Rel setzen
Then field "intrarel" has value "nein" in row 1
Then field "patlasrel" has value "nein" in row 1
And I save the current subeditor to switch back to the parent editor
And I close the current editor

Given I open an editor "LS-2BE041" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "2BE041"
And I set fields
   | ebeleg | LS-2BE041 |
   | such   | LS-2BE041 |
   | vom    | .         |
Then field "laarta" has value "Ausland"
And I set field "patlasrel" to "ja" in row 1
And I set field "mge" to "20" in row 1
And I save the current editor

# Bei Lieferscheinen im Inland darf patlasrel nicht gesetzt werden
# Bestellung anlegen
Given I open an editor "BE_042" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1BE042 |
   | lief   | 1      |
   | such   | BE_042 |
   | ebeleg | BE_042 |
   | vom    | .      |
And I append rows
   | artex  | mge |
   | ABEIST | 1   |
And I save the current editor

Given I open an editor "LS042" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "BE_042"
And I set fields
   | nummer | 1LS042 |
   | such   | LS042  |
   | ebeleg | LS042  |
   | ueb    | ja     |
   | vom    | .      |
And I set field "mge" to "1" in row 1
# Im Einkauf duerfen nur Ruecksendungen an den Zoll gemeldet werden.
Then setting field "patlasrel" to "ja" in row 1 throws the exception "7504"
And I close the current editor

# ATLAS ausschalten
Given I open an editor "Konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set fields
    | atlas | nein |
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-043: Mehrere Teillieferungen mit Storno und Ruecklieferung
#----------------------------------------------------------------------------------------------

Scenario: Mehrere Teillieferungen mit Storno und Ruecklieferung

#
# BE043 -----> LS043_1 -----> RE043_1
# (100) \     (10)          (10)
#        \
#          ----------------------> LS043_2 -------> LS043_2S
#          \                       (5)             (Storno)
#           \
#             ----------------------------------------------> LS043_3----------> RE043_3
#                                                             \ (12)             (12)
#                                                              \
#                                                                -----------------------> RLS043_3
#                                                                                         (-7)
#
#

# Bestellung mit einer Position mit Menge 100
Given I create a PurchaseOrder "BE043" for Vendor "1" with Product "EINK" and quantity "100"

# 1. Teillieferschein aus Bestellung mit Menge 10 (fakt = TRUE) buchen
Given I open an editor "LS043_1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE043"
And I set fields
   | nummer | 1LS043_1 |
   | ebeleg | LS043_1  |
   | vom    | .        |
   | tterm  | .        |
   | fakt   | ja       |
   | ueb    | ja       |
   | such   | LS043_1  |
And I set field "mge" to "10" in row 1
And I save the current editor

# Rechnung aus 1. Teillieferschein mit Menge 10 buchen
Given I open an editor "RE043_1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS043_1"
And I set fields
   | nummer | 1RE043_1 |
   | ebeleg | RE043_1  |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
   | such   | RE043_1  |
And I set field "mge" to "10" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# 2. Teillieferschein aus Bestellung mit Menge 5 (fakt = TRUE) buchen
Given I open an editor "LS043_2" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE043"
And I set fields
   | nummer | 1LS043_2 |
   | ebeleg | LS043_2  |
   | vom    | .        |
   | tterm  | .        |
   | fakt   | ja       |
   | ueb    | ja       |
   | such   | LS043_2  |
And I set field "mge" to "5" in row 1
And I save the current editor

#  2. Teillieferung stornieren
Given I open an editor "teilrueckstorno" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "LS043_2"
Then I set field "nummer" to "1LS043S2"
And I save the current editor

# 3. Teillieferschein aus Bestellung mit Menge 12 buchen (fakt = TRUE)
Given I open an editor "LS043_3" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE043"
And I set fields
   | nummer | 1LS043_3 |
   | ebeleg | LS043_3  |
   | vom    | .        |
   | tterm  | .        |
   | fakt   | ja       |
   | ueb    | ja       |
   | such   | LS043_3  |
And I set field "mge" to "12" in row 1
And I save the current editor

# Rechnung aus 3. Teillieferschein mit Menge 12 buchen
Given I open an editor "RE043_3" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LS043_3"
And I set fields
   | nummer | 1RE043_3 |
   | ebeleg | RE043_3  |
   | vom    | .        |
   | tterm  | .        |
   | ueb    | ja       |
   | such   | RE043_3  |
And I set field "mge" to "12" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferschein aus 3. Teillieferschein mit Menge -7 buchen
Given I open an editor "RLS043_3" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "LS043_3"
And I set fields
   | nummer | 1RLS043   |
   | ebeleg | RLS043_3  |
   | vom    | .         |
   | tterm  | .         |
   | ueb    | ja        |
   | such   | RLS43_3   |
And I set field "mge" to "-7" in row 1
And I save the current editor

Given I open an editor "RE043_3V" from table "(Purchasing):(Invoice)" with command "VIEW" for record from editor "RE043_3"
Then field "remge" has value "-5" in row 1
And I close the current editor
