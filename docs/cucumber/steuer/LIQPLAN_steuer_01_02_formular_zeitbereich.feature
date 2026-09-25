# *****************************************************************************
#  Name             : LIQPLAN_steuer_01_02_formular_zeitbereich.feature
#  Autor            : wane
#  Verantwortlich   : wane
#  Kontrolle        :
#  Funktion         : Liqui-Planung mit unterschiedlichen Zeitbereichen in USTVA-Formular
#                     und Liqui-Planungsscenario:
#                     * Planung monatlich, Formular monatlich
#                     * Planung monatlich, Formular quartalsweise
#                     * Planung monatlich, Formular jährlich
#                     * Planung quartalsweise, Formular monatlich
#                     * Planung jährlich, Formular monatlich
#                     * Planung jährlich, Formular quartalsweise
#
#                     Parallel werden auch IS LIQPLANDETAILS-Aufrufe bzw Uebergaenge
#                     aus IS LIQPLAN nach IS LIQPLANDETAILS getestet.
#
#
# *****************************************************************************

@persistent
Feature: LIQPLAN_steuer_01_02_formular_zeitbereich.feature
Background: MMM

Given I set the fake date to "07.01.1995"

Scenario: (Planung monatlich, Formular monatlich)

# Ust-Formular Konfiguration
Given I open an editor "temp" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "USTVA2020"
And I set field "zeitraum" to "monatlich"
And I press button "berech"
Then I save the current editor

# Liquiditätsplanung öffnen (Planung monatlich, Formular monatlich)
# (Infosystem) LIQPLAN
Given I open the infosystem "LIQPLAN"
And I press button "bstart"
Then table has values
|tposition                       |tekvk  |twert0|twert1|twert2|twert3|twert4  |twert5  |twert6  |twert7  |twert8  |twert9  |twert10 |twert11 |twert12 |twert13  |tzeilensum|
|Eigene liquide Mittel (AB)      |       |      |      |      |-11.15|-11.15  |4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25  |          |
|Kreditlinie (AB)                |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zahlungsmittel (AB)             |       |      |      |      |-11.15|-11.15  |4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25  |          |
|Offene Posten                   |Verkauf|      |      |      |      |        |        |        |115.00  |        |        |        |115.00  |        |2530.00  |2760.00   |
|Rechnungsobligo                 |Verkauf|      |      |      |      |4140.00 |        |        |        |        |5520.00 |        |        |        |-9660.00 |          |
|Lieferobligo                    |Verkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |13800.00 |13800.00  |
|Sonstige Einzahlungen           |Verkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Einzahlungen gesamt             |       |      |      |      |      |4140.00 |        |        |115.00  |        |5520.00 |        |115.00  |        |6670.00  |16560.00  |
|Offene Posten                   |Einkauf|      |      |11.15 |      |11.15   |        |        |11.15   |        |11.15   |        |11.15   |        |211.94   |267.69    |
|Rechnungsobligo                 |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Lieferobligo                    |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Sonstige Auszahlungen           |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Auszahlungen gesamt             |       |      |      |11.15 |      |11.15   |        |        |11.15   |        |11.15   |        |11.15   |        |211.94   |267.69    |
|Liquiditätssaldo I             |       |      |      |-11.15|      |4128.85 |        |        |103.85  |        |5508.85 |        |103.85  |        |6458.06  |          |
|Gebuchte Umsatzsteuerzahllast   |       |      |      |      |      |        |        |        |27.00   |        |        |        |27.00   |        |297.00   |351.00    |
|Umsatzsteuerzahllast aus Obligos|       |      |      |      |      |        |        |        |540.00  |        |        |        |720.00  |        |540.00   |1800.00   |
|Zinssatz Bereitstellung (%)     |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinsen Bereitstellung           |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinssatz Inanspruchnahme (%)    |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinsen Inanspruchnahme          |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Weitere Belastungen gesamt      |       |      |      |      |      |        |        |        |567.00  |        |        |        |747.00  |        |837.00   |2151.00   |
|Liquiditätssaldo II            |       |      |      |-11.15|      |4128.85 |        |        |-463.15 |        |5508.85 |        |-643.15 |        |5621.06  |          |
|Eigene liquide Mittel (EB)      |       |      |      |-11.15|-11.15|4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25 |14141.31 |          |
|Kreditlinie (EB)                |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zahlungsmittel (EB)             |       |      |      |-11.15|-11.15|4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25 |14141.31 |          |
|Inanspruchnahme Kreditlinie abs.|       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Inanspruchnahme Kreditlinie (%) |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Änderung Kreditvolumen         |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
# Wechsel in LIQPLANDETAILS
And I press button "twertnachws7" to open a subeditor for "" in row 15
And I press button "bstart"
Then the table has 1 rows
# Kopffelder
Then field "stichtag" has value "07.01.1995" in row 0
Then field "position" has value "Gebuchte Umsatzsteuerzahllast" in row 0
Then field "periodevon" has value "7" in row 0
Then field "periodebis" has value "7" in row 0
Then field "planszenario" has value "STD" in row 0
Then field "zeiteinheit" has value "Woche" in row 0
# Tabellenfelder
Then field "tterm" has value "15.02.1995" in row 1
Then field "tzabetr" has value "27.00" in row 1
Then field "tbelegtyp" has value "Umsatzsteuervoranmeldung" in row 1
#
Then field "tbelzeigen" is modifiable in row 1
#  zur Zeit nicht moeglich
#  Then pressing button "tbelzeigen" in row 1 to open a subeditor throws the exception ""
#  # zurueck zu IS LIQPLANDETAILS
#  And I close the current subeditor to switch back to the parent editor
# zurueck zum USTVA-Formular
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Umsatzsteuerzahllast aus Obligo für Anzahlungen  (Planung monatlich, Formular monatlich)
# (Infosystem) LIQPLANDETAILS
Given I open the infosystem "LIQPLANDETAILS"
# (Infosystem) LIQPLANDETAILS
#stichtag=19950107|zeiteinheit=(Week)|auswaehr=DEM|bukreis=HGB|buwaehr=DEM|planszenario=STD|kategorieauswert=0|allekategorien=1|zeigealle=0|periodevon=13|periodebis=13|position=Umsatzsteuerzahllast aus Obligos
And I set fields
|stichtag|19950107|
|zeiteinheit|(Week)|
|auswaehr|DEM|
|bukreis|HGB|
|buwaehr|DEM|
|planszenario|STD|
|kategorieauswert|0|
|allekategorien|1|
|zeigealle|0|
|periodevon|13|
|periodebis|13|
|position|Umsatzsteuerzahllast aus Obligos|
And I press button "bstart"
Then the table has 3 rows
Then field "tterm" has value "15.04.1995" in row 1
Then field "tzabetr" has value "1800.00" in row 1
Then field "tterm" has value "15.04.1995" in row 2
Then field "tzabetr" has value "-540.00" in row 2
Then field "tterm" has value "15.04.1995" in row 3
Then field "tzabetr" has value "-720.00" in row 3

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Scenario: (Planung monatlich, Formular quartalsweise)

