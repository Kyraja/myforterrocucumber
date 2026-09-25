@persistent
Feature: attendance.feature

# *****************************************************************************
#  Name             : attendance
#  Autor            : tiwe
#  Verantwortlich   : teaminfosysteme
#  Kontrolle        : cl
#  Funktion         : Testet das Infosystem ATTENDANCE. An- und abstempeln von Personalzeiten und Dienstgaengen.
#
# *****************************************************************************

# letzter Test: 20191206 Status: fehlerfrei durch
# insgeamt werden 4 Personalzeiten erzeugt
#    1. normale Personalzeit 
#    2. normale Personalzeit
#    3. Dienstgang
#    4. normale Personalzeit 
Background:
Given I set the fake date to "12.01.1995" 
Scenario: 1 Mitarbeiter stempelt sich ein
# Debug: 1 neue Personalzeit PZ1_ANMELDUNG      
################################################################################
#01 pruefen, ob es für Mitarbeiter KAEPSELE eine offene Personalzeit gibt, dass sollte nicht der Fall sein
Given I open the infosystem "LAZEIT"
And I set field "anwesend" to "ja"
And I set field "nummitarb" to "KAEPS"
And I press start
Then the table has 0 rows
And I close the current editor
#02 Anstempeln über Infosystem ATTENDANCE
Given I open the infosystem "ATTENDANCE"
And I set field "mitarb" to "KAEPS"
Then field "kommt" has value "icon:plus"
And I press button "kommt" 
Then field "bdestatus" has value "icon:ball_green"
And I close the current editor
#03 prüfen der angestempelten Personalzeit
Given I open an editor "PZ1_ANMELDUNG" from table "(PDC):(TimeAndLaborData)" with command "UPDATE" for search criteria "$,,ma=KAEPS;endzeit=`;@richtung=(Backwards);@sort=offen;@maxtreffer=1"
Then field "ma^such" has value "KAEPSELE"
Then field "anfzeit" is not empty
And I save the current editor
################################################################################
Scenario: 2 Mitarbeiter stempelt sich ab
# Debug: 1 Personalzeit PZ1_ABMELDUNG      
################################################################################
#1 Abstempeln über Infosystem ATTENDANCE
Given I open the infosystem "ATTENDANCE"
And I set field "mitarb" to "KAEPS"
Then field "geht" has value "icon:plus"
And I press button "geht" 
Then field "bdestatus" has value "icon:ball_green"
And I close the current editor
#2 prüfen der abgestempelten Personalzeit
Given I open an editor "PZ1_ABMELDUNG" from table "(PDC):(TimeAndLaborData)" with command "UPDATE" for search criteria "$,,ma=KAEPS;endzeit<>`;@richtung=(Backwards);@maxtreffer=1"
Then field "ma^such" has value "KAEPSELE"
Then field "endzeit" is not empty
Then field "istzeit" is not empty
And I save the current editor
And I close the current editor
################################################################################
Scenario: 3 Mitarbeiter stempelt einen Dienstgang an
# Debug: 2 Personalzeiten PZ2_ABMELDUNG , PZ3_DIENSTGANG   
################################################################################
#1 Anstempeln über Infosystem ATTENDANCE
Given I open the infosystem "ATTENDANCE"
And I set field "mitarb" to "KAEPS"
Then field "kommt" has value "icon:plus"
And I press button "kommt" 
Then field "bdestatus" has value "icon:ball_green"
And I close the current editor
#2 Anstempeln des Dienstgangs über Infosystem ATTENDANCE
Given I open the infosystem "ATTENDANCE"
And I set field "mitarb" to "KAEPS"
Then field "dienstgang" has value "icon:internet"
And I press button "dienstgang"
Then field "bdestatus" has value "icon:ball_green"
And I close the current editor
#3 Prüfen der erzeugten Personalzeiten
Given I open an editor "PZ2_ABMELDUNG" from table "(PDC):(TimeAndLaborData)" with command "UPDATE" for search criteria "$,,ma=KAEPS;endzeit<>`;@richtung=(Backwards);@maxtreffer=1"
Then field "ma^such" has value "KAEPSELE"
Then field "endzeit" is not empty
Then field "istzeit" is not empty
And I save the current editor 
And I close the current editor
Given I open an editor "PZ3_DIENSTGANG" from table "(PDC):(TimeAndLaborData)" with command "UPDATE" for search criteria "$,,ma=KAEPS;endzeit=`;dienstgang=ja;@sort=offen;@richtung=(Backwards);@maxtreffer=1"
Then field "ma^such" has value "KAEPSELE"
Then field "endzeit" is empty
Then field "dienstgang" has value "ja"
And I save the current editor 
And I close the current editor
################################################################################
Scenario: 4 Mitarbeiter stempelt einen Dienstgang ab
# Debug: 2 Personalzeiten PZ4_DIENSTGANG PZ5_ANMELDUNG PZ5_ABMELDUNG
#1 Anstempeln eines Dienstgangs über IS ATTENDANCE
Given I open the infosystem "ATTENDANCE"
And I set field "mitarb" to "KAEPS"
Then field "dienstgang" has value "icon:house"
And I press button "dienstgang"
Then field "bdestatus" has value "icon:ball_green"
And I close the current editor
#2 Prüfen der erzeugten Personalzeiten
Given I open an editor "PZ4_DIENSTGANG" from table "(PDC):(TimeAndLaborData)" with command "UPDATE" for search criteria "$,,ma=KAEPS;endzeit<>`;dienstgang=ja;@richtung=(Backwards);@maxtreffer=1"
Then field "ma^such" has value "KAEPSELE"
Then field "dienstgang" has value "ja"
Then field "endzeit" is not empty
Then field "istzeit" is not empty
And I save the current editor 
And I close the current editor
Given I open an editor "PZ5_ANMELDUNG" from table "(PDC):(TimeAndLaborData)" with command "UPDATE" for search criteria "$,,ma=KAEPS;endzeit=`;@sort=offen;@richtung=(Backwards);@maxtreffer=1"
Then field "ma^such" has value "KAEPSELE"
Then field "endzeit" is empty
And I save the current editor 
And I close the current editor
#3 Abstempeln der offen Personalzeit über IS ATTENDANCE
Given I open the infosystem "ATTENDANCE"
And I set field "mitarb" to "KAEPS"
Then field "geht" has value "icon:plus"
And I press button "geht"
Then field "bdestatus" has value "icon:ball_green"
And I close the current editor
#4 Prüfen der erzeugten Personalzeiten
Given I open an editor "PZ5_ABMELDUNG" from table "(PDC):(TimeAndLaborData)" with command "UPDATE" for search criteria "$,,ma=KAEPS;endzeit<>`;@richtung=(Backwards);@maxtreffer=1"
Then field "ma^such" has value "KAEPSELE"
Then field "endzeit" is not empty
Then field "istzeit" is not empty
And I save the current editor 
And I close the current editor

