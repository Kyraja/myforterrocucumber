# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      :
# *****************************************************************************
@persistent
Feature: BW2-1520 Kostenumlage rückführen

Background:
Given I set the fake date to "21.01.2002"

# ---------------------------------------------------------------------------------------------
Scenario: zielpostion 3 (kmzpos3) mit den 3 kostenumlagen 200, 300 und 500,
#
#         RE mit Lagerbewegung - KM 200 auf kmzpos3 - KM 300 auf kmzpos3 - KM 500 auf kmzpos3 ...
#         RF KM 200 - Buchung RLS geblockt - RF KM 300 - Buchung RLS geblockt ...
#         SMN 6444 - RF KM 500 - Buchung RLS möglich
#
#   !!  MN 6444 wirkt aus einer anderen kette über KM 500 auf die kette vptxt==kmzpos3
#               und muss deshalb vorher noch storniert werden. prüfung auch in anderem test
# ---------------------------------------------------------------------------------------------
Given I'm logged in with password "sy"
Given I set the fake date to "21.01.2002"

# ------------ kostenquelle 2 -----------
#  km ohne umbuchung

#  KM---KMRF---MN         offen: ----SKMRF---SKM
#   \         beldat=25.01.
#    \
#    Zeitraum des Buchungsdatums prüfen (1a, 1b, 1c)
#

# RF KM
Given I open an editor "kostenumlrueck-200" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "201"
And I set field "name" to "KMRF"
And I set field "such" to "U2-RUECKF"
And I set field "origvorg" to "+U2-1ZEI-12"
And I set field "budat" to "14.01.2002"
And I save the current editor

# RLS anlegen
Given I open an editor "ruecklief-1" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+3-4"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "3-4RLS1"
And I set field "vom" to "."
And I set field "ueb" to "nein"
Then field "artikel" has value "E1LO-VO" in row 1
And I set field "mge" to "-30" in row 1
# And I wait for file cucudbg for debugging
And I save the current editor


# Ruecklieferschein buchen (muss scheitern wegen zwei noch vorhandenen Kostenumlagen)
Given I open an editor "rls-3-4RLS1" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "3-4RLS1"
And I set field "ueb" to "ja"
And saving the current editor throws the exception "2743"
Then saving the current editor throws the exception "2888"

# und die genaue meldung/bewertung - wichtig fuer genaue qs!:
# ACHTUNG!! WENN DIESER FEHLERTEXTVERGLEICH IN CUCUMBER SCHEITERT, WIRD NICHT NUR DIE EIGENTLICHE FEHLERZEILE
#           SONDERN NOCH WEITERE AUSGEBEBEN. DIE SIND ABER NICHT IMMER FALSCH. BEGINNE DESHALB MIT DER KORRKTUR
#           AN DER ERSTEN ANGEGEBEN FEHLERSTELLE UND LASSE DEN TEST DANN NOCHMALS LAUFEN!
Then saving the current editor throws the exception
"""
In der Bewertung der zugehörigen Originalliefermenge gibt es noch additive Kosten. Siehe Bewertung: 39.
Stornieren Sie zuerst die ursächliche(n) Kostenumlage(n) oder führen Sie diese zurück.
"""
And I close the current editor


# RF KM
Given I open an editor "kostenumlrueck-300" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "301"
And I set field "name" to "KMRF"
And I set field "such" to "U3-RUECKF"
And I set field "origvorg" to "+U3-2ZEI"
And I set field "budat" to "15.01.2002"
And I save the current editor


# Ruecklieferschein buchen (muss scheitern wegen zwei noch vorhandenen Kostenumlagen)
Given I open an editor "rls-3-4RLS1" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "3-4RLS1"
And I set field "ueb" to "ja"
And saving the current editor throws the exception "2743"


Then saving the current editor throws the exception "2888"
# und die genaue meldung/bewertung - wichtig fuer genaue qs!:
# ACHTUNG!! WENN DIESER FEHLERTEXTVERGLEICH IN CUCUMBER SCHEITERT, WIRD NICHT NUR DIE EIGENTLICHE FEHLERZEILE
#           SONDERN NOCH WEITERE AUSGEBEBEN. DIE SIND ABER NICHT IMMER FALSCH. BEGINNE DESHALB MIT DER KORRKTUR
#           AN DER ERSTEN ANGEGEBEN FEHLERSTELLE UND LASSE DEN TEST DANN NOCHMALS LAUFEN!
Then saving the current editor throws the exception
"""
In der Bewertung der zugehörigen Originalliefermenge gibt es noch additive Kosten. Siehe Bewertung: 41.
Stornieren Sie zuerst die ursächliche(n) Kostenumlage(n) oder führen Sie diese zurück.
"""
And I close the current editor

# voraussetzung für die anschließende rückführung
Given I open an editor "mn-stornieren6444" from table "(CostDistribution):(QuantityRevaluation)" with command "REVERSAL" for record "+6444"
And I save the current editor

# TEIL-RF KM
Given I open an editor "kostenumlrueck-500" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "501"
And I set field "name" to "KMRF"
And I set field "such" to "U5-RUECKF"
And I set field "origvorg" to "+U5-3ZEI-12"
And I set field "budat" to "13.01.2002"
And I modify table
    | !row     | zurueckfuehren   |
    | mge==20  | ja |
    | mge==30  | ja   |
    | mge==60  | nein |