# Ust-Formular Konfiguration
Given I open an editor "temp" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "USTVA2020"
And I set field "zeitraum" to "quartalsweise"
And I press button "berech"
Then I save the current editor


# Liquiditätsplanung öffnenv (Planung monatlich, Formular quartalsweise)
# (Infosystem) LIQPLAN
Given I open the infosystem "LIQPLAN"

And I press button "bstart"
Then table has values
|tposition                       |tekvk  |twert0|twert1|twert2|twert3|twert4  |twert5  |twert6  |twert7  |twert8  |twert9  |twert10 |twert11 |twert12 |twert13  |tzeilensum|
|Eigene liquide Mittel (AB)      |       |      |      |      |-11.15|-11.15  |4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25  |          |
|Kreditlinie (AB)                |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zahlungsmittel (AB)             |       |      |      |      |-11.15|-11.15  |4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25  |          |
|Offene Posten                   |Verkauf|      |      |      |      |        |        |        |115.00  |        |        |        |115.00  |        |2530.00  |2760.00   |
|Rechnungsobligo                 |Verkauf|      |      |      |      |4140.00 |        |        |        |        |5520.00 |        |        |        |-9660.00 |          |
|Lieferobligo                    |Verkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |13800.00 |13800.00  |
|Sonstige Einzahlungen           |Verkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Einzahlungen gesamt             |       |      |      |      |      |4140.00 |        |        |115.00  |        |5520.00 |        |115.00  |        |6670.00  |16560.00  |
|Offene Posten                   |Einkauf|      |      |11.15 |      |11.15   |        |        |11.15   |        |11.15   |        |11.15   |        |211.94   |267.69    |
|Rechnungsobligo                 |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Lieferobligo                    |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Sonstige Auszahlungen           |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Auszahlungen gesamt             |       |      |      |11.15 |      |11.15   |        |        |11.15   |        |11.15   |        |11.15   |        |211.94   |267.69    |
|Liquiditätssaldo I             |       |      |      |-11.15|      |4128.85 |        |        |103.85  |        |5508.85 |        |103.85  |        |6458.06  |          |
|Gebuchte Umsatzsteuerzahllast   |       |      |      |      |      |        |        |        |27.00   |        |        |        |27.00   |        |351.00   |405.00    |
|Umsatzsteuerzahllast aus Obligos|       |      |      |      |      |        |        |        |540.00  |        |        |        |720.00  |        |540.00   |1800.00   |
|Zinssatz Bereitstellung (%)     |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinsen Bereitstellung           |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinssatz Inanspruchnahme (%)    |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinsen Inanspruchnahme          |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Weitere Belastungen gesamt      |       |      |      |      |      |        |        |        |567.00  |        |        |        |747.00  |        |891.00   |2205.00   |
|Liquiditätssaldo II            |       |      |      |-11.15|      |4128.85 |        |        |-463.15 |        |5508.85 |        |-643.15 |        |5567.06  |          |
|Eigene liquide Mittel (EB)      |       |      |      |-11.15|-11.15|4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25 |14087.31 |          |
|Kreditlinie (EB)                |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zahlungsmittel (EB)             |       |      |      |-11.15|-11.15|4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25 |14087.31 |          |
|Inanspruchnahme Kreditlinie abs.|       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Inanspruchnahme Kreditlinie (%) |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Änderung Kreditvolumen         |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
# Wechsel in LIQPLANDETAILS
And I press button "twertnachws7" to open a subeditor for "" in row 15
And I press button "bstart"
Then the table has 1 rows
# Kopffelder
Then field "stichtag" has value "07.01.1995" in row 0
Then field "position" has value "Gebuchte Umsatzsteuerzahllast" in row 0
Then field "periodevon" has value "7" in row 0
Then field "periodebis" has value "7" in row 0
Then field "planszenario" has value "STD" in row 0
Then field "zeiteinheit" has value "Woche" in row 0
# Tabellenfelder
Then field "tterm" has value "15.02.1995" in row 1
Then field "tzabetr" has value "27.00" in row 1
Then field "tbelegtyp" has value "Umsatzsteuervoranmeldung" in row 1
#
Then field "tbelzeigen" is modifiable in row 1
#  zur Zeit nicht moeglich
#  Then pressing button "tbelzeigen" in row 1 to open a subeditor throws the exception ""
#  # zurueck zu IS LIQPLANDETAILS
#  And I close the current subeditor to switch back to the parent editor
# zurueck zum USTVA-Formular
And I close the current subeditor to switch back to the parent editor
And I close the current editor

