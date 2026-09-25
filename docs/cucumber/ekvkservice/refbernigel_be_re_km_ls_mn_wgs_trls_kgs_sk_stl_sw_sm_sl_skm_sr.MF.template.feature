# ***************************************************************************
#  Name      : 
#  Datum     : 2025
#  Autor     : meko/rem
#  Verantwortlich : meko
#  Kontrolle :
#
#  Funktion  : Cucumber Skript zum Zwischenkonto "Berechnet, nicht geliefert" - Materialkostenverbuchung UND Fertigungskostenverbuchung aktivieren
#
# ***************************************************************************
@persistent
Feature: Test zum Zwischenkonto Berechnet, nicht geliefert, Materialkostenverbuchung aktivieren
Background:
Given I set the fake date to "06.01.2002"

# =====================================================================================

#-----------------------------------------------------------
Scenario: Voraussetzung fÃ¼r FKV
#-----------------------------------------------------------

Given I open an editor "fk" from table "(ProductionAccountsGroup):(ProductionAccountsGroup)" with command "NEW" for record ""
And I set field "nummer" to "400"
And I set field "such" to "FKOGRP"
And I append rows
    | fertigungskosten     | belast    | entlast   |
    | Lohn                 | 99800     | 99900     |
    | Maschinenkosten fix  | 99800     | 99900     |
    | Maschinenkosten var  | 99800     | 99900     |
    | SK fix               | 99800     | 99900     |
    | SK var               | 99800     | 99900     |
And I save the current editor

Given I open an editor "korekonf" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
And I set field "fertkont" to "FKOGRP"
And I save the current editor

Given I open an editor "nicht-gebraucht-1" from table "(Capacity):(WorkCenter)" with command "DELETE" for record "Bohrerei"
And I respond with answer "Ja" to the dialog with id "826"
And I save the current editor

Given I open an editor "nicht-gebraucht-2" from table "(Capacity):(WorkCenter)" with command "DELETE" for record "Dreherei"
And I respond with answer "Ja" to the dialog with id "826"
And I save the current editor

Given I open an editor "nicht-gebraucht-3" from table "(Capacity):(Department)" with command "DELETE" for record "betr"
And I respond with answer "Ja" to the dialog with id "826"
And I save the current editor

Given I open an editor "Konto" from table "(Account):(Account)" with command "UPDATE" for record "54000"
And I set field "kstelle" to "101"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Stammdaten anlegen
#----------------------------------------------------------------------------------------------
 
# Gemeinkostensätze (ohne Gemeinkosten) anlegen
Given I open an editor "GK1" from table "(Company):(OverheadRates)" with command "NEW" for record ""
And I set fields
   | such            | GK1         |
   | namebspr        | GK1         |
   | nummer          | 100         |
And I save the current editor

# Artikel (PdZ/Vorgangspreis; ohne Gemeinkosten) anlegen
Given I open an editor "Artikel100100" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
    | nummer    | 100100           |
    | such      | Artikel100100    |
    | ekbewverf | 6                |
    | wgruppe   | 12003vo          |
    | erlgrp    | 14103            |    
    | gemein    | 100              |
    | zuplatz   | 1                |
    | abplatz   | 1                |
And I save the current editor

# MF-vor-be #Given I enable the flag 39
# MF-vor-be #
# MF-vor-be #Given I open an editor "Konfiguration-bew" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-be #And I set field "bew" to "ja"
# MF-vor-be ## 2539 : ACHTUNG LanglÃ¤ufer: Stammdaten werden geprÃ¼ft - o.k.?
# MF-vor-be #And I respond with answer "ja" to the dialog with id "2539"
# MF-vor-be ## 2540 : Alle Fehlerhinweise aus FOP la/MBFEHL bereinigt - wirklich aktivieren?
# MF-vor-be ## braucht Verzeichnis la zur Ausgabe. Dieses im Test anlegen.  
# MF-vor-be #And I respond with answer "ja" to the dialog with id "2540"
# MF-vor-be #And I save the current editor
# MF-vor-be #
# MF-vor-be #Given I open an editor "Konfiguration-fkkonfig" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-be #And I set field "fkkonfig" to "ja"
# MF-vor-be ##eine von beiden nicht
# MF-vor-be #And I respond with answer "Ja" to the dialog with id "3358"
# MF-vor-be ##And I respond with answer "Ja" to the dialog with id "3359"
# MF-vor-be #And I save the current editor
# MF-vor-be #
# MF-vor-be #Given I disable the flag 39

#----------------------------------------------------------------------------------------------
Scenario: Bestellung 10St x 10 EUR (Schritt 1)
#----------------------------------------------------------------------------------------------
 
# HIER DIE BESTELLUNG EINFÃGEN
Given I open an editor "BE-101" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief     | 001      |
    | nummer   | 101-BE   |
    | such     | BE-101   |
    | ebeleg   | BE-101   |
    | erfwaehr | EUR      |    
    | vom      | .        |
    | budat    | .        |
And I append rows
    | artikel | mge  | preis |
    | 100100  | 10   | 10    |
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "36301"
# MF-vor-be #Then field "esakt" has value "0.00" in row 0
# MF-vor-re #Then field "esakt" has value "0.00" in row 0
# MF-vor-km #Then field "esakt" has value "0.00" in row 0
# MF-vor-ls #Then field "esakt" has value "0.00" in row 0
# MF-vor-wgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-mn #Then field "esakt" has value "0.00" in row 0
# MF-vor-trls #Then field "esakt" has value "0.00" in row 0
# MF-vor-kgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-sk #Then field "esakt" has value "0.00" in row 0
# MF-vor-stl #Then field "esakt" has value "0.00" in row 0
# MF-vor-sm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sw #Then field "esakt" has value "0.00" in row 0
# MF-vor-sl #Then field "esakt" has value "0.00" in row 0
# MF-vor-skm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sr #Then field "esakt" has value "0.00" in row 0
And I close the current editor

