# *****************************************************************************
#  Name             : ref_op_vk_rk_edit.feature
#  Verantwortlich   : hc
#  Kontrolle        :
# *****************************************************************************
@persistent
Feature: Vorbelegung und Änderbarkeit der ZV-relevanten Felder in der VK-Rechnungskorrektur

Background:
Given I set the fake date to "31.12.2022"

# ---------------------------------------------------------------------------------------------
Scenario: Rechnung (Rechnungskorrektur) aus Rechnung erzeugen und verbuchen
# VK-Rechnung und VK-Wertgutschrift im Testvorgänger ref_op_vk_wg_edit_cu erzeugt.
# ---------------------------------------------------------------------------------------------

# Rechnungskorrektur: Rechnung -> Rechnung
Given I open an editor "VKRE1-RK1" from table "(Sales):(Invoice)" with command "INVOICE" for record "+1VKRE"

# ----- Vorbelegung der Kopffelder beim Öffnen der Rechnungskorrektur prüfen

Then field "vorganga" has value "Kaufmännische Gutschrift"
Then field "fakt" has value "nein"
And I press button "burekorrektur"
Then field "vorganga" has value "Rechnung"
Then field "fakt" has value "nein"

# Kunde, Rechnungsempfaenger
Then field "kunde" has value "001"
Then field "kl2" has value "001"
# Buchungsdatum, Belegdatum
Then field "budat" has value "31.12.22"
Then field "vom" has value "31.12.22"
# Währung, Kurs
Then field "eweinh" has value "1"
Then field "waehr" has value "USD"
Then field "ewekurs" has value "0.990000"
Then field "iwbu" has value "EUR"
# Rechnungsbetrag, skontierfähiger Betrag
Then field "rebetr" has value "0.00"
Then field "skbbetr" has value "23800.00"

# --- ZV-relevanten Kopffelder
# OP-Status
Then field "rebetroffen" has value "0.00"
Then field "opoffenproz" has value "0.0000"
Then field "opstatus" has value "undefiniert"
# Relevanz: Barzahlung
Then field "kasskto" has value ""
# Relevanz: Zahlungsverteiler (OP-Verteiler)
Then field "opverteiler" has value ""
Then field "zbedvert" has value ""
# Relevanz: OP-Verlauf (OP), OP-Bewegung
Then field "ophist" has value ""
Then field "opz" has value ""
Then field "zbedvert" has value ""
Then field "zbed" has value "201"
Then field "zbedschl" has value ""
Then field "vdat" has value "31.12.22"
Then field "tterm" has value "05.04.23"
Then field "mterm" has value "nein"
Then field "zaform" has value "Lastschrift"
Then field "sepamand" has value ""
Then field "bverb" has value ""
Then field "zasperre" has value "nein"
Then field "zareferenz" has value ""
Then field "vzweck" has value ""
Then field "zatext" has value ""
# Relevanz: QR-Rechnungen/QR-Zahlungen (Schweiz) NUR im Verkauf
Then field "gkonto" has value ""
Then field "fabverb" has value ""
# Relevanz: QR-Rechnungen/QR-Zahlungen (Schweiz)
Then field "zatlnr" has value ""
Then field "zaqrreferenz" has value ""
Then field "zarefpruef" has value ""
Then field "zakodzeile" has value ""

# ----- Änderbarkeit der Kopffelder beim Öffnen der Wertgutschriftmaske prüfen

Then field "num3" is modifiable
Then field "such3" is modifiable
Then field "fakt" is not modifiable
# Kunde, Rechnungsempfaenger
Then field "kunde" is modifiable
Then field "kl2" is modifiable
# Buchungsdatum, Belegdatum
Then field "budat" is modifiable
Then field "vom" is modifiable
# Währung, Kurs
Then field "eweinh" is not modifiable
Then field "waehr" is modifiable
Then field "ewekurs" is modifiable
Then field "iwbu" is not modifiable
# Rechnungsbetrag, skontierfähiger Betrag
Then field "rebetr" is not modifiable
Then field "skbbetr" is not modifiable