# Umsatzsteuerzahllast aus Obligo für Anzahlungen (Planung monatlich, Formular quartalsweise)
# (Infosystem) LIQPLANDETAILS
Given I open the infosystem "LIQPLANDETAILS"
# (Infosystem) LIQPLANDETAILS
#stichtag=19950107|zeiteinheit=(Week)|auswaehr=DEM|bukreis=HGB|buwaehr=DEM|planszenario=STD|kategorieauswert=0|allekategorien=1|zeigealle=0|periodevon=13|periodebis=13|position=Umsatzsteuerzahllast aus Obligos
And I set fields
|stichtag|19950107|
|zeiteinheit|(Week)|
|auswaehr|DEM|
|bukreis|HGB|
|buwaehr|DEM|
|planszenario|STD|
|kategorieauswert|0|
|allekategorien|1|
|zeigealle|0|
|periodevon|13|
|periodebis|13|
|position|Umsatzsteuerzahllast aus Obligos|
And I press button "bstart"
Then the table has 3 rows
Then field "tterm" has value "15.04.1995" in row 1
Then field "tzabetr" has value "1800.00" in row 1
Then field "tterm" has value "15.04.1995" in row 2
Then field "tzabetr" has value "-540.00" in row 2
Then field "tterm" has value "15.04.1995" in row 3
Then field "tzabetr" has value "-720.00" in row 3

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Scenario: (Planung monatlich, Formular jährlich)
# Ust-Formular Konfiguration
Given I open an editor "temp" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "USTVA2020"
And I set field "zeitraum" to "jährlich"
And I press button "berech"
Then I save the current editor


