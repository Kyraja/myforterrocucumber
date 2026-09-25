..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : PDMBOMDIFF.BSTART.BB
.. Author         : cl
.. Verantwortlich : mh
.. Kontrolle      : cl
.. Functionality  : Validates input fields before differing.
..*****************************************************************************
.set trans -
..
.continue ERROR01 ? F|empty(M|artikel)
.continue ERROR08 ? F|empty(M|artikelvergl)
..
.. Standard production list must have product and warehouse.
.type ID128:1 xtmpstdfl xtmpfl
.assign U|xtmpstdfl = F|formatstr(M|selectstd, "$", M|artikel^id, M|lgruppe^id)
.continue ERROR06 ? _G|mehr
..
.. Others must have the same product.
.assign U|xtmpfl = F|formatstr(M|selectnonstd, "$", M|artikelvergl^id) ?  F|empty(M|basisartikel)
.assign U|xtmpfl = F|formatstr(M|selectstd, "$", M|artikelvergl^id, M|lgruppe^id) ? _F|empty(M|basisartikel)
.continue ERROR07 ? _G|mehr
..
.copy M|artikel        = M|artikel
.copy M|flistestd      = U|xtmpstdfl 
.formula M|nrflistestd = M|flistestd^nummer
.copy M|fliste         = U|xtmpfl  ? F|empty(M|fliste)
.formula M|nrfliste    = M|fliste^nummer
..
.. Now we should have 2 production lists to differ otherwise we have to break.
.continue ERROR02 ? F|empty(M|flistestd)
.continue ERROR03 ? F|empty(M|fliste)
.continue ERROR04 ? M|flistestd^artikel^id <> M|fliste^artikel^id & F|empty(basisartikel)
.continue CLRTAB  ? M|flistestd^lgruppe^id = M|fliste^lgruppe^id
.continue CLRTAB  ? _F|empty(M|flistestd^lgruppe) & F|empty(M|fliste^lgruppe)
.continue ERROR05
..
!CLRTAB: Clear table
.input "is/TABLEEREN"
..*****************************************************************************
!END
.continue
..*****************************************************************************
..
!ERROR01: Missing product.
.error -field M|artikel -message Bitte den Artikel eintragen!
.end 1
..
!ERROR02: Missing standard production list.
.error -field M|artikel -message Es fehlt die Angabe der Standardfertigungsliste!
.end 1
..
!ERROR03: Missing 2nd production list!
.error -message Es fehlt die Angabe der zweiten Fertigungsliste!
.end 1
..
!ERROR04: Does not have the same product!
.error -message Die Fertigungslisten haben nicht den gleichen Artikel!
.end 1
..
!ERROR05: Does not have matching warehouses!
.error -message Die Fertigungslisten haben nicht zueinander passende Lagergruppen!
.end 1
..
!ERROR06: No standard production list.
.error -field M|artikel -message Es wurde keine Standardfertigungsliste gefunden!
.end 1
..
!ERROR07: No further production list found!
.error -message Es wurde keine zweite Fertigungsliste gefunden!
.end 1
!ERROR08: No product to compare with
.error -message Es wurde kein Artikel zum Vergleichen gefunden! 
.input "is/TABLEEREN"
.end 1
