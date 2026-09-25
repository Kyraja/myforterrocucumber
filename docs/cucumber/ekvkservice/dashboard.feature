@persistent
Feature: Infosysteme zum Dashboard
Background:
Given I set the fake date to "02.01.1995"
# *****************************************************************************
#  Name           : dashboard.feature
#  Autor          : cl
#  Verantwortlich : cl
#  Kontrolle      : teampss
#  Funktion       : Cucumber Tests zu Infosystemen, die Dashboards verwenden
#                   
# *****************************************************************************

@Infosystem_st_AUFGABEN
# ursache=${message.ursache}|bearbeit=${message.bearbeit}|bisenddatum=+14|bstart=1
# bearbeit=${message.bearbeit}|bestaet=${message.bestaet}|keineeigenen=${message.keineeigenen}|bisenddatum=+14|bstart=1

Scenario: Infosystem AUFGABEN: ALLE
Given I open the infosystem "AUFGABEN"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tprio,tstatus,tablauf,tablaufzustbez,tbestaetigername,tbearbeitername,tteamname,tend,tursache,taufgabe,taufgabenname" from table content to output file "ref_dashboard_cu.REF"
 
Scenario: Infosystem AUFGABEN: ursache 0 1
Given I open the infosystem "AUFGABEN"
And I set field "ursache" to "0 1"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tprio,tstatus,tablauf,tablaufzustbez,tbestaetigername,tbearbeitername,tteamname,tend,tursache,taufgabe,taufgabenname" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem AUFGABEN: bisenddatum
Given I open the infosystem "AUFGABEN"
And I set field "bisenddatum" to "+14"
And I set field "ursache" to ""
And I set field "bearbeit" to ""
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tprio,tstatus,tablauf,tablaufzustbez,tbestaetigername,tbearbeitername,tteamname,tend,tursache,taufgabe,taufgabenname" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem AUFGABEN: keineeigenen
Given I open the infosystem "AUFGABEN"
And I set field "ursache" to ""
And I set field "bearbeit" to ""
And I set field "keineeigenen" to "1"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tprio,tstatus,tablauf,tablaufzustbez,tbestaetigername,tbearbeitername,tteamname,tend,tursache,taufgabe,taufgabenname" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem AUFGABEN: bearbeit 7801 bestaet 7802
Given I open the infosystem "AUFGABEN"
And I set field "ursache" to ""
And I set field "bearbeit" to "7801"
And I set field "bestaet" to "7802"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tprio,tstatus,tablauf,tablaufzustbez,tbestaetigername,tbearbeitername,tteamname,tend,tursache,taufgabe,taufgabenname" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_st_NOTIZEN
# ursache=${message.ursache}|vomdatum=${message.vomdatum}|bisdatum=${message.bisdatum}|bstart=1
Scenario: Infosystem NOTIZEN: ursache 0 1 vomdatum bisdatum
Given I open the infosystem "NOTIZEN"
And I set field "ursache" to "0 1"
And I set field "vomdatum" to "-10"
And I set field "bisdatum" to "+10"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tdatum,tzeit,ttyp,tnotizname" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_st_LPREISE
# selpartner=1|partner=${!message.partner}|ktyp=(SalesPriceList)|kvon=${message.kvon}|kbis=${message.kbis}|bstart=1
# ktyp=${!message.prices}|artpgbis=${!message.nummer}|artpgvon=${!message.nummer}|kvon=${message.kvon}|kbis=${message.kbis}|bstart=1
# ktyp=${!message.discounts}|artpgvon=${!message.nummer}|artpgbis=${!message.nummer}|kvon=${message.kvon}|kbis=${message.kbis}|bstart=1
Scenario: Infosystem LPREISE: ALLE
Given I open the infosystem "LPREISE"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tnum,tsuch,tname,tklpg,tartpg,tvon,tbis" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem LPREISE: selpartner 1 partner 0-4711-3
Given I open the infosystem "LPREISE"
And I set field "selpartner" to "1"
And I set field "partner" to "0-4711-3"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tnum,tsuch,tname,tklpg,tartpg,tvon,tbis" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem LPREISE: ktyp Verkauf Rabatte selpartner 1 partner 0-4711-3
Given I open the infosystem "LPREISE"
And I set field "ktyp" to "Verkauf Rabatte"
And I set field "selpartner" to "1"
And I set field "partner" to "0-4711-3"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tnum,tsuch,tname,tklpg,tartpg,tvon,tbis" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem LPREISE: ktyp Verkauf Rabatte selpartner 1 partner 0-4711-3
Given I open the infosystem "LPREISE"
And I set field "ktyp" to "Verkauf Rabatte"
And I set field "selpartner" to "1"
And I set field "partner" to "0-4711-3"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tnum,tsuch,tname,tklpg,tartpg,tvon,tbis" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem LPREISE: ekvk Verkauf artpgvon 10002 artpgbis 10002
Given I open the infosystem "LPREISE"
And I set field "ekvk" to "Verkauf"
And I set field "artpgvon" to "10002"
And I set field "artpgbis" to "10002"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tnum,tsuch,tname,tklpg,tartpg,tvon,tbis" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem LPREISE: ekvk Verkauf artpgvon 10002 artpgbis 10002 kvon -100 kbis +100
Given I open the infosystem "LPREISE"
And I set field "ekvk" to "Verkauf"
And I set field "artpgvon" to "10002"
And I set field "artpgbis" to "10002"
And I set field "kvon" to "-100"
And I set field "kbis" to "+100"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tnum,tsuch,tname,tklpg,tartpg,tvon,tbis" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_st_KONTAKT
# kontext=${!message.kontext}|kunde=0|interessent=1|lieferant=1|intersach=1|kundensach=1|liefersach=1|mitarbeiter=0|adresse=0|bank=0|bstart=1
# kontext=${!message.kontext}|kunde=0|interessent=0|lieferant=0|intersach=0|kundensach=0|liefersach=1|mitarbeiter=0|adresse=0|bank=0|bstart=1
Scenario: Infosystem KONTAKT: kontext 0 1
Given I open the infosystem "KONTAKT"
And I set field "kontext" to "0 1"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tvbed,tkontakt,tkontaktname" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem KONTAKT: kontext 0 1 kunde 0 interessent 1 lieferant 1
Given I open the infosystem "KONTAKT"
And I set field "kontext" to "0 1"
And I set field "kunde" to "0"
And I set field "interessent" to "1"
And I set field "lieferant" to "1"
And I set field "intersach" to "1"
And I set field "liefersach" to "1"
And I set field "mitarbeiter" to "0"
And I set field "adresse" to "0"
And I set field "bank" to "0"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tvbed,tkontakt,tkontaktname" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_st_ARTIKELAKTE
# kbbeschaffung=1|kartikel=${!message.kartikel}|bstart=1
# kbversand=1|kartikel=${!message.kartikel}|kvon=${message.kvon}|kbis=${message.kbis}|bstart=1
# kboffeneauftraege=1|kartikel=${!message.kartikel}|kvon=${message.kvon}|kbis=${message.kbis}|bstart=1
# kbungebuchtels=1|kartikel=${!message.kartikel}|kvon=${message.kvon}|kbis=${message.kbis}|bstart=1
# kbgeliefert=1|kartikel=${!message.kartikel}|kvon=${message.kvon}|kbis=${message.kbis}|bstart=1
Scenario: Infosystem ARTIKELAKTE: kartikel CAMEL
Given I open the infosystem "ARTIKELAKTE"
And I set field "kartikel" to "CAMEL"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tvorgangsart,tvorgangsanzahl,tvorgangsmenge,tzeitraum,tkunde,tvorgang,tmenge,ttermin,tversand,tsped,tzudrucken" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem ARTIKELAKTE: kartikel CAMEL kbbeschaffung 1 kvon -100 kbis +100
Given I open the infosystem "ARTIKELAKTE"
And I set field "kartikel" to "CAMEL"
And I set field "kbbeschaffung" to "1"
And I set field "kvon" to "-100"
And I set field "kbis" to "+100"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tvorgangsart,tvorgangsanzahl,tvorgangsmenge,tzeitraum,tkunde,tvorgang,tmenge,ttermin,tversand,tsped,tzudrucken" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem ARTIKELAKTE: kartikel CAMEL kbversand 1
Given I open the infosystem "ARTIKELAKTE"
And I set field "kartikel" to "CAMEL"
And I set field "kbversand" to "1"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tvorgangsart,tvorgangsanzahl,tvorgangsmenge,tzeitraum,tkunde,tvorgang,tmenge,ttermin,tversand,tsped,tzudrucken" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem ARTIKELAKTE: kartikel CAMEL kboffeneauftraege 1
Given I open the infosystem "ARTIKELAKTE"
And I set field "kartikel" to "CAMEL"
And I set field "kboffeneauftraege" to "1"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tvorgangsart,tvorgangsanzahl,tvorgangsmenge,tzeitraum,tkunde,tvorgang,tmenge,ttermin,tversand,tsped,tzudrucken" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem ARTIKELAKTE: kartikel CAMEL kbungeuchtels 1
Given I open the infosystem "ARTIKELAKTE"
And I set field "kartikel" to "CAMEL"
And I set field "kbungebuchtels" to "1"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tvorgangsart,tvorgangsanzahl,tvorgangsmenge,tzeitraum,tkunde,tvorgang,tmenge,ttermin,tversand,tsped,tzudrucken" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem ARTIKELAKTE: kartikel CAMEL kbgeliefert 1
Given I open the infosystem "ARTIKELAKTE"
And I set field "kartikel" to "CAMEL"
And I set field "kbgeliefert" to "1"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tvorgangsart,tvorgangsanzahl,tvorgangsmenge,tzeitraum,tkunde,tvorgang,tmenge,ttermin,tversand,tsped,tzudrucken" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_st_KDINFO
# knumkusa=${!message.knumkusa}|kbprojekte=1|bstart=1
# kbblanket=0|kboffer=0|kborder=0|kbdelivery=0|kbinvoice=0|kbserreserv=1|knumkusa=${!message.knumkusa}|bstart=1
Scenario:  Infosystem KDINFO: ALLE
Given I open the infosystem "KDINFO"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "objektnum,tsuch,tschlag,tvortyp,terfass,tmitarb" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem KDINFO: kbprojekte 1
Given I open the infosystem "KDINFO"
And I set field "kbprojekte" to "1"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "objektnum,tsuch,tschlag,tvortyp,terfass,tmitarb" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem KDINFO: kbprojekte 1 knumkusa 1
Given I open the infosystem "KDINFO"
And I set field "kbprojekte" to "1"
And I set field "knumkusa" to "1"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "objektnum,tsuch,tschlag,tvortyp,terfass,tmitarb" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem KDINFO: kboffer 1 kbopport 1 kborder 1 kbdelivery 1
Given I open the infosystem "KDINFO"
And I set field "kboffer" to "1"
And I set field "kbopport" to "1"
And I set field "kborder" to "1"
And I set field "kbdelivery" to "1"
And I set field "kbinvoice" to "1"
And I set field "knumkusa" to "4"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "objektnum,tsuch,tschlag,tvortyp,terfass,tmitarb" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem KDINFO: kbserreserv 1 knumkusa LEER
Given I open the infosystem "KDINFO"
And I set field "kbserreserv" to "1"
And I set field "knumkusa" to ""
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "objektnum,tsuch,tschlag,tvortyp,terfass,tmitarb" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_ev_BEELEGVORKOMMEN
# vkpartner=${!message.vkpartner}|betreuer=|abteilung=(Sales)|ablageart=(Active)|chko=1|vkanko=1|vkabko=1|reko=1|liko=1|rahmen=1|wako=1|vomvom=|vombis=|bstart=1
# vkpartner=${message.vkpartner}|betreuer=${message.betreuer}|abteilung=(Sales)|ablageart=${!message.ablageart}|chko=1|vkanko=1|vkabko=1|reko=1|liko=1|rahmen=1|wako=1|vomvom=${message.vomvom}|vombis=${message.vombis}|bstart=1
Scenario:  Infosystem BELEGVORKOMMEN: ALLE
Given I open the infosystem "BELEGVORKOMMEN"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tvktypa,tvklsart,treart,tabsvorkommen,tabseinheit,tnettowert,tinland" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem BELEGVORKOMMEN: ablageart beides vkpartner 1 betruer 7801
Given I open the infosystem "BELEGVORKOMMEN"
And I set field "ablageart" to "beides"
And I set field "vkpartner" to "1"
And I set field "betreuer" to "7801"
And I set field "chko" to "1"
And I set field "vkanko" to "1"
And I set field "vkabko" to "1"
And I set field "reko" to "1"
And I set field "liko" to "1"
And I set field "rahmen" to "1"
And I set field "wako" to "1"
And I set field "vomvom" to "-100"
And I set field "vombis" to "+100"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tvktypa,tvklsart,treart,tabsvorkommen,tabseinheit,tnettowert,tinland" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_ev_PRODUCTOCCUR
# bverkauf=1|ablageart=(2)|vktyp=(5)|vorjahr=${message.vorjahr}|bstart=1|sortsumdash=1
Scenario: Infosystem PRODUCTOCCUR: ALLE
Given I open the infosystem "PRODUCTOCCUR"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "twaehr,vkbelegnr,ttyp,vom,vorganga,lsart,tkunde,altpos,tartikel,tbezartikel,mge,tle,proz,mgele,artle,netto,pwaehr,gesnetto" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem PRODUCTOCCUR: vorjahr 0 ablageart beides vktyp Rechnung
Given I open the infosystem "PRODUCTOCCUR"
And I set field "vorjahr" to "0"
And I set field "ablageart" to "beides"
And I set field "vktyp" to "Rechnung"
And I press button "bstart"
And I set field "sortsumdash" to "1"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "twaehr,vkbelegnr,ttyp,vom,vorganga,lsart,tkunde,altpos,tartikel,tbezartikel,tle,proz,mgele,artle,netto,pwaehr,gesnetto" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem PRODUCTOCCUR: ablageart beides vktyp Rechnung
Given I open the infosystem "PRODUCTOCCUR"
And I set field "ablageart" to "beides"
And I set field "vktyp" to "Rechnung"
And I set field "vorjahr" to "1"
And I press button "bstart"
And I set field "sortsumdash" to "1"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
Then the table has 1 rows
# And I export fields "twaehr,vkbelegnr,ttyp,vom,vorganga,lsart,tkunde,altpos,tartikel,tbezartikel,mge,tle,proz,mgele,artle,netto,pwaehr,gesnetto" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_vk_VKZENTRALE
# kkritisch=${message.kkritischkritisch||"0"}|kuli=${message.kuli}|vktyp=${!message.tvktypa}|datef=${message.vomvomvom}|datet=${message.vombisbis}|ablageart=${!message.ablageartart}|betreuer=${message.betreuer}|bstart=1
# vktyp=${!message.vktyp}|kuli=${!message.kuli}|bstart=1
Scenario: Infosystem VKZENTRALE: ablageart beides vktyp Auftrag
Given I open the infosystem "VKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "vktyp" to "Auftrag"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tstufe,ttyp1,ttyp2a,ttyp2,ttyp3,ttyp4,tlsart,ttyp5,tvorganga,tshort,ttrans,tkritisch,tdate,tkuli,tklname,treku,tbezreku,teprice,tauswaehr" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem VKZENTRALE: ablageart beides vktyp Lieferschein kkritisch 1
Given I open the infosystem "VKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "vktyp" to "Lieferschein"
And I set field "kkritisch" to "1"
And I set field "datef" to "1.1.1994"
And I set field "datet" to "1.12.1995"
And I set field "betreuer" to ""
And I set field "kuli" to ""
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tstufe,ttyp1,ttyp2a,ttyp2,ttyp3,ttyp4,tlsart,ttyp5,tvorganga,tshort,ttrans,tkritisch,tdate,tkuli,tklname,treku,tbezreku,teprice,tauswaehr" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_la_BESTAND
# artikel=${!message.artikel}|klgruppe=| bgebch=1|bstart=1
Scenario: Infosystem BESTAND: ALLE
Given I open the infosystem "BESTAND"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "lgruppe,lager,lplatz,dispo,tartikel,lemge,leinheit,lzu,lab" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem BESTAND: artikel Fortuna bgebch 1
Given I open the infosystem "BESTAND"
And I set field "artikel" to "FORTUNA"
And I set field "verdichten" to "0"
And I set field "details" to "0"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "lgruppe,lager,lplatz,dispo,tartikel,lemge,leinheit,lzu,lab" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_fe_PRODLIST
# kart=${!message.kart}|bba=1|klgruppe=|bstart=1
Scenario: Infosystem PRODLIST: ALLE
Given I open the infosystem "PRODLIST"
And I press button "bstart"
And I press button "release" in row 1
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "order,art,artbez,abtlg,netmge,frgmge,vpbsmge,artle,tsterm,tterm,tfterm,platz,kstelle" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem PRODLIST: kart 301 bba 1
Given I open the infosystem "PRODLIST"
And I set field "kart" to "301"
And I set field "bba" to "1"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "order,art,artbez,abtlg,netmge,frgmge,vpbsmge,artle,tsterm,tterm,tfterm,platz,kstelle" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_ek_LIOE
# artikel=${!message.artikel}|bstart=1
Scenario: Infosystem LIOE: ALLE
Given I open the infosystem "LIOE"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "kopf,tkuli,tkuliname,tkuli2,tprojekt,art,mge,limge,remge,dispo,tterm,twterm,fterm,twvdat,tzeich" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem LIOE: artikel 202
Given I open the infosystem "LIOE"
And I set field "artikel" to "202"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "kopf,tkuli,tkuliname,tkuli2,tprojekt,art,mge,limge,remge,dispo,tterm,twterm,fterm,twvdat,tzeich" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_ek_EKZENTRALE
# kuli=${message.kuli}|ektyp=${!message.tektypa}|datef=-30|datet=.|ablageart=${!message.ablageart}|betreuer=${message.betreuer}|bstart=1
Scenario: Infosystem EKZENTRALE: ablageart beides
Given I open the infosystem "EKZENTRALE"
And I set field "ablageart" to "beides"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tstufe,ttyp2a,ttyp2,ttyp3,ttyp4,tlsart,ttyp5,tvorganga,tshort,ttrans,bsart,tkritisch,tdate,tkuli,tklname,treku,tbezreku,teprice,tauswaehr" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem EKZENTRALE: ablageart beides ektyp Rechnung kuli 100 betruer 7801
Given I open the infosystem "EKZENTRALE"
And I set field "ablageart" to "beides"
And I set field "ektyp" to "Rechnung"
And I set field "kuli" to "100"
And I set field "betreuer" to "7801"
And I set field "datef" to "-50"
And I set field "datet" to "+800"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tstufe,ttyp2a,ttyp2,ttyp3,ttyp4,tlsart,ttyp5,tvorganga,tshort,ttrans,bsart,tkritisch,tdate,tkuli,tklname,treku,tbezreku,teprice,tauswaehr" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_op_LOP
# kkonto=${!message.vertret}|bstart=1
# vtab = (Vendor) | kkonto= ${!message.kkonto} | bstart=1
Scenario: Infosystem LOP: ALLE
Given I open the infosystem "LOP"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "konto,tname,topz,tterm,num,vom,soll,haben,tsalaus,tauswaehr" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem LOP: kkonto K 102
Given I open the infosystem "LOP"
And I set field "kkonto" to "K 102"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "konto,tname,topz,tterm,num,vom,soll,haben,tsalaus,tauswaehr" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_ser_SERVICECENTER
# kunde=${!message.kunde}|anzstufen=99|datef=${message.datef}|datet=${message.datet}|vorgang=${!message.ttrans}|lebendig=${!message.lebendig}|beides=${!message.beides}|bstart=1
Scenario: Infosystem SERVICECENTER: kunde 237501
Given I open the infosystem "SERVICECENTER"
And I set field "kunde" to "237501"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tbaumstufe,ttyp1,ttyp2,ttyp3,ttyp6,ttyp7,ttyp4,lsabzu,ttyp5,ttyp8,ttyp9,ttyp10,tshort,ttrans,ttyp,tkunde,tbezbetreuer,tdate,vorgstatus" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem SERVICECENTER: kunde 237501 lendig 1 anzstufen 99
Given I open the infosystem "SERVICECENTER"
And I set field "kunde" to "237501"
And I set field "lebendig" to "1"
And I set field "anzstufen" to "99"
And I set field "datef" to "-100"
And I set field "datet" to "."
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tbaumstufe,ttyp1,ttyp2,ttyp3,ttyp6,ttyp7,ttyp4,lsabzu,ttyp5,ttyp8,ttyp9,ttyp10,tshort,ttrans,ttyp,tkunde,tbezbetreuer,tdate,vorgstatus" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem SERVICECENTER: kunde 237501 anzstufen 99 beides 1 datef -100 datet PUNKT
Given I open the infosystem "SERVICECENTER"
And I set field "kunde" to "237501"
And I set field "anzstufen" to "99"
And I set field "beides" to "1"
And I set field "datef" to "-100"
And I set field "datet" to "."
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tbaumstufe,ttyp1,ttyp2,ttyp3,ttyp6,ttyp7,ttyp4,lsabzu,ttyp5,ttyp8,ttyp9,ttyp10,tshort,ttrans,ttyp,tkunde,tbezbetreuer,tdate,vorgstatus" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem SERVICECENTER: vorgang V 330993 anzstufen 99 datet PUNKT
Given I open the infosystem "SERVICECENTER"
And I set field "vorgang" to "V 330993"
And I set field "anzstufen" to "99"
And I set field "datet" to "."
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tbaumstufe,ttyp1,ttyp2,ttyp3,ttyp6,ttyp7,ttyp4,lsabzu,ttyp5,ttyp8,ttyp9,ttyp10,tshort,ttrans,ttyp,tkunde,tbezbetreuer,tdate,vorgstatus" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_ser_SAINFO
# kkunr=${!message.kkunr}|kanfbearb=|bstart=1
Scenario: Infosystem SAINFO: ALLE
Given I open the infosystem "SAINFO"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tanfrage,tanfbsch,tanfsts,tanfbearb,tkunr,tserprod,tsertech,tanferf" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem SAINFO: kkunr 237501
Given I open the infosystem "SAINFO"
And I set field "kkunr" to "237501"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tanfrage,tanfbsch,tanfsts,tanfbearb,tkunr,tserprod,tsertech,tanferf" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_ser_SERPROD
# kkunde=${!message.kkunde}|bstart=1
Scenario: Infosystem SERPROD ALLE
Given I open the infosystem "SERPROD"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tprodukt,tproduktbez,tartname,tkunde,tkuname,taukunde,taukuname,tetterm,tservice,tsereart,tsereartpt,tbetreff" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem SERPROD: kkunde 237503
Given I open the infosystem "SERPROD"
And I set field "kkunde" to "237503"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tprodukt,tproduktbez,tartname,tkunde,tkuname,taukunde,taukuname,tetterm,tservice,tsereart,tsereartpt,tbetreff" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_fb_OPENDOWNPAYMENTS
# kunde=${!message.kunde}|bverkauf=1|bstart=1
Scenario: Infosystem OPENDOWNPAYMENTS: ALLE
Given I open the infosystem "OPENDOWNPAYMENTS"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
Then the table has 0 rows
And I export fields "benummer,vom,tkunde,kname,tlief" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_fb_VKZ
# mitumsatz=1|bstart=1|sortdash=1
Scenario: Infosystem VKZ: ALLE
Given I open the infosystem "VKZ"
And I press button "bstart"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tkonto,tbezeichnung,tstaat,tverd,tasoll1,tahaben1,tvkzsoll1,tvkzhaben1,tesoll1,tehaben1" from table content to output file "ref_dashboard_cu.REF"

