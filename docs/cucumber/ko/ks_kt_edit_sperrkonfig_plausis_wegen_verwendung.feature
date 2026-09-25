
# *****************************************************************************
#  Name           : ks_kt_edit_sperrkonfig_plausis_wegen_verwendung.feature
#  Autor          : sih
#  Verantwortlich : sih
#  Kontrolle      : uo
#  Funktion       : Test der Plausibilisierung von Kst/Ktr in Bezug auf Editierbarkeit der Felder
#                   der Sperrkonfiguration, wenn die Kst/der Ktr
#                   * in der Kostenrechnungskonfiguration vorkommt
#                   * in einer Warengruppe vorkommt
#                   * in einer Produktgruppe vorkommt
#
# *****************************************************************************
@persistent
Feature: BW2-1992 (Kostenstellen und Kostentraeger dürfen nicht gesperrt werden, wenn sie in der Kostenrechnungskonfiguration vorkommen)
Background:
Given I set the fake date to "30.03.1995"

Scenario: 01 Sperrverbot Restkostenstelle und Restkostentraeger in der Kostenrechnungskonfiguration
 
Given I open an editor "rest-kst" from table "(Account):(CostCenter)" with command "COPY" for record "100" 	
And I set field "nummer" to "122"
And I save the current editor

Given I open an editor "rest-ktr" from table "(Account):(CostObject)" with command "COPY" for record "100000" 	
And I set field "nummer" to "122222"
And I save the current editor

Given I open an editor "korekonfig" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "KOREKONF" 	
And I set field "strest" to "122"
And I set field "trrest" to "122222"
And I save the current editor

Given I open an editor "rest-kst-sperren-verboten" from table "(Account):(CostCenter)" with command "UPDATE" for record "122" 	
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then saving the current editor throws the exception "3277"
And I close the current editor

Given I open an editor "rest-kst-sperren-verboten" from table "(Account):(CostCenter)" with command "VIEW" for record "122" 	
Then field "sperrkonfigurationneu" has value ""
And I close the current editor
 
Given I open an editor "rest-ktr-sperren-verboten" from table "(Account):(CostObject)" with command "UPDATE" for record "122222" 	
And I set field "sperrkonfigurationneu" to "Standard-Kostenträgersperre"
Then saving the current editor throws the exception "3277"
And I close the current editor
 
Given I open an editor "rest-ktr-sperren-verboten" from table "(Account):(CostObject)" with command "VIEW" for record "122222" 	
Then field "sperrkonfigurationneu" has value ""
And I close the current editor

Scenario: 02 Sperrverbot Kostenstelle/Kostentraeger für Rundungsdifferenz aus der ILV in der Kostenrechnungskonfiguration

Given I open an editor "runddiff-kst" from table "(Account):(CostCenter)" with command "COPY" for record "100" 	
And I set field "nummer" to "123"
And I set field "such" to "runddiff-ks"
And I save the current editor

Given I open an editor "korekonfig" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "KOREKONF" 	
And I set field "ilvks" to "runddiff-ks"
And I save the current editor

Given I open an editor "diff-kst-sperren-verboten" from table "(Account):(CostCenter)" with command "UPDATE" for record "runddiff-ks" 	
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then saving the current editor throws the exception "3277"
And I close the current editor

Given I open an editor "diff-kst-sperren-verboten" from table "(Account):(CostCenter)" with command "VIEW" for record "runddiff-ks" 	
Then field "sperrkonfigurationneu" has value ""
And I close the current editor

Scenario: 03 Sperrverbot Kostenstelle/Kostentraeger bei Vorkommen in einer Warengruppe 

Given I open an editor "kst-fuer-wg" from table "(Account):(CostCenter)" with command "COPY" for record "100" 	
And I set field "nummer" to "124"
And I set field "such" to "wg-kst1"
And I save the current editor

Given I open an editor "wg-kst" from table "(Company):(MaterialGroup)" with command "COPY" for record "55" 	
And I set field "such" to "wg-kst1"
And I set field "wgkst" to "124"
And I save the current editor

Given I open an editor "ktr-fuer-wg" from table "(Account):(CostObject)" with command "COPY" for record "100000" 	
And I set field "nummer" to "100024"
And I set field "such" to "wg-ktr1"
And I save the current editor

Given I open an editor "wg-ktr" from table "(Company):(MaterialGroup)" with command "COPY" for record "55" 	
And I set field "such" to "wg-ktr1"
And I set field "wgkst" to "100024"
And I save the current editor

