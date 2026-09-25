@persistent
Feature: Produktgruppenaenderung
Background: Std-Produktgruppe aendern
Given I set the fake date to "08.01.2002"

# ----------------------
@Produktgruppe
Scenario: Alle Teile erhalten produktgruppen

Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "E1"
And I set field "erlgrp" to "66"
And I save the current editor
And I close the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "E2"
And I set field "erlgrp" to "66"
And I save the current editor
And I close the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "E3"
And I set field "erlgrp" to "66"
And I save the current editor
And I close the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "BEHAELTER"
And I set field "erlgrp" to "66"
And I save the current editor
And I close the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "PALETTE"
And I set field "erlgrp" to "66"
And I save the current editor
And I close the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "EINK"
And I set field "erlgrp" to "66"
And I save the current editor
And I close the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "BG1"
And I set field "erlgrp" to "66"
And I save the current editor
And I close the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "V1"
And I set field "erlgrp" to "66"
And I save the current editor
And I close the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "V2"
And I set field "erlgrp" to "66"
And I save the current editor
And I close the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "V3"
And I set field "erlgrp" to "66"
And I save the current editor
And I close the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "TEST"
And I set field "erlgrp" to "66"
And I save the current editor
And I close the current editor

Given I open an editor "teil" from table "(Part):(Product)" with command "UPDATE" for record "BAUT"
And I set field "erlgrp" to "66"
And I save the current editor
And I close the current editor


# BG1;
# V1;
# V2;
# V3;
# TEST;
# BAUT;
# 



# E2;
# E3;
# BEHAELTER;
# PALETTE;
# EINK;

