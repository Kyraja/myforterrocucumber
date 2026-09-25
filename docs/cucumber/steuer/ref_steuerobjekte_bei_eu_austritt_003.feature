# *****************************************************************************
#  Name             : ref_steuerobjekte_bei_eu_austritt_003.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Test des Verhalten der steuerlichen Objekten in EK/VK bei EU-Austritt
#
#
#
#  https://extranet.abas.de/sub_de/abas-business-suite/erp/funktionsbereiche/Technischer_Leitfaden_Brexit.pdf
# *****************************************************************************

@persistent
Feature: VRGSTRGL in Verkauf
Background: Test von 
Given I set the fake date to "07.07.2002"


@FALL-1EK-NACH
@FALL-1VK-NACH
Scenario: NACH: 1	AU/BE 	RE 	LS 	EU-Austritt	RLS 	GS

##############################
# Ruecklieferung von 200 Stk. -> alles zurueck
Given I open an editor "ruecklief-1ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+1ek-LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "1ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL1" in row 1
And I set field "mge" to "-200" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS 1 zu Ruecklieferschein 1
Given I open an editor "KGS-01ek" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-1ek"
And I set field "num4" to "1ek-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "EKEUSOFORT"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 	| mge 	| preis 	| ofmge | 
    | VK1-FALL1	| -200 	| 200.00 	| 0	| 
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

##############################
# Ruecklieferung von 200 Stk. -> alles zurueck
Given I open an editor "ruecklief-1vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record "+1vk-LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num3" to "1vk-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL1" in row 1
And I set field "mge" to "-200" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS 1 zu Ruecklieferschein 1
Given I open an editor "KGS-01vk" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-1vk"
And I set field "num3" to "1vk-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "VKEUSTFR"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 	| mge 	| preis 	| ofmge | 
    | VK1-FALL1	| -200 	| 200.00 	| 0	| 
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-2EK-NACH
@FALL-2VK-NACH
Scenario: 2 NACH:	AU/BE 	LS 	TRE1 	  EU-Austritt	TRE2 	RLS 	GS

Given I set the fake date to "08.07.2002"

##############################
# Teil-Rechnung2 anlegen
Given I open an editor "rechnung-02ek" from table "(Purchasing):(Invoice)" with command "COPY" for record "2ek-LS"
And I set field "num4" to "2ek-RE2"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-2EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "vrgstrgl" to "EKEUSOFORT"
And I set field "mge" to "100" in row 1
And I set field "preis" to "101" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung von 250 Stk. -> alles zurueck
Given I open an editor "ruecklief-2ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+2ek-LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "2ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL2" in row 1
And I set field "mge" to "-250" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS-02ek" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-2ek"
And I set field "num4" to "2ek-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "EKEUSOFORT"
Then the table has 2 rows
And I set field "intrarel" to "nein" in row 1
And I set field "intrarel" to "nein" in row 2
Then table has values
    | art 	| mge 	| preis 	| ofmge |
    | VK1-FALL2	| -150 	| 100.00 	| 0	|
    | VK1-FALL2	| -100 	| 101.00 	| 0	|
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

##############################
# Teil-Rechnung2 anlegen
Given I open an editor "rechnung-02vk" from table "(Sales):(Invoice)" with command "COPY" for record "2vk-LS"
And I set field "num3" to "2vk-RE2"
Then field "fakt" has value "nein"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-2VK"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "100" in row 1
And I set field "preis" to "101" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung von 250 Stk. -> alles zurueck
Given I open an editor "ruecklief-2vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record "+2vk-LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num3" to "2vk-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL2" in row 1
And I set field "mge" to "-250" in row 1
And I save the current editor
And I close the current editor

# ACHTUNG!!!
# Wegen unterschiedlichen VRSTRGL in den Rechnungen muss man hier 2 KG erstellen.

# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS-02vka" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-2vk"
And I set field "num3" to "2vk-GS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "VKEUSTFR"
Then the table has 2 rows
And I set field "intrarel" to "nein" in row 1
And I set field "intrarel" to "nein" in row 2
Then table has values
    | art 	| mge 	| preis 	| ofmge |
    | VK1-FALL2	| -150 	| 100.00 	| 0	|
    | VK1-FALL2	| -100 	| 101.00 	| 0	|