And I save the current editor

# Ruecklieferschein buchen (muss funktionieren, weil keine aktive Kostenumlage mehr)
Given I open an editor "rls-3-4RLS1" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "3-4RLS1"
And I set field "ueb" to "ja"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

################################################################

Scenario: Rücklieferschein auf umgelagerte Menge

Given I'm logged in with password "sy"
Given I set the fake date to "21.01.2002"


# Rücklieferschein anlegen
Given I open an editor "rls-11-15-2-mge20" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+R11-15-2"
And I set field "num4" to "11152-20"
And I set field "such4" to "RL11mge20"
And I set field "ebeleg" to "RL11-15-2-mge20"
And I set field "vom" to "."
And I set field "mge" to "-20" in row 3
And I save the current editor


# Ruecklieferschein buchen (muss scheitern wegen zwei noch vorhandenen Kostenumlagen)
Given I open an editor "rls-11-15-2-mge20" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "RL11mge20"
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "2888"

# und die genaue meldung/bewertung - wichtig fuer genaue qs!:
# ACHTUNG!! WENN DIESER FEHLERTEXTVERGLEICH IN CUCUMBER SCHEITERT, WIRD NICHT NUR DIE EIGENTLICHE FEHLERZEILE
#           SONDERN NOCH WEITERE AUSGEBEBEN. DIE SIND ABER NICHT IMMER FALSCH. BEGINNE DESHALB MIT DER KORRKTUR
#           AN DER ERSTEN ANGEGEBEN FEHLERSTELLE UND LASSE DEN TEST DANN NOCHMALS LAUFEN!
Then saving the current editor throws the exception
"""
In der Bewertung der zugehörigen Originalliefermenge gibt es noch additive Kosten. Siehe Bewertung: 43.
Stornieren Sie zuerst die ursächliche(n) Kostenumlage(n) oder führen Sie diese zurück.
"""
And I close the current editor

#  NUR DIE EINE POSITION ZURÜCKFÜHREN, DAMIT DIE ADD-KOSTEN IN DER BEWERTUNGSKETTE 0 WERDEN !!
Given I open an editor "kostenumlrueck-400" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "400RF"
And I set field "such" to "U4-RUECKF"
And I set field "origvorg" to "+U4-4ZEI"
And I modify table
    | !row      | zurueckfuehren   |
    | mge==10   | nein |
    | mge==20   | ja   |
    | mge==40   | nein |
    | mge==50   | nein |
And I save the current editor

# Ruecklieferschein buchen (muss funktionieren, weil keine aktive Kostenumlage mehr auf der rückliefermenge!)
Given I open an editor "rls-11-15-2-mge20" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "RL11mge20"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "sRL11mge20" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "RL11mge20"
And I save the current editor

#####################################################################

Scenario: 5-6-7 Rücklieferversuche

# Rücklieferschein anlegen
Given I open an editor "rls-5-6-7-mge60" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+R5-6-7"
And I set field "num4" to "567rl"
And I set field "such4" to "RL567-M60"
And I set field "ebeleg" to "RL5-6-7-mge60"
And I set field "vom" to "."
And I set field "mge" to "-60" in row 2
And I save the current editor


# Ruecklieferschein buchen (scheitert)
Given I open an editor "rls-5-6-7-mge60" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "RL567-M60"
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "2888"

# und die genaue meldung/bewertung - wichtig fuer genaue qs!:
# ACHTUNG!! WENN DIESER FEHLERTEXTVERGLEICH IN CUCUMBER SCHEITERT, WIRD NICHT NUR DIE EIGENTLICHE FEHLERZEILE
#           SONDERN NOCH WEITERE AUSGEBEBEN. DIE SIND ABER NICHT IMMER FALSCH. BEGINNE DESHALB MIT DER KORRKTUR
#           AN DER ERSTEN ANGEGEBEN FEHLERSTELLE UND LASSE DEN TEST DANN NOCHMALS LAUFEN!
Then saving the current editor throws the exception
"""
In der Bewertung der zugehörigen Originalliefermenge gibt es noch additive Kosten. Siehe Bewertung: 42.
Stornieren Sie zuerst die ursächliche(n) Kostenumlage(n) oder führen Sie diese zurück.
"""
And I close the current editor

# REST-RF KM  danach ganze KM zurückgeführt
Given I open an editor "kostenumlrueck-500" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "502"
And I set field "name" to "KMRF"
And I set field "such" to "U5-RF-M60"
And I set field "origvorg" to "+U5-3ZEI-12"
And I set field "budat" to "13.01.2002"
And I modify table
    | !row     | zurueckfuehren   |
    | mge==60  | ja |
And I save the current editor

# Ruecklieferschein buchen (muss funktionieren, weil keine aktive Kostenumlage mehr)
Given I open an editor "rls-5-6-7-mge60" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "RL567-M60"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "sRL567-MGE60" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "RL567-M60"
And I save the current editor


################################################################

@FALL-730
Scenario: FALL-730   BE - LS aus BE - KM auf LS - TRE1 aus LS - TRE2 aus LS ...
#                    Buchung RLS geblockt - RFKM - Buchung RLS möglich
#                    RLS buchen - Storno RLS
#
# !! Besonderheit hier: KM auf LS !!

Given I'm logged in with password "sy"
Given I set the fake date to "21.01.2002"

