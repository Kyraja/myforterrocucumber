# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : wane, sih
# *****************************************************************************
@persistent
Feature: BW2-1308 Kostenumlage aus Fibu-buchungszeilen 

Background:
Given I set the fake date to "02.01.2002"
Given I enable the flag 39

# ---------------------------------------------------------------------------------------------
Scenario: projektkostenrechnung aktivieren u. stammdaten (projekte) anlegen
# ---------------------------------------------------------------------------------------------

# die projektkostenrechnung stört nicht beim test der funktionalität ohne projekte. 
# lässt man das projekt einfach weg, ist es std.funktionalität. deshalb kann das
# gleich mitgetestet werden.

Given I'm logged in with password "sy"
Given I set the fake date to "02.01.2002"

Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "projekt" to "1"
And I save the current editor

Given I open an editor "proj-1" from table "(Transaction):(Project)" with command "NEW" for record ""
And I set field "num86" to "1p"
And I set field "such" to "proj1"
And I save the current editor

Given I open an editor "proj-2" from table "(Transaction):(Project)" with command "NEW" for record ""
And I set field "num86" to "2p"
And I set field "such" to "proj2"
And I save the current editor

Given I open an editor "proj-3" from table "(Transaction):(Project)" with command "NEW" for record ""
And I set field "num86" to "3p"
And I set field "such" to "proj3"
And I save the current editor

# -------------------------------------------------------------------------------------------------------
# 2 Lieferscheinpositionen zur Aufnahme additiver Kosten
# -------------------------------------------------------------------------------------------------------
Given I open an editor "ls-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "num4" to "2ls"
And I set field "lief" to "1"
And I set field "erfwaehr" to "EUR"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "E1A-VM" in row !lastRow
And I set field "mge" to "5" in row !lastRow
And I set field "preis" to "30" in row !lastRow
And I set field "konto" to "10000" in row !lastRow
And I set field "projekt" to "proj2" in row !lastRow
And I set field "platz" to "F2" in row !lastRow
# ...
And I create a new row at the end of the table
And I set field "artex" to "E1A-PO" in row !lastRow
And I set field "mge" to "20" in row !lastRow
And I set field "preis" to "2" in row !lastRow
And I set field "konto" to "10000" in row !lastRow
And I save the current editor

# -------------------------------------------------------------------------------------------------------
# Fibu-buchung mit 2 kostenumlagefähigen Zeilen
# -------------------------------------------------------------------------------------------------------
Given I open an editor "buchung1_2km_faehige_zeilen" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "bu1"

And I create a new row at the end of the table
And I set field "konto" to "l 1" in row !lastRow

And I create a new row at the end of the table
And I set field "konto" to "54000" in row !lastRow
And I set field "ewsbetr" to "100" in row !lastRow
And I set field "kstelle" to "100" in row !lastRow
And I set field "projekt" to "proj1" in row !lastRow

And I create a new row at the end of the table
And I set field "konto" to "58000" in row !lastRow
And I set field "ewsbetr" to "10" in row !lastRow
And I set field "kstelle" to "101" in row !lastRow

And I create a new row at the end of the table
#  skontokonto ist zur kostenumlage erlaubt
And I set field "konto" to "47300" in row !lastRow
And I set field "ewsbetr" to "2" in row !lastRow
# And I set field "kstelle" to "101" in row !lastRow

And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor

# -------------------------------------------------------------------------------------------------------
# Fibu-buchung mit einer (1) kostenumlagefähige Zeile
# -------------------------------------------------------------------------------------------------------
Given I open an editor "buchung_1km_faehige_bilanzzeile" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "bu2kmbil"
And I create a new row at the end of the table
And I set field "konto" to "10000" in row !lastRow
And I create a new row at the end of the table
And I set field "konto" to "50010" in row !lastRow
And I set field "ewsbetr" to "100" in row !lastRow
And I set field "kstelle" to "110" in row !lastRow
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor

# -----------------------------------------------------------------------------------------
Scenario: Plausi: Kontenarten   
# -----------------------------------------------------------------------------------------
# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373 
#  Positivliste für die Konten:Alle Sachkonten mit der Kontenart:
#      leer
#      Skontokonto
#      Kursdifferenzkonto
#  also alle anderen verboten. zB steuerkonten

Given I'm logged in with password "sy"
Given I set the fake date to "02.01.2002"

# Kostenumlage neu - nur plausi - nicht speichern 
Given I open an editor "kostenuml-kontenkart-kart-plausi" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "7kmplaus"
And I set field "umlagebuchung" to id from editor "buchung1_2km_faehige_zeilen"

# steuerkontozeile - nicht erl.
#    1981 de   |Kontenart der Buchungszeile nicht für Kostenumlage erlaubt.
And setting field "umlagebuzeile" to "5" throws the exception "1981"

# skonto-kontozeile erl.
And I set field "umlagebuzeile" to "4"

# in den anderen kostenumlagen dieses tests sind überalle die auch
# erlaubte leere kontenart verwendet worden. 

And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer==2ls;artex=E1A-PO;@gruppe=2;@datenbank=4" in row !lastRow
And I set field "proz" to "100" in row !lastRow
And I set field "fibuumbuch" to "ja"
And I save the current editor

# -----------------------------------------------------------------------------------------
Scenario: neuer testbedarf nach verwendung der buchung in einer kostenumlage
# -----------------------------------------------------------------------------------------
Given I'm logged in with password "sy"
Given I set the fake date to "02.01.2002"

# neuer testbedarf nach verwendung der buchung in einer kostenumlage 

# neuer testbedarf OHNE WARTUNGSMODUS?
  
