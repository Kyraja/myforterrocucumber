..!interpreter english translate noabbrev
..!meta M|=dfue/FORECASTCONFIG
..*****************************************************************************
.. Name           : FORECASTCONFIG.START.BA
.. Author         : mh
.. Verantwortlich : mh
.. Kontrolle      :
.. Functionality  :
...Includes       :
..      include     dfue/FORECASTCONFIG.VIEW
..      include     dfue/FORECASTCONFIG.PROTECTION.BEFORE
..*****************************************************************************
.set trans -
..
.input "FORECASTCONFIG.PROTECTION.BEFORE"
..
.make screen line --
.. 
.formula M|kanzabrufefo = 0
.formula M|kanzabrufejedi = 0
.. 
.formula M|kanzlabjedi = 0
.formula M|kanzlabfo = 0
.formula M|kanzlabohne = 0
.formula M|kanzfabjedi = 0
.formula M|kanzfabfo = 0
.formula M|kanzfabohne = 0
.formula M|kanzvabjedi = 0
.formula M|kanzvabfo = 0
.formula M|kanzvabohne = 0
.. 
.copy M|kbanlegen = G|false
.copy M|kbloeschen = G|false
.copy M|kbkonfigurieren = G|false
.copy M|kbaktivieren = G|false
.copy M|kbdeaktivieren = G|false
..
..
.. 
.. Evaluate arguments
..------------------------- ----------- ---------------------------------------
.continue START  ?  G|evtvar = "bstart"
.continue NOEDI  ?  G|evtvar = "kbufehlerhafte"
..------------------------- ----------- ---------------------------------------
.continue END
.. 
..
!START 
.copy M|kbohnenachricht = G|false
.formula M|select = F|formatstr("$,,;@gruppe=2;@ordnung=nummer;such={1};nummer={2}!{3};firma={4}", M|kkundesuch, M|kkundevon^nummer, M|kkundebis^nummer, M|khauptkunde^id)
.formula M|select = M|select + ";edinfosnr<>`" ? M|kbmitediinfos
.formula M|select = M|select + ";merkmal1=" + M|kmerkmal1^id ? _F|empty(M|kmerkmal1)
.formula M|select = M|select + ";merkmal2=" + M|kmerkmal2^id ? _F|empty(M|kmerkmal2)
.formula M|select = M|select + ";merkmal3=" + M|kmerkmal3^id ? _F|empty(M|kmerkmal3)
.formula M|select = M|select + ";merkmal4=" + M|kmerkmal4^id ? _F|empty(M|kmerkmal4)
.formula M|select = M|select + ";merkmal5=" + M|kmerkmal5^id ? _F|empty(M|kmerkmal5)
.formula M|select = M|select + ";merkmal6=" + M|kmerkmal6^id ? _F|empty(M|kmerkmal6)
.continue END
.. 
.. 
!NOEDI
.copy M|kbohnenachricht = G|true
.copy M|kbmitediinfos = G|true
.copy M|kbedifelder = G|true
.input "FORECASTCONFIG.VIEW"
.formula M|select = "$,,;@gruppe=1.2;@ordnung=nummer;edinfosnr<>`"
.continue END
.. 
..*****************************************************************************
!END
.continue