# Liquiditätsplanung öffnen (Planung monatlich, Formular jährlich)
# (Infosystem) LIQPLAN
Given I open the infosystem "LIQPLAN"
And I press button "bstart"
Then table has values
|tposition                       |tekvk  |twert0|twert1|twert2|twert3|twert4  |twert5  |twert6  |twert7  |twert8  |twert9  |twert10 |twert11 |twert12 |twert13  |tzeilensum|
|Eigene liquide Mittel (AB)      |       |      |      |      |-11.15|-11.15  |4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25  |          |
|Kreditlinie (AB)                |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zahlungsmittel (AB)             |       |      |      |      |-11.15|-11.15  |4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25  |          |
|Offene Posten                   |Verkauf|      |      |      |      |        |        |        |115.00  |        |        |        |115.00  |        |2530.00  |2760.00   |
|Rechnungsobligo                 |Verkauf|      |      |      |      |4140.00 |        |        |        |        |5520.00 |        |        |        |-9660.00 |          |
|Lieferobligo                    |Verkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |13800.00 |13800.00  |
|Sonstige Einzahlungen           |Verkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Einzahlungen gesamt             |       |      |      |      |      |4140.00 |        |        |115.00  |        |5520.00 |        |115.00  |        |6670.00  |16560.00  |
|Offene Posten                   |Einkauf|      |      |11.15 |      |11.15   |        |        |11.15   |        |11.15   |        |11.15   |        |211.94   |267.69    |
|Rechnungsobligo                 |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Lieferobligo                    |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Sonstige Auszahlungen           |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Auszahlungen gesamt             |       |      |      |11.15 |      |11.15   |        |        |11.15   |        |11.15   |        |11.15   |        |211.94   |267.69    |
|Liquiditätssaldo I             |       |      |      |-11.15|      |4128.85 |        |        |103.85  |        |5508.85 |        |103.85  |        |6458.06  |          |
|Gebuchte Umsatzsteuerzahllast   |       |      |      |      |      |        |        |        |27.00   |        |        |        |27.00   |        |594.00   |648.00    |
|Umsatzsteuerzahllast aus Obligos|       |      |      |      |      |        |        |        |540.00  |        |        |        |720.00  |        |540.00   |1800.00   |
|Zinssatz Bereitstellung (%)     |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinsen Bereitstellung           |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinssatz Inanspruchnahme (%)    |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinsen Inanspruchnahme          |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Weitere Belastungen gesamt      |       |      |      |      |      |        |        |        |567.00  |        |        |        |747.00  |        |1134.00  |2448.00   |
|Liquiditätssaldo II            |       |      |      |-11.15|      |4128.85 |        |        |-463.15 |        |5508.85 |        |-643.15 |        |5324.06  |          |
|Eigene liquide Mittel (EB)      |       |      |      |-11.15|-11.15|4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25 |13844.31 |          |
|Kreditlinie (EB)                |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zahlungsmittel (EB)             |       |      |      |-11.15|-11.15|4117.70 |4117.70 |4117.70 |3654.55 |3654.55 |9163.40 |9163.40 |8520.25 |8520.25 |13844.31 |          |
|Inanspruchnahme Kreditlinie abs.|       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Inanspruchnahme Kreditlinie (%) |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Änderung Kreditvolumen         |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
# Versuch in LIQPLANDETAILS zu wechseln
Then pressing button "twertnachws13" in row 3 to open a subeditor throws the exception "5705"
And pressing button "twertnachws13" in row 3 to open a subeditor throws the exception "An dieser Stelle ist leider keine Detailausgabe möglich."



# Umsatzsteuerzahllast aus Obligo für Anzahlungen (Planung monatlich, Formular jährlich)
# (Infosystem) LIQPLANDETAILS
Given I open the infosystem "LIQPLANDETAILS"
# (Infosystem) LIQPLANDETAILS
#stichtag=19950107|zeiteinheit=(Week)|auswaehr=DEM|bukreis=HGB|buwaehr=DEM|planszenario=STD|kategorieauswert=0|allekategorien=1|zeigealle=0|periodevon=13|periodebis=13|position=Umsatzsteuerzahllast aus Obligos
And I set fields
|stichtag|19950107|
|zeiteinheit|(Week)|
|auswaehr|DEM|
|bukreis|HGB|
|buwaehr|DEM|
|planszenario|STD|
|kategorieauswert|0|
|allekategorien|1|
|zeigealle|0|
|periodevon|13|
|periodebis|13|
|position|Umsatzsteuerzahllast aus Obligos|
And I press button "bstart"
Then the table has 3 rows
Then field "tterm" has value "15.04.1995" in row 1
Then field "tzabetr" has value "1800.00" in row 1
Then field "tterm" has value "15.04.1995" in row 2
Then field "tzabetr" has value "-540.00" in row 2
Then field "tterm" has value "15.04.1995" in row 3
Then field "tzabetr" has value "-720.00" in row 3

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Scenario: (Planung quartalsweise, Formular monatlich)

# <(PaymentMasterFiles)> <(Empty)>, (LiquidityPlanningScenario)
Given I open an editor "LiquiPlan" from table "(PaymentMasterFiles):(LiquidityPlanningScenario)" with command "STORE" for record "STD"
And I set fields
| ustvazeitraum  | quartalsweise |
And I save the current editor


# Ust-Formular Konfiguration
Given I open an editor "temp" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "USTVA2020"
And I set field "bempos" to "10" in row 6
And I set field "zeitraum" to "monatlich"
And I set field "ganjahr" to "95"
And I set field "ganmon" to "1"
And I set field "gendmon" to "1"
And I set field "bukreis" to "HGB"
And I press button "berech"
Then I save the current editor


