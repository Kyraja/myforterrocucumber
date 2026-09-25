..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : PDMBOMDIFF.BB
.. Author         : cl
.. Verantwortlich : mh
.. Kontrolle      : cl
.. Functionality  : Validates inputs before creating a new production list.
..*****************************************************************************
.set trans -
.type bool xnoloesch ? _F|defined(U|xnoloesch)
..
.copy U|xnoloesch = G|FALSE
.continue VALID ? G|evtartengl = "BUTTON_BEFORE"  & G|evtvar = "bneuestdfl"
.continue VALID ? G|evtartengl = "BUTTON_BEFORE"  & G|evtvar = "bneuefl"
.continue END
..
!VALID
.continue ERROR01 ?  F|empty(M|flistestd)
.continue ERROR02 ?  F|empty(M|fliste)
.continue ERROR03 ?  M|tzeilen = 0
..
.select screen header
..
!NEXTROW
.select screen line
.continue END ? _G|mehr
.continue ERROR04 ? _M|sel1 & _M|sel2 & _M|loesch
.copy U|xnoloesch = G|TRUE  ? _M|loesch
.continue NEXTROW
..*****************************************************************************
!END
.copy M|noloesch = U|xnoloesch
.continue
..*****************************************************************************
..
!ERROR01: Missing standard production list.
.error -field M|artikel -message Es fehlt die Angabe der Standardfertigungsliste!
.end 1
..
!ERROR02: Missing 2nd production list!
.error -message Es fehlt die Angabe der zweiten Fertigungsliste!
.end 1
..
!ERROR03: No differences
.error -message Tabelle ist leer!
.end 1
..
!ERROR04: Unmarked row exists!
.error -line 'M|aktzeile' -field M|zn -message Die Zeile 'M|zn' ist nicht markiert!
.end 1