# --- ZV-relevanten Kopffelder
# OP-Status
Then field "rebetroffen" is not modifiable
Then field "opoffenproz" is not modifiable
Then field "opstatus" is not modifiable
# Relevanz: Barzahlung
Then field "kasskto" is not modifiable
# Relevanz: Zahlungsverteiler (OP-Verteiler)
Then field "opverteiler" is not modifiable
Then field "zbedvert" is modifiable
# Relevanz: OP-Verlauf (OP), OP-Bewegung
Then field "ophist" is modifiable
Then field "opz" is modifiable
Then field "zbedvert" is modifiable
Then field "zbed" is modifiable
Then field "zbedschl" is modifiable
Then field "vdat" is modifiable
Then field "tterm" is modifiable
Then field "mterm" is modifiable
Then field "zaform" is modifiable
Then field "sepamand" is modifiable
Then field "bverb" is modifiable
Then field "zasperre" is modifiable
Then field "zareferenz" is modifiable
Then field "vzweck" is modifiable
Then field "zatext" is modifiable
# Relevanz: QR-Rechnungen/QR-Zahlungen (Schweiz) NUR im Verkauf
Then field "gkonto" is modifiable
Then field "fabverb" is modifiable
# Relevanz: QR-Rechnungen/QR-Zahlungen (Schweiz)
Then field "zatlnr" is modifiable
Then field "zaqrreferenz" is modifiable
Then field "zarefpruef" is modifiable
Then field "zakodzeile" is modifiable

Then field "vom" has value "31.12.22"
Then field "vdat" has value "31.12.22"
Then field "tterm" has value "05.04.23"
Then field "mterm" has value "nein"

# ----- In der Tabelle vorbelegen: Menge in der Zeile 1 -----
Then field "ofmge" has value "10" in row 1
And I set field "mge" to "10" in row 1

# ----- Kopffelder vorbelegen
And I set fields
   | num3   | 1VKRK     |
   | such3  | VKRK1     |
   | ueb    | ja        |

# And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: VK-Rechnungskorrektur +1VKRK zeigen
# ---------------------------------------------------------------------------------------------

Given I open an editor "VKRK1-VIEW" from table "(Sales):(Invoice)" with command "VIEW" for record "+1VKRK"

# ----- Vorbelegung der Kopffelder prüfen

Then field "num3" has value "1VKRK"
Then field "such3" has value "VKRK1"
Then field "vorganga" has value "Rechnung"
Then field "fakt" has value "nein"
# Kunde, Rechnungsempfaenger
Then field "kunde" has value "001"
Then field "kl2" has value "001"
# Buchungsdatum, Belegdatum
Then field "budat" has value "31.12.22"
Then field "vom" has value "31.12.22"
# Währung, Kurs
Then field "eweinh" has value "1"
Then field "waehr" has value "USD"
Then field "ewekurs" has value "0.990000"
Then field "iwbu" has value "EUR"
# Rechnungsbetrag, skontierfähiger Betrag
Then field "rebetr" has value "23800.00"
Then field "skbbetr" has value "23800.00"

# --- ZV-relevanten Kopffelder
# OP-Status
Then field "rebetroffen" has value "23800.00"
Then field "opoffenproz" has value "100.0000"
Then field "opstatus" has value "offen"
# Relevanz: Barzahlung
Then field "kasskto" has value ""
# Relevanz: Zahlungsverteiler (OP-Verteiler)
Then field "opverteiler" has value ""
Then field "zbedvert" has value ""
# Relevanz: OP-Verlauf (OP), OP-Bewegung
Then field "ophist" has value "OP1VKRK"
# Then field "opz" has value "?"    Identnummer der OP-Bewegung
Then field "zbedvert" has value ""
Then field "zbed" has value "201"
Then field "zbedschl" has value ""
Then field "vdat" has value "31.12.22"
Then field "tterm" has value "05.04.23"
Then field "mterm" has value "nein"
Then field "zaform" has value "Lastschrift"
Then field "sepamand" has value ""
Then field "bverb" has value ""
Then field "zasperre" has value "nein"
Then field "zareferenz" has value ""
Then field "vzweck" has value ""
Then field "zatext" has value ""
# Relevanz: QR-Rechnungen/QR-Zahlungen (Schweiz) NUR im Verkauf
Then field "gkonto" has value ""
Then field "fabverb" has value ""
# Relevanz: QR-Rechnungen/QR-Zahlungen (Schweiz)
Then field "zatlnr" has value ""
Then field "zaqrreferenz" has value ""
Then field "zarefpruef" has value ""
Then field "zakodzeile" has value ""

And I save the current editor
