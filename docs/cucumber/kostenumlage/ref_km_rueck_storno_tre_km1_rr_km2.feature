# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      :
# *****************************************************************************
@persistent
Feature: BW2-1520 Kostenumlage auf Teilrechnungen rückführen

Background:
Given I set the fake date to "08.01.2002"

# ---------------------------------------------------------------------------------------------
Scenario: schaffen einer weiterverwendbaren schematischen bewegungsdatenbasis
# ------------------------------------------------------------------------
#
# die anzahl zuordnungen/zeile ergibt die anzahl tabellenzeilen
# in der km
#
# die anzahl zuordnungen/spalte ergibt die mehrfachbelegung von
# zugängen mit km
#
# nicht vorhandene zuordnung bedeutet: derzeit keine verwendung von
# zeilen oder spalten
#
# HINWEIS:
# DIESE TABELLE WURDE VOLLSTÄNDIG AUS DEM EIGENTLICHEN BASISTEST KOPIERT.
# HIER IN DIESEM TEST WERDEN ABER NUR WENIGE IN DER TABELLE AUFGEFÜHRTEN
# KOSTENUMLAGEN VERWENDET.
#
# ----------------|------------------------------------------------------
#                 | Zielposition auf die die kostenquelle umgelegt wird:
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
#                 | 11| 15| 2 | 3 | 4 | 5 | 6 | 7 | 8 |
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kostenquelle:   |   |   |   |   |   |   |   |   |   |
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_11   |100|   |   |   |   |   |   |100|   |
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_15   |   |150|   |   |   |   |   |   |   |
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_2_12 |   |   |   |200|   |   |   |   |   |
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_3    |400|   |400|   |400|400|   |   |   |           400 = U4-4ZEI
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_4    |   |   |300|300|   |   |   |   |   |           300 = U3-2ZEI
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_5_12 |   |   |500|500|   |   |500|   |   |           500 = U5-3ZEI-12
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
# kost_qu_ek_6    |   |   |   |   |   |   |   |   |600|           600 = U6-NEG (-)
# ----------------|---|---|---|---|---|---|---|---|---|----------------------
#
# in KM 200: identische guv konten und kostenobjekte, damit ohne umbuchung
#                                                           ~~~~~~~~~~~~~~
#            in der km und der rückführung erlaubt!
#
# in KM 500: identische guv konto und kostenobjekt mit zielpos3,
#            deshalb nur teilweise umbuchung in der km und der rückführung!
#                        ~~~~~~~~~~~~~~~~~~~
# ---------------------------------------------------------------------------------------------
Given I'm logged in with password "sy"
Given I set the fake date to "10.01.2002"

Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "E1EI-VO"
And I set field "gemein" to ""
And I save the current editor

Given I open an editor "artikel" from table "(Part):(Product)" with command "UPDATE" for record "E1LO-VO"
And I set field "gemein" to ""
And I save the current editor

# Zusatzposition Transport
Given I open an editor "zusatzp_transport" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set field "nummer" to "1transp"
And I set field "such" to "transport"
And I set field "name" to "transportkosten"
And I save the current editor

# Rechnung für add. kosten anlegen
Given I open an editor "re-addkosten1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "134-add"
And I set field "lief" to "1"
And I set field "erfwaehr" to "gbp"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I append rows
 |artex     | pwert| konto | kstelle | ptext         |
 |transport |     6| 50011 |     111 | kost_qu_ek_11 |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Rechnung für add. kosten anlegen
Given I open an editor "re-addkosten2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "135-add"
And I set field "lief" to "1"
And I set field "erfwaehr" to "eur"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I append rows
 |artex     | pwert| konto | kstelle | ptext          |
 |transport |    10| 50011 |     111 | kost_qu_ek_15  |
 |transport |    20| 50012 |     112 | kost_qu_ek_2_12|
 |transport |    30| 50013 |     113 | kost_qu_ek_3   |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung für add. kosten anlegen
