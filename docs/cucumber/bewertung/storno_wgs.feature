# *****************************************************************************
#  Name           : storno_wgs.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Darstellung von Geschäftsprozessen mit (Teil-)Wertgutschriften und Storno der (Teil-)Wertgutschriften
#
#
# *****************************************************************************
@persistent
Feature: ref_storno_wgs_cu
Background:
Given I set the fake date to "03.02.1995"

# -----------------------------------------------------------------------------------------------------------
Scenario: 01a Stammdaten (Lagerplätze angleichen, Artikel anlegen)
#-----------------------------------------------------------------------------------------------------------
Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "e1"
And I set field "abplatz" to "f1"
And I save the current editor
And I close the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "COPY" for record "e1"
And I set field "such" to "e100"
And I save the current editor
And I close the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "COPY" for record "e1"
And I set field "such" to "e200"
And I save the current editor
And I close the current editor

# -----------------------------------------------------------------------------------------------------------
Scenario: 01b Stammdaten (Konten anlegen)
# -----------------------------------------------------------------------------------------------------------
Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "10100"
And I set field "such" to "K10100"
And I set field "namebspr" to "Rohstoffe"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "10200"
And I set field "such" to "K10200"
And I set field "namebspr" to "Rohstoffe"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "10300"
And I set field "such" to "K10300"
And I set field "namebspr" to "Rohstoffe"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "10400"
And I set field "such" to "K10400"
And I set field "namebspr" to "Rohstoffe"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "10600"
And I set field "such" to "K10600"
And I set field "namebspr" to "Rohstoffe"
And I save the current editor

Given I open an editor "konto" from table "(Account):(Account)" with command "COPY" for record "10000"
And I set field "nummer" to "10700"
And I set field "such" to "K10700"
And I set field "namebspr" to "Rohstoffe"
And I save the current editor

# -----------------------------------------------------------------------------------------------------------
Scenario: 02 BE(m10;p12)-REoLB(m10;p10)-TWGS1(m-2;p10)-TWGS2(m-1;p10)-TWGS3(m-0,5;p10)-LS(m10;p12)-StornoTWGS(m-1;p10)
# -----------------------------------------------------------------------------------------------------------
# Bestellung
Given I open an editor "bestellung1" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 100BE  |
    | such4    | BE100  |
    | vom      | .      |
    | ebeleg   | BE1    |
    | erfwaehr | dem    |
    | budat    | .      |
And I append rows
| artikel | mge | preis |konto      | ptext      |
| E1      | 10  | 12,00 | 10100     |            |
| E2      | 15  | 15,00 | 10200     |            |
And I save the current editor
And I close the current editor

# EK-Rechnung
Given I set the fake date to "10.02.1995"
Given I open an editor "rechnung1" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "bestellung1"
And I set fields
    | lief     | 1       |
    | num4     | 100RE   |
    | such4    | RE100   |
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | RE1     |
    | budat    | .       |
    | erfwaehr | dem     |
And I press button "offueb" in row 1
And I set field "preis" to "10" in row 1
And I press button "offueb" in row 2
And I set field "preis" to "13" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I execute shell command "echo \"=== Bewertungssammler BE100 ===\" > ref_storno_wgs_cu.ref"
Given I execute shell command "echo \"Bewertungssammler nach Rechnung\" >> ref_storno_wgs_cu.ref"
Given I execute shell command "edpexport.sh -p sy -F -f id,empfaenger,bewempf,art,elem,zn,kart,kosten1,kosten2,datum,budat,mge,kverur,addkosten -O TAB -k \"@datei=57;@gruppe=3\" >> ref_storno_wgs_cu.ref"


# Teilwertgutschrift 1
Given I set the fake date to "04.03.1995"
Given I open an editor "100-wgs1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+100RE"
And I set fields
   | nummer | 100WGS1 |
   | such   | WGS1100 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
# Teilwertgutschrift erstellen
And I set field "mge" to "-2" in row 1
Then the table has 5 rows
And I save the current editor

