..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : CONTAINERMOVEMENTS.BB
.. Author         : cl
.. Verantwortlich : cl
.. Kontrolle      : mh
.. Functionality  :
..*****************************************************************************
.set trans -
.type text   xformatstr  ? _F|defined(U|xformatstr)
.type ID87:9 xcallparam  ? _F|defined(U|xcallparam)
..
.continue CONTAINERACCOUNT ? G|evtartengl = "BUTTON_AFTER" & (G|evtvar = "bu1" ; G|evtvar = "bu2" ; G|evtvar = "bu3" ; G|evtvar = "bu4" ; G|evtvar = "bu5" ; G|evtvar = "bu6" ; G|evtvar = "bu7" ; G|evtvar = "bu8" ; G|evtvar = "bu9" ; G|evtvar = "bu10" ; G|evtvar = "bu11" ; G|evtvar = "bu12" ; G|evtvar = "ihbu1" ; G|evtvar = "ihbu2" ; G|evtvar = "ihbu3" ; G|evtvar = "ihbu4" ; G|evtvar = "ihbu5" ; G|evtvar = "ihbu6" ; G|evtvar = "ihbu7" ; G|evtvar = "ihbu8" ; G|evtvar = "ihbu9" ; G|evtvar = "ihbu10" ; G|evtvar = "ihbu11" ; G|evtvar = "ihbu12")
.continue KERNEL           ? G|evtartengl = "BUTTON_KERNEL"
.continue END
..
!CONTAINERACCOUNT: šbersicht Beh„lterbewegungen
.continue ERROR2  ? M|tzeilen = 0
..
.continue BU1  ? G|evtvar = "bu1" ;  G|evtvar = "ihbu1"
.continue BU2  ? G|evtvar = "bu2" ;  G|evtvar = "ihbu2"
.continue BU3  ? G|evtvar = "bu3" ;  G|evtvar = "ihbu3"
.continue BU4  ? G|evtvar = "bu4" ;  G|evtvar = "ihbu4"
.continue BU5  ? G|evtvar = "bu5" ;  G|evtvar = "ihbu5"
.continue BU6  ? G|evtvar = "bu6" ;  G|evtvar = "ihbu6"
.continue BU7  ? G|evtvar = "bu7" ;  G|evtvar = "ihbu7"
.continue BU8  ? G|evtvar = "bu8" ;  G|evtvar = "ihbu8"
.continue BU9  ? G|evtvar = "bu9" ;  G|evtvar = "ihbu9"
.continue BU10 ? G|evtvar = "bu10" ; G|evtvar = "ihbu10"
.continue BU11 ? G|evtvar = "bu11" ; G|evtvar = "ihbu11"
.continue BU12 ? G|evtvar = "bu12" ; G|evtvar = "ihbu12"
..
!BU1
.formula M|anfang = M|abestandinternm1 ? G|evtvar = "ihbu1"
.formula M|anfang = M|abestandm1   ? G|evtvar = "bu1"
.formula M|bintern = G|TRUE        ? G|evtvar = "ihbu1" & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|TRUE        ? G|evtvar = "bu1"   & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|FALSE       ? G|evtvar = "bu1"   & F|equals(M|ktofuehr, "(Internal)")
.formula M|bintern = G|FALSE       ? G|evtvar = "ihbu1" & F|equals(M|ktofuehr, "(Internal)")
.formula M|ende   = M|ebestandinternm1 ? G|evtvar = "ihbu1"
.formula M|ende   = M|ebestandm1   ? G|evtvar = "bu1"
..
.assign U|xcallparam = M|callparam2  ? _F|empty(M|kreislauf)
.assign U|xcallparam = M|callparam1  ?  F|empty(M|kreislauf)
.input "st/CALLPARAM.EXEC"
.continue END
..
!BU2
.formula M|anfang = M|abestandinternm2 ? G|evtvar = "ihbu2"
.formula M|anfang = M|abestandm2   ? G|evtvar = "bu2"
.formula M|bintern = G|TRUE        ? G|evtvar = "ihbu2" & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|TRUE        ? G|evtvar = "bu2"   & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|FALSE       ? G|evtvar = "bu2"   & F|equals(M|ktofuehr, "(Internal)")
.formula M|bintern = G|FALSE       ? G|evtvar = "ihbu2" & F|equals(M|ktofuehr, "(Internal)")
.formula M|ende   = M|ebestandinternm2 ? G|evtvar = "ihbu2"
.formula M|ende   = M|ebestandm2   ? G|evtvar = "bu2"
..
.assign U|xcallparam = M|callparam4  ? _F|empty(M|kreislauf)
.assign U|xcallparam = M|callparam3  ?  F|empty(M|kreislauf)
.input "st/CALLPARAM.EXEC"
.continue END
..
!BU3
.formula M|anfang = M|abestandinternm3 ? G|evtvar = "ihbu3"
.formula M|anfang = M|abestandm3   ? G|evtvar = "bu3"
.formula M|bintern = G|TRUE        ? G|evtvar = "ihbu3" & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|TRUE        ? G|evtvar = "bu3"   & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|FALSE       ? G|evtvar = "bu3"   & F|equals(M|ktofuehr, "(Internal)")
.formula M|bintern = G|FALSE       ? G|evtvar = "ihbu3" & F|equals(M|ktofuehr, "(Internal)")
.formula M|ende   = M|ebestandinternm3 ? G|evtvar = "ihbu3"
.formula M|ende   = M|ebestandm3   ? G|evtvar = "bu3"
..
.assign U|xcallparam = M|callparam6  ? _F|empty(M|kreislauf)
.assign U|xcallparam = M|callparam5  ?  F|empty(M|kreislauf)
.input "st/CALLPARAM.EXEC"
.continue END
..
!BU4
.formula M|anfang = M|abestandinternm4 ? G|evtvar = "ihbu4"
.formula M|anfang = M|abestandm4   ? G|evtvar = "bu4"
.formula M|bintern = G|TRUE        ? G|evtvar = "ihbu4" & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|TRUE        ? G|evtvar = "bu4"   & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|FALSE       ? G|evtvar = "bu4"   & F|equals(M|ktofuehr, "(Internal)")
.formula M|bintern = G|FALSE       ? G|evtvar = "ihbu4" & F|equals(M|ktofuehr, "(Internal)")
.formula M|ende   = M|ebestandinternm4 ? G|evtvar = "ihbu4"
.formula M|ende   = M|ebestandm4   ? G|evtvar = "bu4"
..
.assign U|xcallparam = M|callparam8  ? _F|empty(M|kreislauf)
.assign U|xcallparam = M|callparam7  ?  F|empty(M|kreislauf)
.input "st/CALLPARAM.EXEC"
.continue END
..
!BU5
.formula M|anfang = M|abestandinternm5 ? G|evtvar = "ihbu5"
.formula M|anfang = M|abestandm5   ? G|evtvar = "bu5"
.formula M|bintern = G|TRUE        ? G|evtvar = "ihbu5" & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|TRUE        ? G|evtvar = "bu5"   & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|FALSE       ? G|evtvar = "bu5"   & F|equals(M|ktofuehr, "(Internal)")
.formula M|bintern = G|FALSE       ? G|evtvar = "ihbu5" & F|equals(M|ktofuehr, "(Internal)")
.formula M|ende   = M|ebestandinternm5 ? G|evtvar = "ihbu5"
.formula M|ende   = M|ebestandm5   ? G|evtvar = "bu5"
..
.assign U|xcallparam = M|callparam10  ? _F|empty(M|kreislauf)
.assign U|xcallparam = M|callparam9   ?  F|empty(M|kreislauf)
.input "st/CALLPARAM.EXEC"
.continue END
..
!BU6
.formula M|anfang = M|abestandinternm6 ? G|evtvar = "ihbu6"
.formula M|anfang = M|abestandm6   ? G|evtvar = "bu6"
.formula M|bintern = G|TRUE        ? G|evtvar = "ihbu6" & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|TRUE        ? G|evtvar = "bu6"   & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|FALSE       ? G|evtvar = "bu6"   & F|equals(M|ktofuehr, "(Internal)")
.formula M|bintern = G|FALSE       ? G|evtvar = "ihbu6" & F|equals(M|ktofuehr, "(Internal)")
.formula M|ende   = M|ebestandinternm6 ? G|evtvar = "ihbu6"
.formula M|ende   = M|ebestandm6   ? G|evtvar = "bu6"
..
.assign U|xcallparam = M|callparam12  ? _F|empty(M|kreislauf)
.assign U|xcallparam = M|callparam11  ?  F|empty(M|kreislauf)
.input "st/CALLPARAM.EXEC"
.continue END
..
!BU7
.formula M|anfang = M|abestandinternm7 ? G|evtvar = "ihbu7"
.formula M|anfang = M|abestandm7   ? G|evtvar = "bu7"
.formula M|bintern = G|TRUE        ? G|evtvar = "ihbu7" & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|TRUE        ? G|evtvar = "bu7"   & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|FALSE       ? G|evtvar = "bu7"   & F|equals(M|ktofuehr, "(Internal)")
.formula M|bintern = G|FALSE       ? G|evtvar = "ihbu7" & F|equals(M|ktofuehr, "(Internal)")
.formula M|ende   = M|ebestandinternm7 ? G|evtvar = "ihbu7"
.formula M|ende   = M|ebestandm7   ? G|evtvar = "bu7"
..
.assign U|xcallparam = M|callparam14  ? _F|empty(M|kreislauf)
.assign U|xcallparam = M|callparam13  ?  F|empty(M|kreislauf)
.input "st/CALLPARAM.EXEC"
.continue END
..
!BU8
.formula M|anfang = M|abestandinternm8 ? G|evtvar = "ihbu8"
.formula M|anfang = M|abestandm8   ? G|evtvar = "bu8"   & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|TRUE        ? G|evtvar = "ihbu8" & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|TRUE        ? G|evtvar = "bu8"   & F|equals(M|ktofuehr, "(Internal)")
.formula M|bintern = G|FALSE       ? G|evtvar = "bu8"   & F|equals(M|ktofuehr, "(Internal)")
.formula M|bintern = G|FALSE       ? G|evtvar = "ihbu8"
.formula M|ende   = M|ebestandinternm8 ? G|evtvar = "ihbu8"
.formula M|ende   = M|ebestandm8   ? G|evtvar = "bu8"
..
.assign U|xcallparam = M|callparam16  ? _F|empty(M|kreislauf)
.assign U|xcallparam = M|callparam15  ?  F|empty(M|kreislauf)
.input "st/CALLPARAM.EXEC"
.continue END
..
!BU9
.formula M|anfang = M|abestandinternm9 ? G|evtvar = "ihbu9"
.formula M|anfang = M|abestandm9   ? G|evtvar = "bu9"
.formula M|bintern = G|TRUE        ? G|evtvar = "ihbu9" & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|TRUE        ? G|evtvar = "bu9"   & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|FALSE       ? G|evtvar = "bu9"   & F|equals(M|ktofuehr, "(Internal)")
.formula M|bintern = G|FALSE       ? G|evtvar = "ihbu9" & F|equals(M|ktofuehr, "(Internal)")
.formula M|ende   = M|ebestandinternm9 ? G|evtvar = "ihbu9"
.formula M|ende   = M|ebestandm9   ? G|evtvar = "bu9"
..
.assign U|xcallparam = M|callparam18  ? _F|empty(M|kreislauf)
.assign U|xcallparam = M|callparam17  ?  F|empty(M|kreislauf)
.input "st/CALLPARAM.EXEC"
.continue END
..
!BU10
.formula M|anfang = M|abestandinternm10 ? G|evtvar = "ihbu10"
.formula M|anfang = M|abestandm10   ? G|evtvar = "bu10"
.formula M|bintern = G|TRUE         ? G|evtvar = "ihbu10" & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|TRUE         ? G|evtvar = "bu10"   & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|FALSE        ? G|evtvar = "bu10"   & F|equals(M|ktofuehr, "(Internal)")
.formula M|bintern = G|FALSE        ? G|evtvar = "ihbu10" & F|equals(M|ktofuehr, "(Internal)")
.formula M|ende   = M|ebestandinternm10 ? G|evtvar = "ihbu10"
.formula M|ende   = M|ebestandm10   ? G|evtvar = "bu10"
..
.assign U|xcallparam = M|callparam20  ? _F|empty(M|kreislauf)
.assign U|xcallparam = M|callparam19  ?  F|empty(M|kreislauf)
.input "st/CALLPARAM.EXEC"
.continue END
..
!BU11
.formula M|anfang = M|abestandinternm11 ? G|evtvar = "ihbu11"
.formula M|anfang = M|abestandm11   ? G|evtvar = "bu11"
.formula M|bintern = G|TRUE         ? G|evtvar = "ihbu11" & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|TRUE         ? G|evtvar = "bu11"   & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|FALSE        ? G|evtvar = "bu11"   & F|equals(M|ktofuehr, "(Internal)")
.formula M|bintern = G|FALSE        ? G|evtvar = "ihbu11" & F|equals(M|ktofuehr, "(Internal)")
.formula M|ende   = M|ebestandinternm11 ? G|evtvar = "ihbu11"
.formula M|ende   = M|ebestandm11   ? G|evtvar = "bu11"
..
.assign U|xcallparam = M|callparam22  ? _F|empty(M|kreislauf)
.assign U|xcallparam = M|callparam21  ?  F|empty(M|kreislauf)
.input "st/CALLPARAM.EXEC"
.continue END
..
!BU12
.formula M|anfang = M|abestandinternm12 ? G|evtvar = "ihbu12"
.formula M|anfang = M|abestandm12   ? G|evtvar = "bu12"
.formula M|bintern = G|TRUE         ? G|evtvar = "ihbu12" & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|TRUE         ? G|evtvar = "bu12"   & F|equals(M|ktofuehr, "(BusinessPartner)")
.formula M|bintern = G|FALSE        ? G|evtvar = "bu12"   & F|equals(M|ktofuehr, "(Internal)")
.formula M|bintern = G|FALSE        ? G|evtvar = "ihbu12" & F|equals(M|ktofuehr, "(Internal)")
.formula M|ende   = M|ebestandinternm12 ? G|evtvar = "ihbu12"
.formula M|ende   = M|ebestandm12   ? G|evtvar = "bu12"
..
.assign U|xcallparam = M|callparam24  ? _F|empty(M|kreislauf)
.assign U|xcallparam = M|callparam23  ?  F|empty(M|kreislauf)
.input "st/CALLPARAM.EXEC"
.continue END
..
!KERNEL
.. Gesch„ftspartnersicht
.formula U|xcallparam = "59125" ? F|equals(M|ktofuehr, "(Internal)") & (G|evtvar = "detailsm1" ; G|evtvar = "detailsm2" ; G|evtvar = "detailsm3" ; G|evtvar = "detailsm4" ; G|evtvar = "detailsm5" ; G|evtvar = "detailsm6" ; G|evtvar = "detailsm7" ; G|evtvar = "detailsm8" ; G|evtvar = "detailsm9" ; G|evtvar = "detailsm10" ; G|evtvar = "detailsm11" ; G|evtvar = "detailsm12")
.formula U|xcallparam = "59125" ? F|equals(M|ktofuehr, "(Internal)") & (G|evtvar = "detailsinternm1" ; G|evtvar = "detailsinternm2" ; G|evtvar = "detailsinternm3" ; G|evtvar = "detailsinternm4" ; G|evtvar = "detailsinternm5" ; G|evtvar = "detailsinternm6" ; G|evtvar = "detailsinternm7" ; G|evtvar = "detailsinternm8" ; G|evtvar = "detailsinternm9" ; G|evtvar = "detailsinternm10" ; G|evtvar = "detailsinternm11" ; G|evtvar = "detailsinternm12")
.. interne Sicht
.formula U|xcallparam = "59347" ? F|equals(M|ktofuehr, "(BusinessPartner)") & (G|evtvar = "detailsinternm1" ; G|evtvar = "detailsinternm2" ; G|evtvar = "detailsinternm3" ; G|evtvar = "detailsinternm4" ; G|evtvar = "detailsinternm5" ; G|evtvar = "detailsinternm6" ; G|evtvar = "detailsinternm7" ; G|evtvar = "detailsinternm8" ; G|evtvar = "detailsinternm9" ; G|evtvar = "detailsinternm10" ; G|evtvar = "detailsinternm11" ; G|evtvar = "detailsinternm12")
.formula U|xcallparam = "59347" ? F|equals(M|ktofuehr, "(BusinessPartner)") & (G|evtvar = "detailsm1" ; G|evtvar = "detailsm2" ; G|evtvar = "detailsm3" ; G|evtvar = "detailsm4" ; G|evtvar = "detailsm5" ; G|evtvar = "detailsm6" ; G|evtvar = "detailsm7" ; G|evtvar = "detailsm8" ; G|evtvar = "detailsm9" ; G|evtvar = "detailsm10" ; G|evtvar = "detailsm11" ; G|evtvar = "detailsm12")
.input "st/CALLPARAM.EXEC"
.continue END
..
!DETAIL
.command -parallel 'U|xformatstr'
.continue END
..
..*****************************************************************************
!END
.continue
..
!ERROR1
.error Nur bei leerem Beh„lterkonto erlaubt!
.end 1
..
!ERROR2
.error Tabelle ist leer.
.end 1