# Konto 730-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0730FALL"
And I set field "such" to "FALL-730"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

# Konto 58-xxxx Anschaffungsnebenkosten
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "58000"
And I set field "nummer" to "58-0730"
And I set field "such" to "FALL-58xxxx"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0730FALL"
And I set field "such" to "FALL-730"
And I set field "bestausekso" to "FALL-730"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "730-FALL"
And I set field "num2" to "730-FALL"
And I set field "such" to "FALL-730"
And I set field "namebspr" to "FALL-730"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-730"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-730" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "730-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-730" in row 1
And I set field "mge" to "730" in row 1
And I set field "preis" to "730" in row 1
And I set field "kenn" to "FALL-730"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "730-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-730" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-730"
And I set field "num4" to "730-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "730" in row 1
And I set field "kenn" to "FALL-730"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-730" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "730-LS"
And I close the current editor

# Rechnung1a anlegen
Given I open an editor "rechnung-730-1a" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "730-RE1a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "1730" in row 1
And I set field "konto" to "58-0730" in row 1
And I set field "kenn" to "FALL-730"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+730-RE1a"
And I close the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-730" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "730-KMa"
And I set field "pos" to "$,,kopf^nummer=730-RE1a;art=TEXT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=730-LS;artex=FALL-730;@gruppe=2;@datenbank=4;@ablageart=(Active)" in row 1
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+730-KMa"
And I close the current editor


# Material-Rechnung anlegen
Given I open an editor "rechnung-730-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-730"
And I set field "num4" to "730-RE2a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-730"
#And I set field "fakt" to "nein"
And I set field "mge" to "230" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung vorhanden
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+730-RE2a"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-730-2b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-730"
And I set field "num4" to "730-RE2b"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-730"
# And I set field "mge" to "500" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-730" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Rechnung vorhanden
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+730-RE2b"
And I close the current editor


# Rücklieferschein anlegen
Given I open an editor "rls-730" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+730-LS"
And I set field "num4" to "730-RLS"
And I set field "vom" to "."
And I set field "mge" to "-730" in row 1
And I set field "kenn" to "FALL-730 Ruecklieferschein"
And I save the current editor

# Ruecklieferschein buchen (muss scheitern wegen zwei noch vorhandenen Kostenumlagen)
Given I open an editor "rls-730" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "730-RLS"
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "2888"
And I close the current editor


Given I open an editor "kostenumlrueck-730a" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "730aRf"
And I set field "such" to "R730a"
And I set field "origvorg" to "+730-KMa"
And I save the current editor

# Ruecklieferschein buchen (muss funktionieren, weil keine aktive Kostenumlage mehr)
Given I open an editor "rls-730" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "730-RLS"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "srls-730" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "730-RLS"
And I save the current editor


##############################################################################
@FALL-750
Scenario: FALL-750    BE - LS aus BE - TRE1 aus LS - TR2 aus LS - KM1 auf TRE1 - KM2 auf TR2 ...
#                     Buchung RLS geblockt - RFKM1 - Buchung RLS geblockt - RFKM1 - Buchung RLS möglich
#                    RLS buchen - Storno RLS

Given I'm logged in with password "sy"
Given I set the fake date to "21.01.2002"

# Konto 750-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0750FALL"
And I set field "such" to "FALL-750"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

# Konto 58-xxxx Anschaffungsnebenkosten
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "58000"
And I set field "nummer" to "58-0750"
And I set field "such" to "FALL-58xxxx"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0750FALL"
And I set field "such" to "FALL-750"
And I set field "bestausekso" to "FALL-750"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "750-FALL"
And I set field "num2" to "750-FALL"
And I set field "such" to "FALL-750"
And I set field "namebspr" to "FALL-750"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-750"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-750" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "750-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-750" in row 1
And I set field "mge" to "750" in row 1
And I set field "preis" to "750" in row 1
And I set field "kenn" to "FALL-750"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "750-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-750" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-750"
And I set field "num4" to "750-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "750" in row 1
And I set field "kenn" to "FALL-750"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-750" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "750-LS"
And I close the current editor

# Rechnung1 anlegen
Given I open an editor "rechnung-750-1a" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "750-RE1a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "1750" in row 1
And I set field "konto" to "58-0750" in row 1
And I set field "kenn" to "FALL-750"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+750-RE1a"
And I close the current editor

# Rechnung1 anlegen
Given I open an editor "rechnung-750-1b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "750-RE1b"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "20" in row 1
And I set field "konto" to "58-0750" in row 1
And I set field "kenn" to "FALL-750"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+750-RE1b"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-750-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-750"
And I set field "num4" to "750-RE2a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-750"
And I set field "mge" to "250" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-750-2b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-750"
And I set field "num4" to "750-RE2b"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-750"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-750" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+750-RE2a"
And I close the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-750" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "750-KMa"
And I set field "pos" to "$,,kopf^nummer=750-RE1a;art=TEXT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=750-RE2a;artex=FALL-750;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+750-KMa"
And I close the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-750b" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "750-KMb"
And I set field "pos" to "$,,kopf^nummer=750-RE1b;art=TEXT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=750-RE2b;artex=FALL-750;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+750-KMa"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-750" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+750-LS"
And I set field "num4" to "750-RLS"
And I set field "vom" to "."
And I set field "mge" to "-750" in row 1
And I set field "kenn" to "FALL-750 Ruecklieferschein"
And I save the current editor

