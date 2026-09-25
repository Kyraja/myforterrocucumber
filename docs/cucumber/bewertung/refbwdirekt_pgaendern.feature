# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : wane, sih
# *****************************************************************************
@persistent
Feature: PG-ergänzung in materialbewertungen 

Background:
Given I set the fake date to "02.01.2002"

# ---------------------------------------------------------------------------------------------
Scenario: PG-änderungen und PG-ergänzung in materialbewertungen 
# ---------------------------------------------------------------------------------------------

Given I'm logged in with password "sy"
Given I set the fake date to "10.01.2002"

Given I open an editor "pgaendern" from table "(Part):(Product)" with command "UPDATE" for record "E1A-PO"
Then field "erlgrp" has value "14106"
And I set field "erlgrp" to "14105"
And I save the current editor

Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,historisch==nein;pgruppe==14106;artikel==E1A-PO;such==F41;@richtung=(Backwards);@ablageart=(Active);@maxtreffer=1"
Then field "historisch" has value "nein"
Then field "pgruppe" has value "14106"
And I close the current editor

Given I open an editor "Bewertungskopie" from table "(Valuation):(Valuation)" with command "COPY" for record from editor "Bewertung"
Then field "historisch" has value "nein"
And I set field "bem" to "produktgruppe in nachfolger nicht geändert, ergänzt und diesen gespeichert"
Then field "pgruppe" has value "14106"
And I press button "ergaenzen1"
And I save the current editor

Given I open an editor "Kontrolle-Bewertungskopie" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "Bewertungskopie"
Then field "historisch" has value "nein"
Then field "pgruppe" has value "14106"
And I close the current editor

Given I open an editor "Bewertungskopie2" from table "(Valuation):(Valuation)" with command "COPY" for record from editor "Bewertung"
Then field "historisch" has value "nein"
And I set field "bem" to "produktgruppe in nachfolger geleert und diesen gespeichert"
Then field "pgruppe" has value "14106"
And I set field "pgruppe" to ""
Then field "pgruppe" is empty
And I save the current editor

Given I open an editor "Kontrolle-Bewertungskopie2" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "Bewertungskopie2"
Then field "historisch" has value "nein"
Then field "pgruppe" has value "14106"
And I close the current editor

Given I open an editor "Bewertungskopie3" from table "(Valuation):(Valuation)" with command "COPY" for record from editor "Bewertung"
Then field "historisch" has value "nein"
And I set field "bem" to "produktgruppe in nachfolger auf anderen wert geändert und diesen gespeichert"
And I set field "pgruppe" to "14107"
And I save the current editor

Given I open an editor "Kontrolle-Bewertungskopie3" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "Bewertungskopie3"
Then field "historisch" has value "nein"
Then field "pgruppe" has value "14107"
And I close the current editor

# die ausgabe der bewertungsdaten ist wie folgt möglich:
# edpexport.sh -psy -l130:1 -f ppsrefid,such,nummer,pgruppe,historisch,bem -F -k 'historisch==nein;artikel==E1A-PO;such==F41;@ordnung=ppsrefid,bewzeitp,zaehler,nummer' -A beides

Given I open an editor "gegenprobe" from table "(Valuation):(Valuation)" with command "UPDATE" for search criteria "$,,historisch==nein;pgruppe==14106;artikel==E1A-PO;such==F39;@richtung=(Backwards);@ablageart=(Active);@maxtreffer=1"
Then field "historisch" has value "nein"
Then field "pgruppe" has value "14106"
And I set field "pgruppe" to ""
Then field "pgruppe" is empty
And I set field "bem" to "gegenprobe: produktgruppe in erster bewertung geleert und gespeichert"
# Then field "pgruppe" has value "14105"
And I save the current editor

Given I open an editor "Kontrolle-gegenprobe" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "gegenprobe"
Then field "historisch" has value "nein"
Then field "bem" has value "gegenprobe: produktgruppe in erster bewertung geleert und gespeichert"
Then field "pgruppe" has value "14105"
And I close the current editor

Given I open an editor "Kontrolle-gegenprobe-historisch" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,historisch==ja;pgruppe==14106;artikel==E1A-PO;such==F39;@richtung=(Backwards);@ablageart=abgelegt;@maxtreffer=1"
Then field "historisch" has value "ja"
Then field "bem" is empty
Then field "pgruppe" has value "14106"
And I close the current editor

# die ausgabe der bewertungsdaten ist wie folgt möglich:
# edpexport.sh -psy -l130:1 -f ppsrefid,such,nummer,pgruppe,historisch,bem -F -k 'artikel==E1A-PO;such==F39;@ordnung=ppsrefid,bewzeitp,zaehler,nummer' -A beides
