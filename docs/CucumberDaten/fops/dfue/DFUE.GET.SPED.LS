..!interpreter english
..@@BEGINHEAD
..========================================================================
..==
..==  Name              : DFUE.GET.SPED.LS
..==
..==  Pfad              : dfue
..==
..==  Projekt           : dfue
..==
..==  Funktion          : sucht die LS zu einem SPED
..==
..==  Erstellungsdatum  : 22.10.98
..==
..==  Autor             : Marco Machmer
..==  Verantwortlich    : mh
..==  Menuepunkte       :
..==
..==  Maskenprioritaet
..==  bei EFOP          :
..==
..==  Besonderheiten    : ist unterprogramm
..==                      - folgende Åbergabevariablen mÅssen gesetzt sein
..==                        xSPEDnr     ... steht die IDnr des SPED
..==                        xbNextLS    ... true -> next LS
..==                        xbNextZeile ... true -> next Zeile eines LS
..==                        xbsperre    ... true -> .hol xxx sperr
..==
..==                      - rÅckgabewert ist xmehr
..==
..==  Aenderungshistorie: 1.1 <22.10.98>
..==                      - erste version im lieferumfang 8.5N__
..==
..#KOR#EDI-MODUL#DATUM#éNDERUNGS-INDEX#MitarbeiterkÅrzel#
..#KOR#LS#06.11.2003#1#ok#
..========================================================================
.set trans -
..@@ENDHEAD
..
.input ARB
..
.. variable definitions
..@@BEGINVARDEFS
..====================================================
.type text  xcom
.type text  xdPARAM
.type bool  xmehr
..... procedure stack pointer .....
..art int   xprocsp
.type text  xtxt
..====================================================
..@@ENDVARDEFS
..
.. initialize procedure stack pointer
..fo xprocsp = 0
.. alle variablen mÅssen definiert sein, sonst bricht das programm ab
.set demand -
..
.. ----------------------------------------
.continue EPROCDEF
.. procedure definitions
!EPROCDEF: ----- end procedure definitions -----
.. ----------------------------------------
..
.. programm ist immer unterprogramm
.end . ? txname / "*DFUE.GET.SPED.LS"
..
.. testen, ob die Åbergabewerte gesetzt sind durch einfache zuweisung
.formula xmehr = xbNextLS
.formula xmehr = xbNextZeile
.formula xmehr = xbsperre
.formula xtxt   = xSPEDnr
.formula xmehr = false
.formula xtxt   = ""
..
.. --------------------   BLOCK  --------------------
.. initialisierung
..die parameterdatei
..**ok,06.11.2003 (xarb wurde entfernt)
.formula xdPARAM = "dfue/DFUE.EXP.INI"
.input 'xdPARAM'
..
.. -------------------- ENDBLOCK --------------------
..
..
.continue EL001 ? _(+xSPEDnr = 0)
.. IF001
.formula xmehr = false
.continue
..
!EL001
.. FI001
..
..
.continue EL002 ? _((_(xbNextLS)) & (_(xbNextZeile)))
.. IF002
.. neue suche ueber SEL starten
.. hole Åber SEL alle LS zu einem SPED
.. benutzt wird der StandardschlÅssel
..
..
..               die selektionsleiste
.formula U|xcom = "$,,;@gruppe=1;typ=(4);@ablage=(3);@zeilen=(0);sped=" + xSPEDnr
.select sales lock 'xcom' ? xbsperre
.select sales       'xcom' ? _xbsperre
.formula xmehr = mehr
.continue
..
.continue FI002
!EL002
..
.continue EL003 ? _(xbNextLS)
.. IF003
.. nÑchster LS
.select sales lock ? xbsperre
.select sales       ? _xbsperre
.formula xmehr = mehr
.continue
..
.continue FI003
!EL003
.. nÑchste zeile des LS
.select line lock ? xbsperre
.select line       ? _xbsperre
.formula xmehr = mehr
.continue
..
!FI003
..
!FI002
..