Scenario:  Infosystem VKZ: mitumsatz 1 sortdash 1
Given I open the infosystem "VKZ"
And I set field "mitumsatz" to "1"
And I press button "bstart"
And I set field "sortdash" to "1"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "tkonto,tbezeichnung,tstaat,tverd,tasoll1,tahaben1,tvkzsoll1,tvkzhaben1,tesoll1,tehaben1" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_vk_AUO
# dashboard = 1 | bstart = 1 | sortsumdash = 1 
Scenario: Infosystem AUO  
Given I open the infosystem "AUO"
And I set field "dashboard" to "1"
And I press button "bstart"
And I set field "sortsumdash" to "1"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "nwert,xi,jahr" from table content to output file "ref_dashboard_cu.REF"


@Infosystem_op_LOP
Scenario: Rechnung 0005 anlegen
Given I open an editor "rechnung-0005" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "+1"
And I set field "tterm" to "+1"
And I create a new row at the end of the table
And I set field "artex" to "301" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor 

Scenario: Rechnung 0006 anlegen
Given I open an editor "rechnung-0006" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "+9"
And I set field "tterm" to "+9"
And I create a new row at the end of the table
And I set field "artex" to "301" in row 1
And I set field "mge" to "20" in row 1
And I set field "preis" to "20" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor 

