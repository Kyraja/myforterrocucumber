# *****************************************************************************
#  Name             : kv_138_editor_plausichecks.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Hier werden die Plausis im Editor fuer Kontovorgaenge geprueft
#
# *****************************************************************************
@persistent
Feature: Kontovorgang
Background: Test des Editors fuer Kontovorgang

Given I set the fake date to "10.01.95"


@FALL-KVPlausis
Scenario: Kontovorgangseditor; Plausis

# einen Kontovorgang laden
Given I open an editor "kontovorgang" from table "(AccountTransaction):(AccountTransaction)" with command "VIEW" for record "K001_MMM96"
Then field "konto" is not modifiable
Then field "kvgjahr" is not modifiable
Then field "kvnum" is not modifiable
Then field "kvoffen" is not modifiable
Then field "gdmgeschl" is not modifiable
Then field "saldo" is not modifiable
Then field "anzahlzeil" is not modifiable
Then field "sumsoll" is not modifiable
Then field "sumhaben" is not modifiable
Then field "erstbudat" is not modifiable
Then field "letztbudat" is not modifiable
#
Then field "kvnum" has value "mmm96"
Then field "kvoffen" has value "ja"
Then field "gdmgeschl" is empty in row 0
Then field "saldo" has value "12.15"
Then field "anzahlzeil" has value "2"
Then field "erstbudat" has value "01.01.96"
Then field "letztbudat" has value "23.01.96"
#
# hier kommen 2 Fehlermeldungen -> kann man auswaehlen
Then setting field "kvnum" to "neu_kv" in row 0 throws the exception "551"
Then setting field "kvnum" to "neu_kv" in row 0 throws the exception "291"
Then setting field "kvgjahr" to "98" in row 0 throws the exception "551"
Then setting field "saldo" to "20000.00" in row 0 throws the exception "291"
Then setting field "kvoffen" to "nein" in row 0 throws the exception "291"
#
# hier sind keine Zeilen erlaubt
Then creating a new row at position 1 throws the exception "291"
#
# das Speichern ist eigentlich nicht moeglich
And I save the current editor
And I close the current editor

# hier kommen 2 Fehlermeldungen -> kann man auswaehlen

Then opening an editor from table "(AccountTransaction):(AccountTransaction)" with command "COPY" for record from editor "kontovorgang" throws the exception "2620"
Then opening an editor from table "(AccountTransaction):(AccountTransaction)" with command "COPY" for record from editor "kontovorgang" throws the exception "40"


Given I open an editor "kontovorgang2" from table "(AccountTransaction):(AccountTransaction)" with command "UPDATE" for record from editor "kontovorgang"
And I close the current editor


Given I open an editor "kontovorgang3" from table "(AccountTransaction):(AccountTransaction)" with command "MODIFY" for record from editor "kontovorgang"
And I close the current editor
####################################################################################################################################


@FALL-KVSchliessen
Scenario: Kontovorgang man. schliessen; Plausis

Given I open an editor "kontovorgang" from table "(AccountTransaction):(AccountTransaction)" with command "TRANSFER" for record "K001_MMM96"
And I save the current editor
And I close the current editor

Given I open an editor "kontovorgang2" from table "(AccountTransaction):(AccountTransaction)" with command "VIEW" for record "+K001_MMM96"
Then field "kvoffen" is not modifiable
Then field "kvoffen" has value "nein"
Then field "gdmgeschl" is not empty in row 0
And I close the current editor


Given I open an editor "kontovorgang3" from table "(AccountTransaction):(AccountTransaction)" with command "TRANSFER" for record "+K001_MMM96"
# hier kommen 2 Fehlermeldungen -> kann man auswaehlen
Then saving the current editor throws the exception "2743"
Then saving the current editor throws the exception "8566"
And I close the current editor
####################################################################################################################################


@FALL-KVOeffnen
Scenario: Kontovorgang man. oeffen Plausis
# exception "8562": Nur geschlossene Kontovorgaenge mit dem Saldo ungleich 0.00 duerfen geoeffnet werden.

Given I open an editor "kv_vorher" from table "(AccountTransaction):(AccountTransaction)" with command "VIEW" for record "+L003_HEUTE"
# wurde nix veraendert
Then field "kvoffen" is not modifiable
Then field "kvoffen" has value "nein"
Then field "gdmgeschl" is empty in row 0
And I close the current editor

# Versuch einen abgelegten nicht man. geschlossen KV man. zu oeffenen
Given I open an editor "kontovorgang" from table "(AccountTransaction):(AccountTransaction)" with command "RELEASE" for record "+L003_HEUTE"
# hier kommen 2 Fehlermeldungen -> kann man auswaehlen
Then saving the current editor throws the exception "2743"
Then saving the current editor throws the exception "8562"
And I close the current editor

