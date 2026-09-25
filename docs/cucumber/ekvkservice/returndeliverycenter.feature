@persistent
Feature: RETURNDELIVERYCENTER
Background:
Given I set the fake date to "02.02.02"
# *****************************************************************************
#  Name           : returndeliverycenter.feature
#  Autor          : cl
#  Verantwortlich : cl
#  Kontrolle      : teaminfosysteme
#  Funktion       : Cucumber Tests fuer RETURNDELIVERYCENTER
#
# *****************************************************************************

Scenario: bestehenden Lieferschein kopieren und Projekt und Charge setzen
Given I open an editor "lieferschein-1" from table "(Sales):(PackingSlip)" with command "COPY" for record "LS207"
# Artikel V3
Then field "artikel" has value "V3" in row 1
And I set field "mge" to "33" in row 1
And I set field "verw" to "test1" in row 1
And I set field "projekt" to "111" in row 1
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 1
And I set field "lpsuch" to "F1" in row 1
And I set field "zuomge" to "28" in row 1
And I set field "projekt" to "111" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F1" in row 2
And I set field "zuomge" to "5" in row 2
And I set field "verw" to "test2" in row 2
And I save the current editor
And I switch the current editor to editor "lieferschein-1"
Then field "artikel" has value "V2" in row 2
Then field "platz" has value "F2" in row 2
And I set field "mge" to "33" in row 2
And I set field "verw" to "test2" in row 2
And I press button "mzsubm" to open a subeditor for "Materialzuordnung" in row 2
# Artikel V2 mit zwei Zeilen MZ: 30 mit test1 auf F2 und 3 mit test2 auf F1
And I set field "lpsuch" to "F2" in row 1
And I set field "zuomge" to "30" in row 1
And I set field "verw" to "test1" in row 1
And I create a new row at the end of the table
And I set field "lpsuch" to "F1" in row 2
And I set field "zuomge" to "3" in row 2
And I set field "verw" to "test2" in row 2
And I set field "projekt" to "111" in row 2
And I save the current editor
And I switch the current editor to editor "lieferschein-1"
Then I set field "ueb" to "Ja"
And I save the current editor


@Infosystem_RETURNDELIVERYCENTER
Scenario:  Infosystem starten RETURNDELIVERYCENTER
Given I open the infosystem "RETURNDELIVERYCENTER"
And I set field "bverkauf" to "ja"
And I set field "bis" to "02.02.02"
And I set field "kunde" to "1"
And I set field "artikel" to "V2"
And I press button "buladen"
Then the table has 8 rows

Then table has values
   | tmark   | tartikel | tvkvorg  | tpbed | tlbed | tkl2vk  | twarenempf  | mge  | rueckmge | platz | tcharge | tverwendung | tprojekt    | mzda | mztreffer | bfarbe |
   | nein    | V2       | 300016   |       | 603   | 4       | 1           | 11   | 11       | F2    |         |             |             | nein | nein      | nein   |
   | nein    | V2       | 300048   |       | 603   | 4       | 1           | 33   | 10       | F2    |         |             | TESTPROJEKT | nein | nein      | nein   |
   | nein    | V2       | 300050   |       | 603   | 4       | 1           | 23   | 10       | F2    |         |             |             | nein | nein      | nein   |
   | nein    | V2       | 300052   |       | 603   | 4       | 1           | 23   | 23       | F2    |         |             |             | nein | nein      | nein   |
   | nein    | V2       | 300054   |       | 603   | 4       | 1           | 33   | 0        | F2    |         | test2       |             | nein | nein      | nein   |
   | nein    | V2       | 300054   |       | 603   | 4       | 1           | 30   | 30       | F2    |         | test1       |             | ja   | nein      | ja     |
   | nein    | V2       | 300054   |       | 603   | 4       | 1           | 3    | 3        | F1    |         | test2       | TESTPROJEKT | ja   | nein      | ja     |
   | nein    | V2       | +400004  |       | 603   | 4       | 1           | 11   | 11       | F2    |         |             |             | nein | nein      | nein   |

