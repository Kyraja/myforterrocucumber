@persistent
Feature: RETURNPRELIMINARY
Background:
Given I set the fake date to "02.01.02"
# *****************************************************************************
#  Name           : returnpreliminary.feature
#  Autor          : cl
#  Verantwortlich : cl
#  Kontrolle      : as
#  Funktion       : Cucumber Tests fuer RETURNPRELIMINARY
#                   
# *****************************************************************************

@FALL-460
Scenario: FALL-460
# BE>LS>RE>RLS>GS   mit unterschiedlichen Preisen

# Konto 460-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0460FALL"
And I set field "such" to "FALL-460"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0460FALL"
And I set field "such" to "FALL-460"
And I set field "bestausekso" to "FALL-460"
And I save the current editor
#NIO

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "460-FALL"
And I set field "num2" to "460-FALL"
And I set field "such" to "FALL-460"
And I set field "namebspr" to "FALL-460"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-460"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
And I save the current editor 

# Bestellung anlegen mit drei Zeilen und unterschiedlichen Preisen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "460-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-460" in row 1
And I set field "mge" to "460" in row 1
And I set field "preis" to "460,46" in row 1
And I create a new row at the end of the table
And I set field "artex" to "FALL-460" in row 2
And I set field "mge" to "460" in row 2
And I set field "preis" to "460,92" in row 2
And I create a new row at the end of the table
And I set field "artex" to "FALL-460" in row 3
And I set field "mge" to "460" in row 3
And I set field "preis" to "460,23" in row 3
And I set field "kenn" to "FALL-460"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "460-BE"
And I close the current editor
 
# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-460" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "460-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "02.01.02"
And I set field "pnum" to "1" in row 1
And I set field "mge" to "460" in row 1
And I set field "pnum" to "2" in row 2
And I set field "mge" to "100" in row 2
And I set field "pnum" to "3" in row 3
And I set field "mge" to "230" in row 3
And I set field "kenn" to "FALL-460"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-460" with type of cost entry "Verbuchung Lagerbestand" for startdate "02.01.02" until enddate "02.01.02"

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "460-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-460"
And I set field "num4" to "460-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "02.01.02"
And I set field "mge" to "295" in row 1
And I set field "preis" to "460,41" in row 1
And I set field "mge" to "70" in row 2
And I set field "preis" to "550,01" in row 2
And I set field "mge" to "130" in row 3
And I set field "preis" to "520,01" in row 3
#
And I set field "kenn" to "FALL-460"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-460" with type of cost entry "Verbuchung Lagerbestand" for startdate "02.01.02" until enddate "02.01.02"

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+460-RE"
And I close the current editor

# Rücklieferschein anlegen zu Fall 460
Given I open an editor "rls-460" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-460"
And I set field "num4" to "460-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "02.01.02"
Then the table has 3 rows
And I set field "mge" to "-190" in row 1
And I set field "mge" to "-50" in row 2
And I set field "mge" to "-100" in row 3
And I set field "kenn" to "FALL-460 Ruecklieferschein"
And I save the current editor

# Ausgabe Rücklieferschein 
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "460-RLS"
And I close the current editor

# 1. Kaufm. Gutschrift -> gebucht am 02.01.02 (1. Zeile komplett, 2. Zeile  1 von 50)
Given I open an editor "gutschrift-460" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-460"
And I set field "num4" to "460-GS1"
And I set field "ueb" to "ja"
And I set field "vom" to "02.01.02"
And I set field "budat" to "02.01.02"
Then the table has 3 rows
# Max 10 gutschreibbar
And I set field "mge" to "-10" in row 1
And I set field "mge" to "-1" in row 2
And I set field "kenn" to "FALL-460"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I set the fake date to "03.01.02"
# 2. Kaufm. Gutschrift -> nicht gebucht 
Given I open an editor "gutschrift-460" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-460"
And I set field "num4" to "460-GS2"
And I set field "vom" to "03.01.02"
# And I set field "ueb" to "ja"
Then the table has 3 rows
And I set field "mge" to "-1" in row 1
And I set field "mge" to "-11" in row 2
And I set field "kenn" to "FALL-460"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# 3. Kaufm. Gutschrift -> erstellt am 03.01.02, gebucht am 03.01.02 
Given I open an editor "gutschrift-460" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-460"
And I set field "num4" to "460-GS3"
And I set field "ueb" to "ja"
And I set field "vom" to "03.01.02"
And I set field "budat" to "03.01.02"
Then the table has 3 rows
And I set field "mge" to "-1" in row 1
And I set field "mge" to "-1" in row 2
And I set field "kenn" to "FALL-460"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I set the fake date to "04.01.02"
# 4. Kaufm. Gutschrift -> erstell am 04.01.02, nicht gebucht 
Given I open an editor "gutschrift-460" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-460"
And I set field "num4" to "460-GS4"
And I set field "vom" to "04.01.02"
And I set field "budat" to "04.01.02"
Then the table has 3 rows
And I set field "mge" to "-10" in row 1
And I set field "mge" to "-5" in row 2
And I set field "kenn" to "FALL-460"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I set the fake date to "05.01.02"
# 5. Kaufm. Gutschrift -> erstell am 05.01.02, gebucht am 05.01.02 
Given I open an editor "gutschrift-460" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-460"
And I set field "num4" to "460-GS5"
And I set field "ueb" to "ja"
And I set field "vom" to "05.01.02"
And I set field "budat" to "05.01.02"
Then the table has 3 rows
And I set field "mge" to "-1" in row 1
And I set field "mge" to "-1" in row 2
And I set field "kenn" to "FALL-460"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

