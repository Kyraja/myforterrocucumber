Feature: Storno und Ruecklieferungen hier nur Einkauf
Background:
Given I set the fake date to "02.01.2002"
# Given I enable the flag 198
Given I enable the flag 91

#####################################################################################################################################

@FALL-221
Scenario: FALL-221 
# EK	Bestellung	Lieferschein	Rechnung (SPED)	Rechnung (empfänger)	Kostenumlage	Storno-Kostenumlage	Storno-Rechnung (empfänger)
# mit DIFF

# Konto 221-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "221-FALL"
And I set field "such" to "FALL-221"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "221-FALL"
And I set field "such" to "FALL-221"
And I set field "bestausekso" to "FALL-221"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "221-FALL"
And I set field "num2" to "221-FALL"
And I set field "such" to "FALL-221"
And I set field "namebspr" to "FALL-221"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-221"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "221-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-221" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "100" in row 1
And I set field "kenn" to "FALL-221"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "221-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-221" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "221-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-221"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "221-LS"
And I close the current editor

# Rechnung1 anlegen
Given I open an editor "rechnung-221-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "221-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "100" in row 1
And I set field "konto" to "FALL-221" in row 1
And I set field "kenn" to "FALL-221"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+221-RE1"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-221-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-221"
And I set field "num4" to "221-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-221"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+221-RE2"
And I close the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-221" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "221-KM" 
And I set field "pos" to "$,,kopf^nummer=221-RE1;art=TEXT;@ablageart=(Filed)"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=221-RE2;artex=FALL-221;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+221-KM"
And I close the current editor

# Storno Kostenumlage
Given I open an editor "kostenuml-storno" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record from editor "kostenuml-221"
And I set field "num135" to "221-STKM" 
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+221-STKM"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung-221-2"
And I set field "num4" to "221-STRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+221-STRE"
And I close the current editor

#####################################################################################################################################

@FALL-222
Scenario: FALL-222
# EK	Bestellung	Lieferschein	Rechnung (SPED)	Rechnung (empfänger)	Kostenumlage	Storno-Kostenumlage	Storno-Rechnung (empfänger)
#ohne DIFF

# Konto 222-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "222-FALL"
And I set field "such" to "FALL-222"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "222-FALL"
And I set field "such" to "FALL-222"
And I set field "bestausekso" to "FALL-222"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "222-FALL"
And I set field "num2" to "222-FALL"
And I set field "such" to "FALL-222"
And I set field "namebspr" to "FALL-222"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-222"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "222-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-222" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "100" in row 1
And I set field "kenn" to "FALL-222"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "222-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-222" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "222-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-222"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "222-LS"
And I close the current editor

# Rechnung1 anlegen
Given I open an editor "rechnung-222-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "222-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "1100" in row 1
And I set field "konto" to "FALL-222" in row 1
And I set field "kenn" to "FALL-222"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+222-RE1"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-222-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-222"
And I set field "num4" to "222-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-222"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+222-RE2"
And I close the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-222" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "222-KM" 
And I set field "pos" to "$,,kopf^nummer=222-RE1;art=TEXT;@ablageart=(Filed)"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=222-RE2;artex=FALL-222;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+222-KM"
And I close the current editor

# Storno Kostenumlage
Given I open an editor "kostenuml-storno" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record from editor "kostenuml-222"
And I set field "num135" to "222-STKM" 
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+222-STKM"
And I close the current editor

# Storno Rechnung
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung-222-2"
And I set field "num4" to "222-STRE"
And I save the current editor

# Ausgabe Storno Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+222-STRE"
And I close the current editor

#####################################################################################################################################

@FALL-2230
Scenario: FALL-2230 
# EK	Bestellung	Lieferschein	Rechnung (SPED)	Rechnung (empfänger)	Kostenumlage
# mit DIFF

# Konto 2230-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2230FALL"
And I set field "such" to "FALL-2230"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2230FALL"
And I set field "such" to "FALL-2230"
And I set field "bestausekso" to "FALL-2230"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2230-FALL"
And I set field "num2" to "2230-FALL"
And I set field "such" to "FALL-2230"
And I set field "namebspr" to "FALL-2230"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2230"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2230-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2230" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "100" in row 1
And I set field "kenn" to "FALL-2230"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2230-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2230" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "2230-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-2230"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2230-LS"
And I close the current editor

# Rechnung1 anlegen
Given I open an editor "rechnung-2230-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2230-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "100" in row 1
And I set field "konto" to "FALL-2230" in row 1
And I set field "kenn" to "FALL-2230"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2230-RE1"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2230-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2230"
And I set field "num4" to "2230-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2230"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2230-RE2"
And I close the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-2230" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "2230-KM" 
And I set field "pos" to "$,,kopf^nummer=2230-RE1;art=TEXT;@ablageart=(Filed)"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=2230-RE2;artex=FALL-2230;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+2230-KM"
And I close the current editor

