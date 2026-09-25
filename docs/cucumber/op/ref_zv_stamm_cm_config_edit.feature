# *****************************************************************************
#  Name             : ref_zv_stamm_cm_config_edit.feature
#  Autor            : hc
#  Verantwortlich   : hc
#  Kontrolle        :
#  Funktion         : Test des Editors V-66-01 ZVkonfig (Zahlungsverkehr-Konfiguration, AJO: CMConfig)
#  ref              : ref_zv_stamm_cm_config_edit_cu
# *****************************************************************************

@persistent
Feature: ref_zv_stamm_cm_config_edit.feature
Background:
Given I set the fake date to "31.12.2022"

# =============================================================================
Scenario: ZVkonfig VIEW (1)

Given I open an editor "ZVKONFIG-1-VIEW" from table "(PaymentMasterFiles):(CMConfig)" with command "VIEW" for record "1"
Then field "num66" has value "1"
Then field "such66" has value "KONFIG"
And I save the current editor

# =============================================================================
Scenario: ZVkonfig DELETE (1 ohne Wartung)

Given I'm logged in with password "sy"

Given I open an editor "ZVKONFIG-1-DELETE" from table "(PaymentMasterFiles):(CMConfig)" with command "DELETE" for record "1"
# 111 de      |darf nicht gelöscht werden
Then saving the current editor throws the exception "111"
And I close the current editor

# =============================================================================
Scenario: ZVkonfig DELETE (1 in Wartung)

Given I'm logged in with password "annette"

Given I open an editor "ZVKONFIG-1-DELETE" from table "(PaymentMasterFiles):(CMConfig)" with command "DELETE" for record "1"
And I respond with answer "ja" to the dialog with id "826"
And I save the current editor

Given I'm logged in with password "sy"

# =============================================================================
Scenario: ZVkonfig NEW (1002)

Given I open an editor "ZVKONFIG-NEW" from table "(PaymentMasterFiles):(CMConfig)" with command "NEW" for record ""

# --- Default-Vorbelegung prüfen
Then field "gsofort" has value "ja"
Then field "verrbuchen" has value "ja"

And I set fields
   | num66   | 1002       |
   | such66  | ZVKONF2 |

And I save the current editor

# =============================================================================
Scenario: ZVkonfig NEW nochmal

Then opening an editor from table "(PaymentMasterFiles):(CMConfig)" with command "NEW" for record "" throws the exception "351"
# 351 de      |Datensatz existiert - Mehrfacherfassung nicht erlaubt

# =============================================================================
Scenario: ZVkonfig COPY (Fehler, weil 1 mal Objekt)

Then opening an editor from table "(PaymentMasterFiles):(CMConfig)" with command "COPY" for record "1002" throws the exception "351"
# 351 de      |Datensatz existiert - Mehrfacherfassung nicht erlaubt

# =============================================================================
Scenario: ZVkonfig UPDATE (1002), Feldänderbarkeit

Given I open an editor "ZVKONFIG-UPDATE" from table "(PaymentMasterFiles):(CMConfig)" with command "UPDATE" for record "1002"

# --- Identnummer, Suchwort, Bezeichnung
Then field "num66" is modifiable
Then field "such66" is modifiable
Then field "namebspr" is modifiable

# --- Maximale Anzahl der Tabellenzeilen
Then field "mzeile" is modifiable

# --- Mahnwesen
Then field "mbed" is modifiable
Then field "gsofort" is modifiable
Then field "lmahnsperr" is modifiable

# --- Zahlungsvorschläge
Then field "zveinterv" is modifiable
Then field "zvainterv" is modifiable
Then field "zveopvor" is modifiable
Then field "zvaopvor" is modifiable
Then field "eskzanach" is modifiable
Then field "askzanach" is modifiable
Then field "enettozanach" is modifiable
Then field "anettozanach" is modifiable
Then field "skktagekure" is modifiable
Then field "skktagekugut" is modifiable
Then field "skktagelire" is modifiable
Then field "skktageligut" is modifiable

# --- Ausbuchen
Then field "ausbusorttab" is modifiable

# --- Verrechnen
Then field "verrbuchen" is modifiable
Then field "verrkonto" is modifiable
Then field "verrkontoname" is not modifiable
Then field "verrtext1" is modifiable

# --- Umbuchen, Zahlungsträger
Then field "bdatauto" is modifiable
Then field "zaverfseparat" is modifiable
Then field "euzaraum" is modifiable
Then field "eumaxzahl" is modifiable
Then field "reminavis" is modifiable
Then field "vzweckers" is modifiable
Then field "bdatserver" is modifiable
Then field "bdatclient" is modifiable
Then field "datloesch" is modifiable
Then field "scheckeinrauto" is modifiable
Then field "minscheck" is modifiable
Then field "wechseleinrauto" is modifiable
Then field "ztrsammauto" is modifiable
Then field "sammnegativ" is modifiable

