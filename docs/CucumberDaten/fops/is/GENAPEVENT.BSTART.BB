..!interpreter english translate noabbrev
..*****************************************************************************
.. Author         : lei
..*****************************************************************************
.set trans -
.type A267 xallvartab xallinfosys xvartab xinfosys
.assign U|xallvartab = "(AllTablesOfVariables)"
.assign U|xallinfosys = "(AllInfosystems)"
.assign U|xvartab = "(SingleTableOfVariables)"
.assign U|xinfosys = "(SingleInfosystem)"
..
.make screen line -- ? M|tzeilen > 0
.formula M|fehlerprotokoll = ""
.continue VARTAB ? M|kontexttyp = U|xallvartab
.continue IS ? M|kontexttyp = U|xallinfosys
.continue KONTEXT ? _F|empty(M|kontext)
.continue ERR
..
!VARTAB
.assign M|isvartab = G|TRUE
.assign M|kontext = ""
.assign M|grliste = "12:26"
.assign M|select = "$,,@ordnung=such;typ==(Original)"
.continue
..
!IS
.assign M|isvartab = G|FALSE
.assign M|kontext = ""
.assign M|grliste = "65:1"
.assign M|select = "$,,@ordnung=nummer"
.continue
..
!KONTEXT
.assign M|select = "$,,id==" + 'M|kontext^id'
.continue ISK ? M|kontext^dnr = 65
.assign M|isvartab = G|TRUE
.assign M|grliste = "12:26"
.assign M|kontexttyp = U|xvartab
.continue
..
!ISK
.assign M|isvartab = G|FALSE
.assign M|grliste = "65:1"
.assign M|kontexttyp = U|xinfosys
.continue
..
!ERR
.cursor kontexttyp
.error Bitte Kontexttyp oder Kontext vorgeben.
.end 1
