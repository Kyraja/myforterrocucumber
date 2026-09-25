..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : DFUE.VKRE.MP
.. Author         : mh/ok/mh
.. Verantwortlich : mh
.. Kontrolle      :
.. Functionality  : Checks if data in sales invoice would be fit to create an
..                  edi invoice using DFUE.VK2EDI.
..*****************************************************************************
.set trans -
..
.input "ARB"
.input "KAKTNAME.KONST"
..
.. variable definitions
..@@BEGINVARDEFS
..====================================================
..**ok,02.04.2002 (neu xprocreturn)
.type bool  xprocreturn
..**ok,23.03.2001 (neu xIstPackm)
.type bool  xIstPackm
.type text  xablade
.type bool  xbartpos
.type integer   xDFUEproto
.type text  xdPARAM
.type text  xfeldpos
.type text  xkunde
.type text  xland
.type bool  xmehr
..
.type text  xPosMgeEinheit
.type bool  xbFehler
.type text  xsys
.type text  xTmpText
..
..... procedure stack pointer .....
.type integer   xprocsp
.type text  xStSchl
.type text  xtxt1
.type text  xtxt2
.type PS97:1  xUrland
.type text  xUrsprung
.type text  xvorgang
.type text  xWEinheit
.type text  xwerk
.type integer   xzeile
..**ok,24.10.2002 (jetzt die Variable xGruppe NEU)
.type text  xGruppe
..
..**mh, 20.09.2010: ist die eigene Firma in der EU?
.type bool xobeuland
.type PS97:1 xInland
..
.. mh, 31.01.2017: define missing variables
.type text xposphe
..====================================================
..@@ENDVARDEFS
..
.. initialize procedure stack pointer
.formula xprocsp = 0
.. alle variablen mÅssen definiert sein, sonst bricht das programm ab
.set demand -
..
.. ----------------------------------------
.continue EPROCDEF
.. procedure definitions
..
!PROC001: ----- FEHLER -----
.box Fehler
'xtxt1'
'xtxt2'
.. evtl. positionieren
.cursor 'xfeldpos' 'xzeile' ? +xfeldpos > 0
.end 1
..
.continue 'xprocst.xprocsp'
..
!EPROCDEF: ----- end procedure definitions -----
.. ----------------------------------------
..
.. khuelskaemper 2024 Ob das Land des Mandanten in der EU ist
.. istInEU = (euKennung != '') AND (austritt='' OR (austritt > heute))
.formula U|xInland = F|sysinfo(10)^staat
.formula U|xobeuland = (U|xInland^egkenn <> "") & (('U|xInland^egbis:8' = "") ; ('U|xInland^egbis:8' > 'G|datum:8'))
..
.. aller anfang ist im kopf
.select screen header
..
.. **ok,19.05.2003 Wenn Rechnungsbetrag 0 ist wird dfuesenden auf "nein" gesetzt.
.. **ok,05.06.2003 Weil rebetr beim SCREEN_VALIDATION 0 ist, musss das EFOP beim SCREEN_EXIT angeschaltet werden
..
.. 31.01.2017 for downpayment dfuesenden is set to false; has to be done on VALIDATION
..
.continue NOEDI ? 'M|vorganga(L=":")'="(Downpayment)" & G|evtartengl="SCREEN_VALIDATION"
.continue NOEDI ? 'M|vorganga(L=":")'="(InvoiceReversal)" & G|evtartengl="SCREEN_VALIDATION"
.continue NOEDI ?  M|rebetr = 0 & G|evtartengl="SCREEN_EXIT"
.continue EL001
.. IF001
!NOEDI
.copy M|dfuesenden = G|false
.rewrite screen
..
!EL001
.. FI001
..
..
.continue EL002 ? _((m|dfuesenden) & (m|tzeilen > 0))
.. IF002
.. nur, wenn die rechnung per dfue versendet wird mu· ich pruefen
..
..initialisierung die parameterdatei
..**ok,07.01.2003 (xarb wurde entfernt)
.formula xdPARAM = "dfue/DFUE.EXP.INI"
.input 'xdPARAM'
..
.. vorgangsart fÅr edinfo
.formula xvorgang = "VKRE"
..
.. öbertragungsprotokoll
.. ----------------------------------------
.add m|kunde2
..
.continue EL003 ? _(mehr)
.. IF003
.. erst mal kein protokoll
.formula xDFUEproto = -1
.input 'xdGetProtokoll'
..
..
.continue EL004 ? _(xDFUEproto < 0)
.. IF004
.set trans +
.formula xtxt1 = "Kann öbertragungsprotokoll nicht ermitteln!"
.set trans -
.formula xtxt2 = ""
.formula xfeldpos = ""
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET001"
.continue PROC001
!RET001
.formula xprocsp = xprocsp - 1
..
!EL004
.. FI004
..
.continue FI003
!EL003
.set trans +
.formula xtxt1 = 'F|formatstr("Kann Kunden {1} nicht lesen!", m|kunde2)'
.set trans -
.formula xtxt2 = ""
.formula xfeldpos = ""
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET002"
.continue PROC001
!RET002
.formula xprocsp = xprocsp - 1
..
!FI003
..
.add
.. ----------------------------------------
..
.. xDfueProto=1
..
.continue EL005 ? _(xDFUEproto = 1)
.. IF005
.. prÅfungen fÅr VDA-protokoll
..
.. Lieferantennummer und Umsatzsteuerid pruefen
..
.continue EL006 ? _(F|empty(m|kunde2^frbez))
.. IF006
.set trans +
.formula xtxt1 = "Lieferantennummer im Kunden fehlt!"
.formula xtxt2 = "Kundenstammsatz nachpflegen."
.set trans -
.formula xfeldpos = "kunde2"
.formula xzeile = 0
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET003"
.continue PROC001
!RET003
.formula xprocsp = xprocsp - 1
..
!EL006
.. FI006
..
..**hs,01.08.2000, +ustid=0 -> +ustid=0 & laart="E"
..**ok,07.03.2003, Umsatz-Steuer wird nicht verlangt, wenn in der Maske "Steuerfrei" manuell auf "ja" gesetzt ist
..**ok,10.02.2004 (steuer --> steuerfrei)
..**mh,20.09.2010: Ist die eigene Firma in der EU?  & U|xobeuland
..
..
.continue EL007 ? _((+m|ustid = 0) & (m|kunde2^laart = "E") & ('m|ustart(L="0")' = "(84)") & (U|xobeuland))
.. IF007
.set trans +
.formula xtxt1 = "Umsatzsteuer-Identifikationsnummer fehlt!"
.formula xtxt2 = "Kundenstammsatz nachpflegen."
.set trans -
.formula xfeldpos = "ustid"
.formula xzeile = 0
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET004"
.continue PROC001
!RET004
.formula xprocsp = xprocsp - 1
..
!EL007
.. FI007
..
.. Pruefen eigene Umsatzsteuer-ID aus dem Betriebsdatensatz
..
..
.continue EL008 ? _(('F|sysinfo(10)^ustid' = "") & (U|xobeuland))
.. IF008
.set trans +
.formula xtxt1 = "Umsatzsteuer-Identifikationsnummer im Betriebsdatensatz fehlt!"
.set trans -
.formula xtxt2 = ""
.formula xfeldpos = ""
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET005"
.continue PROC001
!RET005
.formula xprocsp = xprocsp - 1
..
!EL008
.. FI008
..
.. Werk und Abladestelle pruefen
..
.continue EL009 ? _((+m|werk = 0) ; (+m|ablstelle = 0))
.. IF009
.set trans +
.formula xtxt1 = "Entweder Werk oder Abladestelle ist nicht eingetragen!"
.formula xtxt2 = ""
.set trans -
.formula xfeldpos = "werk"
.formula xzeile = 0
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET006"
.continue PROC001
!RET006
.formula xprocsp = xprocsp - 1
..
!EL009
.. FI009
..
.. Zeichen des Bestellers
..
.continue EL010 ? _(+m|frzeich = 0)
.. IF010
.set trans +
.formula xtxt1 = "Kein Bearbeiterkennzeichen des Kunden eingetragen"
.set trans -
.formula xtxt2 = ""
.formula xfeldpos = "frzeich"
.formula xzeile = 0
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET007"
.continue PROC001
!RET007
.formula xprocsp = xprocsp - 1
..
!EL010
.. FI010
..
.. Schluessel fÅr Waehrung aus Kurstabelle holen
..**ok,20.06.2005 (jetzt nicht mehr die Kurstabelle sondern direkt den WÑhrungsdatensatz holen)
.formula xland = m|land<<" "
.formula xWEinheit = ""
.load 1 currency 'M|land'
..
..
.continue EL011 ? _(mehr)
.. IF011
.. Numerische WÑhrungscode nach ISO 4217
.formula xWEinheit = 1|iso3n
..
..
.continue EL012 ? _(+xWEinheit = 0)
.. IF012
.set trans +
.formula xtxt1 = 'F|formatstr("SchlÅssel fÅr WÑhrungseinheit {1} fehlt!", xland)'
.formula xtxt2 = ""
.set trans -
.formula xfeldpos = "land"
.formula xzeile = 0
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET008"
.continue PROC001
!RET008
.formula xprocsp = xprocsp - 1
..
!EL012
.. FI012
..
.continue FI011
!EL011
.set trans +
.formula xtxt1 = "Kann nicht auf die WÑhrung zugreifen!"
.set trans -
.formula xtxt2 = ""
.formula xfeldpos = ""
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET009"
.continue PROC001
!RET009
.formula xprocsp = xprocsp - 1
..
!FI011
..
.. .. wurde Åber einen Lieferschein fakturiert
.. und ist werk/abladestelle immer gleich
.. init
.formula xbartpos = false
.formula xwerk = m|werk
.formula xablade = m|ablstelle
..
.. ----------------------------------------
.select -
.select screen header
.select screen line
..
!LOOP001: ==============================
.continue ELOP001 ? _(mehr)
..
.continue EL013 ? _(F|empty(M|artex))
.. IF013
.continue FI013
!EL013
..**ok,01.07.2005 (jetzt mit gruppe bei "typ=arpos" die Zusatzpositionen mit Typ "AU/BE-Position,BV" berÅcksichtigt)
..
..
.continue EL014 ? _(typ = arpos)
.. IF014
..
.continue EL015 ? _(M|artex^gruppe=1)
.. IF015
.. Zeilen-Verarbeitung Artikel
.. ich suche nach richtigen artikeln
.formula xbartpos = true
.formula xIstPackm = m|art^packmit
..
..
.continue EL016 ? _(xIstPackm)
.. IF016
.continue FI016
!EL016
.. ----------------------------------------
.. woraus bin ich entstanden
.add okopf
..
.continue EL017 ? _(mehr)
.. IF017
..
.continue EL018 ? _(typ <> liko)
.. IF018
.. Kein Lieferschein
.set trans +
.formula xtxt1 = "Es wurde nicht Åber Lieferschein fakturiert."
.formula xtxt2 = "öbertragen per DFö unmîglich!"
.set trans -
.formula xfeldpos = "artex"
.formula xzeile = aktzeile
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET010"
.continue PROC001
!RET010
.formula xprocsp = xprocsp - 1
..
.continue FI018
!EL018
.. Lieferschein-PrÅfung
.. Werk und Abladestelle prÅfen
..
.continue EL019 ? _((xwerk <> d|kunde^werk) ; (xablade <> d|kunde^ablstelle))
.. IF019
.set trans +
.formula xtxt1 = "Werk o. Abladestelle dieser LS-Position pa·t nicht zu denen im Kopf!"
.formula xtxt2 = ""
.set trans -
.formula xfeldpos = "artex"
.formula xzeile = aktzeile
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET011"
.continue PROC001
!RET011
.formula xprocsp = xprocsp - 1
..
!EL019
.. FI019
..
..**ok,26.03.2002 (PrÅfung wenn NICHT Sammelabrechnungsvorschl.liste)
..
..**ok,05.06.2003 (beim éndern-Modus und beim Maskenaustritt nichts eingetragen)
..
..
.continue EL020 ? _(evtmaskprio<>"-")
.. IF020
..
.continue EL021 ? _(evtkommd <> 'T|kaktname.koaktaendern')
.. IF021
..
.continue EL022 ? _(evtartengl<>"SCREEN_VALIDATION")
.. IF022
.. ----------------------------------------
.add okopf
.. NEU: EDL und Rahmen prÅfen
..**ok,20.12.2001 (NEU: PrÅfung EDL-Eintrag, wenn Eintrag da, Rahmen leer, Rahmen finden und eintragen)
..**ok,09.09.2003 (unten statt d|rahmen jetzt m|zrahmen geprÅft)
..
..
.continue EL023 ? _((d|edl<>"") & (m|zrahmen=""))
.. IF023
..**ok,26.03.2002 (jetzt statt mit "kunde" --> mit "werk" und "ablstelle" gesucht)
..
.. Suche nach Rahmenauftrag
.formula xtsel = "$,,;@gruppe=2;kotyp=(BlanketOrder);artex=" + 'm|art^id'
.formula xtsel = xtsel + ";kopf^werk=" + d|werk + ";kopf^ablstelle=" + d|ablstelle
..ok,26.03.2002 (wenn nur mit Werk gesucht werden soll, statt obere die untere Zeile aktivieren)
..              .fo xtsel = xtsel + ";kopf^werk=" + d|werk
..**ok,09.09.2003 (ablagef=nein wurde hinzugefÅgt)
.formula xtsel = xtsel + ";kopf^verwschl=" + d|verwschl + ";ablagef=no;@ablageart=(3)"
..
.. ----------------------------------------
.reserve
.select sales 'xtsel'
..
..
.continue EL024 ? _(mehr)
.. IF024
.formula m|zrahmen = H|kopf
..
!EL024
.. FI024
..
.select
.. ----------------------------------------
..
!EL023
.. FI023
..
.add
.. ----------------------------------------
..
!EL022
.. FI022
..
!EL021
.. FI021
..
!EL020
.. FI020
..
!FI018
..
.continue FI017
!EL017
.. Fehlermeldung
.set trans +
.formula xtxt1 = "Es wurde nicht Åber Lieferschein fakturiert."
.formula xtxt2 = "öbertragen per DFö unmîglich!"
.set trans -
.formula xfeldpos = "artex"
.formula xzeile = aktzeile
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET012"
.continue PROC001
!RET012
.formula xprocsp = xprocsp - 1
..
!FI017
..
.add
.. ----------------------------------------
..
!FI016
..
!EL015
.. FI015
..
!EL014
.. FI014
..
!FI013
..
.select screen line
..
.continue LOOP001
!ELOP001: ==============================
..
.select screen header
.. ----------------------------------------
..
..
.continue EL025 ? _(_(xbartpos))
.. IF025
.set trans +
.formula xtxt1 = "Es fehlt eine Artikelposition!"
.set trans -
.formula xtxt2 = ""
.formula xfeldpos = ""
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET013"
.continue PROC001
!RET013
.formula xprocsp = xprocsp - 1
..
!EL025
.. FI025
..
.. Abschlu·bestellnummern und Artikelnummern des Bestellers prÅfen
.. Preiseinheit und Ursprungsland des Artikels prÅfen
.. SteuerschlÅssel aller Konten in Artikelposition mu· gleich sein
.. Reihenfolge der Versand/Verpackungskosten u. Artikel prÅfen
.. init
.formula xStSchl = ""
..
.formula xbartpos = false
..
.select -
.select screen header
.select screen line
..
..
!LOOP002: ==============================
.continue ELOP002 ? _(mehr)
..
.continue EL026 ? _(F|empty(M|artex))
.. IF026
.continue FI026
!EL026
..
.continue EL027 ? _(typ = arpos)
.. IF027
.. Zeilen-Verarbeitung Artikel
..**ok,01.07.2005 (jetzt mit gruppe bei "typ=arpos" die Zusatzpositionen "AU/BE-Position,BV" geprÅft)
..
..
.continue EL028 ? _(m|art^gruppe=1)
.. IF028
.. nur echte artikelpositionen werden geprueft
.formula xbartpos = true
..**ok,23.03.2001 (es wird jetzt geprÅft, ob Packmittel)
.formula xIstPackm = M|artex^packmit
..
..
.continue EL029 ? _(xIstPackm)
.. IF029
.continue FI029
!EL029
..**ok,26.03.2002 (PrÅfung wenn NICHT Sammelabrechnungsvorschl.liste)
..
..
.continue EL030 ? _(evtmaskprio<>"-")
.. IF030
.. Rahmenvertrag
..
.continue EL031 ? _(+m|zrahmen = 0)
.. IF031
.set trans +
.formula xtxt1 = "Abschlussbestellnummer (Rahmenvertrag) fehlt."
.set trans -
.formula xtxt2 = ""
.formula xfeldpos = "zrahmen"
.formula xzeile   = aktzeile
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET014"
.continue PROC001
!RET014
.formula xprocsp = xprocsp - 1
..
!EL031
.. FI031
..
!EL030
.. FI030
..
!FI029
..
.. Kundenartikelnr, Ursprungsland-SchlÅssel und Preiseinheit
..
.continue EL032 ? _(F|empty(M|zkuartnr))
.. IF032
.set trans +
.formula xtxt1 = "Kundenartikelnummer fehlt im Artikel!"
.set trans -
.formula xtxt2 = ""
.formula xfeldpos = "artex"
.formula xzeile = aktzeile
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET015"
.continue PROC001
!RET015
.formula xprocsp = xprocsp - 1
..
!EL032
.. FI032
..
.. LÑnderschlÅssel fÅr Ursprungsland suchen
.. Nur wenn ein Ursprungsland angegeben ist, wird der SchlÅssel geprÅft!
.copy U|xUrland = M|purland
.formula xUrsprung = M|purland^ischl
..
..
.continue EL033 ? _((_F|empty(T|xUrland)) & (F|empty(T|xUrsprung)))
.. IF033
.set trans +
.formula xtxt1 = 'F|formatstr("LÑnderschlÅssel fÅr Land {1} fehlt!", xUrland)'
.set trans -
.formula xtxt2 = ""
.formula xfeldpos = ""
.formula xzeile = aktzeile
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET016"
.continue PROC001
!RET016
.formula xprocsp = xprocsp - 1
..
!EL033
.. FI033
..
..
.continue EL034 ? _((_(m|pehe = 1)) & (_(m|pehe = 0,01)) & (_(m|pehe = 0,001)))
.. IF034
.set trans +
.formula xtxt1 = "Falsche Preiseinheit im Artikel!"
.formula xtxt2 = "Erlaubt sind 1 oder 0,01  oder  0,001 ."
.set trans -
.formula xfeldpos = "pehe"
.formula xzeile = aktzeile
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET017"
.continue PROC001
!RET017
.formula xprocsp = xprocsp - 1
..
!EL034
.. FI034
..
.. SteurschlÅssel
.add M|psteuer
..
.continue EL025 ? _G|mehr
.continue EL035 ? _(F|empty(U|xStSchl) & _D|nullsts)
.. IF035
.formula U|xStSchl = M|psteuer
..
.continue FI035
!EL035
..
.continue EL036 ? _(U|xStSchl <> 'M|psteuer'  & _D|nullsts)
.. IF036
.set trans +
.formula U|xtxt1 = "SteuerschlÅssel stimmt nicht mit darÅberliegenden Positionen Åberein!"
.formula U|xtxt2 = ""
.set trans -
.formula U|xfeldpos = "artex"
.formula U|xzeile = aktzeile
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET018"
.continue PROC001
!RET018
.formula xprocsp = xprocsp - 1
..
!EL036
.. FI036
..
!FI035
..
.add
..
!EL028
.. FI028
..
.continue FI027
!EL027
.. Zeilen-Verarbeitung Sonstiges
..
.continue EL037 ? _(_((typ = zspos) ; (typ = supos) ; (typ = espos) ; (typ = stpos)))
.. IF037
..
.continue EL038 ? _(typ = trpos)
.. IF038
.. trennposition
.. -> sammelrechnung
.. -> next ls
.formula xbartpos = false
..
.continue FI038
!EL038
..
.continue EL039 ? _(mehr)
.. IF039
..
.continue FI040 ? 'M|artex^kategorie(L=":")'="(Downpayment)"
.continue EL040 ? _(_((M|artex^such / -xSwVersand) ; (M|artex^such / -xSwVerpackung)))
.. IF040
.. Fehler Verpackung/Versand
.set trans +
.formula xtxt1 = "Nur Versand- o. Verpackungskosten erlaubt!"
.set trans -
.formula xtxt2 = ""
.formula xfeldpos = "artex"
.formula xzeile = aktzeile
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET019"
.continue PROC001
!RET019
.formula xprocsp = xprocsp - 1
..
.continue FI040
!EL040
..
.continue EL041 ? _(xbartpos)
.. IF041
.. Fehler Verpackung/Versand (Reihenfolge)
.set trans +
.formula xtxt1 = "Versand- o. Verpackungskosten stehen an falscher Stelle!"
.set trans -
.formula xtxt2 = ""
.formula xfeldpos = "artex"
.formula xzeile = aktzeile
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET020"
.continue PROC001
!RET020
.formula xprocsp = xprocsp - 1
..
!EL041
.. FI041
..
!FI040
..
!EL039
.. FI039
..
!FI038
..
!EL037
.. FI037
..
!FI027
..
!FI026
..
.select screen line
..
.continue LOOP002
!ELOP002: ==============================
..
!EL005
.. FI005
..
.. xDfueProto=3
..
.continue EL042 ? _(xDFUEproto = 3)
.. IF042
.. PrÅfungen fÅr EDIFACT-Protokoll
..
.. Kunde2
.. ----------------------------------------
.add m|kunde2
..
.continue EL043 ? _(mehr)
.. IF043
..
.continue EL044 ? _(+d|frbez = 0)
.. IF044
.set trans +
.formula xtxt1 = "Lieferantennummer im Kunden fehlt!"
.formula xtxt2 = "Kundenstammsatz nachpflegen."
.set trans -
.formula xfeldpos = "kunde2"
.formula xzeile = 0
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET021"
.continue PROC001
!RET021
.formula xprocsp = xprocsp - 1
..
!EL044
.. FI044
..
.. Anschrift
..**hs 28.08.2000 xBmitAdressen
..in DFUE.EXP.INI kann mit der Variable
..xBmitAdressen die PrÅfung von Adressen/Anschriften
..gesteuert werden
..
..
.continue EL045 ? _(xBmitAdressen)
.. IF045
..
.continue EL046 ? _((d|ans<<";")="")
.. IF046
.set trans +
.formula xtxt1 = 'F|formatstr("In Kunde: {1} 1.Zeile von Anschrift pflegen", d|num)'
.formula xtxt2 = "Diese Angabe wird weitergegeben"
.set trans -
.formula xfeldpos = "kunde2"
.formula xzeile = 0
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET022"
.continue PROC001
!RET022
.formula xprocsp = xprocsp - 1
..
!EL046
.. FI046
..
.. PLZ
..
.continue EL047 ? _(d|plz="")
.. IF047
.set trans +
.formula xtxt1 = 'F|formatstr("In Kunde: {1} die Postleitzahl pflegen", d|num)'
.formula xtxt2 = "Diese Angabe wird weitergegeben"
.set trans -
.formula xfeldpos = "kunde2"
.formula xzeile = 0
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET023"
.continue PROC001
!RET023
.formula xprocsp = xprocsp - 1
..
!EL047
.. FI047
..
.. Strasse
..
.continue EL048 ? _(d|str="")
.. IF048
.set trans +
.formula xtxt1 = 'F|formatstr("In Kunde: {1} die Stra·e pflegen", d|num)'
.formula xtxt2 = "Diese Angabe wird weitergegeben"
.set trans -
.formula xfeldpos = "kunde2"
.formula xzeile = 0
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET024"
.continue PROC001
!RET024
.formula xprocsp = xprocsp - 1
..
!EL048
.. FI048
..
.. Ort Zeile1
..
.continue EL049 ? _((d|nort<<";")="")
.. IF049
.set trans +
.formula xtxt1 = 'F|formatstr("In Kunde: {1} den Ort pflegen", d|num)'
.formula xtxt2 = "Diese Angabe wird weitergegeben"
.set trans -
.formula xfeldpos = "kunde2"
.formula xzeile = 0
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET025"
.continue PROC001
!RET025
.formula xprocsp = xprocsp - 1
..
!EL049
.. FI049
..
!EL045
.. FI045
..
..**ok,20.06.2005 (PrÅfung der Bankverbindung wurde etfernt)
..
.continue FI043
!EL043
.set trans +
.formula xtxt1 = 'F|formatstr("Kann Kunden {1} nicht lesen!", m|kunde2)'
.set trans -
.formula xtxt2 = ""
.formula xfeldpos = ""
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET026"
.continue PROC001
!RET026
.formula xprocsp = xprocsp - 1
..
!FI043
..
.add
.. ----------------------------------------
..
.. Ustid in RE
..**hs,01.08.2000, +ustid=0 -> +ustid=0 & laart="E"
..**ok,07.03.2003, Umsatz-Steuer wird nicht verlangt, wenn in der Maske "Steuerfrei" manuell auf "ja" gesetzt ist
..**ok,10.02.2004 (steuer --> steuerfrei)
..
..
.continue EL050 ? _((+m|ustid = 0) & (m|kunde2^laart = "E") & ('m|ustart(L="0")' = "(84)") & (U|xobeuland))
.. IF050
.set trans +
.formula xtxt1 = "Umsatzsteuer-Identifikationsnummer fehlt!"
.formula xtxt2 = "Kundenstammsatz nachpflegen und anschliessend Kunde neu eintragen"
.set trans -
.formula xfeldpos = "ustid"
.formula xzeile = 0
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET027"
.continue PROC001
!RET027
.formula xprocsp = xprocsp - 1
..
!EL050
.. FI050
..
.. schlÅssel fÅr wÑhrung aus kurstabelle holen
..**ok,20.06.2005 (jetzt nicht mehr die Kurstabelle sondern direkt den WÑhrungsdatensatz holen)
.formula xland = m|land<<" "
.formula xWEinheit = ""
.load 1 currency 'M|land'
..
..
.continue EL051 ? _(mehr)
.. IF051
.. Numerische WÑhrungscode nach ISO 4217
.formula xWEinheit = 1|iso3n
..
..
.continue EL052 ? _(+xWEinheit = 0)
.. IF052
.set trans +
.formula xtxt1 = 'F|formatstr("SchlÅssel fÅr WÑhrungseinheit {1} fehlt!", xland)'
.formula xtxt2 = ""
.set trans -
.formula xfeldpos = "land"
.formula xzeile = 0
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET028"
.continue PROC001
!RET028
.formula xprocsp = xprocsp - 1
..
!EL052
.. FI052
..
.continue FI051
!EL051
.set trans +
.formula xtxt1 = "Kann nicht auf die WÑhrung zugreifen!"
.set trans -
.formula xtxt2 = ""
.formula xfeldpos = ""
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET029"
.continue PROC001
!RET029
.formula xprocsp = xprocsp - 1
..
!FI051
..
.. Zeilen
.. init
.formula xStSchl = ""
..
.formula xbartpos = false
..
.select -
.select screen header
.select screen line
..
..
!LOOP003: ==============================
.continue ELOP003 ? _(mehr)
..
.continue EL053 ? _(F|empty(M|artex))
.. IF053
.continue FI053
!EL053
..**ok,24.10.2002 (jetzt mit xGruppe bei "typ=arpos" die Zusatzpositionen mit Typ "AU/BE-Position,BV" berÅcksichtigt)
.formula xPosMgeEinheit = ""
.formula xGruppe = M|artex^gruppe
..
..
.continue EL054 ? _((typ = arpos) & (xGruppe = "1"))
.. IF054
.. nur echte artikelpositionen werden geprueft
.formula xbartpos = true
..
.. Zeilen-Verarbeitung Artikel
.. ----------------------------------------
.add m|artex
..
.continue EL055 ? _(mehr)
.. IF055
.. PrÅfung ob Verkaufspreiseinheit (vpe) in der Einheit einen ISO-Eintrag hat
.formula U|xposphe = 'D|vpe(L=":")'
..
.input "EDI.UNITS"
..
..
.continue EL056 ? _(F|empty(U|eiso))
.. IF056
.. Fehler: Verkaufseinheit hat kein ISO-7372 Einheit
.set trans +
.formula xtxt1 = 'F|formatstr("Falsche Verkaufs-Preiseinheit {1} im Artikel!", xposMgeEinheit)'
.formula xtxt2 = "Erlaubt sind Einheiten nach ISO 7372 wie z.B. kg/KGM g/GRM m/MTR cm/CMT mm/MMT StÅck/PCE Paar/NPR"
.set trans -
.formula xfeldpos = ""
.formula xzeile = aktzeile
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET030"
.continue PROC001
!RET030
.formula xprocsp = xprocsp - 1
..
!EL056
.. FI056
..
!EL055
.. FI055
..
.add
.. ----------------------------------------
..
..
.continue EL057 ? _((_(m|pehe = 1)) & (_(m|pehe = 0,01)) & (_(m|pehe = 0,001)))
.. IF057
.set trans +
.formula xtxt1 = "Falsche Preiseinheit im Artikel!"
.formula xtxt2 = "Erlaubt sind 1 oder 0,01  oder  0,001 ."
.set trans -
.formula xfeldpos = "pehe"
.formula xzeile = aktzeile
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET031"
.continue PROC001
!RET031
.formula xprocsp = xprocsp - 1
..
!EL057
.. FI057
..
!EL054
.. FI054
..
!FI053
..
.select screen line
..
.continue LOOP003
!ELOP003: ==============================
..
.. <Firma>BETR
.. eigene umsatzsteuer-ID steht im betriebsdatensatz
.select company "$,,;gruppe=10;@gruppe=10"
..
..
.continue EL058 ? _(mehr)
.. IF058
..
.continue EL059 ? _((h|ans<<";") = "")
.. IF059
.set trans +
.formula xtxt1 = "Anschrift im Betriebsdatensatz fehlt!"
.formula xtxt2 = "Diese Angabe wird weitergegeben"
.set trans -
.formula xfeldpos = ""
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET032"
.continue PROC001
!RET032
.formula xprocsp = xprocsp - 1
..
!EL059
.. FI059
..
.. PLZ
..
.continue EL060 ? _(+h|plz = 0)
.. IF060
.set trans +
.formula xtxt1 = "PLZ im Betriebsdatensatz fehlt!"
.formula xtxt2 = "eigene Postleitzahl"
.set trans -
.formula xfeldpos = ""
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET033"
.continue PROC001
!RET033
.formula xprocsp = xprocsp - 1
..
!EL060
.. FI060
..
.. Strasse
..
.continue EL061 ? _(+h|str = 0)
.. IF061
.set trans +
.formula xtxt1 = "Stra·e im Betriebsdatensatz fehlt!"
.set trans -
.formula xtxt2 = ""
.formula xfeldpos = ""
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET034"
.continue PROC001
!RET034
.formula xprocsp = xprocsp - 1
..
!EL061
.. FI061
..
.. Ort
..
.continue EL062 ? _(+(h|nort<<";") = 0)
.. IF062
.set trans +
.formula xtxt1 = "Ort im Betriebsdatensatz fehlt!"
.formula xtxt2 = "Diese Angabe wird weitergegeben"
.set trans -
.formula xfeldpos = ""
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET035"
.continue PROC001
!RET035
.formula xprocsp = xprocsp - 1
..
!EL062
.. FI062
..
.. ustid
..
.continue EL063 ? _((+h|ustid = 0) & (U|xobeuland))
.. IF063
.set trans +
.formula xtxt1 = "Umsatzsteuer-Identifikationsnummer im Betriebsdatensatz fehlt!"
.formula xtxt2 = "Diese Angabe wird weitergegeben"
.set trans -
.formula xfeldpos = ""
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET036"
.continue PROC001
!RET036
.formula xprocsp = xprocsp - 1
..
!EL063
.. FI063
..
.continue FI058
!EL058
.set trans +
.formula xtxt1 = "Kann Betriebsdatensatz nicht lesen!"
.set trans -
.formula xtxt2 = ""
.formula xfeldpos = ""
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET037"
.continue PROC001
!RET037
.formula xprocsp = xprocsp - 1
..
!FI058
..
.select -
..
.. Geldtransitkonto xIdDfueExKonto
.. ist das Geldtransitkonto xIdDfueExKonto  gefÅllt
..
.reserve
..
..
.continue EL064 ? _(xIdDfueExKonto<>"")
.. IF064
.. Konto ( Geld-Transitkonto ) eingetragen ( Rechnungen edifact )
.. (sh. DFUE.EXP.INI xIdDfueExKonto = 'xIdDfueExKonto')
..
.. Konto prÅfen
.select account 'xIdDfueExKonto'
..
..
.continue EL065 ? _(mehr)
.. IF065
..**mh, 01.02.2007: PrÅfen ob im Geldtransitkonto eine vollstÑndige Bankverbindung (H|bverb) vorhanden ist
.type bool xbfehlerbankverb
.formula T|xbfehlerbankverb = false
.formula T|xbfehlerbankverb = true ? H|bverb = ""
.formula T|xbfehlerbankverb = true ? H|bverb^bname = "" ; H|bverb^konum = "" ; H|bverb^nident = ""
..
..
.continue EL066 ? _(T|xbfehlerbankverb)
.. IF066
.set trans +
.formula T|xtxt1 = 'F|formatstr("Die Angaben zur Bankverbindung fÅr das Geldtransitkonto {1} sind unvollstÑndig.", T|xiddfueexkonto)'
.formula T|xtxt2 = "PrÅfen Sie bitte die Felder Bankname, Nationale Bankidentifikation und Bankkontonummer."
.set trans -
.formula xfeldpos = ""
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET038"
.continue PROC001
!RET038
.formula xprocsp = xprocsp - 1
..
!EL066
.. FI066
..
.continue FI065
!EL065
.. Fehler:falscher Eintrag
.set trans +
.formula xtxt1 = 'F|formatstr("Konto {1} nicht gefunden", xIdDfueExKonto)'
.formula xtxt2 = "Variable xIdDfueExKonto in DFUE.EXP.INI pflegen"
.set trans -
.formula xfeldpos = ""
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET039"
.continue PROC001
!RET039
.formula xprocsp = xprocsp - 1
..
!FI065
..
.continue FI064
!EL064
.. Fehler:kein Eintrag
.set trans +
.formula xtxt1 = "Konto nicht eingetragen (Geld-Transitkonto)"
.formula xtxt2 = "Variable xIdDfueExKonto in DFUE.EXP.INI pflegen"
.set trans -
.formula xfeldpos = ""
..
.formula xprocsp = xprocsp + 1
.type text xprocst.xprocsp ? _defined(xprocst.xprocsp)
.formula xprocst.xprocsp = "RET040"
.continue PROC001
!RET040
.formula xprocsp = xprocsp - 1
..
!FI064
..
.select
..
!EL042
.. FI042
..
!EL002
.. FI002
..
