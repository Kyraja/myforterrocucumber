..!interpreter english translate noabbrev
..*****************************************************************************
.. FOP-Name       : EKLAB.TAB.LS
.. Autor          : mh
.. Verantwortlich : mh
.. Kontrolle      : cl
.. Funktion       : Ausgabe/Neue Zeile der offenen Lieferscheine
.. Functionality  : Output/new row of non-booked delivery notes
..*****************************************************************************
..<META M|='ek/EKLAB'>
..<META H|='P4:2'>
..<META 3|='P4:2'>
.set trans -
..
.make screen line +O
.colour -foreground 'T|xabasblack' -background 'M|coldelivery' 'M|aktzeile'
.formula M|ttyp = M|ktyplieferschein
..
.formula M|tbaktiv = G|false
.formula M|tbv = ""
.formula M|tlab = ""
.formula M|tls = 3|kopf^id
.formula M|tprahmen = 3|zrahmen^id
.formula M|tprahmen = H|kopf^id
.formula M|tprahmenpos = H|id
.assign M|basisartikel = 3|artex^basisartikel
.formula M|tartikel = 3|artex^id
.formula M|tartname = 3|artex^sucherw
.formula M|tlief = 3|kopf^lief^id
.formula M|tfzahl = H|fzahl
.formula M|tpackanw = H|packanw
.formula M|tmge = 3|mge
.copy M|the = 3|he
.formula M|tpreis = 3|preis
.formula M|tbeterm = ""
.formula M|tliterm = 3|tterm
.formula M|trterm = 3|rterm
.formula M|tplatz = 3|platz^id
.formula M|tfix = 3|fix
.formula M|tverwendung = 3|verw   ? F|defined(3|verw)
.formula M|tedi = ""
.formula M|tedihinweis = ""
.formula M|tediuebdat = ""
.formula M|tstatusz = ""
..
.type P4:2 xconddatitem ? _F|defined(U|xconddatitem)
.type date xconddat ? _F|defined(U|xconddat)
.formula U|xconddatitem = 3|id 
.input "ek/EKLAB.GET.KONDDAT.FO"
.formula M|tkonddat = U|xconddat
.formula M|tzgltstatus = ""
.formula M|tzgltstatus = M|kstatusrot ? _F|empty(H|zgltvon) & U|xconddat<H|zgltvon
.formula M|tzgltstatus = M|kstatusrot ? _F|empty(H|zgltbis) & U|xconddat>H|zgltbis
.formula M|tbgltstatus = F|empty(M|tzgltstatus)
.formula M|tzgltstatus = "" ? ( _F|empty(H|zgltvon) ; _F|empty(H|zgltbis) ) & M|tbgltstatus
.copy M|kzgltstatus = M|kstatusrot ? _M|tbgltstatus 
..
.formula M|tbustorno     = ""
.formula M|tbuvorschlag  = ""
.formula M|tbukonvert    = ""
.formula M|tbukeinbedarf = ""
.formula M|tbusenden     = ""
..
.protection tbustorno 'M|aktzeile'
.protection tbuvorschlag 'M|aktzeile'
.protection tbuvorschlag2 'M|aktzeile'
.protection tbukonvert 'M|aktzeile'
.protection tbukeinbedarf 'M|aktzeile'
.protection tbusenden 'M|aktzeile'
..
..*****************************************************************************
!END
.continue
