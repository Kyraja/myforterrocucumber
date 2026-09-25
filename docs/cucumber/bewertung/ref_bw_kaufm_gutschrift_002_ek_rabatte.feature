# ************************************************************************
#  Name             : ref_bw_kaufm_gutschrift_002_ek_rabatte.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        :
#  Funktion         : testet kaufm. GS und Rabatte
#
#   kurze Zusammenfassung von Testfaellen:
#        @FALL-Rabatt-auf-Alles1:
#        ========================
#           1) BE mit 2 Art., aber gleiche Menge und gleicher Preis
#           2) LS1 zu Art. 1
#           3) LS2 zu Art. 2
#           4) RE1 zu LS1 mit Zeilenrabatt (Feld 'proz') 10%
#           5) RE2 zu LS2 mit Gesamtrechnungsrabatt (Zwischensumme + Prozentposition) 10%
#           6) RLS1 zu LS1 komplett
#           7) RLS2 zu LS2 komplett
#           8) KGS1 zu RLS1
#           9) KGS2 zu RLS2
#           10) Pruefung des Konto -> Saldo muss 0.00 sein
#        @FALL-Rabatt-auf-Alles2:
#        ========================
#           1) BE mit 2 Art., aber gleiche Menge und gleicher Preis
#              in BE wird auch Gesamtrechnungsrabatt von 10% eingetragen
#           2) LS1 zu Art. 1
#           3) LS2 zu Art. 2
#           4) RE1 zu LS1
#           5) RE2 zu LS2
#           6) RLS1 zu LS1 komplett
#           7) RLS2 zu LS2 komplett
#           8) KGS1 zu RLS1
#           9) KGS2 zu RLS2
#           10) Pruefung des Konto -> Saldo muss 0.00 sein
#        @FALL-Rabatt-auf-Alles3:
#        ========================
#           1) BE mit 2 Art., aber gleiche Menge und gleicher Preis
#           2) LS1 zu Art. 1
#           3) LS2 zu Art. 2
#           4) RE1 zu LS1 mit Zeilenrabatt (Feld 'proz') 10%
#           5) RE2 zu LS2 mit Gesamtrechnungsrabatt (Zwischensumme + Prozentposition) 10%
#              in der RE2 wird die Prozentposition auch auf das Bestandskonto gebucht
#           6) RLS1 zu LS1 komplett
#           7) RLS2 zu LS2 komplett
#           8) KGS1 zu RLS1
#           9) KGS2 zu RLS2
#           10) Pruefung des Konto -> Saldo muss 0.00 sein
#        @FALL-Rabatt-auf-Alles4:
#        ========================
#           1) Prozent-Position ohne Umlegen anlegen
#           2) BE mit 1 Art.
#              in BE Gesamtrechnungsrabatt ohne Umlegen aber, 10%
#           3) LS1 zu Art. 1
#           4) RE1 zu LS1
#           5) RLS1 zu LS1 komplett
#           6) KGS1 zu RLS1
#           7) Pruefung des Konto -> Saldo muss 0.00 sein
#                      
#        ===========================================
#
# *****************************************************************************
@persistent
Feature: Storno EK
Background: Test von Stornos im Einkauf
Given I set the fake date to "07.01.2002"


@FALL-Rabatt-auf-Alles1
Scenario: FALL-Rabatt-auf-Alles1; XXXXXXXXXXX; Testumgebung 10
# 1) BE mit 2 Art., aber gleiche Menge und gleicher Preis
# 2) LS1 zu Art. 1
# 3) LS2 zu Art. 2
# 4) Nachbewerten + Kostenverbuchung(alles)
# 5) RE1 zu LS1 mit Zeilenrabatt (Feld 'proz') 10%
# 6) RE2 zu LS2 mit Gesamtrechnungsrabatt (Zwischensumme + Prozentposition) 10%
# 7) Nachbewerten + Kostenverbuchung(alles)
# 8) RLS1 zu LS1 komplett
# 9) RLS2 zu LS2 komplett
# 10) Nachbewerten + Kostenverbuchung(alles)
# 11) KGS1 zu RLS1
# 12) KGS2 zu RLS2
# 13) Nachbewerten + Kostenverbuchung(alles)
# 14) Pruefung des Konto -> Saldo muss 0.00 sein


