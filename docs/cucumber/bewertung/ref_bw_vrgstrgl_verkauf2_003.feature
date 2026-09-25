# *****************************************************************************************************
#  Name             : ref_bw_vrgstrgl_verkauf2_003.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        : 
#  Funktion         : Manipulation der Daten
#                     Hier werden VRGSTRGL aus den VK-Rechnungen und einpaar VK-Lieferscheinen enfernt. 
#                     So werden Daten vor dem Upgrade auf 2016r1n00 (steuerliche Konfiguration) simuliert.
#
#
# *****************************************************************************************************
@persistent
Feature: Manipulation
Background:  VK-Rechnungen preparieren
Given I set the fake date to "09.03.2000"



@FALL-VKRE-PREPARIEREN
Scenario Outline: VK-Rechnungen praeparieren

Given I'm logged in with password "annette"
Given I enable the flag 71
Given I open an editor "re<nummer1>" from table "(Sales):(Invoice)" with command "MODIFY" for record "<nummer1>"
And I set field "vrgstrgl" to ""
And I set field "strgl" to "" in row <zn>
And I save the current editor
Given I disable the flag 71
Given I'm logged in with password "sy"

Examples:
| nummer1 |zn|
|+0001rep | 1|
|+0001rep | 2|
|+0001rep | 4|
|+0002rep | 1|
|+0002rep | 3|
|+0003rep | 1|
|+0003rep | 2|
|+0003rep | 4|
|+0004rep | 1|
|+0004rep | 3|
|+0005rep | 1|
|+0005rep | 2|
|+0006rep | 1|
|+0007rep | 1|
|+0007rep | 2|
|+0009rep | 1|
|+0009rep | 3|
|+0010rep | 1|
|+0010rep | 2|
|+0010rep | 4|
|+0011rep | 1|
|+0012rep | 1|
|+0012rep | 2|
|+0002norm| 1|
|+0002norm| 3|
|+0004norm| 1|
|+0004norm| 3|
|+0006norm| 1|
|+0013norm| 1|
|+0013norm| 2|
|+0013norm| 4|
|+0014norm| 1|
|+0014norm| 2|
|+0015norm| 1|
|+0015norm| 2|
|+0015norm| 4|
|+0017norm| 1|
|+0017norm| 2|
|+0017norm| 4|
|+0018norm| 1|
|+0018norm| 2|
|+0019norm| 1|
|+0008n1  | 1|
|+0008n2  | 1|
|+0014n2  | 1|
|+0014n2  | 3|
|+0020n1  | 1|
|+0020n1  | 3|
|+0020n2  | 1|
|+0020n2  | 3|
#####################################################################################################################################

@FALL-VKLS-PREPARIEREN
Scenario Outline: VK-Lieferscheine praeparieren

Given I'm logged in with password "annette"
Given I enable the flag 71
Given I open an editor "ls<nummer1>" from table "(Sales):(PackingSlip)" with command "MODIFY" for record "<nummer1>"
And I set field "vrgstrgl" to ""
And I save the current editor
Given I disable the flag 71
Given I'm logged in with password "sy"

Examples:
| nummer1 |
|+0002ls  |
| 0003ls  |
|+0004ls  |
|+0006ls  |
| 0007ls  |
#####################################################################################################################################