Then I set field "tmark" to "ja" in row 1
Then I set field "tmark" to "ja" in row 2


And I set field "artikel" to "V3"
And I press button "buladen"
Then the table has 6 rows

Then table has values
   | tmark   | tartikel | tvkvorg  | tpbed | tlbed | tkl2vk  | twarenempf  | mge  | rueckmge | platz   | tcharge | tverwendung | tprojekt    | mzda | mztreffer | bfarbe |
   | ja      | V2       | 300016   |       | 603   | 4       | 1           | 11   | 11       | F2      |         |             |             | nein | nein      | nein   |
   | ja      | V2       | 300048   |       | 603   | 4       | 1           | 33   | 10       | F2      |         |             | TESTPROJEKT | nein | nein      | nein   |
   | nein    | V3       | 300052   |       | 603   | 4       | 1           | 33   | 25       | F2      |         |             |             | nein | nein      | nein   |
   | nein    | V3       | 300054   |       | 603   | 4       | 1           | 33   | 0        | F2      |         | test1       | TESTPROJEKT | nein | nein      | nein   |
   | nein    | V3       | 300054   |       | 603   | 4       | 1           | 28   | 0        | F1      |         | test1       | TESTPROJEKT | ja   | nein      | ja     |
   | nein    | V3       | 300054   |       | 603   | 4       | 1           | 5    | 5        | F1      |         | test2       | TESTPROJEKT | ja   | nein      | ja     |

# die zwei Zeilen V2 demarkieren
Then I set field "tmark" to "nein" in row 1
Then I set field "tmark" to "nein" in row 2


And I set field "verwendung" to "test1"
And I press button "buladen"
Then the table has 2 rows

Then table has values
   | tmark   | tartikel | tvkvorg  | tpbed | tlbed | tkl2vk  | twarenempf  | mge  | rueckmge | platz  | tcharge | tverwendung | tprojekt    | mzda | mztreffer | bfarbe |
   | nein    | V3       | 300054   |       | 603   | 4       | 1           | 33   | 0        | F2     |         | test1       | TESTPROJEKT | nein | ja        | nein   |
   | nein    | V3       | 300054   |       | 603   | 4       | 1           | 28   | 0        | F1     |         | test1       | TESTPROJEKT | ja   | ja        | ja     |

# die zwei Zeilen V3 markieren
Then I set field "tmark" to "ja" in row 2


And I set field "projekt" to "111"
And I press button "buladen"
Then the table has 6 rows

Then table has values
   | tmark   | tartikel | tvkvorg  | tpbed | tlbed | tkl2vk  | twarenempf  | mge  | rueckmge | platz  | tcharge | tverwendung | tprojekt    | mzda | mztreffer | bfarbe |
   | ja      | V3       | 300054   |       | 603   | 4       | 1           | 33   | 0        | F2     |         | test1       | TESTPROJEKT | nein | ja        | nein   |
   | ja      | V3       | 300054   |       | 603   | 4       | 1           | 28   | 0        | F1     |         | test1       | TESTPROJEKT | ja   | nein      | ja     |
   | nein    | V2       | 300048   |       | 603   | 4       | 1           | 33   | 10       | F2     |         |             | TESTPROJEKT | nein | nein      | nein   |
   | nein    | V1       | 300048   |       | 603   | 4       | 1           | 23   | 23       | F1     | 1111    |             | TESTPROJEKT | nein | nein      | nein   |
   | nein    | V2       | 300054   |       | 603   | 4       | 1           | 33   | 0        | F2     |         | test2       |             | nein | ja        | nein   |
   | nein    | V2       | 300054   |       | 603   | 4       | 1           | 3    | 3        | F1     |         | test2       | TESTPROJEKT | ja   | ja        | ja     |


And I set field "artikel" to "V2"
And I press button "buladen"
Then the table has 10 rows


And I set field "charge" to "1111"
And I press button "buladen"
Then the table has 3 rows

