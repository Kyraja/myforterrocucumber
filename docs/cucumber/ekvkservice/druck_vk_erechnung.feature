#@persistent
Feature: ABAS-361
Background:
Given I set the fake date to "02.01.1995"

@print:
Scenario: Aktivieren der Konfiguration erech
Given I open an editor "konfiguration" from table "(Company):(Configuration)" with command "UPDATE" for record "0k"
And I set field "habel" to "1"
And I set field "zugferd" to "1"
And I save the current editor

Scenario Outline: Umstellen der Belegarten fuer das alte Verfahren
Given I open an editor "belegart" from table "(PrintParameter):(DocumentTypes)" with command "UPDATE" for record "<nummer>"
And I set field "aktiv" to "<aktiv>"
And I save the current editor

Examples:
| row | nummer | aktiv |
| 001 | 20236  | 0     |
| 002 | 20242  | 0     |
| 003 | 20237  | 1     |
| 004 | 20241  | 1     |

Scenario Outline: EDI-Konfiguration ZUGFERD setzen
Given I open an editor "Kunde" from table "(Customer):(Customer)" with command "UPDATE" for record "<nummer>"
And I press button "edinfo" to open a subeditor for "EDIInfo"
And I create a new row at the end of the table
And I set field "edinachraz" to "ZUGFeRD-Rechnung Export" in row 1
And I set field "ieabmodell" to "4150" in row 1
And I set field "erlaubt" to "ja" in row 1
And I save the current editor
And I switch the current editor to editor "Kunde"
And I save the current editor

Examples:
|row  | nummer|
| 001 | 5     |

Scenario Outline: Kopieren von Rechnungen und Vorbedingungen fuer E-Versand
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "COPY" for record "<quelle>"
And I set field "nummer" to "<nummer>"
And I set field "such" to "<such>"
And I set field "schlag" to "<schlag>"
And I set field "kl2" to "<kl2>"
And I set field "erechok" to "<erechok>"
And I set field "erechmail" to "<erechmail>"
And I set field "ueb" to "<ueb>"
And I set field "ueb" to "<ueb>"
And I set field "tterm" to "."
And I save the current editor

Examples:
| row | quelle | nummer  | such   |  schlag                     |kl2          | erechok | erechmail     | ueb         |
| 001 | 4712   | 44712   | R44712 |Vorlage fuer Gutschrift      | !dontChange | 1       |devnull@abas.de| 1           |
| 002 | 4712   | 44713   | R44713 |V E-Rechnung nicht gebucht   | !dontChange | 1       |devnull@abas.de| !dontChange |
| 003 | 4712   | 44714   | R44714 |V E-Rechnung gebucht         | !dontChange | 1       |devnull@abas.de| 1           |
| 004 | 4712   | 44715   | R44715 |V neu: E-Rechnung gebucht    | !dontChange | 1       |devnull@abas.de| 1           |
| 005 | 4712   | 44716   | R44716 |V neu: E-Rechnung2 gebucht   | !dontChange | 1       |devnull@abas.de| 1           |
| 006 | 4712   | 44717   | R44717 |V neu: ZUGFERD2 gebucht      | 5           | 1       |devnull@abas.de| 1           |

Scenario Outline: Erzeugen von Ruecklieferscheinen fuer Gutschriften
Given I open an editor "lieferschein" from table "(Sales):(Invoice)" with command "RETURN" for record "<quelle>"
And I set field "nummer" to "<nummer>"
And I set field "ueb" to "ja"
And I set field "vom" to "."
And I press button "offueb" in row 1
And I save the current editor

Examples:
| row | quelle   | nummer  | such     |
| 001 | +R44712  | 44812   | L44812   |
| 002 | +R44714  | 44814   | L44814   |
| 002 | +R44715  | 44815   | L44815   |
| 002 | +R44716  | 44816   | L44816   |

Scenario Outline: Erzeugen von Gutschriften und Vorbedingungen fuer E-Versand
Given I open an editor "gutschrift" from table "(Sales):(Invoice)" with command "NEW" for record ""
And I set field "beleg" to "<quelle>"
And I set field "nummer" to "<nummer>"
And I set field "schlag" to "<schlag>"
And I set field "erechok" to "<erechok>"
And I set field "erechmail" to "<erechmail>"
And I set field "ueb" to "<ueb>"
And I respond with answer "ja" to the dialog with id "4841"
And I save the current editor

Examples:
| row | quelle | nummer  | schlag                     | erechok | erechmail     | ueb         |
| 001 | 44812  | 55713   | E-Gutschrift nicht gebucht | 1       |devnull@abas.de| !dontChange |
| 002 | 44814  | 55714   | E-Gutschrift gebucht       | 1       |devnull@abas.de| 1           |
| 003 | 44815  | 55715   | neu: E-Gutschrift gebucht  | 1       |devnull@abas.de| 1           |
| 004 | 44816  | 55716   | neu: E-Gutschrift2 gebucht | 1       |devnull@abas.de| 1           |

Scenario Outline: Drucken Rechnung, Gutschrift, E-Rechnung und E-Gutschrift mit Archivierung nach altem Verfahren
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "VIEW" for record "<nummer>"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "<layout>"
Then field "aktbelegart" has value "<belegart>"
And I save the current editor
And I switch the current editor to editor "rechnung"
And I close the current editor
Then file "myhomedir/abasdms/gedosod/spools/Sales/001_<nummer2>_[0-9]*.pdf" exists
Then file "myhomedir/abasdms/gedosod/spools/Sales/001_<nummer2>_[0-9]*.idx" exists

