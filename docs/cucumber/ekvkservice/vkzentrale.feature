# *****************************************************************************
#  Name           : vkzentrale.feature
#  Autor          : cl
#  Verantwortlich : cl
#  Kontrolle      : teampss
#  Funktion       : Cucumber Tests fuer VKZENTRALE zur Kundenanlieferungen
#
#
# *****************************************************************************

@persistent
Feature: VKZENTRALE: Kundenalieferung
Background:
Given I set the fake date to "02.01.1995"
Given I set saved value "REF_FILE" to "VK.VKZENTRALE.CU.REF"
Given I set saved value "Feldliste1" to "tlsart,ttrans,tkuli,treku"

@Infosystem_VKZENTRALE
Scenario:  Infosystem starten VKZENTRALE, ablageart = beides, erst Start, dann aufklappen
Given I open the infosystem "VKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "vktyp" to "Auftrag"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
And I press button "exp"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"

Scenario:  Infosystem starten VKZENTRALE, ablageart = beides
Given I open the infosystem "VKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "vktyp" to "Lieferschein"
And I set field "lsart" to ""
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"

Scenario:  Infosystem starten VKZENTRALE, ablageart = beides, Kundenanlieferung
Given I open the infosystem "VKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "vktyp" to "Lieferschein"
And I set field "lsart" to "Kundenanlieferung"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"

Scenario:  Infosystem starten VKZENTRALE, ablageart = beides, Storno-Kundenanlieferung
Given I open the infosystem "VKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "vktyp" to "Lieferschein"
And I set field "lsart" to "Storno-Kundenanlieferung"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"

Scenario:  Infosystem starten VKZENTRALE, ablageart = beides, Stornierte Kundenanlieferung
Given I open the infosystem "VKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "vktyp" to "Lieferschein"
And I set field "lsart" to "Stornierte Kundenanlieferung"
And I press button "bstart"
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste1" from table content to output file "$REF_FILE"