And I set field "mge" to "0" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Kaufm. GS 2 zum Ruecklieferschein
Given I open an editor "KGS-02vkb" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-2vk"
And I set field "num3" to "2vk-GS2"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 	| mge 	| preis 	| ofmge |
    | VK1-FALL2	| -100 	| 101.00 	| 0	|
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-3EK-NACH
@FALL-3VK-NACH
Scenario: 3 NACH:	AU/BE 	LS 	 EU-Austritt	RE 	RLS 	GS 

Given I set the fake date to "09.07.2002"

##############################
# Rechnung anlegen
Given I open an editor "rechnung-03ek" from table "(Purchasing):(Invoice)" with command "COPY" for record "3ek-LS"
And I set field "num4" to "3ek-RE"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-3EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung von 10 Stk. -> alles zurueck
Given I open an editor "ruecklief-3ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+3ek-LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "3ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL3" in row 1
And I set field "mge" to "-10" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS-03ek" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-3ek"
And I set field "num4" to "3ek-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 	| mge 	| preis 	| ofmge |
    | VK1-FALL3	| -10 	| 50.00 	| 0	|
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

##############################
# Rechnung anlegen
Given I open an editor "rechnung-03vk" from table "(Sales):(Invoice)" with command "COPY" for record "3vk-LS"
And I set field "num3" to "3vk-RE"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-3VK"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung von 10 Stk. -> alles zurueck
Given I open an editor "ruecklief-3vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record "+3vk-LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num3" to "3vk-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL3" in row 1
And I set field "mge" to "-10" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS-03vk" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-3vk"
And I set field "num3" to "3vk-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 	| mge 	| preis 	| ofmge | 
    | VK1-FALL3	| -10 	| 50.00 	| 0	| 
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-4EK-NACH
@FALL-4VK-NACH
Scenario: 4 NACH:	AU/BE 	TRE1 	LS 	EU-Austritt	TRE2 	RLS 	GS 

Given I set the fake date to "10.07.2002"

##############################
# Teil-Rechnung2 anlegen
Given I open an editor "rechnung-04vkb" from table "(Purchasing):(Invoice)" with command "COPY" for record "4ek-BE"
And I set field "num4" to "4ek-RE2"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-4EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "35" in row 1
And I set field "preis" to "2.05" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung von 55 Stk. -> alles zurueck
Given I open an editor "ruecklief-4ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+4ek-LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "4ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL4" in row 1
And I set field "mge" to "-55" in row 1
And I save the current editor
And I close the current editor

# ACHTUNG!!!
# Wegen unterschiedlichen VRSTRGL in den Rechnungen muss man hier 2 KGS erstellen.

# Kaufm. GS 1 zum Ruecklieferschein -> EU
Given I open an editor "KGS1-04ek" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-4ek"
And I set field "num4" to "4ek-GS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "EKEUSOFORT"
Then the table has 2 rows
And I set field "intrarel" to "nein" in row 1
And I set field "intrarel" to "nein" in row 2
Then table has values
    | art 	| mge 	| preis | ofmge |
    | VK1-FALL4	| -20 	| 2.00 	| 0	|
    | VK1-FALL4	| -35 	| 2.05 	| 0	|
And I set field "mge" to "0" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Kaufm. GS 2 zum Ruecklieferschein -> Ausland
Given I open an editor "KGS2-04ek" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-4ek"
And I set field "num4" to "4ek-GS2"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 	| mge 	| preis | ofmge |
    | VK1-FALL4	| -35 	| 2.05 	| 0	|
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

##############################
# Teil-Rechnung2 anlegen
Given I open an editor "rechnung-04vkb" from table "(Sales):(Invoice)" with command "COPY" for record "4vk-AU"
And I set field "num3" to "4vk-RE2"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-4VK"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "35" in row 1
And I set field "preis" to "2" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung von 55 Stk. -> alles zurueck
Given I open an editor "ruecklief-4vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record "+4vk-LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num3" to "4vk-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL4" in row 1
And I set field "mge" to "-55" in row 1
And I save the current editor
And I close the current editor

