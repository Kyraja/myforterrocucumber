..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : DFUE.VKLS.MP
.. Author         : mh
.. Verantwortlich : mh
.. Kontrolle      :
.. Functionality  : Maskenpruefung VK-Lieferschein
..                  Pruefung notwendigen Daten fuer Lieferschein-DFUE
..*****************************************************************************
.set trans -
..
.set cancel --
..
.select screen header
..
.continue END  ?  G|evtmaskprio="-"
.continue END  ?  G|batchmode  &  _G|edp
.continue END  ?  M|tzeilen=0
.continue END  ? _M|dfuesenden
..
.type text  xvorgang
.type text  xtfehler
..
..
.. VALIDATE EDI PROTOCOLL
.. SHIPPING IS DONE EITHER TO THE EXTERNAL SERVICE PROVIDER OR TO THE CUSTOMER
..
.. Variable xDFUEproto will be defined and must not be empty after DFUE.GET.PROTOK
..
.. Must have EDI protocoll for external service provider (ESP)
.continue EEDL  ?  F|empty(M|edl)
.add M|edl
.formula U|xvorgang="VKLS"
.input "DFUE.GET.PROTOK"
.continue ERREDL2  ?  F|empty(U|xDFUEproto)
.add
!EEDL
..
.. Must have EDI protocoll for customer (if not shipping to ESP)
.continue EKUN  ? _(F|empty(M|edl))
.add M|kunde
.formula U|xvorgang="VKLS"
.input "DFUE.GET.PROTOK"
.continue ERRKUN2  ?  F|empty(U|xDFUEproto)
.add
!EKUN
..
..
.. VALIDATE REQURIED DATA FOR EDI-MESSAGING
..
.. Must have Supplier number in the customer's company for debitor
.continue ERRDEB1  ?  F|empty(M|kunde2^frbez)
..
.. Must have Supplier number in the customer's company for external service provider
.continue ERREDL4  ?  M|edl^gruppe=1 & F|empty(M|edl^frbez)
.continue ERREDL4  ?  M|edl^gruppe=2 & F|empty(M|edl^firma^frbez)
..
.. Must have shipping order (VDA/EDIFACT/ODETTE)
.continue ERRSPED  ?  F|empty(M|sped)  & (U|xDFUEproto=1 ; U|xDFUEproto=2 ; U|xDFUEproto=3 ; U|xDFUEproto=-1)
..
.. Must have address (if using shipping order)
.continue ERRANS   ? _F|empty(M|sped)  &  F|empty(M|ans)  &  F|empty(M|ans2)
..
.. Must have plant and unloading point (VDA)
.continue ERRWERK  ?  F|empty(M|werk)  & (U|xDFUEproto=1)
.continue ERRWERK  ?  F|empty(M|ablstelle)  & (U|xDFUEproto=1)
..
.. Must have shipping type (VDA)
.continue ERRVER1  ?  F|empty(M|versand)  & (U|xDFUEproto=1)
.continue ERRVER2  ?  F|empty(M|versand^schl)  & (U|xDFUEproto=1)
..
..*****************************************************************************
!END
.continue
..
..
!ERREDL2
.cursor edl 0
.set trans +
.formula U|xtfehler = "Kann öbertragungsprotokoll nicht ermitteln!"
.set trans -
.continue ERROR
..
!ERREDL4
.cursor edl 0
.set trans +
.formula U|xtfehler = "Lieferantennummer im EDL fehlt! Kundenstammsatz nachpflegen."
.set trans -
.continue ERROR
..
!ERRKUN2
.cursor kunde 0
.set trans +
.formula U|xtfehler = "Kann öbertragungsprotokoll nicht ermitteln!"
.set trans -
.continue ERROR
..
!ERRDEB1
.cursor kunde2 0
.set trans +
.formula U|xtfehler = "Lieferantennummer im Kunden fehlt! Kundenstammsatz nachpflegen."
.set trans -
.continue ERROR
..
!ERRSPED
.cursor sped 0
.set trans +
.formula U|xtfehler = "Speditionsauftrag fehlt! Oder Senden=nein setzen."
.set trans -
.continue ERROR
..
!ERRANS
.cursor ans2 0
.set trans +
.formula U|xtfehler = "Anschrift im Kunden eintragen oder Versandanschrift ausfÅllen!"
.set trans -
.continue ERROR
..
!ERRWERK
.cursor werk 0
.set trans +
.formula U|xtfehler = "Werk oder Abladestelle ist nicht eingetragen!"
.set trans -
.continue ERROR
..
!ERRVER1
.cursor versand 0
.set trans +
.formula U|xtfehler = "Versandart fehlt!"
.set trans -
.continue ERROR
..
!ERRVER2
.cursor versand 0
.set trans +
.formula U|xtfehler = F|formatstr("SchlÅssel in Versandart {1} fehlt!", 'M|versand')
.set trans -
.continue ERROR
..
..*****************************************************************************
..
!ERROR
.. add "orig" data to error message, i.e. order triggering the delivery
.. note: "orig" is attached to rows, if the error is triggered by a header field we grab the first row with orig data
..
.type text xtartikel
.type bool xborig
..
.select -
.copy U|xborig = G|false
.select screen line "$,;orig<>`" ? M|aktzeile = 0 & M|tzeilen>0
.continue ERRSHOW  ? _F|defined(M|orig)
.formula U|xborig = _F|empty(M|orig) &  F|defined(M|orig^kopf) &    F|defined(M|orig^artikel)
.formula U|xtartikel = 'M|orig^artikel'  ?  U|xborig
!ERRSHOW
.error 'U|xtfehler'  ? _U|xborig
.error Fehler zu Beleg 'M|orig^kopf^nummer', Kunde 'M|orig^kopf^kunde', Artikel 'U|xtartikel': 'U|xtfehler'  ?  U|xborig
.end 2
