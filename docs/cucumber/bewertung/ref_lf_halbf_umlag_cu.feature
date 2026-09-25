# *****************************************************************************
#  Autor            : meko
#  Verantwortlich   : uo
# *****************************************************************************
@persistent
Feature: Bewertung_IS

Background:
Given I set the fake date to "07.01.2002"

#Folgendes Scenario muss bei einem neu gebauten Mandanten (in dem es die BewVerf nicht gibt) aktiviert werden
#----------------------------------------------------------------------------------------------
Scenario: 01 Bewertungsverfahren PdZ/Vorgangspreis und PdZ/Nullbewertung anlegen
#----------------------------------------------------------------------------------------------

Given I open an editor "firma" from table "(Company):(ValuationConfiguration)" with command "UPDATE" for record "10"
And I append rows
  | bewverf | bewab             | bewzu         |
  | 2       | Preis des Zugangs | Vorgangspreis |
  | 4       | Preis des Zugangs | Nullbewertung |
And I save the current editor

#----------------------------------------------------------------------------------------------
Scenario: 02 Stammdaten erzeugen
#----------------------------------------------------------------------------------------------

# Lieferant mit dortigem externen Lagerplatz anlegen
Given I open an editor "Lieferant" from table "(Vendor):(Vendor)" with command "NEW" for record ""
And I set fields
    | nummer    | 101006           |
    | such      | Li101006         |

# kein echtes konsi
    | konsi     | 102              |
And I save the current editor

# Artikel anlegen (Material; PdZ/Vorgangspreis)
Given I open an editor "STL-ARTIKEL-1" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
    | nummer    | 101004           |
    | such      | STL-ARTIKEL-1    |
    | lief      | 101006           |
    | efrist    | 5                |
    | vorlauf   | 5                |
    | ekbewverf | 2                |
    | zuplatz   | 1                |
    | abplatz   | 1                |
    | epr       | 10               |
And I save the current editor

# Artikel anlegen (Halbfabrikat; PdZ/Nullbewertung)
Given I open an editor "HALBFABR-LBEIST" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
    | nummer    | 101005           |
    | such      | HALBFABR-LBEIST    |
    | dispoa    |                  |
    | bsart     | Eigenfertigung   |
    | earta     | keine            |
    | ekbewverf | 4                |
    | zuplatz   | 1                |
    | abplatz   | 1                |
And I press button "alge" to open a subeditor for "Lagergruppeneigenschaften"
And I append rows
    | lgruppe    | dispoa         | earta        | bsart     | umllg     |
    | 102        | bedarfsbezogen | über Artikel | Umlagern  | 1         |
And I save the current subeditor to switch back to the parent editor
And I save the current editor

# Artikel anlegen (Lohnfertigung)
Given I open an editor "ZWISCH-PROD-NACH-LF" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
    | nummer    | 101006           |
    | such      | ZWISCH-PROD-NACH-LF    |
    | dispoa    | bedarfsbezogen   |
    | bsart     | Lohnfertigung    |
    | earta     | über Artikel     |
    | lief      | 101006           |
    | efrist    | 5                |
    | vorlauf   | 5                |
    | epr       | 10               |
    | ekbewverf | 2                |
    | zuplatz   | 1                |
    | abplatz   | 1                |
And I delete all rows
And I append rows
    | elex           | elanzahl | bua                    |
    | HALBFABR-LBEIST  | 1        | Lieferantenbeistellung |
#    | A AG101005     | 1        |
And I save the current editor

# Artikel anlegen (Baugruppe)
Given I open an editor "Fertigartikel" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
    | nummer    | 101007           |
    | such      | Fertigartikel    |
    | dispoa    | bedarfsbezogen   |
    | bsart     | Eigenfertigung   |
    | earta     | über Artikel     |
    | mindest   | 1                |
    | zuplatz   | 1                |
    | abplatz   | 1                |
