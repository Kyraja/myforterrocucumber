# *****************************************************************************
#  Name             : steuerobjekte_ev_ruecklieferung_kaufmgutschrift_004_vk_fixierung.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Ueberwachung von steuerlichen Objekten bei
#                     Ruecklieferungen, KGS und Storno in Verkauf
#
#
#  Beschreibung: siehe REWE-3686
#            Scenario: 1VK: AU-LS-RE-(RLS aus LS)-(KGS aus RLS)
#            Scenario: 2VK: AU-LS-RE-(RLS aus LS)-(KGS aus RLS)
#            Scenario: 3VK: AU-LS-(RLS aus LS)-(RE aus LS)-(KGS aus RLS)
#            Scenario: 4VK: AU-LS1-LS2-(RE aus LS1)-(RLS1 aus LS1)-(KGS aus RLS1)
#            Scenario: 5VK: AU-LS1-LS2-(RE aus LS1)-(RLS1 aus LS1)-(KGS aus RLS1)
#            Scenario: 6VK: AU-LS1-LS2-(RE aus LS1)-(RLS1 aus LS1)-(KGS aus RLS1)-(Storno KGS1)
#            Scenario: 7VK: AU-LS-(RLS aus LS)-(RE aus LS)-(KGS aus RLS uber Beleg anfuegen)
#
#
#
# *****************************************************************************

@persistent
Feature: steuerobjekte_ev_ruecklieferung_kaufmgutschrift_004_vk_fixierung.feature
Background: steuerliche Objekten in VK


Scenario: 1VK: AU-LS-RE-(RLS aus LS)-(KGS aus RLS)

Given I open an editor "auftrag-vk1" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "1vk-au"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "125" in row 1
And I set field "preis" to "13.15" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
And I save the current editor


# Auftrag beliefern
Given I open an editor "ls-vk1" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-vk1"
And I set field "nummer" to "1vk-ls"
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Rechnung aus Lieferschein
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-vk1"
And I set field "nummer" to "1vk-re"
And I set field "tterm" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von 25 Stk
Given I open an editor "rls-vk1" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "ls-vk1"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "1vk-rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "203" in row 1
And I set field "mge" to "-25" in row 1
# Felder abfragen
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
#
# Tauschen
And I set field "konto" to "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
And I set field "kstelle" to "100" in row 1
Then field "fixkstelle" has value "ja" in row 1
And I set field "strgl" to "VKINFREI" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
# verbuchen
And I save the current editor
And I close the current editor


# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "kgs-vk1" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "rls-vk1"
And I set field "nummer" to "1vk-gs"
And I set field "vom" to "."
# Felder abfragen
Then field "kstelle" has value "101" in row 1
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "fixkstelle" has value "nein" in row 1
#
And I set field "strgl" to "5006" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Felder in Rechnung/KGS nochmal kontrollieren
Given I open an editor "kontrolle" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "kgs-vk1"
# Felder abfragen
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
#
And I close the current editor
#####################################################################################################################################


Scenario: 2VK: AU-LS-RE-(RLS aus LS)-(KGS aus RLS)

Given I open an editor "auftrag-vk2" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "2vk-au"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "105" in row 1
And I set field "preis" to "13.40" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
And I save the current editor


# Auftrag beliefern
Given I open an editor "ls-vk2" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-vk2"
And I set field "nummer" to "2vk-ls"
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
#
# Tauschen
And I set field "konto" to "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
And I set field "kstelle" to "100" in row 1
Then field "fixkstelle" has value "ja" in row 1
And I set field "strgl" to "VKINFREI" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Rechnung aus Lieferschein
Given I open an editor "rechnung2" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-vk2"
And I set field "nummer" to "2vk-re"
And I set field "tterm" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "kstelle" has value "100" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# Fixierung rausnehmen
And I set field "fixkonto" to "nein" in row 1
And I set field "fixstrgl" to "nein" in row 1
And I set field "fixkstelle" to "nein" in row 1
Then field "konto" has value "44000" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von 34 Stk
Given I open an editor "rls-vk2" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "ls-vk2"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "2vk-rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "203" in row 1
And I set field "mge" to "-34" in row 1
# Felder abfragen
Then field "konto" has value "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "kstelle" has value "100" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# Fixierung rausnehmen
And I set field "fixstrgl" to "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
# verbuchen
And I save the current editor
And I close the current editor


# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "kgs-vk2" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "rls-vk2"
And I set field "nummer" to "2vk-gs"
And I set field "vom" to "."
# Felder abfragen
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Felder in Rechnung/KGS nochmal kontrollieren
Given I open an editor "kontrolle" from table "(Sales):(Invoice)" with command "VIEW" for record from editor "kgs-vk2"
# Felder abfragen
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
#
And I close the current editor
#####################################################################################################################################


