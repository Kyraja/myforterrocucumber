@persistant
Feature: Feldvorbelegungen im OP Ausbuchen Kontrollsummen
Background:
Given I set the fake date to "16.10.04"
Scenario: Anzeigefelder im Kopf berechnen und pruefen

# ==========================================================================================
# Offene Posten ausbuchen: neu, zeigen, storno
# Zahlungswaehrung: EUR, USD
# Gegenkonto mit zweiter Kontenwaehrung USD und Zahlungswaehrung USD
# OP fuer ein OP-relevantes Sachkonto wird im Ausbuchungsvorgang erfasst

# ---------- Daten fuer den Test erfassen: Konten und Buchungen ----------

# ----- OP-relevantes Sachkonto 68551 erfassen
Given I open an editor "sachkonto" from table "05:01" with command "COPY" for record "68550"
And I set field "nummer" to "68551"
And I set field "namebspr" to "Nebenkosten des Geldverkehrs"
And I save the current editor

# ----- Bankkonto 18095 erfassen: Zahlungswaehrung leer
Given I open an editor "bankkonto" from table "05:01" with command "COPY" for record "18100"
And I set field "nummer" to "18095"
And I set field "namebspr" to "testbankkonto"
And I set field "karta" to "Bankkonto"
And I save the current editor

# ----- Bankkonto 18450 erfassen: Zahlungswaehrung und zweite Kontowaehrung gleich USD
Given I open an editor "bankkontoUSD" from table "05:01" with command "COPY" for record "18100"
And I set field "nummer" to "18450"
And I set field "namebspr" to "Bankkonto USD"
And I set field "karta" to "Bankkonto"
And I set field "w2ist" to "USD"
And I set field "w2gjahr" to "04"
And I set field "zawaehr" to "USD"
And I save the current editor

# ----- Buchung neu mit Bankkonto 18095, Erfassungswaehrung EUR
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "text" to "Buchung Einlage auf Bankkonto"
And I set field "budat" to "01.10.04"
And I set field "beleg" to "11"
And I create a new row at the end of the table
And I set field "konto" to "18100" in row 1
And I create a new row at the end of the table
And I set field "konto" to "18095" in row 2
And I set field "ewsbetr" to "1000" in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor	

# ----- Buchung neu mit Bankkonto 18450, Erfassungswaehrung USD
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "text" to "Buchung Einlage auf USD-Bankkonto"
And I set field "beleg" to "ANFBEST"
And I set field "budat" to "01.10.04"
And I set field "erfwaehr" to "USD" 
And I create a new row at the end of the table
And I set field "konto" to "18100" in row 1
And I create a new row at the end of the table
And I set field "konto" to "18450" in row 2
And I set field "ewsbetr" to "1000" in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor	

# ---------- <OP-Bearbeitung><neu>, Offene Posten ausbuchen ----------

