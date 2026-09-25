@persistent
Feature: gueltigkeitszeitraum_rahmen_edi_lab.feature

Background:
And I set the fake date to "07.01.1995"

# **********************************************************************************
#  Name             : gueltigkeitszeitraum_rahmen_edi_lab.feature
#  Autor            : bschiga
#  Verantwortlich   : teampss
#  Funktion         : Testet Lieferabrufe fuer Rahmenauftrag mit Gueltigkeitsbereich
#
# **********************************************************************************

#### Vorgaenger ref_edidaten verwenden, legt Stammdaten an

Scenario: 0 Vorbereitung - Rahmenauftrag anlegen
Given I open an editor "RAH_GUELT" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
    | kunde    | EDISB-13  |
    | such     | RAH_GUELT |
    | abschlnr | RA01GUELT |
    | verwschl | S         |
And I append rows
    | artikel  | mge  | zgltvon  | zgltbis  |
    | EDIART-5 | 1000 | 01.02.95 | 31.03.95 |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario Outline: Pruefung auf Gueltigkeit der Rahmenauftragsposition
# ----------------------------------------------------------------------------------------------
## Testfaelle:
# 01. Rahmen ist aktuell nicht gueltig
#     a. Abruftermine liegen vor der Gueltigkeit -> Abruf wird nicht verarbeitet, Fehlerstatus, Fehlermeldung
#     b. Abruftermine liegen nach der Gueltigkeit -> Abruf wird nicht verarbeitet, Fehlerstatus, Fehlermeldung
#     c. Abruftermine liegen tlw. innerhalb und tlw. nach der Gueltigkeit -> Abruf wird nicht verarbeitet, Fehlerstatus, Fehlermeldung
#     d. Abruftermine liegen alle innerhalb der Gueltigkeit -> Abruf wird verarbeitet

# 02. Rahmen ist aktuell gueltig
#     a. Abruftermine liegen vor der Gueltigkeit -> Abruf wird nicht verarbeitet, Fehlerstatus, Fehlermeldung
#     b. Abruftermine liegen nach der Gueltigkeit -> Abruf wird nicht verarbeitet, Fehlerstatus, Fehlermeldung
#     c. Abruftermine liegen tlw. innerhalb und tlw. nach der Gueltigkeit -> Abruf wird nicht verarbeitet, Fehlerstatus, Fehlermeldung
#     d. Abruftermine liegen alle innerhalb der Gueltigkeit -> Abruf wird verarbeitet

# 03. Rahmen ist aktuell gueltig, nur bis-Datum gefuellt
#     a. Abruftermine liegen nach der Gueltigkeit -> Abruf wird nicht verarbeitet, Fehlerstatus, Fehlermeldung
#     b. Abruftermine liegen tlw. innerhalb und tlw. nach der Gueltigkeit -> Abruf wird nicht verarbeitet, Fehlerstatus, Fehlermeldung
#     c. Abruftermine liegen alle innerhalb der Gueltigkeit -> Abruf wird verarbeitet

# 04. Rahmen ist aktuell gueltig, nur von-Datum gefuellt
#     a. Abruftermine liegen vor der Gueltigkeit -> Abruf wird nicht verarbeitet, Fehlerstatus, Fehlermeldung
#     b. Abruftermine liegen tlw. innerhalb und tlw. vor der Gueltigkeit -> Abruf wird nicht verarbeitet, Fehlerstatus, Fehlermeldung
#     c. Abruftermine liegen alle innerhalb der Gueltigkeit -> Abruf wird verarbeitet

And I set the fake date to "<FakeDate>"

Given I open an editor "RAH_GUELT" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RAH_GUELT"
And I set field "zgltvon" to "<zgltvon>" in row 1
And I set field "zgltbis" to "<zgltbis>" in row 1
And I save the current editor

Given I open the infosystem "ERFLIE"
And I set fields
    | rahmen   | RAH_GUELT |
    | einfzahl | 0         |
    | zekunde  | SB-13     |
    | labruf   | <Abruf>   |
    | labrufd  | .         |
And I delete all rows
And I append rows
    | termint   | menge |
    | <Termin1> | 400   |
    | <Termin2> | 300   |
    | <Termin3> | 300   |
And I press button "daterz"
And I close the current editor

Given I import EDI data for forecast delivery schedule

Given I process EDI message for forecast delivery schedule

# EDI-Nachricht pruefen, wurde nicht verarbeitet und kein Auftrag angelegt
Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "VIEW" for search criteria "$,,labnr=<Abruf>;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | status | <status>  |
    | fcode  | <fcode> |
## neuer Fehlercode und neue Fehlermeldung ergaenzen
# ToDo: Then field "ftext" has value "Abrufdatum liegt außerhalb des Gültigkeitszeitraums der Rahmenauftragsposition."
And I close the current editor

Examples:
 | Test | Index | FakeDate | Abruf          | zgltvon  | zgltbis  | Termin1  | Termin2  | Termin3  | status | fcode |
 | 01a  |  0     | 07.01.95 | LAB_NGUELT_1A | 01.02.95 | 31.03.95 | +5       | +10      | +15      | 4      | 63    |
 | 01b  |  1     | 07.01.95 | LAB_NGUELT_1B | 01.02.95 | 31.03.95 | +100     | +110     | +120     | 4      | 63    |
 | 01c  |  2     | 07.01.95 | LAB_NGUELT_1C | 01.02.95 | 31.03.95 | +400     | +45      | +100     | 4      | 63    |
 | 01d  |  3     | 07.01.95 | LAB_NGUELT_1D | 01.02.95 | 31.03.95 | +40      | +45      | +50      | 0      | 0     |
 | 02a  |  3     | 08.02.95 | LAB_NGUELT_2A | 01.02.95 | 31.03.95 | 15.01.95 | 20.01.95 | 25.01.95 | 4      | 63    |
 | 02b  |  4     | 08.02.95 | LAB_NGUELT_2B | 01.02.95 | 31.03.95 | +100     | +110     | +120     | 4      | 63    |
 | 02c  |  5     | 08.02.95 | LAB_NGUELT_2C | 01.02.95 | 31.03.95 | +10      | +20      | +100     | 4      | 63    |
 | 02d  |  6     | 08.02.95 | LAB_NGUELT_2D | 01.02.95 | 31.03.95 | +5       | +10      | +15      | 0      | 0     |
 | 03a  |  7     | 08.02.95 | LAB_NGUELT_3A |          | 31.03.95 | +100     | +110     | +120     | 4      | 63    |
 | 03b  |  8     | 08.02.95 | LAB_NGUELT_3B |          | 31.03.95 | +10      | +20      | +100     | 4      | 63    |
 | 03c  |  9     | 08.02.95 | LAB_NGUELT_3C |          | 31.03.95 | +5       | +10      | +15      | 0      | 0     |
 | 04a  | 10     | 08.02.95 | LAB_NGUELT_4A | 01.02.95 |          | -15      | -12      | -10      | 4      | 63    |
 | 04b  | 11     | 08.02.95 | LAB_NGUELT_4B | 01.02.95 |          | -15      | +10      | +20      | 4      | 63    |
 | 04c  | 12     | 08.02.95 | LAB_NGUELT_4C | 01.02.95 |          | +5       | +10      | +15      | 0      | 0     |