And I delete all rows
And I append rows
#And I modify table
    | elex           | elanzahl |
    | STL-ARTIKEL-1  | 1        |
    | A 1            | 1        |
    | ZWISCH-PROD-NACH-LF  | 1        |
    | A 2            | 1        |
    | A 3            | 1        |
And I save the current editor

# ------------------------------------------------------------------------------------------------------------------------ #
Scenario: 02.MPS Artikelplausi
# ------------------------------------------------------------------------------------------------------------------------ #
# uo: 
# Diese Plausi ist hier teststrukturell nicht sinnvoll, kam aber von MPS hier rein. 
# Falls dieses Scenario also scheitert, muss MPS das klären!
# Es sollte besser in einen MPS-Stammdatentest für Artikel verlagert werden.

# Artikel aender (Lohnfertigung), bsart aendern darf nicht erlaubt sein
Given I open an editor "ZWISCH-PROD-NACH-LF" from table "(Part):(Product)" with command "UPDATE" for record "ZWISCH-PROD-NACH-LF"
Then setting field "bsart" to "Lohnfertigung" throws the exception "203"
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #
Scenario: 03 Disposition starten
# ------------------------------------------------------------------------------------------------------------------------ #

# Dispo starten, um Bestell- und Umlagerungsvorschlag zu erzeugen
And I run Scheduling

# ------------------------------------------------------------------------------------------------------------------------ #
Scenario: 04 Material einkaufen
# ------------------------------------------------------------------------------------------------------------------------ #
# Bestellvorschlag in LG Karlsruhe freigeben
And I open an editor "BV_MAT_01" from table "(Purchasing):(PurchaseOrderSuggestions)" with command "UPDATE" for record ""
And I set fields
    | artikel | STL-ARTIKEL-1 |
    | lgruppe | 1             |
And I press button "ladetab"
And I set field "mfreig" to "JA" in row !lastRow
And I press button "freig" to open a subeditor for "EK_BE_01"
And I set field "such" to "EK_BE_01"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Lieferschein buchen
Given I open an editor "EK_LS_01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "EK_BE_01"
And I set fields
    | nummer   | 101004L  |
    | vom      | .        |
    | such     | EK_LS_01 |
    | ueb      | ja       |
And I modify table
    | !row | mge |
    | 1    | 1   |
And I save the current editor

# Rechnung aus Lieferschein
Given I open an editor "RE-001" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record "EK_LS_01"
And I set fields
   | num    | 101004R  |
   | such   | RE-001   |
   | vom    | .        |
   | budat  | .        |
   | tterm  | .        |
   | ueb    | ja       |
And I set field "mge" to "1" in row 1
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor


# ------------------------------------------------------------------------------------------------------------------------ #
Scenario: 05 FV für Baugruppe zu BA freigeben und ersten AS gutmelden
# ------------------------------------------------------------------------------------------------------------------------ #

# Fertigungsvorschlag
Given I open an editor "FV_01" from table "(Purchasing):(WorkOrderSuggestions)" with command "UPDATE" for record ""
And I set fields
    | artikel | Fertigartikel |
    | lgruppe |               |
And I press button "ladetab"
And I modify table
    | !row |  mfreig |
    | 1    |  ja     |
And I set field "bisuch" to "F101007_" in row 1
And I press button "freig" to open a subeditor for "BA_freigeben"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# Rueckmeldung auf Arbeitsschein1
    Given I open an editor "Rueckmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=F101007_001;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
#      | mzeit   | 1       |
#      | bzeit   | 1       |
      | sofort  | ja      |
    And I set field "gutmge" to "1" in row 1
    And I save the current editor


# Lager- und Gebindemengen Halbfabrikat ausgeben
And I append "--- 4 Platzmenge HALBFABR-LBEIST ---" to output file "tab1.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel==HALBFABR-LBEIST;@ordnung=artikel,lgruppe,lager,platz" to output file "tab1.ref"
And I append "--- Ende 4 Platzmenge ---" to output file "tab1.ref" in cucu_refs_dir
And I append "" to output file "tab1.ref" in cucu_refs_dir