# Liquiditätsplanung öffnenv (Planung quartalsweise, Formular monatlich)
# (Infosystem) LIQPLAN
Given I open the infosystem "LIQPLAN"
And I press button "bstart"
Then table has values
|tposition                       |tekvk  |twert0|twert1|twert2|twert3|twert4  |twert5  |twert6  |twert7  |twert8  |twert9  |twert10 |twert11 |twert12 |twert13  |tzeilensum|
|Eigene liquide Mittel (AB)      |       |      |      |      |-11.15|-11.15  |4117.70 |4117.70 |4117.70 |4221.55 |4221.55 |9730.40 |9730.40 |9834.25 |9834.25  |          |
|Kreditlinie (AB)                |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zahlungsmittel (AB)             |       |      |      |      |-11.15|-11.15  |4117.70 |4117.70 |4117.70 |4221.55 |4221.55 |9730.40 |9730.40 |9834.25 |9834.25  |          |
|Offene Posten                   |Verkauf|      |      |      |      |        |        |        |115.00  |        |        |        |115.00  |        |2530.00  |2760.00   |
|Rechnungsobligo                 |Verkauf|      |      |      |      |4140.00 |        |        |        |        |5520.00 |        |        |        |-9660.00 |          |
|Lieferobligo                    |Verkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |13800.00 |13800.00  |
|Sonstige Einzahlungen           |Verkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Einzahlungen gesamt             |       |      |      |      |      |4140.00 |        |        |115.00  |        |5520.00 |        |115.00  |        |6670.00  |16560.00  |
|Offene Posten                   |Einkauf|      |      |11.15 |      |11.15   |        |        |11.15   |        |11.15   |        |11.15   |        |211.94   |267.69    |
|Rechnungsobligo                 |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Lieferobligo                    |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Sonstige Auszahlungen           |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Auszahlungen gesamt             |       |      |      |11.15 |      |11.15   |        |        |11.15   |        |11.15   |        |11.15   |        |211.94   |267.69    |
|Liquiditätssaldo I             |       |      |      |-11.15|      |4128.85 |        |        |103.85  |        |5508.85 |        |103.85  |        |6458.06  |          |
|Gebuchte Umsatzsteuerzahllast   |       |      |      |      |      |        |        |        |        |        |        |        |        |        |351.00   |351.00    |
|Umsatzsteuerzahllast aus Obligos|       |      |      |      |      |        |        |        |        |        |        |        |        |        |1800.00  |1800.00   |
|Zinssatz Bereitstellung (%)     |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinsen Bereitstellung           |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinssatz Inanspruchnahme (%)    |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinsen Inanspruchnahme          |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Weitere Belastungen gesamt      |       |      |      |      |      |        |        |        |        |        |        |        |        |        |2151.00  |2151.00   |
|Liquiditätssaldo II            |       |      |      |-11.15|      |4128.85 |        |        |103.85  |        |5508.85 |        |103.85  |        |4307.06  |          |
|Eigene liquide Mittel (EB)      |       |      |      |-11.15|-11.15|4117.70 |4117.70 |4117.70 |4221.55 |4221.55 |9730.40 |9730.40 |9834.25 |9834.25 |14141.31 |          |
|Kreditlinie (EB)                |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zahlungsmittel (EB)             |       |      |      |-11.15|-11.15|4117.70 |4117.70 |4117.70 |4221.55 |4221.55 |9730.40 |9730.40 |9834.25 |9834.25 |14141.31 |          |
|Inanspruchnahme Kreditlinie abs.|       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Inanspruchnahme Kreditlinie (%) |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Änderung Kreditvolumen         |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |

# Umsatzsteuerzahllast aus Obligo für Anzahlungen (Planung quartalsweise, Formular monatlich)
# (Infosystem) LIQPLANDETAILS
Given I open the infosystem "LIQPLANDETAILS"
# (Infosystem) LIQPLANDETAILS
#stichtag=19950107|zeiteinheit=(Week)|auswaehr=DEM|bukreis=HGB|buwaehr=DEM|planszenario=STD|kategorieauswert=0|allekategorien=1|zeigealle=0|periodevon=13|periodebis=13|position=Umsatzsteuerzahllast aus Obligos
And I set fields
|stichtag|19950107|
|zeiteinheit|(Week)|
|auswaehr|DEM|
|bukreis|HGB|
|buwaehr|DEM|
|planszenario|STD|
|kategorieauswert|0|
|allekategorien|1|
|zeigealle|0|
|periodevon|13|
|periodebis|13|
|position|Umsatzsteuerzahllast aus Obligos|
And I press button "bstart"
Then the table has 5 rows
Then field "tterm" has value "15.04.1995" in row 1
Then field "tzabetr" has value "1800.00" in row 1
Then field "tterm" has value "15.04.1995" in row 2
Then field "tzabetr" has value "540.00" in row 2
Then field "tterm" has value "15.04.1995" in row 3
Then field "tzabetr" has value "-540.00" in row 3
Then field "tterm" has value "15.04.1995" in row 4
Then field "tzabetr" has value "720.00" in row 4
Then field "tterm" has value "15.04.1995" in row 5
Then field "tzabetr" has value "-720.00" in row 5

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Scenario: (Planung jährlich, Formular monatlich)

