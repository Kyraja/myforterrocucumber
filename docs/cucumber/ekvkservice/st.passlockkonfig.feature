@include @persistent
Feature: Testdaten fuer Kundensperre an Kundenkontakte/Lieferantenkontakte uebergeben oder Kundenkontakt entsperren
Background:
Given I set the fake date to "02.01.1995"
Given I set saved value "REF_FILE" to "ST.PASSLOCKKONFIG.CU.REF"
Given I set saved value "Feldliste" to "kontakt,kontaktname,tksperrkonfig,tlsperrkonfig,icon"

Scenario Outline: Kunden anlegen
Given I open an editor "<kunde>" from table "(Customer):(Customer)" with command "STORE" for record "<such>"
And I set fields
 | such     | <such>     |
 | namebspr | <namebspr> |
 | ans      | <ans>      |
 | str      | <str>      |
 | plz      | <plz>      |
 | nort     | <nort>     |
 | ustid    | <ustid>    |
 | lbed     | <lbed>     |
 | zbed     | <zbed>     |
And I save the current editor
Examples:
 | kunde | such  | namebspr | ans      | str             | plz   | nort | ustid       | lbed | zbed |
 | maier | maier | Maier AG | Maier AG | Poststraße 1    | 77777 | Dorf | DE123456789 | EXW  | 200  |
 | bauer | bauer | Bauer KG | Bauer KG | Hauptstraße 2   | 55555 | Kaff | DE987456321 | EXW  | 201  |
 | kopp  | kopp  | Kopp OHG | Kopp OHG | Schlossstraße 3 | 66666 | Ort  | DE147852369 | exw  | 202  |

Scenario Outline: Kundenkontakt anlegen
Given I open an editor "<kkontakt>" from table "(Customer):(CustomerContact)" with command "STORE" for record "<such>"
And I set fields
 | such                  | <such>                  |
 | firma                 | <firma>                 |
 | namebspr              | <namebspr>              |
 | sperrkonfigurationneu | <sperrkonfigurationneu> |
And I save the current editor
Examples:
 | kkontakt | such   | firma | namebspr            | sperrkonfigurationneu        |
 | k1maier  | maier1 | maier | Maier AG, Kontakt 1 |                              |
 | k2maier  | maier2 | maier | Maier AG, Kontakt 2 | Standard-Kundenkontaktsperre |
 | k3maier  | maier3 | maier | Maier AG, Kontakt 3 |                              |
 | k1bauer  | bauer1 | bauer | Bauer KG, Kontakt 1 |                              |
 | k2bauer  | bauer2 | bauer | Bauer KG, Kontakt 2 |                              |
 | k3bauer  | bauer3 | bauer | Bauer KG, Kontakt 3 |                              |
 | k1kopp   | kopp1  | kopp  | Kopp OHG, Kontakt 1 |                              |
 | k2kopp   | kopp2  | kopp  | Kopp OHG, Kontakt 2 | Standard-Kundenkontaktsperre |
 | k3kopp   | kopp3  | kopp  | Kopp OHG, Kontakt 3 |                              |

Scenario Outline: Interessenten anlegen
Given I open an editor "<interessent>" from table "(Customer):(Prospect)" with command "STORE" for record "<such>"
And I set fields
 | such                  | <such>                  |
 | namebspr              | <namebspr>              |
 | ans                   | <ans>                   |
 | str                   | <str>                   |
 | plz                   | <plz>                   |
 | nort                  | <nort>                  |
 | ustid                 | <ustid>                 |
 | lbed                  | <lbed>                  |
 | zbed                  | <zbed>                  |
And I save the current editor
Examples:
 | kunde  | such   | namebspr   | ans        | str             | plz   | nort  | ustid       | lbed | zbed |
 | kurz   | kurz   | Kurz AG    | Kurz AG    | Poststraße 4    | 77777 | IDorf | DE963214785 | EXW  | 200  |
 | lang   | lang   | Lang KG    | Lang KG    | Hauptstraße 5   | 55555 | IKaff | DE987412365 | EXW  | 201  |
 | mittel | mittel | Mittel OHG | Mittel OHG | Schlossstraße 6 | 66666 | IOrt  | DE852369741 | exw  | 202  | 

Scenario Outline: Interessentenkontakt anlegen
Given I open an editor "<Ikontakt>" from table "(Customer):(ProspectContact)" with command "STORE" for record "<such>"
And I set fields
 | such     | <such>     |
 | firma    | <firma>    |
 | namebspr | <namebspr> |
And I save the current editor
Examples:
 | kkontakt | such    | firma  | namebspr              |
 | k1kurz   | kurz1   | kurz   | Kurz AG, Kontakt 1    |
 | k2kurz   | kurz2   | kurz   | Kurz AG, Kontakt 2    |
 | k3kurz   | kurz3   | kurz   | Kurz AG, Kontakt 3    |
 | k1lang   | lang1   | lang   | Lang KG, Kontakt 1    |
 | k2lang   | lang2   | lang   | Lang KG, Kontakt 2    |
 | k3lang   | lang3   | lang   | Lang KG, Kontakt 3    |
 | k1mittel | mittel1 | mittel | Mittel OHG, Kontakt 1 |
 | k2mittel | mittel2 | mittel | Mittel OHG, Kontakt 2 |
 | k3mittel | mittel3 | mittel | Mittel OHG, Kontakt 3 |