#####################################################################################################################################

@FALL-2240
Scenario: FALL-2240 
# EK	Bestellung	Lieferschein	Rechnung (SPED)	Rechnung (empfänger)	Kostenumlage
#ohne DIFF

# Konto 2240-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "2240FALL"
And I set field "such" to "FALL-2240"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "2240FALL"
And I set field "such" to "FALL-2240"
And I set field "bestausekso" to "FALL-2240"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "2240-FALL"
And I set field "num2" to "2240-FALL"
And I set field "such" to "FALL-2240"
And I set field "namebspr" to "FALL-2240"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-2240"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2240-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-2240" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "100" in row 1
And I set field "kenn" to "FALL-2240"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "2240-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-2240" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "2240-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "kenn" to "FALL-2240"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "2240-LS"
And I close the current editor

# Rechnung1 anlegen
Given I open an editor "rechnung-2240-1" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "2240-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "TEXT" in row 1
And I set field "pwert" to "1100" in row 1
And I set field "konto" to "FALL-2240" in row 1
And I set field "kenn" to "FALL-2240"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2240-RE1"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-2240-2" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-2240"
And I set field "num4" to "2240-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "kenn" to "FALL-2240"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+2240-RE2"
And I close the current editor

# Kostenumlage erzeugen
Given I open an editor "kostenuml-2240" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "num135" to "2240-KM" 
And I set field "pos" to "$,,kopf^nummer=2240-RE1;art=TEXT;@ablageart=(Filed)"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,kopf^nummer=2240-RE2;artex=FALL-2240;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row 1
And I save the current editor

# Ausgabe Kostenumlage
Given I open an editor "kostenuml-view" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for record "+2240-KM"
And I close the current editor

