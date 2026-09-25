# *****************************************************************************
#  Verantwortlich   : uo
#  Kontrolle        : 
#  Funktion         : 
#
# *****************************************************************************
@persistent

Feature: Fälligkeit in Finanzbuchungskopie
Background: back_dummy1

Given I set the fake date to "07.01.02"

Scenario: Finanzbuchung buchen ohne Eingriff in die Fälligkeitswerte/Fälligkeitslogik
Given I set the fake date to "07.01.02"

Given I open an editor "fibu" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "faellanf"
And I set field "text" to "Finanzbuchung Faelligkeit automatisch, nicht fixiert (anf), sys 7.1.2"
And I set field "budat" to "."
And I append rows
|konto|ewsbetr|ewhbetr|kstelle    |
|L 001|       |      0|!dontChange|
|50000|    100|       |    101    |
# 1941 : Buchung o.k., Automatische Belegnummer?
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# Werte im Original

Given I open an editor "kontrolle1" from table "(Entry):(Entry)" with command "VIEW" for record "faellanf"
#Then field "beldat" has value "07.01.02"
#Then field "vdat" has value "07.01.02"
#Then field "zbed" has value "201"
#Then field "term" has value "17.01.02"
#Then field "mterm" has value "nein"
And I close the current editor


Scenario: Kontrolle der Fälligkeit (anf) nach Finanzbuchung kopieren bei wesentlich späterem Systemdatum
Given I set the fake date to "28.02.02"

Given I open an editor "buchungskopie1" from table "(Entry):(Entry)" with command "COPY" for record "faellanf"
And I set field "such" to "faellkop1"
And I set field "text" to "Finanzbuchungskopie aus faellanf zur Ergebniskontrolle, sys 28.2.2"
And I set field "budat" to "28.02.02"
# 583 de      |Buchung o.k.?
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

# Ergebnisse in der Kopie
Given I open an editor "kontrolle2" from table "(Entry):(Entry)" with command "VIEW" for record "faellkop1"
#Then field "konto" has value "L 001" in row 1
#Then field "beldat" has value "07.01.02"
#Then field "vdat" has value "07.01.02"
#Then field "zbed" has value "201"
#Then field "term" has value "17.01.02"
#Then field "mterm" has value "nein"
And I close the current editor

# ================================

Scenario: mmff s. textfeld
Given I set the fake date to "04.03.02"

Given I open an editor "fibu" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "faellmmff"
And I set field "text" to "Finanzbuchung mit manueller Faelligkeit, fixiert (mmff), sys 4.3.2"
And I set field "budat" to "03.03.02"
And I append rows
|konto|ewsbetr|ewhbetr|kstelle    |
|L 001|       |      0|!dontChange|
|50000|    100|       |    101    |

And I set field "term" to "29.03.02"
# wird schon vorher autom. gesetzt, trotzdem so lassen! gehört so zum testfall! 
And I set field "mterm" to "ja"

# 1941 : Buchung o.k., Automatische Belegnummer?
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# Werte im Original

Given I open an editor "kontrolle3" from table "(Entry):(Entry)" with command "VIEW" for record "faellmmff"
#Then field "beldat" has value "03.03.02"
#Then field "vdat" has value "03.03.02"
#Then field "zbed" has value "201"
#Then field "term" has value "29.03.02"
#Then field "mterm" has value "ja"
And I close the current editor


Scenario: Kontrolle der Fälligkeit (mmff) nach Finanzbuchung kopieren bei wesentlich späterem Systemdatum
Given I set the fake date to "28.03.02"

Given I open an editor "buchungskopie2" from table "(Entry):(Entry)" with command "COPY" for record "faellmmff"
And I set field "such" to "faellkop2"
And I set field "text" to "Finanzbuchungskopie aus faellmmff zur Ergebniskontrolle, sys 28.3.2"
And I set field "budat" to "27.03.02"
# 583 de      |Buchung o.k.?
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

