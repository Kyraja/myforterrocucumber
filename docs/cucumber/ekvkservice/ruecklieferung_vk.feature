# *****************************************************************************
#  Name           : ruecklieferung_vk.feature
#  Autor          : dago
#  Verantwortlich : teampss
#  Funktion       : VK: Behandlung von Ruecklieferungen, Teilruecklieferungen, Storno von Ruecklieferungen
#
# *****************************************************************************
#
@persistent
Feature: Ruecklieferung VK
Background: Test von Ruecklieferungen im Verkauf
Given I set the fake date to "02.01.1995"
Given I enable the flag 39

################################################################################
# V E R K A U F
################################################################################

@Testdaten
Scenario: Testdaten (Stammdaten) anlegen
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
And I save the current editor

@Stammdaten
Scenario Outline: Packmittel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "<artikel>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "packmit" to "ja"
And I set field "pmtyp" to "<pmtyp>"
And I save the current editor

Examples:
| artikel  | such     | namebspr         | pmtyp     |
| KLT      | KLT      | KLT              | Behaelter |
| SPALETTE | SPALETTE | Palette Standard | Palette   |
| SKARTON  | SKARTON  | KARTON Standard  | Behaelter |

@Stammdaten
Scenario: Packanweisung PACKA2, zweistufig
Given I open an editor "Packanweisung" from table "(PackingInstructions):(PackingInstructions)" with command "STORE" for record "PACKA2"
And I set field "such" to "PACKA2"
And I set field "artikel" to "KLT" in row 1
And I set field "anzahl" to "4" in row 1
And I set field "ebene" to "1" in row 1
And I set field "minebene" to "1" in row 1
And I set field "auffuell" to "nein" in row 1
And I set field "artikel" to "SPALETTE" in row 2
And I set field "anzahl" to "1" in row 2
And I set field "ebene" to "1" in row 2
And I set field "minebene" to "1" in row 2
And I set field "auffuell" to "nein" in row 2
And I save the current editor

@Stammdaten
Scenario Outline: Einkaufsartikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "<artikel>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "dispoa" to "<dispoa>"
And I set field "packanwstdla" to "<packanwstdla>"
And I set field "fmengestdla" to "10"
And I set field "packanwstdversand" to "<packanwstdversand>"
And I set field "fmengestdversand" to "10"
And I set field "fehe" to "<fehe>"
And I set field "ehe" to "<ehe>"
And I set field "fehle" to "<fehle>"
And I set field "feple" to "<feple>"
And I set field "gebehe" to "<gebehe>"
And I set field "lief" to "1"
And I set field "efrist" to "<efrist>"
And I set field "epr" to "<epr>"
And I set field "epe1" to "<epe1>"
And I set field "lief2" to "reus"
And I set field "efrist2" to "<efrist2>"
And I set field "epr2" to "<epr2>"
And I set field "epe2" to "<epe2>"
And I set field "chverfolgung" to "Chargenverfolgung"
And I set field "chimlager" to "ja"
And I set field "vhe" to "<vhe>"
And I set field "vpe" to "<vpe>"
And I set field "epe" to "<epe>"
And I set field "ve" to "<ve>"
And I set field "ge" to "<ge>"
And I set field "fvhe" to "<fvhe>"
And I set field "fvpe" to "<fvpe>"
And I set field "fepe" to "<fepe>"
And I set field "fve" to "<fve>"
And I set field "fge" to "<fge>"
And I save the current editor

Examples: Artikel
| artikel | such   | namebspr            | dispoa          | packanwstdla | packanwstdversand | fehe | ehe         | fehle | feple | gebehe | efrist | epr | epe1        | efrist2 | epr2 | epe2        | vhe         | vpe         | epe         | ve          | ge          | fvhe | fvpe | fepe | fve | fge |
| SATTEL  | SATTEL | Sattel fuer Fahrrad | auftragsbezogen | PACKA2       | PACKA2            | 1    | !dontChange | 1     | 1     |        | 1      | 10  | !dontChange | 1       | 15   | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | 1    | 1    | 1    | 1   | 1   |
| PEDALE  | PEDALE | Pedale fuer Fahrrad | auftragsbezogen | PACKA2       | PACKA2            | 1    | Paar        | 2     | 2     |        | 1      | 8   | !dontChange | 1       | 9,50 | !dontChange | Paar        | Paar        | Paar        | Paar        | Paar        | 1    | 1    | 1    | 1   | 1   |

@Stammdaten
Scenario: STAMMDATEN - Neue Dienstleistung anlegen
Given I open an editor "dienstl" from table "(Part):(Service)" with command "STORE" for record "dl-analyse"
And I set field "such" to "dl-analyse"
And I set field "namebspr" to "Anlayse"
And I set field "vpr" to "50.00"
And I save the current editor

#------------------------------------------------------------------------------
# Fuer Bestand sorgen
#------------------------------------------------------------------------------

Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | V1        |
    | buart   | ZUGANG    |
    | beleg   | .         |
    | beldat  | .         |
And I append rows
    | platz2 | mge  |
    | F1     | 1000 |
And I save the current editor

Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | E2        |
    | buart   | ZUGANG    |
    | beleg   | .         |
    | beldat  | .         |
And I append rows
    | platz2 | mge  |
    | F2     | 1000 |
And I save the current editor

Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | ARTIKEL1  |
    | buart   | ZUGANG    |
    | beleg   | .         |
    | beldat  | .         |
And I append rows
    | platz2 | mge  |
    | F1     | 1000 |
And I save the current editor

Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | V1        |
    | buart   | ZUGANG    |
    | beleg   | .         |
    | beldat  | .         |
And I append rows
    | platz2  | mge |
    | KONSILP | 20  |
And I save the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-001: Kommando <retoure> (bzw. <return>) und Plausibilitaetspruefungen
#------------------------------------------------------------------------------

@Lieferschein
Scenario: Kommando <(Sales)> LIEFERSCHEIN <(return)>
# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
# Lieferscheinart kann nicht geandert werden.
Given I open an editor "ruecklief" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS003"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "vorganga" has value ""
And I set field "rueckligrund" to "Transportschaden"
And I set field "nummer" to "1LS003R"
# Nachfolgende Felder duerfen nicht in einem Ruecklieferschein geaendert werden
# bzw. muessen negativ sein.
And setting field "lsart" to "Lieferschein" throws the exception ""
And setting field "kunde" to "1" throws the exception ""
And setting field "warenempf" to "1" throws the exception ""
And setting field "artikel" to "E1" in row 1 throws the exception ""
And setting field "mge" to "3" in row 1 throws the exception ""
Then field "fakt" has value "ja"
And setting field "fakt" to "nein" throws the exception ""
And I close the current editor

@Rechnung+Lagerbewegung
Scenario: Kommando <(Sales)> RECHNUNG <(return)>
# Aus einer Rechnung mit Lagerbewegung (abgelegt) wird ueber Kommando RETURN ein Ruecklieferschein
# Lieferscheinart kann nicht geandert werden.
Given I open an editor "ruecklief" from table "(Sales):(Invoice)" with command "RETURN" for record "+1RE007"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "vorganga" has value ""
# Nachfolgende Felder duerfen nicht in einem Ruecklieferschein geaendert werden
# bzw. die Ruecklieferungsmenge darf nicht > Liefermenge - bereits rueckgelieferte Menge sein.
And setting field "lsart" to "Lieferschein" throws the exception ""
And setting field "kunde" to "1" throws the exception ""
And setting field "warenempf" to "1" throws the exception ""
And setting field "artikel" to "E1" in row 1 throws the exception ""
And setting field "mge" to "-11" in row 1 throws the exception ""
Then field "fakt" has value "ja"
And setting field "fakt" to "nein" throws the exception ""
And I close the current editor

@Lieferschein
Scenario: Versuchen gespeicherten Ruecklieferschein zu aendern
# Anlegen eines Lieferscheins / buchen
Given I open an editor "templief" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
Then I set field "kunde" to "1"
Then I set field "nummer" to "1LS009"
Then I set field "such" to "LS009"
Then I set field "ueb" to "Ja"
And I create a new row at the end of the table
Then I set field "artikel" to "V1" in row !lastRow
Then I set field "mge" to "10" in row !lastRow
And I save the current editor

# Aus einem Lieferschein wird ueber Kommando RETURN ein Ruecklieferschein
# Lieferscheinart kann nicht geandert werden.
Given I open an editor "rueckliefaend" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LS009"
Then I set field "such" to "RLS009"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then field "vorganga" has value ""
Then I set field "mge" to "-2" in row !lastRow
Then I set field "rueckligrund" to "Falschbestellung" in row !lastRow
And I save the current editor

# Erneutes Oeffnen und versuchen zu aendern
Given I open an editor "rueckliefaend2" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "RLS009"
# Nachfolgende Felder duerfen nicht in einem geanderten Ruecklieferschein geaendert werden
And setting field "lsart" to "Lieferschein" throws the exception ""
And setting field "kunde" to "1" throws the exception ""
And setting field "warenempf" to "1" throws the exception ""
And setting field "artikel" to "V1" in row 1 throws the exception ""
# Nachfolgende Felder duerfen nicht negativ sein.
And setting field "preis" to "-12" in row 1 throws the exception ""
And I close the current editor

# Aenderungen von Einheit und Faktor im Ruecklieferschein
Given I open an editor "ruecklief" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS021"
And I set field "mge" to "-10" in row 1
Then setting field "he" to "Stück" in row 1 throws the exception ""
And I set field "mge" to "-5" in row 1
And I set field "he" to "Stück" in row 1
Then setting field "lehe" to "2" in row 1 throws the exception ""
And I set field "lehe" to "0,25" in row 1
And I set field "mge" to "-20" in row 1
And I close the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-002: Teilruecklieferung gebuchter Lieferschein
#------------------------------------------------------------------------------