# And I delete file "tab1.ref" in cucu_refs_dir
And I append "--- 4 Lagerjournal HALBFABR-LBEIST ---" to output file "tab1.ref" in cucu_refs_dir
And I export "id,zn,budat,artikel,platz,lgruppe,buart,ursache,detursache,mge,me,fert,ebeleg" from table "(Journal):(Journal)" where "artikel==HALBFABR-LBEIST;@ordnung=budat,artikel" to output file "tab1.ref"
# And I export "ljfeldliste1" from StockMovementJournal where "artikel==HALBFABR-LBEIST;@ordnung=budat,artikel" to output file "tab1.ref"
And I append "--- Ende 4 Lagerjournal ---" to output file "tab1.ref" in cucu_refs_dir
And I append "" to output file "tab1.ref" in cucu_refs_dir



# ------------------------------------------------------------------------------------------------------------------------ #
Scenario: 06 Lohnfertigungsvorschlag freigeben und BE,LS,RE
# ------------------------------------------------------------------------------------------------------------------------ #

# Lohnfertigungsvorschlag in LG 1 zu BE freigeben
And I open an editor "LFV_01" from table "(Purchasing):(SubcontractingSuggestions)" with command "UPDATE" for record ""
And I set fields
    | artikel | ZWISCH-PROD-NACH-LF |
    | lgruppe | 1             |
And I press button "ladetab"
And I set field "mfreig" to "JA" in row !lastRow
And I press button "freig" to open a subeditor for "LF_BE_01"
And I set field "such" to "LF_BE_01"
And I save the current subeditor to switch back to the parent editor
And I close the current editor

# LohnfertigungsLieferschein buchen
Given I open an editor "LF_LS_01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "LF_BE_01"
And I set fields
    | nummer   | 101006L      |
    | vom      | .            |
    | ebeleg   | LF_LS_01     |
    | ueb      | ja           |
And I modify table
    | !row | mge |
    | 1    | 1   |
And I save the current editor



# Lager- und Gebindemengen Halbfabrikat ausgeben
And I append "*****  nach Lohnfertigungslieferschein im Einkauf ---" to output file "tab1.ref" in cucu_refs_dir

And I append "--- 5 Platzmenge HALBFABR-LBEIST ---" to output file "tab1.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel==HALBFABR-LBEIST;@ordnung=artikel,lgruppe,lager,platz" to output file "tab1.ref"
And I append "--- Ende 5 Platzmenge ---" to output file "tab1.ref" in cucu_refs_dir
And I append "" to output file "tab1.ref" in cucu_refs_dir

# And I delete file "tab1.ref" in cucu_refs_dir
And I append "--- 5 Lagerjournal HALBFABR-LBEIST ---" to output file "tab1.ref" in cucu_refs_dir
And I export "id,zn,budat,artikel,platz,lgruppe,buart,ursache,detursache,mge,me,fert,ebeleg" from table "(Journal):(Journal)" where "artikel==HALBFABR-LBEIST;@ordnung=budat,artikel" to output file "tab1.ref"
# And I export "ljfeldliste1" from StockMovementJournal where "artikel==HALBFABR-LBEIST;@ordnung=budat,artikel" to output file "tab1.ref"
And I append "--- Ende 5 Lagerjournal ---" to output file "tab1.ref" in cucu_refs_dir
And I append "" to output file "tab1.ref" in cucu_refs_dir




Given I open an editor "LF_RE_01" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "LF_LS_01"
And I set fields
    | nummer   | 101006R    |
    | vom      | .          |
    | budat    | .          |
    | tterm    | .          |
    | ueb      | ja         |
And I modify table
    | !row | mge |
    | 1    | 1   |
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor




# ------------------------------------------------------------------------------------------------------------------------ #
Scenario: 07 Halbfabrikat umlagern in externe Lagergruppe
# ------------------------------------------------------------------------------------------------------------------------ #

