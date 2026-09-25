..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : FLEXQTY.BB
.. Author         : fwester
.. Verantwortlich : tiwe
.. Kontrolle      : cl
.. Functionality  : Opens and presets <(Workorder)><(Done)> subeditor.
..*****************************************************************************
.set trans -
..
.. Correct usage?
.continue FATAL   ? _G|evtartengl = "BUTTON_BEFORE"
.continue SETQTY  ? G|evtvar = "mgesetzen" ; G|evtvar = "mgesetzen2"
.continue DISABLY ? G|evtvar = "demontage" ; G|evtvar = "demontage2"
.continue SCRAP   ? G|evtvar = "ausschuss" ; G|evtvar = "ausschuss2"
.continue FATAL
..
!SETQTY: Set quantity
.continue EQUAL   ? M|ofmge = M|mgeneu
.continue ERROR03 ? M|mgesetzen = M|icon1
.assign M|tid = ""
.assign M|origversionn = ""
.select nolock nowait object 'M|tba^id'
.continue ERROR04 ? _G|mehr
.. hier in BA: 'H|id'
.select nolock add H|lres
.continue CONTROL ? _G|mehr
..hier in FV: 'H|id'
.select nolock add H|lres
.continue CONTROL ? _G|mehr
.. hier in AFL: 'H|id'
..
!CONTROL
.formula M|tid = H|id
.copy M|origversionn = H|versionn
.select -
.continue INCREAS  ? M|mgesetzen = M|icon3
.continue REDUCE   ? M|mgesetzen = M|icon4
.continue END
..
!REDUCE: Redunce quantity
.continue ERROR05 ? M|mgeneu = 0.0 & M|ofmge = M|prodmge
..
.formula M|tcommand = M|tid + "<(Edit)> ?"
.formula M|tcommand = M|tcommand + " bfrgmge=" + 'M|mgeneu'
.formula M|tcommand = M|tcommand + " | "
.formula M|tcommand = M|tcommand + " blimge=" + 'M|mgeneu'
.formula M|tcommand = M|tcommand + " |"
.formula M|tcommand = M|tcommand + " [invisible]=1"
.continue SUBEDIT ? G|evtvar = "mgesetzen2"
.continue END
..
!INCREAS: Increase quantity
.formula M|tcommand = M|tid + "<(Edit)> ?"
.formula M|tcommand = M|tcommand + " bgmge=" + 'M|mgeneu'
.formula M|tcommand = M|tcommand + " |"
.formula M|tcommand = M|tcommand + " [invisible]=1"
.continue SUBEDIT ? G|evtvar = "mgesetzen2"
.continue END
..
!DISABLY: Disassembly
.. Function needed?
.continue ERROR01 ? F|empty(M|demontage)
..
.formula M|tmpmge = M|merkmgeneu - M|merkmgegrenze
.formula M|tcommand = "<(Workorder)>" + M|tba^id + "<(Done)> ?"
.formula M|tcommand = M|tcommand + " 0:sofort=TRUE |"
.formula M|tcommand = M|tcommand + " 1:gutmge=" + 'M|tmpmge'
.continue SUBEDIT ? G|evtvar = "demontage2"
.continue END
..
!SCRAP: Confirm scrap
.. Function needed?
.continue ERROR01 ? F|empty(M|ausschuss)
..
.formula M|tmpmge = M|merkmgegrenze - M|merkmgeneu
.formula M|tcommand = "<(Workorder)>" + M|tba^id + "<(Done)> ?"
.formula M|tcommand = M|tcommand + " 0:sofort=TRUE |"
.formula M|tcommand = M|tcommand + " 1:gutmge=0 |"
.formula M|tcommand = M|tcommand + " 1:verlust=" + 'M|tmpmge'
.continue SUBEDIT ? G|evtvar = "ausschuss2"
.continue END
..
!SUBEDIT: Open subeditor
.select modificationlock nowait object 'M|tba^id'
.continue ERROR04 ? _G|mehr
.continue ERROR02 ? _G|gesperrt
.select -
.end 0 'M|tcommand'
..*****************************************************************************
!END
.continue
..*****************************************************************************
!FATAL
.error -number 1111
.end 1
..
..
!EQUAL: Equal quantities - nothing will change
.set trans +
.formula M|bemerkung = "Keine VerÑnderung: Betriebsauftrag hat diese Menge."
.set trans -
.error
.end 1
..
!ERROR01: Nothing to do
.set trans +
.formula M|bemerkung = "Sie mÅssen nicht demontieren."
.formula M|bemerkung = "Sie mÅssen keinen Ausschuss melden." ? G|evtvar = "ausschuss" ; G|evtvar = "ausschuss2"
.set trans -
.error
.end 1
..
!ERROR02: Data record already locked
.error -line 'G|evtzeile' -field M|tba -message Der Betriebsauftrag oder der RÅckmeldebeleg werden gerade bearbeitet. Bitte zuerst schlie·en.
.end 1
..
!ERROR03: Reduction is to big.
.set trans +
.formula M|bemerkung = "Demontage oder Ausschussmeldung notwendig!"
.set trans -
.colour -background 255 0 0 mgegrenze 'M|aktzeile'
.error
.end 1
..
!ERROR04: Working order not found!
.error -line 'G|evtzeile' -field M|tba -message Der Betriebsauftrag oder RÅckmeldebeleg wurde nicht gefunden.
.end 1
..
!ERROR05: New working orders cannot be cancelled like that
.formula M|mgeneu = M|tba^mge
.formula M|mgesetzen = ""
.error -line 'G|evtzeile' -field M|tba -message Die Stornierung muss in diesem Fall Åber den Fertigungsvorschlag erfolgen.
.end 1