# MF-vor-re #Given I enable the flag 39
# MF-vor-re #
# MF-vor-re #Given I open an editor "Konfiguration-bew" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-re #And I set field "bew" to "ja"
# MF-vor-re ## 2539 : ACHTUNG LanglÃ¤ufer: Stammdaten werden geprÃ¼ft - o.k.?
# MF-vor-re #And I respond with answer "ja" to the dialog with id "2539"
# MF-vor-re ## 2540 : Alle Fehlerhinweise aus FOP la/MBFEHL bereinigt - wirklich aktivieren?
# MF-vor-re ## braucht Verzeichnis la zur Ausgabe. Dieses im Test anlegen.  
# MF-vor-re #And I respond with answer "ja" to the dialog with id "2540"
# MF-vor-re #And I save the current editor
# MF-vor-re #
# MF-vor-re #Given I open an editor "Konfiguration-fkkonfig" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-re #And I set field "fkkonfig" to "ja"
# MF-vor-re ##eine von beiden nicht
# MF-vor-re #And I respond with answer "Ja" to the dialog with id "3358"
# MF-vor-re ##And I respond with answer "Ja" to the dialog with id "3359"
# MF-vor-re #And I save the current editor
# MF-vor-re #
# MF-vor-re #Given I disable the flag 39

#----------------------------------------------------------------------------------------------
Scenario: Rechnung 10St x 10 EUR (Schritt 2) -> Bew, die erzeugt wuerde, haette bewpr = 10
#----------------------------------------------------------------------------------------------

# HIER DIE RECHNUNG EINFÃGEN USW.
# Rechnung aus Bestellung
Given I open an editor "RE-101" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "BE-101"
And I set fields
   | num    | 101-RE   |
   | such   | RE-101   |
   | vom    | .        |
#   | tterm  | .        |
   | ueb    | ja       |
And I set field "mge" to "10" in row 1
And I set field "ptext" to "RE-101" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "36301"
# MF-vor-be #Then field "esakt" has value "100.00" in row 0
# MF-vor-re #Then field "esakt" has value "100.00" in row 0
# MF-vor-km #Then field "esakt" has value "0.00" in row 0
# MF-vor-ls #Then field "esakt" has value "0.00" in row 0
# MF-vor-wgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-mn #Then field "esakt" has value "0.00" in row 0
# MF-vor-trls #Then field "esakt" has value "0.00" in row 0
# MF-vor-kgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-sk #Then field "esakt" has value "0.00" in row 0
# MF-vor-stl #Then field "esakt" has value "0.00" in row 0
# MF-vor-sm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sw #Then field "esakt" has value "0.00" in row 0
# MF-vor-sl #Then field "esakt" has value "0.00" in row 0
# MF-vor-skm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sr #Then field "esakt" has value "0.00" in row 0
And I close the current editor

# Scenario: km
# km ist kostenumlage @Melik:
# bitte den MF- block jeweils von oben kopieren und den kommentar entsprechend des scenarios benennen... blockmodus verwenden
# MF-vor-km #Given I enable the flag 39
# MF-vor-km #
# MF-vor-km #Given I open an editor "Konfiguration-bew" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-km #And I set field "bew" to "ja"
# MF-vor-km ## 2539 : ACHTUNG LanglÃ¤ufer: Stammdaten werden geprÃ¼ft - o.k.?
# MF-vor-km #And I respond with answer "ja" to the dialog with id "2539"
# MF-vor-km ## 2540 : Alle Fehlerhinweise aus FOP la/MBFEHL bereinigt - wirklich aktivieren?
# MF-vor-km ## braucht Verzeichnis la zur Ausgabe. Dieses im Test anlegen.  
# MF-vor-km #And I respond with answer "ja" to the dialog with id "2540"
# MF-vor-km #And I save the current editor
# MF-vor-km #
# MF-vor-km #Given I open an editor "Konfiguration-fkkonfig" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-km #And I set field "fkkonfig" to "ja"
# MF-vor-km ##eine von beiden nicht
# MF-vor-km #And I respond with answer "Ja" to the dialog with id "3358"
# MF-vor-km ##And I respond with answer "Ja" to the dialog with id "3359"
# MF-vor-km #And I save the current editor
# MF-vor-km #
# MF-vor-km #Given I disable the flag 39
# HIER DIE KM EINFÃGEN UND UNTEN ENTSPRECHEND ALLE WEITEREN SCHRITTE.
#----------------------------------------------------------------------------------------------
Scenario: RE Transportkosten anlegen
#----------------------------------------------------------------------------------------------
# EK-Rechnung Transportkosten
# Rechnung für additive Kosten anlegen

Given I open an editor "RE-102" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "102-RE"
And I set field "lief" to "1"
And I set field "erfwaehr" to "EUR"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I append rows
 |artex       | pwert| kstelle | ptext  |
 |TEXT        |   10 |     101 | RE-102 |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: Transportkosten umlegen (Schritt 3) -> Bew, die erzeugt wuerde, haette bewpr = 10+1 = 11
#----------------------------------------------------------------------------------------------
# KM Transportkosten auf RE