# ACHTUNG!!!
# Wegen unterschiedlichen VRSTRGL in den Rechnungen muss man hier 2 KGS erstellen.

# Kaufm. GS 1 zum Ruecklieferschein -> EU
Given I open an editor "KGS1-04vk" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-4vk"
And I set field "num3" to "4vk-GS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "VKEUSTFR"
Then the table has 2 rows
And I set field "intrarel" to "nein" in row 1
And I set field "intrarel" to "nein" in row 2
Then table has values
    | art 	| mge 	| preis | ofmge |
    | VK1-FALL4	| -20 	| 2.00 	| 0	|
    | VK1-FALL4	| -35 	| 2.00 	| 0	|
And I set field "mge" to "0" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Kaufm. GS 1 zum Ruecklieferschein -> Ausland
Given I open an editor "KGS2-04vk" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-4vk"
And I set field "num3" to "4vk-GS2"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 	| mge 	| preis | ofmge |
    | VK1-FALL4	| -35 	| 2.00 	| 0	|
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-5EK-NACH
@FALL-5VK-NACH
Scenario: 5 NACH:	AU/BE 	TRE1(50St) 	LS(100St) 	 EU-Austritt	TRE2(50St) 	TRLS(25St) 	GS 

Given I set the fake date to "11.07.2002"

##############################
# Teil-Rechnung2 anlegen
Given I open an editor "rechnung-05vkb" from table "(Purchasing):(Invoice)" with command "COPY" for record "5ek-BE"
And I set field "num4" to "5ek-RE2"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-5EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "50" in row 1
And I set field "preis" to "3.5" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung von 25 Stk. -> Teilruecklieferung
Given I open an editor "ruecklief-5ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+5ek-LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "5ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL5" in row 1
And I set field "mge" to "-25" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS-05ek" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-5ek"
And I set field "num4" to "5ek-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "EKEUSOFORT"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 	| mge 	| preis | ofmge | 
    | VK1-FALL5	| -25 	| 3.00 	| 0	| 
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

##############################
# Teil-Rechnung2 anlegen
Given I open an editor "rechnung-05vkb" from table "(Sales):(Invoice)" with command "COPY" for record "5vk-AU"
And I set field "num3" to "5vk-RE2"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-5VK"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "50" in row 1
And I set field "preis" to "3.5" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung von 25 Stk. -> Teilruecklieferung
Given I open an editor "ruecklief-5vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record "+5vk-LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num3" to "5vk-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL5" in row 1
And I set field "mge" to "-25" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS-05vk" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-5vk"
And I set field "num3" to "5vk-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "VKEUSTFR"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 	| mge 	| preis | ofmge |
    | VK1-FALL5	| -25 	| 3.50 	| 0	|
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-6EK-NACH
@FALL-6VK-NACH
Scenario: 6 NACH:	AU/BE 	TRE1(50St) 	LS(100St) 	  EU-Austritt	TRE2(50St) 	TRLS(75St) 	GS

Given I set the fake date to "12.07.2002"

##############################
# Teil-Rechnung2 anlegen
Given I open an editor "rechnung-06vkb" from table "(Purchasing):(Invoice)" with command "COPY" for record "6ek-BE"
And I set field "num4" to "6ek-RE2"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-6EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "50" in row 1
And I set field "preis" to "3.5" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung von 75 Stk. -> Teilruecklieferung
Given I open an editor "ruecklief-6ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+6ek-LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "6ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL6" in row 1
And I set field "mge" to "-75" in row 1
And I save the current editor
And I close the current editor


# ACHTUNG!!!
# Wegen unterschiedlichen VRSTRGL in den Rechnungen muss man hier 2 KG erstellen.

# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS1-06ek" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-6ek"
And I set field "num4" to "6ek-GS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "EKEUSOFORT"
Then the table has 2 rows
And I set field "intrarel" to "nein" in row 1
And I set field "intrarel" to "nein" in row 2
Then table has values
    | art 	| mge 	| preis | ofmge |
    | VK1-FALL6	| -50 	| 3.00 	| 0	|
    | VK1-FALL6	| -25 	| 3.50 	| 0	|
And I set field "mge" to "0" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Kaufm. GS 2 zum Ruecklieferschein
Given I open an editor "KGS2-06ek" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-6ek"
And I set field "num4" to "6ek-GS2"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 	| mge 	| preis | ofmge |
    | VK1-FALL6	| -25 	| 3.50 	| 0	|
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

##############################
# Teil-Rechnung2 anlegen
Given I open an editor "rechnung-06vkb" from table "(Sales):(Invoice)" with command "COPY" for record "6vk-AU"
And I set field "num3" to "6vk-RE2"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-6VK"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "50" in row 1
And I set field "preis" to "3.5" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# Ruecklieferung von 75 Stk. -> Teilruecklieferung
Given I open an editor "ruecklief-6vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record "+6vk-LS"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num3" to "6vk-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL6" in row 1
And I set field "mge" to "-75" in row 1
And I save the current editor
And I close the current editor

# ACHTUNG!!!
# Wegen unterschiedlichen VRSTRGL in den Rechnungen muss man hier 2 KGS erstellen.

# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS1-06vk" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-6vk"
And I set field "num3" to "6vk-GS1"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "VKEUSTFR"
Then the table has 2 rows
And I set field "intrarel" to "nein" in row 1
And I set field "intrarel" to "nein" in row 2
Then table has values
    | art 	| mge 	| preis | ofmge |
    | VK1-FALL6	| -25 	| 3.00 	| 0	|
    | VK1-FALL6	| -50 	| 3.50 	| 0	|
And I set field "mge" to "0" in row 2
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Kaufm. GS 2 zum Ruecklieferschein
Given I open an editor "KGS2-06vk" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-6vk"
And I set field "num3" to "6vk-GS2"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 	| mge 	| preis | ofmge |
    | VK1-FALL6	| -50 	| 3.50 	| 0	|
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-7EK-NACH
@FALL-7VK-NACH
Scenario: 7 NACH:	AU/BE 	LS1, LS2 	RE 	 EU-Austritt	RLS1 	GS 

Given I set the fake date to "13.07.2002"

##############################
# Ruecklieferung von 111 Stk. -> alles von LS1
Given I open an editor "ruecklief-7ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+7ek-LS1"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "7ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL7" in row 1
And I set field "mge" to "-111" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS-07ek" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-7ek"
And I set field "num4" to "7ek-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "EKEUSOFORT"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 	| mge 	| preis | ofmge | 
    | VK1-FALL7	| -111	| 3.00 	| 0	| 
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

##############################
# Ruecklieferung von 111 Stk. -> alles von LS1
Given I open an editor "ruecklief-7vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record "+7vk-LS1"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num3" to "7vk-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL7" in row 1
And I set field "mge" to "-111" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS-07vk" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-7vk"
And I set field "num3" to "7vk-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "VKEUSTFR"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 	| mge 	| preis | ofmge | 
    | VK1-FALL7	| -111	| 3.00 	| 0	| 
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################

@FALL-8EK-NACH
@FALL-8VK-NACH
Scenario: 8 NACH:	AU/BE 	LS1, LS2 	RE1, RE2 	EU-Austritt	RLS1 	GS 

Given I set the fake date to "14.07.2002"

##############################
# Ruecklieferung von 44 Stk. -> alles von LS1
Given I open an editor "ruecklief-8ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+8ek-LS1"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "8ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL8" in row 1
And I set field "mge" to "-44" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS-08ek" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-8ek"
And I set field "num4" to "8ek-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "EKEUSOFORT"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 	| mge 	| preis | ofmge | 
    | VK1-FALL8	| -44	| 1.00 	| 0	| 
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