Examples:
| row | nummer   | layout  | belegart                         | nummer2 |
| 001 |  44713   | MASTER  | VK Rechnung                      | 44713   |
| 002 | +44714   | MASTER  | VK Rechnung mit E-Mail-Versand   | 44714   |
| 003 |  55713   | MASTER  | VK Gutschrift                    | 55713   |
| 004 | +55714   | MASTER  | VK Gutschrift mit E-Mail-Versand | 55714   |

Scenario Outline: Umstellen der Belegarten fuer das neue Verfahren
Given I open an editor "belegart" from table "(PrintParameter):(DocumentTypes)" with command "UPDATE" for record "<nummer>"
And I set field "aktiv" to "<aktiv>"
And I save the current editor

Examples:
| row | nummer | aktiv |
| 001 | 20236  | 1     |
| 002 | 20242  | 1     |
| 003 | 20237  | 0     |
| 004 | 20241  | 0     |

Scenario Outline: E-Rechnung und E-Gutschrift mit Archivierung nach neuem Verfahren
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "VIEW" for record "<nummer>"
Then field "druck" has value "ja"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "<layout>"
Then field "aktbelegart" has value "<belegart>"
And I save the current editor
And I switch the current editor to editor "rechnung"
And I close the current editor
Then file "myhomedir/abasdms/gedosod/spools/Dragdrop/001_<nummer2>_[0-9]*.eml" exists
Then file "myhomedir/abasdms/gedosod/spools/Dragdrop/001_<nummer2>_[0-9]*.idx" exists

Examples:
| row | nummer | layout    | belegart        | nummer2 |
| 001 | +44715 | MASTER    | VK E-Rechnung   | 44715   |
| 002 | +44716 | EMASTER   | VK E-Rechnung   | 44716   |
| 003 | +55715 | MASTER    | VK E-Gutschrift | 55715   |
| 004 | +55716 | EMASTER   | VK E-Gutschrift | 55716   |
| 005 | +44717 | ZUGFERD2  | VK E-Rechnung   | 44717   |

Scenario Outline: E-Rechnung und E-Gutschrift noch einmal drucken
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "VIEW" for record "<nummer>"
Then field "druck" has value "nein"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "<layout>"
Then field "aktbelegart" has value "<belegart>"
And I save the current editor
And I switch the current editor to editor "rechnung"
And I close the current editor
Then file "myhomedir/abasdms/gedosod/spools/Sales/001_<nummer2>_[0-9]*.pdf" exists
Then file "myhomedir/abasdms/gedosod/spools/Sales/001_<nummer2>_[0-9]*.idx" exists

Examples:
| row | nummer | layout  | belegart      | nummer2 |
| 001 | +44715 | MASTER  | VK Rechnung   | 44715   |
| 002 | +55715 | MASTER  | VK Gutschrift | 55715   |

Scenario Outline: E-Rechnung und E-Gutschrift noch einmal drucken
Given I open an editor "rechnung" from table "(Sales):(Invoice)" with command "VIEW" for record "<nummer>"
Then field "druck" has value "nein"
And I press button "budruck2" to open a subeditor for "Druckdialog"
And I set field "layout" to "<layout>"
Then field "aktbelegart" has value "<belegart>"
Then saving the current editor throws the exception
"""
Vorgang abgebrochen
Fehler beim Drucken über die Kontextzeilen aufgetreten. Zeile 0 gescheitert. Letzte Fehlermeldung:
Ausdruck der Kontextzeile 0 gescheitert:
Die Rechnung wurde bereits gedruckt.

"""
Then file "myhomedir/abasdms/gedosod/spools/Sales/001_<nummer2>_[0-9]*.pdf" exists not
Then file "myhomedir/abasdms/gedosod/spools/Sales/001_<nummer2>_[0-9]*.idx" exists not

Examples:
| row | nummer | layout  | belegart      | nummer2 |
| 001 | +44716 | EMASTER | VK Rechnung   | 44716   |
| 002 | +55716 | EMASTER | VK Gutschrift | 55716   |


Scenario Outline: Vorhandene Archiv-Spoolerdateien testen
Then file "<datei>" exists

Examples:
| row | datei |
| 001 | myhomedir/abasdms/gedosod/habel.spool |
| 002 | myhomedir/abasdms/gedosod/habel.spool |
| 003 | myhomedir/abasdms/gedosod/RunDD.Job   |
| 004 | myhomedir/abasdms/gedosod/RunDD.Job  |

Scenario Outline: Inhalt von E-Mails und PDFs pruefen
And I find <anzahl> files with content "<content>" and pattern "<pattern>"

Examples:

| row | content    | pattern                                         | anzahl |
| 001 | Message-ID:| myhomedir/abasdms/gedosod/spools/Dragdrop/*.eml | 5      |
| 002 | attachment;| myhomedir/abasdms/gedosod/spools/Dragdrop/*.eml | 5      |
| 003 | PDF-       | myhomedir/abasdms/gedosod/spools/Sales/*.pdf    | 6      |