Given I open an editor "KMTR" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "kmtr"
And I set field "pos" to "$,,ptext==RE-102;art==TEXT;@ablageart=(Both)"
# MF-vor-be #And I set field "fibuumbuch" to "ja"
# MF-vor-re #And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
#And I set field "pos" to "$,,kopf^num==101-RE;ptext==RE-101;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row !lastRow
#Die beiden nächsten Zeilen erfüllen beide den Zweck. Für eine der beiden Zeilen muss man sich entscheiden:
#And I set field "pos" to "(159,4,0)" in row !lastRow
And I set field "pos" to "$,,artikel==100100;ptext==RE-101;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row !lastRow
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "36301"
# MF-vor-be #Then field "esakt" has value "100.00" in row 0
# MF-vor-re #Then field "esakt" has value "100.00" in row 0
# MF-vor-km #Then field "esakt" has value "0.00" in row 0
# MF-vor-ls #Then field "esakt" has value "0.00" in row 0
# MF-vor-wgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-mn #Then field "esakt" has value "0.00" in row 0
# MF-vor-trls #Then field "esakt" has value "0.00" in row 0
# MF-vor-kgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-sk #Then field "esakt" has value "0.00" in row 0
# MF-vor-stl #Then field "esakt" has value "0.00" in row 0
# MF-vor-sm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sw #Then field "esakt" has value "0.00" in row 0
# MF-vor-sl #Then field "esakt" has value "0.00" in row 0
# MF-vor-skm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sr #Then field "esakt" has value "0.00" in row 0
And I close the current editor

# Scenario: ls
# MF-vor-ls #Given I enable the flag 39
# MF-vor-ls #
# MF-vor-ls #Given I open an editor "Konfiguration-bew" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-ls #And I set field "bew" to "ja"
# MF-vor-ls ## 2539 : ACHTUNG LanglÃ¤ufer: Stammdaten werden geprÃ¼ft - o.k.?
# MF-vor-ls #And I respond with answer "ja" to the dialog with id "2539"
# MF-vor-ls ## 2540 : Alle Fehlerhinweise aus FOP la/MBFEHL bereinigt - wirklich aktivieren?
# MF-vor-ls ## braucht Verzeichnis la zur Ausgabe. Dieses im Test anlegen.  
# MF-vor-ls #And I respond with answer "ja" to the dialog with id "2540"
# MF-vor-ls #And I save the current editor
# MF-vor-ls #
# MF-vor-ls #Given I open an editor "Konfiguration-fkkonfig" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-ls #And I set field "fkkonfig" to "ja"
# MF-vor-ls ##eine von beiden nicht
# MF-vor-ls #And I respond with answer "Ja" to the dialog with id "3358"
# MF-vor-ls ##And I respond with answer "Ja" to the dialog with id "3359"
# MF-vor-ls #And I save the current editor
# MF-vor-ls #
# MF-vor-ls #Given I disable the flag 39

#----------------------------------------------------------------------------------------------
Scenario: Lieferschein 10St x 10 EUR (Schritt 4) -> Bew 1 hat bewpr = 11
#----------------------------------------------------------------------------------------------

# Lieferschein aus Bestellung erstellen
Given I open an editor "LS-101" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "BE-101"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "num" to "101-LS"
And I set field "such" to "LS-101"
And I set field "mge" to "10" in row 1
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "36301"
# MF-vor-be #Then field "esakt" has value "0.00" in row 0
# MF-vor-re #Then field "esakt" has value "0.00" in row 0
# MF-vor-km #Then field "esakt" has value "0.00" in row 0
# MF-vor-ls #Then field "esakt" has value "0.00" in row 0
# MF-vor-wgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-mn #Then field "esakt" has value "0.00" in row 0
# MF-vor-trls #Then field "esakt" has value "0.00" in row 0
# MF-vor-kgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-sk #Then field "esakt" has value "0.00" in row 0
# MF-vor-stl #Then field "esakt" has value "0.00" in row 0
# MF-vor-sm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sw #Then field "esakt" has value "0.00" in row 0
# MF-vor-sl #Then field "esakt" has value "0.00" in row 0
# MF-vor-skm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sr #Then field "esakt" has value "0.00" in row 0
And I close the current editor

# Scenario: wgs
# MF-vor-wgs #Given I enable the flag 39
# MF-vor-wgs #
# MF-vor-wgs #Given I open an editor "Konfiguration-bew" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-wgs #And I set field "bew" to "ja"
# MF-vor-wgs ## 2539 : ACHTUNG LanglÃ¤ufer: Stammdaten werden geprÃ¼ft - o.k.?
# MF-vor-wgs #And I respond with answer "ja" to the dialog with id "2539"
# MF-vor-wgs ## 2540 : Alle Fehlerhinweise aus FOP la/MBFEHL bereinigt - wirklich aktivieren?
# MF-vor-wgs ## braucht Verzeichnis la zur Ausgabe. Dieses im Test anlegen.  
# MF-vor-wgs #And I respond with answer "ja" to the dialog with id "2540"
# MF-vor-wgs #And I save the current editor
# MF-vor-wgs #
# MF-vor-wgs #Given I open an editor "Konfiguration-fkkonfig" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-wgs #And I set field "fkkonfig" to "ja"
# MF-vor-wgs ##eine von beiden nicht
# MF-vor-wgs #And I respond with answer "Ja" to the dialog with id "3358"
# MF-vor-wgs ##And I respond with answer "Ja" to the dialog with id "3359"
# MF-vor-wgs #And I save the current editor
# MF-vor-wgs #
# MF-vor-wgs #Given I disable the flag 39
# 
# Teilwertgutschrift: Bestellt wurden 10

#----------------------------------------------------------------------------------------------
Scenario: Wertgutschrift auf erste RE (Schritt 6) (Schritte 5 und 6 wurden getauscht (erst WGS dann MNB)) -> Bew 2 hat bewpr = 9
#----------------------------------------------------------------------------------------------

Given I open an editor "WGS-101" from table "(Purchasing):(Invoice)" with command "INVOICE" for record from editor "RE-101"
And I set fields
   | nummer | 101-WGS |
   | such   | WGS-101 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
