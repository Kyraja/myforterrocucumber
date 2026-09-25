@persistant
Feature: Betrags- und Waehrungsfelder in Offene Posten ausbuchen
Background:
Given I set the fake date to "15.10.04"
Scenario: Betragsfelder vorbelegen, berechnen und pruefen

# ==========================================================================================
# Test 1. Korrektur aus REWE-2992
# -------------------------------
# OP opUSD1 in Fremdwaehrung USD erfassen (Buchung neu)
# und in Buchungswaehrung ER ausbuchen.
# Beim Ausbuchen Feldnachbehandlung des Feldes budm pruefen.

# ---------- OP opUSD1 in USD erfassen (Buchung neu) ----------

Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "beleg" to "opUSD1"
And I set field "budat" to "01.10.04"
And I set field "erfwaehr" to "USD"
And I set field "ewekurs" to "0.897654"
And I create a new row at the end of the table
And I set field "konto" to "K 001" in row 1
And I set field "ewsbetr" to "10000.00" in row 1
Then field "sbetrag" has value "8976.54" in row 1
And I create a new row at the end of the table
And I set field "konto" to "44000" in row 2
And I set field "kstelle" to "101" in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

# ---------- <OP-Bearbeitung><neu>, Offene Posten ausbuchen ----------

Given I open an editor "OPAUSBU1neu" from table "102:04" with command "NEW" for record ""
And I set field "such" to "OPAUSBU1"
And I set field "beleg" to "ausEUR1"
And I set field "gkonto" to "18100"
And I set field "kwaehr" to "EUR"
#
Then field "kwaehr" has value "EUR"
Then field "kiwbu" has value "EUR"

# ----- OP such=OPopUSD1 laden -----
And I create a new row at the end of the table
And I set field "op" to "OPopUSD1" in row 1

# OP
Then field "tbeleg" has value "opUSD1" in row 1
Then field "konto" has value "K 001" in row 1

# Feldkontrolle: OP offen vor Ausbuchung:
Then field "feinh" has value "1" in row 1
Then field "waehr" has value "USD" in row 1
Then field "iwbu" has value "EUR" in row 1
Then field "ekkurs" has value "0.897654" in row 1
Then field "rebetr" has value "10000.00" in row 1
Then field "redm" has value "8976.54" in row 1
Then field "sha" has value "Haben" in row 1

# Ausbuchung
# ----- Kurs OP-Waehrung zu Buchungswaehrung vorbelegen
# ==> Kursfixierung kursfix wird aktiviert
# ==> Offener Betrag  in Zahlungswaehrung vor Ausbuchung (zarebetr) wird errechnet
And I set field "eopzaiwkurs" to "0.897654" in row 1
Then field "kursfix" has value "ja" in row 1
Then field "zarebetr" has value "8976.54" in row 1

# Feldkontrolle: Ausbuchung
Then field "feinh" has value "1" in row 1
Then field "waehr" has value "USD" in row 1
Then field "ziwbu" has value "EUR" in row 1
Then field "eopzaiwkurs" has value "0.897654" in row 1
Then field "twaehr" has value "EUR" in row 1
Then field "ziwbu" has value "EUR" in row 1
Then field "ezkurs" has value "1.000000" in row 1
Then field "kursfix" has value "ja" in row 1
#
Then field "zarebetr" has value "8976.54" in row 1
#
Then field "opzabetr" has value "0.00" in row 1
Then field "budm" has value "0.00" in row 1
Then field "skbetr" has value "0.00" in row 1
Then field "skdm" has value "0.00" in row 1
Then field "sksatz" has value "0" in row 1
Then field "kursdiff" has value "0.00" in row 1
Then field "ofbetr" has value "8976.54" in row 1

# Feldkontrolle: OP offen nach Ausbuchung
Then field "feinh" has value "1" in row 1
Then field "waehr" has value "USD" in row 1
Then field "iwbu" has value "EUR" in row 1
Then field "ekkurs" has value "0.897654" in row 1
Then field "zrebetr" has value "10000.00" in row 1
Then field "zredm" has value "8976.54" in row 1
Then field "sha" has value "Haben" in row 1