#####################################################################################################################################
# 
# @FALL-444
# Scenario: Fall-444
# # EK Bestellung 
# # 3 Lieferscheine 
# # 1 Rechnungen mit unterschiedlichen Preisen 
# # Bestand wird von F1 nach F2 gebucht 
# # dann 15 zur zurück
# # Rücklieferung 15 Stück
# 
# # Konto 444-FALL mit Steuerregel
# Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
# And I set field "nummer" to "444-FALL"
# And I set field "such" to "FALL-444"
# And I set field "ktostrgl" to "EKIN-ALL"
# And I save the current editor
# 
# Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
# And I set field "nummer" to "444-FALL"
# And I set field "such" to "FALL-444"
# And I set field "bestausekso" to "FALL-444"
# And I save the current editor
# 
# # Artikel anlegen
# Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "444-FALL"
# And I set field "num2" to "444-FALL"
# And I set field "such" to "FALL-444"
# And I set field "namebspr" to "FALL-444"
# And I set field "bsart" to "Fremdbeschaffung"
# And I set field "dispoa" to "bedarfsbezogen"
# And I set field "lief" to "1"
# And I set field "wgruppe" to "FALL-444"
# And I set field "erlgrp" to "66"
# And I set field "ekbewverf" to "6"
# # maybe more
# And I save the current editor 
# 
# # Bestellung anlegen
# Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
# And I set field "lief" to "1"
# And I set field "num4" to "444-BE"
# And I create a new row at the end of the table
# And I set field "artex" to "FALL-444" in row 1
# And I set field "mge" to "444" in row 1
# And I set field "preis" to "444" in row 1
# And I set field "kenn" to "FALL-444"
# And I save the current editor
# 
# # Ausgabe Bestellung
# Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "444-BE"
# And I close the current editor
# 
# # Lieferschein zu Bestellung anlegen
# Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
# And I set field "beleg" to id from editor "bestellung-1"
# And I set field "num4" to "444-LS1"
# And I set field "ueb" to "ja"
# And I set field "vom" to "."
# And I set field "mge" to "30" in row 1
# And I set field "kenn" to "FALL-444"
# And I save the current editor
# 
# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
# 
# # Ausgabe Lieferschein
# Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "444-LS1"
# And I close the current editor
# 
# # Lieferschein2 zu Bestellung anlegen
# Given I open an editor "lieferschein-2" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
# And I set field "beleg" to id from editor "bestellung-1"
# And I set field "num4" to "444-LS2"
# And I set field "ueb" to "ja"
# And I set field "vom" to "."
# And I set field "mge" to "30" in row 1
# And I set field "kenn" to "FALL-444"
# And I save the current editor
# 
# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
# 
# # Ausgabe Lieferschein
# Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "444-LS2"
# And I close the current editor
# 
# # Lieferschein3 zu Bestellung anlegen
# Given I open an editor "lieferschein-3" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
# And I set field "beleg" to id from editor "bestellung-1"
# And I set field "num4" to "444-LS3"
# And I set field "ueb" to "ja"
# And I set field "vom" to "."
# And I set field "mge" to "30" in row 1
# And I set field "kenn" to "FALL-444"
# And I save the current editor
# 
# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
# 
# # Ausgabe Lieferschein
# Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "444-LS3"
# And I close the current editor
# 
# # Rechnung anlegen
# Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
# And I set field "beleg" to id from editor "lieferschein-1"
# And I set field "num4" to "444-RE"
# And I set field "ueb" to "ja"
# And I set field "vom" to "."
# # And I set field "mge" to "444" in row 1
# And I set field "preis" to "444,11" in row 1
# And I set field "beleg" to id from editor "lieferschein-2"
# And I set field "num4" to "444-RE"
# And I set field "ueb" to "ja"
# And I set field "vom" to "."
# # And I set field "mge" to "444" in row 3
# And I set field "preis" to "444,22" in row 3
# And I set field "beleg" to id from editor "lieferschein-3"
# And I set field "num4" to "444-RE"
# And I set field "ueb" to "ja"
# And I set field "vom" to "."
# # And I set field "mge" to "444" in row 5
# And I set field "preis" to "444,33" in row 5
# And I set field "kenn" to "FALL-444"
# And I respond with answer "Ja" to the dialog with id "4841"
# And I save the current editor
# 
# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
# 
# # Ausgabe Rechnung
# Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+444-RE"
# And I close the current editor
# 
# # Lagerbuchung Artikel  umbuchen
# Given I open an editor "Lagerbuchung01_um" for tip command "(Stockadjustment)" and arguments ""
# And I set field "artikel" to "FALL-444"
# And I set field "buart" to "Umbuchung"
# And I set field "beleg" to "L01"
# And I set field "beldat" to "."
# And I create a new row at the end of the table
# And I set field "mge" to "90" in row 1
# And I set field "platz" to "F1" in row 1
# And I set field "platz2" to "F2" in row 1
# And I save the current editor
# 
# # Lagerbuchung Artikel  zurück buchen
# Given I open an editor "Lagerbuchung01_um" for tip command "(Stockadjustment)" and arguments ""
# And I set field "artikel" to "FALL-444"
# And I set field "buart" to "Umbuchung"
# And I set field "beleg" to "L02"
# And I set field "beldat" to "."
# And I create a new row at the end of the table
# And I set field "mge" to "15" in row 1
# And I set field "platz" to "F2" in row 1
# And I set field "platz2" to "F1" in row 1
# And I save the current editor
# 
# # Rücklieferschein anlegen
# Given I open an editor "rls-444" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-2"
# And I set field "num4" to "444-RLS"
# And I set field "ueb" to "ja"
# And I set field "vom" to "."
# And I set field "mge" to "-10" in row 1
# And I set field "kenn" to "FALL-444 Ruecklieferschein"
# And I save the current editor
# 
# # Materialkostenverbuchung
# Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."
# 
# # Ausgabe Rücklieferschein Lieferschein
# Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "444-RLS"
# And I close the current editor
# 
#####################################################################################################################################

@FALL-555
Scenario: FALL-555
# EK Bestellung	Lieferschein 3 Rechnungen mit unterschiedlichen Preisen

# Konto 555-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "555-FALL"
And I set field "such" to "FALL-555"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "555-FALL"
And I set field "such" to "FALL-555"
And I set field "bestausekso" to "FALL-555"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "555-FALL"
And I set field "num2" to "555-FALL"
And I set field "such" to "FALL-555"
And I set field "namebspr" to "FALL-555"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-555"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "555-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-555" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "100" in row 1
And I set field "kenn" to "FALL-555"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "555-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "555-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "30" in row 1
And I set field "kenn" to "FALL-555"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "555-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "555-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "150" in row 1
And I set field "kenn" to "FALL-555"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+555-RE1"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "555-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "175" in row 1
And I set field "kenn" to "FALL-555"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+555-RE2"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "555-RE3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "200" in row 1
And I set field "kenn" to "FALL-555"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+555-RE3"
And I close the current editor

#####################################################################################################################################

@FALL-666
Scenario: FALL-666
# EK Bestellung	Lieferschein 3 Rechnungen mit unterschiedlichen Preisen

# Konto 666-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "666-FALL"
And I set field "such" to "FALL-666"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "666-FALL"
And I set field "such" to "FALL-666"
And I set field "bestausekso" to "FALL-666"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "666-FALL"
And I set field "num2" to "666-FALL"
And I set field "such" to "FALL-666"
And I set field "namebspr" to "FALL-666"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-666"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "666-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-666" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "100" in row 1
And I set field "kenn" to "FALL-666"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "666-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "666-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "kenn" to "FALL-666"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "666-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "666-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "150" in row 1
And I set field "kenn" to "FALL-666"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+666-RE1"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "666-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "175" in row 1
And I set field "kenn" to "FALL-666"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+666-RE2"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "666-RE3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "200" in row 1
And I set field "kenn" to "FALL-666"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+666-RE3"
And I close the current editor

