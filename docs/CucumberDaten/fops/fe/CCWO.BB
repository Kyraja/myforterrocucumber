..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : CCWO.BB
.. Verantwortlich : tiwe
.. Kontrolle      : cl
.. Functionality  :
..
..*****************************************************************************
.set trans -
.type text     xtkomm      ? _F|defined(U|xtkomm)
.type integer  xifbuchung  ? _F|defined(U|xifbuchung)
.type integer  xiretoure   ? _F|defined(U|xiretoure)
.type integer  xibetrieb   ? _F|defined(U|xibetrieb)
.type integer  xistorno    ? _F|defined(U|xistorno)
.type bool     xbreterlaub ? _F|defined(U|xbreterlaub)
.type bool     xbstorno    ? _F|defined(U|xbstorno)
..
.continue RUECKBAU  ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "burueck2"
.continue STORNO    ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "bustorno2"
.continue ZEIT      ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "buzeit2"
.continue FBU       ? G|evtartengl = "BUTTON_BEFORE" & G|evtvar = "tfbu"
.continue ERROR
..
!ZEIT: TeitrÅckmeldung / TimeEntry
.continue END ? F|empty(M|buzeit)
.continue ABLZEIT ? M|ablage
.formula U|xtkomm = "(TimeEntry)"+ " ? barmex=" + M|rueckmeldung^nummer
.continue END
..
!ABLZEIT
.formula U|xtkomm = "(TimeEntry)"+ " ? barmex=+" + M|rueckmeldung^nummer
.continue END
..
!STORNO
.continue END ? F|empty(M|bustorno)
.copy U|xbstorno = G|TRUE 
.assign U|xistorno = 7
.assign U|xibetrieb = 9
.continue STFEHLER    ? _F|cmdpermitted(U|xibetrieb, U|xistorno)
.continue SETSTORNO
..
!STFEHLER
.copy U|xbstorno = G|FALSE
.continue FEHLER2 ? _U|xbstorno
..
!SETSTORNO
.formula U|xtkomm = "<(Workorder)>"+M|rueckmeldung^id+"<(Reversal)>"
.continue END
..
!RUECKBAU
.continue END ? F|empty(M|burueck)
.copy U|xbreterlaub = G|TRUE
.assign U|xiretoure = 22
.assign U|xibetrieb = 9
.continue ERLFEHLER    ? _F|cmdpermitted(U|xibetrieb, U|xiretoure)
.continue RET 
..
!ERLFEHLER
.copy U|xbreterlaub = G|FALSE
.continue FEHLER1 ? _U|xbreterlaub
..
!RET
.continue COPY ? M|ablage ; F|empty(M|tba) 
.formula U|xtkomm = "<(Workorder)>"+M|rueckmeldung^nummer+"<(Return)>"
.continue END
..
!COPY
.formula U|xtkomm = "<(Workorder)>"+M|rueckmeldung^id+"<(Copy)>"
.continue END
!FBU: Materialentnahme
.continue END
..
!FEHLER1
.error RÅckbau nicht erlaubt!
.end 1
..
!FEHLER2
.error Storno nicht erlaubt!
.end 1
..
!ERROR
.error Kein passendes Event gefunden.
.end 1
..
.. ****************************************************************
!END
.end 0 'U|xtkomm'
