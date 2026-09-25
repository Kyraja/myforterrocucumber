# *****************************************************************************
#  Autor            : uo
#  Verantwortlich   : uo
#  Kontrolle        : 
#  Funktion         : 
# *****************************************************************************
@persistent
Feature: auführbare minusmengen prozesse auf alten original minusmengen ref_storno_rueck_negative_originalmengen_in_lagerbuch_ausfuehrb.feature 
Background:
Given I set the fake date to "15.07.02"

# carue 23.03.22: Auch fuer diesen Fall werden im Upgrade auf erp21 keine Belege erzeugt.
# Storno dieser Faelle ist daher nicht mehr moeglich

Scenario: 01 Alte Lagerbuchungen mit negativen Originalmengen, 
    können nach dem Upgrade storniert werden, wenn die detursache 
    mit einer entsprechenden manuellen ursache gefüllt ist.
    alte manuelle umbuchungen allerdings nicht, die sind in plausis gelandet 

# Lagerjournal oeffnen, um Zugriff auf Id des Belegs zu haben, im Feld Vorgang
Given I open an editor "Journal1" from table "(Journal):(Journal)" with command "VIEW" for record "LNEG-ZU-MDET"
Then field "vorgang" is empty
And I close the current editor

# Lagerjournal oeffnen, um Zugriff auf Id des Belegs zu haben, im Feld Vorgang
Given I open an editor "Journal2" from table "(Journal):(Journal)" with command "VIEW" for record "LNEG-AB-MDET"
Then field "vorgang" is empty
And I close the current editor
