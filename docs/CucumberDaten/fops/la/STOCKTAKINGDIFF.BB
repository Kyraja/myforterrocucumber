..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : STOCKTAKINGDIFF.BB
.. Author         : cl
.. Verantwortlich : tiwe
.. Kontrolle      : cl
.. Functionality  : starts Table-FOP
.. Includes
.. include la/STOCKTAKINGDIFF.EMPTY
..*****************************************************************************
.set trans -
.type ID56:2 x1          ? _F|defined(U|x1)
..
.continue ERROR3 ? _M|banhaengen & F|empty(M|zlsnr) & F|empty(M|zlvon) & F|empty(M|zlbis) & F|empty(M|tmpfile)
.continue TYPE   ? F|empty(M|tmpfile)
..
!ZSELECT
.copy M|banhaengen = G|TRUE
..
.select from 'M|tmpfile' U|x1
.. Button fertig drÅcken 
.continue KONTEN  ? _G|mehr
.assign M|zlsnr = 'U|x1'
..
!TYPE
.type text  xdIdiffBuch   ? _F|defined(U|xdIdiffBuch)
.type text  xdIdiffBuch2  ? _F|defined(U|xdIdiffBuch2)
.type text  xsys          ? _F|defined(U|xsys)
.type P5:1  xKoLaBest     ? _F|defined(U|xKoLaBest)
.type P5:1  xKoMgeAbw     ? _F|defined(U|xKoMgeAbw)
.type P5:1  xKoPrAbw      ? _F|defined(U|xKoPrAbw)
.type real  xmgeabw       ? _F|defined(U|xmgeabw)
.type real  xwertabw      ? _F|defined(U|xwertabw)
.type bool  xbfirst       ? _F|defined(U|xbfirst)
..
.set trans -
.continue ERROR2 ? G|evtvar = "fertig" & M|banhaengen & M|bfertig
.continue ERROR2 ? G|evtvar = "bstart" & M|banhaengen & M|bfertig
.continue ERROR1 ? G|evtvar = "fertig" & _M|banhaengen
.continue ERROR  ? M|banhaengen & F|empty(M|zlsnr) & G|evtvar = "bstart"
.copy U|xbfirst = G|FALSE
.copy M|bfertig = G|FALSE
..
.. temp. Datei fÅr BuchungssÑtze
.formula U|xdIdiffBuch  = "rmtmp/X.IOB."  + pid + ".TMP"
.formula U|xdIdiffBuch2 = "rmtmp/X.IOB2." + pid + ".TMP"
..
.continue KONTEN ? G|evtartengl = "BUTTON_AFTER" & G|evtvar = "fertig"
.continue TABLE  ? M|banhaengen
..
.input "la/STOCKTAKINGDIFF.EMPTY"
.input "is/TABLEEREN"   ? _M|banhaengen & _U|xbfirst
..
!TABLE
.input 'M|tab'
.continue ZSELECT ? _F|empty(M|tmpfile)
.continue END ? M|banhaengen
..
!KONTEN     
.copy U|xbfirst = G|TRUE
.select screen header
.output new 'U|xdIdiffBuch'
..
!LINE
.select screen line
.continue AWK ? _G|mehr
'M|abestand^id'#'M|akontomgeabw^id'#'M|akontopreisabw^id'#'M|twertdiff'#'M|tabwert'
.continue LINE
..
!AWK: Verdichten der datei
.formula U|xsys = "idiff.awk " + U|xdIdiffBuch + " > " + U|xdIdiffBuch2
.system 'U|xsys' background
..
!MASKEND
.select screen header
.select screen line 'M|tzeilen'
..
!SELECTLINE
.select from 'xdIdiffBuch2'  xKoLaBest # xKoMgeAbw # xKoPrAbw # xmgeabw # xwertabw
.continue END  ? _G|mehr
..
!MAKELINE
.copy M|bfertig = G|TRUE 
.make screen line +O
.formula M|break         = 0
.formula M|break         = 1 ? U|xbfirst
.set trans +
.formula M|ttename       = "Kontenverdichtung"
.set trans -
.assign M|abestand       = U|xKoLaBest
.assign M|akontomgeabw   = U|xKoMgeAbw
.assign M|akontopreisabw = U|xKoPrAbw
.. Mengenabweichung 
.assign M|twertdiff        = U|xmgeabw
.. Preisabweichung
.assign M|tabwert          = U|xwertabw
.copy U|xbfirst          = G|FALSE
.formula M|hinweis       = "" ? _M|bew
.set trans +
.formula M|hinweis       = "(wird automatisch durch das KOS-Kommando gebucht)" ? M|bew
.set trans -
.continue SELECTLINE
..
..****************************************************************************
!END
.continue
..****************************************************************************
!ERROR
.error Bitte ZÑhlliste eintragen.
.end 1
..
!ERROR1
.error Kontenverdichtung bereits erfolgt.
.end 1
..
!ERROR2
.error Button "Fertig" wurde bereits gedrÅckt.
.end 1
..
!ERROR3
.error Bitte ZÑhlliste oder ZÑhllistenbereich angeben.
.end 1