##############################
# Ruecklieferung von 44 Stk. -> alles von LS1
Given I open an editor "ruecklief-8vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record "+8vk-LS1"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num3" to "8vk-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL8" in row 1
And I set field "mge" to "-44" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS-08vk" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-8vk"
And I set field "num3" to "8vk-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "VKEUSTFR"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 	| mge 	| preis | ofmge | 
    | VK1-FALL8	| -44	| 1.00 	| 0	| 
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################

@FALL-9EK-NACH
@FALL-9VK-NACH
Scenario: 9 NACH:	AU/BE 	LS1, LS2 	 EU-Austritt	RE 	RLS1  	 GS 

Given I set the fake date to "15.01.2002"

##############################
# Sammel-Rechnung anlegen
Given I open an editor "rechnung-09ek" from table "(Purchasing):(Invoice)" with command "COPY" for record "+9ek-BE"
And I set field "num4" to "9ek-RE1"
And I set field "fakt" to "nein"
And I set field "bem" to "FALL-9EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "beleg" to "9ek-LS1"
And I set field "beleg" to "9ek-LS2"
And I set field "intrarel" to "nein" in row 1
And I set field "intrarel" to "nein" in row 3
And I set field "intrarel" to "nein" in row 5
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Ruecklieferung von 44 Stk. -> alles von LS1
Given I open an editor "ruecklief-9ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "+9ek-LS1"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "9ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL9" in row 1
And I set field "mge" to "-44" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS-09ek" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-9ek"
And I set field "num4" to "9ek-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 	| mge 	| preis | ofmge | 
    | VK1-FALL9	| -44	| 1.00 	| 0	| 
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

##############################
# Sammel-Rechnung anlegen
Given I open an editor "rechnung-09vk" from table "(Sales):(Invoice)" with command "COPY" for record "+9vk-AU"
And I set field "num3" to "9vk-RE1"
And I set field "fakt" to "nein"
And I set field "bem" to "FALL-9VK"
And I set field "ueb" to "ja"
And I set field "beleg" to "9vk-LS1"
And I set field "beleg" to "9vk-LS2"
And I set field "intrarel" to "nein" in row 1
And I set field "intrarel" to "nein" in row 3
And I set field "intrarel" to "nein" in row 5
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Ruecklieferung von 44 Stk. -> alles von LS1
Given I open an editor "ruecklief-9vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record "+9vk-LS1"
Then field "lsart" has value "Rücklieferschein"
And I set field "num3" to "9vk-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL9" in row 1
And I set field "mge" to "-44" in row 1
And I save the current editor
And I close the current editor

# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS-09vk" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "ruecklief-9vk"
And I set field "num3" to "9vk-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 	| mge 	| preis | ofmge | 
    | VK1-FALL9	| -44	| 1.00 	| 0	| 
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################

@FALL-10EK-NACH
@FALL-10VK-NACH
Scenario: 10 NACH:	AU/BE 	 LS 	 RE 	RLS 	EU-Austritt	GS

Given I set the fake date to "16.07.2002"

##############################
# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS-10ek" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "10ek-RLS"
And I set field "num4" to "10ek-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "EKEUSOFORT"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 		| mge 	| preis | ofmge | 
    | VK1-FALL10	| -99	| 1.00 	| 0	| 
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

##############################
# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS-10vk" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "10vk-RLS"
And I set field "num3" to "10vk-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "VKEUSTFR"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 		| mge 	| preis | ofmge | 
    | VK1-FALL10	| -99	| 1.00 	| 0	| 
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################

@FALL-11EK-NACH
@FALL-11VK-NACH
Scenario: 11 NACH:	AU/BE (100St) 	 LS (100St) 	 TRE (30St) 	TRLS(45St) 	EU-Austritt	TRE2 (25St)

Given I set the fake date to "17.07.2002"

##############################
# Teil-Rechnung2 anlegen
Given I open an editor "rechnung-11ekb" from table "(Purchasing):(Invoice)" with command "COPY" for record "11ek-LS"
And I set field "num4" to "11ek-RE2"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-11EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "25" in row 1
And I set field "preis" to "3.5" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

