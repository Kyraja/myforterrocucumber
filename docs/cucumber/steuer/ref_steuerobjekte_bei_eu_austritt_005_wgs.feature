# *****************************************************************************
#  Name             : ref_steuerobjekte_bei_eu_austritt_005_wgs.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Test des Verhalten der steuerlichen Objekten in EK/VK bei EU-Austritt
#                     Hier werden Wertgutschriften (WGS) zu Ende gefuehrt.
#
#  https://extranet.abas.de/sub_de/abas-business-suite/erp/funktionsbereiche/Technischer_Leitfaden_Brexit.pdf
# *****************************************************************************

@persistent
Feature: Wertgutschrift in Einkauf/Verkauf
Background: Test von WGS
Given I set the fake date to "07.07.2002"

@FALL-24EK-NACH
@FALL-24VK-NACH
Scenario: 24 NACH: BE->LS->TRE1->   *EU-Austritt* ->TRE2->WGS1         Lief. aus GB
#         24 NACH: AU->TRE1->TLS1-> *EU-Austritt* ->TRE2->WGS1->TLS2   Kunde aus GB

# Teil-Rechnung2 anlegen und verbuchen
Given I open an editor "rechnung-24ek" from table "(Purchasing):(Invoice)" with command "COPY" for record "24ek-LS"
And I set field "num4" to "24ek-RE2"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-24EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "re-24ek-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+24ek-RE2"
Then field "wertgutschrift" has value "nein" in row 0
Then field "vrgstrgl" has value "EKAUSLSTFR" in row 0
Then field "ustart" has value "steuerfrei" in row 0
Then field "stlaart" has value "Ausland" in row 0
Then the table has 2 rows
Then field "intrarel" has value "nein" in row 1
Then field "strgl" has value "EKAUFREI" in row 1
Then field "steuer" has value "0" in row 1
Then field "konto" has value "1afall24" in row 1
And I close the current editor

# Teil-Wertgutschrift1: Kommando Rechnung auf eine Rechnung
Given I open an editor "wgs-24ek" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+24ek-RE2"
And I set fields
   | nummer | 24ek-wgs|
   | such   | wgs24   |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    | ja      |
Then field "wertgutschrift" has value "ja" in row 0
Then field "vrgstrgl" has value "EKAUSLSTFR" in row 0
Then field "ustart" has value "steuerfrei" in row 0
Then field "stlaart" has value "Ausland" in row 0
Then the table has 2 rows
Then field "intrarel" has value "nein" in row 1
Then field "ofmge" has value "-60" in row 1
And I set field "mge" to "-10" in row 1
Then field "ofmge" has value "-50" in row 1
Then field "artikel" has value "EK1-FALL24" in row 1
Then field "intrarel" has value "nein" in row 1
Then field "strgl" has value "EKAUFREI" in row 1
Then field "steuer" has value "0" in row 1
And I save the current editor
And I close the current editor

######################

# Teil-Rechnung2 anlegen und verbuchen
Given I open an editor "trechnung2-024vk" from table "(Sales):(Invoice)" with command "COPY" for record "24vk-AU"
And I set field "num3" to "24vk-RE2"
Then field "fakt" is not modifiable
Then field "fakt" has value "nein" in row 0
And I set field "bem" to "FALL-24VK"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "preis" to "210" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "re-24vk-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+24vk-RE2"
Then field "wertgutschrift" has value "nein" in row 0
Then the table has 2 rows
Then field "intrarel" has value "nein" in row 1
And I close the current editor

# Teil-Wertgutschrift1: Kommando Rechnung auf eine Rechnung
Given I open an editor "wgs-24vk" from table "(Sales):(Invoice)" with command "INVOICE" for record "+24vk-RE2"
And I set fields
   | nummer | 24vk-wgs|
   | such   | wgs24   |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    |  ja     |
Then field "wertgutschrift" has value "ja" in row 0
Then the table has 2 rows
Then field "intrarel" has value "nein" in row 1
Then field "ofmge" has value "-60" in row 1
And I set field "mge" to "-15" in row 1
Then field "ofmge" has value "-45" in row 1
Then field "artikel" has value "EK1-FALL24" in row 1
Then field "intrarel" has value "nein" in row 1
And I save the current editor
And I close the current editor


# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################


@FALL-25EK-NACH
@FALL-25VK-NACH
Scenario: 25 NACH: BE LS  RE   *EU-Austritt* WGS  TRLS GS       Lief. aus GB
#         25 NACH: LS RLS TRE1 *EU-Austritt* WGS1 TRE2 GS       Lief. aus GB

Given I set the fake date to "7.07.2002"