# Ruecklieferschein buchen (muss scheitern wegen zwei noch vorhandenen Kostenumlagen)
Given I open an editor "rls-750" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "750-RLS"
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "2888"
And I close the current editor

Given I open an editor "kostenumlrueck-750a" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "750aRf"
And I set field "such" to "R750a"
And I set field "origvorg" to "+750-KMa"
And I save the current editor

# Ruecklieferschein buchen (muss scheitern wegen noch einer vorhandenen Kostenumlage)
Given I open an editor "rls-750" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "750-RLS"
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "2888"
And I close the current editor

# auch die 2. KM rückführen
Given I open an editor "kostenumlrueck-750b" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "750bRf"
And I set field "such" to "R750b"
And I set field "origvorg" to "+750-KMb"
And I save the current editor

# Ruecklieferschein buchen (muss funktionieren, da beide KM komplett zurückgeführt wurden)
Given I open an editor "rls-750" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "750-RLS"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "srls-750" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "750-RLS"
And I save the current editor

#####################################################################################################################################

@FALL-760
Scenario: FALL-760  BE - LS aus BE OHNE Faktura! - TRE1 aus BE - TRE2 aus BE ...
#                   KM1 auf TRE1 - KM2 auf TRE2 - Buchung RLS geblockt - RFKM1 ...
#                   Buchung RLS geblockt - RFKM2 - Buchung RLS möglich
#                   RLS buchen - Storno RLS
#
# !!! im Einkauf hier keine mengemäßige Zuordnung der LS-pos zu den RE-pos !!


Given I'm logged in with password "sy"
Given I set the fake date to "21.01.2002"

# Konto 760-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0760FALL"
And I set field "such" to "FALL-760"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

# Konto 58-xxxx Anschaffungsnebenkosten
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "58000"
And I set field "nummer" to "58-0760"
And I set field "such" to "FALL-58xxxx"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0760FALL"
And I set field "such" to "FALL-760"
And I set field "bestausekso" to "FALL-760"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "760-FALL"
And I set field "num2" to "760-FALL"
And I set field "such" to "FALL-760"
And I set field "namebspr" to "FALL-760"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-760"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-760" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "760-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-760" in row 1
And I set field "mge" to "760" in row 1
And I set field "preis" to "760" in row 1
And I set field "kenn" to "FALL-760"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "760-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-760" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-760"
And I set field "num4" to "760-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "fakt" to "nein"
And I set field "mge" to "760" in row 1
And I set field "kenn" to "FALL-760"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-760" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+760-LS"
And I close the current editor

# Rechnung1 anlegen
Given I open an editor "rechnung-760-1a" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "760-RE1a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "1760" in row 1
And I set field "konto" to "58-0760" in row 1
And I set field "kenn" to "FALL-760"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+760-RE1a"
And I close the current editor

# Rechnung-b anlegen
Given I open an editor "rechnung-760-1b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "760-RE1b"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "20" in row 1
And I set field "konto" to "58-0760" in row 1
And I set field "kenn" to "FALL-760"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+760-RE1b"
And I close the current editor

# Material-Rechnung anlegen
Given I open an editor "rechnung-760-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-760"
And I set field "num4" to "760-RE2a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-760"
#And I set field "fakt" to "nein"
And I set field "mge" to "260" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-760-2b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-760"
And I set field "num4" to "760-RE2b"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-760"
# And I set field "mge" to "500" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-760" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Rechnung vorhanden
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+760-RE2a"
And I close the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-760" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "760-KMa"
And I set field "pos" to "$,,kopf^nummer=760-RE1a;art=TEXT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=760-RE2a;artex=FALL-760;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+760-KMa"
And I close the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-760b" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "760-KMb"
And I set field "pos" to "$,,kopf^nummer=760-RE1b;art=TEXT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=760-RE2b;artex=FALL-760;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+760-KMa"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-760" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+760-LS"
And I set field "num4" to "760-RLS"
And I set field "vom" to "."
And I set field "mge" to "-760" in row 1
And I set field "kenn" to "FALL-760 Ruecklieferschein"
And I save the current editor

# Ruecklieferschein buchen (muss scheitern wegen zwei noch vorhandenen Kostenumlagen)
Given I open an editor "rls-760" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "760-RLS"
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "2888"
And I close the current editor


Given I open an editor "kostenumlrueck-760a" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "760aRf"
And I set field "such" to "R760a"
And I set field "origvorg" to "+760-KMa"
And I save the current editor

# Ruecklieferschein buchen (muss scheitern wegen noch einer vorhandenen Kostenumlage)
Given I open an editor "rls-760" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "760-RLS"
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "2888"
And I close the current editor


# auch die 2. KM rückführen
Given I open an editor "kostenumlrueck-760b" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "760bRf"
And I set field "such" to "R760b"
And I set field "origvorg" to "+760-KMb"
And I save the current editor

# Ruecklieferschein buchen (muss funktionieren, da beide KM komplett zurückgeführt wurden)
Given I open an editor "rls-760" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "760-RLS"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "srls-760" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "760-RLS"
And I save the current editor


####################################################################################