@TeilruecklieferungLS
Scenario: Teilruecklieferung gebuchter Lieferschein
# 1. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS100"
Then I set field "nummer" to "1LS100R1"
Then I set field "mge" to "-3" in row 1
Then field "fixpwert" has value "ja" in row 1
Then I set field "fixpwert" to "nein" in row 1
Then I set field "mge" to "-1" in row 4
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS100"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS100R1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# 2. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS100"
Then I set field "nummer" to "1LS100R2"
Then I set field "mge" to "-4" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS100"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS100R2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# 3. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS100"
Then I set field "nummer" to "1LS100R3"
Then I set field "mge" to "-5" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS100"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS100R3"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# 2. Teilruecklieferung zuruecknehmen
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS100R2"
Then I set field "mge" to "0" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS100"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS100R2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# 1. Teilruecklieferung buchen
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS100R1"
Then I set field "ueb" to "ja"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS100"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS100R1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# 4. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS100"
Then I set field "nummer" to "1LS100R4"
Then I set field "ueb" to "ja"
Then I set field "mge" to "-4" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS100"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS100R4"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# 3. Teilruecklieferung buchen
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS100R3"
Then I set field "ueb" to "ja"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS100"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS100R3"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-003: Teilruecklieferung Rechnung mit Lagerbewegung
#------------------------------------------------------------------------------

@TeilruecklieferungRE
Scenario: Teilruecklieferung Rechnung mit Lagerbewegung
# 1. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Sales):(Invoice)" with command "RETURN" for record "+1RE101"
Then I set field "nummer" to "1LS101R1"
Then I set field "mge" to "-3" in row 1
Then field "fixpwert" has value "ja" in row 1
Then I set field "fixpwert" to "nein" in row 1
Then I set field "mge" to "-1" in row 4
And I save the current editor

# Ausgabe Rechnung mit Lagerbewegung
Given I open an editor "teilrueck" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE101"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS101R1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# 2. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Sales):(Invoice)" with command "RETURN" for record "+1RE101"
Then I set field "nummer" to "1LS101R2"
Then I set field "mge" to "-4" in row 1
And I save the current editor

# Ausgabe Rechnung mit Lagerbewegung
Given I open an editor "teilrueck" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE101"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS101R2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# 3. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Sales):(Invoice)" with command "RETURN" for record "+1RE101"
Then I set field "nummer" to "1LS101R3"
Then I set field "mge" to "-5" in row 1
And I save the current editor

# Ausgabe Rechnung mit Lagerbewegung
Given I open an editor "teilrueck" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE101"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS101R3"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# 2. Teilruecklieferung zuruecknehmen
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS101R2"
Then I set field "mge" to "0" in row 1
And I save the current editor

# Ausgabe Rechnung mit Lagerbewegung
Given I open an editor "teilrueck" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE101"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS101R2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# 1. Teilruecklieferung buchen
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS101R1"
Then I set field "ueb" to "ja"
And I save the current editor

# Ausgabe Rechnung mit Lagerbewegung
Given I open an editor "teilrueck" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE101"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS101R1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# 4. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Sales):(Invoice)" with command "RETURN" for record "+1RE101"
Then I set field "nummer" to "1LS101R4"
Then I set field "ueb" to "ja"
Then I set field "mge" to "-4" in row 1
And I save the current editor

# Ausgabe Rechnung mit Lagerbewegung
Given I open an editor "teilrueck" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE101"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS101R4"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# 3. Teilruecklieferung buchen
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS101R3"
Then I set field "ueb" to "ja"
And I save the current editor

# Ausgabe Rechnung mit Lagerbewegung
Given I open an editor "teilrueck" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE101"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS101R3"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-004: Gemischte Teillieferung und Teilruecklieferung
#------------------------------------------------------------------------------

@TeillieferRueckliefer
Scenario: Teillieferung und Teilruecklieferung
# 1. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "RETURN" for record "+1LS105"
Then I set field "nummer" to "1LS105R1"
Then I set field "ueb" to "ja"
Then I set field "mge" to "-50" in row 1
And I save the current editor

# Ausgabe Teillieferung
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS105"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferung
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS105R1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Teillieferung
Given I open an editor "teilrueck" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU105"
Then I set field "nummer" to "1LS106"
Then I set field "ueb" to "ja"
Then I set field "mge" to "25" in row 1
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "teilrueck" from table "(Sales):(SalesOrder)" with command "VIEW" for record "+1AU105"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Teillieferung
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS106"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# 2. Teilruecklieferung
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "RETURN" for record "+1LS105"
Then I set field "nummer" to "1LS105R2"
Then I set field "ueb" to "ja"
Then I set field "mge" to "-25" in row 1
Then I set field "beleg" to "1LS106"
Then I set field "mge" to "-25" in row 3
And I save the current editor

# Ausgabe Auftrag
Given I open an editor "teilrueck" from table "(Sales):(SalesOrder)" with command "VIEW" for record "+1AU105"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Teillieferung
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS105"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Teillieferung
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS106"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferung
Given I open an editor "teilrueck" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS105R2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-007: Storno Teilruecklieferung gebuchter Lieferschein
#------------------------------------------------------------------------------

@TeilruecklieferungLSStorno
Scenario: Storno Teilruecklieferung gebuchter Lieferschein
# 1. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS102"
Then I set field "nummer" to "1LS102R1"
Then I set field "ueb" to "ja"
Then I set field "mge" to "-5" in row 1
Then I set field "mge" to "-1" in row 4
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS102"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS102R1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# 2. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS102"
Then I set field "nummer" to "1LS102R2"
Then I set field "ueb" to "ja"
Then I set field "mge" to "-7" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS102"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS102R2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Storno 1. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+1LS102R1"
Then I set field "nummer" to "1LS102S1"
And I set field "bem" to "Storno 1. TeilRueckLS"
And I save the current editor
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I close the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS102"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe stornierter Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS102R1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Storno-Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS102S1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Storno 2. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "+1LS102R2"
Then I set field "nummer" to "1LS102S2"
And I save the current editor
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I close the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS102"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe stornierter Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS102R2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Storno-Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS102S2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# 3. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS102"
Then I set field "nummer" to "1LS102R3"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
Then I set field "mge" to "-12" in row 1
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS102"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS102R3"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-008: Storno Teilruecklieferung Rechnung mit Lagerbewegung
#------------------------------------------------------------------------------

@TeilruecklieferungREStorno
Scenario: Storno Teilruecklieferung Rechnung mit Lagerbewegung
# 1. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Sales):(Invoice)" with command "RETURN" for record "+1RE103"
Then I set field "nummer" to "1LS103R1"
Then I set field "ueb" to "ja"
Then I set field "mge" to "-5" in row 1
Then I set field "mge" to "-1" in row 4
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "teilrueckstorno" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE103"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS103R1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# 2. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Sales):(Invoice)" with command "RETURN" for record "+1RE103"
Then I set field "nummer" to "1LS103R2"
Then I set field "ueb" to "ja"
Then I set field "mge" to "-7" in row 1
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "teilrueckstorno" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE103"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS103R2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Storno 1. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "1LS103R1"
Then I set field "nummer" to "1LS103S1"
And I save the current editor
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I close the current editor

# Ausgabe Rechnung
Given I open an editor "teilrueckstorno" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE103"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe stornierter Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS103R1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Storno-Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS103S1"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Storno 2. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "1LS103R2"
Then I set field "nummer" to "1LS103S2"
And I save the current editor
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I close the current editor

# Ausgabe Lieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE103"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe stornierter Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS103R2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Storno-Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+1LS103S2"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# 3. Teilruecklieferung
Given I open an editor "teilrueckstorno" from table "(Sales):(Invoice)" with command "RETURN" for record "+1RE103"
Then I set field "nummer" to "1LS103R3"
Then I set field "vom" to "."
Then I set field "ueb" to "ja"
Then I set field "mge" to "-12" in row 1
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "teilrueckstorno" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE103"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

# Ausgabe Ruecklieferschein
Given I open an editor "teilrueckstorno" from table "(Sales):(PackingSlip)" with command "VIEW" for record "1LS103R3"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I close the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-010: Beleg anfuegen im Ruecklieferschein - ganze Vorgaenge
#------------------------------------------------------------------------------

@RuecklieferungBelegAnfuegen
Scenario: Beleg anfuegen im Ruecklieferschein - Anfuegen ganzer Vorgaenge
Given I open an editor "rliefbeleganf" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS010"
Then I set field "nummer" to "1LS010R1"
# Auftrag
And setting field "beleg" to "1AU001" throws the exception ""
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
# Lieferschein, Rechnung ueber Auftag, nicht gebucht
And setting field "beleg" to "1LS004" throws the exception ""
# Rechnung aus Auftrag, ohne Lagerbewegung, nicht gebucht
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
Then I set field "beleg" to "+1LS004B"
# anfuegbar, aber nicht speicherbar da ungebuchte RE existiert
And I delete row at position !lastRow
And I delete row at position !lastRow
# Rechnung mit Lagerbewegung, gebucht
Then I set field "beleg" to "+1RE007"
# Noch einmal
Then I set field "beleg" to "+1RE007"
# Urspruenglicher Lieferschein noch einmal
Then I set field "beleg" to "1LS010"
Then I set field "mge" to "-5" in row 1
Then I set field "mge" to "-4" in row 4
Then I set field "mge" to "-2" in row 6
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I save the current editor