Given I set the fake date to "06.01.02"

# offene Kaufm. Gutschrift Nr. 2 und Nr. 4 buchen
Given I open an editor "gutschrift-460" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "460-GS2"
And I set field "vom" to "06.01.02"
And I set field "budat" to "06.01.02"
And I set field "ueb" to "ja"
And I save the current editor

Given I open an editor "gutschrift-460" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "460-GS4"
And I set field "vom" to "06.01.02"
And I set field "budat" to "06.01.02"
And I set field "ueb" to "ja"
And I save the current editor


@Infosystem_RETURNPRELIMINARY_02.01.02
Scenario:  Infosystem starten RETURNPRELIMINARY
Given I open the infosystem "RETURNPRELIMINARY"
And I set field "konto" to "0460FALL"
And I set field "stichtag" to "02.01.02"
And I press button "bstart"
Then field "stichtag" has value "02.01.02"
Then the table has 10 rows

Then field "vorgang" has value "E 460-RLS" in row 1
Then field "vom" has value "02.01.02" in row 1
Then field "rerelev" has value "ja" in row 1
Then field "artikel" has value "FALL-460" in row 1
Then field "tmge" has value "-190" in row 1
Then field "the" has value "Stück" in row 1
Then field "preis" has value "460.41" in row 1
Then field "proz" has value "" in row 1
Then field "remge" has value "-2" in row 1
Then field "twertfehlt" has value "-920.82" in row 1
Then field "tkonto" has value "0460FALL" in row 1
Then field "ngkaufgut" has value "nein" in row 1
Then field "kaufgut" has value "nein" in row 1

Then field "vorgang" has value "E +460-GS5" in row 2
Then field "vorgang" has value "E +460-GS4" in row 3
Then field "vorgang" has value "E +460-GS3" in row 4
Then field "vorgang" has value "E +460-GS2" in row 5

Then field "vorgang" has value "E 460-RLS" in row 6
Then field "vom" has value "02.01.02" in row 6
Then field "rerelev" has value "ja" in row 6
Then field "artikel" has value "FALL-460" in row 6
Then field "tmge" has value "-50" in row 6
Then field "the" has value "Stück" in row 6
Then field "preis" has value "550.01" in row 6
Then field "proz" has value "" in row 6
Then field "remge" has value "-1" in row 6
Then field "twertfehlt" has value "-550.01" in row 6
Then field "tkonto" has value "0460FALL" in row 6
Then field "ngkaufgut" has value "nein" in row 6
Then field "kaufgut" has value "nein" in row 6

Then field "vorgang" has value "E +460-GS5" in row 7
Then field "vorgang" has value "E +460-GS4" in row 8
Then field "vorgang" has value "E +460-GS3" in row 9
Then field "vorgang" has value "E +460-GS2" in row 10


@Infosystem_RETURNPRELIMINARY_03.01.02
Scenario:  Infosystem starten RETURNPRELIMINARY
Given I open the infosystem "RETURNPRELIMINARY"
And I set field "stichtag" to "03.01.02"
And I set field "konto" to "0460FALL"
And I press button "bstart"
Then field "stichtag" has value "03.01.02"
Then the table has 8 rows