######################
Given I open an editor "re-25ek-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+25ek-RE1"
Then field "wertgutschrift" has value "nein" in row 0
Then field "budat" has value "27.01.02" in row 0
Then field "vrgstrgl" has value "EKEUSOFORT" in row 0
Then field "ustart" has value "Steuersofortabzug" in row 0
Then field "stlaart" has value "EU-Staat" in row 0
Then field "ophist" has value "OP25EK-RE1" in row 0
Then the table has 5 rows
Then field "intrarel" has value "nein" in row 1
Then field "strgl" has value "EKEUWARE" in row 1
Then field "steuer" has value "1" in row 1
Then field "konto" has value "1efall25" in row 1
Then field "pwert" has value "100.00" in row 1
And I close the current editor

# Teil-Wertgutschrift1: Kommando Rechnung auf eine Rechnung
Given I open an editor "wgs-25ek" from table "(Purchasing):(Invoice)" with command "INVOICE" for record "+25ek-RE1"
Then field "budat" has value "07.07.02"
Then field "vrgstrgl" has value "EKAUSLSTFR"
Then field "ophist" has value ""
# Kein OP-Vorschlag, Vorgangssteuerregel des OPs OP25EK-RE1: EKEUSOFORT

And I set fields
   | nummer | 25ek-wgs|
   | such   | wgs25   |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    | ja      |
Then field "wertgutschrift" has value "ja" in row 0
Then field "budat" has value "07.07.02" in row 0
Then field "vrgstrgl" has value "EKAUSLSTFR" in row 0
Then field "ustart" has value "steuerfrei" in row 0
Then field "stlaart" has value "Ausland" in row 0
Then the table has 1 rows
Then field "intrarel" has value "nein" in row 1
Then field "ofmge" has value "-25" in row 1
And I set field "mge" to "-10" in row 1
Then field "ofmge" has value "-15" in row 1
Then field "artikel" has value "EK1-FALL25" in row 1
Then field "intrarel" has value "nein" in row 1
Then field "strgl" has value "EKAUFREI" in row 1
Then field "steuer" has value "0" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "1-25ek-wgs-view" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+25ek-wgs"
Then field "budat" has value "07.07.02"
Then field "vrgstrgl" has value "EKAUSLSTFR"
Then field "ophist" has value "OP25EK-WGS"
And I close the current editor

# Ruecklieferung von 10 Stk.
Given I open an editor "ruecklief-25ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+25ek-LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "25ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "EK1-FALL25" in row 1
And I set field "mge" to "-10" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS zu Ruecklieferschein
Given I open an editor "KGS-25ek" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-25ek"
Then field "budat" has value "07.07.02"
Then field "vrgstrgl" has value "EKAUSLSTFR"
Then field "ophist" has value ""
# Kein OP-Vorschlag.  OP-Vorschlag nur beim Storno einer Rechnung und beim Erzeugen einer wertgutschrift.
And I set field "num4" to "25ek-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then field "wertgutschrift" has value "nein" in row 0
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art        | mge | preis | ofmge |
    | EK1-FALL25 | -10 | 2.40  | 0     |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

######################
#         25 NACH: LS RLS TRE1 *EU-Austritt* WGS1 TRE2 GS       Lief. aus GB

Given I open an editor "re-25vk-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+25vk-RE1"
Then field "wertgutschrift" has value "nein" in row 0
Then field "budat" has value "27.01.02" in row 0
Then field "vrgstrgl" has value "VKEUSTFR" in row 0
Then field "ustart" has value "steuerrelevant" in row 0
Then field "stlaart" has value "EU-Staat" in row 0
Then field "ophist" has value "OP25VK-RE1" in row 0
Then the table has 2 rows
Then field "intrarel" has value "nein" in row 1
Then field "strgl" has value "VKEUWARE" in row 1
Then field "steuer" has value "0" in row 1
Then field "konto" has value "43150" in row 1
Then field "pwert" has value "150.00" in row 1
And I close the current editor

# Teil-Wertgutschrift1: Kommando Rechnung auf eine Rechnung
Given I open an editor "wgs-25vk" from table "(Sales):(Invoice)" with command "INVOICE" for record "+25vk-RE1"
Then field "budat" has value "07.07.02"
Then field "vrgstrgl" has value "VKAUSLSTFR"
Then field "ophist" has value ""
# Kein OP-Vorschlag, Vorgangssteuerregel des OPs OP25VK-RE1: VKEUSTFR
And I set fields
   | nummer | 25vk-wgs|
   | such   | wgs25   |
   | tterm  | .       |
   | budat  | .       |
   | vom    | .       |
   | ueb    | ja      |