# <(PaymentMasterFiles)> <(Empty)>, (LiquidityPlanningScenario)
Given I open an editor "LiquiPlan" from table "(PaymentMasterFiles):(LiquidityPlanningScenario)" with command "STORE" for record "STD"
And I set fields
| ustvazeitraum  | jährlich |
And I save the current editor


# Liquiditätsplanung öffnen (Planung jährlich, Formular monatlich)
# (Infosystem) LIQPLAN
Given I open the infosystem "LIQPLAN"
And I press button "bstart"
Then table has values
|tposition                       |tekvk  |twert0|twert1|twert2 |twert3 |twert4  |twert5  |twert6  |twert7  |twert8  |twert9  |twert10 |twert11 |twert12 |twert13  |tzeilensum|
|Eigene liquide Mittel (AB)      |       |      |      |       |-11.15 |-11.15  |4117.70 |4117.70 |4117.70 |4221.55 |4221.55 |9730.40 |9730.40 |9834.25 |9834.25  |          |
|Kreditlinie (AB)                |       |      |      |       |       |        |        |        |        |        |        |        |        |        |         |          |
|Zahlungsmittel (AB)             |       |      |      |       |-11.15 |-11.15  |4117.70 |4117.70 |4117.70 |4221.55 |4221.55 |9730.40 |9730.40 |9834.25 |9834.25  |          |
|Offene Posten                   |Verkauf|      |      |       |       |        |        |        |115.00  |        |        |        |115.00  |        |2530.00  |2760.00   |
|Rechnungsobligo                 |Verkauf|      |      |       |       |4140.00 |        |        |        |        |5520.00 |        |        |        |-9660.00 |          |
|Lieferobligo                    |Verkauf|      |      |       |       |        |        |        |        |        |        |        |        |        |13800.00 |13800.00  |
|Sonstige Einzahlungen           |Verkauf|      |      |       |       |        |        |        |        |        |        |        |        |        |         |          |
|Einzahlungen gesamt             |       |      |      |       |       |4140.00 |        |        |115.00  |        |5520.00 |        |115.00  |        |6670.00  |16560.00  |
|Offene Posten                   |Einkauf|      |      |11.15  |       |11.15   |        |        |11.15   |        |11.15   |        |11.15   |        |211.94   |267.69    |
|Rechnungsobligo                 |Einkauf|      |      |       |       |        |        |        |        |        |        |        |        |        |         |          |
|Lieferobligo                    |Einkauf|      |      |       |       |        |        |        |        |        |        |        |        |        |         |          |
|Sonstige Auszahlungen           |Einkauf|      |      |       |       |        |        |        |        |        |        |        |        |        |         |          |
|Auszahlungen gesamt             |       |      |      |11.15  |       |11.15   |        |        |11.15   |        |11.15   |        |11.15   |        |211.94   |267.69    |
|Liquiditätssaldo I             |       |      |      |-11.15 |       |4128.85 |        |        |103.85  |        |5508.85 |        |103.85  |        |6458.06  |          |
|Gebuchte Umsatzsteuerzahllast   |       |      |      |       |       |        |        |        |        |        |        |        |        |        |324.00   |324.00    |
|Umsatzsteuerzahllast aus Obligos|       |      |      |       |       |        |        |        |        |        |        |        |        |        |1800.00  |1800.00   |
|Zinssatz Bereitstellung (%)     |       |      |      |       |       |        |        |        |        |        |        |        |        |        |         |          |
|Zinsen Bereitstellung           |       |      |      |       |       |        |        |        |        |        |        |        |        |        |         |          |
|Zinssatz Inanspruchnahme (%)    |       |      |      |       |       |        |        |        |        |        |        |        |        |        |         |          |
|Zinsen Inanspruchnahme          |       |      |      |       |       |        |        |        |        |        |        |        |        |        |         |          |
|Weitere Belastungen gesamt      |       |      |      |       |       |        |        |        |        |        |        |        |        |        |2124.00  |2124.00   |
|Liquiditätssaldo II            |       |      |      |-11.15 |       |4128.85 |        |        |103.85  |        |5508.85 |        |103.85  |        |4334.06  |          |
|Eigene liquide Mittel (EB)      |       |      |      |-11.15 |-11.15 |4117.70 |4117.70 |4117.70 |4221.55 |4221.55 |9730.40 |9730.40 |9834.25 |9834.25 |14168.31 |          |
|Kreditlinie (EB)                |       |      |      |       |       |        |        |        |        |        |        |        |        |        |         |          |
|Zahlungsmittel (EB)             |       |      |      |-11.15 |-11.15 |4117.70 |4117.70 |4117.70 |4221.55 |4221.55 |9730.40 |9730.40 |9834.25 |9834.25 |14168.31 |          |
|Inanspruchnahme Kreditlinie abs.|       |      |      |       |       |        |        |        |        |        |        |        |        |        |         |          |
|Inanspruchnahme Kreditlinie (%) |       |      |      |       |       |        |        |        |        |        |        |        |        |        |         |          |
|Änderung Kreditvolumen         |       |      |      |       |       |        |        |        |        |        |        |        |        |        |         |          |

