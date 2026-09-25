# *****************************************************************************
#  Name             : steuerobjekte_basis_brexit_002_offene_vorgaenge.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Test des Verhalten der steuerlichen Objekten in EK/VK bei EU-Austritt
#
#
# *****************************************************************************

@persistent
Feature: VRGSTRGL in Verkauf
Background: Test von 
Given I set the fake date to "07.01.2002"


@FALL-1EK-VOR
@FALL-1VK-VOR
Scenario: VOR: 1	AU/BE 	RE 	LS 	EU-Austritt	RLS 	GS

######################
# Bestellung anlegen
Given I open an editor "bestellung-1ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1brexit"
And I set field "num4" to "1ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall1" in row 1
And I set field "mge" to "200" in row 1
And I set field "preis" to "200" in row 1
And I set field "bem" to "FALL-1EK"
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-01ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "bestellung-1ek"
And I set field "num4" to "1ek-RE"
And I set field "fakt" to "nein"
And I set field "bem" to "FALL-1EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "200" in row 1
And I set field "preis" to "200" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-01ek" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-1ek"
And I set field "num4" to "1ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-1EK"
And I create a new row at the end of the table
And I set field "mge" to "200" in row 1
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-1vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1brexit"
And I set field "num3" to "1vk-AU"
And I create a new row at the end of the table
And I set field "artex" to "0vfall1" in row 1
And I set field "mge" to "200" in row 1
And I set field "preis" to "200" in row 1
And I set field "bem" to "FALL-1VK"
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-01vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-1vk"
And I set field "num3" to "1vk-RE"
And I set field "fakt" to "nein"
And I set field "bem" to "FALL-1VK"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "200" in row 1
And I set field "preis" to "200" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-01vk" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-1vk"
And I set field "num3" to "1vk-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "200" in row 1
And I set field "bem" to "FALL-1VK"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-2EK-VOR
@FALL-2VK-VOR
Scenario: 2 VOR:	AU/BE 	LS 	TRE1 	  EU-Austritt	TRE2 	RLS 	GS

Given I set the fake date to "08.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-2ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1brexit"
And I set field "num4" to "2ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall2" in row 1
And I set field "mge" to "250" in row 1
And I set field "preis" to "100" in row 1
And I set field "bem" to "FALL-2EK"
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-02ek" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-2ek"
And I set field "num4" to "2ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-2EK"
And I create a new row at the end of the table
And I set field "mge" to "250" in row 1
And I save the current editor
And I close the current editor

# Teil-Rechnung1 anlegen
Given I open an editor "rechnung-02ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-02ek"
And I set field "num4" to "2ek-RE1"
Then field "fakt" has value "nein"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-2EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "150" in row 1
And I set field "preis" to "100" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-2vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1brexit"
And I set field "num3" to "2vk-AU"
And I create a new row at the end of the table
And I set field "artex" to "0vfall2" in row 1
And I set field "mge" to "250" in row 1
And I set field "preis" to "100" in row 1
And I set field "bem" to "FALL-2VK"
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-02vk" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-2vk"
And I set field "num3" to "2vk-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "250" in row 1
And I set field "bem" to "FALL-2VK"
And I save the current editor
And I close the current editor

# Teil-Rechnung1 anlegen
Given I open an editor "rechnung-02vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-02vk"
And I set field "num3" to "2vk-RE1"
Then field "fakt" has value "nein"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-2VK"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "150" in row 1
And I set field "preis" to "100" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-3EK-VOR
@FALL-3VK-VOR
Scenario: 3 VOR:	AU/BE 	LS 	 EU-Austritt	RE 	RLS 	GS 

Given I set the fake date to "09.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-3ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "1brexit"
And I set field "num4" to "3ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall3" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I set field "bem" to "FALL-3EK"
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-03ek" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-3ek"
And I set field "num4" to "3ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-3EK"
And I create a new row at the end of the table
And I set field "mge" to "10" in row 1
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-3vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "1brexit"
And I set field "num3" to "3vk-AU"
And I set field "bem" to "FALL-3VK"
And I create a new row at the end of the table
And I set field "artex" to "0vfall3" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "50" in row 1
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-03vk" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-3vk"
And I set field "num3" to "3vk-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "10" in row 1
And I set field "bem" to "FALL-3VK"
And I save the current editor
And I close the current editor


# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-4EK-VOR
@FALL-4VK-VOR
Scenario: 4 VOR:	AU/BE 	TRE1 	LS 	EU-Austritt	TRE2 	RLS 	GS 

Given I set the fake date to "10.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-4ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "2brexit"
And I set field "num4" to "4ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall4" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "2" in row 1
And I set field "bem" to "FALL-4EK"
And I save the current editor
And I close the current editor

# TeilRechnung1 anlegen
Given I open an editor "rechnung-04ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "bestellung-4ek"
And I set field "num4" to "4ek-RE1"
And I set field "fakt" to "nein"
And I set field "bem" to "FALL-4EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "20" in row 1
And I set field "preis" to "2" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-04ek" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-4ek"
And I set field "num4" to "4ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-4EK"
And I create a new row at the end of the table
And I set field "mge" to "55" in row 1
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-4vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "2brexit"
And I set field "num3" to "4vk-AU"
And I create a new row at the end of the table
And I set field "artex" to "0vfall4" in row 1
And I set field "mge" to "55" in row 1
And I set field "preis" to "2" in row 1
And I set field "bem" to "FALL-4VK"
And I save the current editor
And I close the current editor