# --- SEPA
Then field "sepawaehr" is modifiable
Then field "sepamrefzaehl" is modifiable
Then field "sepamrefvorl" is modifiable
Then field "sepamverfallmon" is modifiable
Then field "sepamktext1" is modifiable
Then field "sepamktext2" is modifiable
Then field "sepamktext3" is modifiable
Then field "sepamktext6" is modifiable
Then field "sepamktext7" is modifiable
Then field "sepamktext8" is modifiable
Then field "sepamktext9" is modifiable
Then field "sepamktext10" is modifiable
Then field "sepamktext4" is modifiable
Then field "sepamktext5" is modifiable

# --- Zuordnungskonfiguration: Zuordnung offene Posten, Zuordnung der Gutschriften

Then field "zuordkgutschrift" is modifiable
Then field "zuordkbelastung" is modifiable
Then field "gopausgleich" is modifiable
Then field "bopausgleich" is modifiable
Then field "gnkonten" is modifiable
Then field "bnkonten" is modifiable

# --- Liquiditätsplanung
Then field "lqplanszenario" is modifiable
Then field "lqplanzaenddat" is modifiable
Then field "lqkbereich" is modifiable

# --- Suchwortpräfixe
Then field "swpba" is modifiable
Then field "swpbv" is modifiable
Then field "swpueberw" is modifiable
Then field "swplast" is modifiable
Then field "swpbvorg" is modifiable
Then field "swpescheck" is modifiable
Then field "swpascheck" is modifiable
Then field "swpscheck" is modifiable
Then field "swpkwechsel" is modifiable
Then field "swpztr" is modifiable
Then field "swpztrsamm" is modifiable
Then field "swpsepamandvk" is modifiable
Then field "swpsepamandek" is modifiable
Then field "swkab" is modifiable
Then field "swkak" is modifiable
Then field "swpmahn" is modifiable
Then field "swpmahnvorg" is modifiable
Then field "swpzveing" is modifiable
Then field "swpzvausg" is modifiable
Then field "swpbuerggegeben" is modifiable
Then field "swpbuergerhalten" is modifiable
Then field "swpbuergrahmen" is modifiable
Then field "swpzvumbew" is modifiable
Then field "swpzvverr" is modifiable
Then field "swpzvausbu" is modifiable
Then field "swpzvzaaus" is modifiable
Then field "swpzvzaein" is modifiable
# --- Suchwortpräfixe: Felder nicht in der Maske, Felder ohne Verwendung
# Then field "swpzbedschl" is modifiable
# Then field "swptum" is modifiable

# --- Suchworterweiterung der Bank
Then field "swpbaname" is modifiable
Then field "swpbanid" is modifiable
Then field "swpbaiid" is modifiable

# --- Suchworterweiterung der Bankverbindung: Felder ohne Verwendung
# Then field "swpbvbank" is modifiable
# Then field "swpbviban" is modifiable
# Then field "swpbvbko" is modifiable

And I save the current editor

# =============================================================================
Scenario: Konto NEW (14700)

Given I open an editor "Konto_14700" from table "(Account):(Account)" with command "NEW" for record ""
Then field "bebuchbar" has value "ja"
Then field "karta" has value ""
And I set fields
   | num5  | 14700 |
   | such5 | VERR-NO |
   | name  | Konto bebuchbar, kein Verrechnungskonto |
   | bu    | ja |
   | karta | |
And I save the current editor

# =============================================================================
Scenario: Konto COPY (14700 -> 14799, 14701, 14702)

Given I open an editor "Konto_14799" from table "(Account):(Account)" with command "COPY" for record "14700"
Then field "bebuchbar" has value "ja"
Then field "karta" has value ""
And I set fields
   | num5  | 14799 |
   | such5 | VERR-NO_BU-NO |
   | name  | Konto nicht bebuchbar, kein Verrechnungskonto |
   | karta | |
   | bu    | nein |
And I save the current editor

Given I open an editor "Konto_14701" from table "(Account):(Account)" with command "COPY" for record "14700"
Then field "bebuchbar" has value "ja"
Then field "karta" has value ""
And I set fields
   | num5  | 14701 |
   | such5 | VERR_BU |
   | name  | Verrechnungskonto 1, bebuchbar |
   | karta | Verrechnungskonto |
   | bu    | ja |
And I save the current editor