# # Sperrversuch Kst
Given I open an editor "diff-kst-sperren-wg-verboten" from table "(Account):(CostCenter)" with command "UPDATE" for record "wg-kst1" 	
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then saving the current editor throws the exception
""" 
Sperre nicht möglich, da das Objekt in einer Warengruppe verwendet wird. Es kommt in der Warengruppe 54 vor.
"""
And I close the current editor

Given I open an editor "diff-kst-sperren-wg-verboten" from table "(Account):(CostCenter)" with command "VIEW" for record "wg-kst1" 	
Then field "sperrkonfigurationneu" has value ""
And I close the current editor
 
# Sperrversuch Ktr
Given I open an editor "diff-ktr-sperren-wg-verboten" from table "(Account):(CostObject)" with command "UPDATE" for record "wg-ktr1" 	
And I set field "sperrkonfigurationneu" to "Standard-Kostenträgersperre"
Then saving the current editor throws the exception
""" 
Sperre nicht möglich, da das Objekt in einer Warengruppe verwendet wird. Es kommt in der Warengruppe 57 vor.
"""
And I close the current editor
 
Given I open an editor "diff-ktr-sperren-wg-verboten" from table "(Account):(CostObject)" with command "UPDATE" for record "wg-ktr1" 	
Then field "sperrkonfigurationneu" has value ""
And I close the current editor


# Scenario: 04 Sperrverbot Kostenstelle/Kostentraeger bei Vorkommen in einer Produktgruppe 
 
Given I open an editor "kst-fuer-pg" from table "(Account):(CostCenter)" with command "COPY" for record "100" 	
And I set field "nummer" to "125"
And I set field "such" to "pg-kst2"
And I save the current editor
 
Given I open an editor "pg-kst" from table "(Company):(ProductGroup)" with command "COPY" for record "66" 	
And I set field "such" to "pg-kst2"
And I set field "pgkst" to "125"
And I save the current editor
 
Given I open an editor "ktr-fuer-pg" from table "(Account):(CostObject)" with command "COPY" for record "100000" 	
And I set field "nummer" to "100025"
And I set field "such" to "pg-ktr2"
And I save the current editor
 
Given I open an editor "pg-ktr" from table "(Company):(ProductGroup)" with command "COPY" for record "66" 	
And I set field "such" to "pg-ktr2"
And I set field "pgkst" to "100025"
And I save the current editor

# Sperrversuch Kst
Given I open an editor "diff-kst-sperren-wg-verboten" from table "(Account):(CostCenter)" with command "UPDATE" for record "pg-kst2" 	
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
Then saving the current editor throws the exception
""" 
Sperre nicht möglich, da das Objekt in einer Produktgruppe verwendet wird. Es kommt in der Produktgruppe 58 vor.
"""
And I close the current editor
 
Given I open an editor "diff-kst-sperren-wg-verboten" from table "(Account):(CostCenter)" with command "VIEW" for record "pg-kst2" 	
Then field "sperrkonfigurationneu" has value ""
And I close the current editor
 
# Sperrversuch Ktr
Given I open an editor "diff-ktr-sperren-wg-verboten" from table "(Account):(CostObject)" with command "UPDATE" for record "pg-ktr2" 	
And I set field "sperrkonfigurationneu" to "Standard-Kostenträgersperre"
Then saving the current editor throws the exception
""" 
Sperre nicht möglich, da das Objekt in einer Produktgruppe verwendet wird. Es kommt in der Produktgruppe 59 vor.
"""
And I close the current editor
 
Given I open an editor "diff-ktr-sperren-wg-verboten" from table "(Account):(CostObject)" with command "UPDATE" for record "pg-ktr2" 	
Then field "sperrkonfigurationneu" has value ""
And I close the current editor

# Scenario: 05 Neuanlage Kostenstelle und gleich Sperrkonfiguration erfassen und Speichern in der Konstellation, dass in der Kostenrechnungskonfiguration
#              entweder die Rest-Kst, der -Ktr oder das Objekt Kostenstelle/Kostenträger für Rundungsdifferenz aus der ILV fehlt

Given I open an editor "korekonf" from table "(CostType):(CostAccountingConfig)" with command "UPDATE" for record "korekonf"
And I set field "ilvks" to ""
And I save the current editor

Given I open an editor "ks-mit-sperre" from table "(Account):(CostCenter)" with command "NEW" for record ""
And I set field "such" to "neu-mit-sperre"
And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
And I save the current editor



