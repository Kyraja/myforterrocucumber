@persistent
Feature: Storno EK
Background: Test von Stornos im Einkauf

# ========================================
@EK-Rechnung
Scenario: Kommando <(Purchasing)> RE <(new)>
Given I set the fake date to "11.01.2002"

Given I open an editor "rechnung" from table "(Purchasing):(Invoice)" with command "VIEW" for record "+37476re"
And I close the current editor

Given opening an editor from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "rechnung" throws the exception "3335"
And I close the current editor