# Ergebnisse in der Kopie
Given I open an editor "kontrolle4" from table "(Entry):(Entry)" with command "VIEW" for record "faellkop2"
#Then field "konto" has value "L 001" in row 1
#Then field "beldat" has value "03.03.02"
#Then field "vdat" has value "03.03.02"
#Then field "zbed" has value "201"
#Then field "term" has value "13.03.02"
#Then field "mterm" has value "nein"
And I close the current editor

# ==============================

Scenario: mmnf s. textfeld
Given I set the fake date to "10.04.02"

Given I open an editor "fibu" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "faellmmnf"
And I set field "text" to "Finanzbuchung mit manueller Faelligkeit (mmnf), sys 10.4.2"
And I set field "budat" to "08.04.02"
And I append rows
|konto|ewsbetr|ewhbetr|kstelle    |
|L 001|       |      0|!dontChange|
|50000|    100|       |    101    |

And I set field "term" to "12.04.02"

# 1941 : Buchung o.k., Automatische Belegnummer?
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor

# Werte im Original

Given I open an editor "kontrolle5" from table "(Entry):(Entry)" with command "VIEW" for record "faellmmnf"
#Then field "beldat" has value "08.04.02"
#Then field "vdat" has value "08.04.02"
#Then field "zbed" has value "201"
#Then field "term" has value "18.04.02"
#Then field "mterm" has value "nein"
And I close the current editor


Scenario: Kontrolle der Fälligkeit (mmnf) nach Finanzbuchung kopieren bei wesentlich späterem Systemdatum
Given I set the fake date to "21.05.02"

Given I open an editor "buchungskopie3" from table "(Entry):(Entry)" with command "COPY" for record "faellmmnf"
And I set field "such" to "faellkop3"
And I set field "text" to "Finanzbuchungskopie aus faellmmnf zur Ergebniskontrolle, sys 21.5.2"
And I set field "budat" to "21.05.02"
# 583 de      |Buchung o.k.?
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor

# Ergebnisse in der Kopie
Given I open an editor "kontrolle6" from table "(Entry):(Entry)" with command "VIEW" for record "faellkop3"
#Then field "konto" has value "L 001" in row 1
#Then field "beldat" has value "08.04.02"
#Then field "vdat" has value "08.04.02"
#Then field "zbed" has value "201"
#Then field "term" has value "18.04.02"
#Then field "mterm" has value "nein"
And I close the current editor

# ==============================

Scenario: mmnfozb s. textfeld
Given I set the fake date to "29.05.02"

Given I open an editor "fibu" from table "(Entry):(Entry)" with command "NEW" for record ""
And I set field "such" to "mmnfozb"
And I set field "text" to "Finanzbuchung mit manueller Faelligkeit ohne ZBed (mmnfozb), sys 29.5.2"
And I set field "budat" to "."
And I append rows
|konto|ewsbetr|ewhbetr|kstelle    |
|L 001|       |      0|!dontChange|
|50000|    100|       |    101    |

And I set field "zbed" to ""
And I set field "vdat" to ""

And I set field "term" to "12.06.02"

# 1941 : Buchung o.k., Automatische Belegnummer?
And I respond with answer "ja" to the dialog with id "1941"
And I save the current editor
And I close the current editor


Scenario: Kontrolle der Fälligkeit (mmnfozb) nach Finanzbuchung kopieren bei wesentlich späterem Systemdatum
Given I set the fake date to "02.06.02"

Given I open an editor "buchungskopie4" from table "(Entry):(Entry)" with command "COPY" for record "mmnfozb"
And I set field "such" to "faellkop4"
And I set field "text" to "Finanzbuchungskopie aus mmnfozb zur Ergebniskontrolle, sys 2.6.2"
And I set field "budat" to "01.06.02"

# 58 de: bitte datum eintragen
And saving the current editor throws the exception "58"

And I set field "term" to "26.06.02"

# 583 de      |Buchung o.k.?
And I respond with answer "ja" to the dialog with id "583"
And I save the current editor
And I close the current editor