@FALL-770
Scenario: FALL-770  BE - TLSa aus BE OHNE Faktura! - TLSb aus BE OHNE Faktura! ...
#                   TRE1 aus BE - TRE2 aus BE - Separate RE3 mit Warenbeweg. ...
#                   KMa auf TRE2a und RE3 - KMb auf RE3 und RE2b ...
#                   Buchung RLSa geblockt - Buchung RLSb geblockt - RFKMa ...
#                   Buchung RLSa möglich  - Buchung RLSb noch geblockt - RFKMb ...
#                                           Buchung RLSb möglich
#                   RLSb buchen - Storno RLSb
#
# !!! ABWEICHENDE MENGEN ZWISCHEN TEILRECHNUNGEN UND TEILLIEFERSCHEINEN !!
# !!! im Einkauf hier keine mengemäßige Zuordnung der LS-pos zu den RE-pos !!

Given I'm logged in with password "sy"
Given I set the fake date to "21.01.2002"

# Konto 770-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0770FALL"
And I set field "such" to "FALL-770"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

# Konto 58-xxxx Anschaffungsnebenkosten
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "58000"
And I set field "nummer" to "58-0770"
And I set field "such" to "FALL-58xxxx"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0770FALL"
And I set field "such" to "FALL-770"
And I set field "bestausekso" to "FALL-770"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "770-FALL"
And I set field "num2" to "770-FALL"
And I set field "such" to "FALL-770"
And I set field "namebspr" to "FALL-770"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-770"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-770" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "770-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-770" in row 1
And I set field "mge" to "770" in row 1
And I set field "preis" to "770" in row 1
And I set field "kenn" to "FALL-770"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "770-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-770" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-770"
And I set field "num4" to "770-LSa"
And I set field "such4" to "LSa770"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "fakt" to "nein"
And I set field "mge" to "370" in row 1
And I set field "kenn" to "FALL-770"
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-770" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-770"
And I set field "num4" to "770-LSb"
And I set field "such4" to "LSb770"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "fakt" to "nein"
And I set field "mge" to "400" in row 1
And I set field "kenn" to "FALL-770"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-770" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+770-LSa"
And I close the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+770-LSb"
And I close the current editor

# Rechnung1 anlegen
Given I open an editor "rechnung-770-1a" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "770-RE1a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "1770" in row 1
And I set field "konto" to "58-0770" in row 1
And I set field "kenn" to "FALL-770"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+770-RE1a"
And I close the current editor

# Rechnung-b anlegen
Given I open an editor "rechnung-770-1b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "770-RE1b"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "20" in row 1
And I set field "konto" to "58-0770" in row 1
And I set field "kenn" to "FALL-770"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+770-RE1b"
And I close the current editor

# Material-Rechnung anlegen
Given I open an editor "rechnung-770-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-770"
And I set field "num4" to "770-RE2a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-770"
And I set field "mge" to "500" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-770-2b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-770"
And I set field "num4" to "770-RE2b"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-770"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-770" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Rechnung vorhanden
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+770-RE2a"
And I close the current editor
# Rechnung vorhanden
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+770-RE2b"
And I close the current editor


Given I open an editor "rechnung-770-3" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 770-RE3|
    | vom      | .      |
    | ueb      | ja     |
    | fakt     | ja     |
    | ebeleg   | andere |
    | budat    | .      |
And I append rows
    | artikel     | mge | preis   | tterm	| ptext     | platz     |
    | E1FR-VL     | 200  | 150,00 | +4		| ni-rueckf |!dontChange|
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# Kostenumlage erzeugen
Given I open an editor "kostenuml-770" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "770-KMa"
And I set field "pos" to "$,,kopf^nummer=770-RE1a;art=TEXT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=770-RE2a;artex=FALL-770;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=770-RE3; artex=E1FR-VL;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 2
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+770-KMa"
And I close the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-770b" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "770-KMb"
And I set field "pos" to "$,,kopf^nummer=770-RE1b;art=TEXT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=770-RE3; artex=E1FR-VL;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=770-RE2b;artex=FALL-770;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 2
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+770-KMa"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-770" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+770-LSa"
And I set field "num4" to "770-RLSa"
And I set field "vom" to "."
And I set field "mge" to "-370" in row 1
And I set field "kenn" to "FALL-770 Ruecklieferschein"
And I save the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-770" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+770-LSb"
And I set field "num4" to "770-RLSb"
And I set field "vom" to "."
And I set field "mge" to "-400" in row 1
And I set field "kenn" to "FALL-770 Ruecklieferschein"
And I save the current editor


# Ruecklieferschein buchen (muss scheitern wegen zwei noch vorhandenen Kostenumlagen)
Given I open an editor "rls-770" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "770-RLSa"
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "2888"
And I close the current editor


# Ruecklieferschein buchen (muss scheitern wegen zwei noch vorhandenen Kostenumlagen)
Given I open an editor "rls-770" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "770-RLSb"
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "2888"
And I close the current editor

Given I open an editor "kostenumlrueck-770a" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "770aRf"
And I set field "such" to "R770a"
And I set field "origvorg" to "+770-KMa"
And I save the current editor

# Ruecklieferschein buchen
Given I open an editor "rls-770" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "770-RLSa"
And I set field "ueb" to "ja"
And I save the current editor

# Lieferschein stornieren scheitert
Given opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+770-LSb" throws the exception "3335"
And I close the current editor

