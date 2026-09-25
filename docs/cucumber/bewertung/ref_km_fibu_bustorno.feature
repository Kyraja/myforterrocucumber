# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : wane, sih
# *****************************************************************************
@persistent
Feature: BW2-1473 Test von integrierten (Fibu)Buchungsstornos inkl. der Kostenumlagen welche diese Buchung 
                   als Kostenquelle nutzen (aus jira BW2-1473, 2021) 

# die projektkostenrechnung stört nicht beim test der funktionalität ohne projekte. 
# lässt man das projekt einfach weg, ist es std.funktionalität. deshalb kann das
# gleich mitgetestet werden.

Background:
Given I set the fake date to "10.02.2002"

# ---------------------------------------------------------------------------------------------
Scenario:
# ---------------------------------------------------------------------------------------------
Given I'm logged in with password "sy"
Given I set the fake date to "10.02.2002"

# bu 1
Given I open an editor "storno1-bu" from table "(Entry):(Entry)" with command "REVERSAL" for search criteria "$,,umgelegtinkm==+2km;@maxtreffer=1"
#  das ist auch +3km mit dabei!
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

# buchung 1 nicht nochmal stornierbar
Given opening an editor from table "(Entry):(Entry)" with command "REVERSAL" for record from editor "storno1-bu" throws the exception "10301"

# für die storno-umlagebuchung aus storno-km: 
# 10301 TX=de   |Bereits stornierte Buchungen koennen nicht storniert werden.
# bu 17 + 18
Given opening an editor from table "(Entry):(Entry)" with command "REVERSAL" for record "$,,ursache=Kostenumlage;stornovorlobjekt<>`;konto==54000;@maxtreffer=1" throws the exception "10301"
Given opening an editor from table "(Entry):(Entry)" with command "REVERSAL" for record "$,,ursache=Kostenumlage;stornovorlobjekt<>`;konto==58000;@maxtreffer=1" throws the exception "10301"
# und die storno-buchung selbst ist nicht stornierbar
# bu 16
Given opening an editor from table "(Entry):(Entry)" with command "REVERSAL" for record "$,,ursache=manuell;stornovorlobjekt<>`;konto==54000;@maxtreffer=1" throws the exception "10301"


Given I open an editor "storno2-bu" from table "(Entry):(Entry)" with command "REVERSAL" for search criteria "$,,umgelegtinkm==+1km;@maxtreffer=1"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
# die storno-buchung selbst ist nicht stornierbar
# bu 19
Given opening an editor from table "(Entry):(Entry)" with command "REVERSAL" for record "$,,ursache=manuell;stornovorlobjekt<>`;konto==50010;@maxtreffer=1" throws the exception "10301"

# bu 7
Given I open an editor "storno3-bu" from table "(Entry):(Entry)" with command "REVERSAL" for search criteria "$,,umgelegtinkm==+4km;@maxtreffer=1"
# Given I open an editor "storno3-bu" from table "(Entry):(Entry)" with command "REVERSAL" for search criteria "$,,nummer==7;@maxtreffer=1"
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

# bu 9
Given opening an editor from table "(Entry):(Entry)" with command "REVERSAL" for record "$,,umgelegtinkm==+5zeitr;@maxtreffer=1" throws the exception "50"
#  50 de   |Zeitraum ist schon abgeschlossen
And I close the current editor
# .. dann direkt
Given I open an editor "storno-5zeitr" from table "(CostDistribution):(CostDistribution)" with command "REVERSAL" for record "+5zeitr"
And I set field "num135" to "5zstorn"
And I save the current editor


#Given opening an editor from table "(Entry):(Entry)" with command "REVERSAL" for record "$,,umgelegtinkm==+8buentf;@maxtreffer=1" throws the exception "50"
#  50 de   |Zeitraum ist schon abgeschlossen
Given I open an editor "storno8-bu" from table "(Entry):(Entry)" with command "REVERSAL" for search criteria "$,,umgelegtinkm==+8buentf;@maxtreffer=1"
And saving the current editor throws the exception "8340"
And I close the current editor


# ------ nachbewerten ---------------
Given I open an editor "nachbewerten" for tip command "(Revalue)" and arguments ""
And I close the current editor