Scenario Outline: Lieferanten anlege
Given I open an editor "<lieferant>" from table "(Vendor):(Vendor)" with command "STORE" for record "<such>"
And I set fields
 | such                  | <such>                  |
 | namebspr              | <namebspr>              |
 | ans                   | <ans>                   |
 | str                   | <str>                   |
 | plz                   | <plz>                   |
 | nort                  | <nort>                  |
 | ustid                 | <ustid>                 |
 | lbed                  | <lbed>                  |
 | zbed                  | <zbed>                  |
And I save the current editor
Examples:
 | lieferant | such    | namebspr   | ans       | str             | plz   | nort  | ustid       | lbed | zbed |
 | gold      | gold    | Gold AG    | Gold AG   | Poststraße 7    | 77777 | LDorf | DE123456789 | EXW  | 200  |
 | schwarz   | schwarz | Schwarz KG | Scharz KG | Hauptstraße 8   | 55555 | LKaff | DE987456321 | EXW  | 201  |
 | rot       | rot     | Rot OHG    | Rot OHG   | Schlossstraße 9 | 66666 | LOrt  | DE147852369 | EXW  | 202  |

Scenario Outline: Lieferantenkontakt anlegen
Given I open an editor "<lkontakt>" from table "(Vendor):(VendorContact)" with command "STORE" for record "<such>"
And I set fields
 | such                  | <such>                  |
 | firma                 | <firma>                 |
 | namebspr              | <namebspr>              |
 | sperrkonfigurationneu | <sperrkonfigurationneu> |
And I save the current editor
Examples:
 | kkontakt  | such    | firma    | namebspr              | sperrkonfigurationneu                   |
 | k1gold    | gold1    | gold    | Gold AG, Kontakt 1    | Standard-Lieferantenkontaktsperre       |
 | k2gold    | gold2    | gold    | Gold AG, Kontakt 2    |                                         |
 | k3gold    | gold3    | gold    | Gold AG, Kontakt 3    |                                         |
 | k1schwarz | schwarz1 | schwarz | Schwarz KG, Kontakt 1 | Standard-Lieferantenkontaktsperre       |
 | k2schwarz | schwarz2 | schwarz | Schwarz KG, Kontakt 2 |                                         |
 | k3schwarz | schwarz3 | schwarz | Schwarz KG, Kontakt 3 |                                         |
 | k1rot     | rot1     | rot     | Rot OHG, Kontakt 1    |                                         |
 | k2rot     | rot2     | rot     | Rot OHG, Kontakt 2    | Standard-Lieferantenkontaktsperrhinweis |
 | k3rot     | rot3     | rot     | Rot OHG, Kontakt 3    |                                         |

Scenario: Infosystem PASSLOCKKONFIG starten mit Kunde Maier
Given I open the infosystem "PASSLOCKCONFIG"
And I set field "objekt" to "K MAIER"
And I press start
Then the table has 3 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario: Infosystem PASSLOCKKONFIG starten mit Kunde Bauer
Given I open the infosystem "PASSLOCKCONFIG"
And I set field "objekt" to "K BAUER"
And I press start
Then the table has 3 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario: Infosystem PASSLOCKKONFIG starten mit Kunde Kopp
Given I open the infosystem "PASSLOCKCONFIG"
And I set field "objekt" to "K KOPP"
And I press start
Then the table has 3 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario: Infosystem PASSLOCKKONFIG starten mit Interessent Kurz
Given I open the infosystem "PASSLOCKCONFIG"
And I set field "objekt" to "K KURZ"
And I press start
Then the table has 3 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario: Infosystem PASSLOCKKONFIG starten mit Interessent Lang
Given I open the infosystem "PASSLOCKCONFIG"
And I set field "objekt" to "K LANG"
And I press start
Then the table has 3 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario: Infosystem PASSLOCKKONFIG starten mit Interessent Mittel
Given I open the infosystem "PASSLOCKCONFIG"
And I set field "objekt" to "K MITTEL"
And I press start
Then the table has 3 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario: Infosystem PASSLOCKKONFIG starten mit Lieferant Gold
Given I open the infosystem "PASSLOCKCONFIG"
And I set field "objekt" to "L GOLD"
And I press start
Then the table has 3 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario: Infosystem PASSLOCKKONFIG starten mit Lieferant Schwarz
Given I open the infosystem "PASSLOCKCONFIG"
And I set field "objekt" to "L SCHWARZ"
And I press start
Then the table has 3 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"

Scenario: Infosystem PASSLOCKKONFIG starten mit Lieferant Rot
Given I open the infosystem "PASSLOCKCONFIG"
And I set field "objekt" to "L ROT"
And I press start
Then the table has 3 rows
And I append ScenarioHeadline to output file "$REF_FILE"
And I export fields "$Feldliste" from table content to output file "$REF_FILE"