# Ruecklieferschein buchen (muss scheitern wegen noch einer vorhandenen Kostenumlage)
Given I open an editor "rls-770" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "770-RLSb"
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "2888"
And I close the current editor

# auch die 2. KM rückführen
Given I open an editor "kostenumlrueck-770b" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "770bRf"
And I set field "such" to "R770b"
And I set field "origvorg" to "+770-KMb"
And I save the current editor

# Ruecklieferschein buchen (muss funktionieren, da beide KM komplett zurückgeführt wurden)
Given I open an editor "rls-770" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "770-RLSb"
And I set field "ueb" to "ja"
And I save the current editor

# Lieferschein stornieren scheitert
Given opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "+LSa770" throws the exception "3335"
And I close the current editor

Given I open an editor "kostenumlrueck-770Sa" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+770aRf"
And I set field "num135" to "770aSRf"
Then saving the current editor throws the exception "1426"
And I close the current editor


Given I open an editor "kostenumlrueck-770Sb" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+770bRf"
And I set field "num135" to "770bSRf"
Then saving the current editor throws the exception "1426"
And I close the current editor


Given I open an editor "srls-770" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "770-RLSb"
And I set field "num4" to "770-SRLb"
And I save the current editor

Given I open an editor "kostenumlrueck-770Sb" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+770bRf"
And I set field "num135" to "770bSRf"
And I save the current editor

Given I open an editor "kostenumlrueck-770Sa" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+770aRf"
And I set field "num135" to "770aSRf"
Then saving the current editor throws the exception "1426"
And I close the current editor


Given I open an editor "srls-770" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "770-RLSa"
And I set field "num4" to "770-SRLa"
And I save the current editor

Given I open an editor "kostenumlrueck-770Sa" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+770aRf"
And I set field "num135" to "770aSRf"
And I save the current editor

#####################################################################################################################################

@FALL-790
Scenario: FALL-790  BE - TREa aus BE 190 - TREb aus BE 600...
#                   KMa auf TREa - KMb auf TREb -
#                   TLSa aus BE OHNE Faktura 300 - TLSb aus BE OHNE Faktura 300
#                   Buchung RLSa geblockt - RFKM1 ...
#                   Buchung RLSa geblockt - RFKM2 - Buchung RLSa möglich
#                    RLSa buchen - Storno RLSa
#
# !!! ABWEICHENDE MENGEN ZWISCHEN TEILRECHNUNGEN UND TEILLIEFERSCHEINEN !!
# !!! im Einkauf hier keine mengemäßige Zuordnung der LS-pos zu den RE-pos !!


Given I'm logged in with password "sy"
Given I set the fake date to "21.01.2002"

# Konto 790-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0790FALL"
And I set field "such" to "FALL-790"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

# Konto 58-xxxx Anschaffungsnebenkosten
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "58000"
And I set field "nummer" to "58-0790"
And I set field "such" to "FALL-58xxxx"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0790FALL"
And I set field "such" to "FALL-790"
And I set field "bestausekso" to "FALL-790"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "790-FALL"
And I set field "num2" to "790-FALL"
And I set field "such" to "FALL-790"
And I set field "namebspr" to "FALL-790"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-790"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-790" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "790-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-790" in row 1
And I set field "mge" to "790" in row 1
And I set field "preis" to "790" in row 1
And I set field "kenn" to "FALL-790"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "790-BE"
And I close the current editor


# Rechnung1 der umzulegenden kosten anlegen
Given I open an editor "rechnung-790-1a" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "790-RE1a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "1790" in row 1
And I set field "konto" to "58-0790" in row 1
And I set field "kenn" to "FALL-790"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+790-RE1a"
And I close the current editor

# Rechnung-b  der umzulegenden kosten anlegen
Given I open an editor "rechnung-790-1b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "790-RE1b"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "20" in row 1
And I set field "konto" to "58-0790" in row 1
And I set field "kenn" to "FALL-790"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+790-RE1b"
And I close the current editor


# Material-Rechnungen anlegen
# ---------------------------
Given I open an editor "rechnung-790-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-790"
And I set field "num4" to "790-RE2a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-790"
And I set field "fakt" to "nein"
And I set field "mge" to "190" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-790-2b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-790"
And I set field "num4" to "790-RE2b"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-790"
And field "fakt" is not modifiable
And I set field "mge" to "600" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung vorhanden
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+790-RE2a"
And I close the current editor
# Rechnung vorhanden
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+790-RE2b"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-790" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."


# Kostenumlage erzeugen
#------------------------
Given I open an editor "kostenuml-790" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "790-KMa"
And I set field "pos" to "$,,kopf^nummer=790-RE1a;art=TEXT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=790-RE2a;artex=FALL-790;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=790-RE2b;artex=FALL-790;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 2
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+790-KMa"
And I close the current editor


# Lieferschein a  zu Bestellung anlegen
#------------------------------------
Given I open an editor "lieferschein-790a" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-790"
And I set field "num4" to "790-LSa"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And field "fakt" is not modifiable
And field "fakt" has value "nein"
And I set field "mge" to "300" in row 1
And I set field "kenn" to "FALL-790"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+790-LSa"
And I close the current editor

