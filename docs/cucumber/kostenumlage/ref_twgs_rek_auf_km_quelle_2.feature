# *****************************************************************************
#  Name             : ref_twgs_rek_auf_km_quelle_2.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle      : 
# *****************************************************************************
@persistent
Feature: Kombinationen aus wertgutschrift auf eine DIENSTLEISTUNGSRECHNUNG (=KOSTENQUELLE) + kostenumlagen  

Background:
Given I set the fake date to "3.02.2002"



# ---------------------------------------------------------------------------------------------
Scenario: Daten vorbereiten
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "3.02.2002"

Given I open an editor "rechnung_fuer_alles" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
    | num4     | 1alles |
    | such4    | R1ALLES|
    | bem      | Nehmer fuer alle KMs |
    | lief     | 1      |
    | vom      | .      |
    | ueb      | ja     |
    | fakt     | ja     |
    | ebeleg   | MATRE1 |
    | budat    | .      |
    | erfwaehr |  GBP   |
And I append rows
    | artikel | mge | preis | tterm | ptext     | platz       |
    | E1EI-VO | 10  | 10,00 | +4    | kmzpos1ff | !dontChange |
    | E1EI-VO | 15  | 15,00 | +4    | kmzpos2ff | !dontChange |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: RE(3POS)---KM(nur1.POS)---WGS1(anlegen+verbuchen)---WGS1(ohne 1.POS:ändern+verbuchen)---WGS2(fuer Rest;nur anlegen)    mit Plausis
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "3.02.2002"

# graf:
#              ___KM(KM135-ADD, nur 1. POS aus RE)
#             /
#      (1)   /
# RE(135-add)------WGS1(135-wgs)----------WGS1(135-wgs)------------------WGS2(135-wgs2)(fuer Rest;nur anlegen)
#                  Anlegen: OK            Ändern: OK                     Anlegen: OK
#                  Verbuchen: !OK         Verbuchen: OK(ohne 1.POS)      Verbuchen: !OK
#                  Speichern: OK                                         Speichern: OK

Given I open an editor "km" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "KM135-ADD" 
And I set field "pos" to "$,,ptext==kost_qu_ek_15;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos15;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos11;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor
And I close the current editor

# Wertgutschrift1: Kommando Rechnung auf eine Rechnung
Given I open an editor "135-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+135-add"
And I set fields
   | nummer | 135-wgs|
   | such   | wgs135 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
Then the table has 6 rows
And I set field "pwert" to "-6" in row 1
And I set field "pwert" to "-9" in row 2
And I set field "pwert" to "-14" in row 3
# Meldung:
# Kaufmännische Gutschrift nicht möglich, weil die betroffene Rechnung als Quelle in der Kostenumlage (XXX,135,0) beinhaltet ist.
# Stornieren Sie zuerst die ursprüngliche(n) Kostenumlage(n) oder führen Sie diese zurück.
And saving the current editor throws the exception "9264"
And I set field "ueb" to "nein"
And I save the current editor
And I close the current editor

# Wertgutschrift weiterverarbeiten: Zeile mit KM entfernen
Given I open an editor "135-wgs" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "135-wgs"
And I set field "ueb" to "ja"
And I delete row at position 1
Then the table has 5 rows
And I save the current editor
And I close the current editor

# Wertgutschrift2: Kommando Rechnung auf eine Rechnung
# Kontrolle: was noch theoretisch wertgutgeschrieben werden kann
Given I open an editor "135-wgs2" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+135-add"
And I set fields
   | nummer | 135-wgs2|
   | such   | wgs135 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  nein  |
Then field "wertgutschrift" has value "ja" in row 0
Then the table has 6 rows
Then field "artikel" has value "TRANSPORT" in row 1
Then field "artikel" has value "TRANSPORT" in row 2
Then field "artikel" has value "TRANSPORT" in row 3
Then field "ofmge" has value "-10" in row 1
Then field "ofmge" has value "-20" in row 2
Then field "ofmge" has value "-30" in row 3
#
Then field "ofwert" has value "-10.00" in row 1
Then field "ofwert" has value "-11.00" in row 2
Then field "ofwert" has value "-16.00" in row 3

