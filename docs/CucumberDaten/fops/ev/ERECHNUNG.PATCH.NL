..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : ERECHNUNG.PATCH.NL
.. Author         : cl
.. Verantwortlich : cl
.. Kontrolle      : mh
.. Functionality  : Nachlaeuferprogramm Eingehende E-Rechnungen
.. Erlaubnisse pruefen: F|cmdpermitted(Datenbanknummer[,Kommandonummer][,Passwort][,Datenbankgruppe])
..
..*****************************************************************************
.type text xsys         ? _F|defined(U|xsys)
.type text xtsel        ? _F|defined(U|xtsel)
.type bool xdatenexport ? _F|defined(U|xdatenexport)
.type bool xjediconfig  ? _F|defined(U|xjediconfig)
.type bool xzugferd     ? _F|defined(U|xzugferd)
.type text xtmpfile     ? _F|defined(U|xtmpfile)
.type text xtout        ? _F|defined(U|xtout)
.type text xterr        ? _F|defined(U|xterr)
.type text xterror0     ? _F|defined(U|xterror0)
.type text xterror1     ? _F|defined(U|xterror1)
.type text xterror2     ? _F|defined(U|xterror2)
.type text xterror3     ? _F|defined(U|xterror3)
.type text xterror4     ? _F|defined(U|xterror4)
.type text xterror5     ? _F|defined(U|xterror5)
.type text xterror6     ? _F|defined(U|xterror6)
.type text xterror7     ? _F|defined(U|xterror7)
.type text xterror8     ? _F|defined(U|xterror8)
.type text xterror9     ? _F|defined(U|xterror9)
.type text xterror10    ? _F|defined(U|xterror10)
.type text xterror11    ? _F|defined(U|xterror11)
.type text xterror13    ? _F|defined(U|xterror13)
.type text xterror14    ? _F|defined(U|xterror14)
.type text xterror15    ? _F|defined(U|xterror15)
.type text xterror17    ? _F|defined(U|xterror17)
.type text xterror18    ? _F|defined(U|xterror18)
.type text xterror19    ? _F|defined(U|xterror19)
.type text xterror21    ? _F|defined(U|xterror21)
.type text xterror22    ? _F|defined(U|xterror22)
.type text xterror23    ? _F|defined(U|xterror23)
.type text xterror25    ? _F|defined(U|xterror25)
.type text xterror26    ? _F|defined(U|xterror26)
.type text xterror27    ? _F|defined(U|xterror27)
.type text xterror29    ? _F|defined(U|xterror29)
.type text xterror30    ? _F|defined(U|xterror30)
.type text xterror31    ? _F|defined(U|xterror31)
..
.file -tempname U|xtmpfile
.file -tempname U|xtout
.file -tempname U|xterr
..
.set trans +
.formula U|xterror0  = "Das Bearbeiten der Datei dfue/zugferd.cfg ist gescheitert"
.formula U|xterror1  = "Fehler beim Anlegen des Aufrufparameters"
.formula U|xterror2  = "Fehler beim Import der Inhouse-Schemadefinitionen!"
.formula U|xterror3  = "Fehler beim Aktualisieren der Datei dfue/zugferd.cfg"
.formula U|xterror4  = "Keine AP-Teilliste vorhanden fr ELINVOICECENTER"
.formula U|xterror8  = "Keine AP-Teilliste vorhanden fr BKOPF"
.formula U|xterror5  = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname87, "12", kaktname14)
.formula U|xterror6  = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname87, "12", kaktname13)
.formula U|xterror7  = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname87, "12", kaktname12)
.formula U|xterror9  = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname87, "14", kaktname14)
.formula U|xterror10 = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname87, "14", kaktname13)
.formula U|xterror11 = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname87, "14", kaktname12)
.formula U|xterror13 = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname87, "22", kaktname14)
.formula U|xterror14 = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname87, "22", kaktname13)
.formula U|xterror15 = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname87, "22", kaktname12)
.formula U|xterror17 = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname92, "1", kaktname14)
.formula U|xterror18 = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname92, "1", kaktname13)
.formula U|xterror19 = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname92, "1", kaktname12)
.formula U|xterror21 = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname92, "2", kaktname14)
.formula U|xterror22 = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname92, "2", kaktname13)
.formula U|xterror23 = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname92, "2", kaktname12)
.formula U|xterror25 = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname92, "5", kaktname14)
.formula U|xterror26 = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname92, "5", kaktname13)
.formula U|xterror27 = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname92, "5", kaktname12)
.formula U|xterror29 = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname92, "11", kaktname14)
.formula U|xterror30 = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname92, "11", kaktname13)
.formula U|xterror31 = F|formatstr("Erlaubnis {1} Gruppe {2} - {3} - nicht vorhanden", kdatname92, "11", kaktname12)
.set trans -
..
!EINS: Aufrufparameter ELINVOICECENTER zu ELINVOICEPROCESS (Tabelle AP-Teilliste)
..     in load/edp/csv/d87g22/EV.ELINVOICECENTER.csv in erster Zeile den AP 53292 eintragen
..     Duerfen Standard-AP-Listen erweitert werden? Wenn nein, dann typ=individuell nutzen
..     Rechtepruefung: Datenbank Datenexport (87) Gruppe 12,14,22 -> Neu/Aendern/Zeigen (14,13,12)
..
.output terminal
.copy U|xdatenexport = G|TRUE
.copy U|xdatenexport = F|cmdpermitted(87,14, ,12)
?'U|xterror5' ? _U|xdatenexport
.copy U|xdatenexport = F|cmdpermitted(87,13, ,12)
?'U|xterror6' ? _U|xdatenexport
.copy U|xdatenexport = F|cmdpermitted(87,12, ,12)
?'U|xterror7' ? _U|xdatenexport
.copy U|xdatenexport = F|cmdpermitted(87,14, ,14)
?'U|xterror9' ? _U|xdatenexport
.copy U|xdatenexport = F|cmdpermitted(87,13, ,14)
?'U|xterror10' ? _U|xdatenexport
.copy U|xdatenexport = F|cmdpermitted(87,12, ,14)
?'U|xterror11' ? _U|xdatenexport
.copy U|xdatenexport = F|cmdpermitted(87,14, ,22)
?'U|xterror13' ? _U|xdatenexport
.copy U|xdatenexport = F|cmdpermitted(87,13, ,22)
?'U|xterror14' ? _U|xdatenexport
.copy U|xdatenexport = F|cmdpermitted(87,12, ,22)
?'U|xterror15' ? _U|xdatenexport
..
.continue ZWEI ? _U|xdatenexport
..
.. pruefen, ob schon eine AP-Teilliste angelegt wurde
.formula U|xtsel = "$,,aufrktxt=i elinvoicecenter;aufrtab=1;buttonfeld=buinfosys;typ=stand"
.load 1 group "87:22" 'U|xtsel'
.continue LINE ? G|mehr
'U|xterror4'
.continue APBKOPF
..
!LINE: AP-Nummer eintragen
.output new 'U|xtmpfile'
.input DATEI.F
#!database=87:22
?#!action=NEW    ? _G|mehr
?#!action=STORE  ?  G|mehr
#!DONTCHANGE=~
#!flddelimiter=|
id \
zeile|aufruf
?'1|id' \        ?  G|mehr
?   ~   \        ? _G|mehr
-*|-\
+|53292\
.continue OUTPUT
..
!OUTPUT
.output
.output terminal
.system 'F|formatstr("edpimport.sh -o testflag298=1 -p {1} -I {2} >{3} 2>{4}", G|einmalpw, U|xtmpfile, U|xtout, U|xterr)' background
?Aufrufparameter 53292 erfolgreich in AP-Teilliste eingefgt. ? G|mehr
.continue APBKOPF ? G|mehr
'U|xterror1'
.output terminal
.input 'U|xterr'
.continue APBKOPF
..
!APBKOPF
.. pruefen, ob schon eine AP-Teilliste angelegt wurde
.formula U|xtsel = "$,,aufrktxt=i bkopf;aufrtab=(No);buttonfeld=buinfosys;typ=stand;tzielobj=i adresse;@gruppe=22;@ablageart=(Active)"
..
.load 1 group "87:22" 'U|xtsel'
.continue L2INE ? G|mehr
'U|xterror8'
.continue ZWEI 
..
!L2INE: 3 AP-Nummern hinten anh„ngen eintragen (58300, 58301, 58302)
.. pruefen, ob die 3 APS schon in der Liste stehen
.formula U|xtsel = "$,,aufrktxt=i bkopf;aufrtab=(No);buttonfeld=buinfosys;typ=stand;tzielobj=i adresse;aufruf=58300;@gruppe=22;@zeilen=(Yes);@ablageart=(Active)"
.load 2 group "87:22" 'U|xtsel'
.continue ZWEI ? G|mehr
..
.output new 'U|xtmpfile'
.input DATEI.F
#!database=87:22
?#!action=NEW    ? _G|mehr
?#!action=STORE  ?  G|mehr
#!DONTCHANGE=~
#!flddelimiter=|
id \
zeile|aufruf
?'1|id' \        ?  G|mehr
?   ~   \        ? _G|mehr
+|58300\
+|58301\
+|58302\
.continue O2UTPUT
..
!O2UTPUT
.output
.output terminal
.system 'F|formatstr("edpimport.sh -o testflag298=1 -p {1} -I {2} >{3} 2>{4}", G|einmalpw, U|xtmpfile, U|xtout, U|xterr)' background
?Aufrufparameter 58300, 58301 und 58302 erfolgreich in AP-Teilliste eingefgt. ? G|mehr
.continue  ZWEI ? G|mehr
'U|xterror1'
.output terminal
.input 'U|xterr'
.continue ZWEI
..
!ZWEI: jediconfig.sh aufrufen
..     Datenbank EDI-Konfiguration (92) Gruppen Abbildungsmodell (1), Objektzuordnung (2) und Feldzuordnung (5)
..     -> Neu/Aendern/Zeigen (14,13,12)
..
.copy U|xjediconfig = G|TRUE
.copy U|xjediconfig = F|cmdpermitted(92,14, ,1)
?'U|xterror17' ? _U|xjediconfig
.copy U|xjediconfig = F|cmdpermitted(92,13, ,1)
?'U|xterror18' ? _U|xjediconfig
.copy U|xjediconfig = F|cmdpermitted(92,12, ,1)
?'U|xterror19' ? _U|xjediconfig
.copy U|xjediconfig = F|cmdpermitted(92,14, ,2)
?'U|xterror21' ? _U|xjediconfig
.copy U|xjediconfig = F|cmdpermitted(92,13, ,2)
?'U|xterror22' ? _U|xjediconfig
.copy U|xjediconfig = F|cmdpermitted(92,12, ,2)
?'U|xterror23' ? _U|xjediconfig
.copy U|xjediconfig = F|cmdpermitted(92,14, ,5)
?'U|xterror25' ? _U|xjediconfig
.copy U|xjediconfig = F|cmdpermitted(92,13, ,5)
?'U|xterror26' ? _U|xjediconfig
.copy U|xjediconfig = F|cmdpermitted(92,12, ,5)
?'U|xterror27' ? _U|xjediconfig
..
.continue DREI
..
!DREI: dfue/zugferd.cfg muss aktualisiert werden. Jede Zeile ein Aufruf
..     Datenbank EDI-Konfiguration (92) Gruppe EDI-Objektsuche (11)
..     -> Neu/Aendern/Zeigen (14,13,12)
..
.copy U|xzugferd = G|TRUE
.copy U|xzugferd = F|cmdpermitted(92,14, ,11)
?'U|xterror29' ? _U|xzugferd
.copy U|xzugferd = F|cmdpermitted(92,13, ,11)
?'U|xterror30' ? _U|xzugferd
.copy U|xzugferd = F|cmdpermitted(92,12, ,11)
?'U|xterror31' ? _U|xzugferd
..
.continue VIER ? _U|xzugferd
..
.formula U|xsys = "putinisetting.sh -r dfue/zugferd.cfg xmlxpath/3.0.2/import/xrechnung-cii SchematronFile"
.system 'U|xsys'
?'U|xterror3'   ? _G|mehr
.formula U|xsys = "putinisetting.sh -r dfue/zugferd.cfg xmlxpath/3.0.2/import/xrechnung-cii SchematronFile"
.system 'U|xsys'
?'U|xterror3'   ? _G|mehr
.formula U|xsys = "putinisetting.sh -r dfue/zugferd.cfg xmlxpath/3.0.2/import/xrechnung-cii SchematronFile"
.system 'U|xsys'
?'U|xterror3'   ? _G|mehr
.formula U|xsys = "putinisetting.sh dfue/zugferd.cfg global ImportCharset UTF-8"
.system 'U|xsys'
?'U|xterror3'   ? _G|mehr
.formula U|xsys = "putinisetting.sh dfue/zugferd.cfg global ExportCharset UTF-8"
.system 'U|xsys'
?'U|xterror3'   ? _G|mehr
.formula U|xsys = "putinisetting.sh dfue/zugferd.cfg global UseNamespacePrefix 1"
.system 'U|xsys'
?'U|xterror3'   ? _G|mehr
.formula U|xsys = "putinisetting.sh dfue/zugferd.cfg export ExportEmptyFields 0"
.system 'U|xsys'
?'U|xterror3'   ? _G|mehr
.formula U|xsys = "putinisetting.sh dfue/zugferd.cfg xmlxpath/1.08/export/en16931 SchematronErrorFlags fatal,warning"
.system 'U|xsys'
?'U|xterror3'   ? _G|mehr
.formula U|xsys = "putinisetting.sh dfue/zugferd.cfg xmlxpath/1.08/export/extended SchematronErrorFlags fatal,warning"
.system 'U|xsys'
?'U|xterror3'   ? _G|mehr
.formula U|xsys = "putinisetting.sh dfue/zugferd.cfg xmlxpath/3.0.2/export/xrechnung-cii SchematronErrorFlags fatal,warning"
.system 'U|xsys'
?'U|xterror3'   ? _G|mehr
.formula U|xsys = "putinisetting.sh dfue/zugferd.cfg xmlxpath/2.3.3/import/en16931 SchematronFile '$HOMEDIR/jedi/schema/facturx1073/EN16931/FACTUR-X_EN16931.xslt'
.system 'U|xsys'
?'U|xterror3'   ? _G|mehr
.formula U|xsys = "putinisetting.sh dfue/zugferd.cfg xmlxpath/2.3.3/import/en16931 SchematronErrorFlags fatal,warning"
.system 'U|xsys'
?'U|xterror3'   ? _G|mehr
.formula U|xsys = "putinisetting.sh dfue/zugferd.cfg xmlxpath/2.3.3/import/extended SchematronFile '$HOMEDIR/jedi/schema/facturx1073/EXTENDED/FACTUR-X_EXTENDED.xslt'
.system 'U|xsys'
?'U|xterror3'   ? _G|mehr
.formula U|xsys = "putinisetting.sh dfue/zugferd.cfg xmlxpath/2.3.3/import/extended SchematronErrorFlags fatal,warning"
.system 'U|xsys'
?'U|xterror3'   ? _G|mehr
.formula U|xsys = "putinisetting.sh dfue/zugferd.cfg xmlxpath/3.0.2/import/xrechnung-cii SchematronFile1 '$HOMEDIR/jedi/schema/xrechnung/cii3.0.2/EN16931-CII-validation.xsl'
.system 'U|xsys'
?'U|xterror3'   ? _G|mehr
.formula U|xsys = "putinisetting.sh dfue/zugferd.cfg xmlxpath/3.0.2/import/xrechnung-cii SchematronFile2 '$HOMEDIR/jedi/schema/xrechnung/cii3.0.2/XRechnung-CII-validation.xsl'
.system 'U|xsys'
?'U|xterror3'   ? _G|mehr
.formula U|xsys = "putinisetting.sh dfue/zugferd.cfg xmlxpath/3.0.2/import/xrechnung-cii SchematronErrorFlags fatal,warning"
.system 'U|xsys'
?'U|xterror3'   ? _G|mehr
.formula U|xsys = "sed -i -e 's/SchematronFile1/SchematronFile/g' -i -e 's/SchematronFile2/SchematronFile/g' dfue/zugferd.cfg"
.system 'U|xsys'
?'U|xterror0'   ? _G|mehr
?Die Datei dfue/zugferd.cfg wurde erfolgreich angelegt bzw. erweitert. ? G|mehr
.continue VIER
..
!VIER: EDI-Objektsuche muss manuell importiert werden
.continue END  ? _U|xjediconfig
..
.formula U|xsys = "jediconfig.sh -p " + einmalpw + " -f $HOMEDIR/jedi/config/objectsearch/objectsearch_zugferd_std.edp"
.system 'U|xsys'
?EDI-Objektsuche wurde angelegt. ? G|mehr
.continue END ? G|mehr
'U|xterror2'
.continue END
..
..*****************************************************************************
!END
Fertig!
.continue
