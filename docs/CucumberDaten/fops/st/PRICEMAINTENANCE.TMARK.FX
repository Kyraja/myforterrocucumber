..!interpreter english translate noabbrev
..*****************************************************************************
.. FOP-Name       : PRICEMAINTENANCE.TMARK.FX
.. Autor          : fwester
.. Verantwortlich : cl
.. Kontrolle      : tiwe
.. Functionality  : Handles event while user marks or unmarks a row. If user
.. unmarks a header row its scaling have to be unmarked too. Each unmarking
.. causes a resetting of editable values and status flags. If user marks a
.. scaling row its header row have to be marked too.
..*****************************************************************************
.set trans -
..
.continue HEADER ? M|tbaumstufe = M|headerlevel
.continue CHILD  ? M|tbaumstufe = M|rowlevel
.continue FATAL
..
!CHILD: Do nothing while unmarked
.continue CMARKED ? M|tmark
..
.. Child unmarked
.input 'M|resetrow' ? _F|empty(M|resetrow)
.input 'M|setrowremoval' ? _F|empty(M|setrowremoval)
.input 'M|checkrecordrow' ? _F|empty(M|checkrecordrow)
.continue END
..
!CMARKED: Scaling marked, mark header too.
.copy M|lastrowno = G|evtzeile
.select screen line 'F|formatstr("$,,;tnum^id=={1}", M|theader^id)'
.continue FATAL ? _G|mehr
.continue REPOS ? M|tmark
.copy M|tmark = G|true
.continue REPOS
..
!HEADER: Do nothing while marked
.continue MARKALL ? M|tmark
..
.. Header row unmarked
.copy M|lastrowno = G|evtzeile
.input 'M|resetrow' ? _F|empty(M|resetrow)
.type integer currentrowno
.copy U|currentrowno = G|evtzeile + 1
..
!WHILE: Unmark scaling
.continue REPOS ? U|currentrowno > M|tzeilen
.select screen line 'U|currentrowno'
.continue REPOS ? _G|mehr
.continue REPOS ? M|tbaumstufe = M|headerlevel
.copy M|tmark = G|false
.input 'M|resetrow' ? _F|empty(M|resetrow)
.input 'M|setrowremoval' ? _F|empty(M|setrowremoval)
.input 'M|checkrecordrow' ? _F|empty(M|checkrecordrow)
.formula U|currentrowno = U|currentrowno + 1
.continue WHILE
..
!MARKALL: Header was marked, mark scaling too
.copy M|lastrowno = G|evtzeile
.type integer currentrowno
.copy U|currentrowno = G|evtzeile + 1
..
!WHILE2: Mark scaling
.continue REPOS ? U|currentrowno > M|tzeilen
.select screen line 'U|currentrowno'
.continue REPOS ? _G|mehr
.continue REPOS ? M|tbaumstufe = M|headerlevel
.copy M|tmark = G|true
.formula U|currentrowno = U|currentrowno + 1
.continue WHILE2
..
!REPOS: Reset row cursor to before
.select screen line 'M|lastrowno'
.continue FATAL ? _G|mehr
..*****************************************************************************
!END
.continue
..*****************************************************************************
!FATAL
.error -number 1111
.end 1