# Teilwertgutschrift erstellen über 2
And I set field "mge" to "-2" in row 1
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "36301"
# MF-vor-be #Then field "esakt" has value "0.00" in row 0
# MF-vor-re #Then field "esakt" has value "0.00" in row 0
# MF-vor-km #Then field "esakt" has value "0.00" in row 0
# MF-vor-ls #Then field "esakt" has value "0.00" in row 0
# MF-vor-wgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-mn #Then field "esakt" has value "0.00" in row 0
# MF-vor-trls #Then field "esakt" has value "0.00" in row 0
# MF-vor-kgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-sk #Then field "esakt" has value "0.00" in row 0
# MF-vor-stl #Then field "esakt" has value "0.00" in row 0
# MF-vor-sm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sw #Then field "esakt" has value "0.00" in row 0
# MF-vor-sl #Then field "esakt" has value "0.00" in row 0
# MF-vor-skm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sr #Then field "esakt" has value "0.00" in row 0
And I close the current editor

# Scenario: mn
# MF-vor-mn #Given I enable the flag 39
# MF-vor-mn #
# MF-vor-mn #Given I open an editor "Konfiguration-bew" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-mn #And I set field "bew" to "ja"
# MF-vor-mn ## 2539 : ACHTUNG LanglÃ¤ufer: Stammdaten werden geprÃ¼ft - o.k.?
# MF-vor-mn #And I respond with answer "ja" to the dialog with id "2539"
# MF-vor-mn ## 2540 : Alle Fehlerhinweise aus FOP la/MBFEHL bereinigt - wirklich aktivieren?
# MF-vor-mn ## braucht Verzeichnis la zur Ausgabe. Dieses im Test anlegen.  
# MF-vor-mn #And I respond with answer "ja" to the dialog with id "2540"
# MF-vor-mn #And I save the current editor
# MF-vor-mn #
# MF-vor-mn #Given I open an editor "Konfiguration-fkkonfig" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-mn #And I set field "fkkonfig" to "ja"
# MF-vor-mn ##eine von beiden nicht
# MF-vor-mn #And I respond with answer "Ja" to the dialog with id "3358"
# MF-vor-mn ##And I respond with answer "Ja" to the dialog with id "3359"
# MF-vor-mn #And I save the current editor
# MF-vor-mn #
# MF-vor-mn #Given I disable the flag 39

#----------------------------------------------------------------------------------------------
Scenario: Mengenneubewertung (Schritt 5) (Schritte 5 und 6 wurden getauscht (erst WGS dann MNB)) -> Bew 3 hat bewpr = 13
#----------------------------------------------------------------------------------------------

# Mengenneubewertung anlegen
Given I open an editor "MNB-101" from table "(CostDistribution):(QuantityRevaluation)" with command "NEW" for record ""
And I set field "such" to "MNB-101"
#Die beiden nächsten Zeilen erfüllen beide den Zweck. Für eine der beiden Zeilen muss man sich entscheiden:
#And I set field "vorgang" to "(154,10,0)" in row 1
And I set field "vorgang" to "$,,artikel==100100;ebeleg==101-LS;@gruppe=1;@datenbank=10;@ablageart=(Both)" in row !lastRow
And I set field "ntbewpr" to "13" in row 1
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "36301"
# MF-vor-be #Then field "esakt" has value "0.00" in row 0
# MF-vor-re #Then field "esakt" has value "0.00" in row 0
# MF-vor-km #Then field "esakt" has value "0.00" in row 0
# MF-vor-ls #Then field "esakt" has value "0.00" in row 0
# MF-vor-wgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-mn #Then field "esakt" has value "0.00" in row 0
# MF-vor-trls #Then field "esakt" has value "0.00" in row 0
# MF-vor-kgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-sk #Then field "esakt" has value "0.00" in row 0
# MF-vor-stl #Then field "esakt" has value "0.00" in row 0
# MF-vor-sm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sw #Then field "esakt" has value "0.00" in row 0
# MF-vor-sl #Then field "esakt" has value "0.00" in row 0
# MF-vor-skm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sr #Then field "esakt" has value "0.00" in row 0
And I close the current editor

# Scenario: trls
# MF-vor-trls #Given I enable the flag 39
# MF-vor-trls #
# MF-vor-trls #Given I open an editor "Konfiguration-bew" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-trls #And I set field "bew" to "ja"
# MF-vor-trls ## 2539 : ACHTUNG LanglÃ¤ufer: Stammdaten werden geprÃ¼ft - o.k.?
# MF-vor-trls #And I respond with answer "ja" to the dialog with id "2539"
# MF-vor-trls ## 2540 : Alle Fehlerhinweise aus FOP la/MBFEHL bereinigt - wirklich aktivieren?
# MF-vor-trls ## braucht Verzeichnis la zur Ausgabe. Dieses im Test anlegen.  
# MF-vor-trls #And I respond with answer "ja" to the dialog with id "2540"
# MF-vor-trls #And I save the current editor
# MF-vor-trls #
# MF-vor-trls #Given I open an editor "Konfiguration-fkkonfig" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-trls #And I set field "fkkonfig" to "ja"
# MF-vor-trls ##eine von beiden nicht
# MF-vor-trls #And I respond with answer "Ja" to the dialog with id "3358"
# MF-vor-trls ##And I respond with answer "Ja" to the dialog with id "3359"
# MF-vor-trls #And I save the current editor
# MF-vor-trls #
# MF-vor-trls #Given I disable the flag 39

#----------------------------------------------------------------------------------------------
Scenario: Teil-Ruecklieferschein -4 St (Schritt 7) -> Bew 4 hat weiter bewpr = 13, aber mge von 10 auf 6
#----------------------------------------------------------------------------------------------

