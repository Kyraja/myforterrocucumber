@persistent
Feature: maxrahmenmenge_edi_fab.feature

Background:
And I set the fake date to "07.01.1995"


# **********************************************************************************
#  Name             : maxrahmenmenge_edi_fab.feature
#  Autor            : bschiga
#  Verantwortlich   : teampss
#  Funktion         : Testet Feinabrufe fuer Rahmenauftrag mit maximaler Menge
#
# **********************************************************************************

# ----------------------------------------------------------------------------------------------
Scenario: 0 Vorbereitung - Kundenkontakt pflegen und Rahmenauftrag anlegen
# ----------------------------------------------------------------------------------------------
# Das Abbildungsmodell beim Kunden muss manchmal auskommentiert werden, da  Probleme beim Bau mit STORE
# im Kundenkontakt die EDI-Nachricht "Feinabruf" hinterlegen
Given I open an editor "EDISB-13" from table "(Customer):(CustomerContact)" with command "UPDATE" for record "EDISB-13"
And I press button "edinfo" to open a subeditor for "EDI-Nachricht"
#And I create a new row at the end of the table
And I modify table
    | !row  | edinachraz | ieabmodell | abmodell | erlaubt | protokoll |
    | +1    | Feinabruf  | 4020       | 4021     | ja      | VDA       |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# neuen Rahmenauftrag anlegen
Given I open an editor "RAH_EDI22" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
    | kunde       | EDISB-13   |
    | such        | RAH_EDI22  |
    | abschlnr    | RA22MAXMGE |
    | verwschl    | S          |
And I append rows
    | artikel     | mge  | maxabrufmge  |
    | EDIART-4    | 1000 | 1000         |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario: 01 Lieferabruf verarbeiten, maximale Rahmenmenge eingehalten
# ----------------------------------------------------------------------------------------------
Given I open the infosystem "ERFLIE"
And I set fields
    | rahmen    | RAH_EDI22      |
    | einfzahl  | 0              |
    | zekunde   | SB-13          |
    | labruf    | LAB_EDI02_01   |
    | labrufd   | .              |
And I delete all rows
And I append rows
    | termint   | menge  |
    | +5        | 200    |
    | +10       | 300    |
    | +15       | 300    |
    | +20       | 200    |
And I press button "daterz"
And I close the current editor

Given I open the infosystem "EDIIMPORT"
And I set field "abm" to "4010"
And I press start
And I set field "tmark" to "ja" in row 1
And I press button "tbuimport" in row 1
And I close the current editor

Given I open the infosystem "EDIIMPVER"
And I set field "kbabrufe" to "ja"
And I set field "kballekunden" to "nein"
And I press start
And I create a new row at position 1
And I set field "tkunde" to "EDISB-13" in row 1
And I press button "tbuverarb" in row 1
And I close the current editor

Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "VIEW" for search criteria "$,,labnr=LAB_EDI02_01;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | status    | 0    |
    | fcode     | 0    |
Then field "ftext" is empty
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: 02 Feinabruf verarbeiten, maximale Rahmenmenge ueberschritten, LFZ vorhanden
# ----------------------------------------------------------------------------------------------
#Feinabruf und restliche LAB-Mengen ueberschreiten maximale Rahmenmenge, Fehlermeldung testen

# Auftrag liefern
Given I open an editor "Liefer" from table "(Sales):(SalesOrder)" with command "DELIVERY" for search criteria "$,,such=BEDISB-13;lztabnr=LAB_EDI02_01;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
And I set fields
    | such    | EDILS01 |
    | vom     |  .      |
    | ueb     | ja      |
And I set field "mge" to "50" in row 1
And I set field "dfuesenden" to "nein"
And I save the current editor

# Auftrag liefern
Given I open an editor "Liefer" from table "(Sales):(SalesOrder)" with command "DELIVERY" for search criteria "$,,such=BEDISB-13;lztabnr=LAB_EDI02_01;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
And I set fields
    | such    | EDILS02 |
    | vom     |  .      |
    | ueb     | ja      | 
And I set field "mge" to "50" in row 1
And I set field "dfuesenden" to "nein"
And I save the current editor

# neuer Abruf, LFZ ist 100, EFZ ist 50, Abrufmenge + EFZ überschreitet maximale Rahmenmenge
Given I open the infosystem "ERFLIE"
And I set fields
    | rahmen    | RAH_EDI22   |
    | kbfab     | ja          |
    | einfzahl  | 50          |
    | zekunde   | SB-13       |
    | labruf    | FAB_EDI02_01|
    | labrufd   | .           |
