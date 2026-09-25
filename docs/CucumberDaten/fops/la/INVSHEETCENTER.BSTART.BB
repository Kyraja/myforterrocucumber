..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : INVSHEETCENTER.BSTART.BB
.. Author         : cl
.. Verantwortlich : tiwe
.. Kontrolle      : cl
.. Functionality  : Validates input, clears table and builds query.
..
.. todo
.. Bereiche nicht als Verweise, sondern Textfelder und diese validieren.
..*****************************************************************************
.set trans -
..
.. Validations
.continue ERROR01 ? _(M|bposnr ; M|bplsartn ; M|bartnpln ; M|bplsartna ; M|bplsarts ; M|bartspls ; M|bartnapls)
..
.. Clear table
.input "is/TABLEEREN"
..
.. Define order number
.formula M|ordnungsart = 1 ? M|bposnr
.formula M|ordnungsart = 2 ? M|bplsartn
.formula M|ordnungsart = 3 ? M|bartnpln
.formula M|ordnungsart = 4 ? M|bplsartna
.formula M|ordnungsart = 5 ? M|bplsarts
.formula M|ordnungsart = 6 ? M|bartspls
.formula M|ordnungsart = 7 ? M|bartnapls
..
.. Define query
.formula M|select = "$,,;@numsuch=" + M|zaehllistevon + "!" + M|zaehllistebis
.continue OPTIONS ? _M|nurnichtgedruckt
.formula M|select = M|select + ";gedruckt=0;"
..
!OPTIONS: Add options
.formula M|select = M|select + ";@ablageart="+'M|ablage'+";@gruppe=2"
..*****************************************************************************
!END
.continue
..*****************************************************************************
..
!ERROR01: Missing order!
.error Bitte eine Sortierung w„hlen.
.end 1