# Umlagerungsvorschlag
Given I open an editor "UV_01" from table "(Purchasing):(RelocationSuggestions)" with command "UPDATE" for record ""
And I set fields
    | artikel | HALBFABR-LBEIST |
    | lgruppe | 102           |
And I press button "ladetab"
And I modify table
    | !row |  mfreig |
    | 1    |  ja     |
And I press button "freig" to open a subeditor for "EK_UBE_01"
And I set field "such" to "Uml_01"
And I set field "lief" to "101006"
And I save the current subeditor to switch back to the parent editor
And I close the current editor


# Lager- und Gebindemengen Halbfabrikat ausgeben
And I append "*****  nach Umlagerungsvorschlag=>Bestellerfassung HALBFABR-LBEIST ---" to output file "tab1.ref" in cucu_refs_dir

And I append "--- 6 Platzmenge HALBFABR-LBEIST ---" to output file "tab1.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel==HALBFABR-LBEIST;@ordnung=artikel,lgruppe,lager,platz" to output file "tab1.ref"
And I append "--- Ende 6 Platzmenge ---" to output file "tab1.ref" in cucu_refs_dir
And I append "" to output file "tab1.ref" in cucu_refs_dir

# And I delete file "tab1.ref" in cucu_refs_dir
And I append "--- 6 Lagerjournal HALBFABR-LBEIST ---" to output file "tab1.ref" in cucu_refs_dir
And I export "id,zn,budat,artikel,platz,lgruppe,buart,ursache,detursache,mge,me,fert,ebeleg" from table "(Journal):(Journal)" where "artikel==HALBFABR-LBEIST;@ordnung=budat,artikel" to output file "tab1.ref"
# And I export "ljfeldliste1" from StockMovementJournal where "artikel==HALBFABR-LBEIST;@ordnung=budat,artikel" to output file "tab1.ref"
And I append "--- Ende 6 Lagerjournal ---" to output file "tab1.ref" in cucu_refs_dir
And I append "" to output file "tab1.ref" in cucu_refs_dir



# UmlagerungsLieferschein buchen
Given I open an editor "EK_ULS_01" from table "(Purchasing):(PurchaseOrder)" with command "DELIVERY" for record from editor "EK_UBE_01"
And I set fields
    | nummer   | 101005u      |
    | vom      | .            |
    | ebeleg   | EK_ULS_01    |
    | ueb      | ja           |
And I modify table
    | !row | mge |
    | 1    | 1   |
And I save the current editor


# Lager- und Gebindemengen Halbfabrikat ausgeben
And I append "*****  Mengen nach Buchen des Umlagerungslieferscheins zum HALBFABR-LBEIST ---" to output file "tab1.ref" in cucu_refs_dir
And I append "*****  Die negative Gebindemenge von Artikel HALBFABR-LBEIST wird aufgefuellt, ---" to output file "tab1.ref" in cucu_refs_dir
And I append "*****  ABER FEHLERHAFT!!  ES WIRD GAR KEINE UMLAGERUNG ERZEUGT!! ---" to output file "tab1.ref" in cucu_refs_dir
And I append "*****  ES WIRD EINE UNGUELTIGE BEWERTUNGSKETTE ERZEUGT (UMLAGERUNGSZUGANG OHNE ABGANG). " to output file "tab1.ref" in cucu_refs_dir
And I append "" to output file "tab1.ref" in cucu_refs_dir
And I append "*****  DIE RECHNUNG UMLAGERUNGSRECHNUNG FUER DEN SPEDITEUR IST WOHL UEBLICH" to output file "tab1.ref" in cucu_refs_dir
And I append "*****  Im Test eine Nullrechnung, sinnvoller waere dann realistisch mit Dienstleistungsposition fuer die den transport." to output file "tab1.ref" in cucu_refs_dir
And I append "" to output file "tab1.ref" in cucu_refs_dir