##############################
# Teil-Rechnung2 anlegen
Given I open an editor "rechnung-11vkb" from table "(Sales):(Invoice)" with command "COPY" for record "11vk-LS"
And I set field "num3" to "11vk-RE2"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-11VK"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "25" in row 1
And I set field "preis" to "3.5" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################

@FALL-12EK-NACH
@FALL-12VK-NACH
Scenario: 12 NACH:	 - 	 LS 	 RE 	RLS 	EU-Austritt	GS

Given I set the fake date to "18.07.2002"

##############################
# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS-12ek" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "12ek-RLS"
And I set field "num4" to "12ek-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "EKEUSOFORT"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 		| mge 	| preis | ofmge | 
    | VK1-FALL12	| -100	| 9.00 	| 0	| 
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

##############################
# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS-12vk" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "12vk-RLS"
And I set field "num3" to "12vk-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "VKEUSTFR"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 		| mge 	| preis | ofmge | 
    | VK1-FALL12	| -100	| 9.00 	| 0	| 
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################

@FALL-13EK-NACH
@FALL-13VK-NACH
Scenario: 13 NACH:	 - 	 LS (100St) 	 TRE1 (30St) 	EU-Austritt	TRLS (45St) 	 TRE2 (25St)

Given I set the fake date to "19.07.2002"

##############################
# Ruecklieferung von 45 Stk. -> von LS
Given I open an editor "ruecklief-13ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "13ek-LS"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "13ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL13" in row 1
And I set field "mge" to "-45" in row 1
And I save the current editor
And I close the current editor

# Teil-Rechnung2 anlegen
Given I open an editor "rechnung-13vkb" from table "(Purchasing):(Invoice)" with command "COPY" for record "13ek-LS"
And I set field "num4" to "13ek-RE2"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-13EK"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "25" in row 1
And I set field "preis" to "4" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

##############################
# Ruecklieferung von 45 Stk. -> von LS
Given I open an editor "ruecklief-13vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record "13vk-LS"
Then field "lsart" has value "Rücklieferschein"
And I set field "num3" to "13vk-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL13" in row 1
And I set field "mge" to "-45" in row 1
And I save the current editor
And I close the current editor

# Teil-Rechnung2 anlegen
Given I open an editor "rechnung-13vkb" from table "(Sales):(Invoice)" with command "COPY" for record "13vk-LS"
And I set field "num3" to "13vk-RE2"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-13VK"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "25" in row 1
And I set field "preis" to "4" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################

@FALL-14EK-NACH
@FALL-14VK-NACH
Scenario: 14 NACH:	 - 	 LS (100St) 	 RLS (20St) 	EU-Austritt	 RE (80St)

Given I set the fake date to "20.07.2002"

##############################
# Rechnung anlegen
Given I open an editor "rechnung-14vkb" from table "(Purchasing):(Invoice)" with command "COPY" for record "14ek-LS"
And I set field "num4" to "14ek-RE"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-14EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "80" in row 1
And I set field "preis" to "14" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

##############################
# Rechnung anlegen
Given I open an editor "rechnung-14vkb" from table "(Sales):(Invoice)" with command "COPY" for record "14vk-LS"
And I set field "num3" to "14vk-RE"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-14VK"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "80" in row 1
And I set field "preis" to "14" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################

@FALL-15EK-NACH
@FALL-15VK-NACH
Scenario: 15 NACH:	 - 	 LS (100St) 	 RLS (20St) 	TRE1 (30St) 	EU-Austritt	 TRE2 (50St) 

Given I set the fake date to "21.07.2002"

##############################
# Rechnung anlegen
Given I open an editor "rechnung-15vkb" from table "(Purchasing):(Invoice)" with command "COPY" for record "15ek-LS"
And I set field "num4" to "15ek-RE"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-15EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "50" in row 1
And I set field "preis" to "4.75" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

##############################
# Rechnung anlegen
Given I open an editor "rechnung-15vkb" from table "(Sales):(Invoice)" with command "COPY" for record "15vk-LS"
And I set field "num3" to "15vk-RE"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-15VK"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "50" in row 1
And I set field "preis" to "4.75" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################