Scenario: Rechnung 0007 anlegen
Given I open an editor "rechnung-0007" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "kunde" to "1"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "+25"
And I set field "tterm" to "+25"
And I create a new row at the end of the table
And I set field "artex" to "301" in row 1
And I set field "mge" to "30" in row 1
And I set field "preis" to "30" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor 

Scenario: Infosystem LOP Zahlungseingänge (Kunden)
Given I open the infosystem "LOP"
And I set field "dashboard" to "1"
And I press button "bstart"
Then field "fdashbetr1inkl" has value "722856.37"
Then field "fbetr2" has value "460.00"
Then field "fbetr3" has value "0.00"
Then field "fbetr4" has value "1035.00"
Then field "proz1" has value "99.79"
Then field "proz2" has value "0.06"
Then field "proz3" has value "0.00"
Then field "proz4" has value "0.14"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "konto,rebetr" from table content to output file "ref_dashboard_cu.REF"

Scenario: Rechnung 0002 anlegen
Given I open an editor "rechnung-0002" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0002-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "+1"
And I create a new row at the end of the table
And I set field "artex" to "201" in row 1
And I set field "mge" to "10" in row 1
And I set field "preis" to "10" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor 

Scenario: Rechnung 0003 anlegen
Given I open an editor "rechnung-0003" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0003-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "+9"
And I create a new row at the end of the table
And I set field "artex" to "201" in row 1
And I set field "mge" to "20" in row 1
And I set field "preis" to "20" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor 