Given I open an editor "rliefbeleganf" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS010R1"
# Lieferschein, Rechnung ueber Lieferschein, gebucht, nicht abgelegt
Then I set field "beleg" to "1LS003"
# Noch einmal
Then I set field "beleg" to "1LS003"
# Lieferschein, Rechnung ueber Auftag, gebucht
Then I set field "beleg" to "+1LS004B"
# Noch einmal
Then I set field "beleg" to "+1LS004B"
# Rechnung mit Lagerbewegung, gebucht
Then I set field "beleg" to "+1RE007"
# Noch einmal
Then I set field "beleg" to "+1RE007"
# Urspruenglicher Lieferschein noch einmal
Then I set field "beleg" to "1LS010"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I delete all rows
And I save the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-011: Beleg anfuegen im Ruecklieferschein - einzelne Positionen
#------------------------------------------------------------------------------

Scenario: Beleg anfuegen im Ruecklieferschein - Anfuegen einzelner Positionen
Given I open an editor "rliefbeleganf" from table "(Sales):(PackingSlip)" with command "RETURN" for record "1LS010"
Then I set field "nummer" to "1LS010R2"
# Auftrag
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=1AU001" throws the exception ""
# Anzahlungsrechnung, gebucht
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=ANZAHLUNG;kopf=+1RE001A" throws the exception ""
# Schlussrechnung, ohne Lagerbewegung, gebucht
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=+1RE001" throws the exception ""
# Anzahlungsrechnung, nicht gebucht
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=ANZAHLUNG;kopf=1RE002A" throws the exception ""
# Schlussrechnung, ohne Lagerbewegung, nicht gebucht
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=1RE002" throws the exception ""
# Rechnung aus Lieferschein, gebucht
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=+1RE003" throws the exception ""
# Lieferschein, Rechnung ueber Auftag, nicht gebucht
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=1LS004" throws the exception ""
# Rechnung aus Auftrag, ohne Lagerbewegung, nicht gebucht
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=1RE004" throws the exception ""
# Stornierter Lieferschein
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=+1LS005" throws the exception ""
# Storno-Lieferschein
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=+1LS005S" throws the exception ""
# Stornierte Rechnung
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=+1RE006" throws the exception ""
# Storno-Rechnung
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=+1RE006S" throws the exception ""
# Rechnung mit Lagerbewegung, nicht gebucht
And setting field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=1RE008" throws the exception ""
# Lieferschein, Rechnung ueber Lieferschein, gebucht, nicht abgelegt
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=1LS003"
# Noch einmal
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=1LS003"
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=+1LS004B"
# anfuegbar, aber nicht speicherbar da ungebuchte RE existiert
And I delete row at position !lastRow
And I delete row at position !lastRow
# Rechnung mit Lagerbewegung, gebucht
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=+1RE007"
# Noch einmal
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=+1RE007"
# Urspruenglicher Lieferschein noch einmal
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=1LS010"
Then I set field "mge" to "-5" in row 1
#Then I set field "mge" to "-4" in row 4
Then I set field "mge" to "-3" in row 4
Then I set field "mge" to "-2" in row 6
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I save the current editor

Given I open an editor "rliefbeleganf" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS010R2"
# Lieferschein, Rechnung ueber Lieferschein, gebucht, nicht abgelegt
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=1LS003"
# Noch einmal
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=1LS003"
# Lieferschein, Rechnung ueber Auftag, gebucht
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=+1LS004B"
# Noch einmal
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=+1LS004B"
# Rechnung mit Lagerbewegung, gebucht
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=+1RE007"
# Noch einmal
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=+1RE007"
# Urspruenglicher Lieferschein noch einmal
Then I set field "beleg" to "$,,@gruppe=2;@ablageart=beides;artikel=V1;kopf=1LS010"
Then I fill template "EV_VORG_RUECK.ftl" and append it to output file "ruecklieferung_vk.out"
And I delete all rows
And I save the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-012: Nur positive Mengen in Lieferschein und Rechnung mit Lagerbewegung
#------------------------------------------------------------------------------

@NurPositiveMengenLSundRE
Scenario: Menge im Lieferschein darf nicht negativ sein
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "nummer" to "1AU009"
And I set field "kunde" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "1" in row 1
And I set field "vmge" to "1" in row 1
And I save the current editor

Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag"
And I set field "nummer" to "1LS011"
And setting field "mge" to "-2" in row 1 throws the exception ""
And I set field "mge" to "1" in row 1
And I set field "vom" to "."
And I save the current editor

Scenario: Menge in Rechnung mit Lagerbewegung darf nicht negativ sein
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "nummer" to "1AU010"
And I set field "kunde" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "1" in row 1
And I set field "vmge" to "1" in row 1
And I save the current editor

Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag"
And I set field "nummer" to "1RE011"
And setting field "mge" to "-2" in row 2 throws the exception ""
And I set field "mge" to "1" in row 1
And I set field "vom" to "."
And I set field "term" to "."
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-013: Umlagerplatz bei Ruecklieferung, Konsignationslagerplatz in den Positionen
#------------------------------------------------------------------------------

Scenario: Umlagerplatz bei Ruecklieferung, Konsignationslagerplatz in den Positionen

Given I open an editor "Lief" from table "(Sales):(PackingSlip)" with command "STORE" for record "LSKONS"
Then I set field "kunde" to "1"
Then I set field "nummer" to "1LS013"
Then I set field "such" to "LSKONS"
Then I set field "ueb" to "Ja"
And I create a new row at the end of the table
Then I set field "artikel" to "AUBE" in row !lastRow
Then I set field "mge" to "5" in row !lastRow
And I create a new row at the end of the table
Then I set field "artikel" to "AUBE" in row !lastRow
Then I set field "mge" to "6" in row !lastRow
And I save the current editor

Given I open an editor "rueck_konsi_vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LSKONS"
Then I set field "nummer" to "1LS012R4"
Then field "umplatz" is empty
Then field "umlgruppe" is empty
Then field "umplatz" is not modifiable
Then field "umlgruppe" is not modifiable
And I set field "mge" to "-1" in row 1
And I set field "platz" to "F2" in row 2
# 3. Zeile AUBE hat keinen Lagerplatz - Speichern geht trotzdem
And I save the current editor

Scenario Outline: VK-Lieferschein, Ruecklieferung mit unterschiedlichen Lagerplaetzen
# Lagerjournaleintraege werden hinterher ins Ref ausgegeben
Given I set the fake date to "23.04.1995"

Given I open an editor "LS" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
Then I set field "kunde" to "1"
Then I set field "such" to "LS<row>"
Then I set field "vom" to "."
Then I set field "ueb" to "Ja"
And I create a new row at the end of the table
Then I set field "artikel" to "E2" in row !lastRow
Then I set field "mge" to "<mge>" in row !lastRow
And I save the current editor

Given I open an editor "RLSUM" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LS<row>"
And I set field "vom" to "."
And I set field "such" to "LSR<row>"
Then I set field "ueb" to "Ja"
And I set field "mge" to "-<mge>" in row 1
And I set field "platz" to "<platz>" in row 1
And I save the current editor

Examples:

 |row |mge |platz      |
 |01  |1   |F1         |
 |02  |2   |!dontChange|
 |03  |3   |!dontChange|

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
	|lager           |such     |namebspr           |lgruppe           |
	|Konsignationsla |KONSILG1 |Konsignationslager |Konsilagergruppe  |
	|Externeslager   |EXTERNLG |Externes Lager     |Externelagergruppe|

Scenario Outline: STAMMDATEN - Konsignationslagerplatz und externen Lagerplatz anlegen
Given I open an editor "<lagerplatz>" from table "(Location):(Location)" with command "STORE" for record "<such>"
And I set field "such" to "<such>"
And I set field "namebspr" to "<namebspr>"
And I set field "lager" to id from editor "<lager>"
And I set field "lgruppe" to id from editor "<lgruppe>"
And I save the current editor

Examples: Lagerplatz
	|lagerplatz      |such     |namebspr            |lager           |lgruppe           |
	|Konsignationslp |KONSILG1 |Konsignationslager  |Konsignationsla |Konsilagergruppe  |
	|Externer1lp     |extern   |Externer Lagerplatz |Externeslager   |Externelagergruppe|
	|Externer2lp     |extern2  |Externer Lagerplatz |Externeslager   |Externelagergruppe|

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
	|such 	  |namebspr  |vkbez     |vbez      |ebez      |vpr   |bsart            |dispoa         |lief |epr  |efrist|
	|artikel1 |Artikel 1 |Artikel 1 |Artikel 1 |Artikel 1 |10000 |Fremdbeschaffung |bedarfsbezogen |reus |9000 |15    |
	|artikel2 |Artikel 2 |Artikel 2 |Artikel 2 |Artikel 2 | 9000 |Fremdbeschaffung |bedarfsbezogen |reus |7000 |10    |
	|artikel3 |Artikel 3 |Artikel 3 |Artikel 3 |Artikel 3 | 8000 |Fremdbeschaffung |bedarfsbezogen |reus |6000 |12    |

Scenario Outline: STAMMDATEN - Zusatzposition vom Typ AU/BE anlegen
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
	|zusatzpos   |such   |namebspr             |zptyp             |vkbez                |vbez                 |ebez                 |vpr  |epr |
	|zusatzAUBE  |AUBE   |Zusatzposition AU/BE |AU/BE-Position,BV |Zusatzposition AU/BE |Zusatzposition AU/BE |Zusatzposition AU/BE |1100 |1000|
	|neutralePOS |NEUPOS |Neutrale Position    |Neutrale Position |Neutrale Position    |Neutrale Position    |Neutrale Position    | 500 | 400|