# für zeile1 das bil. konto mit km 
# da in buchung hier nur das bilanzkonto verwendet wird und diese buchungszeile kein kostenobjekt enthalten darf,
# ist für zeile kein neuer änderungstest des kostenobjektes erforderlich.
# => nicht testen

# neuer testbedarf MIT WARTUNGSMODUS
# zu verwendung zeile1 das bil. konto in km 
# es genügt die verwendung/belegung der zeile mit einer kostenumlage auch ohne umlagebuchung. dadurch 
# darf in der fibu-buchung, auch in wartung nichts an dieser zeile mehr änderbar sein. 
# => testen

# -------------------------------------------------------------------------------------------------------
# Kostenumlage VON BILANZ AUF BILANZ OHNE UMBUCHUNG, 2-zeilig mit prozentualer verteilung
# -------------------------------------------------------------------------------------------------------
Given I open an editor "kostenuml-bil-bil-oh-umb-1" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "1km"
And I set field "umlagebuchung" to id from editor "buchung_1km_faehige_bilanzzeile"
And I set field "umlagebuzeile" to "1"
# And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer==2ls;artex=E1A-VM;@gruppe=2;@datenbank=4" in row !lastRow
And I set field "proz" to "70" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer==2ls;artex=E1A-PO;@gruppe=2;@datenbank=4" in row !lastRow
And I set field "proz" to "30" in row !lastRow
And I save the current editor

# -------------------------------------------------------------------------------------------------------
# Kostenumlage erzeugen, ABWEICHENDE KONTEN UMBUCHUNG ERFORDERLICH, 2-zeilig mit prozentualer verteilung
# -------------------------------------------------------------------------------------------------------
Given I open an editor "kostenuml-abweichende-konten-mit-umb" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "2km"
And I set field "umlagebuchung" to id from editor "buchung1_2km_faehige_zeilen"
And I set field "umlagebuzeile" to "2"
# And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer==2ls;artex=E1A-VM;@gruppe=2;@datenbank=4" in row !lastRow
And I set field "proz" to "40" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer==2ls;artex=E1A-PO;@gruppe=2;@datenbank=4" in row !lastRow
And I set field "proz" to "60" in row !lastRow
# unterschiedliche konten, umbuchung erforderlich
#  8878 de   |Abweichende Konten in Kopf und Tabelle der Kostenumlage. Umbuchung durchfhren.
And saving the current editor throws the exception "8878"
And I set field "fibuumbuch" to "ja"
And I save the current editor


# ---------------------------------------
# status hier
# ---------------------------------------

#     |-------------------------------------------------------------------------------------------------------------|
#     |  umgelegt aus fibu-buchung:     |                              ... in:                                      |
#     |---------------------------------|---------------------------------------------------------------------------|
#     | buchung_1km_faehige_bilanzzeile |     kostenuml-bil-bil-oh-umb-1     |      kostenuml-bil-bil-oh-umb-1      |
#     |            zeile 1              |         70%                        |                30%                   |
#     |---------------------------------|------------------------------------|--------------------------------------|
#     | buchung1_2km_faehige_zeilen     |kostenuml-abweichende-konten-mit-umb| kostenuml-abweichende-konten-mit-umb |
#     |            zeile 2              |          40%                       |               60%                    |
#     |                                 |---------------------------------------------------------------------------|
#     |                                 |                              umgelegt auf:	                            |
#     |---------------------------------|------------------------------------|--------------------------------------|
#     |                                 |       ls-2 / pos1                  |        ls-2 / pos2                   |
#     |-------------------------------------------------------------------------------------------------------------|

# ---------------------------------------------------------------------------------------------
Scenario: plausis für normalmodus + Projektkostenrechnung und Plausi dazu
# ---------------------------------------------------------------------------------------------
Given I'm logged in with password "sy"
Given I set the fake date to "02.01.2002"

# a) sy
# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373 aus https://jira.abasag.intra/browse/BW2-1373:
# Es ist abgesichert, dass eine Buchungszeile nur Quelle für eine aktive (nicht stornierte) Kostenumlage sein
# kann (a: Fehlermeldung derziet 8339). technisch wird das durch den eintrag und die löschung des 
# kostenumlageverweises (b) in der buchungszeile realisiert.
# hier plausi a)
Given I open an editor "kostenuml-plausi-8339" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "1km"
And I set field "umlagebuchung" to id from editor "buchung_1km_faehige_bilanzzeile"
And setting field "umlagebuzeile" to "1" throws the exception "8339"
And I close the current editor

# b) sy
# storno der buchung verboten bei verwendung 
# einer buchungszeile aus einer fibu-buchung in einer kostenumlage
# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373:
# Beim Storno einer Buchung mit einer Kostenumlage werden bei Bedarf (Umbuchung in Kostenumlage aktiviert)
# zwei Buchungen storniert: Storno Buchung (wie immer), "Storno Umbuchung der Kostenumlage" (kann auch durch eine
# Kostenumlage an der Storno-Fibu-Buchung oder durch den Storno der ursprünglichen Kostenumlage realisiert werden)
# zunächst unnötig kompliziert uo: Buchungsstorno nur möglich, wenn keine KM in Buchung vorhanden. 
# meldung 9962: bitte zuerst kostenumlage stornieren
#  9662 de   |Bitte zuerst die abhängigen Kostenumlage(n) stornieren.
# STORNO WÄRE JETZT ERLAUBT, ABER HIER NICHT MACHEN, SONST ÄNDERN SICH DIE TESTDATEN FÜR DIE FOLGEPROZESSE:
#     Given opening an editor from table "(Entry):(Entry)" with command "REVERSAL" for record from editor "buchung1_2km_faehige_zeilen" throws the exception "9662"


