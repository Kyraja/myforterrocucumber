..!interpreter english translate
.continue INI
..*******************************************************************************************************
..*
..*  Programmname : DRUCK.RE
..*
..*  Autor        : Holger Klein ais
..  Verantwortlich    : mh
..*
..*  am           : 17.04.2000
..*  Ge„ndert am  : 26.02.2001, Ozan Kesim
..*  Funktion     : Druckt Rechnungen aus der EDI Datenbank
..*
..*  Bemerkung    : Ist Unterprogramm von DRUCK.VORGANG
..*
..Aenderungshistorie:
..#KOR#EDI-MODUL#DATUM#ŽNDERUNGS-INDEX#Mitarbeiterkrzel#FOP-Dateigr”áe(vor/nach)#SPX-Dateigr”áe(vor/nach)#
..#KOR#EDI#26.03.2001#1#ok#4171/4342#nur FOP
..*
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
?EDI-ID: 'H|num   '                                                    Mandant: 'mandant '    ? H|tzeilen > 0
?vom   : 'H|ddatei '                VDA - Rechnung                     Datum  : 'datum   '    ? H|tzeilen > 0
?Zeit  : 'H|zdatei '                                                   Seite  : 'seite   '    ? H|tzeilen > 0
?-----------------------------------------------------------------------------------------    ? H|tzeilen > 0
.continue MAIN0
..
!MAIN0
.select line
.continue ENDE0       ? _mehr
.continue M400        ?  H|text1 / "*400*"
.continue M500        ?  H|text1 / "*500*"
.continue M525        ?  H|text1 / "*525*"
.continue M550        ?  H|text1 / "*550*"
.continue M600        ?  H|text1 / "*600*"
.continue MAIN0
..
!M400
Kundennummer       : 'H|text3             '   Lieferantennr.     : 'H|text4             '
šbertragungsdatum  : 'H|text7             '
šbertragungs-Nr Alt: 'H|text5             '   šbertragungs-Nr Neu: 'H|text6             '
?-----------------------------------------------------------------------------------------    ? H|tzeilen > 0
USt-IdNr Kunde     : 'H|text8             '   USt-IdNr Lieferant : 'H|text9             '
?-----------------------------------------------------------------------------------------    ? H|tzeilen > 0
.continue MAIN0
..
!M500
Werk-Kunde         : 'H|text10            '
Rechnungsnummer    : 'H|text3             '   Rechnungsdatum   :  'H|text4                '
Umsatzsteuersatz   : 'H|text9             '
Umsatzsteuerbetrag : 'H|text5             '   Rechnungsendwert :  'H|text6                '
W„hrungseinheit    : 'H|text7             '   Referenznummer   :  'H|text8                '
Entgeld            : 'H|text11            '
?-----------------------------------------------------------------------------------------    ? H|tzeilen > 0
.continue MAIN0
..
!M525
Lieferschein Nr.  :  'H|text3             '
Versanddatum      :  'H|text4             '   Versandart      :  'H|text6                '
Abladestelle      :  'H|text5             '   Zeichen Bestell :  'H|text7                '
Versandkosten     :  'H|text9             '   Verpackungskost.:  'H|text10               '
Abschluss.Best.Nr.:  'H|text8             '
?-----------------------------------------------------------------------------------------    ? H|tzeilen > 0
.continue MAIN0
..
!M550
Sachnummer Kunde  :  'H|text3             '   Sach-Nr Lieferant :  'H|text4              '
Liefermenge       :  'H|text5             '   Preiseinheit      :  'H|text6              '
Einzelpreis       :  'H|text7             '   Gesamtpreis       :  'H|text8              '
Ursprungsland     :  'H|text10            '   U.steuerpr„ferenz :  'H|text11             '
Proz. Angabe Vorl.:  'H|text12            '   Handelspr„ferenz  :  'H|text13             '
?-----------------------------------------------------------------------------------------    ? H|tzeilen > 0
.continue MAIN0
..
!M600
Umsatzsteuersatz  1: 'H|text11            '
Summe Entgeld     1: 'H|text9             '   Summe USt.Betrag 1:  'H|text10            '
Umsatzsteuersatz  2: 'H|text14            '
Summe Entgeld     2: 'H|text12            '   Summe USt.Betrag 2:  'H|text13            '
Rechnungsendwert   : 'H|text8             '
?-----------------------------------------------------------------------------------------    ? H|tzeilen > 0
.continue MAIN0
..
!ENDE0
.continue