And I save the current editor
And I close the current editor

# ---------------------------------------------------------------------------------------------
Scenario: RE---KM1---KM2---WGS(anlegen)---WGS(verbuchen)    mit Plausis
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "3.02.2002"


# graf:
#               _______KM2(KM10-ADD2, 2. POS aus RE)
#              /
#             /__KM1(KM10-ADD1, 1. POS aus RE)
#            /
# RE(10kopie1)------------------WGS1(10wgs1)(alle 3POS aus RE)----------WGS1(10wgs1)(nur 3. POS)
#                               Anlegen: OK                             Ändern: OK
#                               Verbuchen: !OK                          Verbuchen: OK(ohne 1.POS)
#                               Speichern: OK


Given I open an editor "rechnung-kopieren" from table "(Purchasing):(Invoice)" with command "COPY" for record "+135-add"
And I set fields
   | nummer | 10kopie1|
   | such   | kopie10 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
Then field "wertgutschrift" has value "nein" in row 0
Then the table has 6 rows
And I set field "ptext" to "km_10_01" in row 1
And I set field "ptext" to "km_10_02" in row 2
And I set field "ptext" to "km_10_03" in row 3
And I save the current editor
And I close the current editor


# KM 1
Given I open an editor "km10-add1" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "KM10-ADD1" 
And I set field "pos" to "$,,ptext==km_10_01;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos15;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos11;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor
And I close the current editor


# KM 2
Given I open an editor "km10-add2" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "KM10-ADD2" 
And I set field "pos" to "$,,ptext==km_10_02;pwert==20;art==transport;twertgutschrift==nein;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos15;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos11;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor
And I close the current editor


# Wertgutschrift1: Kommando Rechnung auf eine Rechnung
Given I open an editor "10-wgs1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+10kopie1"
And I set fields
   | nummer | 10wgs1|
   | such   | wgs10 |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
Then the table has 6 rows
And I set field "pwert" to "-6" in row 1
And I set field "pwert" to "-9" in row 2
And I set field "pwert" to "-14" in row 3
# Meldung:
# Kaufmännische Gutschrift nicht möglich, weil die betroffene Rechnung als Quelle in der Kostenumlage (XXX,135,0) beinhaltet ist.
# Stornieren Sie zuerst die ursprüngliche(n) Kostenumlage(n) oder führen Sie diese zurück.
And saving the current editor throws the exception "9264"
And I set field "ueb" to "nein"
And I save the current editor
And I close the current editor


# Wertgutschrift weiterverarbeiten: Zeile mit KMs entfernen
Given I open an editor "10-wgs1_update" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "10wgs1"
And I set field "ueb" to "ja"
And I delete row at position 2
And I delete row at position 1
Then the table has 4 rows
And I save the current editor
And I close the current editor

# ---------------------------------------------------------------------------------------------
Scenario: RE---WGS1(1.und2.POS;nur anlegen)---KM(3.POS)---WGS1(verbuchen:1.und2.POS)---WGS2(anlegen+verbuchen)    mit Plausis
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "3.02.2002"


Given I open an editor "rechnung-kopieren" from table "(Purchasing):(Invoice)" with command "COPY" for record "+135-add"
And I set fields
   | nummer | 20kopie1|
   | such   | kopie20 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
Then field "wertgutschrift" has value "nein" in row 0
Then the table has 6 rows
And I set field "ptext" to "km_20_01" in row 1
And I set field "ptext" to "km_20_02" in row 2
And I set field "ptext" to "km_20_03" in row 3
And I save the current editor
And I close the current editor


# Wertgutschrift1: Kommando Rechnung auf eine Rechnung
Given I open an editor "20-wgs1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+20kopie1"
And I set fields
   | nummer | 20wgs1 |
   | such   | wgs20  |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  nein  |
Then the table has 6 rows
And I set field "pwert" to "-6" in row 1
And I set field "pwert" to "-9" in row 2
#
# !!! Position aus der 3.Zeile wird nicht wertgutgeschiebenen
And I delete row at position 3
Then the table has 5 rows
And I save the current editor
And I close the current editor