# TeilRechnung1 anlegen
Given I open an editor "rechnung-04vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-4vk"
And I set field "num3" to "4vk-RE1"
And I set field "fakt" to "nein"
And I set field "bem" to "FALL-4VK"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "20" in row 1
And I set field "preis" to "2" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-04vk" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-4vk"
And I set field "num3" to "4vk-LS"
And I set field "ueb" to "ja"
And I set field "bem" to "FALL-4VK"
And I create a new row at the end of the table
And I set field "mge" to "55" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-5EK-VOR 
@FALL-5VK-VOR
Scenario: 5 VOR:	AU/BE 	TRE1(50St) 	LS(100St) 	 EU-Austritt	TRE2(50St) 	TRLS(25St) 	GS 

Given I set the fake date to "11.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-5ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "2brexit"
And I set field "num4" to "5ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall5" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "3" in row 1
And I set field "bem" to "FALL-5EK"
And I save the current editor
And I close the current editor

# TeilRechnung1 anlegen
Given I open an editor "rechnung-05ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "bestellung-5ek"
And I set field "num4" to "5ek-RE1"
And I set field "fakt" to "nein"
And I set field "bem" to "FALL-5EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "50" in row 1
And I set field "preis" to "3" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-05ek" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-5ek"
And I set field "num4" to "5ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-5EK"
And I create a new row at the end of the table
And I set field "mge" to "100" in row 1
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-5vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "2brexit"
And I set field "num3" to "5vk-AU"
And I set field "bem" to "FALL-5VK"
And I create a new row at the end of the table
And I set field "artex" to "0vfall5" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "3" in row 1
And I save the current editor
And I close the current editor

# TeilRechnung1 anlegen
Given I open an editor "rechnung-05vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-5vk"
And I set field "num3" to "5vk-RE1"
And I set field "fakt" to "nein"
And I set field "bem" to "FALL-5VK"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "50" in row 1
And I set field "preis" to "3" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-05vk" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-5vk"
And I set field "num3" to "5vk-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "100" in row 1
And I set field "bem" to "FALL-5VK"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-6EK-VOR
@FALL-6VK-VOR
Scenario: 6 VOR:	AU/BE 	TRE1(50St) 	LS(100St) 	  EU-Austritt	TRE2(50St) 	TRLS(75St) 	GS 

Given I set the fake date to "12.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-6ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "2brexit"
And I set field "num4" to "6ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall6" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "3" in row 1
And I set field "bem" to "FALL-6EK"
And I save the current editor
And I close the current editor

# TeilRechnung1 anlegen
Given I open an editor "rechnung-06ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "bestellung-6ek"
And I set field "num4" to "6ek-RE1"
And I set field "fakt" to "nein"
And I set field "bem" to "FALL-6EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "50" in row 1
And I set field "preis" to "3" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-06ek" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-6ek"
And I set field "num4" to "6ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-6EK"
And I create a new row at the end of the table
And I set field "mge" to "100" in row 1
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-6vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "2brexit"
And I set field "num3" to "6vk-AU"
And I create a new row at the end of the table
And I set field "artex" to "0vfall6" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "3" in row 1
And I set field "bem" to "FALL-6VK"
And I save the current editor
And I close the current editor

# TeilRechnung1 anlegen
Given I open an editor "rechnung-06vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-6vk"
And I set field "num3" to "6vk-RE1"
And I set field "fakt" to "nein"
And I set field "bem" to "FALL-6VK"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "50" in row 1
And I set field "preis" to "3" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-06vk" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-6vk"
And I set field "num3" to "6vk-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "100" in row 1
And I set field "bem" to "FALL-6VK"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-7EK-VOR
@FALL-7VK-VOR
Scenario: 7 VOR:	AU/BE 	LS1, LS2 	RE 	 EU-Austritt	RLS1 	GS 

Given I set the fake date to "13.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-7ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "2brexit"
And I set field "num4" to "7ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall7" in row 1
And I set field "mge" to "233" in row 1
And I set field "preis" to "3" in row 1
And I set field "bem" to "FALL-7EK"
And I save the current editor
And I close the current editor

# Lieferschein1 anlegen
Given I open an editor "lieferschein-07vka" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-7ek"
And I set field "num4" to "7ek-LS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-7EK"
And I create a new row at the end of the table
And I set field "mge" to "111" in row 1
And I save the current editor
And I close the current editor

# Lieferschein2 anlegen
Given I open an editor "lieferschein-07vkb" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-7ek"
And I set field "num4" to "7ek-LS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-7EK"
And I create a new row at the end of the table
And I set field "mge" to "122" in row 1
And I save the current editor
And I close the current editor