Given I open an editor "TRLS-101" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "(165,4,0)"
And I set field "num4" to "101-TRLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "mge" to "-4" in row 1
And I save the current editor
And I close the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "36301"
# MF-vor-be #Then field "esakt" has value "32.00" in row 0
# MF-vor-re #Then field "esakt" has value "32.00" in row 0
# MF-vor-km #Then field "esakt" has value "32.00" in row 0
# MF-vor-ls #Then field "esakt" has value "32.00" in row 0
# MF-vor-wgs #Then field "esakt" has value "32.00" in row 0
# MF-vor-mn #Then field "esakt" has value "32.00" in row 0
# MF-vor-trls #Then field "esakt" has value "32.00" in row 0
# MF-vor-kgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-sk #Then field "esakt" has value "0.00" in row 0
# MF-vor-stl #Then field "esakt" has value "0.00" in row 0
# MF-vor-sm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sw #Then field "esakt" has value "0.00" in row 0
# MF-vor-sl #Then field "esakt" has value "0.00" in row 0
# MF-vor-skm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sr #Then field "esakt" has value "0.00" in row 0
And I close the current editor

# Scenario: kgs
# MF-vor-kgs #Given I enable the flag 39
# MF-vor-kgs #
# MF-vor-kgs #Given I open an editor "Konfiguration-bew" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-kgs #And I set field "bew" to "ja"
# MF-vor-kgs ## 2539 : ACHTUNG LanglÃ¤ufer: Stammdaten werden geprÃ¼ft - o.k.?
# MF-vor-kgs #And I respond with answer "ja" to the dialog with id "2539"
# MF-vor-kgs ## 2540 : Alle Fehlerhinweise aus FOP la/MBFEHL bereinigt - wirklich aktivieren?
# MF-vor-kgs ## braucht Verzeichnis la zur Ausgabe. Dieses im Test anlegen.  
# MF-vor-kgs #And I respond with answer "ja" to the dialog with id "2540"
# MF-vor-kgs #And I save the current editor
# MF-vor-kgs #
# MF-vor-kgs #Given I open an editor "Konfiguration-fkkonfig" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-kgs #And I set field "fkkonfig" to "ja"
# MF-vor-kgs ##eine von beiden nicht
# MF-vor-kgs #And I respond with answer "Ja" to the dialog with id "3358"
# MF-vor-kgs ##And I respond with answer "Ja" to the dialog with id "3359"
# MF-vor-kgs #And I save the current editor
# MF-vor-kgs #
# MF-vor-kgs #Given I disable the flag 39

#----------------------------------------------------------------------------------------------
Scenario: Kaufmaennische Gutschrift (auf den Teil-RLS) (Schritt 8) -> keine Bew?
#----------------------------------------------------------------------------------------------

Given I open an editor "KGS-101" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "TRLS-101"
And I set field "num4" to "101-KGS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "36301"
#meko:14.08.25 mit Artur besprochen: Bis Bugissue UA-2652 korrigiert ist, erwarten wir in den naechsten 8 Zeilen den falschen Wert -8.
#meko:Nach der Korrektur sollte der Test scheitern und dann kann man die eigentlich korrekte 0 als erwarteten Wert eintragen.
# MF-vor-be #Then field "esakt" has value "-8.00" in row 0
# MF-vor-re #Then field "esakt" has value "-8.00" in row 0
# MF-vor-km #Then field "esakt" has value "-8.00" in row 0
# MF-vor-ls #Then field "esakt" has value "-8.00" in row 0
# MF-vor-wgs #Then field "esakt" has value "-8.00" in row 0
# MF-vor-mn #Then field "esakt" has value "-8.00" in row 0
# MF-vor-trls #Then field "esakt" has value "-8.00" in row 0
#meko:14.08.25 mit Artur besprochen: für die nächste Zeile (-40) hat Artur UA-2653 angelegt. Korrekt wäre eigentlich die 0. Weitere Vorgehensweise wird im Issue beschlossen.
# MF-vor-kgs #Then field "esakt" has value "-40.00" in row 0
# MF-vor-sk #Then field "esakt" has value "0.00" in row 0
# MF-vor-stl #Then field "esakt" has value "0.00" in row 0
# MF-vor-sm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sw #Then field "esakt" has value "0.00" in row 0
# MF-vor-sl #Then field "esakt" has value "0.00" in row 0
# MF-vor-skm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sr #Then field "esakt" has value "0.00" in row 0
And I close the current editor

# Scenario: sk
# MF-vor-sk #Given I enable the flag 39
# MF-vor-sk #
# MF-vor-sk #Given I open an editor "Konfiguration-bew" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-sk #And I set field "bew" to "ja"
# MF-vor-sk ## 2539 : ACHTUNG LanglÃ¤ufer: Stammdaten werden geprÃ¼ft - o.k.?
# MF-vor-sk #And I respond with answer "ja" to the dialog with id "2539"
# MF-vor-sk ## 2540 : Alle Fehlerhinweise aus FOP la/MBFEHL bereinigt - wirklich aktivieren?
# MF-vor-sk ## braucht Verzeichnis la zur Ausgabe. Dieses im Test anlegen.  
# MF-vor-sk #And I respond with answer "ja" to the dialog with id "2540"
# MF-vor-sk #And I save the current editor
# MF-vor-sk #
# MF-vor-sk #Given I open an editor "Konfiguration-fkkonfig" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-sk #And I set field "fkkonfig" to "ja"
# MF-vor-sk ##eine von beiden nicht
# MF-vor-sk #And I respond with answer "Ja" to the dialog with id "3358"
# MF-vor-sk ##And I respond with answer "Ja" to the dialog with id "3359"
# MF-vor-sk #And I save the current editor
# MF-vor-sk #
# MF-vor-sk #Given I disable the flag 39

#----------------------------------------------------------------------------------------------
Scenario: Storno Kaufmaennische Gutschrift (Schritt 9) -> keine Bew?
#----------------------------------------------------------------------------------------------