Then table has values
   | tmark   | tartikel | tvkvorg  | tpbed | tlbed | tkl2vk  | twarenempf  | mge  | rueckmge | platz   | tcharge | tverwendung | tprojekt    | mzda | mztreffer | bfarbe |
   | ja      | V3       | 300054   |       | 603   | 4       | 1           | 33   | 0        | F2      |         | test1       | TESTPROJEKT | nein | ja        | nein   |
   | ja      | V3       | 300054   |       | 603   | 4       | 1           | 28   | 0        | F1      |         | test1       | TESTPROJEKT | ja   | nein      | ja     |
   | nein    | V1       | 300048   |       | 603   | 4       | 1           | 23   | 23       | F1      | 1111    |             | TESTPROJEKT | nein | nein      | nein   |

Then I set field "tmark" to "nein" in row 2

Then table has values
   | tmark   | tartikel | tvkvorg  | tpbed | tlbed | tkl2vk  | twarenempf  | mge  | rueckmge | platz   | tcharge | tverwendung | tprojekt    | mzda | mztreffer | bfarbe |
   | nein    | V3       | 300054   |       | 603   | 4       | 1           | 33   | 0        | F2      |         | test1       | TESTPROJEKT | nein | ja        | nein   |
   | nein    | V3       | 300054   |       | 603   | 4       | 1           | 28   | 0        | F1      |         | test1       | TESTPROJEKT | ja   | nein      | ja     |
   | nein    | V1       | 300048   |       | 603   | 4       | 1           | 23   | 23       | F1      | 1111    |             | TESTPROJEKT | nein | nein      | nein   |

And I set field "newmge" to "-1" in row 3

Then table has values
   | tmark   | tartikel | tvkvorg  | tpbed | tlbed | tkl2vk  | twarenempf  | mge  | rueckmge | newmge | platz   | tcharge | tverwendung | tprojekt    | mzda | mztreffer | bfarbe |
   | nein    | V3       | 300054   |       | 603   | 4       | 1           | 33   | 0        |   0    | F2      |         | test1       | TESTPROJEKT | nein | ja        | nein   |
   | nein    | V3       | 300054   |       | 603   | 4       | 1           | 28   | 0        |   0    | F1      |         | test1       | TESTPROJEKT | ja   | nein      | ja     |
   | nein    | V1       | 300048   |       | 603   | 4       | 1           | 23   | 23       |   -1   | F1      | 1111    |             | TESTPROJEKT | nein | nein      | nein   |

And I press button "buerstellen"

# Wie kann ich pruefen, ob der edpimport geklappt hat und ob sich der Vorgang oeffnet?
# Hier geht jetzt der Rueclklieferschein auf. Wie speichere ich den bzw. beende ich den?

And I save the current editor

Given I open the infosystem "RETURNDELIVERYCENTER"
And I set field "bverkauf" to "ja"
And I set field "kunde" to "1"
And I set field "verwendung" to "test1"
And I set field "artikel" to "V3"
And I press button "buladen"
Then the table has 2 rows

Then table has values
   | tmark   | tartikel | tvkvorg  | tpbed | tlbed | tkl2vk  | twarenempf  | mge  | rueckmge | platz   | tcharge | tverwendung | tprojekt    | mzda | mztreffer | bfarbe |
   | nein    | V3       | 300054   |       | 603   | 4       | 1           | 33   | 0        | F2      |         | test1       | TESTPROJEKT | nein | ja        | nein   |
   | nein    | V3       | 300054   |       | 603   | 4       | 1           | 28   | 0        | F1      |         | test1       | TESTPROJEKT | ja   | ja        | ja     |

And I save the current editor

Given I open the infosystem "RETURNDELIVERYCENTER"
And I set field "bverkauf" to "ja"
And I set field "kunde" to "1"
And I set field "charge" to "1111"
And I set field "projekt" to "111"
And I set field "artikel" to "V1"
And I press button "buladen"
Then the table has 1 rows

