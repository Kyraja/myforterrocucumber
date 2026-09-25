#***************************************************************************
#
#  Name           : ekvk_stornopartner.feature
#  Datum          : 31.05.24
#  Autor          : lclaus
#  Verantwortlich : teampss
#
#  Funktion  : Test zum Referenztest ref_ekvk_stornopartner_cu.
#
#***************************************************************************
#
@persistent
Feature: EKVK Stornopartner
Background:
Given I set the fake date to "02.01.1995"
#
#---------------------------------------------------------------------------
# V E R K A U F
#---------------------------------------------------------------------------
#
#---------------------------------------------------------------------------
Scenario: VK Rechnung anlegen, buchen, stronieren
#---------------------------------------------------------------------------

Given I open an editor "SPVKRE01" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| kunde | 1        |
	| such  | SPVKRE01 |
	| ueb   | ja       |
	| vom   | .        |
	| tterm | .        |
And I append rows
	| artikel | mge |
	| V1      | 1   |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# VK Rechnung stornieren
Given I open an editor "SPVKRE01S" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "SPVKRE01"
And I save the current editor

#---------------------------------------------------------------------------
Scenario: VK Barrechnung anlegen, buchen, stornieren
#---------------------------------------------------------------------------
Given I open an editor "SPVKRE02" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set fields
	| kunde    | 1          |
	| vorganga | Barzahlung |
	| such     | SPVKRE02   |
	| ueb      | ja         |
	| vom      | .          |
	| tterm    | .          |
And I append rows
	| artikel | mge |
	| V1      | 1   |
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor

# VK Barrechnung stornieren
Given I open an editor "SPVKRE02S" from table "(Sales):(Invoice)" with command "REVERSAL" for record from editor "SPVKRE02"
And I save the current editor

#---------------------------------------------------------------------------
Scenario: VK Lieferschein anlegen, buchen, berechnen, stornieren
#---------------------------------------------------------------------------
Given I open an editor "SPVKLS01" from table "(Sales):(PackingSlip)" with command "NEW" for record ""
And I set fields
	| kunde  | 1        |
	| such   | SPVKLS01 |
	| nummer | 400005   |
	| vom    | .        |
And I append rows
	| artikel | mge |
	| v3      | 1   |
And I set field "ueb" to "ja"
And I save the current editor

# VK Lieferschein stornieren
Given I open an editor "SPVKLS01S" from table "(Sales):(PackingSlip)" with command "REVERSAL" for record from editor "SPVKLS01"
And I set field "nummer" to "400006"
And I save the current editor

#
#---------------------------------------------------------------------------
# E I N K A U F
#---------------------------------------------------------------------------
#
#
#---------------------------------------------------------------------------
Scenario: EK Rechnung anlegen, buchen, stornieren
#---------------------------------------------------------------------------
Given I open an editor "SPEKRE01" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
	| lief  | 1        |
	| such  | SPEKRE01 |
	| ueb   | ja       |
	| vom   | .        |
	| tterm | .        |
And I append rows
	| artikel | mge |
	| V1      | 1   |
And I save the current editor

# EK Rechnung stornieren
Given I open an editor "SPEKRE01S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "SPEKRE01"
And I save the current editor

#---------------------------------------------------------------------------
Scenario: EK Barrechnung anlegen, buchen, stornieren
#---------------------------------------------------------------------------
Given I open an editor "SPEKRE02" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set fields
	| lief     | 1          |
	| vorganga | Barzahlung |
	| such     | SPEKRE02   |
	| ueb      | ja         |
	| vom      | .          |
	| tterm    | .          |
And I append rows
	| artikel | mge |
	| V1      | 1   |
And I save the current editor

# VK Barrechnung stornieren
Given I open an editor "SPEKRE02S" from table "(Purchasing):(Invoice)" with command "REVERSAL" for record from editor "SPEKRE02"
And I save the current editor

#---------------------------------------------------------------------------
# EK Lieferschein anlegen, buchen, berechnen, stornieren
#---------------------------------------------------------------------------
Given I open an editor "SPEKLS01" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
	| lief   | 1        |
	| nummer | 4R0005   |
	| such   | SPEKLS01 |
	| vom    | .        |
And I append rows
	| artikel | mge |
	| v3      | 1   |
And I set field "ueb" to "ja"
And I save the current editor
#
# EK Lieferschein stornieren
Given I open an editor "SPEKLS01S" from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record from editor "SPEKLS01"
And I set field "nummer" to "4R0006"
And I save the current editor
