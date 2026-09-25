# *****************************************************************************
#  Name             : ref_op_vk_wg_edit.feature
#  Verantwortlich   : hc
#  Kontrolle        :
# *****************************************************************************
@persistent
Feature: Vorbelegung und Änderbarkeit der ZV-relevanten Felder in der VK-Rechnung und in der VK-Wertgutschrift

Background:
Given I set the fake date to "31.12.2022"

# ---------------------------------------------------------------------------------------------
Scenario: Stammdaten
# ---------------------------------------------------------------------------------------------

# Artikel 1001
Given I open an editor "artikel" from table "(Part):(Product)" with command "COPY" for record "1000"
And I set field "nummer" to "1001"
And I set field "such" to "A1001"
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: VK-Rechnung erzeugen und verbuchen
# ---------------------------------------------------------------------------------------------

# VK-Rechnung neu: 1VKRE
Given I open an editor "VKRE1" from table "(Sales):(Invoice)" with command "NEW" for record ""

# ----- Vorbelegung der Kopffelder beim Öffnen der Rechnungsmaske prüfen

Then field "vorganga" has value "Rechnung"
Then field "fakt" has value "ja"
# Kunde, Rechnungsempfaenger
Then field "kunde" has value ""
Then field "kl2" has value ""
# Buchungsdatum, Belegdatum
Then field "budat" has value "31.12.22"
Then field "vom" has value "31.12.22"
# Währung, Kurs
Then field "eweinh" has value "1"
Then field "waehr" has value "EUR"
Then field "ewekurs" has value "1.000000"
Then field "iwbu" has value "EUR"
# Rechnungsbetrag, skontierfähiger Betrag
Then field "rebetr" has value "0.00"
# Then field "skbbetr" has value "0.00"

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
Then field "zbed" has value ""
Then field "zbedschl" has value ""
Then field "vdat" has value "31.12.22"
Then field "tterm" has value ""
Then field "mterm" has value "nein"
Then field "zaform" has value ""
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

# ----- Änderbarkeit der Kopffelder beim Öffnen der Rechnungsmaske prüfen

Then field "vorganga" is modifiable
Then field "fakt" is modifiable
# Kunde, Rechnungsempfaenger
Then field "kunde" is modifiable
Then field "kl2" is modifiable
# Buchungsdatum, Belegdatum
Then field "budat" is modifiable
Then field "vom" is modifiable
# Währung, Kurs
Then field "eweinh" is not modifiable
Then field "waehr" is modifiable
Then field "ewekurs" is not modifiable
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
Then field "ophist" is not modifiable
Then field "opz" is not modifiable
Then field "zbedvert" is modifiable
Then field "zbed" is modifiable
Then field "zbedschl" is modifiable
Then field "vdat" is modifiable
Then field "tterm" is modifiable
Then field "mterm" is modifiable
Then field "zaform" is modifiable
Then field "sepamand" is not modifiable
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

# ----- Im Kopf vorbelegen: Kunde, Buchungsdatum und Belegdatum (< Tagesdatum), Währung, Kurs abweichend, Zahlungsbedingung -----

And I set fields
    | kunde    | 001        |
    | vom      | 01.11.22 |
    | budat    | 01.11.22 |
    | waehr    | USD        |
    | ewekurs  | 0.990000   |
    | zbed     | 201        |

# ----- Vorbelegung der Kopffelder prüfen

Then field "vorganga" has value "Rechnung"
Then field "fakt" has value "ja"
# Kunde, Rechnungsempfaenger
Then field "kunde" has value "001"
Then field "kl2" has value "001"
# Buchungsdatum, Belegdatum
Then field "budat" has value "01.11.22"
Then field "vom" has value "01.11.22"
# Währung, Kurs
Then field "eweinh" has value "1"
Then field "waehr" has value "USD"
Then field "ewekurs" has value "0.990000"
Then field "iwbu" has value "EUR"
# Rechnungsbetrag, skontierfähiger Betrag
Then field "rebetr" has value "0.00"
Then field "skbbetr" has value "0.00"

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
Then field "vdat" has value "01.11.22"
Then field "tterm" has value "04.02.23"
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

# ----- Änderbarkeit der Kopffelder beim Öffnen der Rechnungsmaske prüfen

Then field "vorganga" is modifiable
Then field "fakt" is modifiable
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

# ----- In der Tabelle vorbelegen: 2 Zeilen, Artikel, Menge und Preis -----
And I append rows
    | artikel | mge | preis  |
    | 1001    | 10  | 2000,00 |

# ----- Im Kopf vorbelegen: Identnummer, Suchwort, Buchen -----

And I set fields
    | num3     | 1VKRE  |
    | such3    | VKRE1|
    | ueb      | ja     |
    | fakt     | ja     | fakt ist bereits aktiviert

And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: VK-Rechnung +1VKRE zeigen
# ---------------------------------------------------------------------------------------------

Given I open an editor "VKRE1-VIEW" from table "(Sales):(Invoice)" with command "VIEW" for record "+1VKRE"

# ----- Vorbelegung der Kopffelder prüfen

