# *****************************************************************************
#  Name           : infoupd_create_infosys.feature
#  Autor          : fwester
#  Verantwortlich : fwester
#  Funktion       : Legt Stammdatensatz 65:1 mit angepassten Rahmenfeldern an.
# *****************************************************************************
@persistent
@OLD_INFOSYS_RECORD
Feature: CRUD 65:1

Scenario: Create an infosystem
Given I'm logged in with password "annette"
And I enable the flag 71
And I enable the flag 364
Given I open an editor "Infosystem neu" from table "(Infosystem):(Infosystem)" with command "NEW" for record ""
And I set field "such" to "BUG201707757"
And I set field "arb" to "ow1"
And I set field "maskorigin" to "Automatisch erzeugen"
And I set field "layoutorigin" to "Keine Ausgabe"
And I modify table
 | !row                 | inmask | inprint | indaten | extbezs   | maxlength | vms         | param       | buttonvor   | buttonnach  | feldfuell   | feldpruef   | feldaus     |
 | vname=='iearb'       | 1      | 1       | 1       | presetted | 1         | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange |
 | vname=='ierangarb'   | 1      | 1       | 1       | presetted | 1         | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange |
 | vname=='iedatname'   | 1      | 1       | 1       | presetted | 1         | (Editable)    | Eingabe     | !dontChange | !dontChange | BUG.FF      | BUG.FV    | BUG.FE        |
 | vname=='iedn'        | 1      | 1       | 1       | presetted | 1         | (Editable)    | Eingabe     | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange |
 | vname=='iedatnr'     | 1      | 1       | 1       | presetted | 1         | (Editable)    | Eingabe     | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange |
 | vname=='iegrp'       | 1      | 1       | 1       | presetted | 1         | (Editable)    | Eingabe     | !dontChange | !dontChange | BUG.FF      | BUG.FV    | BUG.FE        |
 | vname=='iegrliste'   | 1      | 1       | 1       | presetted | 1         | (Editable)    | Eingabe     | !dontChange | !dontChange | BUG.FF      | BUG.FV    | BUG.FE        |
 | vname=='iegrtxt'     | 1      | 1       | 1       | presetted | 1         | (Editable)    | Eingabe     | !dontChange | !dontChange | BUG.FF      | BUG.FV    | BUG.FE        |
 | vname=='iegrausw'    | 1      | 1       | 1       | presetted | 1         | (Editable)    | Eingabe     | BUG.BB      | BUG.BA      | !dontChange | !dontChange | !dontChange |
 | vname=='iebkopf'     | 1      | 1       | 1       | presetted | 1         | !dontChange | Ausgabe     | !dontChange | !dontChange | BUG.FF      | BUG.FV    | BUG.FE        |
 | vname=='iebfuss'     | 1      | 1       | 1       | presetted | 1         | !dontChange | Ausgabe     | !dontChange | !dontChange | BUG.FF      | BUG.FV    | BUG.FE        |
 | vname=='iegrkopf'    | 1      | 1       | 1       | presetted | 1         | !dontChange | Ausgabe     | !dontChange | !dontChange | BUG.FF      | BUG.FV    | BUG.FE        |
 | vname=='iegrfuss'    | 1      | 1       | 1       | presetted | 1         | !dontChange | Ausgabe     | !dontChange | !dontChange | BUG.FF      | BUG.FV    | BUG.FE        |
 | vname=='ietab'       | 1      | 1       | 1       | presetted | 1         | !dontChange | Ausgabe     | !dontChange | !dontChange | BUG.FF      | BUG.FV    | BUG.FE        |
 | vname=='iebtyp'      | 1      | 1       | 1       | presetted | 1         | (Editable)    | Ausgabe     | !dontChange | !dontChange | BUG.FF      | BUG.FV    | BUG.FE        |
 | vname=='ieatyp'      | 1      | 1       | 1       | presetted | 1         | (Editable)    | Ausgabe     | !dontChange | !dontChange | BUG.FF      | BUG.FV    | BUG.FE        |
 | vname=='ieageraet'   | 1      | 1       | 1       | presetted | 1         | !dontChange | Ausgabe     | !dontChange | !dontChange | BUG.FF      | BUG.FV    | BUG.FE        |
 | vname=='ieaparam'    | 1      | 1       | 1       | presetted | 1         | !dontChange | Ausgabe     | !dontChange | !dontChange | BUG.FF      | BUG.FV    | BUG.FE        |
 | vname=='iemaxlines'  | 1      | 1       | 1       | presetted | 1         | !dontChange | Ausgabe     | !dontChange | !dontChange | BUG.FF      | BUG.FV    | BUG.FE        |
 | vname=='ieanzstufen' | 1      | 1       | 1       | presetted | 1         | !dontChange | Ausgabe     | !dontChange | !dontChange | BUG.FF      | BUG.FV    | BUG.FE        |
 | vname=='ietreeview'  | 1      | 1       | 1       | presetted | 1         | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange | !dontChange |
 | vname=='ieabbrfrage' | 1      | 1       | 1       | presetted | 1         | !dontChange | Ausgabe     | !dontChange | !dontChange | BUG.FF      | BUG.FV    | BUG.FE        |
And I save the current editor
And I close the current editor