#####################################################################################################################################

@FALL-777
Scenario: FALL-777
# EK Bestellung	Lieferschein 3 Rechnungen mit unterschiedlichen Preisen 1 Rücklieferschein

# Konto 777-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "777-FALL"
And I set field "such" to "FALL-777"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "777-FALL"
And I set field "such" to "FALL-777"
And I set field "bestausekso" to "FALL-777"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "777-FALL"
And I set field "num2" to "777-FALL"
And I set field "such" to "FALL-777"
And I set field "namebspr" to "FALL-777"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-777"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "777-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-777" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "100" in row 1
And I set field "kenn" to "FALL-777"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "777-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "777-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "kenn" to "FALL-777"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "777-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "777-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "150" in row 1
And I set field "kenn" to "FALL-777"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+777-RE1"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "777-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "175" in row 1
And I set field "kenn" to "FALL-777"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+777-RE2"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "777-RE3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "200" in row 1
And I set field "kenn" to "FALL-777"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+777-RE3"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-777" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "777-LS"
And I set field "num4" to "777-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "kenn" to "FALL-777 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "777-RLS"
And I close the current editor

#####################################################################################################################################

@FALL-888
Scenario: FALL-888
# EK Bestellung	Lieferschein 3 Rechnungen mit unterschiedlichen Preisen 1 Rücklieferschein Gutschrift

# Konto 888-FALL mit Steuerregel
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "888-FALL"
And I set field "such" to "FALL-888"
And I set field "ktostrgl" to "EKIN-ALL"
And I save the current editor

Given I open an editor "warengruppe" from table "(Company):(MaterialGroup)" with command "COPY" for record "55"
And I set field "nummer" to "888-FALL"
And I set field "such" to "FALL-888"
And I set field "bestausekso" to "FALL-888"
And I save the current editor

# Artikel anlegen
Given I open an editor "artikel" from table "(Part):(Product)" with command "STORE" for record "888-FALL"
And I set field "num2" to "888-FALL"
And I set field "such" to "FALL-888"
And I set field "namebspr" to "FALL-888"
And I set field "bsart" to "Fremdbeschaffung"
And I set field "dispoa" to "bedarfsbezogen"
And I set field "lief" to "1"
And I set field "wgruppe" to "FALL-888"
And I set field "erlgrp" to "66"
And I set field "ekbewverf" to "6"
# maybe more
And I save the current editor 

# Bestellung anlegen
Given I open an editor "bestellung-1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "888-BE"
And I create a new row at the end of the table
And I set field "artex" to "FALL-888" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "100" in row 1
And I set field "kenn" to "FALL-888"
And I save the current editor

# Ausgabe Bestellung
Given I open an editor "bestellung-view" from table "(Purchasing):(PurchaseOrder)" with command "VIEW" for record "888-BE"
And I close the current editor

# Lieferschein zu Bestellung anlegen
Given I open an editor "lieferschein-1" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "bestellung-1"
And I set field "num4" to "888-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "50" in row 1
And I set field "kenn" to "FALL-888"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "888-LS"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "888-RE1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "150" in row 1
And I set field "kenn" to "FALL-888"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+888-RE1"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "888-RE2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "175" in row 1
And I set field "kenn" to "FALL-888"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+888-RE2"
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "lieferschein-1"
And I set field "num4" to "888-RE3"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "10" in row 1
And I set field "preis" to "200" in row 1
And I set field "kenn" to "FALL-888"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rechnung
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+888-RE3"
And I close the current editor

# Rücklieferschein anlegen
Given I open an editor "rls-888" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "888-LS"
And I set field "num4" to "888-RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-31" in row 1
And I set field "kenn" to "FALL-888 Ruecklieferschein"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Rücklieferschein Lieferschein
Given I open an editor "lieferschein-view" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "888-RLS"
And I close the current editor

# Gutschrift
Given I open an editor "gutschrift-888" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "rls-888"
And I set field "num4" to "888-GS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# And I set field "mge" to "-51" in row 1
# And I set field "preis" to "100" in row 1
And I set field "kenn" to "FALL-888"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Materialkostenverbuchung
Given I create a CostEntriesSuggestion "mkv-000" with type of cost entry "Verbuchung Lagerbestand" for startdate "." until enddate "."

# Ausgabe Gutschrift
Given I open an editor "rechnung-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+888-GS"
And I close the current editor