Scenario: 3VK: AU-LS-(RLS aus LS)-(RE aus LS)-(KGS aus RLS)

Given I open an editor "auftrag-vk3" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "3vk-au"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "105" in row 1
And I set field "preis" to "13.40" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
And I save the current editor


# Auftrag beliefern
Given I open an editor "ls-vk3" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-vk3"
And I set field "nummer" to "3vk-ls"
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
#
# Tauschen
And I set field "kstelle" to "100" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Ruecklieferung von 7 Stk
Given I open an editor "rls-vk3" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "ls-vk3"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "3vk-rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "203" in row 1
And I set field "mge" to "-7" in row 1
# Felder abfragen
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "100" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# Tauschen
And I set field "konto" to "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
#
# verbuchen
And I save the current editor
And I close the current editor


# Rechnung aus Lieferschein
Given I open an editor "rechnung-vk3" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-vk3"
And I set field "nummer" to "3vk-re"
And I set field "tterm" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "100" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# Tauschen
And I set field "konto" to "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
And I set field "strgl" to "VKINFREI-0" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor



# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "kgs-vk3" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "rls-vk3"
And I set field "nummer" to "3vk-gs"
And I set field "vom" to "."
# Felder abfragen
Then field "konto" has value "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "fixkstelle" has value "ja" in row 1
Then field "kstelle" has value "100" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Kontrolle -> was wirklich gespeichert wurde
Given I open an editor "kontrolle" from table "(Sales):(Invoice)" with command "VIEW" for record "+3vk-gs"
# Felder abfragen
Then field "konto" has value "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "fixkstelle" has value "ja" in row 1
Then field "kstelle" has value "100" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
And I close the current editor
#####################################################################################################################################


Scenario: 4VK: AU-LS1-LS2-(RE aus LS1)-(RLS1 aus LS1)-(KGS aus RLS1)

Given I open an editor "auftrag-vk4" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "4vk-au"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "205" in row 1
And I set field "preis" to "13.13" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
And I save the current editor


# Auftrag beliefern
Given I open an editor "ls1-vk4" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-vk4"
And I set field "nummer" to "4vk-ls1"
And I press button "offueb" in row 1
And I set field "mge" to "105" in row 1
# Felder abfragen
Then field "ofmge" has value "100" in row 1
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Auftrag beliefern
Given I open an editor "ls2-vk4" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-vk4"
And I set field "nummer" to "4vk-ls2"
And I press button "offueb" in row 1
# Felder abfragen
Then field "ofmge" has value "0" in row 1
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
#
# Tauschen
And I set field "konto" to "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
And I set field "kstelle" to "100" in row 1
Then field "fixkstelle" has value "ja" in row 1
And I set field "strgl" to "VKINFREI" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Rechnung aus Lieferschein
Given I open an editor "rechnung1-vk4" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls1-vk4"
And I set field "nummer" to "4vk-re1"
And I set field "tterm" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
#
# Tauschen
And I set field "konto" to "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
And I set field "kstelle" to "100" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von 47 Stk
Given I open an editor "rls-vk4" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "ls1-vk4"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "4vk-rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "203" in row 1
And I set field "mge" to "-47" in row 1
# Felder abfragen
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
#
# Tauschen
And I set field "strgl" to "VKINFREI" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
#
# verbuchen
And I save the current editor
And I close the current editor


# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "kgs-vk4" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "rls-vk4"
And I set field "nummer" to "4vk-gs"
And I set field "vom" to "."
# Felder abfragen
Then field "konto" has value "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "100" in row 1
Then field "fixkstelle" has value "ja" in row 1
# Tauschen
And I set field "kstelle" to "500" in row 1
Then field "fixkstelle" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Kontrolle -> was wirklich gespeichert wurde
Given I open an editor "kontrolle" from table "(Sales):(Invoice)" with command "VIEW" for record "+4vk-gs"
# Felder abfragen
Then field "kstelle" has value "500" in row 1
Then field "fixkstelle" has value "ja" in row 1
Then field "konto" has value "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
#
And I close the current editor
#####################################################################################################################################


Scenario: 5VK: AU-LS1-LS2-(RE aus LS1)-(RLS1 aus LS1)-(KGS aus RLS1)

Given I open an editor "auftrag-vk5" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "5vk-au"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "225" in row 1
And I set field "preis" to "13.13" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
#
# Tauschen
And I set field "konto" to "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
And I set field "kstelle" to "500" in row 1
Then field "fixkstelle" has value "ja" in row 1
And I set field "strgl" to "VKINFREI" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
And I save the current editor


