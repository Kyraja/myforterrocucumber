# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : wane, sih
# *****************************************************************************
@persistent
Feature: BW2-1473  stornotests für kostenumlagen auf buchungszeilen 

# die projektkostenrechnung stört nicht beim test der funktionalität ohne projekte. 
# lässt man das projekt einfach weg, ist es std.funktionalität. deshalb kann das
# gleich mitgetestet werden.

Background:
Given I set the fake date to "10.02.2002"

# ---------------------------------------------------------------------------------------------
Scenario: stornos aus km
# ---------------------------------------------------------------------------------------------
Given I'm logged in with password "sy"
Given I set the fake date to "10.02.2002"

Given I open an editor "storno-2km" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+2km"
And I set field "num135" to "2kmstorn"
# And I wait for file cucudbg for debugging
And I save the current editor

Given I open an editor "storno-3km" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+3km"
And I set field "num135" to "3kmstorn"
And I save the current editor

# reihenfolge der manuellen stornos übereinstimmend mit der reihenfolge die bei den buchungsstornos im schwestertest
# /abas-ERP/std/test/ref_km_fibu_kmstorno.ref entsteht. dort ist sie innerhalb eines buchungsstornos nicht von aussen
# beeinflussbar. deshalb vorgabe von dort. man testet weniger fälle aber die daten add.kosten in der bew.kette verlaufen so
# identisch (müssten identisch verlaufen).
Given I open an editor "storno-1km" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+1km"
And I set field "num135" to "1kmstorn"
And I save the current editor

Given I open an editor "storno-4km" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+4km"
And I set field "num135" to "4kmstorn"
And I save the current editor

Given I open an editor "storno-5zeitr" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+5zeitr"
And I set field "num135" to "5zstorn"
And I save the current editor

# nicht stornierbar, weil fibu-quelle im vorgängertest manipulativ entfernt wurde. das soll auch so bleiben.
Given I open an editor "storno-8buentf" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+8buentf"
And I set field "num135" to "8buesto"
And saving the current editor throws the exception "8340"
And I close the current editor

# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