# Rückmge müsste auf 22 reduziert sein, falls das Erstellen geklappt hätte
Then table has values
  | tmark   | tartikel | tvkvorg  | tpbed | tlbed | tkl2vk  | twarenempf  | mge  | rueckmge | platz   | tcharge | tverwendung | tprojekt    | mzda | mztreffer | bfarbe |
  | nein    | V1       | 300048   |       | 603   | 4       | 1           | 23   | 23       | F1      | 1111    |             | TESTPROJEKT | nein | nein      | nein   |

And I save the current editor


Given I open the infosystem "RETURNDELIVERYCENTER"
And I set field "bverkauf" to "ja"
And I set field "bis" to "02.02.02"
And I set field "vkvorg" to "300054"
And I press button "buladen"
Then the table has 6 rows

Then table has values
   | tmark   | tartikel | tvkvorg  | tpbed | tlbed | tkl2vk  | twarenempf  | mge  | rueckmge | platz   | tcharge | tverwendung | tprojekt    | mzda | mztreffer | bfarbe |
   | nein    | V3       | 300054   |       | 603   | 4       | 1           | 33   | 0        | F2      |         | test1       | TESTPROJEKT | nein | nein      | nein   |
   | nein    | V3       | 300054   |       | 603   | 4       | 1           | 28   | 0        | F1      |         | test1       | TESTPROJEKT | ja   | nein      | ja     |
   | nein    | V3       | 300054   |       | 603   | 4       | 1           | 5    | 5        | F1      |         | test2       | TESTPROJEKT | ja   | nein      | ja     |
   | nein    | V2       | 300054   |       | 603   | 4       | 1           | 33   | 0        | F2      |         | test2       |             | nein | nein      | nein   |
   | nein    | V2       | 300054   |       | 603   | 4       | 1           | 30   | 30       | F2      |         | test1       |             | ja   | nein      | ja     |
   | nein    | V2       | 300054   |       | 603   | 4       | 1           | 3    | 3        | F1      |         | test2       | TESTPROJEKT | ja   | nein      | ja     |



# Einkauf testen
And I set field "beinkauf" to "ja"
And I set field "lief" to "1"
And I set field "artikel" to "E1"
And I set field "bnullzeile" to "nein"
And I press button "buladen"
Then the table has 14 rows

Then table has values
   | tmark   | tartikel | tekvorg  | tpbed | tlbed | tkl2ek  | mge    | rueckmge | tvstaat     |
   | nein    | E1       | 39       |       |       | 1       | 20     | 12       | USA         |
   | nein    | E1       | 1LS003   |       |       | 1       | 10     | 10       | DEUTSCHLAND |
   | nein    | E1       | +1LS004B |       |       | 1       | 5      | 5        | DEUTSCHLAND |
   | nein    | E1       | 1LS014   |       |       | 1       | 5      | 4        | DEUTSCHLAND |
   | nein    | E1       | +5       |       |       | 1       | 10     | 0        | DEUTSCHLAND |
   | nein    | E1       | 7        |       |       | 1       | 10     | 0        | DEUTSCHLAND |
   | nein    | E1       | +18      |       |       | 1       | 15     | 7        | DEUTSCHLAND |
   | nein    | E1       | +1LS17   |       |       | 1       | 10     | 10       | DEUTSCHLAND |
   | nein    | E1       | 35       |       |       | 1       | 20     | 20       | USA         |
   | nein    | E1       | 37       |       |       | 1       | 20     | 20       | USA         |
   | nein    | E1       | 41       |       |       | 1       | 20     | 12       | USA         |
   | nein    | E1       | 43       |       |       | 1       | 20     | 12       | USA         |
   | nein    | E1       | +1RE007  |       |       | 1       | 10     | 10       | DEUTSCHLAND |
   | nein    | E1       | +1RE010  |       |       | 1       | 10     | 10       | DEUTSCHLAND |

 And I set field "bnullzeile" to "ja"
 And I set field "artikel" to "E1"
 And I press button "buladen"
 Then the table has 12 rows

 Then table has values
   | tmark   | tartikel | tekvorg  | tpbed | tlbed | tkl2ek  | mge    | rueckmge | tvstaat     |
   | nein    | E1       | 39       |       |       | 1       | 20     | 12       | USA         |
   | nein    | E1       | 1LS003   |       |       | 1       | 10     | 10       | DEUTSCHLAND |
   | nein    | E1       | +1LS004B |       |       | 1       | 5      | 5        | DEUTSCHLAND |
   | nein    | E1       | 1LS014   |       |       | 1       | 5      | 4        | DEUTSCHLAND |
   | nein    | E1       | +18      |       |       | 1       | 15     | 7        | DEUTSCHLAND |
   | nein    | E1       | +1LS17   |       |       | 1       | 10     | 10       | DEUTSCHLAND |
   | nein    | E1       | 35       |       |       | 1       | 20     | 20       | USA         |
   | nein    | E1       | 37       |       |       | 1       | 20     | 20       | USA         |
   | nein    | E1       | 41       |       |       | 1       | 20     | 12       | USA         |
   | nein    | E1       | 43       |       |       | 1       | 20     | 12       | USA         |
   | nein    | E1       | +1RE007  |       |       | 1       | 10     | 10       | DEUTSCHLAND |
   | nein    | E1       | +1RE010  |       |       | 1       | 10     | 10       | DEUTSCHLAND |

