# *****************************************************************************
#  Name             : ref_bw_add_kosten_04_plausis.feature
#  Autor            : wane
#  Verantwortlich   : sih
#  Kontrolle        :
#  Funktion         : Test der Pausis, die mit add. Kosten(Kostenumlagen(KM)) zu tun haben
#
#             Faelle:
#                * @FALL-450 KM und Rueck-LS; KM auf den LS direkt
#                * @FALL-460 KM und Rueck-LS; KM auf RE, die vor LS verbucht ist
#
#
# *****************************************************************************

@persistent
Feature: add.Kosten
Background: Test von add. Kosten in der Bewertung
Given I set the fake date to "07.01.2002"


# @FALL-450 KM und Rueck-LS
Scenario: KM auf LS + volle Ruecklieferung; Testumgebung 45
# eine Bestellung fuer Artikel mit Beistellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
# Inland-Lieferant
And I set field "lief" to "001fa45"
And I set field "num4" to "450-BE"
And I set field "kenn" to "FALL-450 Rueck-LS,"
And I create a new row at the end of the table
And I set field "artex" to "0efall45" in row 1
And I set field "mge" to "450" in row 1
And I set field "preis" to "3.33" in row 1
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "450-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "schlag" to "FALL-450 Rueck-LS,"
And I press button "offueb" in row 1
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "450" in the Area "45" with Command Revalue

# VK-Rechnung (Ausland)
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "450-RE"
And I set field "kunde" to "006fa45"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "0efall45" in row 1
And I set field "mge" to "175" in row 1
And I set field "preis" to "45" in row 1
And I set field "kenn" to "FALL-450 Rueck-LS,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "450" in the Area "45" with Command Revalue

# Kostenumlage (450)
# zuerst die Frachtrechnung anlegen
Given I open an editor "fracht" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001fa45"
And I set field "num4" to "450km1"
And I set field "kenn" to "FALL-450 Rueck-LS,"
And I set field "such" to "KM450"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "FRACHT" in row 1
And I set field "pwert" to "450" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen
Given I open an editor "kostenuml" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "450-KM1"
And I set field "pos" to "$,,kopf^nummer=450km1;art=FRACHT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=450-LS;artex=0efall45;mge=450;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "450" in the Area "45" with Command Revalue


# Ruecklieferschein1 anlegen
Given I open an editor "rls-450" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1"
And I set field "num4" to "450-RLS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-450 Rueck-LS,"
And I set field "mge" to "-300" in row 1
And I save the current editor
And I close the current editor


# Ruecklieferschein2 anlegen -> Rest zurueckliefern
Given I open an editor "rls-450" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1"
And I set field "num4" to "450-RLS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-450 Rueck-LS,"
And I press button "offueb" in row 1
And saving the current editor throws the exception "2888"
And I set field "ueb" to "nein"
And I save the current editor

And I close the current editor

# Nach dem Zwischenspeichern darf dieser RLS auch nicht verbucht werden
Given I open an editor "rls-erneut" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "450-RLS2"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And saving the current editor throws the exception "2888"
And I close the current editor
#
# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "450" in the Area "45" with Command Revalue
#####################################################################################################################################


# @FALL-460 KM und Rueck-LS
Scenario: KM auf RE + Versuch der vollen Ruecklieferung; Testumgebung 46
# Kette: BE->TRE1(verbuchen)->TRE2->KM(auf TRE1)->EK-LS->VK-RE->RLS1(verbuchen)->RLS2(Meldung)

# eine Bestellung fuer Artikel mit Beistellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
# Inland-Lieferant
And I set field "lief" to "001fa46"
And I set field "num4" to "460-BE"
And I set field "kenn" to "FALL-460 Rueck-LS,"
And I create a new row at the end of the table
And I set field "artex" to "0efall46" in row 1
And I set field "mge" to "460" in row 1
And I set field "preis" to "3.33" in row 1
And I save the current editor


# Teil-Rechnung 1 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "460-RE1"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "230" in row 1
And I set field "preis" to "3.55" in row 1
And I set field "kenn" to "FALL-460"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Teil-Rechnung 2 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "460-RE2"
# bei 2. Teil-RE ist das Feld schreibgeschuetzt
Then field "fakt" is not modifiable
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "preis" to "3.77" in row 1
And I set field "kenn" to "FALL-460"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Kostenumlage (460)
# zuerst die Frachtrechnung anlegen
Given I open an editor "fracht" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001fa46"
And I set field "num4" to "460km1"
And I set field "kenn" to "FALL-460 Rueck-LS,"
And I set field "such" to "KM460"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "FRACHT" in row 1
And I set field "pwert" to "460" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen
Given I open an editor "kostenuml" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "460-KM1"
And I set field "pos" to "$,,kopf^nummer=460km1;art=FRACHT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=460-RE1;artex=0efall46;mge=230;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor



# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "460-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "schlag" to "FALL-460 Rueck-LS,"
And I press button "offueb" in row 1
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "460" in the Area "46" with Command Revalue

# VK-Rechnung (Ausland)
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "460-RE"
And I set field "kunde" to "006fa46"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "0efall46" in row 1
And I set field "mge" to "175" in row 1
And I set field "preis" to "46" in row 1
And I set field "kenn" to "FALL-460 Rueck-LS,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "460" in the Area "46" with Command Revalue


# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "460" in the Area "46" with Command Revalue


# Ruecklieferschein1 anlegen
Given I open an editor "rls-460" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1"
And I set field "num4" to "460-RLS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-460 Rueck-LS,"
And I set field "mge" to "-200" in row 1
And I save the current editor
And I close the current editor


# Ruecklieferschein2 anlegen -> Rest zurueckliefern
Given I open an editor "rls-460" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1"
And I set field "num4" to "460-RLS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-460 Rueck-LS,"
And I press button "offueb" in row 1
And saving the current editor throws the exception "2888"
And I set field "ueb" to "nein"
And I save the current editor

And I close the current editor

# Nach dem Zwischenspeichern darf dieser RLS auch nicht verbucht werden
Given I open an editor "rls-erneut" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "460-RLS2"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And saving the current editor throws the exception "2888"
And I close the current editor
#
# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "460" in the Area "46" with Command Revalue
#####################################################################################################################################

# @FALL-470 KM und Rueck-LS
Scenario: KM auf RE + Versuch der vollen Ruecklieferung; Testumgebung 47
# Aktionen: BE->TRE1->TRE2->KM(auf TRE1)->EK-LS->VK-RE->RLS1(anlegen)->RLS2(anlegen)->RLS1(verbuchen)->RLS2(Meldung)->KM(Storno)->RLS2(verbuchen)

# eine Bestellung fuer Artikel mit Beistellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
# Inland-Lieferant
And I set field "lief" to "001fa47"
And I set field "num4" to "470-BE"
And I set field "kenn" to "FALL-470 Rueck-LS,"
And I create a new row at the end of the table
And I set field "artex" to "0efall47" in row 1
And I set field "mge" to "470" in row 1
And I set field "preis" to "3.33" in row 1
And I create a new row at the end of the table
And I set field "artex" to "1efall47" in row 2
And I set field "mge" to "470" in row 2
And I set field "preis" to "5.55" in row 2
And I save the current editor

# Teil-Rechnung 1 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "470-RE1"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then field "artex" has value "EK1-FALL47" in row 1
And I set field "mge" to "230" in row 1
And I set field "preis" to "3.55" in row 1
And I set field "kenn" to "FALL-470"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Teil-Rechnung 2 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "470-RE2"
# bei 2. Teil-RE ist das Feld schreibgeschuetzt
Then field "fakt" is not modifiable
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-470"
Then the table has 2 rows
Then field "artex" has value "EK1-FALL47" in row 1
And I press button "offueb" in row 1
And I set field "preis" to "3.77" in row 1
And I press button "offueb" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Kostenumlage (470)
# zuerst die Frachtrechnung anlegen
Given I open an editor "fracht" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001fa47"
And I set field "num4" to "470km1"
And I set field "kenn" to "FALL-470 Rueck-LS,"
And I set field "such" to "KM470"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "FRACHT" in row 1
And I set field "pwert" to "470" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen
Given I open an editor "kostenuml" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "470-KM1"
And I set field "pos" to "$,,kopf^nummer=470km1;art=FRACHT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=470-RE1;artex=0efall47;mge=230;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "470-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "schlag" to "FALL-470 Rueck-LS,"
Then the table has 2 rows
Then field "artex" has value "EK1-FALL47" in row 1
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "470" in the Area "47" with Command Revalue

# VK-Rechnung (Ausland)
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "470-RE"
And I set field "kunde" to "006fa47"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "0efall47" in row 1
And I set field "mge" to "175" in row 1
And I set field "preis" to "47" in row 1
And I set field "kenn" to "FALL-470 Rueck-LS,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "470" in the Area "47" with Command Revalue


# Ruecklieferschein1 anlegen, aber nicht verbuchen
Given I open an editor "rls-470" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1"
And I set field "num4" to "470-RLS1"
And I set field "ueb" to "nein"
And I set field "vom" to "."
And I set field "kenn" to "FALL-470 Rueck-LS,"
And I set field "mge" to "-200" in row 1
And I save the current editor
And I close the current editor


