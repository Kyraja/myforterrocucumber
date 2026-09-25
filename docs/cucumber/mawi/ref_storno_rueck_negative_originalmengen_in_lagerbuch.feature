# ***************************************************************************** 
#  Autor            : uo 
#  Verantwortlich   : uo 
#  Kontrolle        :  
#  Funktion         :  
# ***************************************************************************** 
@persistent 
Feature: ref_storno_rueck_negative_originalmengen_in_lagerbuch.feature Storno Lagerbuchung  
Background: 
Given I set the fake date to "15.07.02" 

# carue 22.03.22: Belege ohne detursache und fuer einzeilige Umlagerungen legen wir im Upgrade fuer erp21 nicht an
# da diese nicht storniert werden koennen
 
Scenario: 01 Plausi Alte Lagervorgänge mit negativen oder pos. Originalmengen,  
   können nach dem Upgrade nicht storniert werden, wenn die detursache leer ist.  
 
# Lagerjournal oeffnen, um Zugriff auf Id des Belegs zu haben, im Feld Vorgang 
Given I open an editor "Journal1" from table "(Journal):(Journal)" with command "VIEW" for record "LNEG-ZU-ODET"
Then field "vorgang" is empty
And I close the current editor 

Given I open an editor "Journal2" from table "(Journal):(Journal)" with command "VIEW" for record "LNEG-AB-ODET" 
Then field "vorgang" is empty
And I close the current editor 
 
Given I open an editor "Journal3" from table "(Journal):(Journal)" with command "VIEW" for record "LNEG-UM-ODET"
Then field "vorgang" is empty
And I close the current editor 


Scenario: 02 Fake Plausi Alte Umbuchung mit negativen Originalmengen,  
   aber mit hineingeschmuggelter detursache, kann fast storniert werden... 
   weitere erfassung (+zeile) nicht probiert..  
 
 
# Lagerjournal oeffnen, um Zugriff auf Id des Belegs zu haben, im Feld Vorgang 
Given I open an editor "Journal" from table "(Journal):(Journal)" with command "VIEW" for record "LNEG-UM-MDET"
Then field "vorgang" is empty
And I close the current editor 
 
 
Scenario: 03 Alte Lagervorgänge mit POSITIVEN Originalmengen aus version 2016, 
             können nach dem Upgrade auch nicht storniert werden, weil detursache  
             leer ist. 
 
# Lagerjournal oeffnen, um Zugriff auf Id des Belegs zu haben, im Feld Vorgang 
Given I open an editor "Journal" from table "(Journal):(Journal)" with command "VIEW" for search criteria "$,,artikel==E1A-VF;mge==1;buarta==Zugang" 
Then field "vorgang" is empty
And I close the current editor 