# Sammel-Rechnung anlegen
Given I open an editor "rechnung-07ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "bestellung-7ek"
And I set field "num4" to "7ek-RE1"
And I set field "fakt" to "nein"
And I set field "bem" to "FALL-7EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "beleg" to id from editor "lieferschein-07vka"
And I set field "beleg" to id from editor "lieferschein-07vkb"
And I set field "intrarel" to "nein" in row 1
And I set field "intrarel" to "nein" in row 3
And I set field "intrarel" to "nein" in row 5
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-7vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "2brexit"
And I set field "num3" to "7vk-AU"
And I set field "bem" to "FALL-7VK"
And I create a new row at the end of the table
And I set field "artex" to "0vfall7" in row 1
And I set field "mge" to "233" in row 1
And I set field "preis" to "3" in row 1
And I save the current editor
And I close the current editor

# Lieferschein1 anlegen
Given I open an editor "lieferschein-07vka" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-7vk"
And I set field "num3" to "7vk-LS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-7VK"
And I create a new row at the end of the table
And I set field "mge" to "111" in row 1
And I save the current editor
And I close the current editor

# Lieferschein2 anlegen
Given I open an editor "lieferschein-07vkb" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-7vk"
And I set field "num3" to "7vk-LS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-7VK"
And I create a new row at the end of the table
And I set field "mge" to "122" in row 1
And I save the current editor
And I close the current editor

# Sammel-Rechnung anlegen
Given I open an editor "rechnung-07vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-7vk"
And I set field "num3" to "7vk-RE1"
And I set field "fakt" to "nein"
And I set field "bem" to "FALL-7VK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "beleg" to id from editor "lieferschein-07vka"
And I set field "beleg" to id from editor "lieferschein-07vkb"
And I set field "intrarel" to "nein" in row 1
And I set field "intrarel" to "nein" in row 3
And I set field "intrarel" to "nein" in row 5
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-8EK-VOR
@FALL-8VK-VOR
Scenario: 8 VOR:	AU/BE 	LS1, LS2 	RE1, RE2 	EU-Austritt	RLS1 	GS 

Given I set the fake date to "14.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-8ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "2brexit"
And I set field "num4" to "8ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall8" in row 1
And I set field "mge" to "77" in row 1
And I set field "preis" to "1" in row 1
And I set field "bem" to "FALL-8EK"
And I save the current editor
And I close the current editor

# Lieferschein1 anlegen
Given I open an editor "lieferschein-08vka" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-8ek"
And I set field "num4" to "8ek-LS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-8EK"
And I create a new row at the end of the table
And I set field "mge" to "44" in row 1
And I save the current editor
And I close the current editor

# Lieferschein2 anlegen
Given I open an editor "lieferschein-08vkb" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-8ek"
And I set field "num4" to "8ek-LS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-8EK"
And I create a new row at the end of the table
And I set field "mge" to "33" in row 1
And I save the current editor
And I close the current editor

# Rechnung1 anlegen
Given I open an editor "rechnung-08vka" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-08vka"
And I set field "num4" to "8ek-RE1"
Then field "fakt" has value "nein"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-8EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-08vkb" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-08vkb"
And I set field "num4" to "8ek-RE2"
Then field "fakt" has value "nein"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-8EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-8vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "2brexit"
And I set field "num3" to "8vk-AU"
And I set field "bem" to "FALL-8VK"
And I create a new row at the end of the table
And I set field "artex" to "0vfall8" in row 1
And I set field "mge" to "77" in row 1
And I set field "preis" to "1" in row 1
And I save the current editor
And I close the current editor

# Lieferschein1 anlegen
Given I open an editor "lieferschein-08vka" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-8vk"
And I set field "num3" to "8vk-LS1"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "44" in row 1
And I set field "bem" to "FALL-8VK"
And I save the current editor
And I close the current editor

# Lieferschein2 anlegen
Given I open an editor "lieferschein-08vkb" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-8vk"
And I set field "num3" to "8vk-LS2"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "33" in row 1
And I set field "bem" to "FALL-8VK"
And I save the current editor
And I close the current editor

# Rechnung1 anlegen
Given I open an editor "rechnung-08vka" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-08vka"
And I set field "num3" to "8vk-RE1"
Then field "fakt" has value "nein"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-8VK"
And I set field "ueb" to "ja"
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Rechnung2 anlegen
Given I open an editor "rechnung-08vkb" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-08vkb"
And I set field "num3" to "8vk-RE2"
Then field "fakt" has value "nein"
Then field "fakt" is not modifiable
And I set field "bem" to "FALL-8VK"
And I set field "ueb" to "ja"
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-9EK-VOR
@FALL-9VK-VOR
Scenario: 9 VOR:	AU/BE 	LS1, LS2 	 EU-Austritt	RE 	RLS1  	 GS 

Given I set the fake date to "15.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-9ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "3brexit"
And I set field "num4" to "9ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall9" in row 1
And I set field "mge" to "77" in row 1
And I set field "preis" to "1" in row 1
And I set field "bem" to "FALL-9EK"
And I save the current editor
And I close the current editor

# Lieferschein1 anlegen
Given I open an editor "lieferschein-09vka" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-9ek"
And I set field "num4" to "9ek-LS1"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "44" in row 1
And I set field "bem" to "FALL-9EK"
And I save the current editor
And I close the current editor