# Ruecklieferschein2 anlegen, aber nicht verbuchen -> Rest zurueckliefern
Given I open an editor "rls-470" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1"
And I set field "num4" to "470-RLS2"
And I set field "ueb" to "nein"
And I set field "vom" to "."
And I set field "kenn" to "FALL-470 Rueck-LS,"
And I press button "offueb" in row 1
And I set field "ueb" to "nein"
And I save the current editor
And I close the current editor

# +++++++++
# Jetzt ist die komplette Menge aus dem Original LS in den Rueck-LS drin, aber Rueck-LS wurden noch nicht gebucht
# +++++++++

# Ruecklieferschein3 anlegen, aber nicht verbuchen -> Rest zurueckliefern
Given I open an editor "rls-470" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1"
And I set field "num4" to "470-RLS3"
And I set field "ueb" to "nein"
And I set field "vom" to "."
Then the table has 1 rows
And I close the current editor
#
# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "470" in the Area "47" with Command Revalue

# Nach dem Zwischenspeichern wird RLS1 wird verbucht -> keine Meldung erwartet!!!
Given I open an editor "rls1-buchen" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "470-RLS1"
And I set field "ueb" to "ja"
And I save the current editor
And I close the current editor
#
# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "470" in the Area "47" with Command Revalue

# Nach dem Zwischenspeichern wird RLS2 wird verbucht -> die Meldung erwartet!!!
# diesen RLS kann man nicht verbuchen!!!
Given I open an editor "rls2-buchen" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "470-RLS2"
And I set field "ueb" to "ja"
Then field "ofmge" has value "0" in row 1
And saving the current editor throws the exception "2888"
And I close the current editor
#
# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "470" in the Area "47" with Command Revalue

# KM stornieren
Given I open an editor "storno-km" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+470-KM1"
And I set field "num135" to "470STOR"
And I save the current editor
And I close the current editor

# 2. Versuch RLS2 zu verbuchen -> KM ist inzwischen storniert
Given I open an editor "rls2-buchen" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "470-RLS2"
And I set field "ueb" to "ja"
Then field "ofmge" has value "0" in row 1
And I save the current editor
And I close the current editor
#
# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "470" in the Area "47" with Command Revalue
#####################################################################################################################################

# @FALL-480 KM-Storno und Rueck-LS
Scenario: KM auf RE + Versuch der vollen Ruecklieferung; Testumgebung 48
# Aktionen zum Artikel 0efall48:
# BE   -> 480 Stk. zu 3.33
# TRE1 ->  30 Stk. zu 3.55
# TRE2 ->  50 Stk. zu 3.77
# TRE3 -> 400 Stk. zu 3.99
# KM(auf TRE3) -> 480.00 auf 400 Stk.
# EK-LS1 -> 240 Stk.
# EK-LS2 -> 240 Stk.
# VK-RE -> 175 Stk.
# RLS1(anlegen) -> 240 Stk.
# RLS2(anlegen) -> 240 Stk.
# RLS1(verbuchen) -> Meldung
# RLS2(verbuchen) -> Meldung
# KM(Storno) -> -480.00 -> add. Kosten muessen jetzt 0.00 sein
# RLS1(verbuchen) -> Ok
# RLS2(verbuchen) -> Ok
# Hier ist die KM auf einer Teil-RE, betrifft aber beide LS bzw. beide RLS

# eine Bestellung fuer Artikel mit Beistellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
# Inland-Lieferant
And I set field "lief" to "001fa48"
And I set field "num4" to "480-BE"
And I set field "kenn" to "FALL-480 Rueck-LS,"
And I create a new row at the end of the table
And I set field "artex" to "0efall48" in row 1
And I set field "mge" to "480" in row 1
And I set field "preis" to "3.33" in row 1
And I create a new row at the end of the table
And I set field "artex" to "1efall48" in row 2
And I set field "mge" to "480" in row 2
And I set field "preis" to "5.55" in row 2
And I save the current editor