Scenario: Lagergruppe - Pruefen der Plausibiltaeten der Ruecklieferungslaeger
Given I open an editor "lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "UPDATE" for record "KARLSRUHE"
And setting field "vkruecklieferung" to "KONSILG1" throws the exception ""
And setting field "vkruecklieferung" to "103" throws the exception ""
And I set field "vkruecklieferung" to "F2"
And setting field "vkkundenanlieferung" to "F2" throws the exception ""
And I set field "vkkundenanlieferung" to id from editor "Konsignationslp"
And I save the current editor

Scenario: Lagergruppe - Pruefen der Plausibiltaeten der Ruecklieferungslaeger
Given I open an editor "lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "UPDATE" for record "KARLSRUHE"
And setting field "vkruecklieferung" to "KONSILG1" throws the exception ""
And setting field "vkruecklieferung" to "103" throws the exception ""
And I set field "vkruecklieferung" to "F2"
And setting field "vkkundenanlieferung" to "F2" throws the exception ""
And I set field "vkkundenanlieferung" to "KONSILP1"
And I close the current editor

Scenario: Lagergruppe - In Konsignationslagergruppe muessen die Felder fuer die Ruecklieferung schreibgeschuetzt sein
Given I open an editor "Konsignationslgruppe" from table "(Warehouse):(WarehouseGroup)" with command "UPDATE" for record "KONSILG1"
Then field "vkruecklieferung" is not modifiable
Then field "vkkundenanlieferung" is not modifiable
And I close the current editor

Scenario: STAMMDATEN - Neuen Kunden anlegen
Given I open an editor "kunde" from table "(Customer):(Customer)" with command "STORE" for record "Bayram"
And I set field "such" to "Bayram"
And I set field "namebspr" to "Bayram Werkzeugbau, Rastatt"
And I set field "ans" to "Bayram Werkzeugbau GmbH"
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
Then field "name" has value "Bayram Werkzeugbau, Rastatt"
Then field "zbed" has value "201"

Scenario: Lagergruppe - Externe Lagergruppe mit Ruecklieferungslagerplaetzen fuellen
Given I open an editor "lagergruppe" from table "(Warehouse):(WarehouseGroup)" with command "UPDATE" for record "EXTERN"
And setting field "vkruecklieferung" to "KONSILG1" throws the exception ""
And setting field "vkruecklieferung" to "F2" throws the exception ""
And I set field "vkruecklieferung" to "EXTERN2"
And setting field "vkkundenanlieferung" to "EXTERN" throws the exception ""
And I set field "vkkundenanlieferung" to id from editor "Konsignationslp"
And I save the current editor

Scenario: Auftrag mit 2 normalen Positionen und 2 Zusatzpositonen anlegen
Given I open an editor "auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I create a new row at the end of the table
And I set field "artikel" to id from editor "artikel1" in row 1
And I set field "mge" to "10" in row 1
And I create a new row at the end of the table
And I set field "artikel" to id from editor "artikel2" in row 2
And I set field "mge" to "10" in row 2
And I set field "platz" to id from editor "Externer2lp" in row 2
And I create a new row at the end of the table
And I set field "artikel" to id from editor "zusatzAUBE" in row 3
And I set field "mge" to "10" in row 3
And I create a new row at the end of the table
And I set field "artikel" to id from editor "neutralePOS" in row 4
And I save the current editor

Scenario: Lieferschein zu obigem Auftrag anlegen und eine Position buchen
Given I open an editor "vk1lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag"
And I set field "such" to "RLB1"
And I set field "ueb" to "ja"
Then setting field "mge" to "-1" in row 1 throws the exception ""
And I set field "mge" to "5" in row 1
Then field "platz" has value "F1" in row 1
Then field "lgruppe" has value "KARLSRUHE" in row 1
# Setzen eines anderen Lagerplatz der gleichen Lagergruppe
And I set field "platz" to "F2" in row 1
# Platz F1 wieder eintragen
And I set field "platz" to "F1" in row 1
And I set field "mge" to "5" in row 2
Then field "lgruppe" has value "EXTERNLG" in row 2
And I save the current editor

Scenario: Obigen Lieferschein rueckliefern
Given I open an editor "rlieferschein" from table "(Sales):(PackingSlip)" with command "RETURN" for record "RLB1"
Then field "lsart" has value "Rücklieferschein"
And I set field "such" to "RRLB1"
And I set field "rueckligrund" to "Transportschaden"
Then field "kunde" is not modifiable
Then field "kunde2" is not modifiable
Then field "kunde3" is not modifiable
Then the table has 3 rows
Then field "artex" is not modifiable in row 1
Then field "platz" has value "F2" in row 1
And I set field "mge" to "-2" in row 1
Then field "ofmge" has value "-3" in row 1
And I set field "abplatz" to "F2" in row 1
# Lagerplatz muss vkruecklieferung aus Lagergruppe sein
Then field "platz" has value "EXTERN2" in row 2
And I set field "mge" to "-3" in row 2
Then field "ofmge" has value "-2" in row 2
And I save the current editor

Scenario: Ruecklieferschein oeffnen und nochmals aendern
Given I open an editor "rlieferschein" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "RRLB1"
Then field "lsart" has value "Rücklieferschein"
And I set field "ueb" to "ja"
Then the table has 3 rows
# Lagerplatz muss vkruecklieferung aus Lagergruppe sein
Then field "platz" has value "F2" in row 1
Then field "platz" has value "EXTERN2" in row 2
# Neue Zeile: Nur Zusatzpositionen ohne AU/BE Positionen
And I create a new row at the end of the table
And setting field "artikel" to "AUBE" in row 3 throws the exception ""
And setting field "artikel" to "artikel1" in row 3 throws the exception ""
And setting field "artikel" to "dl-analyse" in row 3 throws the exception ""
And I save the current editor

Scenario: Rechnung mit Lagerbewegung zu obigem Auftrag anlegen und zwei Positionen buchen
Given I open an editor "vkrechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag"
And I set field "such" to "RLREB1"
And I set field "ueb" to "ja"
Then setting field "mge" to "-1" in row 1 throws the exception ""
And I set field "mge" to "5" in row 1
And I set field "mge" to "5" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Scenario: Obige Rechnung rueckliefern
Given I open an editor "rrechnung" from table "(Sales):(Invoice)" with command "RETURN" for record "+rlreb1"
Then field "lsart" has value "Rücklieferschein"
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then the table has 2 rows
# Lagerplatz muss vkruecklieferung aus Lagergruppe sein
Then field "platz" has value "F2" in row 1
Then field "platz" has value "EXTERN2" in row 2
And I set field "mge" to "-2" in row 1
Then field "ofmge" has value "-3" in row 1
And I set field "mge" to "-3" in row 2
Then field "ofmge" has value "-2" in row 2
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-016: Packmittelpositionen koennen im Ruecklieferschein entfernt werden.
#----------------------------------------------------------------------------------------------
Scenario: EDI LS -> Packmittelpositionen im Ruecklieferschein loeschen
Given I open an editor "VKLSmitPackmittel" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kunde"
And I set field "such" to "LS-PACKM"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "SATTEL" in row 1
And I set field "mge" to "100" in row 1
And I set field "fmenge" to "90" in row 1
And I create a new row at the end of the table
And I set field "artikel" to "PEDALE" in row 2
And I set field "mge" to "100" in row 2
And I set field "fmenge" to "91" in row 2
And I press button "packvor"
And I press button "verpplanbearb" to open a subeditor for "Verpackungsplanung"
And I set field "istmaster" to "ja" in row 3
And I set field "zuteilen" to "1" in row 4
And I set field "zuteilen" to "1" in row 5
And I press button "verpacken"
And I press button "splitloesch" in row 6
And I save the current editor
And I switch the current editor to editor "VKLSmitPackmittel"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "ruecklspackmittel" from table "(Sales):(PackingSlip)" with command "RETURN" for record "LS-PACKM"
Then I set field "such" to "RLS-PACKM"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
Then I set field "mge" to "-80" in row 5
Then I set field "rueckligrund" to "Falschbestellung" in row 5
And I delete row at position 7
And I delete row at position 6
Then I set field "mge" to "-80" in row 1
Then I set field "rueckligrund" to "Falschbestellung" in row 1
Then I set field "mge" to "-1" in row 4
And I delete row at position 3
And I delete row at position 2
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-017: Zeige-Modus: Rechnungsart wird richtig angezeigt.
#----------------------------------------------------------------------------------------------
Scenario: Rechnungsarten werden richtig zugeordnet und angezeigt
Given I open an editor "RE-storniert" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE006"
Then field "vorganga" has value "Stornierte Rechnung"
And I close the current editor

Given I open an editor "Storno-RE" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE006S"
Then field "vorganga" has value "Storno-Rechnung"
And I close the current editor

Given I open an editor "REanzahlung" from table "(Sales):(Invoice)" with command "VIEW" for record "+1RE001A"
Then field "vorganga" has value "Anzahlung"
And I close the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-019: Ruecklieferung bei Konsignationslagerplatz im Kunden/Lieferanten und bei Umlagerrechnung
#----------------------------------------------------------------------------------------------

Scenario: Rücklieferung aus Rechnung mit Lagerbewegung mit Konsignationslagerplatz im Kunden
Given I open an editor "1AU020" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "nummer" to "1AU020"
And I set field "kunde" to "1KUNDE"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "1AU020" from table "(Sales):(SalesOrder)" with command "INVOICE" for record "1AU020"
And I set field "nummer" to "1RE020"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "1RE020" from table "(Sales):(Invoice)" with command "RETURN" for record "+1RE020"
And I set field "nummer" to "1RE020R"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-021: Anfuegen von LS und RE mit Lagerbewegung an einen leeren Lieferschein
#----------------------------------------------------------------------------------------------