# KM 1
Given I open an editor "km20-add1" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "KM20-ADD1"
# 2930 TX=de   |Kostenumlagen zu wertgutgeschiebenen Rechnungspositionen sind nicht erlaubt.
Then setting field "pos" to "$,,ptext==km_20_01;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)" in row 0 throws the exception "2930"
#
And I set field "pos" to "$,,ptext==km_20_03;pwert==30;art==transport;twertgutschrift==nein;@ablageart=(Filed)"
#
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos15;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos11;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor
And I close the current editor

# versuchen Wertgutschrift zu verbuchen
Given I open an editor "20-wgs1" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "20wgs1"
And I set field "ueb" to "ja"
# Obwohl die Position aus der gleichen Rechnung ist wird sie nicht akzeptiert!!!
# 6822 TX=de   |Beleg anfügen bei Wertgutschrift nicht erlaubt.
Then setting field "beleg" to "$,,ptext==km_20_03;pwert==30;art==transport;twertgutschrift==nein;@ablageart=(Filed)" in row 0 throws the exception "6822"
Then the table has 5 rows
And I save the current editor
And I close the current editor

# Wertgutschrift2: Kommando Rechnung auf eine Rechnung
Given I open an editor "20-wgs2" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+20kopie1"
And I set fields
   | nummer | 20wgs2 |
   | such   | wgs20  |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
Then the table has 6 rows
And I press button "offueb" in row 1
And I set field "pwert" to "-2" in row 2
And I set field "pwert" to "-3" in row 3
#
Then the table has 6 rows
# Meldung:
# Kaufmännische Gutschrift nicht möglich, weil die betroffene Rechnung als Quelle in der Kostenumlage (XXX,135,0) beinhaltet ist.
# Stornieren Sie zuerst die ursprüngliche(n) Kostenumlage(n) oder führen Sie diese zurück.
And saving the current editor throws the exception "9264"
And I set field "ueb" to "nein"
And I save the current editor
And I close the current editor


# ---------------------------------------------------------------------------------------------
Scenario: RE---KM1---KM2---WGS(anlegen ueber "Beleg anfuegen")+(verbuchen)    mit Plausis
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "3.02.2002"


Given I open an editor "rechnung-kopieren" from table "(Purchasing):(Invoice)" with command "COPY" for record "+135-add"
And I set fields
   | nummer | 30kopie1|
   | such   | kopie30 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
Then field "wertgutschrift" has value "nein" in row 0
Then the table has 6 rows
And I set field "ptext" to "km_30_01" in row 1
And I set field "ptext" to "km_30_02" in row 2
And I set field "ptext" to "km_30_03" in row 3
And I save the current editor
And I close the current editor


# KM 1
Given I open an editor "km30-add1" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "KM30-ADD1" 
And I set field "pos" to "$,,ptext==km_30_01;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos15;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos11;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor
And I close the current editor


# KM 2
Given I open an editor "km30-add2" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "KM30-ADD2" 
And I set field "pos" to "$,,ptext==km_30_02;pwert==20;art==transport;twertgutschrift==nein;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos15;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos11;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor
And I close the current editor



Given I open an editor "wgs_ueber_rechnung_neu" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
Then field "wertgutschrift" has value "nein" in row 0
And I set field "beleg" to "+30kopie1"
Then field "wertgutschrift" has value "ja" in row 0
And I set fields
   | nummer | 30wgs1 |
   | such   | wgs30  |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja    |
Then the table has 6 rows
And I set field "pwert" to "-1" in row 1
And I set field "pwert" to "-2" in row 2
And I set field "pwert" to "-3" in row 3
# Meldung:
# Kaufmännische Gutschrift nicht möglich, weil die betroffene Rechnung als Quelle in der Kostenumlage (XXX,135,0) beinhaltet ist.
# Stornieren Sie zuerst die ursprüngliche(n) Kostenumlage(n) oder führen Sie diese zurück.
And saving the current editor throws the exception "9264"
And I set field "ueb" to "nein"
And I save the current editor
And I close the current editor