Given I execute shell command "echo \"Bewertungssammler nach TWGS1\" >> ref_storno_wgs_cu.ref"
Given I execute shell command "edpexport.sh -p sy -F -f id,empfaenger,bewempf,art,elem,zn,kart,kosten1,kosten2,datum,budat,mge,kverur,addkosten -O TAB -k \"@datei=57;@gruppe=3\" >> ref_storno_wgs_cu.ref"

# Teilwertgutschrift 2
Given I set the fake date to "12.03.1995"
Given I open an editor "100-wgs2" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+100RE"
And I set fields
   | nummer | 100WGS2 |
   | such   | WGS2100 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
# Teilwertgutschrift erstellen
And I set field "mge" to "-1" in row 1
Then the table has 5 rows
And I save the current editor

Given I execute shell command "echo \"Bewertungssammler nach TWGS2\" >> ref_storno_wgs_cu.ref"
Given I execute shell command "edpexport.sh -p sy -F -f id,empfaenger,bewempf,art,elem,zn,kart,kosten1,kosten2,datum,budat,mge,kverur,addkosten -O TAB -k \"@datei=57;@gruppe=3\" >> ref_storno_wgs_cu.ref"


# Teilwertgutschrift 3
Given I set the fake date to "20.03.1995"
Given I open an editor "100-wgs3" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+100RE"
And I set fields
   | nummer | 100WGS3 |
   | such   | WGS3100 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
# Teilwertgutschrift erstellen
And I set field "mge" to "-0.5" in row 1
Then the table has 5 rows
And I save the current editor

Given I execute shell command "echo \"Bewertungssammler nach TWGS3\" >> ref_storno_wgs_cu.ref"
Given I execute shell command "edpexport.sh -p sy -F -f id,empfaenger,bewempf,art,elem,zn,kart,kosten1,kosten2,datum,budat,mge,kverur,addkosten -O TAB -k \"@datei=57;@gruppe=3\" >> ref_storno_wgs_cu.ref"


# Lieferschein
Given I set the fake date to "01.04.1995"
Given I open an editor "lieferschein1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "100BE"
And I set fields
    | lief     | 1       |
    | num4     | 100LS   |
    | such4    | LS100   |
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | LS      |
    | erfwaehr | dem     |
And I press button "offueb" in row 1
And I press button "offueb" in row 2
And I save the current editor
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# Storno Teilwertgutschrift 2 (zweite TWGS darf nicht vor dritter TWGS storniert werden)
Given I set the fake date to "05.05.1995"
# Stornieren Sie zuerst dieses Objekt.
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "100-wgs2" throws the exception "3335"

# Storno der dritten WGS erlaubt
Given I set the fake date to "05.05.1995"
Given I open an editor "Storno 100-wgs3" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "100-wgs3"
And I set fields
    | num4     | 100STO1     |
And I save the current editor

Given I execute shell command "echo \"Bewertungssammler nach Storno TWGS3\" >> ref_storno_wgs_cu.ref"
Given I execute shell command "edpexport.sh -p sy -F -f id,empfaenger,bewempf,art,elem,zn,kart,kosten1,kosten2,datum,budat,mge,kverur,addkosten -O TAB -k \"@datei=57;@gruppe=3\" >> ref_storno_wgs_cu.ref"

# -----------------------------------------------------------------------------------------------------------
Scenario: 03 BE(m100;p10)-REoLB(m100;p10)-LS(m50)-TWGS1(m-100;p1)-TWGS2(m-100;p1)-TWGS3(m-100;p1)-LS(m50)
# -----------------------------------------------------------------------------------------------------------
# Bestellung
Given I set the fake date to "06.05.1995"
Given I open an editor "bestellung2" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 200BE  |
    | such4    | BE200  |
    | vom      | .      |
    | ebeleg   | BE2    |
    | erfwaehr | dem    |
    | budat    | .      |
And I append rows
| artikel | mge | preis |konto      | ptext      |
| E1      | 100 | 10,00 | 10300     |            |
And I save the current editor
And I close the current editor