Given I open an editor "re-addkosten3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "136-add"
And I set field "lief" to "1"
And I set field "erfwaehr" to "eur"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I append rows
 |artex     | pwert| konto | kstelle | ptext          |
 |transport |    40| 50014 |     114 | kost_qu_ek_4   |
 |transport |    50| 50012 |     112 | kost_qu_ek_5_12|
 |transport |   -32| 50016 |     113 | kost_qu_ek_6   |

# 16er-hinweis:
# diese -32 landen mit dem guv-konto letztlich im haben
# deshalb auch unten in der entspr. fibu-zeile die 32 im haben
# und die kstelle darf nicht 116 sein, weil sonst quell- u.
# ziel-kstelle identisch werden wodurch keine umbuchung gemacht wird.

And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "ls_01" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 11-15-2l|
    | vom      | .      |
    | ueb      | ja     |
#    | fakt     | ja     |
    | ebeleg   | MATLS1 |
And I append rows

# mit-mkv #    | artikel     | mge | preis | tterm	| ptext    | platz     |
# mit-mkv #    | E1EI-VO     | 10  | 10,00 | +4	| kmzpos11 |!dontChange|
# mit-mkv #    | E1EI-VO     | 15  | 15,00 | +4	| kmzpos15 |!dontChange|
# mit-mkv #    | E1EI-VO     | 20  | 20,00 | +4	| kmzpos2  |  L3F1     |
And I save the current editor


Given I open an editor "Re_01" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "11-15-2l"
And I set fields
    | num4     | 11152r1|
    | vom      | .      |
    | ueb      | ja     |
    | ebeleg   | MATRE1 |
    | budat    | .      |
And I set field "mge" to "4" in row 1
And I set field "mge" to "12" in row 2
And I set field "mge" to "18" in row 3
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ------------------------------------------------------------------------
Scenario: Kostenumlage 1 erzeugen
# ------------------------------------------------------------------------

Given I set the fake date to "12.01.2002"

# Kostenumlagen erzeugen
# mit-km1-nach-teilrechnung #Given I open an editor "kostenuml-15" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
# mit-km1-nach-teilrechnung #And I set field "num135" to "150a"
# mit-km1-nach-teilrechnung #And I set field "such" to "U15-1ZEIA"
# mit-km1-nach-teilrechnung #And I set field "pos" to "$,,ptext==kost_qu_ek_3;art==transport;@ablageart=(Filed)"
# mit-km1-nach-teilrechnung ## mit-mkv #And I set field "fibuumbuch" to "ja"
# mit-km1-nach-teilrechnung ## ohne-mkv #And I set field "fibuumbuch" to "nein"
# mit-km1-nach-teilrechnung #And I set field "umlagemeth" to "Wert"
# mit-km1-nach-teilrechnung #And I create a new row at the end of the table
# mit-km1-nach-teilrechnung #And I set field "pos" to "$,,ptext==kmzpos15;mge==12;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
# mit-km1-nach-teilrechnung #And I save the current editor

# mit-km1-nach-teilrechnung #Given I open an editor "kostenuml-11" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
# mit-km1-nach-teilrechnung #And I set field "num135" to "110"
# mit-km1-nach-teilrechnung #And I set field "such" to "U11-2ZEI"
# mit-km1-nach-teilrechnung #And I set field "pos" to "$,,ptext==kost_qu_ek_11;art==transport;@ablageart=(Filed)"
# mit-km1-nach-teilrechnung #And I set field "fibuumbuch" to "ja"
# mit-km1-nach-teilrechnung #And I set field "umlagemeth" to "Wert"
# mit-km1-nach-teilrechnung #And I create a new row at the end of the table
# mit-km1-nach-teilrechnung #And I set field "pos" to "$,,ptext==kmzpos11;mge==4;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
# mit-km1-nach-teilrechnung #And I create a new row at the end of the table
# mit-km1-nach-teilrechnung #And I set field "pos" to "$,,ptext==kmzpos2;mge==18;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
# mit-km1-nach-teilrechnung #And I save the current editor