# c) sy
# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373:
# Bei "Buchung ändern" mit normalem Passwort sind das Kostenobjekt änderbar.
# Dieses darf nicht geändert werden, wenn an dieser Zeile eine Kostenumlage
# "mit Umbuchung" hängt. derzeitige meldungsnr 2596.uo: ohne umbuchung die
# änderung explizit zulassen (refinement 6.11.)
Given I open an editor "buchung1_2km_faehige_zeilen_upd" from table "(Entry):(Entry)" with command "UPDATE" for record from editor "buchung1_2km_faehige_zeilen"
Then field "kstelle" is not modifiable in row 2
# zusatzplausi beim speichern: And I set field "kstelle" to "112" in row 2
# zusatzplausi beim speichern: And saving the current editor throws the exception "2596"
# And I set field "projekt" to "proj2" in row 2
# And saving the current editor throws the exception "2596"

# c1) diese plausis sind eigentlich schon ohne kostenumlagen aktiv. werden hier nochmals geprüft, weil sie bei 
#     kostenumlagen auf jeden fall noch funktionieren müssen! 
# einfügen oder löschen auch anderer Zeilen, ohne Kostenumlagen muss verboten sein, sonst wird der
# zeilenverweis in der kostenumlage auf die buchungszeile ungültig. die zeilennr darf nicht ändern!
# hier ohne wartung
#  294 u. 295 sind die allg. standardverbotstexte für zeile einfügen und zeile löschen,
#  da auch ohne kostenumlage das einfügen oder löschen von zeilen ohne wartung nicht erlaubt ist. 
And creating a new row at position 1 throws the exception "294"
And creating a new row at position 2 throws the exception "294"
And creating a new row at position 3 throws the exception "294"
And creating a new row at position 4 throws the exception "294"
And creating a new row at position 5 throws the exception "294"
And deleting the row at position 1 throws the exception "295"
And deleting the row at position 2 throws the exception "295"
And deleting the row at position 3 throws the exception "295"
And deleting the row at position 4 throws the exception "295"
And deleting the row at position 5 throws the exception "295"

And I close the current editor

# d) sy
# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373:
# PROJEKT WIE KOSTENSTELLE BEHANDELN
# Bei "Buchung ändern" mit normalem Passwort sind das Kostenobjekt änderbar.
# Dieses darf nicht geändert werden, wenn an dieser Zeile eine Kostenumlage
# "mit Umbuchung" hängt. derzeitige meldungsnr 2596.uo: ohne umbuchung die
# änderung explizit zulassen (refinement 6.11.)
Given I open an editor "buchung1_2km_faehige_zeilen_upd" from table "(Entry):(Entry)" with command "UPDATE" for record from editor "buchung1_2km_faehige_zeilen"
Then field "projekt" is not modifiable in row 2
# And I set field "projekt" to "proj2" in row 2
# And saving the current editor throws the exception "2596"
And I close the current editor

# ---------------------------------------------------------------------------------------------
Scenario: und jetzt die selben plausis in wartung
# ---------------------------------------------------------------------------------------------
Given I'm logged in with password "annette"
Given I set the fake date to "02.01.2002"

#    4 x dito, aber in wartung

# plausi a) in wartung
# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373:
# Es ist abgesichert, dass eine Buchungszeile nur Quelle für eine aktive (nicht stornierte) Kostenumlage sein
# kann (a: Fehlermeldung derziet 8339). technisch wird das durch den eintrag und die löschung des 
# kostenumlageverweises (b) in der buchungszeile realisiert.
# hier plausi a)
Given I open an editor "kostenuml-plausi-8339" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "1km"
And I set field "umlagebuchung" to id from editor "buchung_1km_faehige_bilanzzeile"
And setting field "umlagebuzeile" to "1" throws the exception "8339"
And I close the current editor

# plausi b) in wartung
# storno der buchung verboten bei verwendung 
# einer buchungszeile aus einer fibu-buchung in einer kostenumlage
# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373
# Beim Storno einer Buchung mit einer Kostenumlage werden bei Bedarf (Umbuchung in Kostenumlage aktiviert)
# zwei Buchungen storniert: Storno Buchung (wie immer), "Storno Umbuchung der Kostenumlage" (kann auch durch eine
# Kostenumlage an der Storno-Fibu-Buchung oder durch den Storno der ursprünglichen Kostenumlage realisiert werden)
# zunächst unnötig kompliziert uo: Buchungsstorno nur möglich, wenn keine KM in Buchung vorhanden. 
# meldung 9962: bitte zuerst kostenumlage stornieren
#  9662 de   |Bitte zuerst die abhängigen Kostenumlage(n) stornieren.
# STORNO WÄRE JETZT ERLAUBT, ABER HIER NICHT MACHEN, SONST ÄNDERN SICH DIE TESTDATEN FÜR DIE FOLGEPROZESSE:
#   Given opening an editor from table "(Entry):(Entry)" with command "REVERSAL" for record from editor "buchung1_2km_faehige_zeilen" throws the exception "9662"

# plausi c) in wartung
# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373:
# Bei "Buchung ändern" mit normalem Passwort sind das Kostenobjekt änderbar.
# Dieses darf nicht geändert werden, wenn an dieser Zeile eine Kostenumlage
# "mit Umbuchung" hängt. derzeitige meldungsnr 2596.uo: ohne umbuchung die
# änderung explizit zulassen (refinement 6.11.)
Given I open an editor "buchung1_2km_faehige_zeilen_upd_w" from table "(Entry):(Entry)" with command "UPDATE" for record from editor "buchung1_2km_faehige_zeilen"
Then field "kstelle" is not modifiable in row 2
# zusatzplausi beim speichern: And I set field "kstelle" to "112" in row 2
# zusatzplausi beim speichern: And saving the current editor throws the exception "2596"
And I close the current editor