# Lieferschein2 anlegen
Given I open an editor "lieferschein-09vkb" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-9ek"
And I set field "num4" to "9ek-LS2"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "33" in row 1
And I set field "bem" to "FALL-9EK"
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-9vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "3brexit"
And I set field "num3" to "9vk-AU"
And I create a new row at the end of the table
And I set field "artex" to "0vfall9" in row 1
And I set field "mge" to "77" in row 1
And I set field "preis" to "1" in row 1
And I set field "bem" to "FALL-9VK"
And I save the current editor
And I close the current editor

# Lieferschein1 anlegen
Given I open an editor "lieferschein-09vka" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-9vk"
And I set field "num3" to "9vk-LS1"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "44" in row 1
And I set field "bem" to "FALL-9VK"
And I save the current editor
And I close the current editor

# Lieferschein2 anlegen
Given I open an editor "lieferschein-09vkb" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-9vk"
And I set field "num3" to "9vk-LS2"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "33" in row 1
And I set field "bem" to "FALL-9VK"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-10EK-VOR
@FALL-10VK-VOR
Scenario: 10 VOR:	AU/BE 	 LS 	 RE 	RLS 	EU-Austritt	GS

Given I set the fake date to "16.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-10ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "3brexit"
And I set field "num4" to "10ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall10" in row 1
And I set field "mge" to "99" in row 1
And I set field "preis" to "1" in row 1
And I set field "bem" to "FALL-10EK"
And I save the current editor
And I close the current editor

# Lieferschein1 anlegen
Given I open an editor "lieferschein-10ek" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-10ek"
And I set field "num4" to "10ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "99" in row 1
And I set field "bem" to "FALL-10EK"
And I save the current editor
And I close the current editor

# Rechnung1 anlegen
Given I open an editor "rechnung-10ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-10ek"
And I set field "num4" to "10ek-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-10EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Ruecklieferung von 99 Stk. -> alles von LS
Given I open an editor "ruecklief-10ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-10ek"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "10ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL10" in row 1
And I set field "mge" to "-99" in row 1
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-10vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "3brexit"
And I set field "num3" to "10vk-AU"
And I create a new row at the end of the table
And I set field "artex" to "0vfall10" in row 1
And I set field "mge" to "99" in row 1
And I set field "preis" to "1" in row 1
And I set field "bem" to "FALL-10VK"
And I save the current editor
And I close the current editor

# Lieferschein1 anlegen
Given I open an editor "lieferschein-10vk" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-10vk"
And I set field "num3" to "10vk-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "99" in row 1
And I set field "bem" to "FALL-10VK"
And I save the current editor
And I close the current editor

# Rechnung1 anlegen
Given I open an editor "rechnung-10vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-10vk"
And I set field "num3" to "10vk-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-10VK"
And I set field "ueb" to "ja"
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Ruecklieferung von 99 Stk. -> alles von LS
Given I open an editor "ruecklief-10vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-10vk"
Then field "lsart" has value "Rücklieferschein"
And I set field "num3" to "10vk-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL10" in row 1
And I set field "mge" to "-99" in row 1
And I save the current editor
And I close the current editor


# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-11EK-VOR
@FALL-11VK-VOR
Scenario: 11 VOR:	AU/BE (100St) 	 LS (100St) 	 TRE (30St) 	TRLS(45St) 	EU-Austritt	TRE2 (25St)

Given I set the fake date to "17.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-11ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "3brexit"
And I set field "num4" to "11ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall11" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "bem" to "FALL-11EK"
And I save the current editor
And I close the current editor

# Lieferschein1 anlegen
Given I open an editor "lieferschein-11ek" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-11ek"
And I set field "num4" to "11ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-11EK"
And I create a new row at the end of the table
And I set field "mge" to "100" in row 1
And I save the current editor
And I close the current editor

# Rechnung1 anlegen
Given I open an editor "rechnung-11ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-11ek"
And I set field "num4" to "11ek-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-11EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "30" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# TeilRuecklieferung von 45 Stk. -> von LS
Given I open an editor "ruecklief-11ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-11ek"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "11ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL11" in row 1
And I set field "mge" to "-45" in row 1
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-11vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "3brexit"
And I set field "num3" to "11vk-AU"
And I create a new row at the end of the table
And I set field "artex" to "0vfall11" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I set field "bem" to "FALL-11VK"
And I save the current editor
And I close the current editor

# Lieferschein1 anlegen
Given I open an editor "lieferschein-11vk" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-11vk"
And I set field "num3" to "11vk-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "100" in row 1
And I set field "bem" to "FALL-11VK"
And I save the current editor
And I close the current editor

# Rechnung1 anlegen
Given I open an editor "rechnung-11vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-11vk"
And I set field "num3" to "11vk-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-11VK"
And I set field "ueb" to "ja"
And I set field "mge" to "30" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# TeilRuecklieferung von 45 Stk. -> von LS
Given I open an editor "ruecklief-11vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-11vk"
Then field "lsart" has value "Rücklieferschein"
And I set field "num3" to "11vk-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL11" in row 1
And I set field "mge" to "-45" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-12EK-VOR
@FALL-12VK-VOR
Scenario: 12 VOR:	 - 	 LS 	 RE 	RLS 	EU-Austritt	GS