And I delete all rows
And I append rows
    | termint   | menge |
    | +5        | 90    |
    | +6        | 90    |
And I press button "daterz"
And I close the current editor

Given I open the infosystem "EDIIMPORT"
And I set field "abm" to "4020"
And I press start
And I set field "tmark" to "ja" in row 1
And I press button "tbuimport" in row 1
And I close the current editor

Given I open the infosystem "EDIIMPVER"
And I set field "kbabrufe" to "ja"
And I set field "kballekunden" to "nein"
And I press start
And I create a new row at position 1
And I set field "tkunde" to "EDISB-13" in row 1
And I press button "tbuverarb" in row 1
And I close the current editor

Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "VIEW" for search criteria "$,,labnr=FAB_EDI02_01;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
Then field "ideksvor" is empty
Then fields have values
    | status  | 4     |
    | fcode   | 63    |
# ToDo: Pruefung auf den mehrzeiligen Fehlertext geht momentan noch nicht
#Then field "ftext" has value
#"""In Zeile xx wurde die maximale Rahmenmenge yy in Rahmenauftrag ZZZ um iii ueberschritten.
#Abrufmenge zu hoch.
#Auftrag kann nicht angelegt werden""
And I close the current editor

#############################################################################################################################
# Menge im Feinabruf ist hoeher als im LAB fuer gleichen Zeitraum, insgesamt passen EFZ + FAB-Mengen + restlichen LAB-Mengen
# maximale Rahmenmenge eingehalten, keine Fehlermeldung

Scenario: 03 neuer LAB mit Menge kleiner maximale Abrufmenge, neuer Feinabruf mit hoeherer Menge als LAB

# neuer LAB, EFZ ist 50, LFZ ist 100, Abrufmenge + EFZ unterhalb maximale Rahmenmenge
Given I open the infosystem "ERFLIE"
And I set fields
    | rahmen     | RAH_EDI22   |
    | einfzahl   | 50          |
    | zekunde    | SB-13       |
    | labruf     | LAB_EDI02_02|
    | labrufd    | .           |
And I delete all rows
And I append rows
    | termint    | menge  |
    | +5         | 200    |
    | +10        | 300    |
    | +15        | 300    |
    | +20        | 120    |
And I press button "daterz"
And I close the current editor

# LAB importieren
Given I open the infosystem "EDIIMPORT"
And I set field "abm" to "4010"
And I press start
And I set field "tmark" to "ja" in row 1
And I press button "tbuimport" in row 1
And I close the current editor

# EDI-Nachricht verarbeiten
Given I open the infosystem "EDIIMPVER"
And I set field "kbabrufe" to "ja"
And I set field "kballekunden" to "nein"
And I press start
And I create a new row at position 1
And I set field "tkunde" to "EDISB-13" in row 1
And I press button "tbuverarb" in row 1
And I close the current editor

# LAB -> EDI-Nachricht pruefen, kein Fehler
Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "VIEW" for search criteria "$,,labnr=LAB_EDI02_02;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | status  | 0    |
    | fcode   | 0    |
Then field "ftext" is empty
And I close the current editor


# neuer FAB, LFZ ist 100, EFZ ist 50, Abrufmenge + EFZ entspricht maximaler Rahmenmenge
# Erhoehung gegenueber LAB-Einteilung
Given I open the infosystem "ERFLIE"
And I set fields
    | rahmen    | RAH_EDI22    |
    | kbfab     | ja           |
    | einfzahl  | 50           |
    | zekunde   | SB-13        |
    | labruf    | FAB_EDI02_02 |
    | labrufd   | .            |
And I delete all rows
And I append rows
    | termint   | menge  |
    | +5        | 120    |
    | +6        | 110    |
And I press button "daterz"
And I close the current editor

# FAB importieren
Given I open the infosystem "EDIIMPORT"
And I set field "abm" to "4020"
And I press start
And I set field "tmark" to "ja" in row 1
And I press button "tbuimport" in row 1
And I close the current editor

# EDI-Nachricht verarbeiten
Given I open the infosystem "EDIIMPVER"
And I set field "kbabrufe" to "ja"
And I set field "kballekunden" to "nein"
And I press start
And I create a new row at position 1
And I set field "tkunde" to "EDISB-13" in row 1
And I press button "tbuverarb" in row 1
And I close the current editor

# FAB -> EDI-Nachricht pruefen, kein Fehlerstatus, Freitextfeld leer
Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "VIEW" for search criteria "$,,labnr=FAB_EDI02_02;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
Then field "ideksvor" is not empty
Then fields have values
    | status    | 0    |
    | fcode     | 0    |