Scenario: Beleg anfuegen LS an LS (ergibt RLS)

# LS anlegen
Given I open an editor "LS02" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1    |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS02 |
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I save the current editor

# LS anlegen -> LS anfuegen -> RLS
Given I open an editor "LS03" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1    |
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
    | artikel | mge  | herkunft^kopf^such |
    | V1      |  -10 |                    |
And I save the current editor

Given I open an editor "LS03V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS03"
Then field "lsart" has value "Rücklieferschein"
And I close the current editor

Scenario: Beleg anfuegen LS an LS (ergibt RLS) Kein Mischen erlauben

# Auftrag neu
Given I create a SalesOrder "AU04" for Customer "1" with Product "V1" and quantity "5"

# LS neu
Given I open an editor "LS04" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1    |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS04 |
And I append rows
  |artikel  | mge    |
  |V2       | 11     |
And I save the current editor

# LS neu, AU anfuegen, LS anfuegen
Given I open an editor "LS05" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1    |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS05 |
And I set field "beleg" to "nummer" from editor "AU04"
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
# AU an RLS anfuegen-> Dieser Beleg darf nicht angefuegt werden
Then setting field "beleg" in row 0 to "id" from editor "AU04" in row 0 throws the exception "4615"
Then the table has 1 rows
And I close the current editor

Scenario: Beleg anfuegen RE mit Lagerbewegung an LS (ergibt RLS)

# RE mit Lagerbewegung anlegen
Given I open an editor "RE01L" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | kunde  | 1     |
   | vom    | .     |
   | tterm  | .     |
   | fakt   | ja    |
   | ueb    | ja    |
   | such   | RE01L |
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# LS anlegen -> RE mit Lagerbewegung anfuegen -> RLS
Given I open an editor "LS06" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1    |
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
    | V1      |  -10 |
And I save the current editor

Given I open an editor "LS06V" from table "(Sales):(PackingSlip)" with command "VIEW" for record from editor "LS06"
Then field "lsart" has value "Rücklieferschein"
And I close the current editor

Scenario: Beleg anfuegen RE mit Lagerbewegung an LS (ergibt RLS). Kein Mischen erlauben

# Auftrag neu
Given I create a SalesOrder "AU05" for Customer "1" with Product "V1" and quantity "5"

# RE mit Lagerbewegung neu
Given I open an editor "RE02L" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
   | kunde  | 1     |
   | vom    | .     |
   | tterm  | .     |
   | fakt   | ja    |
   | ueb    | ja    |
   | such   | RE02L |
And I append rows
   | artikel  | mge    |
   | V2       | 11     |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# LS neu, AU anfuegen, RE mit Lagerbewegung anfuegen
Given I open an editor "LS05" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | kunde  | 1    |
   | vom    | .    |
   | tterm  | .    |
   | ueb    | ja   |
   | such   | LS07 |
And I set field "beleg" to "nummer" from editor "AU05"
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
# AU an RLS anfuegen-> Dieser Beleg darf nicht angefuegt werden
Then setting field "beleg" in row 0 to "id" from editor "AU05" in row 0 throws the exception "4615"
Then the table has 1 rows
And I close the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-025: RE ohne Lagerbewegung aus Auftrag darf nicht ueberberechnet werden
#----------------------------------------------------------------------------------------------

Scenario: RE ohne Lagerbewegung aus Auftrag darf nicht ueberberechnet werden
# Bei Rechnung ohne Lagerbewegung aus Auftrag darf die Rechnungsmenge
# nicht groesser sein als die Bestellmenge, bzw. die gelieferte Menge bei Ueberlieferungen,
# Ruecklieferungen, Storno-Vorgaenge und kaufmaennische Gutschriften sind zu beruecksichtigen
#
# AU13 -----> RE13 (abbruch)--> RE13 (abbruch)--> RLS13
# (10)     \  (10!)             (12!)             (10!)
#           \
#            -------LS13---------------> LSS13
#                   (12)                 (Storno)
#
# Auftrag anlegen
Given I create a SalesOrder "AU13" for Customer "1" with Product "V1" and quantity "10"

# Rechnung zum Auftrag (Versuch 1)
Given I open an editor "RE13" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU13"
# Im VK Default: Lagerbewegung Ja
Then field "fakt" has value "ja"
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

#LS zu Auftrag - ueberliefern
Given I open an editor "LS13" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU13"
And I set fields
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | nummer | 1LS13 |
   | such   | LS13  |
   | fakt   | nein  |
And I set field "mge" to "12" in row 1
And I save the current editor

# Rechnung zum Auftrag (Versuch 2)
Given I open an editor "RE13" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU13"
# Mit Lagerbewegung
Then field "fakt" has value "nein"
Then field "mge" has value "12" in row 1
And I set field "mge" to "10" in row 1
# Ueberberechnung soll scheitern - Rechnungsmenge zu hoch
Then setting field "mge" to "13" in row 1 throws the exception "2810"
# Negative Werte nicht erlaubt
Then setting field "mge" to "-1" in row 1 throws the exception "2158"
And I close the current editor

Given I open an editor "LSS13" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS13"
And I set field "bem" to "Storno Fehllieferung"
And I save the current editor

# Rechnung zum Auftrag (Versuch 3 Speichern)
Given I open an editor "RE13" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU13"
And I set fields
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | nummer | 1RE13 |
   | such   | RE13  |
# Mit Lagerbewegung
And I set field "fakt" to "nein"
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
Given I deliver the SalesOrder "AU13" with PackingSlip "LS13B"

# Alle Objekte muessen abgelegt sein
Then "(Sales):(Invoice)" with the editor id "RE13" is filed
Then "(Sales):(PackingSlip)" with the editor id "LS13" is filed
Then "(Sales):(PackingSlip)" with the editor id "LSS13" is filed
Then "(Sales):(SalesOrder)" with the editor id "AU13" is filed

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-026: Pruefung beim Speichern: RE ohne Lagerbewegung aus Auftrag darf nicht ueberberechnet werden
#----------------------------------------------------------------------------------------------

Scenario: Pruefung beim Speichern: RE ohne Lagerbewegung aus Auftrag darf nicht ueberberechnet werden
# Auftrag anlegen
Given I create a SalesOrder "AU11" for Customer "1" with Product "V1" and quantity "10"

# Rechnung zum Auftrag
Given I open an editor "RE11" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU11"
And I set fields
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
And I set field "tterm" to "."
# Rechnungsmenge noch zu hoch beim Speichern pruefen
Then field "mge" has value "11" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
Then saving the current editor throws the exception "2810"


#----------------------------------------------------------------------------------------------
# TSQ-RUECK-027: RLS beruecksichtigen: RE ohne Lagerbewegung aus Auftrag darf nicht ueberberechnet werden
#----------------------------------------------------------------------------------------------

Scenario: RLS beruecksichtigen: RE ohne Lagerbewegung aus Auftrag darf nicht ueberberechnet werden
#
# AU12 ---> ----------------> RE12 (abbr)---> RLS12 (abbr) -----> RE12
# (10)   \                    (16!)           (13!)               (13!)
#         \
#          -----LS12----> RLS12 (ungeb)
#               (16) \ \  (-2)
#                     \ \------------>RLS12B (geb)
#                      \              (-3)
#                       \----------------------> RLS12C --> RLSS12C (Storno)
#                                                (-4)

#
# Auftrag anlegen
Given I create a SalesOrder "AU12" for Customer "1" with Product "V1" and quantity "10"

#LS zu Auftrag - ueberliefern
Given I open an editor "LS12" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU12"
And I set fields
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | nummer | 1LS12 |
   | such   | LS12  |
   | fakt   | nein  |
And I set field "mge" to "16" in row 1
And I save the current editor

# Ruecklieferung ungebucht
Given I open an editor "RLS12" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS12"
And I set fields
   | vom    | .      |
   | tterm  | .      |
   | ueb    | nein   |
   | such   | RLS12  |
And I set field "mge" to "-2" in row 1
And I save the current editor

# Rechnung zum Auftrag (Versuch 1)
Given I open an editor "RE12" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU12"
# Im EK Default: Lagerbewegung nein
Then field "fakt" has value "nein"
Then field "mge" has value "16" in row 1
And I close the current editor

# Ruecklieferung gebucht
Given I open an editor "RLS12B" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS12"
And I set fields
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
   | such   | RLS12B  |
And I set field "mge" to "-3" in row 1
And I save the current editor

# Rechnung zum Auftrag (Versuch 2)
Given I open an editor "RE12" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU12"
# Im EK Default: Lagerbewegung nein
Then field "fakt" has value "nein"
Then field "mge" has value "16" in row 1
Then setting field "mge" to "17" in row 1 throws the exception "2810"
And I close the current editor

# 2. Ruecklieferung gebucht
Given I open an editor "RLS12C" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS12"
And I set fields
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
   | such   | RLS12C  |
And I set field "mge" to "-4" in row 1
And I save the current editor

# Storno RLS2C
Given I open an editor "RLSS12C" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "RLS12C"
And I save the current editor

# Rechnung zum Auftrag (Versuch 3)
Given I open an editor "RE12" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU12"
And I set fields
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | such   | RE12  |
Then field "fakt" has value "nein"
Then field "mge" has value "16" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-028: RE ohne Lagerbewegung aus Auftrag darf nicht ueberberechnet werden max. 0 vorschlagen
#----------------------------------------------------------------------------------------------