Given I open an editor "SKGS-101" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "KGS-101"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "36301"
# MF-vor-be #Then field "esakt" has value "32.00" in row 0
# MF-vor-re #Then field "esakt" has value "32.00" in row 0
# MF-vor-km #Then field "esakt" has value "32.00" in row 0
# MF-vor-ls #Then field "esakt" has value "32.00" in row 0
# MF-vor-wgs #Then field "esakt" has value "32.00" in row 0
# MF-vor-mn #Then field "esakt" has value "32.00" in row 0
# MF-vor-trls #Then field "esakt" has value "32.00" in row 0
# MF-vor-kgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-sk #Then field "esakt" has value "0.00" in row 0
# MF-vor-stl #Then field "esakt" has value "0.00" in row 0
# MF-vor-sm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sw #Then field "esakt" has value "0.00" in row 0
# MF-vor-sl #Then field "esakt" has value "0.00" in row 0
# MF-vor-skm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sr #Then field "esakt" has value "0.00" in row 0
And I close the current editor

# Scenario: stl
# MF-vor-stl #Given I enable the flag 39
# MF-vor-stl #
# MF-vor-stl #Given I open an editor "Konfiguration-bew" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-stl #And I set field "bew" to "ja"
# MF-vor-stl ## 2539 : ACHTUNG LanglÃ¤ufer: Stammdaten werden geprÃ¼ft - o.k.?
# MF-vor-stl #And I respond with answer "ja" to the dialog with id "2539"
# MF-vor-stl ## 2540 : Alle Fehlerhinweise aus FOP la/MBFEHL bereinigt - wirklich aktivieren?
# MF-vor-stl ## braucht Verzeichnis la zur Ausgabe. Dieses im Test anlegen.  
# MF-vor-stl #And I respond with answer "ja" to the dialog with id "2540"
# MF-vor-stl #And I save the current editor
# MF-vor-stl #
# MF-vor-stl #Given I open an editor "Konfiguration-fkkonfig" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-stl #And I set field "fkkonfig" to "ja"
# MF-vor-stl ##eine von beiden nicht
# MF-vor-stl #And I respond with answer "Ja" to the dialog with id "3358"
# MF-vor-stl ##And I respond with answer "Ja" to the dialog with id "3359"
# MF-vor-stl #And I save the current editor
# MF-vor-stl #
# MF-vor-stl #Given I disable the flag 39

#----------------------------------------------------------------------------------------------
Scenario: Storno Teil-Ruecklieferschein (Schritt 10) -> Bew 5 hat weiter bewpr = 13, aber mge wieder von 6 auf 10
#----------------------------------------------------------------------------------------------

Given I open an editor "STRLS-101" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "TRLS-101"
And I set field "nummer" to "1-STRLS"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "36301"
# MF-vor-be #Then field "esakt" has value "0.00" in row 0
# MF-vor-re #Then field "esakt" has value "0.00" in row 0
# MF-vor-km #Then field "esakt" has value "0.00" in row 0
# MF-vor-ls #Then field "esakt" has value "0.00" in row 0
# MF-vor-wgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-mn #Then field "esakt" has value "0.00" in row 0
# MF-vor-trls #Then field "esakt" has value "0.00" in row 0
# MF-vor-kgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-sk #Then field "esakt" has value "0.00" in row 0
# MF-vor-stl #Then field "esakt" has value "0.00" in row 0
# MF-vor-sm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sw #Then field "esakt" has value "0.00" in row 0
# MF-vor-sl #Then field "esakt" has value "0.00" in row 0
# MF-vor-skm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sr #Then field "esakt" has value "0.00" in row 0
And I close the current editor

# Scenario: sm
# MF-vor-sm #Given I enable the flag 39
# MF-vor-sm #
# MF-vor-sm #Given I open an editor "Konfiguration-bew" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-sm #And I set field "bew" to "ja"
# MF-vor-sm ## 2539 : ACHTUNG LanglÃ¤ufer: Stammdaten werden geprÃ¼ft - o.k.?
# MF-vor-sm #And I respond with answer "ja" to the dialog with id "2539"
# MF-vor-sm ## 2540 : Alle Fehlerhinweise aus FOP la/MBFEHL bereinigt - wirklich aktivieren?
# MF-vor-sm ## braucht Verzeichnis la zur Ausgabe. Dieses im Test anlegen.  
# MF-vor-sm #And I respond with answer "ja" to the dialog with id "2540"
# MF-vor-sm #And I save the current editor
# MF-vor-sm #
# MF-vor-sm #Given I open an editor "Konfiguration-fkkonfig" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-sm #And I set field "fkkonfig" to "ja"
# MF-vor-sm ##eine von beiden nicht
# MF-vor-sm #And I respond with answer "Ja" to the dialog with id "3358"
# MF-vor-sm ##And I respond with answer "Ja" to the dialog with id "3359"
# MF-vor-sm #And I save the current editor
# MF-vor-sm #
# MF-vor-sm #Given I disable the flag 39

#----------------------------------------------------------------------------------------------
Scenario: Storno Mengenneubewertung (Schritt 12)(Schritte 12 und 11 wurden getauscht (analog Schritte 5+6))
#----------------------------------------------------------------------------------------------

Given I open an editor "SMNB-101" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record from editor "MNB-101"
And I set field "nummer" to "1-SMNB"
And I set field "such" to "SMNB-101"
And I save the current editor
And I close the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "36301"
# MF-vor-be #Then field "esakt" has value "0.00" in row 0
# MF-vor-re #Then field "esakt" has value "0.00" in row 0
# MF-vor-km #Then field "esakt" has value "0.00" in row 0
# MF-vor-ls #Then field "esakt" has value "0.00" in row 0
# MF-vor-wgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-mn #Then field "esakt" has value "0.00" in row 0
# MF-vor-trls #Then field "esakt" has value "0.00" in row 0
# MF-vor-kgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-sk #Then field "esakt" has value "0.00" in row 0
# MF-vor-stl #Then field "esakt" has value "0.00" in row 0
# MF-vor-sm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sw #Then field "esakt" has value "0.00" in row 0
# MF-vor-sl #Then field "esakt" has value "0.00" in row 0
# MF-vor-skm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sr #Then field "esakt" has value "0.00" in row 0
And I close the current editor