# Teil-Rechnung 1 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "480-RE1"
And I set field "fakt" to "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
Then field "artex" has value "EK1-FALL48" in row 1
And I set field "mge" to "30" in row 1
And I set field "preis" to "3.55" in row 1
And I set field "kenn" to "FALL-480"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Teil-Rechnung 2 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "480-RE2"
# bei 2. Teil-RE ist das Feld schreibgeschuetzt
Then field "fakt" is not modifiable
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-480"
Then the table has 2 rows
Then field "artex" has value "EK1-FALL48" in row 1
And I set field "mge" to "50" in row 1
And I set field "preis" to "3.77" in row 1
And I press button "offueb" in row 2
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Teil-Rechnung 3 anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "480-RE3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-480"
Then the table has 2 rows
Then field "artex" has value "EK1-FALL48" in row 1
And I press button "offueb" in row 1
And I set field "preis" to "3.99" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Kostenumlage (480)
# zuerst die Frachtrechnung anlegen
Given I open an editor "fracht" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "001fa48"
And I set field "num4" to "480km1"
And I set field "kenn" to "FALL-480 Rueck-LS,"
And I set field "such" to "KM480"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artikel" to "FRACHT" in row 1
And I set field "pwert" to "480" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
# danach die Kostenumlage erzeugen
Given I open an editor "kostenuml" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "480-KM1"
And I set field "pos" to "$,,kopf^nummer=480km1;art=FRACHT;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Linear"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=480-RE3;artex=0efall48;mge=400;@gruppe=2;@datenbank=4;@ablageart=(Both)" in row 1
And I save the current editor

# Lieferschein 1 zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "480-LS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "schlag" to "FALL-480 Rueck-LS,"
Then the table has 2 rows
Then field "artex" has value "EK1-FALL48" in row 1
And I set field "mge" to "240" in row 1
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "480" in the Area "48" with Command Revalue

# Lieferschein 2 zu Bestellung anlegen
Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "480-LS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "schlag" to "FALL-480 Rueck-LS,"
Then the table has 2 rows
Then field "artex" has value "EK1-FALL48" in row 1
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "480" in the Area "48" with Command Revalue


# VK-Rechnung (Ausland)
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "num3" to "480-RE"
And I set field "kunde" to "006fa48"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "0efall48" in row 1
And I set field "mge" to "175" in row 1
And I set field "preis" to "48" in row 1
And I set field "kenn" to "FALL-480 Rueck-LS,"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "480" in the Area "48" with Command Revalue

# Ruecklieferschein1 anlegen, aber nicht verbuchen
Given I open an editor "rls-480" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-1"
And I set field "num4" to "480-RLS1"
And I set field "ueb" to "nein"
And I set field "vom" to "."
And I set field "kenn" to "FALL-480 Rueck-LS,"
Then field "artex" has value "EK1-FALL48" in row 1
And I set field "mge" to "-240" in row 1
And I save the current editor
And I close the current editor


# Ruecklieferschein2 anlegen, aber nicht verbuchen -> Rest zurueckliefern
Given I open an editor "rls-480" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2"
And I set field "num4" to "480-RLS2"
And I set field "ueb" to "nein"
And I set field "vom" to "."
And I set field "kenn" to "FALL-480 Rueck-LS,"
Then field "artex" has value "EK1-FALL48" in row 1
And I press button "offueb" in row 1
And I set field "ueb" to "nein"
And I save the current editor
And I close the current editor

# +++++++++
# Jetzt ist die komplette Menge aus der Bestellung in den Rueck-LS drin, aber Rueck-LS wurden noch nicht gebucht
# +++++++++

#
# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "480" in the Area "48" with Command Revalue

# Nach dem Zwischenspeichern wird RLS1 wird verbucht -> keine Meldung erwartet!!!
Given I open an editor "rls1-buchen" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "480-RLS1"
And I set field "ueb" to "ja"
Then field "ofmge" has value "0" in row 1
And saving the current editor throws the exception "2888"
And I close the current editor
#
# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "480" in the Area "48" with Command Revalue

# Nach dem Zwischenspeichern wird RLS2 wird verbucht -> die Meldung erwartet!!!
# diesen RLS kann man nicht verbuchen!!!
Given I open an editor "rls2-buchen" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "480-RLS2"
And I set field "ueb" to "ja"
Then field "ofmge" has value "0" in row 1
And saving the current editor throws the exception "2888"
And I close the current editor
#
# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "480" in the Area "48" with Command Revalue

# KM stornieren
Given I open an editor "storno-km" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+480-KM1"
And I set field "num135" to "480STOR"
And I save the current editor
And I close the current editor

#
# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "480" in the Area "48" with Command Revalue

# 2. Versuch RLS1 zu verbuchen -> KM ist inzwischen storniert
Given I open an editor "rls1-buchen" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "480-RLS1"
And I set field "ueb" to "ja"
Then field "ofmge" has value "0" in row 1
And I save the current editor
And I close the current editor

#
# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "480" in the Area "48" with Command Revalue


# 2. Versuch RLS2 zu verbuchen -> KM ist inzwischen storniert
Given I open an editor "rls2-buchen" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "480-RLS2"
And I set field "ueb" to "ja"
Then field "ofmge" has value "0" in row 1
And I save the current editor
And I close the current editor
#
# nachbewerten + Materialkostenverbuchung
Given I create a CostEntriesSuggestion for the Test Case "480" in the Area "48" with Command Revalue
#####################################################################################################################################
