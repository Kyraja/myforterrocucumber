# *****************************************************************************
#  Name             : ref_steuerobjekte_bei_eu_austritt2_004.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Test des Verhalten der steuerlichen Objekten in EK/VK bei EU-Austritt
#                     Hier werden Lohnfertigungsfaelle zu Ende gefuehrt.
#                     Nordirlaender werden im steuerlichen Sinne als EU-Mitglieder behandelt.
#
#
#
#  https://extranet.abas.de/sub_de/abas-business-suite/erp/funktionsbereiche/Technischer_Leitfaden_Brexit.pdf
# *****************************************************************************

@persistent
Feature: ref_steuerobjekte_bei_eu_austritt2_004.feature
Background: steuerliche Objekten in EK/VK

Given I set the fake date to "30.07.2002"

@FALL-LohnFertMITKOPPEL
Scenario: @FALL-LohnFertMITKOPPEL zu Ende bringen: EK- und VK-Rechnung bezahlen + Nachbewerten



# Rechnung aus Lieferschein 2
Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "COPY" for record "200LO-LS"
And I set field "num4" to "200LO-RE"
And I set field "ueb" to "ja"
And I set field "vom" to "."
# Irland
And I set field "lief" to "BREXIT5"
And I set field "kenn" to "FALL-LohnFertMITKOPPEL"
And I set field "preis" to "107" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# VK-Rechnung aus Auftrag
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "COPY" for record "200-LS"
And I set field "num3" to "200-RE"
And I set field "vom" to "."
And I set field "tterm" to "."
And I set field "kenn" to "FALL-LohnFertMITKOPPEL"
And I set field "preis" to "373" in row 1
And I set field "intrarel" to "nein" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor

# Nachbewerten + Kostenverbuchung(alles)
Given I create CostEntriesSuggestions "mkv-alle" with all types of cost entry for startdate "01.01." until enddate "." with Command Revalue
######################################################################################################################################