Given I open an editor "kv_nacher" from table "(AccountTransaction):(AccountTransaction)" with command "VIEW" for record "+L003_HEUTE"
# wurde nix veraendert
Then field "kvoffen" is not modifiable
Then field "kvoffen" has value "nein"
Then field "gdmgeschl" is empty in row 0
And I close the current editor


Given I open an editor "kontovorgang" from table "(AccountTransaction):(AccountTransaction)" with command "RELEASE" for record "+K001_MMM96"
And I save the current editor
And I close the current editor

# KV ist wieder offen
Given I open an editor "kv_nacher2" from table "(AccountTransaction):(AccountTransaction)" with command "VIEW" for record "K001_MMM96"
Then field "kvoffen" is not modifiable
Then field "kvoffen" has value "ja"
Then field "gdmgeschl" is empty in row 0
And I close the current editor

# Versuch einen offenen KV manuell zu oeffen
Given I open an editor "kontovorgang" from table "(AccountTransaction):(AccountTransaction)" with command "RELEASE" for record "K001_MMM96"
# hier kommen 2 Fehlermeldungen -> kann man auswaehlen
Then saving the current editor throws the exception "2743"
Then saving the current editor throws the exception "8562"
And I close the current editor

Given I open an editor "kv_nacher3" from table "(AccountTransaction):(AccountTransaction)" with command "VIEW" for record "K001_MMM96"
# wurde nix veraendert
Then field "kvoffen" is not modifiable
Then field "kvoffen" has value "ja"
Then field "gdmgeschl" is empty in row 0
And I close the current editor
####################################################################################################################################


@FALL-Auszifferung1
Scenario: Auszifferung

Given I open an editor "auszifferung" from table "(AccountTransaction):(Allocation)" with command "NEW" for record ""
And I set field "konto" to "35555"
Then field "kvoffen" is modifiable
# Zeilen mit offenen KVs laden
And I set field "kvoffen" to "ja"
And I press button "ladetab"
Then the table has 5 rows
# Zeilen mit geschlossenen KVs auch dazu laden
And I set field "geschl" to "ja"
And I press button "ladetab"
Then the table has 10 rows
# Zeilen ohne KVs auch holen
And I set field "geschl" to "nein"
And I set field "kvoffen" to "nein"
And I set field "ohnekv" to "ja"
And I press button "ladetab"
Then the table has 12 rows
# alle Zeilen markieren
And I press button "setzmarke"
Then field "marksaldo" has value "-17704.01"
Then field "kvmarksaldo" has value "-17704.01"
Then field "marksoll" has value "2944.21"
Then field "markhaben" has value "20648.22"
Then field "markanzahl" has value "12"
# alle Zeilen demarkieren
And I press button "entfmarke"
Then field "marksaldo" has value "0.00"
Then field "kvmarksaldo" has value "0.00"
Then field "marksoll" has value "0.00"
Then field "markhaben" has value "0.00"
Then field "markanzahl" has value "0"
#
Then field "kvnum" has value ""
And I set field "kvneu" to "100pro"
Then field "kvnum" has value "100pro"


And I close the current editor
#####################################################################################################################################


@FALL-Auszifferung2
Scenario: Auszifferung2; Selektion-Plausis

