@persistent
Feature: maxrahmenmenge_edi_lab.feature

Background:
And I set the fake date to "07.01.1995"


# **********************************************************************************
#  Name             : maxrahmenmenge_edi_lab.feature
#  Autor            : bschiga
#  Verantwortlich   : teampss
#  Funktion         : Testet Lieferabrufe fuer Rahmenauftrag mit maximaler Menge
#
# **********************************************************************************

#### Vorgänger ref_edidaten verwenden, legt Stammdaten an


Scenario: 0 Vorbereitung - Rahmenauftrag anlegen

# neuen Rahmenauftrag anlegen
Given I open an editor "RAH_EDI21" from table "(Sales):(BlanketOrder)" with command "NEW" for record ""
And I set fields
    | kunde       | EDISB-13    |
    | such        | RAH_EDI21   |
    | abschlnr    | RA21MAXMGE  |
    | verwschl    | S           |
And I append rows
    | artikel     | mge     | maxabrufmge |
    | EDIART-3    | 1000 | 1000           |
And I save the current editor


####################################################################################################################
## 1. Auftrag zum Rahmen und Lieferschein buchen, ohne Lieferabruf

Scenario: 01 Auftrag zum Rahmen und Lieferschein buchen, ohne Lieferabruf

# Auftrag aus Rahmenauftrag RAH_EDI21
Given I open an editor "AUF1_EDI1" from table "(Sales):(BlanketOrder)" with command "RELEASE" for record "RAH_EDI21"
And I set fields
   | such        | AUF1_EDI1 |
   | dfuesenden    | nein        |
Then field "rahmen^such" has value "RAH_EDI21"
And I set field "mge" to "50" in row 1
Then field "zrahmen^such" has value "RAH_EDI21" in row 1
And I save the current editor

Given I open an editor "Liefer" from table "(Sales):(SalesOrder)" with command "DELIVERY" for record "AUF1_EDI1"
And I set fields
    | such       | EDI_LS01  |
    | vom        |  .        |
    | ueb        | ja        |
And I set field "mge" to "50" in row 1
And I set field "dfuesenden" to "nein"
And I save the current editor

# fzahl und fzahlabrufoffen pruefen
Given I open an editor "RAH_EDI21" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RAH_EDI21"
Then table has values
    | fzahl | fzahlabrufoffen  | maxabrufmge |
    | 50    | 950              | 1000        |
And I close the current editor

#####################################################################################################################
## 2. Lieferabruf mit Abrufmenge die kleiner als maxabrufmge ist, fehlerfreie Verarbeitung

Scenario: 02 Lieferabruf erstellen, importieren, verarbeiten, maximale Rahmenmenge unterschritten und EFZ kleiner LFZ

# Lieferabruf erfassen, Abrufmenge gesamt 900
Given I open the infosystem "ERFLIE"
And I set fields
    | rahmen     | RAH_EDI21    |
    | einfzahl   | 0            |
    | zekunde    | SB-13        |
    | labruf     | LAB_SB13_001 |
    | labrufd    | .            |
And I delete all rows
And I append rows
    | termint    | menge  |
    | +5         | 200    |
    | +10        | 300    |
    | +15        | 300    |
    | +20        | 100    |
And I press button "daterz"
And I close the current editor

# Lieferabruf importieren
Given I open the infosystem "EDIIMPORT"
And I set field "abm" to "4010"
And I press start
And I set field "tmark" to "ja" in row 1
And I press button "tbuimport" in row 1
And I close the current editor

# Lieferabruf verarbeiten
Given I open the infosystem "EDIIMPVER"
And I set field "kbabrufe" to "ja"
And I set field "kballekunden" to "nein"
And I press start
And I create a new row at position 1
And I set field "tkunde" to "EDISB-13" in row 1
And I press button "tbuverarb" in row 1
And I close the current editor

# EDI-Nachricht pruefen, wurde verarbeitet und Auftrag angelegt
Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "VIEW" for search criteria "$,,labnr=LAB_SB13_001;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | status    | 0  |
    | fcode     | 0  |
Then field "ftext" is empty
And I close the current editor

# fzahl und fzahlabrufoffen pruefen
Given I open an editor "RAH_EDI21" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RAH_EDI21"
Then table has values
    | fzahl    | fzahlabrufoffen | maxabrufmge  |
    | 50       | 100             | 1000         |
And I close the current editor

##############################################################################################################################
## 3. Neuer Lieferabruf erstellen, importieren, verarbeiten, maximale Rahmenmenge überschritten und EFZ = LFZ (aus Schritt 1)

Scenario: 03 Neuer Lieferabruf erstellen, importieren, verarbeiten, maximale Rahmenmenge überschritten und EFZ gleich LFZ

# neuer Abruf, EFZ ist 50, Abrufmenge 1000 + EFZ überschreitet maximale Rahmenmenge
Given I open the infosystem "ERFLIE"
And I set fields
    | rahmen     | RAH_EDI21     |
    | einfzahl   | 50            |
    | zekunde    | SB-13         |
    | labruf     | LAB_SB13_002  |
    | labrufd    | .             |