Given I open an editor "OPAUSBU1neu" from table "102:04" with command "NEW" for record ""
And I set field "such" to "OPAUSBU1"
And I set field "beleg" to "0815"
#
# ----- Kontrollsummenfelder beim oeffnen der Maske
Then field "gkonto" has value ""
Then field "gkoasaldo" has value "0.00"
Then field "suzabetr" has value "0.00"
Then field "suskbetr" has value "0.00"
Then field "sumkursdiff" has value "0.00"
Then field "suofbetr" has value "0.00"
Then field "gkonsaldo" has value "0.00"
Then field "gkobetr" has value "0.00"
Then field "gkobetrrest" has value "0.00"
#
Then field "kkonto" has value ""
Then field "koasaldo" has value "0.00"
Then field "kozabetr" has value "0.00"
Then field "koskbetr" has value "0.00"
Then field "kokursdiff" has value "0.00"
Then field "kozrebetr" has value "0.00"
Then field "konsaldo" has value "0.00"
Then field "kobetr" has value "0.00"
Then field "kobetrrest" has value "0.00"
#
# ----- Gegenkonto 18095 (Zahlungswaehrung EUR) eintragen
And I set field "gkonto" to "18095"
Then field "gkonsaldo" has value "1000.00"
Then field "gkowaehr" has value "EUR"
#
# ----- Gegenkonto 18450 (Zahlungswaehrung USD) eintragen
And I set field "gkonto" to "18450"
Then field "gkowaehr" has value "USD"
Then field "gkonsaldo" has value "1000.00"
#
# ----- Zahlungswährung auf EUR aendern
And I set field "kwaehr" to "EUR"
Then field "gkowaehr" has value "EUR"
Then field "gkonsaldo" has value "953.29"
Then field "gkoasaldo" has value "953.29"
#
# ----- Zahlungswährung auf USD aendern
And I set field "kwaehr" to "USD"
Then field "gkowaehr" has value "USD"
Then field "gkoasaldo" has value "1000.00"
Then field "gkonsaldo" has value "1000.00"
#
# ----- Einen OP fuer das Konto 68551 in der ersten Zeile erfassen
And I create a new row at the end of the table
And I set field "opneu" to "ja" in row 1 
Then field "vom" has value "16.10.04" in row 1
#
And I set field "konto" to "68551" in row 1
Then field "koname" has value "Nebenkosten des Geldverkehrs" in row 1
#
And I set field "tbeleg" to "123" in row 1
And I set field "opzabetr" to "100" in row 1
Then field "sha" has value "Soll" in row 1
Then field "ofbetr" has value "-100.00" in row 1
Then field "sha" has value "Soll" in row 1
#
Then field "gkonto" has value "18450"
Then field "gkoasaldo" has value "1000.00"
Then field "suzabetr" has value "-100.00"
Then field "suskbetr" has value "0.00"
Then field "sumkursdiff" has value "0.00"
Then field "suofbetr" has value "100.00"
Then field "gkonsaldo" has value "900.00"
Then field "gkobetr" has value "0.00"
Then field "gkobetrrest" has value "100.00"
#
Then field "kkonto" has value "68551"
Then field "koasaldo" has value "0.00"
Then field "kozabetr" has value "-100.00"
Then field "koskbetr" has value "0.00"
Then field "kokursdiff" has value "0.00"
Then field "kozrebetr" has value "100.00"
Then field "konsaldo" has value "100.00"
Then field "kobetr" has value "0.00"
Then field "kobetrrest" has value "100.00"
#
# ----- Soll/Haben in Zeile 1 aendern: Soll --> Haben
And I set field "sha" to "Haben" in row 1
Then field "ofbetr" has value "-100.00" in row 1
Then field "opzabetr" has value "100.00" in row 1
Then field "sha" has value "Haben" in row 1
#
Then field "gkonto" has value "18450"
Then field "gkoasaldo" has value "1000.00"
Then field "suzabetr" has value "100.00"
Then field "suskbetr" has value "0.00"
Then field "sumkursdiff" has value "0.00"
Then field "suofbetr" has value "-100.00"
Then field "gkonsaldo" has value "1100.00"
Then field "gkobetr" has value "0.00"
Then field "gkobetrrest" has value "-100.00"
#
Then field "kkonto" has value "68551"
Then field "koasaldo" has value "0.00"
Then field "kozabetr" has value "100.00"
Then field "koskbetr" has value "0.00"
Then field "kokursdiff" has value "0.00"
Then field "kozrebetr" has value "-100.00"
Then field "konsaldo" has value "-100.00"
Then field "kobetr" has value "0.00"
Then field "kobetrrest" has value "-100.00"
#
# ----- Zahlungsbetrag aendern: 100.00 -> 50.00
And I set field "opzabetr" to "50" in row 1
Then field "ofbetr" has value "-50.00" in row 1
Then field "sha" has value "Haben" in row 1
#
Then field "gkoasaldo" has value "1000.00"
Then field "suzabetr" has value "50.00"
Then field "suskbetr" has value "0.00"
Then field "sumkursdiff" has value "0.00"
Then field "suofbetr" has value "-50.00"
Then field "gkonsaldo" has value "1050.00"
Then field "gkobetr" has value "0.00"
Then field "gkobetrrest" has value "-50.00"
#
Then field "kkonto" has value "68551"
Then field "koasaldo" has value "0.00"
Then field "kozabetr" has value "50.00"
Then field "koskbetr" has value "0.00"
Then field "kokursdiff" has value "0.00"
Then field "kozrebetr" has value "-50.00"
Then field "konsaldo" has value "-50.00"
Then field "kobetr" has value "0.00"
Then field "kobetrrest" has value "-50.00"
#
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor

# ---------- <OP-Bearbeitung> OPAUSBU1 <zeigen> ----------
Given I open an editor "OPAUSBU1zeigen" from table "102:04" with command "VIEW" for record "+OPAUSBU1"
#
Then field "gkonto" has value "18450"
Then field "gkoasaldo" has value "0.00"
Then field "suzabetr" has value "50.00"
Then field "suskbetr" has value "0.00"
Then field "sumkursdiff" has value "0.00"
Then field "suofbetr" has value "-50.00"
Then field "gkonsaldo" has value "0.00"
Then field "gkobetr" has value "0.00"
Then field "gkobetrrest" has value "-50.00"
#
Then field "kkonto" has value ""
Then field "koasaldo" has value "0.00"
Then field "kozabetr" has value "0.00"
Then field "koskbetr" has value "0.00"
Then field "kokursdiff" has value "0.00"
Then field "kozrebetr" has value "0.00"
Then field "konsaldo" has value "0.00"
Then field "kobetr" has value "0.00"
Then field "kobetrrest" has value "0.00"
#
And I close the current editor