Scenario: RE ohne Lagerbewegung aus Auftrag darf nicht ueberberechnet werden
#
# AU14 -----> RE14
# (10)  \  \  (10)
#        \  \
#         \  -------LS14----> RLS14
#          \        (15)      (8)
#           \
#            ------------------------> RE14B
#                                      (!0)
#
# Auftrag anlegen
Given I create a SalesOrder "AU14" for Customer "1" with Product "V1" and quantity "10"

# Rechnung zum Auftrag
Given I open an editor "RE14" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU14"
And I set fields
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | nummer | 1RE14 |
   | such   | RE14  |
And I set field "fakt" to "nein"
And I set field "mge" to "10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#LS zu Auftrag - ueberliefern
Given I open an editor "LS14" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU14"
And I set fields
   | vom    | .     |
   | tterm  | .     |
   | ueb    | ja    |
   | nummer | 1LS14 |
   | such   | LS14  |
And I set field "mge" to "15" in row 1
And I save the current editor

Given I open an editor "RLS14" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS14"
And I set fields
   | vom    | .       |
   | tterm  | .       |
   | ueb    | nein    |
   | such   | RLS14   |
And I set field "mge" to "-8" in row 1
And I save the current editor

# Wertgutschrift nicht moeglich
Then opening an editor from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE14" throws the exception "6823"

# Ruecklieferschein buchen
Given I open an editor "RLS14B" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS14"
And I set fields
   | ueb  | ja |
And I save the current editor

# Wertgutschrift moeglich
Given I open an editor "WG14" from table "(Sales):(Invoice)" with command "INVOICE" for record from editor "RE14"
And I set fields
	| nummer | 1WG14      |
	| such   | WG14       |
	| ueb    | nein       |
	| tterm  | .          |
	| vom    | .          |
	| budat  | .          |
Then field "wertgutschrift" has value "ja"
Then field "twertgutschrift" has value "ja" in row 1
And I press button "offueb" in row 1
And I save the current editor

# Weitere Rechnung zum Auftrag - Vorschlag muss 0 sein
Given I open an editor "RE14B" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU14"
Then field "mge" has value "5" in row 1
And I close the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-029: RE aus Auftrag mit Ueberlieferung - Prozesskette abschliessen
#----------------------------------------------------------------------------------------------

Scenario: RE aus Auftrag mit Ueberlieferung abschliessen

#
# AU15 ---------------> RE15
# (10) \                (10)
#       \
#         ----------------------> RE15B -------> RE15BS
#         \                       (0*)           (Storno)
#          \                      AU abglegt!    AU lebendig!
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

# Auftrag anlegen
Given I create a SalesOrder "AU15" for Customer "1" with Product "V1" and quantity "10"

# Lieferschein mit Menge 15 erzeugen
Given I open an editor "LS15" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU15"
And I set fields
   | ueb    | ja    |
   | fakt   | nein  |
   | such   | AU15  |
And I set field "mge" to "15" in row 1
And I save the current editor

# Rechnung aus Auftrag erzeugen mit Menge 10
Given I open an editor "RE15" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU15"
And I set fields
   | ueb    | ja    |
   | vom    | .     |
   | tterm  | .     |
   | such   | RE15  |
And I set field "mge" to "10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# 0*-Rechnung aus Auftrag erzeugen
Given I open an editor "RE15B" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU15"
And I set fields
   | ueb    | ja    |
   | vom    | .     |
   | tterm  | .     |
   | such   | RE15B |
And I set field "mge" to "0" in row 1
And I respond with answer "Ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

# Pruefe, ob Vorgaenge abgelegt sind
Then "(Sales):(PackingSlip)" with the editor id "LS15" is filed
Then "(Sales):(Invoice)" with the editor id "RE15" is filed
Then "(Sales):(Invoice)" with the editor id "RE15B" is filed
Then "(Sales):(SalesOrder)" with the editor id "AU15" is filed

# 0* Rechnung stornieren -> Auftrag muss wieder aufgehen
Given I open an editor "RE15BS" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE15B"
And I set field "bem" to "Storno O-Rechnung"
And I save the current editor
Then "(Sales):(SalesOrder)" with the editor id "AU15" is not filed

Given I open an editor "AU15V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU15"
# Pruefe, ob die remge wieder korrekt restauriert wurde
Then field "remge" has value "5" in row 1
And I close the current editor

# Ruecklieferschein mit Menge -8 erzeugen und buchen
Given I open an editor "RLS15" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS15"
And I set fields
   | ueb    | ja    |
   | such   | RLS15 |
And I set field "mge" to "-8" in row 1
And I save the current editor

# KGS mit Menge -2 erzeugen und buchen
Given I open an editor "KGS15" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS15"
And I set fields
   | ueb    | ja    |
   | vom    | .     |
   | tterm  | .     |
   | such   | KGS15 |
# Nicht voll gutschreiben
And I set field "mge" to "-2" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# KGS mit Menge 0 erzeugen und buchen
Given I open an editor "KGS15B" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS15"
And I set fields
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
   | such   | KGS15B |
And I set field "mge" to "0" in row 1
# Wollen Sie wirklich stornieren?
And I respond with answer "Ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

# Storno 0* KGS
Given I open an editor "KGS15BS" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "KGS15B"
And I set field "bem" to "Storno 0-KGS"
And I save the current editor
Then "(Sales):(PackingSlip)" with the editor id "RLS15" is not filed

# KGS 0* erneut erzeugen und buchen
Given I open an editor "KGS15C" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "RLS15"
And I set fields
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
   | such   | KGS15C |
And I set field "mge" to "0" in row 1
# Wollen Sie wirklich stornieren?
And I respond with answer "Ja" to the dialog with id "191"
And I set field "status" to "*" in row 1
And I save the current editor

# Pruefe, ob alle Vorgaenge abgelegt sind
Then "(Sales):(Invoice)" with the editor id "KGS15C" is filed
Then "(Sales):(Invoice)" with the editor id "KGS15BS" is filed
Then "(Sales):(Invoice)" with the editor id "KGS15B" is filed
Then "(Sales):(Invoice)" with the editor id "KGS15" is filed
Then "(Sales):(PackingSlip)" with the editor id "RLS15" is filed
Then "(Sales):(PackingSlip)" with the editor id "LS15" is filed
Then "(Sales):(Invoice)" with the editor id "RE15" is filed
Then "(Sales):(SalesOrder)" with the editor id "AU15" is not filed

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-030: Rechnungsart Barzahlung bei Gutschriften
#----------------------------------------------------------------------------------------------

Scenario: Rechnungsart Barzahlung bei Gutschriften

Given I open an editor "1RE022G" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "1LS022R"
And I set field "nummer" to "1RE022G"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
Then field "vorganga" has value "Barzahlung"
And I set field "vorganga" to "Kaufmännische Gutschrift"
And I create a new row at the end of the table
And I set field "artikel" to "V2" in row !lastRow
And I set field "mge" to "10" in row !lastRow
And I set field "preis" to "20000" in row !lastRow
Then field "vorganga" has value "Barzahlung"
And I set field "vorganga" to "Rechnung"
And I delete row at position !lastRow
Then field "vorganga" has value "Barzahlung"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Then field "vorganga" from editor "1RE022G" in row 0 has value "Barzahlung"

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-031: Stornierung von Ueberbelieferungen
#----------------------------------------------------------------------------------------------

Scenario: Stornierung von Ueberbelieferungen

# Auftrag anlegen
Given I create a SalesOrder "AU19" for Customer "1" with Product "V1" and quantity "15"

# Lieferscheine erzeugen mit Ueberbelieferung
Given I open an editor "LS19-1" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU19"
And I set fields
   | ueb    | ja     |
   | such   | LS19-1 |
And I set field "mge" to "15" in row 1
And I save the current editor

Given I open an editor "LS19-2" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU19"
And I set fields
   | ueb    | ja     |
   | such   | LS19-2 |
And I set field "mge" to "15" in row 1
And I save the current editor

Given I open an editor "LS19-3" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU19"
And I set fields
   | ueb    | ja     |
   | such   | LS19-3 |
And I set field "mge" to "15" in row 1
And I save the current editor

# Lieferscheine stornieren und Menge der Reservierung pruefen
Given I open an editor "LS19-2S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS19-2"
And I save the current editor

Given I open an editor "LS19-1S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS19-1"
And I save the current editor

Given I open an editor "AU19" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU19"
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then field "limge" has value "15" in row 1
And I close the current editor
And I switch the current editor to editor "AU19"
And I close the current editor

Given I open an editor "LS19-3S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS19-3"
And I save the current editor

Given I open an editor "AU19" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU19"
And I press button "absteig" to open a subeditor for "AFL" in row 1
Then field "limge" has value "15" in row 1
And I close the current editor
And I switch the current editor to editor "AU19"
And I close the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-032: Stornierung einer Umlagerung mit Setartikel und Baugruppe
#----------------------------------------------------------------------------------------------

Scenario: Stornierung einer Umlagerung mit Setartikel und Baugruppe

Given I set the fake date to "25.04.1995"

Given I open an editor "1LS200U" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
   | nummer  | 1LS200U |
   | kunde   | 1       |
   | umplatz | F4      |
   | ueb     | ja      |
And I append rows
   | artikel | mge |
   | V1SET   | 10  |
And I save the current editor

Given I open an editor "1LS200U" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "1LS200U"
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-033: Stornierung nach Aenderung der Einplanung im Auftrag
#----------------------------------------------------------------------------------------------

Scenario: Stornierung nach Aenderung der Einplanung im Auftrag

# Auftrag
Given I open an editor "1AU033" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer | 1AU033 |
   | kunde  | 1      |