# ----- Zahlungsbetrag in Zahlungswaehrung OPZABETR mit offenen Betrag vorbelegen, 0% Skonto -----
And I set field "opzabetr" to "8976.54" in row 1
Then field "budm" has value "8976.54" in row 1
#
And I set field "sksatz" to "0" in row 1
Then field "skbetr" has value "0.00" in row 1
Then field "skdm" has value "0.00" in row 1
# OP ausgeglichen
Then field "ofbetr" has value "0.00" in row 1
#
# Feldkontrolle: Ausbuchung
#
Then field "feinh" has value "1" in row 1
Then field "waehr" has value "USD" in row 1
Then field "ziwbu" has value "EUR" in row 1
Then field "eopzaiwkurs" has value "0.897654" in row 1
Then field "twaehr" has value "EUR" in row 1
Then field "ziwbu" has value "EUR" in row 1
Then field "ezkurs" has value "1.000000" in row 1
Then field "kursfix" has value "ja" in row 1
#
Then field "zarebetr" has value "8976.54" in row 1
#
Then field "opzabetr" has value "8976.54" in row 1
Then field "budm" has value "8976.54" in row 1
Then field "skbetr" has value "0.00" in row 1
Then field "skdm" has value "0.00" in row 1
Then field "sksatz" has value "0" in row 1
Then field "kursdiff" has value "0.00" in row 1
Then field "ofbetr" has value "0.00" in row 1

# Feldkontrolle: OP offen nach Ausbuchung
Then field "feinh" has value "1" in row 1
Then field "waehr" has value "USD" in row 1
Then field "iwbu" has value "EUR" in row 1
Then field "ekkurs" has value "0.897654" in row 1
Then field "zrebetr" has value "0.00" in row 1
Then field "zredm" has value "0.00" in row 1
Then field "sha" has value "Haben" in row 1

# ----- Zahlungsbetrag in Buchungswaehrung BUDM um 0.04 EUR korrigieren -----
And I set field "budm" to "8976.50" in row 1
# ==> EZKURS darf sich nicht aendern (Wert 1.000000)
Then field "ezkurs" has value "1.000000" in row 1
# ==> ZAREBETR bleibt unveraendert
Then field "zarebetr" has value "8976.54" in row 1
# ==> OPZABETR gleich BUDM (wie eingetragen)
Then field "opzabetr" has value "8976.50" in row 1
Then field "budm" has value "8976.50" in row 1

# Feldkontrolle: Ausbuchung
#
Then field "feinh" has value "1" in row 1
Then field "waehr" has value "USD" in row 1
Then field "ziwbu" has value "EUR" in row 1
Then field "eopzaiwkurs" has value "0.897654" in row 1
Then field "twaehr" has value "EUR" in row 1
Then field "ziwbu" has value "EUR" in row 1
Then field "ezkurs" has value "1.000000" in row 1
Then field "kursfix" has value "ja" in row 1
#
Then field "zarebetr" has value "8976.54" in row 1
#
Then field "opzabetr" has value "8976.50" in row 1
Then field "budm" has value "8976.50" in row 1
Then field "skbetr" has value "0.00" in row 1
Then field "skdm" has value "0.00" in row 1
Then field "sksatz" has value "0" in row 1
Then field "kursdiff" has value "0.00" in row 1
Then field "ofbetr" has value "0.04" in row 1

# Feldkontrolle: OP offen nach Ausbuchung
Then field "feinh" has value "1" in row 1
Then field "waehr" has value "USD" in row 1
Then field "iwbu" has value "EUR" in row 1
Then field "ekkurs" has value "0.897654" in row 1
Then field "zrebetr" has value "0.04" in row 1
Then field "zredm" has value "0.04" in row 1
Then field "sha" has value "Haben" in row 1

And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