# ---------- <OP-Bearbeitung> OPAUSBU1 <storno> ----------

Given I open an editor "OPAUSBU1storno" from table "102:04" with command "REVERSAL" for record "+OPAUSBU1"
#
Then field "gkonto" has value "18450"
Then field "gkoasaldo" has value "1050.00"
Then field "suzabetr" has value "-50.00"
Then field "suskbetr" has value "0.00"
Then field "sumkursdiff" has value "0.00"
Then field "suofbetr" has value "0.00"
Then field "gkonsaldo" has value "1000.00"
Then field "gkobetr" has value "0.00"
Then field "gkobetrrest" has value "50.00"
#
Then field "kkonto" has value ""
Then field "koasaldo" has value "0.00"
Then field "kozabetr" has value "0.00"
Then field "koskbetr" has value "0.00"
Then field "kokursdiff" has value "0.00"
Then field "kozrebetr" has value "0.00"
Then field "konsaldo" has value "0.00"
Then field "kobetrrest" has value "0.00"
#
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor

# ==========================================================================================
# Offene Posten ausbuchen: neu, zeigen, storno
# Zahlungswaehrung: EUR
# OPs beim Laden ausgleichen

# ---------- Daten fuer den Test erfassen: Konten und Buchungen ----------

# ----- Kunden erfassen
Given I open an editor "Kunde" from table "00:01" with command "COPY" for record "001"
And I set field "nummer" to "1eur"
And I set field "waehr" to "EUR"
And I save the current editor
#
# ----- Bankkonto 18eur erfassen: Zahlungswaehrung leer
Given I open an editor "bankkonto" from table "05:01" with command "COPY" for record "18100"
And I set field "nummer" to "18eur"
And I set field "namebspr" to "testbankkonto"
And I set field "karta" to "Bankkonto"
And I save the current editor

# ----- Buchung neu (Erfassungswaehrung EUR): OPs fuer Kunde 1eur erzeugen
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "01.01.04"
And I set field "beleg" to "1eur-1"
And I create a new row at the end of the table
And I set field "konto" to "K 1eur" in row 1
And I set field "ewsbetr" to "1000.00" in row 1
And I create a new row at the end of the table
And I set field "konto" to "44000" in row 2
And I set field "kstelle" to "101" in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor
#
Given I open an editor "Buchung" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "budat" to "01.01.04"
And I set field "beleg" to "1eur-2"
And I create a new row at the end of the table
And I set field "konto" to "K 1eur" in row 1
And I set field "ewsbetr" to "1000.00" in row 1
And I create a new row at the end of the table
And I set field "konto" to "44000" in row 2
And I set field "kstelle" to "101" in row 2
And I respond with answer "Ja" to the dialog with id "583"
And I save the current editor

# ---------- <OP-Bearbeitung><neu>, Offene Posten ausbuchen ----------

