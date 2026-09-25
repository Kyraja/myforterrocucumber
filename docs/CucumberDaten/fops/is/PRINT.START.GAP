..!interpreter english translate noabbrev
.continue DECL
..*****************************************************************************
.. FOP-Name       : PRINT.START.GAP
.. Autor          : lei
.. Verantwortlich : mg
.. Kontrolle      : lei
.. Funktion       :
..    P|aktslayout: Das Startlayout
..
..    definiert
..    P|akttmp
..
.. Ablauf         :
..    Startet die generierten "GAPFOP" um den Ablaufplan zu interpretieren.
..*****************************************************************************
.set trans -
!DECL
.. HIER PRINT.START.GAP
.. aktslayout:'P|aktslayout'
.. akttmp:'P|akttmp'
.. P|datagen: 'P|datagen'
.. P|struktur: 'P|struktur'
.. P|nurdruck: 'P|nurdruck'
.. P|rendern: 'P|rendern'
.type text xtmpdir      ? _F|defined(U|xtmpdir)
.type text xgenfop      ? _F|defined(U|xgenfop)
.type text xxmldata     ? _F|defined(U|xxmldata)
.type text xsys         ? _F|defined(U|xsys)
.type text xrender      ? _F|defined(U|xrender)
.type integer xkapebene ? _F|defined(U|xkapebene)
.type text xakt         ? _F|defined(U|xakt)
.type text xerr         ? _F|defined(U|xerr)
.type text xout         ? _F|defined(U|xout)
.type text xgenprefix   ? _F|defined(xgenprefix)
..
.assign U|xgenprefix = "gen/print/plan/"
.. akttmp ist noch Parameter
..datei -maske -tempname U|xtmpdir -suffix 'P|aktslayout'
..zuweisen P|akttmp = U|xtmpdir << P|aktslayout
..zuweisen P|aktpfad = P|aktslayout
.input "DATEI.F"
..aus auf 'U|xtmpdir'
.output terminal
.. PRINT.START.GAP: P|akttmp:'P|akttmp' P|aktslayout:'P|aktslayout'
.assign U|xgenfop = U|xgenprefix + P|aktslayout + ".GAPFOP.0"
..aus an 'U|xtmpdir'
.output terminal
.. Starte GAP.0 'U|xgenfop'
.input 'U|xgenfop'
..weiter GAP2
..
!GAP1
.assign U|xgenfop = U|xgenprefix + P|aktslayout + ".GAPFOP.1"
..aus an 'U|xtmpdir'
.output terminal
.. Starte GAP.1 'U|xgenfop'
.. deklarationen fuer GAPFOP.1
.input 'U|xgenfop'
..weiter END ? P|datagen & _P|struktur
..
!GAP2
.assign U|xgenfop = U|xgenprefix + P|aktslayout + ".GAPFOP.2"
..aus an 'U|xtmpdir'
.output terminal
.. Starte GAP.2 'U|xgenfop'
.. deklarationen fuer GAPFOP.2
.input 'U|xgenfop'
..aus an 'U|xtmpdir'
.output terminal
.. Ende GAP
..*****************************************************************************
!END
.continue
