# *****************************************************************************
#  Autor            : uo
#  Verantwortlich   : uo
#  Kontrolle        : 
#  Funktion         : 
# *****************************************************************************
@persistent
Feature: ref_storno_rueck_negative_originalmengen_in_ev.feature 
Background:
Given I set the fake date to "15.07.02"

Scenario: 01 Alte Vorgänge mit negativen Originalmengen, müssen nach Upgrade auf >=2019 für Storno/Rücklieferungen blockiert sein

# alter EK-LS mit neg. menge
# ist der Datensatz grundsätzlich vorhanden?
Given I open an editor "rls-ekview" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "79234"
And I close the current editor

# diese meldung ist schon perfekt.
# cc   2620 de   |Objekt kann nicht geladen werden
Then opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "79234" throws the exception "2620"
# cc   4064 de   |Stornierung des Vorgangs aufgrund negativer Mengen nicht möglich.
Then opening an editor from table "(Purchasing):(PackingSlip)" with command "REVERSAL" for record "79234" throws the exception "4064"

Then opening an editor from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "79234" throws the exception "2620"

# nach verbesserung von BW2-1230, müßte das hier ZUSÄTZLICH MIT anderer exception zucken!
# BW2-1231 wird nach entscheidung durch PO th.gaiser nicht gelöst #Then opening an editor from table "(Purchasing):(PackingSlip)" with command "RETURN" for record "79234" throws the exception "4064"



# alter VK-LS mit neg. menge
# ist der Datensatz grundsätzlich vorhanden?
Given I open an editor "rls-vkview" from table "(Sales):(PackingSlip)" with command "VIEW" for record "9845"
And I close the current editor

# diese meldung ist schon perfekt.
# cc   2620 de   |Objekt kann nicht geladen werden
Then opening an editor from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "9845" throws the exception "2620"
# cc   4064 de   |Stornierung des Vorgangs aufgrund negativer Mengen nicht möglich.
Then opening an editor from table "(Sales):(PackingSlip)" with command "REVERSAL" for record "9845" throws the exception "4064"
 
Then opening an editor from table "(Sales):(PackingSlip)" with command "RETURN" for record "9845" throws the exception "2620"
# nach lösung von BW2-1231, müßte das hier ZUSÄTZLICH MIT anderer exception zucken!
# BW2-1231 wird nach entscheidung durch PO th.gaiser nicht gelöst #Then opening an editor from table "(Sales):(PackingSlip)" with command "RETURN" for record "9845" throws the exception "4064"