Given I open an editor "Konto_14702" from table "(Account):(Account)" with command "COPY" for record "14701"
Then field "bebuchbar" has value "ja"
Then field "karta" has value "Verrechnungskonto"
And I set fields
   | num5  | 14702 |
   | name  | Verrechnungskonto 2, bebuchbar |
And I save the current editor

# --- Verrechnungskonten sind immer bebuchbar
Given I open an editor "Konto_14703" from table "(Account):(Account)" with command "COPY" for record "14700"
Then field "bebuchbar" has value "ja"
Then field "karta" has value ""
And I set fields
   | num5  | 14703 |
   | such5 | VERR_BU |
   | name  | Verrechnungskonto, nicht bebuchbar |
   | karta | Verrechnungskonto |
   | bu    | nein |
Then saving the current editor throws the exception "53"
# 53 de      |Das ist kein Buchungskonto
And I close the current editor

# =============================================================================
Scenario: ZVkonfig UPDATE (num66: 1002 --> 1ZVkonf), Feldprüfung und Feldnachbehandlung

Given I open an editor "ZVKONFIG-UPDATE" from table "(PaymentMasterFiles):(CMConfig)" with command "UPDATE" for record "1002"

# ===== Vorbelegung der Felder beim Öffnen der Maske prüfen =====

Then field "num66" has value "1002"
Then field "such66" has value "ZVKONF2"
Then field "gsofort" has value "ja"
Then field "verrbuchen" has value "ja"

# ===== Identnummer und Suchwort ändern =====

And I set fields
   | num66   | 1ZVkonf |
   | such66  | ZVKONF1 |

# ===== Feldprüfung =====

# --- zvmzeile IP5 Maximale Anzahl der Tabellenzeilen
Then field "mzeile" has value "0"
And I set field "mzeile" to "0"
And I set field "mzeile" to "1"
And I set field "mzeile" to "1000"
And I set field "mzeile" to "10000"

# And I set fields
#    | mzeile   | 0 |
#    | mzeile   | 1 |
#    | mzeile   | 1000 |
#    | mzeile   | 10000 |

Then setting field "mzeile" to "10001" throws the exception "1651"
# 1651 de      |Es sind maximal 10000 Tabellenzeilen erlaubt
Then setting field "mzeile" to "-1" throws the exception "1361"
# 1361 de      |Ungültiger Feldwert

# --- zvverrkonto P5:1 Verrechnungskonto
Then field "verrkonto" has value ""

And I set field "verrkonto" to ""
And I set field "verrkonto" to "14701"
And I set field "verrkonto" to "14702"

# And I set fields
#    | verrkonto   | |
#    | verrkonto   | 14701 |
#    | verrkonto   | 14702 |

Then setting field "verrkonto" to "14799" throws the exception "1361"
# 1361 de      |Ungültiger Feldwert
Then setting field "verrkonto" to "14700" throws the exception "1361"
# 1361 de      |Ungültiger Feldwert

Then field "verrkonto" has value "14702"

# ===== Feldnachbehandlung =====

# --- zvswpbanid B Nationale Identifikation 1 als Suchworterweiterung in der Bank?
And I set field "swpbanid" to "ja"
Then field "swpbaiid" has value "nein"
Then field "swpbaname" has value "nein"

# --- zvswpbaiid B Internationale Identifikation als Suchworterweiterung in der Bank?
And I set field "swpbaiid" to "ja"
Then field "swpbanid" has value "nein"
Then field "swpbaname" has value "nein"

# --- zvswpbaname B Bankname als Sucherweiterung in der Bank?
And I set field "swpbaname" to "ja"
Then field "swpbanid" has value "nein"
Then field "swpbaiid" has value "nein"

# --- zvzveopvor IP4 Offene Posten um n-Tage früher im Zahlungseingangsvorschlag
And I set field "zveopvor" to "10"
Then field "eskzanach" has value "0"
Then field "enettozanach" has value "0"

# --- zveskzanach
And I set field "eskzanach" to "3"
Then field "zveopvor" has value "0"

# --- zvenettozanach
And I set field "enettozanach" to "3"
Then field "zveopvor" has value "0"

# --- zvzvaopvor IP4 Offene Posten um n-Tage früher im Zahlungsausgangsvorschlag
And I set field "zvaopvor" to "10"
Then field "askzanach" has value "0"
Then field "anettozanach" has value "0"

# --- zvaskzanach
And I set field "askzanach" to "3"
Then field "zvaopvor" has value "0"

# --- zvanettozanach
And I set field "anettozanach" to "3"
Then field "zvaopvor" has value "0"

And I save the current editor