# EK-Rechnung
Given I set the fake date to "10.05.1995"
Given I open an editor "rechnung1" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "bestellung2"
And I set fields
    | lief     | 1       |
    | num4     | 200RE   |
    | such4    | RE200   |
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | RE2     |
    | budat    | .       |
    | erfwaehr | dem     |
And I press button "offueb" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I execute shell command "echo \"=== Bewertungssammler BE200 ===\" >> ref_storno_wgs_cu.ref"
Given I execute shell command "echo \"Bewertungssammler nach Rechnung\" >> ref_storno_wgs_cu.ref"
Given I execute shell command "edpexport.sh -p sy -F -f id,empfaenger,bewempf,art,elem,zn,kart,kosten1,kosten2,datum,budat,mge,kverur,addkosten -O TAB -k \"@datei=57;@gruppe=3\" >> ref_storno_wgs_cu.ref"

# Lieferschein 1
Given I set the fake date to "01.06.1995"
Given I open an editor "lieferschein2-1" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "200BE"
And I set fields
    | lief     | 1       |
    | num4     | 200LS1  |
    | such4    | LS1200  |
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | LS      |
    | erfwaehr | dem     |
And I set field "mge" to "50" in row 1
And I save the current editor
And I close the current editor

# Teilwertgutschrift 1
Given I set the fake date to "06.06.1995"
Given I open an editor "200-wgs1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+200RE"
And I set fields
   | nummer | 200WGS1 |
   | such   | WGS1200 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
# Teilwertgutschrift erstellen
And I press button "offueb" in row 1
And I set field "preis" to "1" in row 1
Then the table has 4 rows
And I save the current editor

Given I execute shell command "echo \"Bewertungssammler nach TWGS1\" >> ref_storno_wgs_cu.ref"
Given I execute shell command "edpexport.sh -p sy -F -f id,empfaenger,bewempf,art,elem,zn,kart,kosten1,kosten2,datum,budat,mge,kverur,addkosten -O TAB -k \"@datei=57;@gruppe=3\" >> ref_storno_wgs_cu.ref"

# Teilwertgutschrift 2
Given I set the fake date to "08.06.1995"
Given I open an editor "200-wgs2" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+200RE"
And I set fields
   | nummer | 200WGS2 |
   | such   | WG21200 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
# Teilwertgutschrift erstellen
And I press button "offueb" in row 1
And I set field "preis" to "1" in row 1
Then the table has 4 rows
And I save the current editor

Given I execute shell command "echo \"Bewertungssammler nach TWGS2\" >> ref_storno_wgs_cu.ref"
Given I execute shell command "edpexport.sh -p sy -F -f id,empfaenger,bewempf,art,elem,zn,kart,kosten1,kosten2,datum,budat,mge,kverur,addkosten -O TAB -k \"@datei=57;@gruppe=3\" >> ref_storno_wgs_cu.ref"

# Teilwertgutschrift 3
Given I set the fake date to "10.06.1995"
Given I open an editor "200-wgs3" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+200RE"
And I set fields
   | nummer | 200WGS3 |
   | such   | WG31200 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
# Teilwertgutschrift erstellen
And I press button "offueb" in row 1
And I set field "preis" to "1" in row 1
Then the table has 4 rows
And I save the current editor

Given I execute shell command "echo \"Bewertungssammler nach TWGS3\" >> ref_storno_wgs_cu.ref"
Given I execute shell command "edpexport.sh -p sy -F -f id,empfaenger,bewempf,art,elem,zn,kart,kosten1,kosten2,datum,budat,mge,kverur,addkosten -O TAB -k \"@datei=57;@gruppe=3\" >> ref_storno_wgs_cu.ref"

# Lieferschein 2
Given I set the fake date to "14.06.1995"
Given I open an editor "lieferschein2-2" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "200BE"
And I set fields
    | lief     | 1       |
    | num4     | 200LS2  |
    | such4    | LS2200  |
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | LS      |
    | erfwaehr | dem     |
