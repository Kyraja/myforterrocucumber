..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : CHANGECURRENCY.YDATE.FX
.. Date           : 04.03.15
.. Version        : 2015r2n04
.. Author         : si/dr
.. Copyright      : (c) 2015 SABA International
.. Functionality  :
..
.. Interface (arguments and their meaning)
..    uses array argument (arg.i)           : no
..    uses name argument  (xpname=value)    : no
..
..    Argument     meaning
..    -------------------------------------------------------------------------
..
.. Program flow   :
...Includes       :
..*****************************************************************************
..
..*****************************************************************************
.type text  U|xtcmd     ? _F|defined(U|xtcmd)
.type text  U|xtedp     ? _F|defined(U|xtdat)
.type text  U|xtout     ? _F|defined(U|xtout)
.type text  U|xterr     ? _F|defined(U|xterr)
.type P94:1 U|xcurr     ? _F|defined(U|xcurr)
.type P95:1 U|xrate     ? _F|defined(U|xrate)
.type realx U|xrcalc    ? _F|defined(U|xrcalc)
.type realx U|xrfact    ? _F|defined(U|xrfact)
.type bool  U|xbisewu   ? _F|defined(U|xbisewu)
.type text  U|xtiso3    ? _F|defined(U|xtiso3)
.type P97:1 U|xland     ? _F|defined(U|xland)
.type text  U|xtlaart   ? _F|defined(U|xtlaart)
..
.formula M|yrate        = ""
.formula M|ycalc        = ""
..
.continue END           ? F|empty(M|yland)
.continue END           ? F|empty(M|ydate)
..
.formula U|xbisewu      =  M|ycurr^ewu
..
..eigenen Kurs zur neuen WÑhrung ermitteln
.formula U|xtcmd        = "$,@database=95;@group=1;fwaehr==EUR;iwaehr=="+'G|inland^id'
.load 0 nolock object 'U|xtcmd'
.continue NORATE        ? _G|mehr
.assign M|yrate         = 0|id
.formula M|ycalc        = 0|faktieinh / 0|fkurs
.load 0
.end
..
!STEP04: <(Company)> $,gruppe=18 <(View)>,(Configuration) ? [pos]=0:inland
.output NEW 'U|xtout'
.output NEW 'U|xterr'
.output NEW 'U|xtedp'
.input DATEI.F
...#!EDP_TESTFLAG2=1
...#!EDP_DATE='U|xdate'
#!database=12
#!group=18
#!action=update
nummer;inland;eg;elster;
0k;'U|xcurr^id';'U|xbisewu';'U|xbisewu';
.output
.formula U|xtcmd        = "edpimport.sh -p abas123 -o FOPMODE=0 -o SHOWNOTES=0 -o SHOWTEXT=0 -I " + U|xtedp
.formula U|xtcmd        = U|xtcmd + " > " + U|xtout + " 2>" + U|xterr
.system 'U|xtcmd' background
..
.continue ERR04         ? F|filesize(U|xterr) > 0
.continue ERR04         ? 'F|sysinfo(18)^inland^id' <> 'U|xcurr^id'
..
!STEP05: <(Company)> $,gruppe=10 <(View)>,(CompanyData) ? [pos]=0:lainland
.output NEW 'U|xtout'
.output NEW 'U|xterr'
.output NEW 'U|xtedp'
.input DATEI.F
...#!EDP_TESTFLAG2=1
...#!EDP_DATE='U|xdate'
#!database=12
#!group=10
#!action=update
nummer;lainland;laart;
1;'U|xland^id';'U|xlaart';
.output
.formula U|xtcmd        = "edpimport.sh -p abas123 -o FOPMODE=0 -o SHOWNOTES=0 -o SHOWTEXT=0 -I " + U|xtedp
.formula U|xtcmd        = U|xtcmd + " > " + U|xtout + " 2>" + U|xterr
.system 'U|xtcmd' background
..
.continue ERR05         ? F|filesize(U|xterr) > 0
.continue ERR05         ? 'F|sysinfo(10)^lainland^id' <> 'U|xland^id'
..
!STEP06: eigenen WÑhrungskurs nullen
.formula U|xtcmd        = "$,@database=95;@group=1;fwaehr=="+'U|xcurr^id'+";iwaehr=="+'U|xcurr^id'
.load 0 nolock object 'U|xtcmd'
.continue NOIWAEHR      ? _G|mehr
..
.output NEW 'U|xtout'
.output NEW 'U|xterr'
.output NEW 'U|xtedp'
.input DATEI.F
...#!EDP_TESTFLAG2=1
...#!EDP_DATE='U|xdate'
#!database=12
#!group=10
#!action=update
id;faktieinh;fkurs;faktfeinh;ikurs;
'0|id';1;1;1;1;
.output
.load 0
.formula U|xtcmd        = "edpimport.sh -p abas123 -o FOPMODE=0 -o SHOWNOTES=0 -o SHOWTEXT=0 -I " + U|xtedp
.formula U|xtcmd        = U|xtcmd + " > " + U|xtout + " 2>" + U|xterr
.system 'U|xtcmd' background
..
.continue ERR06         ? F|filesize(U|xterr) > 0
..
!STEP07: alle WÑhrungskurse umrechnen
.continue STEP08
.output NEW 'U|xtout'
.output NEW 'U|xterr'
.output NEW 'U|xtedp'
.input DATEI.F
...#!EDP_TESTFLAG2=1
...#!EDP_DATE='U|xdate'
#!database=2
#!group=1
#!action=update
.output
.formula U|xtcmd        = "edpimport.sh -p abas123 -o FOPMODE=0 -o SHOWNOTES=0 -o SHOWTEXT=0 -I " + U|xtedp
.formula U|xtcmd        = U|xtcmd + " > " + U|xtout + " 2>" + U|xterr
.system 'U|xtcmd' background
..
.continue ERR07         ? F|filesize(U|xterr) > 0
..






.continue END
..
!NOOWN
.error "Kein EUR-Kurs zur neuen WÑhrung gefunden!"
.continue END
..
!NOLAND
.output TERMINAL
Zum ISO3-Code 'U|xtiso3' konnte kein Land ermittelt werden!
.continue END
..
!NOLAART
.output TERMINAL
Die Landart fÅr das neue Land konnte nicht ermittelt werden!
.continue END
..
!NORATE
.output TERMINAL
Sie haben keinen Kurs ausgewÑhlt!
.continue END
..
!NOCALC
.output TERMINAL
Der Kurs ist 0,00!
.continue END
..
!NOFACT
.output TERMINAL
Der Umrechnungsfaktor ist 0,00!
.continue END
..
!ERR04: Error in STEP04
.output TERMINL
Die neue WÑhrung <'U|xcurr'> konnte nicht in der Konfiguration eingetragen werden!
.input 'U|xterr'
.continue END
..
!ERR05: Error in STEP05
.output TERMINAL
Das neue Land <'U|xland'> konnte nicht in den Betriebsdaten eingetragen werden!
.input 'U|xterr'
.continue END
..
!ERR06: Error in STEP06
.output TERMINAL
Der eigene Kurs konnte nicht genullt werden!
.input 'U|xterr'
.continue END
..
!ERR07: Error in STEP07
.output TERMINAL
Bei der Umrechnung der historischen WÑhrungskurse ist ein Fehler aufgetreten!
.input 'U|xterr'
.continue END
..
!END
.continue