# Lieferschein b  zu Bestellung anlegen
#------------------------------------
Given I open an editor "lieferschein-790b" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-790"
And I set field "num4" to "790-LSb"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And field "fakt" is not modifiable
And field "fakt" has value "nein"
And I set field "mge" to "490" in row 1
And I set field "kenn" to "FALL-790"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+790-LSb"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-790" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Rücklieferschein zu LSa anlegen
Given I open an editor "rls-790" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+790-LSa"
And I set field "num4" to "790-RLSa"
And I set field "vom" to "."
And I set field "mge" to "-300" in row 1
And I set field "kenn" to "FALL-790 Ruecklieferschein"
And I save the current editor

# Ruecklieferschein buchen (muss scheitern wegen zwei noch vorhandenen Kostenumlagen)
Given I open an editor "rls-790" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "790-RLSa"
And I set field "ueb" to "ja"

Then saving the current editor throws the exception "2888"

# und die genaue meldung/bewertung - wichtig fuer genaue qs!:
# ACHTUNG!! WENN DIESER FEHLERTEXTVERGLEICH IN CUCUMBER SCHEITERT, WIRD NICHT NUR DIE EIGENTLICHE FEHLERZEILE
#           SONDERN NOCH WEITERE AUSGEBEBEN. DIE SIND ABER NICHT IMMER FALSCH. BEGINNE DESHALB MIT DER KORRKTUR
#           AN DER ERSTEN ANGEGEBEN FEHLERSTELLE UND LASSE DEN TEST DANN NOCHMALS LAUFEN!
#  Then saving the current editor throws the exception
#  """
#  In der Bewertung der zugehörigen Originalliefermenge gibt es noch additive Kosten. Siehe Bewertung: 114.
#  Stornieren Sie zuerst die ursächliche(n) Kostenumlage(n) oder führen Sie diese zurück.
#  """
And I close the current editor

# 1. KM-Position zurückführen
#------------------------------
Given I open an editor "kostenumlrueck-790a" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "790aRf"
And I set field "such" to "R790a"
And I set field "origvorg" to "+790-KMa"
And I modify table
    | !row      | zurueckfuehren   |
# mge 600
    | 2         | nein             |
And I save the current editor

# Ruecklieferschein buchen (muss scheitern wegen zwei noch vorhandenen Kostenumlagen)
Given I open an editor "rls-790" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "790-RLSa"
And I set field "ueb" to "ja"

Then saving the current editor throws the exception "2888"

# und die genaue meldung/bewertung - wichtig fuer genaue qs!:
# ACHTUNG!! WENN DIESER FEHLERTEXTVERGLEICH IN CUCUMBER SCHEITERT, WIRD NICHT NUR DIE EIGENTLICHE FEHLERZEILE
#           SONDERN NOCH WEITERE AUSGEBEBEN. DIE SIND ABER NICHT IMMER FALSCH. BEGINNE DESHALB MIT DER KORRKTUR
#           AN DER ERSTEN ANGEGEBEN FEHLERSTELLE UND LASSE DEN TEST DANN NOCHMALS LAUFEN!
#  Then saving the current editor throws the exception
#  """
#  In der Bewertung der zugehörigen Originalliefermenge gibt es noch additive Kosten. Siehe Bewertung: 116.
#  Stornieren Sie zuerst die ursächliche(n) Kostenumlage(n) oder führen Sie diese zurück.
#  """
And I close the current editor


# 2. KM-Pos zurückführen
#-------------------------
Given I open an editor "kostenumlrueck-790b" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "790bRf"
And I set field "such" to "R790b"
And I set field "origvorg" to "+790-KMa"
And I save the current editor

# Ruecklieferschein buchen (muss funktionieren, keine Kostenumlagen)
Given I open an editor "rls-790" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "790-RLSa"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "kostenumlrueck-790Sb" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+790bRf"
And I set field "num135" to "790bSRf"
Then saving the current editor throws the exception "1426"
And I close the current editor


Given I open an editor "kostenumlrueck-790Sb" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+790aRf"
And I set field "num135" to "790aSRf"
Then saving the current editor throws the exception "1426"
And I close the current editor


# Bug: additive kosten leben durch Storno wieder auf.
Given I open an editor "srls-790" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "790-RLSa"
And I set field "num4" to "790-SRLa"
And I save the current editor

Given I open an editor "kostenumlrueck-790Sb" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+790bRf"
And I set field "num135" to "790bSRf"
And I save the current editor

Given I open an editor "kostenumlrueck-790Sb" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+790aRf"
And I set field "num135" to "790aSRf"
And I save the current editor

Given I open an editor "sto-kostenuml-790-KMa" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+790-KMa"
And I set field "num135" to "790-SKMa"
And I save the current editor


###################################################################################

@FALL-800
# wie 790, aber RL von LSb hier zuerst. Dieser ist nur von einer KM-Pos. abhängig,
#          im gegensatz zu LSa

Scenario: FALL-800  BE - TREa aus BE 190 - TREb aus BE 600...
#                   KMa auf TREa - KMb auf TREb -
#                   TLSa aus BE OHNE Faktura 300 - TLSb aus BE OHNE Faktura 490
#                   Buchung RLSb geblockt - RFKMb ...
#                   Buchung RLSa geblockt - RFKM2 - Buchung RLSa möglich
#                   800-RLSb buchen  -   800-RLSb  stornieren
#
# !!! ABWEICHENDE MENGEN ZWISCHEN TEILRECHNUNGEN UND TEILLIEFERSCHEINEN !!
# !!! im Einkauf hier keine mengemäßige Zuordnung der LS-pos zu den RE-pos !!