And I delete all rows
And I append rows
    | termint    | menge  |
    | +5         | 200    |
    | +10        | 300    |
    | +15        | 300    |
    | +20        | 200    |
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

Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "VIEW" for search criteria "$,,labnr=LAB_SB13_002;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
Then fields have values
    | status    | 4     |
    | fcode     | 63    |
# ToDo: Pruefung auf den mehrzeiligen Fehlertext geht momentan noch nicht
#Then field "ftext" has value
#"""In Zeile 8 wurde die maximale Rahmenmenge 1.000 in Rahmenauftrag RAH_EDI21 um 50 ueberschritten.
#Abrufmenge zu hoch.
#Auftrag kann nicht angelegt werden"""
And I close the current editor

Given I open the infosystem "EDICENTER"
And I set field "kedinumvon" to "!EDINACHR^nummer"
And I set field "kedinumbis" to "!EDINACHR^nummer"
And I press start
Then table has values
    | edinr             | fotoz          | vorgang  | status  | fcode | fctext                                                            |
    | !EDINACHR^nummer  | icon:ball_red  |          | 4       | 63    | Fehler: Details entnehmen Sie dem Freitextfeld 1 im EDI-Datensatz |
And I close the current editor
## neuen fcode und neuen fctext eintragen, wenn bekannt ##

# maximale Rahmenmenge erhöhen und Abruf verarbeiten
Given I open an editor "RAH_EDI21" from table "(Sales):(BlanketOrder)" with command "UPDATE" for record "RAH_EDI21"
And I set field "maxabrufmge" to "1050" in row 1
And I save the current editor

# EDI-Nachricht aktivieren
Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "UPDATE" for search criteria "$,,labnr=LAB_SB13_002;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
And I set fields
    | status    | 2  |
    | fcode     | 0  |
    | ftext     |    |
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

# EDI-Nachricht wurde verarbeitet, Auftrag angelegt, kein Fehlerstatus
Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "VIEW" for search criteria "$,,labnr=LAB_SB13_002;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
# Auftrag vorhanden, Feld Vorgangsidentnummer ist gefuellt
Then field "ideksvor" is not empty
Then fields have values
    | status    | 0  |
    | fcode     | 0  |
Then field "ftext" is empty
And I close the current editor

Given I open the infosystem "EDICENTER"
And I set field "kedinumvon" to "!EDINACHR^nummer"
And I set field "kedinumbis" to "!EDINACHR^nummer"
And I press start
Then table has values
    | edinr            | fotoz            | tvkkopf^such  | status  | fcode | fctext                                              |
    | !EDINACHR^nummer | icon:ball_green  | BEDISB-13     | 0       | 0     | kein Fehler in Abhängigkeit von Bearbeitungsstatus |
And I close the current editor

####################################################################################################################

Scenario: 04 Neuer Lieferabruf, Abrufmenge zzgl. LFZ überschreitet maximale Rahmenmenge, EFZ kleiner LFZ

# Auftrag liefern
Given I open an editor "Liefer" from table "(Sales):(SalesOrder)" with command "DELIVERY" for search criteria "$,,such=BEDISB-13;lztabnr=LAB_SB13_002;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
And I set fields
    | such       | EDI_LS02  |
    | vom        |  .        |
    | ueb        | ja        |
And I set field "mge" to "50" in row 1
And I set field "dfuesenden" to "nein"
And I save the current editor

# fzahl und maxabrufmge pruefen
Given I open an editor "RAH_EDI21" from table "(Sales):(BlanketOrder)" with command "VIEW" for record "RAH_EDI21"
Then table has values
    | fzahl  | fzahlabrufoffen | maxabrufmge  |
    | 100    | -50             | 1050         |
And I close the current editor

# neuer Abruf, EFZ ist 50, Abrufmenge 1000 + LFZ 100 überschreitet maximale Rahmenmenge
Given I open the infosystem "ERFLIE"
And I set fields
    | rahmen    | RAH_EDI21     |
    | einfzahl  | 50            |
    | zekunde   | SB-13         |
    | labruf    | LAB_SB13_003  |
    | labrufd   | .             |
And I delete all rows
And I append rows
    | termint    | menge  |
    | +5         | 200    |
    | +10        | 300    |
    | +15        | 300    |
    | +20        | 200    |
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

# EDI-Nachricht wurde fehlerfrei verarbeitet und Auftrag angelegt
Given I open an editor "EDINACHR" from table "(EDI):(EDI)" with command "VIEW" for search criteria "$,,labnr=LAB_SB13_003;@richtung=(Backwards);@maxtreffer=1;@ablageart=lebendig"
Then field "ideksvor" is not empty
Then fields have values
    | status    | 0    |
    | fcode     | 0    |
And I close the current editor

# Differenz LFZ zu EFZ wurde mit Abrufmenge in Position 1 verrechnet
Given I open an editor "AUFTRAG" via ID from editor "EDINACHR" from field "ideksvor" in row 0 for table "(Sales):(SalesOrder)" with command "VIEW"
Then table has values
    | mge    | zrahmen^such |
    | 150    | RAH_EDI21    |
    | 300    | RAH_EDI21    |
    | 300    | RAH_EDI21    |
    | 200    | RAH_EDI21    |
And I close the current editor