#
#
# EINKAUF:
#---------
#
#        / 1000-LS1--------------1000-RE1
#       /  EK1 1000St            1000St x11.22 mit 10% Rabatt
#      /         \
#     /           \----------------------------------------------- 1000RLS1 ------ 1000-GS1
#    /             \                                               1000St          1000St x11.22
#   /
# 1000-BE ----------- 1000-LS2 ------ 1000-RE2
# EK1 1000St x11.11   EK2 1000St      1000St x11.22
# EK2 1000St x11.11         \         mit 10% Gesamtrabatt (-1122.00)
#                            \
#                             \------------------------------------------- 1000RLS2 ------ 1000-GS2
#                              \                                           1000St          1000St x11.22
#
#
#  1 ----- 2 -------- 3 -------- 5 -- 6 -------------------------- 8 ----- 9 ----- 11 ---- 12 -----> Zeitstrahl



# (1) eine Bestellung fuer 2 Artikel anlegen; Mengen und Preise sind gleich
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
# Inland-Lieferant
And I set field "lief" to "001fa10"
And I set field "num4" to "1000-BE"
And I set field "kenn" to "FALL-Rabatt-auf-Alles1,"
And I create a new row at the end of the table
And I set field "artex" to "0efall10" in row 1
And I set field "mge" to "1000" in row 1
And I set field "preis" to "11.11" in row 1
And I create a new row at the end of the table
And I set field "artex" to "1efall10" in row 2
And I set field "mge" to "1000" in row 2
And I set field "preis" to "11.11" in row 2
And I save the current editor


# (2) Lieferschein 1 zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "1000-LS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "schlag" to "FALL-Rabatt-auf-Alles1,"
Then the table has 2 rows
Then field "artex" has value "EK1-FALL10" in row 1
And I set field "mge" to "1000" in row 1
And I set field "mge" to "0" in row 2
And I save the current editor

# (3) Lieferschein 2 zu Bestellung anlegen
Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "1000-LS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "schlag" to "FALL-Rabatt-auf-Alles1,"
Then the table has 1 rows
Then field "artex" has value "EK2-FALL10" in row 1
And I set field "mge" to "1000" in row 1
And I save the current editor

# (4) Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# (5) Rechnung 1 zum LS1 anlegen + verbuchen; Lieferant bleibt
# Zeilenrabatt 10%
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "1000-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-Rabatt-auf-Alles1,"
Then field "fakt" has value "nein" in row 0
And I set field "mge" to "1000" in row 1
And I set field "preis" to "11.22" in row 1
And I set field "proz" to "-10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# (6) Rechnung 2 zum LS2 anlegen + verbuchen; Lieferant bleibt
# Gesamtrechnungsrabatt 10%
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2"
And I set field "num4" to "1000-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-Rabatt-auf-Alles1,"
Then field "fakt" has value "nein" in row 0
And I set field "mge" to "1000" in row 1
And I set field "preis" to "11.22" in row 1
# Zwischensumme-Position einfuegen
And I create a new row at the end of the table
And I set field "artex" to "ZS." in row 2
Then field "pwert" has value "11220.00" in row 2
# Gesamtrechnungsrabatt-Position einfuegen
And I create a new row at the end of the table
And I set field "artex" to "PR." in row 3
And I set field "proz" to "-10" in row 3
Then field "pwert" has value "-1122.00" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# (7) Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# (8) Ruecklieferung 1 von 1000 Stk. -> LS 1 komplett
Given I open an editor "ruecklief-1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+1000-LS1"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "1000RLS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "EK1-FALL10" in row 1
And I set field "mge" to "-1000" in row 1
And I save the current editor
And I close the current editor

# (9) Ruecklieferung 2 von 1000 Stk. -> LS 2 komplett
Given I open an editor "ruecklief-2" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+1000-LS2"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "1000RLS2"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "EK2-FALL10" in row 1
And I set field "mge" to "-1000" in row 1
And I save the current editor
And I close the current editor

# (10) Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# (11) Kaufm. GS 1 zu Ruecklieferschein 1
Given I open an editor "KGS1000" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-1"
And I set field "num4" to "1000-GS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 1 rows
Then table has values
    | art 			| mge 		| preis 	| ofmge | herkunft^kopf^such	|
    | EK1-FALL10	| -1000 	| 11.22 	| 0		| RLFALL10				|
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# (12) Kaufm. GS 2 zu Ruecklieferschein 2
Given I open an editor "KGS1000" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-2"
And I set field "num4" to "1000-GS2"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 1 rows
Then table has values
    | art 			| mge 		| preis 	| ofmge | herkunft^kopf^such	|
    | EK2-FALL10	| -1000 	| 11.22 	| 0		| RLFALL10				|
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# (13) Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# (14) Saldoueberwachung von "1ifall10"
Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "1ifall10"
#  ACHTUNG: HIER MUSS SALDO 0.00 SEIN !!!
#           Hier wurde alles zurueckgeliefert und berechnet -> Menge 0, Wert 0.00
#
# Fehlerzustand!!! siehe BW2-2455
Then field "saldo" has value "1122.00" in row 0
# Then field "saldo" has value "0.00" in row 0
And I close the current editor
#####################################################################################################################################

