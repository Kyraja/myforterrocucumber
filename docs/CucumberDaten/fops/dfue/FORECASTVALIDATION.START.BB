..!interpreter english translate noabbrev
..!meta M|=dfue/FORECASTVALIDATION
..*****************************************************************************
.. Name           : FORECASTVALIDATION.START.BB
.. Author         : mh
.. Verantwortlich : mh
.. Kontrolle      :
.. Functionality  :
..*****************************************************************************
.set trans -
..
.make screen line -- ? M|tzeilen > 0
.. 
.. type of edi message
.formula M|select = "$,,;such=VKAUV!VKAUV;vorart==3"
.formula M|select = "$,,;edinachr=2101;vorart==3" ? M|kblab
.formula M|select = "$,,;edinachr=2102;vorart==3" ? M|kbfab
.formula M|select = "$,,;edinachr=2104;vorart==3" ? M|kbvab 
..
.. range of edi messages 
.formula M|select = M|select + 'F|formatstr(";nummer={1}!{2}", M|kedivon^nummer, M|kedibis^nummer)' ? _F|empty(M|kedivon) ; _F|empty(M|kedibis)
.formula M|select = M|select + 'F|formatstr(";erfass={1}!{2}", M|kerfassvon, M|kerfassbis)' ? _F|empty(M|kerfassvon) ; _F|empty(M|kerfassbis)
.. 
.. customer / unloading point / debitor
.formula M|select = M|select + 'F|formatstr(";idkundeab=={1}", M|kkunde2^nummer)' ? _F|empty(M|kkunde2)
.formula M|select = M|select + 'F|formatstr(";idkundesab=={1}", M|kkunde^nummer)' ? _F|empty(M|kkunde)
.formula M|select = M|select + 'F|formatstr(";werk=={1}", M|kwerk)' ? _F|empty(M|kwerk)
.formula M|select = M|select + 'F|formatstr(";ablstelle=={1}", M|kablstelle)' ? _F|empty(M|kablstelle)
.. 
..*****************************************************************************
!END
.continue