And I append rows
   | artikel | mge | preis | einplan |
   | E2      | 10  | 33    | nein    |
And I save the current editor

# Lieferung
Given I open an editor "1LS033" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU033"
And I set fields
    | nummer | 1LS033 |
    | fakt   | nein   |
    | ueb    | ja     |
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I delete row at position 1
And I append rows
    | lpsuch | zuomge |
    | F2     | 2      |
    | F2     | 3      |
    | F2     | 4      |
And I save the current editor
And I switch the current editor to editor "1LS033"
And I save the current editor

# Auftrag aendern
Given I open an editor "1AU033" from table "(Sales):(SalesOrder)" with command "UPDATE" for record from editor "1AU033"
Then I set field "einplan" to "ja" in row 1
And I save the current editor

# Storno Lieferschein
Given I open an editor "1LS033S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "1LS033"
Then I set field "nummer" to "1LS033S"
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-035: Ruecklieferung zu Lieferschein mit zusätzlicher Position bei Rechnung aus Auftrag
#----------------------------------------------------------------------------------------------

Scenario: Ruecklieferung zu Lieferschein mit zusätzlicher Position bei Rechnung aus Auftrag

# Auftrag anlegen
Given I create a SalesOrder "AU034" for Customer "1" with Product "V1" and quantity "10"

# Lieferschein erzeugen (Rechnung aus Auftrag)
# und zusaetzliche Position fuer Packmittel (nicht rechnungsrelevant) ergaenzen
Given I open an editor "LS034" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU034"
And I set fields
    | nummer | 1LS034 |
    | such   | LS034  |
    | fakt   | nein   |
    | ueb    | ja     |
And I set field "mge" to "10" in row 1
And I append rows
   | artikel  | mge   |
   | PALETTE  | 2     |
And I save the current editor

# Ruecklieferschein erzeugen und nicht buchen
Given I open an editor "RLS034" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS034"
And I set fields
   | such   | RLS034 |
And I set field "mge" to "-8" in row 1
And I set field "mge" to "-1" in row 2
And I save the current editor

# Ruecklieferschein aendern
Given I open an editor "RLS034U" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "RLS034"
Then field "such" has value "RLS034"
And I set field "mge" to "-5" in row 1
And I save the current editor

#------------------------------------------------------------------------------
# TSQ-RUECK-036: Ruecklieferung und Storno von Setartikel ohne Komponenten
#------------------------------------------------------------------------------

Scenario: Ruecklieferung von Setartikel ohne Komponenten (Lieferung ueber Lieferschein)

Given I open an editor "1AU034" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU034 |
   | kunde   | 1      |
And I append rows
   | artikel | mge |
   | V1SET   | 10  |
And I press button "absteig" to open a subeditor for "komponenten" in row 1
And I set field "elanzahl" to "0" in row 1
And I set field "elanzahl" to "0" in row 3
And I save the current editor
And I switch the current editor to editor "1AU034"
And I save the current editor

Given I open an editor "1LS034" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "1AU034"
And I set fields
    | nummer | 1LS034 |
    | ueb    | ja     |
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "1LS034R" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "1LS034"
And I set fields
   | nummer | 1LS034R |
   | vom    | .       |
   | tterm  | .       |
   | ueb    | ja      |
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "1LS034RS" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "1LS034R"
And I set fields
   | nummer | 1LS034RS |
And I save the current editor

Given I open an editor "1LS034S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "1LS034"
And I set fields
   | nummer | 1LS034S |
And I save the current editor

Scenario: Ruecklieferung von Setartikel ohne Komponenten (Lieferung ueber Rechnung mit Lagerbewegung)

Given I open an editor "1AU035" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | nummer  | 1AU035 |
   | kunde   | 1      |
And I append rows
   | artikel | mge |
   | V1SET   | 10  |
And I press button "absteig" to open a subeditor for "komponenten" in row 1
And I set field "elanzahl" to "0" in row 1
And I set field "elanzahl" to "0" in row 3
And I save the current editor
And I switch the current editor to editor "1AU035"
And I save the current editor

Given I open an editor "1RE035" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "1AU035"
And I set fields
    | nummer | 1RE035 |
    | fakt   | ja     |
    | ueb    | ja     |
    | term   | .      |
And I press button "offueb" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "1LS035R" from table "(Sales):(Invoice)" with command "RETURN" for record from editor "1RE035"
And I set fields
    | nummer | 1LS035R |
    | vom    | .       |
    | ueb    | ja      |
And I press button "offueb" in row 1
And I save the current editor

Given I open an editor "1LS035RS" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "1LS035R"
And I set fields
   | nummer | 1LS035RS |
And I save the current editor

Given I open an editor "1RE035S" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "1RE035"
And I set fields
   | nummer | 1LS035S |
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-037: Ruecklieferung zu Lieferschein bei ungebuchter Rechnung mit pwert 0
#----------------------------------------------------------------------------------------------

Scenario: Ruecklieferung zu Lieferschein bei ungebuchter Rechnung mit pwert 0

# Auftrag anlegen
Given I create a SalesOrder "AU036" for Customer "1" with Product "E1" and quantity "100"

# Lieferschein erzeugen
Given I open an editor "LS036" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU036"
And I set fields
    | nummer | 1LS036 |
    | such   | LS036  |
    | fakt   | ja     |
    | ueb    | ja     |
And I set field "mge" to "100" in row 1
And I save the current editor

# Rechnung zu Lieferschein anlegen, nicht buchen
Given I open an editor "RE036" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "LS036"
And I set fields
    | nummer | 1RE036 |
    | such   | RE036  |
    | ueb    | nein   |
    | term   | .      |
And I set field "mge" to "100" in row 1
And I set field "pwert" to "0" in row 1
And I save the current editor

# Ruecklieferschein erzeugen
Given I open an editor "RLS036" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS036"
And I set fields
    | nummer | 1RLS036 |
    | such   | RLS036  |
    | ueb    | ja      |
And I set field "mge" to "-100" in row 1
And I save the current editor

# Rechnung und Lieferschein sind noch lebendig
Then "(Sales):(Invoice)" with the editor id "RE036" is not filed
Then "(Sales):(PackingSlip)" with the editor id "RLS036" is filed
Then "(Sales):(PackingSlip)" with the editor id "LS036" is not filed
Then "(Sales):(SalesOrder)" with the editor id "AU036" is filed

# Rechnung buchen
Given I open an editor "RE036BU" from table "(Sales):(Invoice)" with command "UPDATE" for record from editor "RE036"
And I set field "mge" to "0" in row 1
Then I set field "ueb" to "ja"
And I save the current editor

# Lieferschein muss noch fakturierbar sein
Then "(Sales):(Invoice)" with the editor id "RE036" is filed
Then "(Sales):(PackingSlip)" with the editor id "LS036" is not filed

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-038: remge bei gesplitteten LS Positionen bei RE aus AU
#----------------------------------------------------------------------------------------------

Scenario: remge bei gesplitteten LS Positionen bei RE aus AU

# AU, SplitRE und SplitLS, RLS auf SplitLS, dann RE stornieren
#
#  AU037 ------------------> RE037 --------------------------------------> SRE037 (5!) Anfang der Katastrophe
#  150 St.   (1!)     \      100 St. split (2!)
#  | Aktion | remge    \      50 St. split (2!)
#  | (1)    | 150 St.   \    | Aktion | remge
#  | (2)    |   0 St.    \   | (2)    |   0 St. (Immer 0)
#  | (3)    |   0 St.     \
#  | (4)    |   0 St.      \
#                           ---------> LS037 speichern -----> RLS037
#                                            dann buchen
#                                       75 St. split (3!)      -75 St.   (4!)
#                                       75 St. split (3!)      -25 St.   (4!)
#                                      | Aktion | remge       | Aktion | remge
#                                      | (3)    |  0 St.      | (4)    | -75 St.
#                                      | (3)    |  0 St.      | (4)    | -25 St.
#                                                             | (5)    |   0 St.
#                                                             | (5)    |   0 St.
#
# AU
Given I open an editor "AU037" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | nummer | 1AU037 |
   | such   | AU037  |
   | vom    | .      |
   | tterm  | .      |
And I append rows
   | artikel | he     | mge |
   | V1      | Stueck | 150 |
And I save the current editor

Given I open an editor "AU037V" from table "(Sales):(SalesOrder)" with command "VIEW" for record from editor "AU037"
Then field "remge" has value "150" in row 1
And I close the current editor

# RE ohne LB mit Split
Given I open an editor "RE037" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU037"
And I set fields
   | nummer | 1RE037 |
   | such   | RE037  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
   | fakt   | nein   |
And I set field "mge" to "100" in row 1
And I set field "beleg" to id from editor "AU037"
And I set field "mge" to "50" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Then field "remge" from editor "RE037" in row 1 has value "-100"
Then field "remge" from editor "RE037" in row 2 has value "-50"

Then field "remge" from editor "AU037" in row 1 has value "0"

# LS mit Split, sofort buchen nicht moeglich
Given I open an editor "LS037" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU037"
And I set fields
   | nummer | 1LS037 |
   | such   | LS037  |
   | ueb    | ja     |
   | vom    | .      |
   | tterm  | .      |
And I set field "mge" to "75" in row 1
And I set field "beleg" to id from editor "AU037"
And I set field "mge" to "75" in row 2
#And I respond with answer "ja" to the dialog with id "4841"
Then saving the current editor throws the exception "6819"
And I set field "ueb" to "nein"
And I save the current editor

# LS buchen
Given I open an editor "LS037BU" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS037"
Then I set field "ueb" to "ja"
And I save the current editor