Then field "ftext" is empty
And I close the current editor

# Differenz LFZ zu EFZ wurde mit Abrufmenge in Position 1 verrechnet, FAB-Mengen in Auftrag integriert
Given I open an editor "AUFTRAG" via ID from editor "EDINACHR" from field "ideksvor" in row 0 for table "(Sales):(SalesOrder)" with command "VIEW"
Then table has values
    | abruftyp   | mge    | zrahmen^such  |
    | FAB        |  70    | RAH_EDI22     |
    | FAB        | 110    | RAH_EDI22     |
    | LAB        | 300    | RAH_EDI22     |
    | LAB        | 300    | RAH_EDI22     |
    | LAB        | 120    | RAH_EDI22     |
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Verwendungsschluessel bei Rahmenauftraegen - Vorbereitung
# ----------------------------------------------------------------------------------------------
# Artikel anlegen
Given I open an editor "EINK" from table "(Part):(Product)" with command "COPY" for record "EINK"
And I set fields
    | such | ART_S_E |
And I save the current editor

# Rahmenauftrag Verwendugnschluessel E
Given I open an editor "RA_VERW_E" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
    | kunde    | TESTM       |
    | kl2      | TEST        |
    | such     | RA_VERW_E   |
    | abschlnr | RA_VERW_S_E |
    | verwschl | E           |
And I append rows
    | artikel  | mge  | maxabrufmge | preis | zgltvon  | zgltbis  | zkuartnr | packanw    |
    | ART_S_E  | 1000 | 1000        | 70    | 01.11.21 | 31.12.23 | KDNR_S_E | EINE-STUFE |
And I save the current editor

# Rahmenauftrag Verwendugnschluessel Leer ohne max Rahmenmenge
Given I open an editor "RA_VERW_LEER" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
    | kunde    | TESTM       |
    | kl2      | TEST        |
    | such     | RA_VERW     |
    | abschlnr | RA_VERW_S_E |
And I append rows
    | artikel  | mge  | preis | zgltvon  | zgltbis  | zkuartnr | packanw    |
    | ART_S_E  | 1000 | 80    | 01.11.21 | 31.12.23 | KDNR_S_E | EINE-STUFE |
And I save the current editor

# Rahmenauftrag Verwendugnschluessel Leer mit max Rahmenmenge
Given I open an editor "RA_VERW_LEER" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
    | kunde    | TESTM       |
    | kl2      | TEST        |
    | such     | RA_VERW_L   |
    | abschlnr | RA_VERW_S_E |
And I append rows
    | artikel  | mge  | maxabrufmge | preis | zgltvon  | zgltbis  | zkuartnr | packanw    |
    | ART_S_E  | 1000 | 1000        | 80    | 01.11.21 | 31.12.23 | KDNR_S_E | EINE-STUFE |
And I save the current editor

# Rahmenauftrag Verwendugnschluessel S (als Letzter! Neuester RA!)
Given I open an editor "RA_VERW_S" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
    | kunde    | TESTM       |
    | kl2      | TEST        |
    | such     | RA_VERW_S   |
    | abschlnr | RA_VERW_S_E |
    | verwschl | S           |
And I append rows
    | artikel  | mge  | maxabrufmge | preis | zgltvon  | zgltbis  | zkuartnr  | packanw     |
    | ART_S_E  | 1000 | 1000        | 50    | 01.11.94 | 31.12.21 | KDNR_S_E  | ZWEI-STUFEN |
And I save the current editor

# ----------------------------------------------------------------------------------------------
Scenario Outline: Verwendungsschluessel bei Rahmenauftraegen - Vorbelegung durch Preisfindung
# ----------------------------------------------------------------------------------------------
And I set the fake date to "08.11.2021"

# Auftraege mit Verwendungsschluessel
Given I open an editor "<such>" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde    | TESTM       |
    | kl2      | TEST        |
    | such     | <such>      |
    | vom      | .           |
    | verwschl | <verwschl>  |
And I append rows
    | artikel   | mge | wtterm   |
    | ART_S_E   | 80  | 02.12.21 |
Then table has values
    | fixpwert        | zrahmen^such      |
    | <soll_fixpwert> | <soll_rahmensuch> |

# Maximalmenge ueberschreiten
And I set field "mge" to "1200" in row 1
Then field "zrahmen^such" has value "<soll_rahmen_neu>" in row 1

And I close the current editor

