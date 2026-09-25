# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : 
# *****************************************************************************
@persistent
Feature: BW2-1779 Storno Kostenumlage/Kostenumlagerückführung plausibilisieren  

Background:
Given I set the fake date to "23.01.1995"

# ------------------------------------------------------------------------
Scenario: KM-Stornos müssen verboten sein
# ------------------------------------------------------------------------

Given I set the fake date to "23.01.1995"

Given I open an editor "kostenumlsto1" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for search criteria "$,,nummer==1KM038;@gruppe=1;gruppe==1;@ablageart=abgelegt"
And I close the current editor

# E|2|Storno nicht möglich, da mindestens eine aktive Kostenumlagerückführungsposition existiert.|ERROR|2647
Given opening an editor from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record from editor "kostenumlsto1" throws the exception "2647"


Given I open an editor "kostenumlsto2" from table "(CostDistribution):(CostDistribution)" with command "VIEW" for search criteria "$,,nummer==1KM039;@gruppe=1;gruppe==1;@ablageart=abgelegt"
And I close the current editor

# E|2|Storno nicht möglich, da mindestens eine aktive Kostenumlagerückführungsposition existiert.|ERROR|2647
Given opening an editor from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record from editor "kostenumlsto2" throws the exception "2647"


Given I open an editor "kostenumlruecksto1" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+1KM038R"
And I set field "num135" to "987dummy"
# E|2|Storno, Rückbuchung, stornierter Vorgang oder ganze Menge rückgebucht - Vorgang nicht erlaubt.|ERROR|1426
And saving the current editor throws the exception "1426"
And I close the current editor

Given I open an editor "kostenumlruecksto2" from table "(CostDistribution):(CostDistributionReturn)" with command "REVERSAL" for record "+1KM039R"
And I set field "num135" to "803dummy" 
# E|2|Storno, Rückbuchung, stornierter Vorgang oder ganze Menge rückgebucht - Vorgang nicht erlaubt.|ERROR|1426
And saving the current editor throws the exception "1426"
And I close the current editor

# ------------------------------------------------------------------------
Scenario: Kostenrückführung für noch vorhandene EK-Restmenge
# ------------------------------------------------------------------------
Given I set the fake date to "23.01.1995"


# zuerst plausi restrücklieferung
Given I open an editor "ruecklief-1" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE038"
Then field "typa" has value "Lieferschein"
Then field "lsart" has value "Rücklieferschein"
And I set field "num4" to "1RE038R2"
And I set field "vom" to "."
And I set field "ueb" to "ja"
# And I set field "rueckligrund" to "Transportschaden"
Then field "artikel" has value "E3" in row 1
And I set field "mge" to "-38" in row 1

# E|2|In der Bewertung der zugehörigen Originalliefermenge gibt es noch additive Kosten. 
# Siehe Bewertung: 34.\nStornieren Sie zuerst die ursächliche(n) Kostenumlage(n) oder
# führen Sie diese zurück.|ERROR|2888||
And saving the current editor throws the exception "2888"
And I close the current editor


Given I open an editor "kostenumlrueck" from table "(CostDistribution):(CostDistributionReturn)" with command "NEW" for record ""
And I set field "num135" to "1KMRF38B"
And I set field "name" to "KMRF"
And I set field "origvorg" to "+1KM038"
And I set field "such" to "KMRF38B"
And I save the current editor

# das tut nicht in Cucu # Rücklieferung noch nicht möglich, wegen o.g. Fehler
# das tut nicht in Cucu Given I open an editor "ruecklief-1" from table "(Purchasing):(Invoice)" with command "RETURN" for record "+1RE038"
# das tut nicht in Cucu Then field "typa" has value "Lieferschein"
# das tut nicht in Cucu Then field "lsart" has value "Rücklieferschein"
# das tut nicht in Cucu And I set field "num4" to "1RE038R2"
# das tut nicht in Cucu And I set field "vom" to "."
# das tut nicht in Cucu And I set field "ueb" to "ja"
# das tut nicht in Cucu # And I set field "rueckligrund" to "Transportschaden"
# das tut nicht in Cucu Then field "artikel" has value "E3" in row 1
# das tut nicht in Cucu Then field "artikel" has value "TEXT" in row 2
# das tut nicht in Cucu And I set field "mge" to "-38" in row 1
# das tut nicht in Cucu # And I respond with answer "Ja" to the dialog with id "1482"
# das tut nicht in Cucu And I delete row at position 2
# das tut nicht in Cucu And I save the current editor