Then I set field "tmark" to "ja" in row 1
Then I set field "tmark" to "ja" in row 7


And I set field "ekvorg" to "1LS111"
And I press button "buladen"
Then the table has 2 rows

Then table has values
   | tmark   | tartikel | tekvorg  | tpbed | tlbed | tkl2ek  | mge    | rueckmge |
   | ja      | E1       | 39       |       |       | 1       | 20     | 12       |
   | ja      | E1       | 35       |       |       | 1       | 20     | 20       |

And I save the current editor


Scenario:  Infosystem RETURNDELIVERYCENTER starten und RLS erzeugen und buchen
Given I open the infosystem "RETURNDELIVERYCENTER"
And I set field "bis" to "02.02.02"
And I set field "bverkauf" to "ja"
And I set field "kunde" to "1"
And I set field "artikel" to "V1"
And I press button "buladen"
Then the table has 15 rows

Then field "tvkvorg" has value "+1LS004B" in row 1
Then field "tvkvorg" has value "1LS010" in row 2
Then field "tvkvorg" has value "1LS009" in row 3
Then field "tvkvorg" has value "+300019" in row 4
Then field "tvkvorg" has value "+1LS12" in row 5
Then field "tvkvorg" has value "+1LS14" in row 6
Then field "tvkvorg" has value "+300025" in row 7
Then field "tvkvorg" has value "+1LS034" in row 8
Then field "tvkvorg" has value "+1LS037" in row 9
Then field "tvkvorg" has value "300038" in row 10
Then field "tvkvorg" has value "1LS044" in row 11
Then field "tvkvorg" has value "300040" in row 12
Then field "tvkvorg" has value "300048" in row 13
Then field "tvkvorg" has value "300050" in row 14
Then field "tvkvorg" has value "+1RE007" in row 15
Then field "rueckmge" has value "5" in row 1

Then I set field "tmark" to "ja" in row 1
And I set field "newmge" to "-1" in row 1

And I press button "bubuerstellen"

And I save the current editor

Given I open the infosystem "RETURNDELIVERYCENTER"
And I set field "bverkauf" to "ja"
And I set field "kunde" to "1"
And I set field "artikel" to "V1"
And I press button "buladen"
Then the table has 15 rows

# Ruecklieferung erstellen scheitert hier wegen Steuerregel-Fehler, daher bleibt die Menge auf 5. Ansonsten w�re da jetzt 4 drin
Then field "rueckmge" has value "5" in row 1


Scenario: Infosystem RETURNDELIVERYCENTER starten und VK-RLS erzeugen, Lagerplatz aendern und buchen
Given I open the infosystem "RETURNDELIVERYCENTER"
And I set field "bverkauf" to "ja"
And I set field "vkvorg" to "300040"
And I press button "buladen"
Then the table has 1 rows