# c1) steht weiter unten bei den sonderprüfung zu wartung, weil nur dann zeilen eingefügt oder 
#     gelöscht werden können

# plausi d) in wartung
# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373:
# PROJEKT WIE KOSTENSTELLE BEHANDELN
# Bei "Buchung ändern" mit normalem Passwort sind das Kostenobjekt änderbar.
# Dieses darf nicht geändert werden, wenn an dieser Zeile eine Kostenumlage
# "mit Umbuchung" hängt. derzeitige meldungsnr 2596.uo: ohne umbuchung die
# änderung explizit zulassen (refinement 6.11.)
Given I open an editor "buchung1_2km_faehige_zeilen_upd_w" from table "(Entry):(Entry)" with command "UPDATE" for record from editor "buchung1_2km_faehige_zeilen"
Then field "projekt" is not modifiable in row 2
# And I set field "projekt" to "proj2" in row 2
# And saving the current editor throws the exception "2596"
And I close the current editor

# ---------------------------------------------------------------------------------------------
Scenario: jetzt spezielle wartungsplausis, die nur durch kostenumlagen in wartung hinzukommen
# ---------------------------------------------------------------------------------------------
# wartung muss offenbar pro scenario oder unmittelbar vor dem relevanten kommando erzeugt werden.  
Given I'm logged in with password "annette"
Given I set the fake date to "02.01.2002"


# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373:
# Bei "Buchung ändern" in Wartung kann normalerweise die ganze Buchungszeile
# gelöscht werden. das ist nun zu verbieten, wenn an dieser Zeile eine
# Kostenumlage hängt. uo: hier umbuchung nicht relevant für die änderbarkeit,
# weil in BU alles geändert werden könnte.
Given I open an editor "buchung1_2km_faehige_zeilen_del_row" from table "(Entry):(Entry)" with command "UPDATE" for record from editor "buchung1_2km_faehige_zeilen"
# And I wait for file cucudbg for debugging

# c1) (wartung) zusätzlich
# einfügen oder löschen auch anderer Zeilen, ohne Kostenumlagen muss verboten sein, sonst wird der
# zeilenverweis in der kostenumlage auf die buchungszeile ungültig. die zeilennr darf nicht ändern!
# auch nicht in wartung
#  2595,1753 u. 2596 sind die SPEZIELLEN verbotstexte für zeile einfügen und zeile löschen wg. kostenumlage
#  d.h. hier in wartung wirkt die normale plausi nicht. hier muss die spezielle "einspringen"
And creating a new row at position 1 throws the exception "2595"
And creating a new row at position 2 throws the exception "2595"
And creating a new row at position 3 throws the exception "2595"
And creating a new row at position 4 throws the exception "2595"
And creating a new row at position 5 throws the exception "2595"
And deleting the row at position 1 throws the exception "1753"
# zeile 2 mit kostenumlage hat nochmals eine eigene meldung / eigenen löschschutz
And deleting the row at position 2 throws the exception "2596"
And deleting the row at position 3 throws the exception "1753"
And deleting the row at position 4 throws the exception "1753"
And deleting the row at position 5 throws the exception "1753"
And I close the current editor

# wartung ist hier noch aktiv


# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373:
# Bei "Buchung ändern" in Wartung ist normalerweise das Konto,
# Kostenobjekt und der Buchungsbetrag änderbar. Diese Änderungen
# dürfen nicht geändert werden, wenn an dieser Zeile eine Kostenumlage
# hängt. uo: hier umbuchung nicht relevant für die änderbarkeit, weil
# in BU alles geändert werden könnte., projekt separat
#  hier konto
Given I open an editor "buchung_1km_faehige_bilanzzeile_upd_konto" from table "(Entry):(Entry)" with command "UPDATE" for record from editor "buchung_1km_faehige_bilanzzeile"
Then field "konto" is not modifiable in row 1
# zusatzplausi And I set field "konto" to "10011" in row 1
# zusatzplausi And saving the current editor throws the exception "2596"
And I close the current editor

# wartung ist hier noch aktiv

# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373:
# gehört noch zur letzten kriterienbeschreib.  oberhalb..   hier betrag
Given I open an editor "buchung_1km_faehige_bilanzzeile_upd_konto" from table "(Entry):(Entry)" with command "UPDATE" for record from editor "buchung_1km_faehige_bilanzzeile"
Then field "ewhbetr" is not modifiable in row 1
Then field "ewsbetr" is modifiable in row 2
# And I set field "ewhbetr" to "44" in row 1
# And I set field "ewsbetr" to "44" in row 2
# And saving the current editor throws the exception "2596"
And I close the current editor

# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373:
# gehört noch zur letzten kriterienbeschreib.  oberhalb..  hier betrag
Given I open an editor "buchung_1km_faehige_bilanzzeile_upd_konto" from table "(Entry):(Entry)" with command "UPDATE" for record from editor "buchung_1km_faehige_bilanzzeile"
Then field "hbetrag" is not modifiable in row 1
Then field "sbetrag" is modifiable in row 2
# And I set field "hbetrag" to "44" in row 1
# And I set field "sbetrag" to "44" in row 2
# And saving the current editor throws the exception "2596"
And I close the current editor