Then field "wertgutschrift" has value "ja" in row 0
Then field "budat" has value "07.07.02"
Then field "vrgstrgl" has value "VKAUSLSTFR" in row 0
Then field "ustart" has value "steuerfrei" in row 0
Then field "stlaart" has value "Ausland" in row 0
Then the table has 1 rows
Then field "intrarel" has value "nein" in row 1
Then field "ofmge" has value "-30" in row 1
And I set field "mge" to "-10" in row 1
Then field "ofmge" has value "-20" in row 1
Then field "artikel" has value "EK1-FALL25" in row 1
Then field "konto" has value "41500" in row 1
Then field "intrarel" has value "nein" in row 1
Then field "strgl" has value "VKAUSFREI" in row 1
Then field "steuer" has value "0" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

Given I open an editor "1-25vk-wgs-view" from table "(Sales):(Invoice)" with command "VIEW" for record "+25vk-wgs"
Then field "budat" has value "07.07.02"
Then field "vrgstrgl" has value "VKAUSLSTFR"
Then field "ophist" has value "OP25VK-WGS"
And I close the current editor

# Teil-Rechnung2 anlegen und verbuchen
Given I open an editor "rechnung2-25vk" from table "(Sales):(Invoice)" with command "COPY" for record "25vk-LS"
And I set field "num3" to "25vk-RE2"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-25VK"
And I set field "ueb" to "ja"
And I press button "offueb" in row 1
And I set field "preis" to "5.10" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Kaufm. GS zu Ruecklieferschein
Given I open an editor "KGS-25vk" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "25vk-RLS"
And I set field "num3" to "25vk-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then field "wertgutschrift" has value "nein" in row 0
Then the table has 1 rows
And I press button "offueb" in row 1
Then table has values
    | art        | mge | preis | ofmge |
    | EK1-FALL25 | -20 | 5.10  | 0     |
And I set field "intrarel" to "nein" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
####################################################################################################################################


@FALL-26EK-NACH
Scenario: 26 NACH: LS->TRE1->TWGS1-> *EU-Austritt* ->TRE2->RLS->GS    Lief aus Nordirland

Given I set the fake date to "08.08.2002"

######################
# Teil-Rechnung2 anlegen
Given I open an editor "rechnung-26ek" from table "(Purchasing):(Invoice)" with command "COPY" for record "26ek-LS"
And I set field "num4" to "26ek-RE2"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-26EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "preis" to "5.20" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Ruecklieferung von 50 Stk.
Given I open an editor "ruecklief-26ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+26ek-LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "26ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"

Then field "budat" has value "08.08.02"
Then field "vrgstrgl" has value "EKEUSOFORT"
Then field "ustart" has value "Steuersofortabzug"
Then field "stlaart" has value "EU-Staat"
Then field "rechnlaart" has value "EU-Staat"
Then field "laarta" has value "EU-Staat"
Then field "rechnregion" has value "NORDIRL"

Then field "artikel" has value "EK1-FALL26" in row 1
And I set field "mge" to "-50" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS zu Ruecklieferschein
Given I open an editor "KGS-26ek" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "26ek-RLS"
And I set field "num4" to "26ek-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then field "vorganga" has value "Kaufmännische Gutschrift"
#
Then field "budat" has value "08.08.02"
Then field "wertgutschrift" has value "nein"
# TODO: hier geht die VRGSTRGL aus RLS und Kaufm. GS auseinander!!!
Then field "vrgstrgl" has value "EKAUSLSTFR"
Then field "ustart" has value "steuerfrei"
Then field "stlaart" has value "Ausland"
Then field "rechnlaart" has value "Ausland"
Then field "laarta" has value "Ausland"
Then field "rechnland" has value "GROSSBRITANNIEN"
Then field "rechnregion" has value "NORDIRL"
#
Then the table has 2 rows
Then table has values
    | art        | mge | preis | ofmge | strgl    | steuer | konto    |
    | EK1-FALL26 | -30 | 3.33  | 0     | EKAUFREI | 0      | 36fall26 |
    | EK1-FALL26 | -20 | 5.20  | 0     | EKAUFREI | 0      | 36fall26 |
And I set field "intrarel" to "nein" in row 1
And I set field "intrarel" to "nein" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################


@FALL-27EK-NACH
Scenario: 27 NACH: LS->TRE1->WGS1(anlegen)-> *EU-Austritt* ->WGS1(verbuchen)->TRE2->RLS->GS    Lief aus Nordirland

Given I set the fake date to "08.08.2002"