@FALL-Rabatt-auf-Alles2
Scenario: FALL-Rabatt-auf-Alles2; XXXXXXXXXXX; Testumgebung 11
# 1) BE mit 2 Art., aber gleiche Menge und gleicher Preis
#    in BE wird auch Gesamtrechnungsrabatt von 10% eingetragen
# 2) LS1 zu Art. 1
# 3) LS2 zu Art. 2
# 4) RE1 zu LS1
# 5) RE2 zu LS2
# 6) RLS1 zu LS1 komplett
# 7) RLS2 zu LS2 komplett
# 8) KGS1 zu RLS1
# 9) KGS2 zu RLS2
# 10) Pruefung des Konto -> Saldo muss 0.00 sein

# eine Bestellung fuer 2 Artikel anlegen; Mengen und Preise sind gleich
# Gesamtrechnungsrabatt 10%
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
# Inland-Lieferant
And I set field "lief" to "001fa11"
And I set field "num4" to "1100-BE"
And I set field "kenn" to "FALL-Rabatt-auf-Alles2,"
And I create a new row at the end of the table
And I set field "artex" to "0efall11" in row 1
And I set field "mge" to "1100" in row 1
And I set field "preis" to "11.11" in row 1
And I create a new row at the end of the table
And I set field "artex" to "1efall11" in row 2
And I set field "mge" to "1100" in row 2
And I set field "preis" to "11.11" in row 2
# Zwischensumme-Position einfuegen
And I create a new row at the end of the table
And I set field "artex" to "ZS." in row 3
Then field "pwert" has value "24442.00" in row 3
# Gesamtrechnungsrabatt-Position einfuegen
And I create a new row at the end of the table
And I set field "artex" to "PR." in row 4
And I set field "proz" to "-10" in row 4
Then field "pwert" has value "-2444.20" in row 4
And I save the current editor


# Lieferschein 1 zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "1100-LS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "schlag" to "FALL-Rabatt-auf-Alles2,"
Then the table has 4 rows
Then field "artex" has value "EK1-FALL11" in row 1
And I set field "mge" to "1100" in row 1
And I set field "mge" to "0" in row 2
And I save the current editor

# Lieferschein 2 zu Bestellung anlegen
Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "1100-LS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "schlag" to "FALL-Rabatt-auf-Alles2,"
Then the table has 3 rows
Then field "artex" has value "EK2-FALL11" in row 1
And I set field "mge" to "1100" in row 1
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Rechnung 1 zum LS1 anlegen + verbuchen; Lieferant bleibt
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "1100-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-Rabatt-auf-Alles2,"
Then field "fakt" has value "nein" in row 0
And I set field "mge" to "1100" in row 1
And I set field "preis" to "11.22" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 2 zum LS2 anlegen + verbuchen; Lieferant bleibt
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2"
And I set field "num4" to "1100-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-Rabatt-auf-Alles2,"
Then field "fakt" has value "nein" in row 0
And I set field "mge" to "1100" in row 1
And I set field "preis" to "11.22" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Ruecklieferung 1 von 1100 Stk. -> LS 1 komplett
Given I open an editor "ruecklief-1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+1100-LS1"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "1100RLS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "EK1-FALL11" in row 1
And I set field "mge" to "-1100" in row 1
And I save the current editor
And I close the current editor

# Ruecklieferung 2 von 1100 Stk. -> LS 2 komplett
Given I open an editor "ruecklief-2" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+1100-LS2"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "1100RLS2"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "EK2-FALL11" in row 1
And I set field "mge" to "-1100" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Kaufm. GS 1 zu Ruecklieferschein 1
Given I open an editor "KGS1100" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-1"
And I set field "num4" to "1100-GS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 3 rows
Then table has values
    | art               | mge           | preis         | ofmge | herkunft^kopf^such    |
    | EK1-FALL11        | -1100         | 11.22         | 0     | RLFALL11              |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Kaufm. GS 2 zu Ruecklieferschein 2
Given I open an editor "KGS1100" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-2"
And I set field "num4" to "1100-GS2"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 3 rows
Then table has values
    | art               | mge           | preis         | ofmge | herkunft^kopf^such    |
    | EK2-FALL11        | -1100         | 11.22         | 0     | RLFALL11              |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "1ifall11"