Scenario: Rechnung 0004 anlegen
Given I open an editor "rechnung-0004" from table "(Purchasing):(Invoice)" with command "NEW" for record ""
And I set field "lief" to "1"
And I set field "num4" to "0004-RE"
And I set field "fakt" to "ja"
And I set field "ueb" to "ja"
And I set field "vom" to "+25"
And I create a new row at the end of the table
And I set field "artex" to "201" in row 1
And I set field "mge" to "30" in row 1
And I set field "preis" to "30" in row 1
And I respond with answer "Ja" to the dialog with id "4841"
And I save the current editor 

Scenario: Infosystem LOP Zahlungsausgänge (Lieferant)
Given I open the infosystem "LOP"
And I set field "vtab" to "Lieferant" 
And I set field "dashboard" to "1"
And I press button "bstart"
Then field "fdashbetr1inkl" has value "0.00"
Then field "fbetr2" has value "115.00"
Then field "fbetr3" has value "460.00"
Then field "fbetr4" has value "1035.00"
Then field "proz1" has value "0.00"
Then field "proz2" has value "7.14"
Then field "proz3" has value "28.57"
Then field "proz4" has value "64.29"
And I append ScenarioHeadline to output file "ref_dashboard_cu.REF"
And I export fields "konto,rebetr" from table content to output file "ref_dashboard_cu.REF"

Scenario: Infosystem LOPAPAR - Widget Alterstruktur Verbindlichkeiten
Given I open the infosystem "LOPAPAR"
And I set field "vtab" to "Lieferant" 
And I set field "faellbis" to ""
And I press button "bstart"
And I save the current editor 

Scenario: Infosystem KBLSS - Widget Kontostand Banken
Given I open the infosystem "KBLSS"
And I set field "inklkredit" to "1" 
And I press button "bstart"
And I save the current editor 