# ---------------------------------------------------------------------------------------------
Scenario: RE(3POS)---WGS1(anlegen ueber "Beleg anfuegen";nur 1.Zeile)---KM(fuer 3 POS)---WGS1(verbuchen)---WGS2(fuer anderen 2 Zeilen anfuegen;verbuchen)    mit Plausis
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "3.02.2002"


Given I open an editor "rechnung-kopieren" from table "(Purchasing):(Invoice)" with command "COPY" for record "+135-add"
And I set fields
   | nummer | 40kopie1|
   | such   | kopie40 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
Then field "wertgutschrift" has value "nein" in row 0
Then the table has 6 rows
And I set field "ptext" to "km_40_01" in row 1
And I set field "ptext" to "km_40_02" in row 2
And I set field "ptext" to "km_40_03" in row 3
And I save the current editor
And I close the current editor


Given I open an editor "wgs_ueber_rechnung_neu" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
Then field "wertgutschrift" has value "nein" in row 0
And I set field "beleg" to "$,,ptext==km_40_01;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)"
Then field "wertgutschrift" has value "ja" in row 0
And I set fields
   | nummer | 40wgs1 |
   | such   | wgs40  |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  nein  |
Then the table has 1 rows
And I set field "pwert" to "-1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# KM fuer Position 3
Given I open an editor "km40-add1" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "KM40-ADD1" 
And I set field "pos" to "$,,ptext==km_40_03;pwert==30;art==transport;twertgutschrift==nein;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos15;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos11;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor
And I close the current editor


# 10362 |Wertgutschrift/Rechnungskorrektur erstellen nicht möglich, da bereits ein anderer ungebuchter Vorgang vorhanden ist.
Given opening an editor from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+40kopie1" throws the exception "10362"
And I close the current editor


# WGS1 verbuchen, damit man andere WGS anlegen kann
Given I open an editor "40wgs1_buchen" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "40wgs1"
And I set field "ueb" to "ja"
And I save the current editor
And I close the current editor


Given I open an editor "wgs_ueber_rechnung_neu" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
Then field "wertgutschrift" has value "nein" in row 0
And I set field "beleg" to "$,,ptext==km_40_02;pwert==20;art==transport;twertgutschrift==nein;@ablageart=(Filed)"
#
# Anfügen anderen Positionen aus der gleichen Rechnung ist nicht möglich
# 6822 TX=de   |Beleg anfügen bei Wertgutschrift nicht erlaubt.
Then setting field "beleg" to "$,,ptext==km_40_03;pwert==30;art==transport;twertgutschrift==nein;@ablageart=(Filed)" in row 0 throws the exception "6822"
#
Then field "wertgutschrift" has value "ja" in row 0
And I set fields
   | nummer | 40wgs2 |
   | such   | wgs40  |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  ja  |
Then the table has 1 rows
And I set field "pwert" to "-2" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# ---------------------------------------------------------------------------------------------
Scenario: RE---KM---WGS(anlegen)---SKM---WGS(verbuchen)    mit Plausis
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "3.02.2002"


Given I open an editor "rechnung-kopieren" from table "(Purchasing):(Invoice)" with command "COPY" for record "+135-add"
And I set fields
   | nummer | 50kopie1|
   | such   | kopie50 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
Then field "wertgutschrift" has value "nein" in row 0
Then the table has 6 rows
And I set field "ptext" to "km_50_01" in row 1
And I set field "ptext" to "km_50_02" in row 2
And I set field "ptext" to "km_50_03" in row 3
And I save the current editor
And I close the current editor


# KM 1
Given I open an editor "km50-add1" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "KM50-ADD1" 
And I set field "pos" to "$,,ptext==km_50_01;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos15;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos11;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor
And I close the current editor


# Wertgutschrift1: Kommando Rechnung auf eine Rechnung
Given I open an editor "50-wgs1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+50kopie1"
And I set fields
   | nummer | 50wgs1 |
   | such   | wgs50  |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  nein  |