# Umsatzsteuerzahllast aus Obligo für Anzahlungen (Planung jährlich, Formular monatlich)
# (Infosystem) LIQPLANDETAILS
Given I open the infosystem "LIQPLANDETAILS"
# (Infosystem) LIQPLANDETAILS
#stichtag=19950107|zeiteinheit=(Week)|auswaehr=DEM|bukreis=HGB|buwaehr=DEM|planszenario=STD|kategorieauswert=0|allekategorien=1|zeigealle=0|periodevon=13|periodebis=13|position=Umsatzsteuerzahllast aus Obligos
And I set fields
|stichtag|19950107|
|zeiteinheit|(Week)|
|auswaehr|DEM|
|bukreis|HGB|
|buwaehr|DEM|
|planszenario|STD|
|kategorieauswert|0|
|allekategorien|1|
|zeigealle|0|
|periodevon|13|
|periodebis|13|
|position|Umsatzsteuerzahllast aus Obligos|
And I press button "bstart"
Then the table has 5 rows
Then field "tterm" has value "15.01.1996" in row 1
Then field "tzabetr" has value "1800.00" in row 1
Then field "tterm" has value "15.01.1996" in row 2
Then field "tzabetr" has value "540.00" in row 2
Then field "tterm" has value "15.01.1996" in row 3
Then field "tzabetr" has value "-540.00" in row 3
Then field "tterm" has value "15.01.1996" in row 4
Then field "tzabetr" has value "720.00" in row 4
Then field "tterm" has value "15.01.1996" in row 5
Then field "tzabetr" has value "-720.00" in row 5

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Scenario: (Planung jährlich, Formular jährlich)

# Ust-Formular Konfiguration
Given I open an editor "temp" from table "(Evaluation):(AdvanceVATReturn)" with command "UPDATE" for record "USTVA2020"
And I set field "zeitraum" to "jährlich"
And I press button "berech"
Then I save the current editor