Given I open an editor "buchung1_2km_faehige_zeilen_upd_w_budat" from table "(Entry):(Entry)" with command "UPDATE" for record from editor "buchung1_2km_faehige_zeilen"
# meldung 2596
Then field "budat" is not modifiable
# And I set field "budat" to "9.1.2"
# And saving the current editor throws the exception "2596"
And I close the current editor

Given I open an editor "buchung1_2km_faehige_zeilen_upd_w_erfwaehr" from table "(Entry):(Entry)" with command "UPDATE" for record from editor "buchung1_2km_faehige_zeilen"
# meldung 2596
Then field "erfwaehr" is not modifiable
# And I set field "erfwaehr" to "CAD"
# And saving the current editor throws the exception "2596"
And I close the current editor

# ------------------------------------------------------------------------------------------------------
Scenario: Plausi: Kostenumlage erzeugen für eine Buchungszeile aus einer EK-Rechnung ist NICHT ERLAUBT 
# ------------------------------------------------------------------------------------------------------
Given I'm logged in with password "sy"
Given I set the fake date to "02.01.2002"

# Zusatzposition Transport
Given I open an editor "zusatzp_transport" from table "(Part):(SupplementaryItem)" with command "NEW" for record ""
And I set field "nummer" to "1transp"
And I set field "such" to "transport"
And I set field "name" to "transportkosten"
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-134" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "134-RE"
And I set field "lief" to "1"
And I set field "erfwaehr" to "eur"
And I set field "vom" to "."
And I set field "ueb" to "ja"
# And I set field "kenn" to "FALL-134"
And I create a new row at the end of the table
And I set field "artex" to "transport" in row 1
And I set field "pwert" to "134" in row 1
And I set field "kstelle" to "113" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373:
# aus bw2-1359 vom. 4.11.20 uh:, Wenn die Buchung aus einer EK-Rechnung kommt,
# dann kann hier keine KM angelegt werden und wir verweisen den Anwender mit einer Meldung
# zurück zur Rechnung, damit er dort die KM anlegt (auf Grundlage einer EK-RE-Position als Quelle)

# Kostenumlage erzeugen, auf EK-Buchung ist NICHT ERLAUBT 
Given I open an editor "kostenuml_aus_EK_ueber_fibu_nicht_erlaubt" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "1not"
# 1980 de   |Kosten aus dem Einkauf bitte über die Einkaufsposition umlegen.
And setting field "umlagebuchung" to "$,,ursacheref==4 +134-RE;ursache==Einkauf;@gruppe=0;@datenbank=6" throws the exception "1980"
And I close the current editor


# -----------------------------------------------------------------------------------------
Scenario: fortsetzung km-prozesse 
# -----------------------------------------------------------------------------------------
Given I'm logged in with password "sy"
Given I set the fake date to "02.01.2002"

# Kostenumlage erzeugen, 1-zeilig 
Given I open an editor "kostenuml-abweichende-konten-mit-umb" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "3km"
And I set field "umlagebuchung" to id from editor "buchung1_2km_faehige_zeilen"
And I set field "umlagebuzeile" to "3"
# And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer==2ls;artex=E1A-PO;@gruppe=2;@datenbank=4" in row !lastRow
And I set field "proz" to "100" in row !lastRow
#  8878 de   |Abweichende Konten in Kopf und Tabelle der Kostenumlage. Umbuchung durchfhren.
And saving the current editor throws the exception "8878"
And I set field "fibuumbuch" to "ja"
And I save the current editor


# -----------------------------------------------------------------------------------------
Scenario: guv-konto in kostenumlagetabelle 
# -----------------------------------------------------------------------------------------

# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373:
# Bei "Buchung ändern" mit normalem Passwort sind das Kostenobjekt änderbar. Dieses darf
# nicht geändert werden, wenn an dieser Zeile eine Kostenumlage "mit Umbuchung" hängt.
# (refinement 6.11.)
# in diesem scenario wird der fall ohne umbuchung getestet:
#  ohne umbuchung in der kostenumlage die änderung des kostenobjektes in 
#  der finanzbuchung explizit zulassen (refinement 6.11.),

# + Projektkostenrechnung und Plausi dazu

Given I'm logged in with password "sy"
Given I set the fake date to "04.02.2002"

# Fibu-buchung mit einer (1) kostenumlagefähige Zeile

Given I open an editor "buchung_1km_faehige_bilanzzeile2" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "bu3kmbil"
And I set field "budat" to "15.01.02"
And I create a new row at the end of the table
And I set field "konto" to "10000" in row !lastRow
And I create a new row at the end of the table
And I set field "konto" to "50015" in row !lastRow
And I set field "ewsbetr" to "20" in row !lastRow
And I set field "kstelle" to "111" in row !lastRow
And I set field "projekt" to "proj2" in row !lastRow
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor

Given I open an editor "teil-beist" from table "(Part):(Product)" with command "NEW" for record ""
And I set field "nummer" to "1beistart"
And I set field "such" to "beistek"
And I create a new row at the end of the table
And I set field "elex" to "E1A-VM" in row !lastRow
And I set field "elanzahl" to "2" in row !lastRow
And I set field "lge" to "100" in row !lastRow
And I set field "breite" to "80" in row !lastRow
And I set field "bua" to "lieferantenbeistellung" in row !lastRow
And I save the current editor