And I set field "mge" to "50" in row 1
And I save the current editor
And I close the current editor

Given I execute shell command "echo \"Bewertungssammler nach LS2\" >> ref_storno_wgs_cu.ref"
Given I execute shell command "edpexport.sh -p sy -F -f id,empfaenger,bewempf,art,elem,zn,kart,kosten1,kosten2,datum,budat,mge,kverur,addkosten -O TAB -k \"@datei=57;@gruppe=3\" >> ref_storno_wgs_cu.ref"

# Storno TWGS3
Given I set the fake date to "02.07.1995"
Given I open an editor "Storno 200-wgs3" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "200-wgs3"
And I set fields
    | num4     | 200STO1     |
And I save the current editor

Given I execute shell command "echo \"Bewertungssammler nach Storno TWGS3\" >> ref_storno_wgs_cu.ref"
Given I execute shell command "edpexport.sh -p sy -F -f id,empfaenger,bewempf,art,elem,zn,kart,kosten1,kosten2,datum,budat,mge,kverur,addkosten -O TAB -k \"@datei=57;@gruppe=3\" >> ref_storno_wgs_cu.ref"

# -----------------------------------------------------------------------------------------------------------
Scenario: 04 BE(m10;p10)-REoLB(m10;p11)-100%WGS-LS(m10,p10)-Storno 100%WGS1
# -----------------------------------------------------------------------------------------------------------
# Bestellung
Given I set the fake date to "10.07.1995"
Given I open an editor "bestellung3" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 300BE  |
    | such4    | BE300  |
    | vom      | .      |
    | ebeleg   | BE3    |
    | erfwaehr | dem    |
    | budat    | .      |
And I append rows
| artikel | mge | preis |konto      | ptext      |
| E1      | 10  | 10,00 | 10400     |            |
And I save the current editor
And I close the current editor

# EK-Rechnung
Given I set the fake date to "14.07.1995"
Given I open an editor "rechnung3" from table "(Purchasing):(PurchaseOrder)" with command "INVOICE" for record from editor "bestellung3"
And I set fields
    | lief     | 1       |
    | num4     | 300RE   |
    | such4    | RE300   |
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | RE3     |
    | budat    | .       |
    | erfwaehr | dem     |
And I press button "offueb" in row 1
And I set field "preis" to "11" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I execute shell command "echo \"=== Bewertungssammler BE300 ===\" >> ref_storno_wgs_cu.ref"
Given I execute shell command "echo \"Bewertungssammler nach Rechnung\" >> ref_storno_wgs_cu.ref"
Given I execute shell command "edpexport.sh -p sy -F -f id,empfaenger,bewempf,art,elem,zn,kart,kosten1,kosten2,datum,budat,mge,kverur,addkosten -O TAB -k \"@datei=57;@gruppe=3\" >> ref_storno_wgs_cu.ref"

# Wertgutschrift
Given I set the fake date to "20.07.1995"
Given I open an editor "300-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+300RE"
And I set fields
   | nummer | 300WGS  |
   | such   | WGS300  |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
# Komplettwertgutschrift erstellen
And I press button "komplettieren"
Then the table has 4 rows
And I save the current editor

Given I execute shell command "echo \"Bewertungssammler nach WGS \" >> ref_storno_wgs_cu.ref"
Given I execute shell command "edpexport.sh -p sy -F -f id,empfaenger,bewempf,art,elem,zn,kart,kosten1,kosten2,datum,budat,mge,kverur,addkosten -O TAB -k \"@datei=57;@gruppe=3\" >> ref_storno_wgs_cu.ref"

# Lieferschein
Given I set the fake date to "30.07.1995"
Given I open an editor "lieferschein3" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "300BE"
And I set fields
    | lief     | 1       |
    | num4     | 300LS   |
    | such4    | LS300   |
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | LS      |
    | erfwaehr | dem     |