Given I set the fake date to "18.01.2002"

######################
# Lieferschein anlegen
Given I open an editor "lieferschein-12ek" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "3brexit"
And I set field "num4" to "12ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-12EK"
And I create a new row at the end of the table
And I set field "artex" to "0vfall12" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-12ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-12ek"
And I set field "num4" to "12ek-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-12EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "100" in row 1
And I set field "preis" to "9" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Ruecklieferung von 100 Stk. -> alles von LS
Given I open an editor "ruecklief-12ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-12ek"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "12ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL12" in row 1
And I set field "mge" to "-100" in row 1
And I save the current editor
And I close the current editor

######################
# Lieferschein anlegen
Given I open an editor "lieferschein-12vk" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "3brexit"
And I set field "num3" to "12vk-LS"
And I set field "ueb" to "ja"
And I set field "bem" to "FALL-12VK"
And I create a new row at the end of the table
And I set field "artex" to "0vfall12" in row 1
And I set field "mge" to "100" in row 1
And I set field "preis" to "1" in row 1
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-12vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-12vk"
And I set field "num3" to "12vk-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-12VK"
And I set field "ueb" to "ja"
And I set field "mge" to "100" in row 1
And I set field "preis" to "9" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Ruecklieferung von 100 Stk. -> alles von LS
Given I open an editor "ruecklief-12vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-12vk"
Then field "lsart" has value "Rücklieferschein"
And I set field "num3" to "12vk-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL12" in row 1
And I set field "mge" to "-100" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-13EK-VOR
@FALL-13VK-VOR
Scenario: 13 VOR:	 - 	 LS (100St) 	 TRE1 (30St) 	EU-Austritt	TRLS (45St) 	 TRE2 (25St)

Given I set the fake date to "19.01.2002"

######################
# Lieferschein anlegen
Given I open an editor "lieferschein-13ek" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "3brexit"
And I set field "num4" to "13ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "0vfall13" in row 1
And I set field "mge" to "100" in row 1
And I set field "bem" to "FALL-13EK"
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-13ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-13ek"
And I set field "num4" to "13ek-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-13EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "30" in row 1
And I set field "preis" to "2" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

######################
# Lieferschein anlegen
Given I open an editor "lieferschein-13vk" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "3brexit"
And I set field "num3" to "13vk-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "0vfall13" in row 1
And I set field "mge" to "100" in row 1
And I set field "bem" to "FALL-13VK"
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-13vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-13vk"
And I set field "num3" to "13vk-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-13VK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "30" in row 1
And I set field "preis" to "2" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-14EK-VOR
@FALL-14VK-VOR
Scenario: 14 VOR:	 - 	 LS (100St) 	 RLS (20St) 	EU-Austritt	 RE (80St)

Given I set the fake date to "20.01.2002"

######################
# Lieferschein anlegen
Given I open an editor "lieferschein-14ek" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "4brexit"
And I set field "num4" to "14ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "0vfall14" in row 1
And I set field "mge" to "100" in row 1
And I set field "bem" to "FALL-14EK"
And I save the current editor
And I close the current editor

# Ruecklieferung von 20 Stk. -> von LS
Given I open an editor "ruecklief-14ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-14ek"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "14ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL14" in row 1
And I set field "mge" to "-20" in row 1
And I save the current editor
And I close the current editor

######################
# Lieferschein anlegen
Given I open an editor "lieferschein-14vk" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "4brexit"
And I set field "num3" to "14vk-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "0vfall14" in row 1
And I set field "mge" to "100" in row 1
And I set field "bem" to "FALL-14VK"
And I save the current editor
And I close the current editor

# Ruecklieferung von 20 Stk. -> von LS
Given I open an editor "ruecklief-14vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-14vk"
Then field "lsart" has value "Rücklieferschein"
And I set field "num3" to "14vk-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL14" in row 1
And I set field "mge" to "-20" in row 1
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-15EK-VOR
@FALL-15VK-VOR
Scenario: 15 VOR:	 - 	 LS (100St) 	 RLS (20St) 	TRE1 (30St) 	EU-Austritt	 TRE2 (50St) 

Given I set the fake date to "21.01.2002"

######################
# Lieferschein anlegen
Given I open an editor "lieferschein-15ek" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set field "lief" to "4brexit"
And I set field "num4" to "15ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "artex" to "0vfall15" in row 1
And I set field "mge" to "100" in row 1
And I set field "bem" to "FALL-15EK"
And I save the current editor
And I close the current editor

# Ruecklieferung von 20 Stk. -> von LS
Given I open an editor "ruecklief-15ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-15ek"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "15ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL15" in row 1
And I set field "mge" to "-20" in row 1
And I save the current editor
And I close the current editor

# Teil-Rechnung1 anlegen
Given I open an editor "rechnung-15ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-15ek"
And I set field "num4" to "15ek-RE1"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-15EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "30" in row 1
And I set field "preis" to "5" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

######################
# Lieferschein anlegen
Given I open an editor "lieferschein-15vk" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "kunde" to "4brexit"
And I set field "num3" to "15vk-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "artex" to "0vfall15" in row 1
And I set field "mge" to "100" in row 1
And I set field "bem" to "FALL-15VK"
And I save the current editor
And I close the current editor

