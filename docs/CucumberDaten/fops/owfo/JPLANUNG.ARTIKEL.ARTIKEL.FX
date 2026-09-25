..!interpreter german translate noabbrev
..*****************************************************************************
.. Name           : JPLANUNG.ARTIKEL.ARTIKEL.FX
.. Date           : 02.06.15
.. Version        : 2015r4n01p03
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
.ende ? m|artikel = ""
.art text xtsel
.fo xtsel = "&,,nummer=;y40ajahr="+'m|gjahr'+";y40aartikel=" + 'm|artikel' +";@gruppe=12"
!HOL:
.hol datei40 'xtsel'
.weiter EINLESEN ?  mehr
.weiter MACHDATEI


!MACHDATEI
..
.art text xtsuch xtname 
.fo xtsuch = 'm|artikel^such' + "-" + 'm|gjahr'
.fo xtname = 'm|artikel^name' + " " + 'm|gjahr'
.mache datei40 gruppe12
.fo such = xtsuch
.fo name = xtname
.fo y40aartikel= 'm|artikel^id'
.fo y40ajahr = m|gjahr
...............................
.bringe
.. wieder holen und befÅllen
..
.art text xtsel xtjahr
.fo xtsel = "$,,nummer=;y40ajahr="+'m|gjahr'+";y40aartikel=" + 'm|artikel' +";@gruppe=12"
..
.hol datei40 'xtsel'
..
..
.weiter F1 ? _ mehr
.fo m|partikel = 'h|id'
..
..
..   Umsatzzahlen aus Artikel lesen nicht mehr aktiv,
..   da Umstellung auf 13 Perioden zu 4 Wochen
..
..
.weiter
..



!EINLESEN:
.fo m|partikel = h|nummer
.fo m|artikel  = m|partikel^y40aartikel
.fo m|epreis   = m|partikel^y40avkpreis
.fo m|gmge     = m|partikel^y40aplanmenge
.fo m|gwert    = m|partikel^y40aplanumsatz
..
.fo m|mge01    = m|partikel^y40aplmge01
.fo m|mge02    = m|partikel^y40aplmge02
.fo m|mge03    = m|partikel^y40aplmge03
.fo m|mge04    = m|partikel^y40aplmge04
.fo m|mge05    = m|partikel^y40aplmge05
.fo m|mge06    = m|partikel^y40aplmge06
.fo m|mge07    = m|partikel^y40aplmge07
.fo m|mge08    = m|partikel^y40aplmge08
.fo m|mge09    = m|partikel^y40aplmge09
.fo m|mge10    = m|partikel^y40aplmge10
.fo m|mge11    = m|partikel^y40aplmge11
.fo m|mge12    = m|partikel^y40aplmge12
.fo m|mge13    = m|partikel^y40aplmge13
.weiter



!F1:
.fehler Datei nicht gefunden
.ende
