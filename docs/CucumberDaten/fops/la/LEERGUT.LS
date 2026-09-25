..!interpreter english translate noabbrev
..*****************************************************************************
.. FOP-Name       : LEERGUT.LS
.. Datum          : 24.08.06
.. Version        : 2006r4n00
.. Autor          : dek/ok
.. Verantwortlich : mh
.. Kontrolle      :
.. Funktion       : Erstellt Lieferschein mit edpimport fÅr Leergutbuchung
.. Ablauf         : Button-Nach FOP fÅr "Buchen" Button
.. Functionality  : creates delivery note with edpimport for empty packing item booking
..
.. Program flow   : button after efop for "booking" button
...Includes       :
..*****************************************************************************
.set trans -
..
.type text      xtdat  ? _F|defined(xtdat)
.type text      xtdat2 ? _F|defined(xtdat2)
.type text      xtdat3 ? _F|defined(xtdat3)
.type text      xbetr  ? _F|defined(xbetr)
.type text      xtsys  ? _F|defined(xtsys)
.type text      x1     ? _F|defined(x1)
.type integer   xi     ? _F|defined(xi)
.type ARTR51000 xmge   ? _F|defined(xmge)
..
.formula M|hinweis = ""
..
.continue FM6      ? M|tzeilen = 0
.continue BGEBUCHT ? M|gebucht
..
.formula U|xtdat  = "rmtmp/" + "X." + "LEERGUT."     + G|sekundenz + "." + pid + 'M|aktzeile' + ".TMP"
.formula U|xtdat2 = "rmtmp/" + "X." + "LEERGUT.OUT." + G|sekundenz + "." + pid + 'M|aktzeile' + ".TMP"
.formula U|xtdat3 = "rmtmp/" + "X." + "LEERGUT.ERR." + G|sekundenz + "." + pid + 'M|aktzeile' + ".TMP"
..
.set trans +
.formula U|xbetr = "Dieser Lieferschein wurde fÅr die Leergutzubuchung angelegt"
.set trans -
..
.. ----------- ----- Events -------- -------------------------------------------
.continue VK ? F|empty(M|lief)
.continue EK ? F|empty(M|kunde)
.. ----------- ---------- ---------- -------------------------------------------
.continue END
..
..
!EK
.continue MLSNR  ?  F|empty(M|lsnr)
.output new 'U|xtdat'
.input "DATEI.F"
#!ACTION=NEW
#!DATABASE=4
#!GROUP=23
num;lief;vom;bem;betreff;ueb\
art;mge;rerelev;platz;ptext
'M|lsnr';'M|lief';.;'M|bem';'U|xbetr';'true'\
..
!LSE
.select screen line
.continue EDPSTART  ?  _G|mehr
.continue FM6       ?   M|tzeilen=0
.continue FM1       ? +'M|artikel'=0
.continue FM2       ?   M|mge=0
.formula U|xi = U|xi + 1
?'M|artikel^nummer';'M|mge';'false';'M|platz2^id';\ ? M|tzeilen > U|xi
?'M|artikel^nummer';'M|mge';'false';'M|platz2^id';  ? M|tzeilen = U|xi
.continue LSE
..
..
!VK
.output new 'U|xtdat'
.input "DATEI.F"
#!ACTION=NEW
#!DATABASE=3
#!GROUP=23
lsart;kunde;vom;bem;werk;ablstelle;edllsnr;edllsdat;betreff;dfuesenden;ueb\
art;mge;rerelev;platz;ptext
(CustomerDelivery);'M|kunde';.;'M|bem';'M|werk';'M|ablstelle';'M|lsnr';'M|beldat:8';'U|xbetr';'false';'true'\
..
!LS
.select screen line
.continue EDPSTART  ?  _G|mehr
.continue FM6       ?   M|tzeilen=0
.continue FM4       ?   F|empty(M|platz2)
.continue FM5       ?  _M|platz2^lgruppe^zkonsilg
.continue FM1       ? +'M|artikel'=0
.continue FM2       ?   M|mge=0
.continue FM3       ?   F|empty(M|kunde)
.formula U|xi = U|xi + 1
.formula U|xmge = M|mge
?'M|artikel^nummer';'U|xmge';'false';'M|platz2^id';\ ? M|tzeilen > U|xi
?'M|artikel^nummer';'U|xmge';'false';'M|platz2^id';  ? M|tzeilen = U|xi
.continue LS
..
..
!EDPSTART
.output new WERF.WEG
.formula U|xtsys = "edpimport.sh -p " +  'G|einmalpw' + " -c EKS -o fopmode=false"
.formula U|xtsys = U|xtsys + " -I " + 'U|xtdat' + " -r REF 1>" + 'U|xtdat2' + " 2> " + 'U|xtdat3'
.system 'U|xtsys' background
.continue EDPERR ? _G|mehr
..
!LSEINTR
.select from 'U|xtdat2' U|x1
.continue END ? _G|mehr
.select screen header
.. Im Edp-Aufruf wird mit -r REF die Referenz zurÅckgegeben
.assign M|vklsnr = U|x1
.formula M|statusz = G|icoukrit
.copy M|gebucht = G|TRUE
..*****************************************************************************
!END
.continue
..
!MLSNR
.error Bitte Lieferscheinnummer eintragen.
.cursor lsnr 0
.end 1
..
!FM1
.error Bitte Packmittel eintragen.
.cursor artikel 'M|aktzeile'
.end 1
..
!FM2
.error Bitte eine Menge eintragen.
.cursor mge 'M|aktzeile'
.end 1
..
!FM3
.error Bitte Kunde eintragen.
.cursor kunde 0
.end 1
..
!BGEBUCHT
.box Hinweis
Lieferschein wurde bereits gebucht.
.end 0
..
!EDPERR
.select screen header
.set trans +
.formula M|hinweis = "Kundenanlieferung konnte nicht angelegt werden." ? _F|empty(M|kunde)
.formula M|hinweis = "Lieferschein konnte nicht angelegt werden."      ? _F|empty(M|lief)
.set trans -
.formula M|statusz = G|icokrit
.editing -readonly 'U|xtdat3'
.end 1
..
!FM4
.error Bitte einen Lagerplatz aus einer Lagergruppe mit der Eigenschaft Fremdeigentum eintragen.
.cursor platz2 'M|aktzeile'
.end 1
..
!FM5
.error Eingetragener Lagerplatz ist kein Lagerplatz aus einer Lagergruppe mit der Eigenschaft Fremdeigentum. 
.cursor platz2 'M|aktzeile'
.end 1
..
!FM6
.error Keine Tabellenzeile vorhanden!
.end 1
