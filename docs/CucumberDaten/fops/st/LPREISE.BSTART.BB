..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : LPREISE.BSTART.BB
.. Author         : fwester
.. Verantwortlich : cl 
.. Kontrolle      : tiwe
.. Functionality  : Validates input and prepares database query.
..*****************************************************************************
.set trans -
..
.. Declarations
.type ID82:1 xprice
..
.. Validations
.continue ERROR01 ? _F|empty(M|kbis) & M|kbis < M|kvon
.continue RANGES  ? _M|selpartner & _M|selartikel
.continue ERROR02 ?  F|empty(M|partner) & M|selpartner
.continue ERROR06 ?  F|empty(M|artikel) & M|selartikel 
..
.. Checks we have to do while certain partner is selected
.assign M|partnergrp = ""
.assign M|partnernumgrp = ""
.assign M|artikelgrp = ""
.assign M|artikelnumgrp = ""
.copy M|relevantpartnergrp = G|false
.copy M|relevantartikelgrp = G|false
..
.continue SALES ? M|ktypvk
.. Partner in purchasing must be a supplier
.continue ERROR03 ? M|partner^dnr = 0 & M|selpartner 
.continue DISCOUT ? M|ktyprabatt
.continue PRICE
..
!SALES: Partner in sales must be a customer
.continue ERROR03 ? M|partner^dnr = 1 & M|selpartner
.continue DISCOUT ? M|ktyprabatt
.continue PRICE
..
!DISCOUT: Get discount if not empty or handle ID no.
.continue NUMBER ? F|empty(M|partner^rab)  & M|selpartner
.continue NUMBER ? F|empty(M|artikel^vrab) & M|selartikel & M|ktypvk
.continue NUMBER ? F|empty(M|artikel^erab) & M|selartikel & _M|ktypvk
.assign M|partnergrp = M|partner^rab      ? M|selpartner
.assign M|artikelgrp = M|artikel^vrab     ? M|selartikel & M|ktypvk
.assign M|artikelgrp = M|artikel^erab     ? M|selartikel & _M|ktypvk
.continue NUMBER
..
!PRICE: Get price if not empty or handle ID no.
.continue NUMBER ?  M|ktyprabatt & F|empty(M|partner^rab) & M|selpartner
.continue NUMBER ? _M|ktyprabatt & F|empty(M|partner^prg) & M|selpartner
.continue NUMBER ?  M|ktyprabatt & F|empty(M|artikel^vrab) & M|selartikel & M|ktypvk
.continue NUMBER ? _M|ktyprabatt & F|empty(M|artikel^vprg) & M|selartikel & M|ktypvk
.continue NUMBER ?  M|ktyprabatt & F|empty(M|artikel^erab) & M|selartikel & _M|ktypvk
.continue NUMBER ? _M|ktyprabatt & F|empty(M|artikel^eprg) & M|selartikel & _M|ktypvk
.assign M|partnergrp = M|partner^rab  ?  M|ktyprabatt & M|selpartner
.assign M|partnergrp = M|partner^prg  ? _M|ktyprabatt & M|selpartner
.assign M|artikelgrp = M|artikel^vrab ?  M|ktyprabatt & M|selartikel & M|ktypvk
.assign M|artikelgrp = M|artikel^vprg ? _M|ktyprabatt & M|selartikel & M|ktypvk
.assign M|artikelgrp = M|artikel^erab ?  M|ktyprabatt & M|selartikel & _M|ktypvk
.assign M|artikelgrp = M|artikel^eprg ? _M|ktyprabatt & M|selartikel & _M|ktypvk
.continue NUMBER
..
!NUMBER: Get ID no. while not equal to the partner/product group
.assign M|partnernumgrp = M|partner^nummer  ? M|selpartner
.assign M|artikelnumgrp = M|artikel^nummer  ? M|selartikel
.copy M|relevantpartnergrp = _F|empty(M|partnergrp) & M|partnergrp <> M|partnernumgrp & M|selpartner
.copy M|relevantartikelgrp = _F|empty(M|artikelgrp) & M|artikelgrp <> M|artikelnumgrp & M|selartikel
.continue RANGES
..
!RANGES: Validate ranges
.continue PRODGRP ? F|empty(M|klpgvon) & F|empty(M|klpgbis)
..
.. Check price/discount group range of customer/supplier
.assign U|xprice = F|formatstr("$,,;klpg=={1};@lesen=nein", M|klpgvon)               ? 'M|klpgvon' = 'M|klpgbis'
.assign U|xprice = F|formatstr("$,,;klpg={1}!{2};@lesen=nein", M|klpgvon, M|klpgbis) ? 'M|klpgvon' <> 'M|klpgbis'
.continue ERROR04 ? _G|mehr
..
!PRODGRP: Check price/discount group range of product
.continue CLRTAB  ? F|empty(M|artpgvon) & F|empty(M|artpgbis)
.assign U|xprice = F|formatstr("$,,;artpg=={1};@lesen=nein", M|artpgvon)                ? 'M|artpgvon' = 'M|artpgbis'
.assign U|xprice = F|formatstr("$,,;artpg={1}!{2};@lesen=nein", M|artpgvon, M|artpgbis) ? 'M|artpgvon' <> 'M|artpgbis'
.continue ERROR05 ? _G|mehr
..
!CLRTAB: Clear table and files
.input "is/TABLEEREN"
.note -update ? G|grafik
.system 'F|formatstr(">{1}", M|sortfilename)' background
.. Preset
.copy M|sort = G|FALSE
.copy M|stufe = 1
.copy M|partnerlevel = 1   ? M|selpartner
.copy M|artikellevel = 1   ? M|selartikel
.copy M|sellevel = M|minsellevel
.copy M|partnersellevel = M|minpartnersellevel ? M|selpartner
.copy M|artikelsellevel = M|minartikelsellevel ? M|selartikel
.assign M|select0 = ""
.assign M|select1 = ""
.assign M|select2 = ""
.assign M|select3 = ""
.assign M|select4 = ""
.assign M|partnerselect1 = ""
.assign M|partnerselect2 = ""
.assign M|partnerselect3 = ""
.assign M|artikelselect1 = ""
.assign M|artikelselect2 = ""
.assign M|artikelselect3 = ""
.copy M|init = G|FALSE
..
.. Build common query                                                             
.formula M|select0 = ";@ordnung=gltvon,gltbis;typ==" + F|value(M|ktyp, "AS100")                      ? F|empty(M|ekvk)
.formula M|select0 = ";@ordnung=gltvon,gltbis;typ<>(PurchasingPriceList);typ<>(PurchasingDiscounts)" ? F|equals(M|ekvk, "(Sales)")
.formula M|select0 = ";@ordnung=gltvon,gltbis;typ<>(SalesPriceList);typ<>(SalesDiscounts)"           ? F|equals(M|ekvk, "(Purchasing)")
.continue SELPART ? _M|ksaktion
.formula M|select0 = M|select0 + ";saktion=1"
..
!SELPART: Partner selected?
.continue PARTNER ? M|selpartner
.continue ARTIKEL ? M|selartikel
.. No certain partner is selected
.continue CUSTSUP ? _M|nurpartnerleer & _M|nurartikelleer
.. We query prices or discount with empty group
.formula M|select0 = M|select0 + ";klpg=`"  ? M|nurpartnerleer
.formula M|select0 = M|select0 + ";artpg=`" ? M|nurartikelleer
.continue PERIOD
..
!PARTNER: We have to do a complex selection
.assign M|partnerselect1 = ";klpg=`"
.assign M|partnerselect2 = F|formatstr(";klpg=={1}", M|partnernumgrp)
.continue PERIOD ? _M|relevantpartnergrp
.copy M|partnersellevel = M|maxpartnersellevel
.assign M|partnerselect3 = F|formatstr(";klpg=={1}", M|partnergrp)
.continue PERIOD
..
!ARTIKEL: We have to do a complex selection
.assign M|artikelselect1 = ";artpg=`"
.assign M|artikelselect2 = F|formatstr(";artpg=={1}", M|artikelnumgrp)
.continue PERIOD ? _M|relevantartikelgrp
.copy M|artikelsellevel = M|maxartikelsellevel
.assign M|artikelselect3 = F|formatstr(";artpg=={1}", M|artikelgrp)
.continue PERIOD
..
!CUSTSUP: Price/discount customer/supplier
.continue PRODUCT ? F|empty(M|klpgvon) & F|empty(M|klpgbis)
.formula M|select0 = M|select0 + F|formatstr(";klpg=={1}", M|klpgvon)                ? 'M|klpgvon' = 'M|klpgbis'
.formula M|select0 = M|select0 + F|formatstr(";klpg={1}!{2}", M|klpgvon, M|klpgbis)  ? 'M|klpgvon' <> 'M|klpgbis'
..
!PRODUCT: Price/discount product
.continue PERIOD ? F|empty(M|artpgvon) & F|empty(M|artpgbis)
.formula M|select0 = M|select0 + F|formatstr(";artpg=={1}", M|artpgvon)                 ? 'M|artpgvon' = 'M|artpgbis'
.formula M|select0 = M|select0 + F|formatstr(";artpg={1}!{2}", M|artpgvon, M|artpgbis)  ? 'M|artpgvon' <> 'M|artpgbis'
..
!PERIOD: Expiry period
.continue END  ?  F|empty(M|kvon) &  F|empty(M|kbis)
.copy M|sellevel = M|maxsellevel
.continue FROMTO ? _F|empty(M|kbis) & _F|empty(M|kvon)
.continue FROM   ?  F|empty(M|kbis)
..
.. Only upper limit is defined
.formula M|select1 = ";gltvon=`;gltbis=`"
.formula M|select2 = ";gltvon=`;gltbis<>`"
.copy M|sort = G|TRUE
.formula M|select3 = F|formatstr(";gltvon<>`;gltvon=!{1};gltbis=`", M|kbis)
.formula M|select4 = F|formatstr(";gltvon<>`;gltbis<>`;gltvon=!{1}", M|kbis)
.continue END
..
!FROM: Only lower limit is defined
.formula M|select1 = ";gltvon=`;gltbis=`"
.formula M|select2 = F|formatstr(";gltvon=`;gltbis={1}!", M|kvon)
.copy M|sort = G|TRUE
.formula M|select3 = ";gltvon<>`;gltbis=`"
.formula M|select4 = F|formatstr(";gltvon<>`;gltbis<>`;gltbis={1}!", M|kvon)
.continue END
..
!FROMTO: Complete range defined
.formula M|select1 = ";gltvon=`;gltbis=`"
.formula M|select2 = F|formatstr(";gltvon=`;gltbis={1}!", M|kvon)
.copy M|sort = G|TRUE
.formula M|select3 = F|formatstr(";gltvon<>`;gltvon=!{1};gltbis=`", M|kbis)
.formula M|select4 = F|formatstr(";gltvon<>`;gltbis<>`;gltvon=!{1};gltbis={2}!", M|kbis, M|kvon)
..*****************************************************************************
!END
.continue
..*****************************************************************************
..
!ERROR01: Illegal period
.error -line 0 -field M|kvon -message Unzul„ssiger Zeitraum.
.end 1
..
!ERROR02: Missing partner
.error -line 0 -field M|partner -message Es fehlt die Angabe eines Gesch„ftspartners!
.end 1
..
!ERROR03: Partner does not match selected type
.error -line 0 -field M|partner -message Die Angabe eines Lieferanten passt nicht zum angegebenen Typ! ?  M|ktypvk
.error -line 0 -field M|partner -message Die Angabe eines Kunden passt nicht zum angegebenen Typ!      ? _M|ktypvk
.end 1
..
!ERROR04: Illegal range
.cursor klpgvon 0
.error
.end 1
..
!ERROR05: Illegal range
.cursor artpgvon 0
.error
.end 1
..
!ERROR06: Missing product
.error -line 0 -field M|artikel -message Es fehlt die Angabe eines Artikels!
.end 1