# Rechnung anlegen
Given I open an editor "rechnung-135" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "num4" to "135-RE"
And I set field "lief" to "1"
And I set field "erfwaehr" to "eur"
And I set field "vom" to "."
And I set field "ueb" to "ja"
# And I set field "kenn" to "RE-135"
And I create a new row at the end of the table
And I set field "artex" to "BEISTEK" in row 1
And I set field "mge" to "1" in row 1
And I set field "preis" to "5" in row 1
And I set field "kstelle" to "115" in row 1
And I set field "projekt" to "proj2" in row 1
And I set field "konto" to "50015" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# ------ nachbewerten für abgänge zu den zugängen von 1km und 2km (hier speziell beistellabgang, fall 120) --------
#  tut sich da was in der abgangskette?... nein, was auch wg. MPR im abgang zumindest bisher so ist.
#  das hängt ja davon ab, ob eine kostenumlage im zugang der MPR von 0 erhöht/ändert oder erst wenn der MPR>0 ist
#  oder diesen gar nicht ändert.
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Kostenumlage erzeugen, 1-zeilig 
Given I open an editor "kostenuml-guv-in-tabelle" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "4km"
And I set field "umlagebuchung" to id from editor "buchung_1km_faehige_bilanzzeile2"
And I set field "umlagebuzeile" to "2"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer==135-RE;artex=BEISTEK;@gruppe=2;@datenbank=4;@ablageart=abgelegt" in row !lastRow
And I set field "proz" to "100" in row !lastRow
#
# mit fibuumbuch = nein und ohne respond 2911 (früher 9425) kam es zu einer ADM.FEHL  
#  das ist aber der benötigte testfall.
# völlig unerklärlich, irgendwas mit EFOP und maskaus ...
# es ist ein bekannter fehler in epi od. cucumber, dass es anstatt einer fehlermeldung eine diag gibt.
# klärungsdetails mit xg in https://jira.abasag.intra/browse/BW2-1391
And I respond with answer "Nein" to the dialog with id "2911"
And I save the current editor

# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373:
# Bei "Buchung ändern" mit normalem Passwort sind das Kostenobjekt änderbar. Dieses darf
# nicht geändert werden, wenn an dieser Zeile eine Kostenumlage "mit Umbuchung" hängt.
# (refinement 6.11.)
# in diesem scenario wird der fall ohne umbuchung getestet:
#  ohne umbuchung in der kostenumlage die änderung des kostenobjektes in 
#  der finanzbuchung explizit zulassen (refinement 6.11.),

Given I open an editor "buchung_1km_faehige_bilanzzeile2_kst" from table "(Entry):(Entry)" with command "UPDATE" for record from editor "buchung_1km_faehige_bilanzzeile2"
Then field "umgelegtinkm" has value "+4km" in row 2
And I set field "kstelle" to "112" in row 2
And I respond with answer "yes" to the dialog with id "583"
And I save the current editor

# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373:
#  PROJEKT BEHANDELN WIE KOSTENOBJEKT / KOSTENSTELLE
#  änderung zulassen:
Given I open an editor "buchung_1km_faehige_bilanzzeile2_proj" from table "(Entry):(Entry)" with command "UPDATE" for record from editor "buchung_1km_faehige_bilanzzeile2"
Then field "umgelegtinkm" has value "+4km" in row 2
And I set field "projekt" to "proj3" in row 2
And I respond with answer "yes" to the dialog with id "583"
And I save the current editor

# -----------------------------------------------------------------------------------------
Scenario: Zeitraum des Buchungsdatum in Kostenumlage ändern (mit Zeitraumplausi: Änderungsverbot)    
# -----------------------------------------------------------------------------------------
# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373 
# Die Umbuchung der Kostenumlage mit der Quell "Buchungszeile" orientiert sich am 
# Fibu-Monatsabschluss (und nicht wie sonst am Einkaufs-Monatsabschluss).
# uo: die kostenumlagen kann kein buchungsdatum verwenden, wenn dieses in einen 
#  geschlossenen zeitraum des moduls fällt, aus dem die kosten kommen
#  also EK oder FB (fibu).
#  hier wird das verbot als auch die erlaubnis der änderung des zeitraums 
#  und die verwendung des geänderten buchungsdatum geprüft.

Given I'm logged in with password "sy"
Given I set the fake date to "05.02.2002"

# Fibu-buchung die später gleich in abgeschlossenen zeitraum wandert damit
# das feld kmbudat (budat) im kopf der kostenumlage änderbar wird.

Given I open an editor "buchung_km_faehig_fuer_abgeschl_monat" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "buabgeschl"
And I set field "budat" to "15.12.01"
And I create a new row at the end of the table
And I set field "konto" to "10002" in row !lastRow
And I create a new row at the end of the table
# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1363
# wichtig!!! wenigstens 1x den umlagebetrag aus dem haben holen wg. vorzeichen!!! nicht ändern!!
# die zeile wird weiter unten umgelegt/verwendet
And I set field "konto" to "50014" in row !lastRow
And I set field "ewhbetr" to "3" in row !lastRow
And I set field "kstelle" to "113" in row !lastRow
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

Given I open an editor "Abschl" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set field "such" to "nachbuch01zu"
And I press button "fbbbu" in row 3
And I press button "mbbbu" in row 4
And I respond with answer "Ja" to the dialog with id "7626"
And I save the current editor

# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1373 
# hier der eigentliche test: überwachung des buchungsdatums auf offenen zeitraum in der fibu...

# Kostenumlage erzeugen, 1-zeilig 
Given I open an editor "kostenuml-kmbudat-plausi" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "5zeitr"
And I set field "umlagebuchung" to id from editor "buchung_km_faehig_fuer_abgeschl_monat"
# Akzeptanzkrit. aus https://jira.abasag.intra/browse/BW2-1363
And I set field "umlagebuzeile" to "2"