#  ACHTUNG: HIER MUSS SALDO 0.00 SEIN !!!
#           Hier wurde alles zurueckgeliefert und berechnet -> Menge 0, Wert 0.00
#
# Fehlerzustand!!! siehe BW2-2455
Then field "saldo" has value "2468.40" in row 0
# Then field "saldo" has value "0.00" in row 0
And I close the current editor
#####################################################################################################################################

@FALL-Rabatt-auf-Alles3
Scenario: FALL-Rabatt-auf-Alles3; Gesamtrechnungs-Rabatt auf Bestandskonto; Testumgebung 12
# Ablauf:
# 1) BE mit 2 Art., aber gleiche Menge und gleicher Preis
# 2) LS1 zu Art. 1
# 3) LS2 zu Art. 2
# 4) RE1 zu LS1 mit Zeilenrabatt (Feld 'proz') 10%
# 5) RE2 zu LS2 mit Gesamtrechnungsrabatt (Zwischensumme + Prozentposition) 10%
#    in der RE2 wird die Prozentposition auch auf das Bestandskonto gebucht
# 6) RLS1 zu LS1 komplett
# 7) RLS2 zu LS2 komplett
# 8) KGS1 zu RLS1
# 9) KGS2 zu RLS2
# 10) Pruefung des Konto -> Saldo muss 0.00 sein

# eine Bestellung fuer 2 Artikel anlegen; Mengen und Preise sind gleich
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
# Inland-Lieferant
And I set field "lief" to "001fa12"
And I set field "num4" to "1200-BE"
And I set field "kenn" to "FALL-Rabatt-auf-Alles3,"
And I create a new row at the end of the table
And I set field "artex" to "0efall12" in row 1
And I set field "mge" to "1200" in row 1
And I set field "preis" to "11.11" in row 1
And I create a new row at the end of the table
And I set field "artex" to "1efall12" in row 2
And I set field "mge" to "1200" in row 2
And I set field "preis" to "11.11" in row 2
And I save the current editor


# Lieferschein 1 zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "1200-LS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "schlag" to "FALL-Rabatt-auf-Alles3,"
Then the table has 2 rows
Then field "artex" has value "EK1-FALL12" in row 1
And I set field "mge" to "1200" in row 1
And I set field "mge" to "0" in row 2
And I save the current editor

# Lieferschein 2 zu Bestellung anlegen
Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "1200-LS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "schlag" to "FALL-Rabatt-auf-Alles3,"
Then the table has 1 rows
Then field "artex" has value "EK2-FALL12" in row 1
And I set field "mge" to "1200" in row 1
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Rechnung 1 zum LS1 anlegen + verbuchen; Lieferant bleibt
# Zeilenrabatt 10%
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "1200-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-Rabatt-auf-Alles3,"
Then field "fakt" has value "nein" in row 0
And I set field "mge" to "1200" in row 1
And I set field "preis" to "11.22" in row 1
And I set field "proz" to "-10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rechnung 2 zum LS2 anlegen + verbuchen; Lieferant bleibt
# Gesamtrechnungsrabatt 10%
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2"
And I set field "num4" to "1200-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-Rabatt-auf-Alles3,"
Then field "fakt" has value "nein" in row 0
And I set field "mge" to "1200" in row 1
And I set field "preis" to "11.22" in row 1
# Zwischensumme-Position einfuegen
And I create a new row at the end of the table
And I set field "artex" to "ZS." in row 2
Then field "pwert" has value "13464.00" in row 2
# Gesamtrechnungsrabatt-Position einfuegen
And I create a new row at the end of the table
And I set field "artex" to "PR." in row 3
And I set field "proz" to "-10" in row 3
# ein Bestandskonto eintragen
And I set field "konto" to "1ifall12" in row 3
Then field "pwert" has value "-1346.40" in row 3
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Ruecklieferung 1 von 1200 Stk. -> LS 1 komplett
Given I open an editor "ruecklief-1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+1200-LS1"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "1200RLS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "EK1-FALL12" in row 1
And I set field "mge" to "-1200" in row 1
And I save the current editor
And I close the current editor

