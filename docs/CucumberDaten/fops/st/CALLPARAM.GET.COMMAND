..!interpreter english translate noabbrev
..*****************************************************************************
.. FOP-Name       : CALLPARAM.GET.COMMAND
.. Autor          : fwester
.. Verantwortlich : fwester
.. Kontrolle      : xg
.. Functionality  : Defines in "xerpcommand" the abas ERP command by using
.. data of the call parameter loaded in buffer 0. Expects receiver of
.. callparameter in buffer D.
..*****************************************************************************
.set trans -
..
.. Initializations
.copy U|xerpcommand = ""
.continue INFOSYS ? 0|zielinfosys
..
.. Database
.copy U|xerpcommand = "<" + D|vdntxts + ">"
.copy U|xerpcommand = U|xerpcommand + U|xaufrref ? _F|empty(U|xaufrref)
.continue ACTION
..
!INFOSYS: Open dialog by using file command
.load 1 metadata "D|"
.continue BREAK ? _G|mehr
.copy U|xerpcommand = "<" + 1|vdntxts + ">"
.copy U|xerpcommand = U|xerpcommand + D|id
..
!ACTION: Action
.copy U|xerpcommand = U|xerpcommand + "<" + F|value(0|zielmodus, "AS120") + ">"
..
!MENU: Sometimes we need a menu choice for the group
.continue RELEASE ? _F|equals(0|zielmodus, "(New)")
.copy U|xerpcommand = U|xerpcommand + "," + D|vgrtxts
..
!RELEASE: Release buffers
.load 1
..*****************************************************************************
!END
.continue
..*****************************************************************************
.set trans +
..
!ERROR1: Action is not supported
.assign U|xerrmessage = "Das Kommando '0|zielmodus' ist dem Interpreter unbekannt!"
.continue SCREEN
..
!SCREEN
.output terminal
Aufrufparameter '0|nummer', in Zeile '0|aktzeile':
'U|xerrmessage'
.continue BREAK
..
!BREAK
.error -message Die Ermittlung des Kommandos wurde abgebrochen!
.end 1