# ------------------------------------------------------------------------
Scenario: restrechnung erzeugen
# ------------------------------------------------------------------------

Given I set the fake date to "14.01.2002"

Given I open an editor "Re_03" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "11-15-2l"
And I set fields
    | num4     | 11152r3|
    | vom      | .      |
    | ueb      | ja     |
    | ebeleg   | MATRE3 |
    | budat    | .      |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ------------------------------------------------------------------------
Scenario: Kostenumlage 2 erzeugen
# ------------------------------------------------------------------------

Given I set the fake date to "16.01.2002"

# mit-km2-nach-restrechnung #Given I open an editor "kostenuml-11" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
# mit-km2-nach-restrechnung #And I set field "num135" to "110b"
# mit-km2-nach-restrechnung #And I set field "such" to "U11-2ZEIB"
# mit-km2-nach-restrechnung #And I set field "pos" to "$,,ptext==kost_qu_ek_4;art==transport;@ablageart=(Filed)"
# mit-km2-nach-restrechnung #And I set field "fibuumbuch" to "ja"
# mit-km2-nach-restrechnung #And I set field "umlagemeth" to "Wert"
# mit-km2-nach-restrechnung #And I create a new row at the end of the table
# mit-km2-nach-restrechnung #And I set field "pos" to "$,,ptext==kmzpos11;mge==6;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
# mit-km2-nach-restrechnung #And I create a new row at the end of the table
# mit-km2-nach-restrechnung #And I set field "pos" to "$,,ptext==kmzpos2;mge==2;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
# mit-km2-nach-restrechnung #Then field "budat" has value "14.01.02"
# mit-km2-nach-restrechnung #And I set field "budat" to "."
# mit-km2-nach-restrechnung #And I save the current editor

# Kostenumlagen erzeugen
# mit-km2-nach-restrechnung #Given I open an editor "kostenuml-15" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
# mit-km2-nach-restrechnung #And I set field "num135" to "150"
# mit-km2-nach-restrechnung #And I set field "such" to "U15-1ZEI"
# mit-km2-nach-restrechnung #And I set field "pos" to "$,,ptext==kost_qu_ek_15;art==transport;@ablageart=(Filed)"
# mit-km2-nach-restrechnung ## mit-mkv #And I set field "fibuumbuch" to "ja"
# mit-km2-nach-restrechnung ## ohne-mkv #And I set field "fibuumbuch" to "nein"
# mit-km2-nach-restrechnung #And I set field "umlagemeth" to "Wert"
# mit-km2-nach-restrechnung #And I create a new row at the end of the table
# mit-km2-nach-restrechnung #And I set field "pos" to "$,,ptext==kmzpos15;mge==3;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
# mit-km2-nach-restrechnung #And I save the current editor


# ------------------------------------------------------------------------
Scenario: Kostenumlagerueckfuehrungen und stornos
# ------------------------------------------------------------------------
Given I set the fake date to "18.01.2002"

# mit-km1-nach-teilrechnung #Given I open an editor "kostenumlrueck-15" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
# mit-km1-nach-teilrechnung #And I set field "num135" to "150ru"
# mit-km1-nach-teilrechnung #And I set field "origvorg" to "+U15-1ZEIA"
# mit-km1-nach-teilrechnung #And I set field "such" to "RF-U15"
# mit-km1-nach-teilrechnung #And I save the current editor

# mit-km2-nach-restrechnung #Given I open an editor "kostenumlrueck-15-2" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
# mit-km2-nach-restrechnung #And I set field "num135" to "150ru2"
# mit-km2-nach-restrechnung #And I set field "origvorg" to "+U15-1ZEI"
# mit-km2-nach-restrechnung #And I set field "such" to "RF-U15-2"
# mit-km2-nach-restrechnung #And I save the current editor