Given I open an editor "OPAUSBU1neu" from table "102:04" with command "NEW" for record ""
And I set field "such" to "OPAUSBU2"
And I set field "beleg" to "ausbu2"
#
# ----- Kontrollsummenfelder beim oeffnen der Maske
Then field "gkonto" has value ""
Then field "gkoasaldo" has value "0.00"
Then field "suzabetr" has value "0.00"
Then field "suskbetr" has value "0.00"
Then field "sumkursdiff" has value "0.00"
Then field "suofbetr" has value "0.00"
Then field "gkonsaldo" has value "0.00"
Then field "gkobetr" has value "0.00"
Then field "gkobetrrest" has value "0.00"
#
Then field "kkonto" has value ""
Then field "koasaldo" has value "0.00"
Then field "kozabetr" has value "0.00"
Then field "koskbetr" has value "0.00"
Then field "kokursdiff" has value "0.00"
Then field "kozrebetr" has value "0.00"
Then field "konsaldo" has value "0.00"
Then field "kobetr" has value "0.00"
Then field "kobetrrest" has value "0.00"
#
# ----- Gegenkonto 18eur (Zahlungswaehrung EUR) eintragen
And I set field "gkonto" to "18eur"
Then field "gkowaehr" has value "EUR"
Then field "gkonsaldo" has value "0.00"
Then field "gkoasaldo" has value "0.00"
#
And I set field "opausgleich" to "true"
#
# ----- OP OP1eur-1 laden
And I create a new row at the end of the table
And I set field "op" to "OP1eur-1" in row 1
#
Then field "opzabetr" has value "1000.00" in row 1
Then field "sha" has value "Haben" in row 1
Then field "ofbetr" has value "0.00" in row 1
#
Then field "gkonto" has value "18eur"
Then field "gkoasaldo" has value "0.00"
Then field "suzabetr" has value "1000.00"
Then field "suskbetr" has value "0.00"
Then field "sumkursdiff" has value "0.00"
Then field "suofbetr" has value "0.00"
Then field "gkonsaldo" has value "1000.00"
Then field "gkobetr" has value "0.00"
Then field "gkobetrrest" has value "-1000.00"
#
Then field "kkonto" has value "K 1eur"
Then field "koasaldo" has value "2000.00"
Then field "kozabetr" has value "1000.00"
Then field "koskbetr" has value "0.00"
Then field "kokursdiff" has value "0.00"
Then field "kozrebetr" has value "0.00"
Then field "konsaldo" has value "1000.00"
Then field "kobetr" has value "0.00"
Then field "kobetrrest" has value "-1000.00"
#
# ----- OP OP1eur-2 laden
And I create a new row at the end of the table
And I set field "op" to "OP1eur-2" in row 2
#
Then field "opzabetr" has value "1000.00" in row 2
Then field "sha" has value "Haben" in row 2
Then field "ofbetr" has value "0.00" in row 2
#
Then field "gkonto" has value "18eur"
Then field "gkoasaldo" has value "0.00"
Then field "suzabetr" has value "2000.00"
Then field "suskbetr" has value "0.00"
Then field "sumkursdiff" has value "0.00"
Then field "suofbetr" has value "0.00"
Then field "gkonsaldo" has value "2000.00"
Then field "gkobetr" has value "0.00"
Then field "gkobetrrest" has value "-2000.00"
#
Then field "kkonto" has value "K 1eur"
Then field "koasaldo" has value "2000.00"
Then field "kozabetr" has value "2000.00"
Then field "koskbetr" has value "0.00"
Then field "kokursdiff" has value "0.00"
Then field "kozrebetr" has value "0.00"
Then field "konsaldo" has value "0.00"
Then field "kobetr" has value "0.00"
Then field "kobetrrest" has value "-2000.00"
#
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor

# ---------- <OP-Bearbeitung> OPAUSBU2 <zeigen> ----------
Given I open an editor "OPAUSBU2zeigen" from table "102:04" with command "VIEW" for record "+OPAUSBU2"
#
Then field "gkonto" has value "18eur"
Then field "gkoasaldo" has value "0.00"
Then field "suzabetr" has value "2000.00"
Then field "suskbetr" has value "0.00"
Then field "sumkursdiff" has value "0.00"
Then field "suofbetr" has value "0.00"
Then field "gkonsaldo" has value "0.00"
Then field "gkobetr" has value "0.00"
Then field "gkobetrrest" has value "-2000.00"
#
Then field "kkonto" has value ""
Then field "koasaldo" has value "0.00"
Then field "kozabetr" has value "0.00"
Then field "koskbetr" has value "0.00"
Then field "kokursdiff" has value "0.00"
Then field "kozrebetr" has value "0.00"
Then field "konsaldo" has value "0.00"
Then field "kobetr" has value "0.00"
Then field "kobetrrest" has value "0.00"
#
And I close the current editor

# ---------- <OP-Bearbeitung> OPAUSBU2 <storno> ----------

Given I open an editor "OPAUSBU2storno" from table "102:04" with command "REVERSAL" for record "+OPAUSBU2"
#
Then field "gkonto" has value "18eur"
Then field "gkoasaldo" has value "2000.00"
Then field "suzabetr" has value "-2000.00"
Then field "suskbetr" has value "0.00"
Then field "sumkursdiff" has value "0.00"
Then field "suofbetr" has value "2000.00"
Then field "gkonsaldo" has value "0.00"
Then field "gkobetr" has value "0.00"
Then field "gkobetrrest" has value "2000.00"
#
Then field "kkonto" has value ""
Then field "koasaldo" has value "0.00"
Then field "kozabetr" has value "0.00"
Then field "koskbetr" has value "0.00"
Then field "kokursdiff" has value "0.00"
Then field "kozrebetr" has value "0.00"
Then field "konsaldo" has value "0.00"
Then field "kobetrrest" has value "0.00"
#
And I respond with answer "ja" to the dialog with id "588"
And I save the current editor