# Scenario: sw
# MF-vor-sw #Given I enable the flag 39
# MF-vor-sw #
# MF-vor-sw #Given I open an editor "Konfiguration-bew" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-sw #And I set field "bew" to "ja"
# MF-vor-sw ## 2539 : ACHTUNG LanglÃ¤ufer: Stammdaten werden geprÃ¼ft - o.k.?
# MF-vor-sw #And I respond with answer "ja" to the dialog with id "2539"
# MF-vor-sw ## 2540 : Alle Fehlerhinweise aus FOP la/MBFEHL bereinigt - wirklich aktivieren?
# MF-vor-sw ## braucht Verzeichnis la zur Ausgabe. Dieses im Test anlegen.  
# MF-vor-sw #And I respond with answer "ja" to the dialog with id "2540"
# MF-vor-sw #And I save the current editor
# MF-vor-sw #
# MF-vor-sw #Given I open an editor "Konfiguration-fkkonfig" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-sw #And I set field "fkkonfig" to "ja"
# MF-vor-sw ##eine von beiden nicht
# MF-vor-sw #And I respond with answer "Ja" to the dialog with id "3358"
# MF-vor-sw ##And I respond with answer "Ja" to the dialog with id "3359"
# MF-vor-sw #And I save the current editor
# MF-vor-sw #
# MF-vor-sw #Given I disable the flag 39

#----------------------------------------------------------------------------------------------
Scenario: Storno Wertgutschrift (Schritt 11)(Schritte 12 und 11 wurden getauscht (analog Schritte 5+6))
#----------------------------------------------------------------------------------------------

Given I open an editor "SWGS-101" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "WGS-101"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "36301"
# MF-vor-be #Then field "esakt" has value "0.00" in row 0
# MF-vor-re #Then field "esakt" has value "0.00" in row 0
# MF-vor-km #Then field "esakt" has value "0.00" in row 0
# MF-vor-ls #Then field "esakt" has value "0.00" in row 0
# MF-vor-wgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-mn #Then field "esakt" has value "0.00" in row 0
# MF-vor-trls #Then field "esakt" has value "0.00" in row 0
# MF-vor-kgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-sk #Then field "esakt" has value "0.00" in row 0
# MF-vor-stl #Then field "esakt" has value "0.00" in row 0
# MF-vor-sm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sw #Then field "esakt" has value "0.00" in row 0
# MF-vor-sl #Then field "esakt" has value "0.00" in row 0
# MF-vor-skm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sr #Then field "esakt" has value "0.00" in row 0
And I close the current editor

# Scenario: sl
# MF-vor-sl #Given I enable the flag 39
# MF-vor-sl #
# MF-vor-sl #Given I open an editor "Konfiguration-bew" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-sl #And I set field "bew" to "ja"
# MF-vor-sl ## 2539 : ACHTUNG LanglÃ¤ufer: Stammdaten werden geprÃ¼ft - o.k.?
# MF-vor-sl #And I respond with answer "ja" to the dialog with id "2539"
# MF-vor-sl ## 2540 : Alle Fehlerhinweise aus FOP la/MBFEHL bereinigt - wirklich aktivieren?
# MF-vor-sl ## braucht Verzeichnis la zur Ausgabe. Dieses im Test anlegen.  
# MF-vor-sl #And I respond with answer "ja" to the dialog with id "2540"
# MF-vor-sl #And I save the current editor
# MF-vor-sl #
# MF-vor-sl #Given I open an editor "Konfiguration-fkkonfig" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-sl #And I set field "fkkonfig" to "ja"
# MF-vor-sl ##eine von beiden nicht
# MF-vor-sl #And I respond with answer "Ja" to the dialog with id "3358"
# MF-vor-sl ##And I respond with answer "Ja" to the dialog with id "3359"
# MF-vor-sl #And I save the current editor
# MF-vor-sl #
# MF-vor-sl #Given I disable the flag 39

#----------------------------------------------------------------------------------------------
Scenario: Storno Lieferschein 10St x 10 EUR (Schritt 13)
#----------------------------------------------------------------------------------------------

Given I open an editor "STLS-101" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "LS-101"
And I set field "num4" to "101-STLS"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "36301"
# MF-vor-be #Then field "esakt" has value "100.00" in row 0
# MF-vor-re #Then field "esakt" has value "100.00" in row 0
#meko:In BW2-2548 beschlossen, dass Storno LS nicht auf Zwischenkonto gebucht wird, wenn die Aktivierung nach BE -> RE -> LS erfolgt ist.
#Gemäß diesem Beschluss ist die erwartete 0 in den nächsten 13 Zeilen korrekt.
# MF-vor-km #Then field "esakt" has value "0.00" in row 0
# MF-vor-ls #Then field "esakt" has value "0.00" in row 0
# MF-vor-wgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-mn #Then field "esakt" has value "0.00" in row 0
# MF-vor-trls #Then field "esakt" has value "0.00" in row 0
# MF-vor-kgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-sk #Then field "esakt" has value "0.00" in row 0
# MF-vor-stl #Then field "esakt" has value "0.00" in row 0
# MF-vor-sm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sw #Then field "esakt" has value "0.00" in row 0
# MF-vor-sl #Then field "esakt" has value "0.00" in row 0
# MF-vor-skm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sr #Then field "esakt" has value "0.00" in row 0
And I close the current editor