# hier das verbot prüfen - bis zur plausi beim speichern kommt man hier gar nicht.
#                                                             50 de   |Zeitraum ist schon abgeschlossen
And setting field "budat" to "04.11.01" throws the exception "50"

# .. und jetzt die erlaubte änderung und verwendung prüfen, also speichern und add. kosten an
#   bewertung weitergeben. das sieht man dann in referenzdatei.
And I set field "budat" to "14.02.02"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer==2ls;artex=E1A-PO;@gruppe=2;@datenbank=4" in row !lastRow
And I set field "proz" to "100" in row !lastRow
And I set field "fibuumbuch" to "ja"
And I save the current editor

#  Given I open an editor "Abschl" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
#  And I set field "such" to "nachbuch01auf"
#  And I press button "fbbbu" in row 1
#  And I respond with answer "Ja" to the dialog with id "7626"
#  And I save the current editor
#  
#  # ------ nachbewerten ---------------
#  Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
#  And I close the current editor

# -----------------------------------------------------------------------------------------
Scenario: Plausi: statistische buchungen nicht erlaubt   
# -----------------------------------------------------------------------------------------
Given I'm logged in with password "sy"
Given I set the fake date to "06.02.2002"

# stat. bu anlegen
Given I open an editor "stat_buchung" from table "(Entry):(StatisticalEntry)" with command "NEW" for record ""
And I set field "such" to "stat"
And I set field "budat" to "15.2.02"
And I create a new row at the end of the table
And I set field "konto" to "99800" in row !lastRow
And I set field "sbetrag" to "2" in row !lastRow
And I set field "kstelle" to "110" in row !lastRow
And I create a new row at the end of the table
And I set field "konto" to "99900" in row !lastRow
And I set field "hbetrag" to "2" in row !lastRow
And I set field "kstelle" to "111" in row !lastRow
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor

# km damit versuchen ....
# Kostenumlage erzeugen, 1-zeilig 
# macht mehr ärger als der test wert ist. manueller test und P6:0 reichen aus. # Given I open an editor "kostenuml-kmbudat-plausi" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
# macht mehr ärger als der test wert ist. manueller test und P6:0 reichen aus. # And I set field "num135" to "6statpl"
# macht mehr ärger als der test wert ist. manueller test und P6:0 reichen aus. # #  1646 de   |Falsche Gruppe
# macht mehr ärger als der test wert ist. manueller test und P6:0 reichen aus. # #  kommt vor 10622 ungültige gruppe, weil der verweis P6:0 ist, wird schon grundsätzlich abgefangen
# macht mehr ärger als der test wert ist. manueller test und P6:0 reichen aus. # #  geht nicht And setting field "umlagebuchung" to id from editor "stat_buchung" throws the exception "1646"
# macht mehr ärger als der test wert ist. manueller test und P6:0 reichen aus. # And setting field "umlagebuchung" to "$,,@datenbank=6;@gruppe=1;such==stat" throws the exception "1646"
# macht mehr ärger als der test wert ist. manueller test und P6:0 reichen aus. # And I close the current editor

# -----------------------------------------------------------------------------------------
Scenario: Plausi: Buchungstyp Verbotsfall
# -----------------------------------------------------------------------------------------
Given I'm logged in with password "annette"
Given I set the fake date to "06.02.2002"

# Akzeptanzkrit.: Positivliste für die Buchungen:Buchungstyp: bubutyp
# "Allgemeine Finanzbuchung"
# "Rechnungsbuchung" mit der Buchungsursache "manuell"
# positivfälle gibt es oben genug... hier wir der verbotsfall getestet

Given I open an editor "eröffnungsphase_öffnen" from table "(Company):(FinancialDates)" with command "UPDATE" for record "TERM"
# das steht bis hierher drin: 02.01.02
And I set field "erend" to ""
And I save the current editor

Given I open an editor "buchung_NICHT_km_faehig_wg_butyp" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "butypplaus"
And I set field "budat" to "03.02.02"
And I create a new row at the end of the table
And I set field "konto" to "10010" in row !lastRow
And I create a new row at the end of the table
And I set field "konto" to "50018" in row !lastRow
And I set field "ewsbetr" to "2" in row !lastRow
And I set field "kstelle" to "113" in row !lastRow
And I respond with answer "Ja" to the dialog with id "1941"
And I save the current editor

Given I open an editor "buchung_NICHT_km_faehig_wg_butyp_view" from table "(Entry):(Entry)" with command "VIEW" for record "butypplaus"
Then field "butyp" has value "Eröffnungsbuchung"
And I close the current editor

Given I'm logged in with password "sy"
Given I set the fake date to "06.02.2002"

Given I open an editor "eröffnungsphase_beenden" from table "(Company):(FinancialDates)" with command "UPDATE" for record "TERM"
And I set field "erend" to "02.01.02"
And I save the current editor

Given I open an editor "kostenuml-kmbutyp-plausi" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "7plbutyp"
And setting field "umlagebuchung" to "butypplaus" throws the exception "2591"
And I close the current editor

# -----------------------------------------------------------------------------------------
Scenario: Storno einer Kostenumlage: löschung des KM-eintrages in der finanzbuchungszeile
# -----------------------------------------------------------------------------------------
# Akzeptanzkrit.: 
# Es ist abgesichert, dass eine Buchungszeile nur Quelle für eine aktive (nicht stornierte)
# Kostenumlage sein kann (a: Fehlermeldung derzeit meldung 8339). technisch wird das durch 
# den eintrag und die löschung des kostenumlageverweises (b) in der buchungszeile realisiert.
# HIER:
# Absicherung Fall b) zu weit oberhalb: löschung des KM-eintrages in der finanzbuchungszeile
# nach storno der kostenumlage