Given I open an editor "auszifferung" from table "(AccountTransaction):(Allocation)" with command "NEW" for record ""
And I set field "konto" to "35555"
Then field "kvgjahr" has value "94"
Then setting field "kvgjahr" to "93" in row 0 throws the exception "203"
# GJ-Plausis
Then setting field "agjahr" to "93" in row 0 throws the exception "131"
And I set field "agjahr" to "95"
# erwartet 8568, kommen aber 131 und 1361
Then setting field "egjahr" to "93" in row 0 throws the exception "1361"
And I set field "agjahr" to "94"
And I set field "egjahr" to "94"
# GM-Plausis
Then setting field "amonat" to "-2" in row 0 throws the exception "131"
Then setting field "amonat" to "18" in row 0 throws the exception "6772"
And I set field "amonat" to "12"
Then field "emonat" has value "12"
Then setting field "emonat" to "3" in row 0 throws the exception "8568"
And I set field "amonat" to "1"
And I set field "emonat" to "15"
And I set field "egjahr" to "95"
#
# KVNUM-Plausis
And I set field "vonkvnum" to "40"
Then field "biskvnum" has value "40"
Then setting field "biskvnum" to "33" in row 0 throws the exception "8568"
Then setting field "biskvnum" to "3a" in row 0 throws the exception "8568"
And I set field "biskvnum" to "3"
Then field "vonkvnum" has value "40"
# ACHTUNG:
# in GUI kommt die Meldung, hier nicht;
# hier muesste eigentlich die Meldung
# "Fehler in Bedingung: kvnum=40!3" : ungueltige Bereichsangabe" kommen!!!
And I press button "ladetab" in row 0
# nur eine Leerzeile ist da
Then the table has 1 rows
Then field "tbuchung" is empty in row 1
Then field "tgjahr" is empty in row 1
Then field "tkvnum" is empty in row 1
Then field "tbeleg" is empty in row 1
Then field "tbudat" is empty in row 1
#
And I set field "vonkvnum" to "1"
Then field "biskvnum" has value "1"
And I set field "vonkvnum" to ""
And I press button "ladetab"
Then the table has 2 rows
And I press button "leerentab"
Then field "vonkvnum" has value ""
And I set field "vonkvnum" to "99"
Then field "biskvnum" has value "99"
And I set field "biskvnum" to ""
And I press button "ladetab"
Then the table has 4 rows
#
# Offen, Geschlossen und Ohne
#
Then field "kvoffen" is modifiable
Then field "geschl" is modifiable
Then field "ohnekv" is not modifiable
And I set field "kvoffen" to "nein"
# wenn keine gesetzt ist, dann alle 3 veaenderbar
Then field "kvoffen" is modifiable
Then field "geschl" is modifiable
Then field "ohnekv" is modifiable
#
And I set field "ohnekv" to "ja"
Then field "kvoffen" is not modifiable
Then setting field "kvoffen" to "ja" in row 0 throws the exception "203"
Then field "geschl" is not modifiable
Then field "ohnekv" is modifiable
#
And I close the current editor
#####################################################################################################################################


@FALL-Auszifferung3
Scenario: Auszifferung3; kein Konto eingetragen

Given I open an editor "auszifferung" from table "(AccountTransaction):(Allocation)" with command "NEW" for record ""
Then field "konto" is empty
Then field "kvgjahr" is empty
# Was noch erlaubt ist
Then field "konto" is modifiable
Then field "kvoffen" is modifiable
Then field "geschl" is modifiable
Then field "ohnekv" is not modifiable
And I set field "kvoffen" to "nein"
Then field "ohnekv" is modifiable
# Rest gesperrt
#
# alle Buttons
Then field "ladetab" is not modifiable
Then pressing button "ladetab" in row 0 throws the exception "57"
Then field "selekt" is not modifiable
Then pressing button "selekt" in row 0 throws the exception "57"
Then field "leerentab" is not modifiable
Then field "aktualtab" is not modifiable
Then field "setzmarke" is not modifiable
Then field "entfmarke" is not modifiable
Then field "loesch" is not modifiable
Then pressing button "loesch" in row 0 throws the exception "203"
# Selektion-Felder
Then field "agjahr" is not modifiable
Then field "egjahr" is not modifiable
Then field "amonat" is not modifiable
Then field "emonat" is not modifiable
Then field "vonkvnum" is not modifiable
Then field "biskvnum" is not modifiable
#
Then field "kvnum" is not modifiable
Then field "kvneu" is not modifiable
#
#
And I set field "konto" to "35555"
# Konto ist da, aber Offen, Geschlossen und Ohne sind noch leer
Then pressing button "ladetab" in row 0 throws the exception "2974"
#
And I close the current editor
#####################################################################################################################################


@FALL-Auszifferung4
Scenario: Auszifferung4; Tabelle

Given I open an editor "auszifferung" from table "(AccountTransaction):(Allocation)" with command "NEW" for record ""
And I set field "konto" to "35555"
# Tabelle noch nicht geladen
Then setting field "tmarke" to "ja" in row 1 throws the exception "64"
Then field "tmarke" is not modifiable in row 1
#
# Tabelle laden
Then field "kvoffen" is modifiable
# Zeilen mit offenen KVs laden
And I set field "kvoffen" to "ja"
And I press button "ladetab"
Then the table has 5 rows
# Zeilen mit geschlossenen KVs auch dazu laden
And I set field "geschl" to "ja"
And I press button "ladetab"
Then the table has 10 rows
# Zeilen ohne KVs auch holen
And I set field "geschl" to "nein"
And I set field "kvoffen" to "nein"
And I set field "ohnekv" to "ja"
And I press button "ladetab"
Then the table has 12 rows
#
# neue Zeile eingefuegt -> muss das sein?
And I create a new row at position 5
# noch mal laden der Tabelle schmeisst eine leere Zeile raus
Then the table has 13 rows
And I press button "ladetab"
Then the table has 12 rows
#
Then setting field "tkvnum" to "niemals" in row 5 throws the exception "551"
Then setting field "toffen" to "nein" in row 5 throws the exception "551"
#
Then field "tkvnum" is not empty in row !lastRow
Then field "tkv" is empty in row !lastRow
#
And I close the current editor
#####################################################################################################################################