######################
# WGS verbuchen
Given I open an editor "wgs-27ek" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "27ek-wgs"
Then field "budat" has value "27.01.02"
Then field "vrgstrgl" has value "EKEUSOFORT"
Then field "ophist" has value "OP27EK-RE1"
And I set field "vom" to "."
And I set field "budat" to "."
And I set field "ueb" to "ja"
Then field "budat" has value "08.08.02"
Then field "vrgstrgl" has value "EKAUSLSTFR"
And I respond with answer "Ja" to the dialog with id "4841"
And saving the current editor throws the exception "10109"
# Meldung "Vorgangssteuerregel des Offenen Postens passt nicht zu der Rechnung."
# ophist leeren, beim Speichern wird dann neuer OP erzeugt
And I set field "ophist" to ""
And I save the current editor
And I close the current editor

# Teil-Rechnung2 anlegen und verbucht
Given I open an editor "rechnung2-27ek" from table "(Purchasing):(Invoice)" with command "COPY" for record "27ek-LS"
And I set field "num4" to "27ek-RE2"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-27EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "preis" to "5.60" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Ruecklieferung von 20 Stk.
Given I open an editor "ruecklief-27ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+27ek-LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "27ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "EK1-FALL27" in row 1
And I set field "mge" to "-20" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS zu Ruecklieferschein
Given I open an editor "KGS-27ek" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "27ek-RLS"
And I set field "num4" to "27ek-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "wertgutschrift" has value "nein" in row 0
Then field "vrgstrgl" has value "EKAUSLSTFR" in row 0
Then field "ustart" has value "steuerfrei" in row 0
Then the table has 1 rows
Then table has values
    | art        | mge | preis | ofmge | strgl    | steuer | konto    |
    | EK1-FALL27 | -20 | 5.60  | 0     | EKAUFREI | 0      | 36fall27 |
And I set field "intrarel" to "nein" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################


@FALL-28EK-NACH
Scenario: 28 NACH: LS->TRE1->WGS1(anlegen uber Beleg)-> *EU-Austritt* ->WGS1(verbuchen)->TRE2->RLS->GS    Lief aus Nordirland

Given I set the fake date to "08.08.2002"

######################
# WGS verbuchen
Given I open an editor "wgs-28ek" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "28ek-wgs"
# Kontrolle: vorher
Then field "budat" has value "27.01.02"
Then field "wertgutschrift" has value "ja"
Then field "vrgstrgl" has value "EKEUSOFORT"
Then field "ustart" has value "Steuersofortabzug"
Then field "stlaart" has value "EU-Staat"
Then field "rechnlaart" has value "EU-Staat"
Then field "laarta" has value "EU-Staat"
Then field "rechnregion" has value "NORDIRL"
Then field "ophist" has value "OP28EK-RE1"
#
And I set field "vom" to "."
And I set field "budat" to "."
#
# Kontrolle: nachher
# "budat" geaendert -> andere VRGSTRGL
Then field "budat" has value "08.08.02"
Then field "wertgutschrift" has value "ja"
Then field "vrgstrgl" has value "EKAUSLSTFR"
Then field "ustart" has value "steuerfrei"
Then field "stlaart" has value "Ausland"
Then field "rechnlaart" has value "Ausland"
Then field "laarta" has value "Ausland"
Then field "rechnregion" has value "NORDIRL"
Then field "ophist" has value "OP28EK-RE1"
#
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And saving the current editor throws the exception "10109"
# Meldung "Vorgangssteuerregel des Offenen Postens passt nicht zu der Rechnung."
# ophist leeren, beim Speichern wird dann neuer OP erzeugt.
And I set field "ophist" to "" in row 0
And I save the current editor
And I close the current editor

# Teil-Rechnung2 anlegen und verbucht
Given I open an editor "rechnung2-28ek" from table "(Purchasing):(Invoice)" with command "COPY" for record "28ek-LS"
And I set field "num4" to "28ek-RE2"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-28EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I set field "preis" to "5.60" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Ruecklieferung von 20 Stk.
Given I open an editor "ruecklief-28ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+28ek-LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "28ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "vrgstrgl" has value "EKEUSOFORT" in row 0
Then field "artikel" has value "EK1-FALL28" in row 1
And I set field "mge" to "-20" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS zu Ruecklieferschein
Given I open an editor "KGS-28ek" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "28ek-RLS"
And I set field "num4" to "28ek-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "wertgutschrift" has value "nein" in row 0
Then field "vrgstrgl" has value "EKAUSLSTFR" in row 0
Then field "ustart" has value "steuerfrei" in row 0
Then the table has 1 rows
Then table has values
    | art        | mge | preis | ofmge | strgl    | steuer | konto    |
    | EK1-FALL28 | -20 | 5.60  | 0     | EKAUFREI | 0      | 36fall28 |
And I set field "intrarel" to "nein" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