Given I'm logged in with password "sy"
Given I set the fake date to "21.01.2002"

# Konto 800-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0800FALL"
And I set field "such" to "FALL-800"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

# Konto 58-xxxx Anschaffungsnebenkosten
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "58000"
And I set field "nummer" to "58-0800"
And I set field "such" to "FALL-58xxxx"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0800FALL"
And I set field "such" to "FALL-800"
And I set field "bestausekso" to "FALL-800"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "800-FALL"
And I set field "num2" to "800-FALL"
And I set field "such" to "FALL-800"
And I set field "namebspr" to "FALL-800"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-800"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor

# Bestellung anlegen
Given I open an editor "bestellung-800" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "800-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-800" in row 1
And I set field "mge" to "800" in row 1
And I set field "preis" to "800" in row 1
And I set field "kenn" to "FALL-800"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "800-BE"
And I close the current editor


# Rechnung1 der umzulegenden kosten anlegen
Given I open an editor "rechnung-800-1a" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "800-RE1a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "1800" in row 1
And I set field "konto" to "58-0800" in row 1
And I set field "kenn" to "FALL-800"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+800-RE1a"
And I close the current editor

# Rechnung-b  der umzulegenden kosten anlegen
Given I open an editor "rechnung-800-1b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "800-RE1b"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "20" in row 1
And I set field "konto" to "58-0800" in row 1
And I set field "kenn" to "FALL-800"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+800-RE1b"
And I close the current editor


# Material-Rechnungen anlegen
# ---------------------------
Given I open an editor "rechnung-800-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-800"
And I set field "num4" to "800-RE2a"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-800"
And I set field "fakt" to "nein"
And I set field "mge" to "190" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-800-2b" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-800"
And I set field "num4" to "800-RE2b"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-800"
And field "fakt" is not modifiable
And I set field "mge" to "600" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung vorhanden
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+800-RE2a"
And I close the current editor
# Rechnung vorhanden
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+800-RE2b"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-800" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."


# Kostenumlage erzeugen
#------------------------
Given I open an editor "kostenuml-800" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "800-KMa"
And I set field "pos" to "$,,kopf^nummer=800-RE1a;art=TEXT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=800-RE2a;artex=FALL-800;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=800-RE2b;artex=FALL-800;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 2
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+800-KMa"
And I close the current editor


# Lieferschein a  zu Bestellung anlegen
#------------------------------------
Given I open an editor "lieferschein-800a" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-800"
And I set field "num4" to "800-LSa"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And field "fakt" is not modifiable
And field "fakt" has value "nein"
And I set field "mge" to "300" in row 1
And I set field "kenn" to "FALL-800"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+800-LSa"
And I close the current editor

# Lieferschein b  zu Bestellung anlegen
#------------------------------------
Given I open an editor "lieferschein-800b" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-800"
And I set field "num4" to "800-LSb"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And field "fakt" is not modifiable
And field "fakt" has value "nein"
And I set field "mge" to "490" in row 1
And I set field "kenn" to "FALL-800"
And I save the current editor

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+800-LSb"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-800" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Rücklieferschein zu LSa anlegen
Given I open an editor "rls-800" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+800-LSb"
And I set field "num4" to "800-RLSb"
And I set field "vom" to "."
And I set field "mge" to "-490" in row 1
And I set field "kenn" to "FALL-800 Ruecklieferschein"
And I save the current editor

# Ruecklieferschein buchen (muss scheitern wegen zwei noch vorhandenen Kostenumlagen)
Given I open an editor "rls-800" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "800-RLSb"
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "2888"

# und die genaue meldung/bewertung - wichtig fuer genaue qs!:
# ACHTUNG!! WENN DIESER FEHLERTEXTVERGLEICH IN CUCUMBER SCHEITERT, WIRD NICHT NUR DIE EIGENTLICHE FEHLERZEILE
#           SONDERN NOCH WEITERE AUSGEBEBEN. DIE SIND ABER NICHT IMMER FALSCH. BEGINNE DESHALB MIT DER KORRKTUR
#           AN DER ERSTEN ANGEGEBEN FEHLERSTELLE UND LASSE DEN TEST DANN NOCHMALS LAUFEN!
#  Then saving the current editor throws the exception
#  """
#  In der Bewertung der zugehörigen Originalliefermenge gibt es noch additive Kosten. Siehe Bewertung: 124.
#  Stornieren Sie zuerst die ursächliche(n) Kostenumlage(n) oder führen Sie diese zurück.
#  """
And I close the current editor

# Nur die notwendige KM-Position zurückführen
#---------------------------------------------
Given I open an editor "kostenumlrueck-800b" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "800bRf"
And I set field "such" to "R800b"
And I set field "origvorg" to "+800-KMa"
And I modify table
    | !row      | zurueckfuehren   |
    | mge==190  | nein             |
And I save the current editor

# Ruecklieferschein buchen (muss funktionieren, keine Kostenumlagen)
Given I open an editor "rls-800" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "800-RLSb"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "srls-800" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "800-RLSb"
And I save the current editor

Given I open an editor "kostenumlrueck-800Sb" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+800bRf"
And I set field "num135" to "800bSRf"
And I save the current editor

