..!interpreter english translate
.continue INI
..*******************************************************************************************************
..*
..*  Programmname : DRUCK.LS
..*
..*  Autor        : Holger Klein ais
..  Verantwortlich    : mh
..*
..*  am           : 17.04.2000
..*  Ge„ndert am  : 26.02.2001, Ozan Kesim
..*  Funktion     : Druckt Lieferscheine  / Speditionauftr„ge aus der EDI Datenbank
..*
..*  Bemerkung    : Ist Unterprogramm von DRUCK.VORGANG
..Aenderungshistorie:
..#KOR#EDI-MODUL#DATUM#ŽNDERUNGS-INDEX#Mitarbeiterkrzel#FOP-Dateigr”áe(vor/nach)#SPX-Dateigr”áe(vor/nach)#
..#KOR#EDI#26.03.2001#1#ok#7138/7305#nur FOP
..#KOR#EDI#15.07.2002#2#ok#      (Textkorrekturen)
..
..*******************************************************************************************************
!INI
.set trans +
.type text xtfotmp
.type integer  xi1zaehl
.continue START
..
!START
.up
.page 1
?EDI-ID: 'H|num   '                                                    Mandant: 'mandant '        ? H|tzeilen > 0
?vom   : 'H|ddatei '               VDA - Lieferschein                  Datum  : 'datum   '        ? H|tzeilen > 0
?Zeit  : 'H|zdatei '               (Speditionsauftrag)                 Seite  : 'seite   '        ? H|tzeilen > 0
?------------------------------------------------------------------------------------------       ? H|tzeilen > 0
.continue MAIN0
..
!MAIN0
.select line
.continue ENDE0       ? _mehr
.continue M400        ?  H|text1 / "*400*"
.continue M405        ?  H|text1 / "*405*"
.continue M500        ?  H|text1 / "*500*"
.continue M505        ?  H|text1 / "*505*"
.continue M550        ?  H|text  / "*550*"
.continue M565        ?  H|text  / "*565*"
.continue MAIN0
..
!M400
Kundennummer       : 'H|text3             '   Lieferantennummer  : 'H|text4               '
šbertragungsdatum  : 'H|text7             '
šbertragungs-Nr Alt: 'H|text5             '   šbertragungs-Nr Neu: 'H|text6               '
?------------------------------------------------------------------------------------------       ? H|tzeilen > 0
Transport Nr.       : 'H|text8             '  Unterlieferanten-Nr: 'H|text9               '
Frachtfhrer Nr.    : 'H|text10            '  Lagerhalterschl.   : 'H|text11              '
Werk Lieferant      : 'H|text13            '  Lieferungskennung  : 'H|text12            '
Frachtfhrer        : 'H|text14            '
Frachtf.šbergabezeit: 'H|text16            '  Frachtf. šb.-Datum : 'H|text15               '
Sendegewicht-Brutto : 'H|text17            '  Sendegewicht-Netto : 'H|text18               '
Frankatur Schlssel : 'H|text19            '  Spediteur DFš-Schl.: 'H|text20               '
Anzahl Packstcke   : 'H|text21            '
?------------------------------------------------------------------------------------------     ? H|tzeilen > 0
.continue MAIN0
..
!M405
Transportpartner-Nr : 'H|text3             '  Transp.-Partnername: 'H|text4                '
Transportmittelschl.: 'H|text5             '  Transportmittel-Nr : 'H|text6                '
Tarifzone           : 'H|text7             '
Eintreff-Datum Soll : 'H|text8             '  Eintreff-Zeit      : 'H|text9                '
Lademeter           : 'H|text10            '  LKW - Art Schlssel: 'H|text11               '
Adresse 1 Sped.     : 'H|text12            '
Adresse 2 Sped.     : 'H|text13            '
Adresse 3 Sped.     : 'H|text14            '
?------------------------------------------------------------------------------------------     ? H|tzeilen > 0
.continue MAIN0
..
!M500
Lieferschein-Nr     : 'H|text3             '  Versanddatum       : 'H|text4                '
Abladestelle        : 'H|text5             '  Versandart         : 'H|text6                '
Kundenzeichen (LAB) : 'H|text7             '  Bestellnummer      : 'H|text8                '
Vorgangsschlssel   : 'H|text9             '  Werk - Kunde       : 'H|text10               '
Konsignation        : 'H|text11            '  Empf„ngernummer    : 'H|text12               '
Lager des Kunden    : 'H|text13            '  Lieferanten-Nr EDL : 'H|text14               '
Verbrauchsstelle    : 'H|text15            '  Abrufnummer        : 'H|text16               '
Kundenzeichen(Best.): 'H|text17            '
?------------------------------------------------------------------------------------------     ? H|tzeilen > 0
.continue MAIN0
..
!M505
Dokument-Nr. Kunde : 'H|text3             '
Rechnungsnummer    : 'H|text4             '   Rechnungsdatum     : 'H|text5                '
Euro Nummer        : 'H|text6             '   Euro Datum         : 'H|text7                '
Warenterminal      : 'H|text8             '
LS-Gewicht Brutto  : 'H|text9             '   LS-Gewicht Netto   : 'H|text10               '
LS-Volumen         : 'H|text11            '
Authentifizierung  : 'H|text12            '
Absendernummer     : 'H|text13            '   Absendername       : 'H|text14               '
?------------------------------------------------------------------------------------------     ? H|tzeilen > 0
.continue MAIN0
..
!M550
Positionsnummer    : 'H|text3             '
Sachnummer Kunde   : 'H|text4             '  Sachnummer Lieferant: 'H|text5                '
Ursprungsland      : 'H|text6             '
Liefermenge 1      : 'H|text7             '  Mengeneinheit 1     : 'H|text8                '
Liefermenge 2      : 'H|text9             '  Mengeneinheit 2     : 'H|text10               '
Umsatzsteuersatz   : 'H|text11            '
Prod. Nr. Schl.    : 'H|text12            '  Chargen-Nummer      : 'H|text13               '
Verwendungsschl.   : 'H|text14            '  Gefahrtgutschlssel : 'H|text15               '
Pr„ferenzstatus    : 'H|text16            '  Zollgut             : 'H|text17               '
Bestandsstatus     : 'H|text18            '  ge„nd.Ausfhrungsch.: 'H|text19               '
Žnd.stand Konstruk.: 'H|text20            '  Abrufschlssel      : 'H|text21               '
Ursprungs-LS-Nummer: 'H|text22            '
?------------------------------------------------------------------------------------------     ? H|tzeilen > 0
.continue MAIN0
..
!M565
Positionsnummer    : 'H|text3             '
Sachnummer Kunde   : 'H|text4             '   Sachnummer Liefer. : 'H|text5                '
Anzahl Packmittel  : 'H|text6             '   Fllmenge          : 'H|text7                '
Packstcknummer von: 'H|text8             '   Packstcknumer bis : 'H|text9                '
Abmessung          : 'H|text10            '   Stapelfaktor       : 'H|text11               '
Lagerabruf-Nr      : 'H|text12            '   Labelkennung       : 'H|text13               '
Verpackungstyp     : 'H|text14            '   Eigentumskennung   : 'H|text15               '
?------------------------------------------------------------------------------------------     ? H|tzeilen > 0
.continue MAIN0
..
!ENDE0
.continue