And I press button "offueb" in row 1
And I save the current editor
And I close the current editor

# Storno WGS: wird per Plausi verhindert. Sonst wird nach Storno der WGS keine Nachfolgebewertung erzeugt und die Bewertung bliebe auf LS-Status trotz vorhandener Rechnung.
Given I set the fake date to "02.08.1995"
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "300-wgs" throws the exception "3335"

Given I execute shell command "echo \"Bewertungssammler nach Storno WGS\" >> ref_storno_wgs_cu.ref"
Given I execute shell command "edpexport.sh -p sy -F -f id,empfaenger,bewempf,art,elem,zn,kart,kosten1,kosten2,datum,budat,mge,kverur,addkosten -O TAB -k \"@datei=57;@gruppe=3\" >> ref_storno_wgs_cu.ref"

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor

# -------------------------------------------------------------------------------------------------------------------------------
Scenario: 05 BE(m10;p10)-LS(m10;p10)-RE(m6;p11)-RE(m4;p12)-TWGS(m-2;p6)-TWGS(m-6;p11)-TRLS(m-9)-KGS(m-1;p1,8)-StornoTWGS(m-6;p11)
# -------------------------------------------------------------------------------------------------------------------------------
# Bestellung
Given I set the fake date to "05.08.1995"
Given I open an editor "bestellung4" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 400BE  |
    | such4    | BE400  |
    | vom      | .      |
    | ebeleg   | BE4    |
    | erfwaehr | dem    |
    | budat    | .      |
And I append rows
| artikel | mge | preis |konto      | ptext      |
| E1      | 10  | 10,00 | 10600     |            |
And I save the current editor
And I close the current editor

# Lieferschein
Given I set the fake date to "08.08.1995"
Given I open an editor "lieferschein4" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "400BE"
And I set fields
    | lief     | 1       |
    | num4     | 400LS   |
    | such4    | LS400   |
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | LS      |
    | erfwaehr | dem     |
And I press button "offueb" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.07." until enddate "31.8." with Command Revalue


# EK-Rechnung 1
Given I set the fake date to "10.08.1995"
Given I open an editor "rechnung4-1" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "lieferschein4"
And I set fields
    | lief     | 1       |
    | num4     | 400RE1  |
    | such4    | RE1400  |
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | RE4.1   |
    | budat    | .       |
    | erfwaehr | dem     |
And I set field "mge" to "6" in row 1
And I set field "preis" to "11" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.08." until enddate "31.08." with Command Revalue

# EK-Rechnung 2
Given I set the fake date to "12.08.1995"
Given I open an editor "rechnung4-2" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "lieferschein4"
And I set fields
    | lief     | 1       |
    | num4     | 400RE2  |
    | such4    | RE2400  |
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | RE4.2   |
    | budat    | .       |
    | erfwaehr | dem     |
And I set field "mge" to "4" in row 1
And I set field "preis" to "12" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.08." until enddate "31.08." with Command Revalue

# Teilwertgutschrift 1
Given I set the fake date to "14.08.1995"
Given I open an editor "400-wgs1" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+400RE1"
And I set fields
   | nummer | 400WGS1 |
   | such   | WGS4001 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
# mit dieser TWGS vermindert sich der Positionswert der 400RE1 von 66 EUR um 12 EUR auf 54 EUR
And I set field "mge" to "-2" in row 1
And I set field "preis" to "6" in row 1
Then the table has 4 rows
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.08." until enddate "31.08." with Command Revalue

# Teilwertgutschrift 2
Given I set the fake date to "16.08.1995"
Given I open an editor "400-wgs2" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+400RE1"
And I set fields
   | nummer | 400WGS2 |
   | such   | WGS4002 |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
# mit dieser TWGS würde sich der Positionswert der 400RE1 von mittlerweile 54 EUR um 66 EUR verringern; es kann nur eine Verringerung von 54 EUR stattfinden
And I set field "mge" to "-6" in row 1
And I set field "preis" to "11" in row 1
Then the table has 4 rows
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.08." until enddate "31.08." with Command Revalue