# mit-km1-nach-teilrechnung #Given I open an editor "sto-kostenumlrueck-150" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+RF-U15"
# mit-km1-nach-teilrechnung #And I set field "num135" to "150rus"
# mit-km1-nach-teilrechnung #And I set field "such" to "SRF-U15"
# mit-km1-nach-teilrechnung #And I save the current editor

# mit-km2-nach-restrechnung #Given I open an editor "sto-kostenumlrueck-15-2" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+RF-U15-2"
# mit-km2-nach-restrechnung #And I set field "num135" to "150ru2s"
# mit-km2-nach-restrechnung #And I set field "such" to "SRF-U15-2"
# mit-km2-nach-restrechnung #And I save the current editor


# mit-km2-nach-restrechnung #Given I open an editor "sto-kostenuml-15" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+U15-1ZEI"
# mit-km2-nach-restrechnung #And I set field "num135" to "150s"
# mit-km2-nach-restrechnung #And I set field "such" to "S150"
# mit-km2-nach-restrechnung ## And I wait for file cucudbg for debugging
# mit-km2-nach-restrechnung #And I save the current editor

# mit-km1-nach-teilrechnung #Given I open an editor "sto-kostenuml-15a" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+U15-1ZEIA"
# mit-km1-nach-teilrechnung #And I set field "num135" to "150as"
# mit-km1-nach-teilrechnung #And I set field "such" to "S150a"
# mit-km1-nach-teilrechnung #And I save the current editor

# ***************************************************
# zweizeilige kostenumlage rückführen und stornieren
# ***************************************************

# mit-km1-nach-teilrechnung #Given I open an editor "kostenumlrueck-11" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
# mit-km1-nach-teilrechnung #And I set field "num135" to "111"
# mit-km1-nach-teilrechnung #And I set field "name" to "KMRF"
# mit-km1-nach-teilrechnung #And I set field "origvorg" to "+U11-2ZEI"
# mit-km1-nach-teilrechnung #And I set field "such" to "RF-U11"
# mit-km1-nach-teilrechnung #And I save the current editor

# mit-km2-nach-restrechnung #Given I open an editor "kostenumlrueck-11b" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
# mit-km2-nach-restrechnung #And I set field "num135" to "111b"
# mit-km2-nach-restrechnung #And I set field "name" to "KMRF"
# mit-km2-nach-restrechnung #And I set field "origvorg" to "+U11-2ZEIB"
# mit-km2-nach-restrechnung #And I set field "such" to "RF-U11-B"
# mit-km2-nach-restrechnung #And I save the current editor

# mit-km1-nach-teilrechnung #Given I open an editor "sto-kostenumlrueck-11" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+RF-U11"
# mit-km1-nach-teilrechnung #And I set field "num135" to "111s"
# mit-km1-nach-teilrechnung #And I set field "such" to "SRF-U11"
# mit-km1-nach-teilrechnung #And I save the current editor

# mit-km2-nach-restrechnung #Given I open an editor "sto-kostenumlrueck-11b" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+RF-U11-B"
# mit-km2-nach-restrechnung #And I set field "num135" to "111bs"
# mit-km2-nach-restrechnung #And I set field "such" to "SRF-U11-B"
# mit-km2-nach-restrechnung #And I save the current editor

# mit-km1-nach-teilrechnung #Given I open an editor "sto-kostenuml-110" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+U11-2ZEI"
# mit-km1-nach-teilrechnung #And I set field "num135" to "110s"
# mit-km1-nach-teilrechnung #And I set field "such" to "SKMU11"
# mit-km1-nach-teilrechnung #And I save the current editor

# mit-km2-nach-restrechnung #Given I open an editor "sto-kostenuml-110" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+U11-2ZEIB"
# mit-km2-nach-restrechnung #And I set field "num135" to "110bs"
# mit-km2-nach-restrechnung #And I set field "such" to "SKMU11-B"
# mit-km2-nach-restrechnung #And I save the current editor


# -----------------------------------------------------------------
Scenario: nachbewerten
# -----------------------------------------------------------------
Given I set the fake date to "20.01.2002"

Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
