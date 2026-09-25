..!interpreter english translate noabbrev
..*****************************************************************************
.. FOP-Name       : LABDIFF.BF
.. Autor          : mh
.. Verantwortlich : mh
.. Kontrolle      :
.. Funktion       : Berichtsfuss: Summen und Differenzen in Tabelle ausrechnen
.. Functionality  : report footer: sum and calcuate differences acrosst tabe
...Includes
..      include     dfue/LABDIFF.BF.FARBE
..*****************************************************************************
.set trans -
..
.. field names for schedule line colorization
.type text xlabd
.type text xlabm
.type text xefz
.type text xdiff
..
.. Cumulative delivered quantity vs Cumulative received quantity
.type m9.3 xlab1offen
.type m9.3 xlab2offen
.. project outstanding delivery notes
.type m9.3 xliefoffen
.type m9.3 xliefpuffer
.formula U|xlab1offen = M|klab1fzdiff
.formula U|xlab2offen = M|klab2fzdiff
.formula U|xliefoffen = M|krahfzdiff - M|klab2fzdiff
.. special situation, if cumulative received quantity is larger than cumulative delivered quantity
.. see onlinehelp for infosystem for details
.formula U|xlab1offen = 0.0  ? U|xlab1offen < 0.0
.formula U|xlab2offen = 0.0  ? U|xlab2offen < 0.0
.formula U|xliefoffen = 0.0  ? U|xliefoffen < 0.0
.formula U|xliefpuffer = 0.0
..
.. project cumulative quantity
.type mp9.3 xlab1fzahl
.type mp9.3 xlab2fzahl
.. project outstanding delivery notes
.type m9.3 xlieffzahl
.formula U|xlab1fzahl = M|klab1einfzahl
.formula U|xlab2fzahl = M|klab2einfzahl
.formula U|xlieffzahl = M|krahlfzahl
..
..
.. calculate and project cumulative quantities for table rows
.select screen header
!NLIEF1
.select screen line
.continue ELIEF1  ? _G|mehr
..
.. get delivery day
.formula M|tversandtermin = F|subdelivdays( M|krahmen^kunde^id, M|krahmenpos^platz^lgruppe^id, M|ttermin, M|krahmenpos^vorlauf )  ? _F|empty(M|ttermin)
.formula M|tversandtermin = M|tlipos^wtsterm  ? _F|empty(M|tlipos) & _F|empty(M|tlipos^wtsterm)
..
.. Cumulative delivered quantity vs Cumulative received quantity
.formula M|tlab1offen = M|tlab1menge
.formula M|tlab2offen = M|tlab2menge
.continue O1ENDE  ?  F|empty(U|xlab1offen)
.continue O1MINUS ?  U|xlab1offen < 0.0
.continue O1REST  ?  U|xlab1offen >  M|tlab1offen
.continue O1NULL  ?  U|xlab1offen <= M|tlab1offen
!O1MINUS: -- is + : add fzdiff to open quantity
.formula M|tlab1offen = M|tlab1offen - U|xlab1offen
.formula U|xlab1offen = 0.0
.continue O2ENDE
!O1NULL
.formula M|tlab1offen = M|tlab1offen - U|xlab1offen
.formula U|xlab1offen = 0.0
.continue O1ENDE
!O1REST
.formula U|xlab1offen = U|xlab1offen - M|tlab1offen
.formula M|tlab1offen = 0.0
!O1ENDE
.continue O2ENDE  ?  F|empty(U|xlab2offen)
.continue O2MINUS ?  U|xlab2offen < 0.0
.continue O2REST  ?  U|xlab2offen >  M|tlab2offen
.continue O2NULL  ?  U|xlab2offen <= M|tlab2offen
!O2MINUS: -- is + : add fzdiff to open quantity
.formula M|tlab2offen = M|tlab2offen - U|xlab2offen
.formula U|xlab2offen = 0.0
.continue O2ENDE
!O2NULL
.formula M|tlab2offen = M|tlab2offen - U|xlab2offen
.formula U|xlab2offen = 0.0
.continue O2ENDE
!O2REST
.formula U|xlab2offen = U|xlab2offen - M|tlab2offen
.formula M|tlab2offen = 0.0
!O2ENDE
.. project outstanding delivery notes
.formula M|tlioffen   = 0.0                          ?  U|xliefoffen >  M|tlab2offen
.formula M|tlioffen   = M|tlab2offen - U|xliefoffen  ?  U|xliefoffen <  M|tlab2offen
.formula M|tlioffen   = M|tlab2offen                 ?  U|xliefoffen <= 0.0
.formula U|xliefoffen = U|xliefoffen - M|tlab2offen
.formula U|xliefoffen = 0.0 ? U|xliefoffen < 0.0
.. display quantity in delivery note
.formula U|xliefpuffer = U|xliefpuffer + M|tlimenge
.formula M|tlimenge = U|xliefpuffer                  ? M|tlioffen > 0.0
.formula U|xliefoffen = U|xliefpuffer - M|tlioffen   ? M|tlioffen > 0.0  &  U|xliefpuffer > M|tlioffen
.formula U|xliefpuffer = 0.0                         ? M|tlioffen > 0.0
.formula M|tlimenge = 0.0                            ? M|tlioffen = 0.0
.formula M|tlioffen = M|tlioffen - M|tlimenge        ? M|tlioffen > 0.0
.formula M|tlioffen = 0.0                            ? M|tlioffen < 0.0
.continue LIENDE
!LIENDE
..
.. cumulative quantity: old forecast
.formula U|xlab1fzahl = U|xlab1fzahl + M|tlab1menge
.formula M|tlab1fzahl = U|xlab1fzahl
.. cumulative quantity: new forecast
.formula U|xlab2fzahl = U|xlab2fzahl + M|tlab2menge
.formula M|tlab2fzahl = U|xlab2fzahl
.. difference old/new forecast cq
.formula M|tdiffmenge = M|tlab2menge - M|tlab1menge
.formula M|tdifffzahl = M|tlab2fzahl - M|tlab1fzahl
.. "reserved cumulative quantity": outsanding delivery notes
.formula U|xlieffzahl = U|xlieffzahl + M|tlimenge
.formula M|tlifzziel  = U|xlieffzahl
.continue NLIEF1
!ELIEF1
..
..
.. Early warning
.continue ENDEW2 ? F|empty(M|kediffzeitraum) ; F|empty(M|kediffprozent)
.type M9.3 U|cqold   ? _F|defined(U|cqold)
.type M9.3 U|cqnew   ? _F|defined(U|cqnew)
.type M9.3 U|cqdiff  ? _F|defined(U|cqdiff)
.type GD   U|gd      ? _F|defined(U|gd)
.type GD   U|ewdate  ? _F|defined(U|ewdate)
.type bool U|labfab  ? _F|defined(U|labfab)
.formula U|cqold  = 0.0
.formula U|cqnew  = 0.0 
.formula U|cqdiff = 0.0
.formula U|labfab = M|klab2edinachr^nummer="2102" & M|klab1edinachr^nummer="2101"
.formula U|ewdate = M|klab2datum + M|kediffzeitraum 
.formula M|kfwstart = M|klab2datum
.formula M|kfwende = U|ewdate 
.formula M|kfwfabhorizont = U|endfab<U|ewdate & U|labfab
.formula M|kfwende = U|endfab ?  M|kfwfabhorizont
.formula M|kfwefzalt = M|klab1einfzahl
.formula M|kfwefzneu = M|klab2einfzahl
..
.select screen header
!NEXTEW  
.select screen line
.continue ENDEW ? _G|mehr
.formula U|gd = M|ttermin
.formula M|kfwefzalt = M|tlab1fzahl ?  U|gd < M|kfwstart 
.formula M|kfwefzneu = M|tlab2fzahl ?  U|gd < M|kfwstart 
.continue NEXTEW ?  U|gd < M|kfwstart 
.continue ENDEW ?  U|gd > M|kfwende     
.formula U|cqold = M|tlab1fzahl
.formula U|cqnew = M|tlab2fzahl
.formula U|cqdiff = M|tdifffzahl
.continue NEXTEW
!ENDEW
.formula M|kfwalt = U|cqold
.formula M|kfwneu = U|cqnew
.formula M|kfwsumalt = U|cqold - M|kfwefzalt
.formula M|kfwsumneu = U|cqnew - M|kfwefzneu
.formula M|kfwsumdiff = U|cqdiff
.formula M|kfwdiff = M|kfwsumdiff / M|kfwsumalt  * 100 ? _F|empty(M|kfwsumalt)
..
.. Write Early warning test results into edi message
.continue ENDEW2 ? _M|kfwupdateedi
.select lock edifact 'M|klab^id'
.continue ENDEW2 ? _G|mehr ; _G|gesperrt
..
.. Show or Clear "error" and ftext, if there is/not a difference (or allowance not exceeded)
.formula H|funktion = "F"  ?  H|funktion<>"915"
.formula H|funktion = ""   ?  H|funktion<>"915"  &  (F|abs(M|kfwdiff)<=M|kediffprozent)
.. Add notes to row1 for easy evaluation in edi center
.select lock line
.continue WRITEEW ? _(H|text1/"000*")
.formula H|text20 = "EF:" + 'M|kediffprozent:2'
.formula H|text21 = "ZE:" + 'M|kediffzeitraum'
.formula H|text22 = "AU:" + 'U|cqold:0'
.formula H|text23 = "AB:" + 'U|cqnew:0'
.formula H|text24 = "DI:" + 'M|kfwdiff:2'
!WRITEEW
.rewrite
.select -
!ENDEW2
..
..
.. fill schedule lines (sub mask), colorize schedule lines (sub mask)
.. remove rows with date before diff-list start date
.select screen header
!NLIEF2
.select screen line
.continue ELIEF2  ? _G|mehr
!NLIEF2R: return here after deletion -> current is changed
.continue XLIEF2  ?  M|ttermin < M|klabdiffstart  & _F|empty(M|klabdiffstart)    & _M|kbdiffkomplett & _M|kbdiffeingang & _M|kbdiffabterm
.. show all rows: kbdiffkomplett                                               &  M|kbdiffkomplett & _M|kbdiffeingang & _M|kbdiffabterm
.continue XLIEF2  ?  M|aktzeile=1  & F|empty(M|tlab2termin) & F|empty(M|tlipos)  & _M|kbdiffkomplett &  M|kbdiffeingang & _M|kbdiffabterm
.continue XLIEF2  ?  M|aktzeile=1  & F|empty(M|tlab2offen)  & F|empty(M|tlipos)  & _M|kbdiffkomplett & _M|kbdiffeingang &  M|kbdiffabterm
.continue XLIEF2  ?  M|aktzeile>1  & F|empty(M|tlab2termin) & F|empty(M|tlipos)  & _M|kbdiffkomplett &  M|kbdiffeingang & _M|kbdiffabterm  & (M|tlab2fzahl=M|klab2lfzahl)
.continue XLIEF2  ?  M|aktzeile>1  & F|empty(M|tlab2offen)  & F|empty(M|tlipos)  & _M|kbdiffkomplett & _M|kbdiffeingang &  M|kbdiffabterm  & (M|tlab2fzahl=M|klab2lfzahl)
.continue ELIEF2  ?  M|aktzeile > 64
.. fill schedule lines
.. .formula M|labd.aktzeile  =  F|tostring(M|tlab2termin)
.. .formula M|labd.aktzeile  =  F|tostring(M|tlab1termin)    ?  F|empty(M|labd.aktzeile)
.. .formula M|labd.aktzeile  =  F|tostring(M|ttermin)        ?  F|empty(M|labd.aktzeile)
.formula M|labd.aktzeile    =  F|tostring(M|ttermin)
.formula M|labdattyp.aktzeile = M|tterminc
.formula M|labm.aktzeile  =  M|tlab2menge
.formula M|efz.aktzeile   =  M|tlab2fzahl
.formula M|diff.aktzeile  =  M|tdiffmenge
.continue NLIEF2
!XLIEF2
.. remove rows with date before diff-list start date
.make screen line -
.continue ELIEF2  ?  M|tzeilen < M|aktzeile ; M|aktzeile = 0
.continue NLIEF2R
!ELIEF2
..
..
.. colorize table and shipping schedule lines
.input "dfue/LABDIFF.BF.FARBE"
..*****************************************************************************
!END
.continue