Then the table has 6 rows
And I set field "pwert" to "-4" in row 1
And I set field "pwert" to "-6" in row 2
And I set field "pwert" to "-9" in row 3
Then field "wertgutschrift" has value "ja" in row 0
And I save the current editor
And I close the current editor


# STORNO-KM 1
Given I open an editor "km50-add1-storno" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+KM50-ADD1"
And I save the current editor
And I close the current editor


# WGS1 verbuchen, damit man andere WGS anlegen kann
Given I open an editor "50wgs1_buchen" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "50wgs1"
And I set field "ueb" to "ja"
And I save the current editor
And I close the current editor


# ---------------------------------------------------------------------------------------------
Scenario: RE---KM---WGS(anlegen)---RKM---WGS(verbuchen)---SRKM    mit Plausis
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "3.02.2002"


Given I open an editor "rechnung-kopieren" from table "(Purchasing):(Invoice)" with command "COPY" for record "+135-add"
And I set fields
   | nummer | 60kopie1|
   | such   | kopie60 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
Then field "wertgutschrift" has value "nein" in row 0
Then the table has 6 rows
And I set field "ptext" to "km_60_01" in row 1
And I set field "ptext" to "km_60_02" in row 2
And I set field "ptext" to "km_60_03" in row 3
And I save the current editor
And I close the current editor


# KM 1
Given I open an editor "km60-add1" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "KM60-ADD1" 
And I set field "pos" to "$,,ptext==km_60_01;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos15;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos11;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor
And I close the current editor


# Wertgutschrift1: Kommando Rechnung auf eine Rechnung
Given I open an editor "60-wgs1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+60kopie1"
And I set fields
   | nummer | 60wgs1 |
   | such   | wgs60  |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  nein  |
Then the table has 6 rows
And I set field "pwert" to "-4" in row 1
And I set field "pwert" to "-6" in row 2
And I set field "pwert" to "-9" in row 3
Then field "wertgutschrift" has value "ja" in row 0
And I save the current editor
And I close the current editor


# Rüchführung von KM 1
Given I open an editor "kmr" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "such" to "rueck60"
And I set field "origvorg" to "+KM60-ADD1"
And I save the current editor
And I close the current editor


# WGS1 verbuchen, damit man andere WGS anlegen kann
Given I open an editor "60wgs1_buchen" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "60wgs1"
And I set field "ueb" to "ja"
And I save the current editor
And I close the current editor


# STORNO-Rückführung: STORNO-Rückführung darf an der Stelle nicht passieren!!!
#
# 2921 de |Stornierungen von Kostenumlagerückführungen zu Rechnungspositionen mit Wertgutschrift sind nicht erlaubt.
Given opening an editor from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+rueck60" throws the exception "2921"
And I close the current editor


# ---------------------------------------------------------------------------------------------
Scenario: RE---KM---WGS(anlegen)---RKM(nur1.Zeile)---WGS(verbuchen)    mit Plausis
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "3.02.2002"


Given I open an editor "rechnung-kopieren" from table "(Purchasing):(Invoice)" with command "COPY" for record "+135-add"
And I set fields
   | nummer | 70kopie1|
   | such   | kopie70 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
Then field "wertgutschrift" has value "nein" in row 0
Then the table has 6 rows
And I set field "ptext" to "km_70_01" in row 1
And I set field "ptext" to "km_70_02" in row 2
And I set field "ptext" to "km_70_03" in row 3
And I save the current editor
And I close the current editor


# KM 1
Given I open an editor "km70-add1" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "KM70-ADD1" 
And I set field "pos" to "$,,ptext==km_70_01;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos15;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos11;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor
And I close the current editor


# Wertgutschrift1: Kommando Rechnung auf eine Rechnung
Given I open an editor "70-wgs1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+70kopie1"
And I set fields
   | nummer | 70wgs1 |
   | such   | wgs70  |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  nein  |
Then the table has 6 rows
And I set field "pwert" to "-4" in row 1
And I set field "pwert" to "-6" in row 2
And I set field "pwert" to "-9" in row 3
Then field "wertgutschrift" has value "ja" in row 0
And I save the current editor
And I close the current editor