@FALL-16EK-NACH
@FALL-16VK-NACH
Scenario:16	NACH: AU/BE	LS	RE	RLS	EU-Austritt	GS	Kude/Lief. aus Nordirland

Given I set the fake date to "22.07.2002"

##############################
# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS-16ek" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "16ek-RLS"
And I set field "num4" to "16ek-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "EKEUSOFORT"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 		| mge 	| preis | ofmge |
    | VK1-FALL16	| -22	| 3.00 	| 0	|
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

##############################
# Kaufm. GS 1 zum Ruecklieferschein
Given I open an editor "KGS-16vk" from table "(Sales):(PackingSlip)" with command "INVOICE" for record "16vk-RLS"
And I set field "num3" to "16vk-GS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "vrgstrgl" to "VKEUSTFR"
Then the table has 1 rows
And I set field "intrarel" to "nein" in row 1
Then table has values
    | art 		| mge 	| preis | ofmge |
    | VK1-FALL16	| -22	| 3.00 	| 0	|
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor
#####################################################################################################################################

@FALL-17EK-NACH
@FALL-17VK-NACH
Scenario:17	NACH: AU/BE	LS	TRE1	EU-Austritt	TRE2	        Kude/Lief. aus Nordirland

Given I set the fake date to "23.07.2002"

##############################
# Teil-Rechnung2 anlegen
Given I open an editor "rechnung-17vkb" from table "(Purchasing):(Invoice)" with command "COPY" for record "17ek-LS"
And I set field "num4" to "17ek-RE2"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-17EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "10" in row 1
And I set field "preis" to "4.75" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

##############################
# Teil-Rechnung2 anlegen
Given I open an editor "rechnung-17vkb" from table "(Sales):(Invoice)" with command "COPY" for record "17vk-LS"
And I set field "num3" to "17vk-RE2"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-17VK"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "10" in row 1
And I set field "preis" to "4.75" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
#####################################################################################################################################

@FALL-18EK-NACH
@FALL-18VK-NACH
Scenario:18	NACH: AU/BE	LS	RE(angelegt)	EU-Austritt	RE(verbuchen)

Given I set the fake date to "24.07.2002"

##############################
# Rechnung verbuchen
Given I open an editor "rechnung-18ek" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "18ek-RE"
Then field "fakt" has value "nein"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I save the current editor
And I close the current editor

##############################
# Rechnung verbuchen
Given I open an editor "rechnung-18vk" from table "(Sales):(Invoice)" with command "UPDATE" for record "18vk-RE"
Then field "fakt" has value "nein"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I save the current editor
And I close the current editor
#####################################################################################################################################

@FALL-19EK-NACH
@FALL-19VK-NACH
Scenario:19	NACH: AU/BE	RE	LS(anlegen)	EU-Austritt 	LS(verbuchen)

Given I set the fake date to "24.07.2002"

##############################
# Lieferschein buchen
Given I open an editor "lieferschein-19ek" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "19ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I save the current editor
And I close the current editor

##############################
# Lieferschein buchen
Given I open an editor "lieferschein-19vk" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "19vk-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I save the current editor
And I close the current editor
#####################################################################################################################################

@FALL-20EK-NACH
@FALL-20VK-NACH
Scenario:20	NACH: AU/BE	LS	RE(angelegt)	EU-Austritt	RE(verbuchen)	Kude/Lief. aus Nordirland

Given I set the fake date to "25.07.2002"

##############################
# Rechnung verbuchen
Given I open an editor "rechnung-20ek" from table "(Purchasing):(Invoice)" with command "UPDATE" for record "20ek-RE"
Then field "fakt" has value "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "200.01" in row 1
And I save the current editor
And I close the current editor

##############################
# Rechnung verbuchen
Given I open an editor "rechnung-20vk" from table "(Sales):(Invoice)" with command "UPDATE" for record "20vk-RE"
Then field "fakt" has value "nein"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "preis" to "200.01" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################