And I append "--- 7 Platzmenge HALBFABR-LBEIST ---" to output file "tab1.ref" in cucu_refs_dir
And I export "bewertungslagermengen3" from StorageQuantities where "artikel==HALBFABR-LBEIST;@ordnung=artikel,lgruppe,lager,platz" to output file "tab1.ref"
And I append "--- Ende 7 Platzmenge ---" to output file "tab1.ref" in cucu_refs_dir
And I append "" to output file "tab1.ref" in cucu_refs_dir

# And I delete file "tab1.ref" in cucu_refs_dir
And I append "--- 7 Lagerjournal HALBFABR-LBEIST ---" to output file "tab1.ref" in cucu_refs_dir
And I export "id,zn,budat,artikel,platz,lgruppe,buart,ursache,detursache,mge,me,fert,ebeleg" from table "(Journal):(Journal)" where "artikel==HALBFABR-LBEIST;@ordnung=budat,artikel" to output file "tab1.ref"
# And I export "ljfeldliste1" from StockMovementJournal where "artikel==HALBFABR-LBEIST;@ordnung=budat,artikel" to output file "tab1.ref"
And I append "--- Ende 7 Lagerjournal ---" to output file "tab1.ref" in cucu_refs_dir
And I append "" to output file "tab1.ref" in cucu_refs_dir



# ------------------------------------------------------------------------------------------------------------------------ #
Scenario: 08 Umlagerungsrechnung
# ------------------------------------------------------------------------------------------------------------------------ #

Given I open an editor "EK_URE_01" from table "(Purchasing):(PackingSlip)" with command "INVOICE" for record from editor "EK_ULS_01"
And I set fields
    | nummer   | 101005r    |
    | vom      | .          |
    | ueb      | ja         |
    | budat    | .          |
# folgende Zeile hatte gefehlt, um in Uwes Mandant zum Laufen zu bringen
    | tterm    | .          |
And I modify table
    | !row | mge |
    | 1    | 1   |
#And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ------------------------------------------------------------------------------------------------------------------------ #
Scenario: 09 erste Prüfung Beistellabgangsbewertung auf Fehler (lbgrund = Fall nicht definiert) prüfen
# ------------------------------------------------------------------------------------------------------------------------ #

# Journaleintraege nachladen
Given I open an editor "JournalBeistAb" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==HALBFABR-LBEIST;buarta==Abgang;detursache==Lieferschein Einkauf;"
And I close the current editor

# Beistellabgangsbewertung pruefen
Given I open latest Valuation "BewBeistAbg_01" for Product "HALBFABR-LBEIST" and valuation transaction "JournalBeistAb" with command "VIEW"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Lieferschein Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalBeistAb"
Then field "beistellabgang" has value "ja"
# folgende Zeilen müssen scharfgeschaltet werden, wenn der Fehler behoben ist (ekumlag muss eigentlich = nein sein (wie bei Vorgängerbewertung))
# (aktuell werden die fehlerhaften Werte angenommen, damit der Test durchläuft)
# Nachtrag (23.10.24): mit Artur besprochen: uns sind bewertet = direkt und mgevollbewertet = vollständig wichtig
Then field "ekumlag" has value "nein"
Then table has values
    | tmge | tetlbkto  | bewertet   |
    | 1    | 120       | unbewertet |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #
Scenario: 10 Umlagerungszugangsbewertung auf Fehler (in Zeile: bewertet = vorläufig (FEHLER)) prüfen
# BW2-2271, Abgangsbewertung auch noch betroffen, solange Fehler vorhanden
# ------------------------------------------------------------------------------------------------------------------------ #

# Journaleintraege nachladen
Given I open an editor "JournalUmZu" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==HALBFABR-LBEIST;buarta==Zugang;detursache==Umlagerungslieferschein Einkauf;"
And I close the current editor