Then field "vorgang" has value "E 460-RLS" in row 1
Then field "vom" has value "02.01.02" in row 1
Then field "rerelev" has value "ja" in row 1
Then field "artikel" has value "FALL-460" in row 1
Then field "tmge" has value "-190" in row 1
Then field "the" has value "Stück" in row 1
Then field "preis" has value "460.41" in row 1
Then field "proz" has value "" in row 1
Then field "remge" has value "-2" in row 1
Then field "twertfehlt" has value "-920.82" in row 1
Then field "tkonto" has value "0460FALL" in row 1
Then field "ngkaufgut" has value "nein" in row 1
Then field "kaufgut" has value "nein" in row 1


@Infosystem_RETURNPRELIMINARY_04.01.02
Scenario:  Infosystem starten RETURNPRELIMINARY
Given I open the infosystem "RETURNPRELIMINARY"
And I set field "stichtag" to "04.01.02"
And I set field "konto" to "0460FALL"
And I press button "bstart"
Then field "stichtag" has value "04.01.02"
Then the table has 8 rows

Then field "vorgang" has value "E 460-RLS" in row 1
Then field "vom" has value "02.01.02" in row 1
Then field "rerelev" has value "ja" in row 1
Then field "artikel" has value "FALL-460" in row 1
Then field "tmge" has value "-190" in row 1
Then field "the" has value "Stück" in row 1
Then field "preis" has value "460.41" in row 1
Then field "proz" has value "" in row 1
Then field "remge" has value "-2" in row 1
Then field "twertfehlt" has value "-920.82" in row 1
Then field "tkonto" has value "0460FALL" in row 1
Then field "ngkaufgut" has value "nein" in row 1
Then field "kaufgut" has value "nein" in row 1


@Infosystem_RETURNPRELIMINARY_05.01.02
Scenario:  Infosystem starten RETURNPRELIMINARY
Given I open the infosystem "RETURNPRELIMINARY"
And I set field "stichtag" to "05.01.02"
And I set field "konto" to "0460FALL"
And I press button "bstart"
Then field "stichtag" has value "05.01.02"
Then the table has 6 rows
Then field "vorgang" has value "E 460-RLS" in row 1
Then field "vom" has value "02.01.02" in row 1
Then field "rerelev" has value "ja" in row 1
Then field "artikel" has value "FALL-460" in row 1
Then field "tmge" has value "-190" in row 1
Then field "the" has value "Stück" in row 1
Then field "preis" has value "460.41" in row 1
Then field "proz" has value "" in row 1
Then field "remge" has value "-2" in row 1
Then field "twertfehlt" has value "-920.82" in row 1
Then field "tkonto" has value "0460FALL" in row 1
Then field "ngkaufgut" has value "nein" in row 1
Then field "kaufgut" has value "nein" in row 1


@Infosystem_RETURNPRELIMINARY_06.01.02
Scenario:  Infosystem starten RETURNPRELIMINARY
Given I open the infosystem "RETURNPRELIMINARY"
And I set field "stichtag" to "06.01.02"
And I set field "konto" to "0460FALL"
And I press button "bstart"
Then field "stichtag" has value "06.01.02"
Then the table has 2 rows

#####################################################################################################################################

@FALL-465
Scenario: FALL-465
Given I set the fake date to "02.01.02"
# BE>LS>RLS>RE>GS   mit unterschiedlichen Preisen

# Konto 465-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0465FALL"
And I set field "such" to "FALL-465"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0465FALL"
And I set field "such" to "FALL-465"
And I set field "bestausekso" to "FALL-465"
And I save the current editor
#NIO

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "465-FALL"
And I set field "num2" to "465-FALL"
And I set field "such" to "FALL-465"
And I set field "namebspr" to "FALL-465"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-465"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "465-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-465" in row 1
And I set field "mge" to "465" in row 1
And I set field "preis" to "465,46" in row 1
#
And I create a new row at the end of the table
And I set field "artex" to "FALL-465" in row 2
And I set field "mge" to "465" in row 2
And I set field "preis" to "465,92" in row 2
#
And I create a new row at the end of the table
And I set field "artex" to "FALL-465" in row 3
And I set field "mge" to "465" in row 3
And I set field "preis" to "465,23" in row 3
#
And I set field "kenn" to "FALL-465"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "465-BE"
And I close the current editor
 
# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-465" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "465-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "465" in row 1
And I set field "mge" to "120" in row 2
And I set field "mge" to "230" in row 3
And I set field "kenn" to "FALL-465"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-465" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "465-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-465"
And I set field "num4" to "465-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# Keine Ueberberechnung moeglich
And I set field "mge" to "279" in row 1
And I set field "preis" to "465,41" in row 1
# Keine Ueberberechnung moeglich
And I set field "mge" to "55" in row 2
And I set field "preis" to "520,01" in row 2
And I set field "kenn" to "FALL-465"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-465" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+465-RE"
And I close the current editor

# Rücklieferschein anlegen zu Fall 465
Given I open an editor "rls-465" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-465"
And I set field "num4" to "465-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "02.01.02"
Then the table has 3 rows
And I set field "mge" to "-196" in row 1
And I set field "mge" to "-75" in row 2
And I set field "mge" to "-1" in row 3
And I set field "kenn" to "FALL-465 Ruecklieferschein"
And I save the current editor

# Ausgabe Rücklieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "465-RLS"
And I close the current editor

# Kaufm. Gutschrift
Given I open an editor "gutschrift-465" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-465"
And I set field "num4" to "465-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "02.01.02"
# Nur 0-GS moeglich
And I set field "mge" to "0" in row 1
And I set field "mge" to "0" in row 2
And I set field "kenn" to "FALL-465"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+465-GS"
And I close the current editor


@Infosystem_RETURNPRELIMINARY
Scenario:  Infosystem starten RETURNPRELIMINARY
Given I open the infosystem "RETURNPRELIMINARY"
# Konto leer
And I set field "konto" to ""
And I set field "stichtag" to "02.01.02"
And I press button "bstart"
Then the table has 12 rows
Then field "vorgang" has value "E 460-RLS" in row 1
Then field "vom" has value "02.01.02" in row 1
Then field "rerelev" has value "ja" in row 1
Then field "artikel" has value "FALL-460" in row 1
Then field "tmge" has value "-190" in row 1
Then field "the" has value "Stück" in row 1
Then field "preis" has value "460.41" in row 1
Then field "proz" has value "" in row 1
Then field "remge" has value "-2" in row 1
Then field "twertfehlt" has value "-920.82" in row 1
Then field "tkonto" has value "0460FALL" in row 1
Then field "ngkaufgut" has value "nein" in row 1
Then field "kaufgut" has value "nein" in row 1


@FALL-470
Scenario: FALL-470
# BE>LS>RLS>GS>RE   mit unterschiedlichen Preisen

# Konto 470-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "0470FALL"
And I set field "such" to "FALL-470"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "0470FALL"
And I set field "such" to "FALL-470"
And I set field "bestausekso" to "FALL-470"
And I save the current editor
#NIO

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "470-FALL"
And I set field "num2" to "470-FALL"
And I set field "such" to "FALL-470"
And I set field "namebspr" to "FALL-470"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-470"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# Maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "470-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-470" in row 1
And I set field "mge" to "470" in row 1
And I set field "preis" to "470,46" in row 1
#
And I create a new row at the end of the table
And I set field "artex" to "FALL-470" in row 2
And I set field "mge" to "470" in row 2
And I set field "preis" to "470,92" in row 2
#
And I create a new row at the end of the table
And I set field "artex" to "FALL-470" in row 3
And I set field "mge" to "470" in row 3
And I set field "preis" to "470,23" in row 3
#
And I set field "kenn" to "FALL-470"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "470-BE"
And I close the current editor
 
# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-470" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "470-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "470" in row 1
#
And I set field "mge" to "230" in row 3
#
And I set field "kenn" to "FALL-470"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-470" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "470-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-470"
And I set field "num4" to "470-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "333" in row 1
And I set field "preis" to "470,41" in row 1
#
And I set field "mge" to "130" in row 2
And I set field "preis" to "520,01" in row 2
#
And I set field "kenn" to "FALL-470"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-470" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-470"
And I set field "num4" to "470-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-321" in row 1
And I set field "kenn" to "FALL-470 Ruecklieferschein"
And I save the current editor

# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein 
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "470-RLS"
And I close the current editor

# Kaufm. Gutschrift
Given I open an editor "gutschrift-470" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-470"
And I set field "num4" to "470-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-184" in row 1
And I set field "kenn" to "FALL-470"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+470-GS"
And I close the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-470" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+470-RE"
And I close the current editor


@Infosystem_RETURNPRELIMINARY
Scenario:  Infosystem starten RETURNPRELIMINARY
Given I open the infosystem "RETURNPRELIMINARY"
# Zum Tagesdatum alles erledigt
And I set field "konto" to "0470FALL"
And I press button "bstart"
Then the table has 0 rows