Then field "remge" from editor "RE037" in row 1 has value "-100"
Then field "remge" from editor "RE037" in row 2 has value "-50"

Then field "remge" from editor "AU037" in row 1 has value "0"
Then "(Sales):(SalesOrder)" with the editor id "AU037" is filed

# RLS zu gesplittetem LS
Given I open an editor "RLS037" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "LS037"
And I set fields
   | nummer | 1RLS037 |
   | such   | RLS037  |
   | ueb    | ja      |
And I set field "mge" to "-75" in row 1
And I set field "mge" to "-25" in row 2
And I set field "platz" to "F1" in row 1
And I set field "platz" to "F1" in row 2
And I save the current editor
Then field "remge" from editor "RLS037" in row 1 has value "-75"
Then field "remge" from editor "RLS037" in row 2 has value "-25"

Then field "remge" from editor "AU037" in row 1 has value "0"

# Storno der gesplitteten RE (Testfall zur Korrektur EVS-4509)
Given I open an editor "SRE037" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "RE037"
And I save the current editor

Then field "remge" from editor "AU037" in row 1 has value "150"
Then "(Sales):(SalesOrder)" with the editor id "AU037" is not filed

Then field "remge" from editor "RLS037" in row 1 has value "0"
Then field "remge" from editor "RLS037" in row 2 has value "0"

# AU, SplitRE und SplitLS, LS stornieren
#
#  AU040 ------------------> RE040
#  150 St.            \      100 St. split
#                      \      50 St. split
#                       \
#                         -----------> LS040  ---------------> LS040S
#                                       75 St.                 -75 St.
#                                       75 St.                 -25 St.

# BE
Given I open an editor "AU040" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
   | kunde  | 1      |
   | nummer | 1AU040 |
   | such   | AU040  |
And I append rows
   | artikel | he     | mge |
   | V1      | Stueck | 150 |
And I save the current editor

# RE ohne LB mit Split
Given I open an editor "RE040" from table "(Sales):(SalesOrder)" with command "INVOICE" for record from editor "AU040"
And I set fields
   | nummer | 1RE040 |
   | such   | RE040  |
   | ueb    | ja     |
   | tterm  | .      |
   | fakt   | nein   |
And I set field "mge" to "100" in row 1
And I set field "beleg" to id from editor "AU040"
And I set field "mge" to "50" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# LS mit Split, sofort buchen
Given I open an editor "LS040" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record from editor "AU040"
And I set fields
   | nummer | 1LS040 |
   | such   | LS040  |
   | ueb    | ja     |
And I set field "mge" to "75" in row 1
And I set field "beleg" to id from editor "AU040"
And I set field "mge" to "75" in row 2
Then saving the current editor throws the exception "6819"
And I set field "ueb" to "nein"
And I save the current editor

# LS buchen
Given I open an editor "LS040BU" from table "(Sales):(PackingSlip)" with command "UPDATE" for record from editor "LS040"
Then I set field "ueb" to "ja"
And I save the current editor

# Storno LS
Given I open an editor "LS040S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "LS040"
And I set fields
   | nummer | 1LS040S |
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-041: Ruecklieferung EDL Entnahmelieferschein
#----------------------------------------------------------------------------------------------

Scenario: Ruecklieferung EDL Entnahmelieferschein

Given I open an editor "Firma" from table "(Company):(Configuration)" with command "UPDATE" for record "KONFIG"
And I set field "edi" to "ja"
And I save the current editor

# Kundenkontakt
Given I open an editor "kkontakt1" from table "(Customer):(CustomerContact)" with command "STORE" for record "bayram"
And I set field "such" to "Bayram"
And I set field "firma" to id from editor "kunde"
And I save the current editor

Given I open an editor "kkontakt2" from table "(Customer):(CustomerContact)" with command "UPDATE" for record "bayram"
And I press button "edinfo" to open a subeditor for "edinachricht"
And I delete all rows
And I append rows
 | edinachraz   | erlaubt | protokoll | edlnum | umplatz |
 | Lieferschein | ja      | EDIFACT   | 002    | L3F2    |
And I save the current editor
And I switch the current editor to editor "kkontakt2"
And I save the current editor

# EDL-Lieferschein anlegen und buchen
Given I open an editor "lieferschein" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to id from editor "kkontakt1"
And I set field "such" to "LS041-1"
Then field "umplatz" is not empty
And field "edl" has value "002"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "10" in row 1
And I save the current editor

# Entnahmelieferschein erzeugen und buchen
Given I open an editor "entnahmels" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "lieferschein"
And I set field "such" to "LS041-2"
And I press button "edlls"
And I set field "ueb" to "ja"
Then field "edl" has value "002"
Then field "ursplsnr" is not empty
Then field "platz" has value "L3F2" in row 1
And I save the current editor

# Entnahmelieferschein rueckliefern
Given I open an editor "rueckls" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "entnahmels"
And I set field "such" to "RLS041"
Then field "umplatz" is empty
Then field "umplatz" is not modifiable
Then field "umlgruppe" is empty
Then field "umlgruppe" is not modifiable
Then field "platz" has value "L3F2" in row 1
Then field "platz" is modifiable in row 1
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I save the current editor

#----------------------------------------------------------------------------------------------
# TSQ-RUECK-042: Fremdeigenturmslagerplatz für Ruecklieferung erlauben
#----------------------------------------------------------------------------------------------

Scenario: Fremdeigenturmslagerplatz für Ruecklieferung erlauben

Given I open an editor "lieferschein042" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "betreff" to "Lieferschein042"
And I set field "zbed" to "200"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "10" in row 1
And I set field "platz" to "KONSILP" in row 1
And I save the current editor

# Ruecklieferschein aus Lieferschein auf Fremdeigentumslagerplatz erzeugen
Given I open an editor "ruecklief042" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein042"
And I set field "ueb" to "ja"
And I set field "mge" to "-10" in row 1
Then setting field "platz" to "F1" in row 1 throws the exception "4329"
And I set field "platz" to "KONSILP" in row 1
And I save the current editor


#----------------------------------------------------------------------------------------------
# TSQ-RUECK-043: Teilrücklieferung auf Fremdeigentumslagerplatz
#----------------------------------------------------------------------------------------------

Scenario: Teilrücklieferung auf Fremdeigentumslagerplatz

Given I open an editor "lieferschein043" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "betreff" to "Lieferschein043"
And I set field "zbed" to "200"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "V1" in row 1
And I set field "mge" to "5" in row 1
And I set field "preis" to "20" in row 1
And I set field "platz" to "KONSILP" in row 1
And I save the current editor

# Ruecklieferschein aus Lieferschein auf Fremdeigentumslagerplatz erzeugen
Given I open an editor "ruecklief043" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein043"
And I set field "ueb" to "ja"
And I set field "mge" to "-2" in row 1
And I set field "preis" to "20" in row 1
Then setting field "platz" to "F1" in row 1 throws the exception "4329"
And I set field "platz" to "KONSILP" in row 1
And I save the current editor


#----------------------------------------------------------------------------------------------
Scenario: Auftrag mit MZ, LS aus Auftrag: Lagerplatz (und Lagergruppe) im AU bzw. LS aendern
#----------------------------------------------------------------------------------------------

# Auftrag mit MZ anlegen, die nicht eingeplant aber aktiv sind
Given I open an editor "1AU044" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "nummer" to "1AU044"
And I set field "kunde" to "1"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "10" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then field "einplan" has value "nein" in row 1
And I set field "lpsuch" to "F1" in row 1
And I save the current editor
And I switch the current editor to editor "1AU044"
And I save the current editor

# Lieferschein aus AU erzeugen
Given I open an editor "1AU044" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "1AU044"
And I set field "nummer" to "1LS044"
And I set field "fakt" to "ja"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "ueb" to "nein"
And I set field "mge" to "10" in row 1
And I press button "mzsubm" to open a subeditor for "mz" in row 1
And I save the current editor
And I switch the current editor to editor "1AU044"
And I save the current editor

# Lagerplatz im Auftrag aendern, MZ vorhanden -> Aenderung annehmen
Given I open an editor "1AU044U2" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "1AU044"
And I respond with answer "Ja" to the dialog with id "Die aktuelle Materialzuordnung wird durch Ändern der Lagergruppe gelöscht. Lagerplatz trotzdem ändern?"
And I set field "platz" to "L2F2" in row 1
And I save the current editor
Then field "platz" from editor "1AU044U2" in row 1 has value "L2F2"
Then field "zuoda" from editor "1AU044U2" in row 1 has value "nein"

# Lagerplatz(/-gruppe) im Lieferschein darf geaendert werden
Given I open an editor "1LS044U" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "1LS044"
And I set field "ueb" to "Ja"
And I set field "platz" to "L2F2" in row 1
And I save the current editor


#----------------------------------------------------------------------------------------------
Scenario: Auftrag ohne MZ, Lagerplatz-/gruppe duerfen ohne Nachfrage geaendert werden.
#----------------------------------------------------------------------------------------------

# Auftrag ohne MZ anlegen
Given I open an editor "1AU045" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "nummer" to "1AU045"
And I set field "kunde" to "2"
And I create a new row at the end of the table
And I set field "artikel" to "V1" in row 1
And I set field "mge" to "10" in row 1
Then I set field "einplan" to "ja" in row 1
And I save the current editor

# Lagerplatz im Auftrag aendern, keine MZ vorhanden, Lagerplatz/-gruppe Aenderung erlaubt
Given I open an editor "1AU045U" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "1AU045"
And I set field "platz" to "L2F2" in row 1
And I save the current editor