# Ruecklieferung von 20 Stk. -> von LS
Given I open an editor "ruecklief-15vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-15vk"
Then field "lsart" has value "Rücklieferschein"
And I set field "num3" to "15vk-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL15" in row 1
And I set field "mge" to "-20" in row 1
And I save the current editor
And I close the current editor

# Teil-Rechnung1 anlegen
Given I open an editor "rechnung-15vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-15vk"
And I set field "num3" to "15vk-RE1"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-15VK"
And I set field "ueb" to "ja"
And I set field "mge" to "30" in row 1
And I set field "preis" to "5" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-16EK-VOR
@FALL-16VK-VOR
Scenario:16	VOR: AU/BE	LS	RE	RLS	EU-Austritt	GS	Kude/Lief. aus Nordirland

Given I set the fake date to "22.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-16ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "5brexit"
And I set field "num4" to "16ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall16" in row 1
And I set field "mge" to "22" in row 1
And I set field "preis" to "3" in row 1
And I set field "bem" to "FALL-16EK"
And I save the current editor
And I close the current editor

# Lieferschein1 anlegen
Given I open an editor "lieferschein-16ek" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-16ek"
And I set field "num4" to "16ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "22" in row 1
And I set field "bem" to "FALL-16EK"
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-16ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-16ek"
And I set field "num4" to "16ek-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-16EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Ruecklieferung von 22 Stk. -> alles von LS
Given I open an editor "ruecklief-16ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-16ek"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "16ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL16" in row 1
And I set field "mge" to "-22" in row 1
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-16vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "5brexit"
And I set field "num3" to "16vk-AU"
And I create a new row at the end of the table
And I set field "artex" to "0vfall16" in row 1
And I set field "mge" to "22" in row 1
And I set field "preis" to "3" in row 1
And I set field "bem" to "FALL-16VK"
And I save the current editor
And I close the current editor

# Lieferschein1 anlegen
Given I open an editor "lieferschein-16vk" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-16vk"
And I set field "num3" to "16vk-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "22" in row 1
And I set field "bem" to "FALL-16VK"
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-16vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-16vk"
And I set field "num3" to "16vk-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-16VK"
And I set field "ueb" to "ja"
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Ruecklieferung von 22 Stk. -> alles von LS
Given I open an editor "ruecklief-16vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-16vk"
Then field "lsart" has value "Rücklieferschein"
And I set field "num3" to "16vk-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL16" in row 1
And I set field "mge" to "-22" in row 1
And I save the current editor
And I close the current editor


# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-17EK-VOR
@FALL-17VK-VOR
Scenario:17	VOR: AU/BE	LS	TRE1	EU-Austritt	TRE2	        Kude/Lief. aus Nordirland

Given I set the fake date to "23.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-17ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "5brexit"
And I set field "num4" to "17ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall17" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "4" in row 1
And I set field "bem" to "FALL-17EK"
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-17ek" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-17ek"
And I set field "num4" to "17ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-17EK"
And I create a new row at the end of the table
And I set field "mge" to "25" in row 1
And I save the current editor
And I close the current editor

# Teil-Rechnung1 anlegen
Given I open an editor "rechnung-17ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-17ek"
And I set field "num4" to "17ek-RE1"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-17EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "15" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-17vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "5brexit"
And I set field "num3" to "17vk-AU"
And I create a new row at the end of the table
And I set field "artex" to "0vfall17" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "4" in row 1
And I set field "bem" to "FALL-17VK"
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-17vk" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-17vk"
And I set field "num3" to "17vk-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "25" in row 1
And I set field "bem" to "FALL-17VK"
And I save the current editor
And I close the current editor

# Teil-Rechnung1 anlegen
Given I open an editor "rechnung-17vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-17vk"
And I set field "num3" to "17vk-RE1"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-17VK"
And I set field "ueb" to "ja"
And I set field "mge" to "15" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-18EK-VOR
@FALL-18VK-VOR
Scenario:18	VOR: AU/BE	LS	RE(angelegt)	EU-Austritt	RE(verbuchen)

Given I set the fake date to "24.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-18ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "5brexit"
And I set field "num4" to "18ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall18" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "4" in row 1
And I set field "bem" to "FALL-18EK"
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-18ek" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-18ek"
And I set field "num4" to "18ek-LS"
And I set field "ueb" to "ja"
And I set field "bem" to "FALL-18EK"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "25" in row 1
And I save the current editor
And I close the current editor

# Rechnung anlegen, aber nicht verbuchen
Given I open an editor "rechnung-18ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-18ek"
And I set field "num4" to "18ek-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-18EK"
And I set field "ueb" to "nein"
And I set field "vom" to "."
And I set field "mge" to "25" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-18vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "5brexit"
And I set field "num3" to "18vk-AU"
And I create a new row at the end of the table
And I set field "artex" to "0vfall18" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "4" in row 1
And I set field "bem" to "FALL-18VK"
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-18vk" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-18vk"
And I set field "num3" to "18vk-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "25" in row 1
And I set field "bem" to "FALL-18VK"
And I save the current editor
And I close the current editor