Examples:
| such      | verwschl    | soll_fixpwert | soll_rahmensuch | soll_rahmen_neu |
| A1_VERW_L | !dontChange | nein          | RA_VERW_L       | RA_VERW         |
| A1_VERW_S | S           | nein          | RA_VERW_S       | RA_VERW         |
| A1_VERW_E | E           | nein          | RA_VERW_E       | RA_VERW         |

# ----------------------------------------------------------------------------------------------
Scenario: Verwendungsschluessel bei Rahmenauftraegen - erlaubte Eingaben in zrahmen
# ----------------------------------------------------------------------------------------------
And I set the fake date to "08.11.2021"

Given I open an editor "A1_VERW" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set fields
    | kunde     | TESTM    |
    | kl2       | TEST     |
    | such      | A1_VERW  |
    | vom       | .        |
    | verwschl  |          |
And I append rows
    | artikel   | mge | wtterm   |
    | ART_S_E   | 80  | 02.12.21 |

Then field "zrahmen^such" has value "RA_VERW_L" in row 1
And I set field "zrahmen" to "RA_VERW_S" in row 1
And I set field "zrahmen" to "RA_VERW_E" in row 1

And I set field "verwschl" to "S"
And I set field "zrahmen" to "RA_VERW_L" in row 1
And I set field "zrahmen" to "RA_VERW_S" in row 1
Then setting field "zrahmen" to "RA_VERW_E" in row 1 throws the exception "10908"

And I set field "verwschl" to "E"
And I set field "zrahmen" to "RA_VERW_L" in row 1
Then setting field "zrahmen" to "RA_VERW_S" in row 1 throws the exception "10908"
And I set field "zrahmen" to "RA_VERW_E" in row 1

And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario Outline: Verwendungsschluessel bei Rahmenauftraegen - Pruefung wenn verwschl in Auftrag geaendert wurde
# ----------------------------------------------------------------------------------------------
And I set the fake date to "08.11.2021"

Given I open an editor "A2_VERW" from table "(Sales):(<db_gruppe>)" with command "NEW" for record ""
And I set fields
    | kunde    | TESTM   |
    | kl2      | TEST    |
    | such     | <such>  |
    | vom      | .       |
    | verwschl |         |
And I append rows
    | artikel   | mge | wtterm   | zrahmen   |
    | ART_S_E   | 1   | 02.12.21 | RA_VERW_L |
    | ART_S_E   | 2   | 02.12.21 | RA_VERW_S |
    | ART_S_E   | 3   | 02.12.21 | RA_VERW_E |
    | ART_S_E   | 4   | 02.12.21 | RA_VERW_E |

And I set field "verwschl" to "S"

# Beim Speichern muss die 3. Zeile angemeckert werden (4. Ist auch ungueltig)

# ToDo mibr: CUCU-219 Leere DialogID ermoeglichen fuer die Parametrisierung
#And I respond with answer "Ja" to the dialog with id "<dialog_antwort>"
Then saving the current editor throws the exception "10908"
And I set field "zrahmen" to "RA_VERW_S" in row 3
And I set field "zrahmen" to "" in row 4

Then table has values
    | zrahmen^such |
    | RA_VERW_L    |
    | RA_VERW_S    |
    | RA_VERW_S    |
    |              |

# Speichern moeglich
And I save the current editor

# Noch mal oeffnen und die Rahmensuche bei leerem VerwSchl anstossen
Given I open an editor "A2_VERW" from table "(Sales):(<db_gruppe>)" with command "UPDATE" for record from editor "A2_VERW"
And I set field "verwschl" to ""
# Mengenaenderung stoesst Rahmensuche an
And I set field "mge" to "1" in row 1
And I set field "mge" to "2" in row 2
And I set field "mge" to "3" in row 3
And I set field "mge" to "4" in row 4
Then table has values
    | zrahmen^such |
    | RA_VERW_L    |
    | RA_VERW_S    |
    | RA_VERW_S    |
    | RA_VERW_L    |
And I close the current editor


Examples: Artikel
| db_gruppe   | such    | dialog_antwort |
| SalesOrder  | A2_VERW |                |
| PackingSlip | L2_VERW |                |
#ToDo mibr: Siehe oben
#| Invoice     | R2_VERW |  4841          |