Given I'm logged in with password "sy"
Given I set the fake date to "06.02.2002"

Given I open an editor "storno-7kmstorn" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+7kmplaus"
And I set field "num135" to "7kmstorn"
# And I wait for file cucudbg for debugging
And saving the current editor throws the exception "50"
And I close the current editor

Given I open an editor "Abschl_wieder_öffnen" from table "(FiscalYearManagement):(Closings)" with command "NEW" for record ""
And I set field "such" to "jan-wied-auf"
And I press button "mbbbu" in row 4
And I respond with answer "Ja" to the dialog with id "7626"
And I save the current editor

Given I open an editor "storno-7kmstorn" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+7kmplaus"
And I set field "num135" to "7kmstorn"
# And I wait for file cucudbg for debugging
And I save the current editor
And I close the current editor

# -------------------------------------------------------------------------------------------------------
Scenario: Storno einer Buchung aus Kostenumlage nicht erlaubt
# -------------------------------------------------------------------------------------------------------
Given I set the fake date to "06.02.2002"
And opening an editor from table "(Entry):(Entry)" with command "REVERSAL" for record "4" throws the exception "10307"

# -------------------------------------------------------------------------------------------------------
Scenario: Kostenumlageverweis wird aus Buchungsvorlagen entfernt
# -------------------------------------------------------------------------------------------------------
Given I set the fake date to "06.02.2002"

# zustand ausgangsbasis (fibu) sicherstellen: mit mind. einem kostenumlageverweis
Given I open an editor "fibuview1" from table "(Entry):(Entry)" with command "VIEW" for record "BU1"
Then field "umgelegtinkm" is empty in row 1
Then field "umgelegtinkm" is not empty in row 2
Then field "umgelegtinkm" is not empty in row 3
Then field "umgelegtinkm" is empty in row 4
Then field "umgelegtinkm" is empty in row 5
And I close the current editor

# finanzbuchung in buchungsvorschlag überführen (durch freigabe)
Given I open an editor "fibu2buvorschlag" from table "(Entry):(Entry)" with command "RELEASE" for record "BU1"
And I respond with answer "Ja" to the dialog with id "7709"
And I save the current editor

# kontrolle:  alle kostenumlageverweise müssen leer sein.
Given I open an editor "buvorschlagview1" from table "(RecurringEntry):(FinancialEntryTemplate)" with command "VIEW" for record "BU1"
Then field "umgelegtinkm" is empty in row 1
Then field "umgelegtinkm" is empty in row 2
Then field "umgelegtinkm" is empty in row 3
Then field "umgelegtinkm" is empty in row 4
Then field "umgelegtinkm" is empty in row 5
And I close the current editor

# -------------------------------------------------------------------------------------------------------
Scenario: Kostenumlageverweis muß beim Kopieren einer Buchung entfernt werden
# -------------------------------------------------------------------------------------------------------
Given I set the fake date to "06.02.2002"

Given I open an editor "fibukopie1" from table "(Entry):(Entry)" with command "COPY" for record "BU3KMBIL"
And I set field "such" to "K1BU3KMBIL"
And I set field "text" to "feld umlagebuchung muss beim kopieren geleert werden und leer gespeichert werden."
Then field "umgelegtinkm" is empty in row 1
Then field "umgelegtinkm" is empty in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

# -------------------------------------------------------------------------------------------------------
Scenario: Kostenumlagen zeigen ist auch nach nach entfernung des Buchungsverweises und der Buchungszeilenangabe stabil
#   das ist dann relevant, wenn Fibu-Buchungen mittels Buchungssynchronisation gelöscht werden. 
#   möglich ist das ab version 2019r4 bzw. 2100
# -------------------------------------------------------------------------------------------------------
Given I set the fake date to "06.02.2002"

# buchungskopie erstellen
Given I open an editor "fibukopie2" from table "(Entry):(Entry)" with command "COPY" for record "BU3KMBIL"
And I set field "such" to "K2BU3KMBIL"
And I set field "text" to "diese buchung (feld umlagebuchungin KM) wird zum anzeigetest (VIEW) manipulativ aus der kostenumlage 8buentf entfernt"
Then field "umgelegtinkm" is empty in row 1
Then field "umgelegtinkm" is empty in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

# kostenumlage für buchung K2BU3KMBIL
Given I open an editor "kostenuml-bu-entfernen" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "8buentf"
And I set field "umlagebuchung" to id from editor "fibukopie2"
And I set field "umlagebuzeile" to "2"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer==2ls;artex=E1A-PO;@gruppe=2;@datenbank=4" in row !lastRow
And I set field "proz" to "100" in row !lastRow
And I set field "fibuumbuch" to "ja"
And I save the current editor

# buchung aus kostenumlage entfernen
Given I'm logged in with password "annette"
Given I enable the flag 71
Given I set the fake date to "06.02.2002"
Given I open an editor "kostenuml-buchung-loeschen" from table "(CostDistribution):(CostDistribution)" with command "MODIFY" for record "+8buentf"
And I set field "umlagebuchung" to ""
And I set field "umlagebuzeile" to ""
And I save the current editor
Given I disable the flag 71
Given I'm logged in with password "sy"

Given I set the fake date to "06.02.2002"

# kostenumlage kann ohne quellinformationen (hier ohne umlagebuchung) angezeigt werden. 
# es kommt nicht zu einem fehler und auch zu keiner diag 
Given I open an editor "kostenuml-buchung-loeschen" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+8buentf"
Then field "umlagebuchung" is empty
# tut nicht und anderen varianten auch nicht.     Then field "umlagebuzeile" is empty
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