Then I set field "tmark" to "ja" in row 1
And I set field "newmge" to "-19" in row 1

And I press button "buerstellen"

And I save the current editor

Given I open an editor "ruecklieferschein-vk" from table "(Sales):(PackingSlip)" with command "UPDATE" for record "300041"
Then field "platz" has value "F2" in row 1
And I set field "platz" to "F1" in row 1
And I set field "ueb" to "ja"
And I save the current editor

# Gebuchten Platz in MZ des Ruecklieferschein pruefen
Given I open an editor "ruecklieferschein-vk" from table "(Sales):(PackingSlip)" with command "VIEW" for record "+300041"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then the table has 1 rows
Then field "lpsuch" has value "F1" in row 1
And I close the current subeditor to switch back to the parent editor
And I close the current editor

Scenario:  Infosystem RETURNDELIVERYCENTER starten und EK-RLS erzeugen, Lagerplatz aendern und buchen

# Artikel anlegen
Given I open an editor "E4" from table "(Part):(Product)" with command "NEW" for record ""
And I set fields
   | such      | E4              |
   | bsart     | Fremdbeschaffung |
   | dispoa    | auftragsbezogen  |
   | lief      | 1                |
   | epr       | 140              |
   | chimlager | ja               |
And I save the current editor

# Chargen anlegen
Given I open an editor "CE4" from table "(Lots):(Lots)" with command "NEW" for record ""
And I set fields
   | such    | CE4  |
   | exnum   | CE4  |
   | artikel | E4   |
And I save the current editor

# Lieferschein anlegen
Given I open an editor "LS-01VK" from table "(Purchasing):(PackingSlip)" with command "NEW" for record ""
And I set fields
 | such   | LS-045  |
 | nummer | 45      |
 | ebeleg | LS-45EK |
 | ueb    | ja      |
 | vom    | .       |
 | lief   | 60001   |
And I append rows
 | artikel | mge | charge |
 | E4      |  7  | CE4    |
And I save the current editor

Given I open the infosystem "RETURNDELIVERYCENTER"
And I set field "beinkauf" to "ja"
And I set field "ekvorg" to "45"
And I press button "buladen"
Then the table has 1 rows

Then I set field "tmark" to "ja" in row 1
And I set field "newmge" to "-7" in row 1

And I press button "buerstellen"

And I save the current editor

# Ruecklieferung von neuen Lagerplatz nicht moeglich
Given I open an editor "ruecklieferschein-ek" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "46"
Then field "platz" has value "F1" in row 1
And I set field "platz" to "F2" in row 1
And I set field "ueb" to "ja"
Then saving the current editor throws the exception "Es konnten keine rücklieferbaren Mengen ermittelt werden."
And I close the current editor

# Umbuchung der gelieferten Menge auf neuen Abgangsplatz der Rüuecklieferung
Given I open an editor "LBUCHUNG" for tip command "LBuchung" and arguments ""
And I set fields
    | artikel | E4        |
    | buart   | Umbuchung |
    | beleg   | 1UME4     |
    | beldat  | .         |
And I append rows
    | platz | platz2 | mge | charge1 | charge2 |
    | F1    | F2     |  7  |  CE4    | CE4     |
And I save the current editor

Given I open an editor "ruecklieferschein-ek" from table "(Purchasing):(PackingSlip)" with command "UPDATE" for record "46"
And I set field "platz" to "F2" in row 1
And I set field "ueb" to "ja"
And I save the current editor

# Gebuchten PLatz in MZ des Ruecklieferschein pruefen
Given I open an editor "ruecklieferschein-ek" from table "(Purchasing):(PackingSlip)" with command "VIEW" for record "+46"
And I press button "mzsubm" to open a subeditor for "mz" in row 1
Then the table has 1 rows
Then field "lpsuch" has value "F2" in row 1
And I close the current subeditor to switch back to the parent editor
And I close the current editor