# ----------------------------------------------------------------------------------------------
Scenario: VKAbruf nicht verarbeiten, wenn Rahmenauftrag lfristkurz gesetzt hat
# ----------------------------------------------------------------------------------------------
# neuer LAB, EFZ ist 50, LFZ ist 100, Abrufmenge + EFZ unterhalb maximale Rahmenmenge
Given I open the infosystem "ERFLIE"
And I set fields
    | rahmen     | RAH_EDI22   |
    | einfzahl   | 50          |
    | zekunde    | SB-13       |
    | labruf     | LAB_EDI02_03|
    | labrufd    | .           |
And I delete all rows
And I append rows
    | termint    | menge  |
    | +55        | 1      |
And I press button "daterz"
And I close the current editor

# LAB importieren
Given I open the infosystem "EDIIMPORT"
And I set field "abm" to "4010"
And I press start
And I set field "tmark" to "ja" in row 1
And I press button "tbuimport" in row 1
And I close the current editor

# lfristkurz im Rahmen setzen
Given I open an editor "RAH_EDI22" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record from editor "RAH_EDI22"
And I set field "lzeit" to "10" in row 1
And I set field "verfuegbmge" to "1000" in row 1
And I set field "lfristkurz" to "2" in row 1
And I save the current editor

# EDI-Nachricht verarbeiten
Given I open the infosystem "EDIIMPVER"
And I set field "kbabrufe" to "ja"
And I set field "kballekunden" to "nein"
And I press start
And I create a new row at position 1
And I set field "tkunde" to "EDISB-13" in row 1
And I press button "tbuverarb" in row 1
And I close the current editor

# LAB -> EDI-Nachricht pruefen, Fehler aufgetreten
Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "UPDATE" for search criteria "$,,labnr=LAB_EDI02_03;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | status  | 4                                                                        |
    | fcode   | 63                                                                       |
    | ftext   | Rahmenauftrag mit kurzer Beschaffungszeit kann nicht verarbeitet werden. |
# Then field "ftext" is not empty
# Status zuruecksetzen
And I set fields
    | status    | 2    |
    | fcode     | 0    |
    | ftext     |      |
And I save the current editor

# lfristkurz im Rahmen leeren
Given I open an editor "RAH_EDI22" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record from editor "RAH_EDI22"
And I set field "lzeit" to "10" in row 1
And I set field "verfuegbmge" to "0" in row 1
And I save the current editor

# EDI-Nachricht verarbeiten
Given I open the infosystem "EDIIMPVER"
And I set field "kbabrufe" to "ja"
And I set field "kballekunden" to "nein"
And I press start
And I create a new row at position 1
And I set field "tkunde" to "EDISB-13" in row 1
And I press button "tbuverarb" in row 1
And I close the current editor

# LAB -> EDI-Nachricht pruefen, kein Fehler
Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "VIEW" for search criteria "$,,labnr=LAB_EDI02_03;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | status  | 0     |
    | fcode   | 0     |
# Then field "ftext" is  empty
And I close the current editor

# ----------------------------------------------------------------------------------------------
Scenario: Pruefung im Auftrag auf passende Abschlussnummer
# ----------------------------------------------------------------------------------------------
# neuer LAB, EFZ ist 50, LFZ ist 100, Abrufmenge + EFZ unterhalb maximale Rahmenmenge
Given I open the infosystem "ERFLIE"
And I set fields
    | rahmen     | RAH_EDI22   |
    | einfzahl   | 50          |
    | zekunde    | SB-13       |
    | labruf     | LAB_EDI02_03|
    | labrufd    | .           |
And I delete all rows
And I append rows
    | termint    | menge  |
    | +55        | 1      |
And I press button "daterz"
And I close the current editor

# LAB importieren
Given I open the infosystem "EDIIMPORT"
And I set field "abm" to "4010"
And I press start
And I set field "tmark" to "ja" in row 1
And I press button "tbuimport" in row 1
And I close the current editor

# EDI-Nachricht verarbeiten
Given I open the infosystem "EDIIMPVER"
And I set field "kbabrufe" to "ja"
And I set field "kballekunden" to "nein"
And I press start
And I create a new row at position 1
And I set field "tkunde" to "EDISB-13" in row 1
And I press button "tbuverarb" in row 1
And I close the current editor

# Auftrag liefern
Given I open an editor "Liefer" from table "(Sales):(SalesOrder)" with command "UPDATE" for search criteria "$,,such=BEDISB-13;lztabnr=LAB_EDI02_03;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
Then field "abschlnr" has value "RA22MAXMGE"
And I set field "abschlnr" to "RA22MAXMGEXXX"
# Rahmenauftrag passt nicht zur EDI-Abschlussnummer
Then saving the current editor throws the exception "10983"
And I set field "abschlnr" to "RA22MAXMGE"
And I save the current editor