# Scenario: skm
# MF-vor-skm #Given I enable the flag 39
# MF-vor-skm #
# MF-vor-skm #Given I open an editor "Konfiguration-bew" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-skm #And I set field "bew" to "ja"
# MF-vor-skm ## 2539 : ACHTUNG LanglÃ¤ufer: Stammdaten werden geprÃ¼ft - o.k.?
# MF-vor-skm #And I respond with answer "ja" to the dialog with id "2539"
# MF-vor-skm ## 2540 : Alle Fehlerhinweise aus FOP la/MBFEHL bereinigt - wirklich aktivieren?
# MF-vor-skm ## braucht Verzeichnis la zur Ausgabe. Dieses im Test anlegen.  
# MF-vor-skm #And I respond with answer "ja" to the dialog with id "2540"
# MF-vor-skm #And I save the current editor
# MF-vor-skm #
# MF-vor-skm #Given I open an editor "Konfiguration-fkkonfig" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-skm #And I set field "fkkonfig" to "ja"
# MF-vor-skm ##eine von beiden nicht
# MF-vor-skm #And I respond with answer "Ja" to the dialog with id "3358"
# MF-vor-skm ##And I respond with answer "Ja" to the dialog with id "3359"
# MF-vor-skm #And I save the current editor
# MF-vor-skm #
# MF-vor-skm #Given I disable the flag 39

#----------------------------------------------------------------------------------------------
Scenario: Storno Kostenumlage (Schritt 14)
#----------------------------------------------------------------------------------------------

Given I open an editor "ST-KMTR" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record from editor "KMTR"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "36301"
#meko:KM bucht nie auf Zwischenkonto, daher müssen die in den nächsten 15 Zeilen erwarteten Werte, den Werten aus dem vorherigen Block entsprechen.
# MF-vor-be #Then field "esakt" has value "100.00" in row 0
# MF-vor-re #Then field "esakt" has value "100.00" in row 0
# MF-vor-km #Then field "esakt" has value "0.00" in row 0
# MF-vor-ls #Then field "esakt" has value "0.00" in row 0
# MF-vor-wgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-mn #Then field "esakt" has value "0.00" in row 0
# MF-vor-trls #Then field "esakt" has value "0.00" in row 0
# MF-vor-kgs #Then field "esakt" has value "0.00" in row 0
# MF-vor-sk #Then field "esakt" has value "0.00" in row 0
# MF-vor-stl #Then field "esakt" has value "0.00" in row 0
# MF-vor-sm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sw #Then field "esakt" has value "0.00" in row 0
# MF-vor-sl #Then field "esakt" has value "0.00" in row 0
# MF-vor-skm #Then field "esakt" has value "0.00" in row 0
# MF-vor-sr #Then field "esakt" has value "0.00" in row 0
And I close the current editor

# Scenario: sr
# MF-vor-sr #Given I enable the flag 39
# MF-vor-sr #
# MF-vor-sr #Given I open an editor "Konfiguration-bew" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-sr #And I set field "bew" to "ja"
# MF-vor-sr ## 2539 : ACHTUNG LanglÃ¤ufer: Stammdaten werden geprÃ¼ft - o.k.?
# MF-vor-sr #And I respond with answer "ja" to the dialog with id "2539"
# MF-vor-sr ## 2540 : Alle Fehlerhinweise aus FOP la/MBFEHL bereinigt - wirklich aktivieren?
# MF-vor-sr ## braucht Verzeichnis la zur Ausgabe. Dieses im Test anlegen.  
# MF-vor-sr #And I respond with answer "ja" to the dialog with id "2540"
# MF-vor-sr #And I save the current editor
# MF-vor-sr #
# MF-vor-sr #Given I open an editor "Konfiguration-fkkonfig" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
# MF-vor-sr #And I set field "fkkonfig" to "ja"
# MF-vor-sr ##eine von beiden nicht
# MF-vor-sr #And I respond with answer "Ja" to the dialog with id "3358"
# MF-vor-sr ##And I respond with answer "Ja" to the dialog with id "3359"
# MF-vor-sr #And I save the current editor
# MF-vor-sr #
# MF-vor-sr #Given I disable the flag 39

#----------------------------------------------------------------------------------------------
Scenario: Storno Rechnung (Schritt 15)
#----------------------------------------------------------------------------------------------

Given I open an editor "SRE-101" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "RE-101"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "36301"
# MF-vor-be #Then field "esakt" has value "0.00" in row 0
# MF-vor-re #Then field "esakt" has value "0.00" in row 0
#meko:Wenn die RE vor dem Upgrade und der Storno nach dem Upgrade erfolgt, dann wird das Zwischenkonto nicht richtig bebucht.
#Das ist so gewünscht. Entscheidung ist gefallen in BW2-2476.
#Demgemäß erwarten wir in den nächsten 13 Zeilen die -100 und nicht die 0.
# MF-vor-km #Then field "esakt" has value "-100.00" in row 0
# MF-vor-ls #Then field "esakt" has value "-100.00" in row 0
# MF-vor-wgs #Then field "esakt" has value "-100.00" in row 0
# MF-vor-mn #Then field "esakt" has value "-100.00" in row 0
# MF-vor-trls #Then field "esakt" has value "-100.00" in row 0
# MF-vor-kgs #Then field "esakt" has value "-100.00" in row 0
# MF-vor-sk #Then field "esakt" has value "-100.00" in row 0
# MF-vor-stl #Then field "esakt" has value "-100.00" in row 0
# MF-vor-sm #Then field "esakt" has value "-100.00" in row 0
# MF-vor-sw #Then field "esakt" has value "-100.00" in row 0
# MF-vor-sl #Then field "esakt" has value "-100.00" in row 0
# MF-vor-skm #Then field "esakt" has value "-100.00" in row 0
# MF-vor-sr #Then field "esakt" has value "-100.00" in row 0
And I close the current editor