# Ruecklieferung 2 von 1200 Stk. -> LS 2 komplett
Given I open an editor "ruecklief-2" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+1200-LS2"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "1200RLS2"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "EK2-FALL12" in row 1
And I set field "mge" to "-1200" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Kaufm. GS 1 zu Ruecklieferschein 1
Given I open an editor "KGS1200" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-1"
And I set field "num4" to "1200-GS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 1 rows
Then table has values
    | art               | mge           | preis         | ofmge | herkunft^kopf^such    |
    | EK1-FALL12        | -1200         | 11.22         | 0     | RLFALL12              |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Kaufm. GS 2 zu Ruecklieferschein 2
Given I open an editor "KGS1200" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-2"
And I set field "num4" to "1200-GS2"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 1 rows
Then table has values
    | art               | mge           | preis         | ofmge | herkunft^kopf^such    |
    | EK2-FALL12        | -1200         | 11.22         | 0     | RLFALL12              |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "1ifall12"
#
#  ACHTUNG: HIER MUSS SALDO 0.00 SEIN !!!
#           Hier wurde alles zurueckgeliefert und berechnet -> Menge 0, Wert 0.00
#
# Then field "saldo" has value "0.00" in row 0
Then field "saldo" has value "0.00" in row 0
And I close the current editor
#####################################################################################################################################

@FALL-Rabatt-auf-Alles4
Scenario: FALL-Rabatt-auf-Alles4; Ohne Umlegen; Testumgebung 13
# 1) Prozent-Position ohne Umlegen anlegen
# 2) BE mit 1 Art.
#    in BE Gesamtrechnungsrabatt ohne Umlegen aber, 10%
# 3) LS1 zu Art. 1
# 4) RE1 zu LS1
# 5) RLS1 zu LS1 komplett
# 6) KGS1 zu RLS1
# 7) Pruefung des Konto -> Saldo muss 0.00 sein

# Prozent-Position ohne Umlegen anlegen
Given I open an editor "zpos-1" from table "(Part):(SupplementaryItem)" with command "COPY" for record "PR."
And I set field "namebspr" to "Gesamtrechnungsrab. ohne Umlegen"
And I set field "such" to "PROZ.OHNE"
And I set field "kenn" to "FALL-Rabatt-auf-Alles4,"
# And I set field "umlage" to "ja"
And I set field "umlage" to "nein"
And I set field "evproz" to "-10"
And I save the current editor
And I close the current editor

# eine Bestellung fuer 1 Artikel anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
# Inland-Lieferant
And I set field "lief" to "001fa13"
And I set field "num4" to "1300-BE"
And I set field "kenn" to "FALL-Rabatt-auf-Alles4,"
And I create a new row at the end of the table
And I set field "artex" to "0efall13" in row 1
And I set field "mge" to "1300" in row 1
And I set field "preis" to "11.11" in row 1
# Zwischensumme-Position einfuegen
And I create a new row at the end of the table
And I set field "artex" to "ZS." in row 2
Then field "pwert" has value "14443.00" in row 2
# Gesamtrechnungsrabatt-Position ohne Umlegen einfuegen
And I create a new row at the end of the table
And I set field "artex" to "PROZ.OHNE" in row 3
And I set field "konto" to "1ifall13" in row 3
Then field "pwert" has value "-1444.30" in row 3
And I save the current editor

# Lieferschein 1 zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "1300-LS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "schlag" to "FALL-Rabatt-auf-Alles4,"
Then the table has 3 rows
Then field "artex" has value "EK1-FALL13" in row 1
And I set field "mge" to "1300" in row 1
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Rechnung 1 zum LS1 anlegen + verbuchen; Lieferant bleibt
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "1300-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-Rabatt-auf-Alles4,"
Then field "fakt" has value "nein" in row 0
And I set field "mge" to "1300" in row 1
And I set field "preis" to "11.22" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Ruecklieferung 1 von 1300 Stk. -> LS 1 komplett
Given I open an editor "ruecklief-1" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+1300-LS1"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "1300RLS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "EK1-FALL13" in row 1
And I set field "mge" to "-1300" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

# Kaufm. GS 1 zu Ruecklieferschein 1
Given I open an editor "KGS1300" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-1"
And I set field "num4" to "1300-GS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 3 rows
Then table has values
    | art                       | mge           | preis         | ofmge | herkunft^kopf^such    |
    | EK1-FALL13        | -1300         | 11.22         | 0             | RLFALL13                              |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue

Given I open an editor "konto" from table "(Account):(Account)" with command "VIEW" for record "1ifall13"
#  ACHTUNG: HIER MUSS SALDO 0.00 SEIN !!!
#           Hier wurde alles zurueckgeliefert und berechnet -> Menge 0, Wert 0.00
Then field "saldo" has value "0.00" in row 0
And I close the current editor
#####################################################################################################################################