# Rüchführung von KM 1: nur eine Zeile
Given I open an editor "kmr" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "such" to "rueck70"
And I set field "origvorg" to "+KM70-ADD1"
And I set field "zurueckfuehren" to "nein" in row 1
Then the table has 2 rows
And I save the current editor
And I close the current editor


# Versuch WGS1 zu verbuchen -> KM wurde nicht komplett zurückgeführt
Given I open an editor "70wgs1_buchen" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "70wgs1"
And I set field "ueb" to "ja"
# Meldung:
# Kaufmännische Gutschrift nicht möglich, weil die betroffene Rechnung als Quelle in der Kostenumlage (XXX,135,0) beinhaltet ist.
# Stornieren Sie zuerst die ursprüngliche(n) Kostenumlage(n) oder führen Sie diese zurück.
And saving the current editor throws the exception "9264"
And I set field "ueb" to "nein"
And I save the current editor
And I close the current editor



# ---------------------------------------------------------------------------------------------
Scenario: RE---KM---WGS(anlegen)---WGS(verbuchen über Kommando "Übertragen")    mit Plausis
# ---------------------------------------------------------------------------------------------
Given I set the fake date to "3.02.2002"


Given I open an editor "rechnung-kopieren" from table "(Purchasing):(Invoice)" with command "COPY" for record "+135-add"
And I set fields
   | nummer | 80kopie1|
   | such   | kopie80 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
Then field "wertgutschrift" has value "nein" in row 0
Then the table has 6 rows
And I set field "ptext" to "km_80_01" in row 1
And I set field "ptext" to "km_80_02" in row 2
And I set field "ptext" to "km_80_03" in row 3
And I save the current editor
And I close the current editor


# KM 1
Given I open an editor "km80-add1" from table "(CostDistribution):(CostDistribution)" with command "NEW" for record ""
And I set field "such" to "KM80-ADD1" 
And I set field "pos" to "$,,ptext==km_80_01;pwert==10;art==transport;twertgutschrift==nein;@ablageart=(Filed)"
And I set field "fibuumbuch" to "ja"
And I set field "umlagemeth" to "Wert"
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos15;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I create a new row at the end of the table
And I set field "pos" to "$,,ptext==kmzpos11;@gruppe=2;@datenbank=4;@ablageart=(Filed)" in row !lastRow
And I save the current editor
And I close the current editor


# Wertgutschrift1: Kommando Rechnung auf eine Rechnung
Given I open an editor "80-wgs1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+80kopie1"
And I set fields
   | nummer | 80wgs1 |
   | such   | wgs80  |
   | tterm  | .      |
   | budat  | .      |
   | vom    | .      |
   | ueb    |  nein  |
Then the table has 6 rows
And I set field "pwert" to "-4" in row 1
And I set field "pwert" to "-6" in row 2
And I set field "pwert" to "-9" in row 3
Then field "wertgutschrift" has value "ja" in row 0
And I save the current editor


# das Kommando "Übertragen" verbucht die WGS nicht!!!
Given I open an editor "wgs_uebertragen" from table "(Purchasing):(Invoice)" with command "TRANSFER" for record from editor "80-wgs1"
# Meldung:
# Kaufmännische Gutschrift nicht möglich, weil die betroffene Rechnung als Quelle in der Kostenumlage (XXX,135,0) beinhaltet ist.
# Stornieren Sie zuerst die ursprüngliche(n) Kostenumlage(n) oder führen Sie diese zurück.
And saving the current editor throws the exception "9264"
#
# 3886 TX=de   |Aktion jetzt nicht möglich
Then setting field "ueb" to "nein" in row 0 throws the exception "3886"
And I close the current editor


# WGS "80-wgs1" wurde nicht gebucht!!! Kontrolle
Given I open an editor "rechnung-kontrolle" from table "(Purchasing):(Invoice)" with command "VIEW" for record "wgs80"
Then field "wertgutschrift" has value "ja" in row 0
Then field "uebertr" has value "ja" in row 0
Then the table has 6 rows
And I close the current editor