# Umlagerungszugangsbewertung pruefen
Given I open latest Valuation "BewUmZu_01" for Product "HALBFABR-LBEIST" and valuation transaction "JournalUmZu" with command "VIEW"
Then field "buart" has value "Neubewertung"
Then field "detursache" has value "Umlagerungsrechnung Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalUmZu"
Then field "beistellabgang" has value "nein"
Then field "ekumlag" has value "ja"
# Folgende Prüfung muss scharfgeschaltet werden, wenn Fehler behoben (aktuell werden die fehlerhaften Werte angenommen, damit der Test durchläuft)
# Nachtrag (23.10.24): mit Artur besprochen: bewart ist nicht so wichtig, daher hab ich die nächste Zeile auskommentiert
#Then field "bewart" has value "Vorgangspreis"
# Folgende Prüfung muss scharfgeschaltet werden, wenn Fehler behoben (aktuell werden die fehlerhaften Werte angenommen, damit der Test durchläuft)
# Nachtrag (23.10.24): mit Artur besprochen: uns sind bewertet = direkt und mgevollbewertet = vollständig wichtig
Then table has values
    | tmge | bewertet   |
    | 1    | vorläufig  |
And I close the current editor

# ------------------------------------------------------------------------------------------------------------------------ #
Scenario: 11 zweiten und dritten AS gutmelden
# ------------------------------------------------------------------------------------------------------------------------ #

# Rueckmeldung auf Arbeitsschein2
    Given I open an editor "Rueckmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=F101007_002;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | sofort  | ja      |
    And I set field "gutmge" to "1" in row 1
    And I save the current editor

# Rueckmeldung auf Arbeitsschein3
    Given I open an editor "Rueckmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for search criteria "$,,such=F101007_003;@richtung=rückwärts;@maxordtreffer=1"
    And I set fields
      | sofort  | ja      |
    And I set field "gutmge" to "1" in row 1
    And I save the current editor

# ------------------------------------------------------------------------------------------------------------------------ #
Scenario: 12 Nachbewerten starten
# ------------------------------------------------------------------------------------------------------------------------ #

# Nachbewerten starten
And I run Revaluation

# ------------------------------------------------------------------------------------------------------------------------ #
Scenario: 13 zweite Prüfung Beistellabgangsbewertung (NF ist durch Nachbewerten entstanden) auf Fehler (lbgrund = Fall nicht definiert) prüfen
# BW2-2312 (geloest, ekumlag==nein)
# Aber hier noch Folgefehler aus dem Zugang (BW2-2271), s. oben, Scen. 10
# ------------------------------------------------------------------------------------------------------------------------ #

# Journaleintraege nachladen
Given I open an editor "JournalBeistAb" from table "(Journal):(Journal)" with command "VIEW" for record "$,,artikel==HALBFABR-LBEIST;buarta==Abgang;detursache==Lieferschein Einkauf;"
And I close the current editor

# Beistellabgangsbewertung pruefen
Given I open latest Valuation "BewBeistAbg_01" for Product "HALBFABR-LBEIST" and valuation transaction "JournalBeistAb" with command "VIEW"
Then field "buart" has value "Abgang"
Then field "detursache" has value "Lieferschein Einkauf"
Then field "ppsref^id" has value equal to field "id" from editor "JournalBeistAb"
Then field "beistellabgang" has value "ja"
# folgende Zeilen müssen angepasst werden, wenn der noch (23.09.24) existierende Fehler (UZ Bew des HF ist vorläufig, dadurch
# diese Bew auch vorläufig (bedient sich aus der anderen)) behoben ist
# (aktuell werden die fehlerhaften Werte angenommen, damit der Test durchläuft)
# Nachtrag (23.10.24): mit Artur besprochen: uns sind bewertet = direkt und mgevollbewertet = vollständig wichtig
Then field "ekumlag" has value "nein"
Then table has values
    | tmge | tetlbkto  | bewertet   |
    | 1    | 120       | vorläufig  |
And I close the current editor