# Rechnung anlegen, aber nicht verbuchen
Given I open an editor "rechnung-18vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-18vk"
And I set field "num3" to "18vk-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-18VK"
And I set field "ueb" to "nein"
And I set field "mge" to "25" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-19EK-VOR
@FALL-19VK-VOR
Scenario:19	VOR: AU/BE	RE	LS(anlegen)	EU-Austritt 	LS(verbuchen)

Given I set the fake date to "24.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-19ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "6brexit"
And I set field "num4" to "19ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall19" in row 1
And I set field "mge" to "200" in row 1
And I set field "preis" to "200" in row 1
And I set field "bem" to "FALL-19EK"
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-19ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "bestellung-19ek"
And I set field "num4" to "19ek-RE"
And I set field "fakt" to "nein"
And I set field "bem" to "FALL-19EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "200" in row 1
And I set field "preis" to "200" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Lieferschein anlegen, aber nicht buchen
Given I open an editor "lieferschein-19ek" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-19ek"
And I set field "num4" to "19ek-LS"
And I set field "ueb" to "nein"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "200" in row 1
And I set field "bem" to "FALL-19EK"
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-19vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "6brexit"
And I set field "num3" to "19vk-AU"
And I create a new row at the end of the table
And I set field "artex" to "0vfall19" in row 1
And I set field "mge" to "200" in row 1
And I set field "preis" to "200" in row 1
And I set field "bem" to "FALL-19VK"
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-19vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "auftrag-19vk"
And I set field "num3" to "19vk-RE"
And I set field "fakt" to "nein"
And I set field "bem" to "FALL-19VK"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "200" in row 1
And I set field "preis" to "200" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Lieferschein anlegen, aber nicht buchen
Given I open an editor "lieferschein-19vk" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-19vk"
And I set field "num3" to "19vk-LS"
And I set field "ueb" to "nein"
And I create a new row at the end of the table
And I set field "mge" to "200" in row 1
And I set field "bem" to "FALL-19VK"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-20EK-VOR
@FALL-20VK-VOR
Scenario:20	VOR: AU/BE	LS	RE(angelegt)	EU-Austritt	RE(verbuchen)	Kude/Lief. aus Nordirland

Given I set the fake date to "25.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-20ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "7brexit"
And I set field "num4" to "20ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall20" in row 1
And I set field "mge" to "200" in row 1
And I set field "preis" to "200" in row 1
And I set field "bem" to "FALL-20EK"
And I save the current editor
And I close the current editor

# Lieferschein anlegen, aber nicht buchen
Given I open an editor "lieferschein-20ek" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-20ek"
And I set field "num4" to "20ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-20EK"
And I create a new row at the end of the table
And I set field "mge" to "200" in row 1
And I save the current editor
And I close the current editor

# Rechnung anlegen, aber nicht verbuchen
Given I open an editor "rechnung-20ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-20ek"
And I set field "num4" to "20ek-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-20EK"
And I set field "ueb" to "nein"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "200" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-20vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "7brexit"
And I set field "num3" to "20vk-AU"
And I create a new row at the end of the table
And I set field "artex" to "0vfall20" in row 1
And I set field "mge" to "200" in row 1
And I set field "preis" to "200" in row 1
And I set field "bem" to "FALL-20VK"
And I save the current editor
And I close the current editor

# Lieferschein anlegen, aber nicht buchen
Given I open an editor "lieferschein-20vk" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-20vk"
And I set field "num3" to "20vk-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "200" in row 1
And I set field "bem" to "FALL-20VK"
And I save the current editor
And I close the current editor

# Rechnung anlegen, aber nicht verbuchen
Given I open an editor "rechnung-20vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-20vk"
And I set field "num3" to "20vk-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-20VK"
And I set field "ueb" to "nein"
And I create a new row at the end of the table
And I set field "mge" to "200" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-21EK-VOR
@FALL-21VK-VOR
Scenario:21	VOR: AU/BE	LS	RE	RLS	EU-Austritt	GS	Kude/Lief. aus Nordirland

Given I set the fake date to "25.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-21ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "8brexit"
And I set field "num4" to "21ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall21" in row 1
And I set field "mge" to "22" in row 1
And I set field "preis" to "3" in row 1
And I set field "bem" to "FALL-21EK"
And I save the current editor
And I close the current editor

# Lieferschein1 anlegen
Given I open an editor "lieferschein-21ek" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-21ek"
And I set field "num4" to "21ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "22" in row 1
And I set field "bem" to "FALL-21EK"
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-21ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-21ek"
And I set field "num4" to "21ek-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-21EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Ruecklieferung von 22 Stk. -> alles von LS
Given I open an editor "ruecklief-21ek" from table "(Purchasing):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-21ek"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "21ek-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL21" in row 1
And I set field "mge" to "-22" in row 1
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-21vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "8brexit"
And I set field "num3" to "21vk-AU"
And I create a new row at the end of the table
And I set field "artex" to "0vfall21" in row 1
And I set field "mge" to "22" in row 1
And I set field "preis" to "3" in row 1
And I set field "bem" to "FALL-21VK"
And I save the current editor
And I close the current editor

