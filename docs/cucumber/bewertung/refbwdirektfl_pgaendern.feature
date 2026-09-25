# *****************************************************************************
#  Autor          : uo
#  Verantwortlich : uo
#  Kontrolle      : wane, sih
# *****************************************************************************
@persistent
Feature: PG-ergänzung in rückmeldebewertungen/fertigungsbewertungen 

Background:
Given I set the fake date to "02.01.2002"

# ---------------------------------------------------------------------------------------------
Scenario: PG-änderungen und PG-ergänzung in rückmeldebewertungen/fertigungsbewertungen 
# ---------------------------------------------------------------------------------------------

Given I'm logged in with password "sy"
Given I set the fake date to "10.01.2002"

Given I open an editor "pgaendern" from table "(Part):(Product)" with command "UPDATE" for record "BAUT"
Then field "erlgrp" has value ""
And I set field "erlgrp" to "14105"
And I save the current editor

Given I open an editor "Bewertung" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,historisch==nein;artikel==BAUT;such==BUCHBAR6;@richtung=(Backwards);@ablageart=(Active);@maxtreffer=1"
Then field "historisch" has value "nein"
Then field "pgruppe" has value "66"
And I close the current editor

Given I open an editor "Bewertungskopie" from table "(Valuation):(Valuation)" with command "COPY" for record from editor "Bewertung"
Then field "historisch" has value "nein"
And I set field "bem" to "produktgruppe in nachfolger nicht geändert, ergänzt und diesen gespeichert"
Then field "pgruppe" has value "66"
And I press button "ergaenzen1"
And I save the current editor

Given I open an editor "Kontrolle-Bewertungskopie" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "Bewertungskopie"
Then field "historisch" has value "nein"
Then field "pgruppe" has value "66"
And I close the current editor

Given I open an editor "Bewertungskopie2" from table "(Valuation):(Valuation)" with command "COPY" for record from editor "Bewertung"
Then field "historisch" has value "nein"
And I set field "bem" to "produktgruppe in nachfolger geleert und diesen gespeichert"
Then field "pgruppe" has value "66"
And I set field "pgruppe" to ""
Then field "pgruppe" is empty
And I save the current editor

Given I open an editor "Kontrolle-Bewertungskopie2" from table "(Valuation):(Valuation)" with command "VIEW" for record from editor "Bewertungskopie2"
Then field "historisch" has value "nein"
Then field "pgruppe" has value "66"
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
# edpexport.sh -psy -l130:1 -f ppsrefid,such,nummer,pgruppe,historisch,bem -F -k 'historisch==nein;artikel==BAUT;such==BUCHBAR6;@ordnung=ppsrefid,bewzeitp,zaehler,nummer' -A beides

Given I open an editor "gegenprobe" from table "(Valuation):(Valuation)" with command "UPDATE" for search criteria "$,,historisch==nein;artikel==BAUT;such==BUCHBAR-PG;@richtung=(Backwards);@ablageart=(Active);@maxtreffer=1"
Then field "historisch" has value "nein"
Then field "pgruppe" has value "66"
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

Given I open an editor "Kontrolle-gegenprobe-historisch" from table "(Valuation):(Valuation)" with command "VIEW" for search criteria "$,,historisch==ja;artikel==BAUT;such==BUCHBAR-PG;@richtung=(Backwards);@ablageart=abgelegt;@maxtreffer=1"
Then field "historisch" has value "ja"
Then field "pgruppe" has value "66"
And I close the current editor

# die ausgabe der bewertungsdaten ist wie folgt möglich:
# edpexport.sh -psy -l130:1 -f ppsrefid,such,nummer,pgruppe,historisch,bem -F -k 'historisch==nein;artikel==BAUT;such==BUCHBAR-PG;@ordnung=ppsrefid,bewzeitp,zaehler,nummer' -A beides