# Auftrag beliefern
Given I open an editor "ls1-vk5" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-vk5"
And I set field "nummer" to "5vk-ls1"
And I press button "offueb" in row 1
And I set field "mge" to "105" in row 1
# Felder abfragen
Then field "ofmge" has value "120" in row 1
Then field "konto" has value "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "kstelle" has value "500" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Auftrag beliefern
Given I open an editor "ls2-vk5" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-vk5"
And I set field "nummer" to "5vk-ls2"
And I press button "offueb" in row 1
# Felder abfragen
Then field "ofmge" has value "0" in row 1
Then field "konto" has value "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "kstelle" has value "500" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Rechnung aus Lieferschein
Given I open an editor "rechnung1-vk5" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls1-vk5"
And I set field "nummer" to "5vk-re1"
And I set field "tterm" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "ofmge" has value "0" in row 1
Then field "konto" has value "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "kstelle" has value "500" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# Fixierung rausnehmen
And I set field "fixkonto" to "nein" in row 1
And I set field "fixstrgl" to "nein" in row 1
And I set field "fixkstelle" to "nein" in row 1
#
# Felder abfragen
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von 77 Stk
Given I open an editor "rls-vk5" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "ls1-vk5"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "5vk-rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "203" in row 1
And I set field "mge" to "-77" in row 1
# Felder abfragen
Then field "konto" has value "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "kstelle" has value "500" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# Tauschen
And I set field "kstelle" to "100" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# verbuchen
And I save the current editor
And I close the current editor


# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "kgs-vk5" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "rls-vk5"
And I set field "nummer" to "5vk-gs"
And I set field "vom" to "."
# Felder abfragen
Then field "kstelle" has value "101" in row 1
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "fixkstelle" has value "nein" in row 1
# Tauschen
And I set field "konto" to "44000c2" in row 1
Then field "fixkonto" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Kontrolle -> was wirklich gespeichert wurde
Given I open an editor "kontrolle" from table "(Sales):(Invoice)" with command "VIEW" for record "+5vk-gs"
# Felder abfragen
Then field "konto" has value "44000c2" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "kstelle" has value "101" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "fixkstelle" has value "nein" in row 1
#
And I close the current editor
#####################################################################################################################################


Scenario: 6VK: AU-LS1-LS2-(RE aus LS1)-(RLS1 aus LS1)-(KGS aus RLS1)-(Storno KGS1)

Given I open an editor "auftrag-vk6" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "6vk-au"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "500" in row 1
And I set field "preis" to "33.13" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
#
# Tauschen
And I set field "konto" to "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
And I set field "kstelle" to "500" in row 1
Then field "fixkstelle" has value "ja" in row 1
And I set field "strgl" to "VKINFREI" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "fixstrgl" has value "ja" in row 1
And I save the current editor


# Auftrag beliefern
Given I open an editor "ls1-vk6" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-vk6"
And I set field "nummer" to "6vk-ls1"
And I press button "offueb" in row 1
And I set field "mge" to "305" in row 1
# Felder abfragen
Then field "ofmge" has value "195" in row 1
Then field "konto" has value "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "kstelle" has value "500" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Auftrag beliefern
Given I open an editor "ls2-vk6" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-vk6"
And I set field "nummer" to "6vk-ls2"
And I press button "offueb" in row 1
# Felder abfragen
Then field "ofmge" has value "0" in row 1
Then field "konto" has value "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "kstelle" has value "500" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Rechnung aus Lieferschein
Given I open an editor "rechnung1-vk6" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls1-vk6"
And I set field "nummer" to "6vk-re1"
And I set field "tterm" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "ofmge" has value "0" in row 1
Then field "konto" has value "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "kstelle" has value "500" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# Fixierung rausnehmen
And I set field "fixkonto" to "nein" in row 1
And I set field "fixstrgl" to "nein" in row 1
# Tausch
And I set field "kstelle" to "100" in row 1
#
# Felder abfragen
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "100" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Ruecklieferung von 177 Stk
Given I open an editor "rls-vk6" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "ls1-vk6"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "6vk-rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "203" in row 1
And I set field "mge" to "-177" in row 1
# Felder abfragen
Then field "konto" has value "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "kstelle" has value "500" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# Tauschen
And I set field "kstelle" to "600" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# verbuchen
And I save the current editor
And I close the current editor


# Kaufm. GS 1 zu Ruecklieferschein
Given I open an editor "kgs-vk6" from table "(Sales):(PackingSlip)" with command "INVOICE" for record from editor "rls-vk6"
And I set field "nummer" to "6vk-gs"
And I set field "vom" to "."
# Felder abfragen
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "kstelle" has value "100" in row 1
Then field "fixkstelle" has value "ja" in row 1
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
#
# Tauschen
And I set field "konto" to "44000c2" in row 1
Then field "fixkonto" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Kontrolle -> was wirklich gespeichert wurde
Given I open an editor "kontrolle" from table "(Sales):(Invoice)" with command "VIEW" for record "+6vk-gs"
# Felder abfragen
Then field "konto" has value "44000c2" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "kstelle" has value "100" in row 1
Then field "fixkstelle" has value "ja" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
#
And I close the current editor