# Liquiditätsplanung öffnenv (Planung jährlich, Formular quartalsweise)
# (Infosystem) LIQPLAN
Given I open the infosystem "LIQPLAN"
And I press button "bstart"
Then table has values
|tposition                       |tekvk  |twert0|twert1|twert2|twert3|twert4  |twert5  |twert6  |twert7  |twert8  |twert9  |twert10 |twert11 |twert12 |twert13  |tzeilensum|
|Eigene liquide Mittel (AB)      |       |      |      |      |-11.15|-11.15  |4117.70 |4117.70 |4117.70 |4221.55 |4221.55 |9730.40 |9730.40 |9834.25 |9834.25  |          |
|Kreditlinie (AB)                |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zahlungsmittel (AB)             |       |      |      |      |-11.15|-11.15  |4117.70 |4117.70 |4117.70 |4221.55 |4221.55 |9730.40 |9730.40 |9834.25 |9834.25  |          |
|Offene Posten                   |Verkauf|      |      |      |      |        |        |        |115.00  |        |        |        |115.00  |        |2530.00  |2760.00   |
|Rechnungsobligo                 |Verkauf|      |      |      |      |4140.00 |        |        |        |        |5520.00 |        |        |        |-9660.00 |          |
|Lieferobligo                    |Verkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |13800.00 |13800.00  |
|Sonstige Einzahlungen           |Verkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Einzahlungen gesamt             |       |      |      |      |      |4140.00 |        |        |115.00  |        |5520.00 |        |115.00  |        |6670.00  |16560.00  |
|Offene Posten                   |Einkauf|      |      |11.15 |      |11.15   |        |        |11.15   |        |11.15   |        |11.15   |        |211.94   |267.69    |
|Rechnungsobligo                 |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Lieferobligo                    |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Sonstige Auszahlungen           |Einkauf|      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Auszahlungen gesamt             |       |      |      |11.15 |      |11.15   |        |        |11.15   |        |11.15   |        |11.15   |        |211.94   |267.69    |
|Liquiditätssaldo I             |       |      |      |-11.15|      |4128.85 |        |        |103.85  |        |5508.85 |        |103.85  |        |6458.06  |          |
|Gebuchte Umsatzsteuerzahllast   |       |      |      |      |      |        |        |        |        |        |        |        |        |        |324.00   |324.00    |
|Umsatzsteuerzahllast aus Obligos|       |      |      |      |      |        |        |        |        |        |        |        |        |        |1800.00  |1800.00   |
|Zinssatz Bereitstellung (%)     |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinsen Bereitstellung           |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinssatz Inanspruchnahme (%)    |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zinsen Inanspruchnahme          |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Weitere Belastungen gesamt      |       |      |      |      |      |        |        |        |        |        |        |        |        |        |2124.00  |2124.00   |
|Liquiditätssaldo II            |       |      |      |-11.15|      |4128.85 |        |        |103.85  |        |5508.85 |        |103.85  |        |4334.06  |          |
|Eigene liquide Mittel (EB)      |       |      |      |-11.15|-11.15|4117.70 |4117.70 |4117.70 |4221.55 |4221.55 |9730.40 |9730.40 |9834.25 |9834.25 |14168.31 |          |
|Kreditlinie (EB)                |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Zahlungsmittel (EB)             |       |      |      |-11.15|-11.15|4117.70 |4117.70 |4117.70 |4221.55 |4221.55 |9730.40 |9730.40 |9834.25 |9834.25 |14168.31 |          |
|Inanspruchnahme Kreditlinie abs.|       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Inanspruchnahme Kreditlinie (%) |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |
|Änderung Kreditvolumen         |       |      |      |      |      |        |        |        |        |        |        |        |        |        |         |          |

# Wechsel in LIQPLANDETAILS
And I press button "twertnachws13" to open a subeditor for "" in row 15
And I press button "bstart"
Then the table has 1 rows
# Kopffelder
Then field "stichtag" has value "07.01.1995" in row 0
Then field "position" has value "Gebuchte Umsatzsteuerzahllast" in row 0
Then field "periodevon" has value "13" in row 0
Then field "periodebis" has value "13" in row 0
Then field "planszenario" has value "STD" in row 0
Then field "zeiteinheit" has value "Woche" in row 0
# Tabellenfelder
Then field "tterm" has value "15.01.1996" in row 1
Then field "tzabetr" has value "324.00" in row 1
Then field "tbelegtyp" has value "Umsatzsteuervoranmeldung" in row 1
#
Then field "tbelzeigen" is modifiable in row 1
#  zur Zeit nicht moeglich
#  Then pressing button "tbelzeigen" in row 1 to open a subeditor throws the exception ""
#  # zurueck zu IS LIQPLANDETAILS
#  And I close the current subeditor to switch back to the parent editor
# zurueck zum USTVA-Formular
And I close the current subeditor to switch back to the parent editor
And I close the current editor


# Umsatzsteuerzahllast aus Obligo für Anzahlungen (Planung jährlich, Formular quartalsweise)
# (Infosystem) LIQPLANDETAILS
Given I open the infosystem "LIQPLANDETAILS"
# (Infosystem) LIQPLANDETAILS
#stichtag=19950107|zeiteinheit=(Week)|auswaehr=DEM|bukreis=HGB|buwaehr=DEM|planszenario=STD|kategorieauswert=0|allekategorien=1|zeigealle=0|periodevon=13|periodebis=13|position=Umsatzsteuerzahllast aus Obligos
And I set fields
|stichtag|19950107|
|zeiteinheit|(Week)|
|auswaehr|DEM|
|bukreis|HGB|
|buwaehr|DEM|
|planszenario|STD|
|kategorieauswert|0|
|allekategorien|1|
|zeigealle|0|
|periodevon|13|
|periodebis|13|
|position|Umsatzsteuerzahllast aus Obligos|
And I press button "bstart"
Then the table has 5 rows
Then field "tterm" has value "15.01.1996" in row 1
Then field "tzabetr" has value "1800.00" in row 1
Then field "tterm" has value "15.01.1996" in row 2
Then field "tzabetr" has value "540.00" in row 2
Then field "tterm" has value "15.01.1996" in row 3
Then field "tzabetr" has value "-540.00" in row 3
Then field "tterm" has value "15.01.1996" in row 4
Then field "tzabetr" has value "720.00" in row 4
Then field "tterm" has value "15.01.1996" in row 5
Then field "tzabetr" has value "-720.00" in row 5

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