@FALL-Auszifferung5
Scenario: Auszifferung5; Zeile loeschen

Given I open an editor "auszifferung" from table "(AccountTransaction):(Allocation)" with command "NEW" for record ""
And I set field "konto" to "35555"
#
# Tabelle laden
Then field "kvoffen" is modifiable
# Zeilen mit offenen KVs laden
And I set field "kvoffen" to "ja"
And I press button "ladetab"
Then the table has 5 rows
# Zeilen mit geschlossenen KVs auch dazu laden
And I set field "geschl" to "ja"
And I press button "ladetab"
Then the table has 10 rows
# Zeilen ohne KVs auch holen
And I set field "geschl" to "nein"
And I set field "kvoffen" to "nein"
And I set field "ohnekv" to "ja"
And I press button "ladetab"
Then the table has 12 rows
#
# alle Zeilen markieren
And I press button "setzmarke"
Then field "marksaldo" has value "-17704.01"
Then field "kvmarksaldo" has value "-17704.01"
Then field "marksoll" has value "2944.21"
Then field "markhaben" has value "20648.22"
Then field "markanzahl" has value "12"
#
#
And I delete row at position 12
And I delete row at position 10
And I delete row at position 1
#
Then field "marksaldo" has value "-8458.13"
Then field "kvmarksaldo" has value "-8458.13"
Then field "marksoll" has value "1833.10"
Then field "markhaben" has value "10291.23"
Then field "markanzahl" has value "9"
Then the table has 9 rows
#
# bei 5 Zeilen die Markierung rausnehmen
And I set field "tmarke" to "nein" in row 2
And I set field "tmarke" to "nein" in row 3
And I set field "tmarke" to "nein" in row 5
And I set field "tmarke" to "nein" in row 7
And I set field "tmarke" to "nein" in row 8
#
And I press button "loesch"
Then the table has 4 rows
#
And I press button "leerentab"
Then field "marksaldo" has value "0.00"
Then field "kvmarksaldo" has value "0.00"
Then field "marksoll" has value "0.00"
Then field "markhaben" has value "0.00"
Then field "markanzahl" has value "0"
# eine leere Zeile bleibt stehen
Then the table has 1 rows
Then field "tkvnum" is empty in row !lastRow
Then field "tkv" is empty in row !lastRow
Then field "tbuchung" is empty in row !lastRow
Then setting field "tmarke" to "ja" in row 1 throws the exception "551"
#
And I close the current editor
#####################################################################################################################################


@FALL-Auszifferung6
Scenario: Auszifferung6; Ausziffern

Given I open an editor "auszifferung" from table "(AccountTransaction):(Allocation)" with command "NEW" for record ""
And I set field "konto" to "35555"
#
# Tabelle laden
# Zeilen mit offenen KVs laden
And I set field "kvoffen" to "ja"
And I set field "agjahr" to "94"
And I set field "egjahr" to "96"
And I set field "vonkvnum" to "-"
And I set field "biskvnum" to "-"
And I press button "ladetab"
Then the table has 3 rows
#
And I set field "kvneu" to "raus"
#
And I set field "tmarke" to "ja" in row 2
And I set field "tmarke" to "ja" in row 3
#
Then field "marksaldo" has value "0.00"
Then field "kvmarksaldo" has value "0.00"
Then field "marksoll" has value "9.99"
Then field "markhaben" has value "9.99"
Then field "markanzahl" has value "2"
#
And I save the current editor
And I close the current editor

# neu erzeugten Kontovorgang zur Kontrolle laden
Given I open an editor "kontovorgang" from table "(AccountTransaction):(AccountTransaction)" with command "VIEW" for record "+S35555_RAUS"
Then field "konto" has value "35555"
Then field "kvgjahr" has value "94"
Then field "kvnum" has value "raus"
Then field "kvoffen" has value "nein"
Then field "gdmgeschl" is empty
Then field "saldo" has value "0.00"
Then field "anzahlzeil" has value "2"
Then field "sumsoll" has value "9.99"
Then field "sumhaben" has value "9.99"
Then field "erstbudat" has value "31.12.95"
Then field "letztbudat" has value "01.01.96"
#
And I close the current editor
#####################################################################################################################################