Given I open an editor "storno" from table "(Sales):(Invoice)" with command "REVERSAL" for record "+6vk-gs"
And I set field "nummer" to "6vk-stor"
Then field "partnervorgang" is not empty in row 0
Then field "mge" has value "177" in row 1
Then field "konto" has value "44000c2" in row 1
Then field "fixkonto" has value "ja" in row 1
Then field "kstelle" has value "100" in row 1
Then field "fixkstelle" has value "ja" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
And I save the current editor
And I close the current editor
#####################################################################################################################################


Scenario: 7VK: AU-LS-(RLS aus LS)-(RE aus LS)-(KGS aus RLS uber Beleg anfuegen)

Given I open an editor "auftrag-vk7" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "kunde" to "001"
And I set field "nummer" to "7vk-au"
When I create a new row at the end of the table
And I set field "artex" to "e3" in row 1
And I set field "mge" to "105" in row 1
And I set field "preis" to "13.40" in row 1
And I set field "platz" to "F3" in row 1
# Felder abfragen
Then field "vrgstrgl" has value "VKIN" in row 0
Then field "ktostrgl" has value "VKIN-81" in row 1
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
And I save the current editor


# Auftrag beliefern
Given I open an editor "ls-vk7" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set field "beleg" to id from editor "auftrag-vk7"
And I set field "nummer" to "7vk-ls"
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "101" in row 1
Then field "fixkstelle" has value "nein" in row 1
#
# Tauschen
And I set field "kstelle" to "100" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I save the current editor


# Ruecklieferung von 7 Stk
Given I open an editor "rls-vk7" from table "(Sales):(PackingSlip)" with command "RETURN" for record from editor "ls-vk7"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "nummer" to "7vk-rls"
And I set field "vom" to "."
And I set field "ueb" to "ja"
And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "203" in row 1
And I set field "mge" to "-7" in row 1
# Felder abfragen
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "100" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# Tauschen
And I set field "konto" to "44000c" in row 1
Then field "fixkonto" has value "ja" in row 1
#
# verbuchen
And I save the current editor
And I close the current editor


# Rechnung aus Lieferschein
Given I open an editor "rechnung-vk7" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to id from editor "ls-vk7"
And I set field "nummer" to "7vk-re"
And I set field "tterm" to "."
And I press button "offueb" in row 1
# Felder abfragen
Then field "konto" has value "44000" in row 1
Then field "fixkonto" has value "nein" in row 1
Then field "strgl" has value "VKINSTPF-1-81" in row 1
Then field "fixstrgl" has value "nein" in row 1
Then field "zstrgl" has value "VKINSTPF-1-81-1" in row 1
Then field "kstelle" has value "100" in row 1
Then field "fixkstelle" has value "ja" in row 1
#
# Tauschen
And I set field "konto" to "44000c2" in row 1
Then field "fixkonto" has value "ja" in row 1
And I set field "strgl" to "VKINFREI-0" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "fixstrgl" has value "ja" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
#
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor


# Kaufm. GS 1 zu Ruecklieferschein
# Given I open an editor "rechnung-vk7" from table "(Sales):(Invoice)" with command "NEW" for record ""
Given I open an editor "kgs-vk7" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to "nummer" from editor "rls-vk7"
And I set field "nummer" to "7vk-gs"
And I set field "vom" to "."
# Felder abfragen
Then field "fixkonto" has value "ja" in row 1
Then field "fixkstelle" has value "ja" in row 1
Then field "kstelle" has value "100" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "konto" has value "44000c2" in row 1
Then field "fixstrgl" has value "ja" in row 1
# verbuchen
And I set field "ueb" to "ja"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor
And I close the current editor


# Kontrolle -> was wirklich gespeichert wurde
Given I open an editor "kontrolle" from table "(Sales):(Invoice)" with command "VIEW" for record "+7vk-gs"
# Felder abfragen
Then field "fixkonto" has value "ja" in row 1
Then field "fixkstelle" has value "ja" in row 1
Then field "kstelle" has value "100" in row 1
Then field "strgl" has value "VKINFREI-0" in row 1
Then field "zstrgl" has value "VKINFREI-0-1" in row 1
Then field "konto" has value "44000c2" in row 1
Then field "fixstrgl" has value "ja" in row 1
#
And I close the current editor
#####################################################################################################################################