# Lieferschein1 anlegen
Given I open an editor "lieferschein-21vk" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-21vk"
And I set field "num3" to "21vk-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "22" in row 1
And I set field "bem" to "FALL-21VK"
And I save the current editor
And I close the current editor

# Rechnung anlegen
Given I open an editor "rechnung-21vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-21vk"
And I set field "num3" to "21vk-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-21VK"
And I set field "ueb" to "ja"
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Ruecklieferung von 22 Stk. -> alles von LS
Given I open an editor "ruecklief-21vk" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "lieferschein-21vk"
Then field "lsart" has value "Rücklieferschein"
And I set field "num3" to "21vk-RLS"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "VK1-FALL21" in row 1
And I set field "mge" to "-22" in row 1
And I save the current editor
And I close the current editor


# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-22EK-VOR
@FALL-22VK-VOR
Scenario:22	VOR: AU/BE	LS	TRE1	EU-Austritt	TRE2	        Kude/Lief. aus Nordirland

Given I set the fake date to "26.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-22ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "9brexit"
And I set field "num4" to "22ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall22" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "4" in row 1
And I set field "bem" to "FALL-22EK"
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-22ek" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-22ek"
And I set field "num4" to "22ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-22EK"
And I create a new row at the end of the table
And I set field "mge" to "25" in row 1
And I save the current editor
And I close the current editor

# Teil-Rechnung1 anlegen
Given I open an editor "rechnung-22ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-22ek"
And I set field "num4" to "22ek-RE1"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-22EK"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "mge" to "15" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-22vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "9brexit"
And I set field "num3" to "22vk-AU"
And I create a new row at the end of the table
And I set field "artex" to "0vfall22" in row 1
And I set field "mge" to "25" in row 1
And I set field "preis" to "4" in row 1
And I set field "bem" to "FALL-22VK"
And I save the current editor
And I close the current editor

# Lieferschein anlegen
Given I open an editor "lieferschein-22vk" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-22vk"
And I set field "num3" to "22vk-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "25" in row 1
And I set field "bem" to "FALL-22VK"
And I save the current editor
And I close the current editor

# Teil-Rechnung1 anlegen
Given I open an editor "rechnung-22vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-22vk"
And I set field "num3" to "22vk-RE1"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-22VK"
And I set field "ueb" to "ja"
And I set field "mge" to "15" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################

@FALL-23EK-VOR
@FALL-23VK-VOR
Scenario:23	VOR: AU/BE	LS	RE(angelegt)	EU-Austritt	RE(verbuchen)	Kude/Lief. aus Nordirland

Given I set the fake date to "27.01.2002"

######################
# Bestellung anlegen
Given I open an editor "bestellung-23ek" from table "(Purchasing):(PurchaseOrder)" with command "NEW" for record ""
And I set field "lief" to "9brexit"
And I set field "num4" to "23ek-BE"
And I create a new row at the end of the table
And I set field "artex" to "0vfall23" in row 1
And I set field "mge" to "230" in row 1
And I set field "preis" to "230" in row 1
And I set field "bem" to "FALL-23EK"
And I save the current editor
And I close the current editor

# Lieferschein anlegen, aber nicht buchen
Given I open an editor "lieferschein-23ek" from table "(Purchasing):(PackingSlip)" with command "COPY" for record from editor "bestellung-23ek"
And I set field "num4" to "23ek-LS"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I set field "bem" to "FALL-23EK"
And I create a new row at the end of the table
And I set field "mge" to "230" in row 1
And I save the current editor
And I close the current editor

# Rechnung anlegen, aber nicht verbuchen
Given I open an editor "rechnung-23ek" from table "(Purchasing):(Invoice)" with command "COPY" for record from editor "lieferschein-23ek"
And I set field "num4" to "23ek-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-23EK"
And I set field "ueb" to "nein"
And I set field "vom" to "."
And I create a new row at the end of the table
And I set field "mge" to "230" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

######################
# Auftrag anlegen
Given I open an editor "auftrag-23vk" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "9brexit"
And I set field "num3" to "23vk-AU"
And I create a new row at the end of the table
And I set field "artex" to "0vfall23" in row 1
And I set field "mge" to "230" in row 1
And I set field "preis" to "230" in row 1
And I set field "bem" to "FALL-23VK"
And I save the current editor
And I close the current editor

# Lieferschein anlegen, aber nicht buchen
Given I open an editor "lieferschein-23vk" from table "(Sales):(PackingSlip)" with command "COPY" for record from editor "auftrag-23vk"
And I set field "num3" to "23vk-LS"
And I set field "ueb" to "ja"
And I create a new row at the end of the table
And I set field "mge" to "230" in row 1
And I set field "bem" to "FALL-23VK"
And I save the current editor
And I close the current editor

# Rechnung anlegen, aber nicht verbuchen
Given I open an editor "rechnung-23vk" from table "(Sales):(Invoice)" with command "COPY" for record from editor "lieferschein-23vk"
And I set field "num3" to "23vk-RE"
Then field "fakt" has value "nein"
And I set field "bem" to "FALL-23VK"
And I set field "ueb" to "nein"
And I create a new row at the end of the table
And I set field "mge" to "230" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
#####################################################################################################################################