Then field "num3" has value "1VKRE"
Then field "such3" has value "VKRE1"
Then field "vorganga" has value "Rechnung"
Then field "fakt" has value "ja"
# Kunde, Rechnungsempfaenger
Then field "kunde" has value "001"
Then field "kl2" has value "001"
# Buchungsdatum, Belegdatum
Then field "budat" has value "01.11.22"
Then field "vom" has value "01.11.22"
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
Then field "ophist" has value "OP1VKRE"
# Then field "opz" has value "?"    Identnummer der OP-Bewegung
Then field "zbedvert" has value ""
Then field "zbed" has value "201"
Then field "zbedschl" has value ""
Then field "vdat" has value "01.11.22"
Then field "tterm" has value "04.02.23"
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

# ----- Änderbarkeit der Kopffelder beim Öffnen der Rechnungsmaske prüfen

Then field "vorganga" is not modifiable
Then field "fakt" is not modifiable
# Kunde, Rechnungsempfaenger
Then field "kunde" is not modifiable
Then field "kl2" is not modifiable
# Buchungsdatum, Belegdatum
Then field "budat" is not modifiable
Then field "vom" is not modifiable
# Währung, Kurs
Then field "eweinh" is not modifiable
Then field "waehr" is not modifiable
Then field "ewekurs" is not modifiable
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
Then field "zbedvert" is not modifiable
# Relevanz: OP-Verlauf (OP), OP-Bewegung
Then field "ophist" is not modifiable
Then field "opz" is not modifiable
Then field "zbedvert" is not modifiable
Then field "zbed" is not modifiable
Then field "zbedschl" is not modifiable
Then field "vdat" is not modifiable
Then field "tterm" is not modifiable
Then field "mterm" is not modifiable
Then field "zaform" is not modifiable
Then field "sepamand" is not modifiable
Then field "bverb" is not modifiable
Then field "zasperre" is not modifiable
Then field "zareferenz" is not modifiable
Then field "vzweck" is not modifiable
Then field "zatext" is not modifiable
# Relevanz: QR-Rechnungen/QR-Zahlungen (Schweiz) NUR im Verkauf
Then field "gkonto" is not modifiable
Then field "fabverb" is not modifiable
# Relevanz: QR-Rechnungen/QR-Zahlungen (Schweiz)
Then field "zatlnr" is not modifiable
Then field "zaqrreferenz" is not modifiable
Then field "zarefpruef" is not modifiable
Then field "zakodzeile" is not modifiable

And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: Wertgutschrift erzeugen und verbuchen
# ---------------------------------------------------------------------------------------------

# Wertgutschrift: Rechnung -> Rechnung
Given I open an editor "VKRE1-WG1" from table "(Sales):(Invoice)" with command "INVOICE" for record "+1VKRE"

# ----- Vorbelegung der Kopffelder beim Öffnen der Wertgutschriftmaske prüfen

# Then field "such3" has value "VKRE1"
Then field "vorganga" has value "Kaufmännische Gutschrift"
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
Then field "rebetroffen" has value "23800.00"
Then field "opoffenproz" has value "100.0000"
Then field "opstatus" has value "offen"
# Relevanz: Barzahlung
Then field "kasskto" has value ""
# Relevanz: Zahlungsverteiler (OP-Verteiler)
Then field "opverteiler" has value ""
Then field "zbedvert" has value ""
# Relevanz: OP-Verlauf (OP), OP-Bewegung
Then field "ophist" has value "OP1VKRE"
# Then field "opz" has value "???"  Identnummer
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
Then field "kunde" is not modifiable
Then field "kl2" is not modifiable
# Buchungsdatum, Belegdatum
Then field "budat" is modifiable
Then field "vom" is modifiable
# Währung, Kurs
Then field "eweinh" is not modifiable
Then field "waehr" is not modifiable
Then field "ewekurs" is not modifiable
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

# ----- Belegdatum vorbelegen
And I set fields
   | vom    | 31.12.22  |

Then field "vdat" has value "31.12.22"
Then field "tterm" has value "05.04.23"
Then field "mterm" has value "nein"

# ----- Rechnung gutschreiben
Then field "ofmge" has value "-10" in row 1
Then field "mge" has value "0" in row 1
And I press button "komplettieren"
Then field "ofmge" has value "0" in row 1
Then field "mge" has value "-10" in row 1

# ----- Kopffelder vorbelegen
And I set fields
   | num3   | 1VKWG     |
   | such3  | VKWG1     |
   | ueb    | ja        |

And I save the current editor

# ---------------------------------------------------------------------------------------------
Scenario: VK-Wertgutschrift +1VKWG zeigen
# ---------------------------------------------------------------------------------------------

Given I open an editor "VKWG1-VIEW" from table "(Sales):(Invoice)" with command "VIEW" for record "+1VKWG"

# ----- Vorbelegung der Kopffelder prüfen

Then field "num3" has value "1VKWG"
Then field "such3" has value "VKWG1"
Then field "vorganga" has value "Kaufmännische Gutschrift"
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
Then field "rebetr" has value "-23800.00"
Then field "skbbetr" has value "-23800.00"

# --- ZV-relevanten Kopffelder
# OP-Status
Then field "rebetroffen" has value "0.00"
Then field "opoffenproz" has value "0.0000"
Then field "opstatus" has value "abgeschlossen"
# Relevanz: Barzahlung
Then field "kasskto" has value ""
# Relevanz: Zahlungsverteiler (OP-Verteiler)
Then field "opverteiler" has value ""
Then field "zbedvert" has value ""
# Relevanz: OP-Verlauf (OP), OP-Bewegung
Then field "ophist" has value "+OP1VKRE"
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