# Teilruecklieferschein anlegen
Given I set the fake date to "18.08.1995"
Given I open an editor "rls-400" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein4"
And I set field "num4" to "400RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-9" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.08." until enddate "31.08." with Command Revalue

# kfm. Gutschrift
Given I set the fake date to "20.08.1995"
Given I open an editor "kgs-400" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-400"
And I set field "num4" to "400-KGS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 2 rows
Then table has values
  | art       | mge  | preis         | remge |
  | E1        | -6   |   0.00        | -6    |
  | E1        | -3   |  12.00        | -3    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.08." until enddate "31.08." with Command Revalue

# Storno Teil-WGS2
Given I set the fake date to "22.08.1995"
Given I open an editor "Storno 400-wgs2" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "400-wgs2"
And I set fields
    | num4     | 400STO1     |
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.08." until enddate "31.08." with Command Revalue


# -------------------------------------------------------------------------------------------------------------------------------
Scenario: 06 BE(m10;p10)-LS(m10;p10)-RE(m10;p12)-TWGS(m-2;p6)-TRLS(m-9;p10,80)-KGS(m-9;p10,8)-StornoTWGS_Plausi
# -------------------------------------------------------------------------------------------------------------------------------
# Bestellung
Given I set the fake date to "24.08.1995"
Given I open an editor "bestellung5" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set fields
    | lief     | 1      |
    | num4     | 500BE  |
    | such4    | BE500  |
    | vom      | .      |
    | ebeleg   | BE5    |
    | erfwaehr | dem    |
    | budat    | .      |
And I append rows
| artikel | mge | preis |konto      | ptext      |
| E200    | 10  | 10,00 | 10700     |            |
And I save the current editor
And I close the current editor

# Lieferschein
Given I set the fake date to "26.08.1995"
Given I open an editor "lieferschein5" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record "500BE"
And I set fields
    | lief     | 1       |
    | num4     | 500LS   |
    | such4    | LS500   |
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | LS      |
    | erfwaehr | dem     |
And I press button "offueb" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "31.8." with Command Revalue


# EK-Rechnung
Given I set the fake date to "28.08.1995"
Given I open an editor "rechnung5" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "lieferschein5"
And I set fields
    | lief     | 1       |
    | num4     | 500RE   |
    | such4    | RE500   |
    | vom      | .       |
    | ueb      | ja      |
    | ebeleg   | RE5     |
    | budat    | .       |
    | erfwaehr | dem     |
And I set field "mge" to "10" in row 1
And I set field "preis" to "12" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.08." until enddate "31.08." with Command Revalue

# Teilwertgutschrift
Given I set the fake date to "30.08.1995"
Given I open an editor "500-wgs" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+500RE"
And I set fields
   | nummer | 500WGS  |
   | such   | WGS500  |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
# mit dieser TWGS vermindert sich der Positionswert der 500RE  von 66 EUR um 12 EUR auf 108 EUR
And I set field "mge" to "-2" in row 1
And I set field "preis" to "6" in row 1
Then the table has 4 rows
And I save the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.08." until enddate "31.08." with Command Revalue

# Teilruecklieferschein anlegen
Given I set the fake date to "01.09.1995"
Given I open an editor "rls-500" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein5"
And I set field "num4" to "500RLS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "-9" in row 1
And I save the current editor
And I close the current editor

# kfm. Gutschrift
Given I set the fake date to "04.09.1995"
Given I open an editor "kgs-500" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "rls-500"
And I set field "num4" to "500-KGS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 1 rows
Then table has values
  | art       | mge  | preis        | remge |
  | E200      | -9  |  10.80        | -9    |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.09." until enddate "30.09." with Command Revalue

# Storno Teil-WGS
Given I set the fake date to "06.09.1995"
# Storno der TWG nicht erlaubt: Es existiert eine gebuchte kaufmaennische Gutschrift.
Then opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "500-wgs" throws the exception "3335"

