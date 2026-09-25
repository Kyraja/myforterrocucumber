@persistent
Feature: konten_kostenobjekt_sperren_in_rueckmeldung

Background:
And I set the fake date to "03.02.2002"

# *****************************************************************************
#  Autor            : uo
#  Verantwortlich   : uo
#  Kontrolle        : 
#  Jira-Issue       : BW2-2057
# *****************************************************************************

Scenario: 01 Vorbelegung und Schreibschutz in Rückbaubeleg
# Fertigungsvorschlag anlegen und freigeben

    # -------- sperrfähige kostenstelle anlegen ---------
	Given I open an editor "freie_Kostenstelle" from table "(Account):(CostCenter)" with command "COPY" for record "111"
	And I set field "nummer" to "211"
	And I save the current editor

    # -------- kostenstelle für fertigungskosten verwenden -------
	Given I open an editor "kst_in_maschgrp" from table "(Capacity):(WorkCenter)" with command "UPDATE" for record "101"
	And I set field "kstelle" to "211"
	And I save the current editor

    Given I open an editor "fvor" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | kstelle | bisuch    | mfreig |
      | BG1       | 10     |   211   | RM        | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor"
    And I save the current editor


Scenario: kv mit gesperrter kst in tabelle in rm mit FV (Speichern- und Feld-Plausi und Speicherung)

	# Stamm-Kostenverteiler anlegen
	Given I open an editor "kostenverteiler-10" from table "(Account):(CostDistribution)" with command "NEW" for record ""
	And I set field "nummer" to "10"
	And I set field "such" to "kv10"
	And I create a new row at the end of the table
	And I set field "kstelle" to "112" in row 1
	And I set field "proz" to "10" in row 1
	And I create a new row at the end of the table
	And I set field "kstelle" to "115" in row 2
	And I set field "proz" to "5" in row 2
	And I create a new row at the end of the table
	# diese kst wird gesperrt
	And I set field "kstelle" to "211" in row 3
	And I set field "proz" to "85" in row 3
	And I save the current editor


    Given I open an editor "fvor-kv" from table "(Purchasing):(WorkOrderSuggestions)" with command "NEW" for record ""
    And I append rows
      | artikel   | netmge | kstelle | bisuch    | mfreig |
      | BG1       | 10     |   kv10  | KVRM      | ja     |
    And I press button "freig" to open a subeditor for "BA_freigeben"
    And I close the current editor
    And I switch the current editor to editor "fvor-kv"
    And I save the current editor


	Given I open an editor "Kstelle1-sperren" from table "(Account):(CostCenter)" with command "UPDATE" for record "211"
	And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
	And I save the current editor

	Given I open an editor "Kostenstelle-absichern" from table "(Account):(CostCenter)" with command "VIEW" for record "211"
    Then field "sperrkonfigurationneu" has value "Standard-Kostenstellensperre"
	And I close the current editor


    Given I open an editor "Rückmeldung-kv1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "KVRM001"

    # ist-zustand der rückmeldung
    Then field "typa279" has value "Rückmeldung"

    Then the table has 1 rows
    Then field "artikel" has value "BG1" in row 1
    Then field "mge" has value "10" in row 1

	Then field "sofort" is modifiable
    # input:
	And I set field "sofort" to "nein"

    And I set field "mzeit" to "1"
    And I set field "fixkost" to "44"

    # kstelle wird hier nicht gesperrt
    Then field "kstelle" has value "10"

    And I set field "mgkstl" to "KV10"

    # kv eintragen => wird nachrangig geprüft 
    And I set field "makstl" to "KV10"
    And I set field "makstl2" to "101"
    And I set field "makstl3" to "101"
    And I set field "makstl4" to "101"
    And I set field "makstl5" to "101"

    # ergebnisse der sperrbedingungen: siehe Examplestabelle
    Then field "kontensperredeaktiviert" has value "ja"
    Then field "kstellesperredeaktiviert" has value "ja"

	And I set field "sofort" to "ja"

	# feldplausis:
    Then field "mgkstl" has value "10"
    # And setting field "mgkstl" to "KV10" throws the exception "3602"
    
    And setting field "makstl2" to "KV10" throws the exception "3602"
    And setting field "makstl3" to "KV10" throws the exception "3602"
    And setting field "makstl4" to "KV10" throws the exception "3602"
    And setting field "makstl5" to "KV10" throws the exception "3602"

    # Bedingung kontensperredeaktiviert gilt auch für alle Kostenobjektfelder der Fertigungsleistung (Zeiten)
    Then field "kontensperredeaktiviert" has value "nein"

	# Bedingung kstellesperredeaktiviert gilt ausschließlich für das Kopffeld kstelle
	# und nicht für andere Kostenobjektfelder! 
    Then field "kstellesperredeaktiviert" has value "ja"

	# hier: sofort aus masken übertragen. meldung muss sich auf kostenverteiler beziehen!
	# nr 3602!
    Then saving the current editor throws the exception "3602"

	And I set field "sofort" to "nein"
	# erfasste werte merken
	And I save the current editor


	# hier: Versuch vorerfasste/gespeicherte RM zu übertragen MUSS SCHEITERN. meldung muss sich auf kostenverteiler beziehen!
    Given I open an editor "KVRM001_uebertragung_muss_scheitern" from table "(Workorder):(CompletionConfirmations)" with command "TRANSFER" for record "KVRM001"
	# nr 3602!
    Then saving the current editor throws the exception "3602"
    And I close the current editor


	Given I open an editor "Kstelle1-wieder-entsperren" from table "(Account):(CostCenter)" with command "UPDATE" for record "211"
	And I set field "sperrkonfigurationneu" to ""
	And I save the current editor

	Given I open an editor "Kostenstelle-absichern" from table "(Account):(CostCenter)" with command "VIEW" for record "211"
    Then field "sperrkonfigurationneu" has value ""
	And I close the current editor


	# hier: vorerfasste/gespeicherte RM ohne gesperrte kst 211 (s. zeilen vorher) MUSS übertragen werden.
	# meldung muss sich auf kostenverteiler beziehen!
    Given I open an editor "KVRM001_uebertragung_muss_durchgehen" from table "(Workorder):(CompletionConfirmations)" with command "TRANSFER" for record "KVRM001"
    And I save the current editor

    Given I open an editor "KVRM001_storno_muss_durchgehen" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record "+KVRM001"
    And I save the current editor


Scenario: kv mit gesperrter kst in tabelle in rm ohne FV (nur Speichern-Plausi)
										# Speicherungen solcher FV gibt es sicher zu genüge

	Given I open an editor "Kstelle1-sperren" from table "(Account):(CostCenter)" with command "UPDATE" for record "211"
	And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
	And I save the current editor

	Given I open an editor "Kostenstelle-absichern" from table "(Account):(CostCenter)" with command "VIEW" for record "211"
    Then field "sperrkonfigurationneu" has value "Standard-Kostenstellensperre"
	And I close the current editor


    Given I open an editor "Rückmeldung kv ohne fv" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
    And I set field "barmex" to "10sperrinkv"

    # ist-zustand der rückmeldung
    Then field "typa279" has value "Rückmeldung ohne Fertigungsvorschlag"


	# sofort==ja ist bedingung für aktive kostenstellensperre: ist bei <neu> generell erfüllt 
	Then field "sofort" is not modifiable
    Then field "sofort" has value "ja"
	Then field "kstelle" is modifiable
    And I set field "kstelle" to "KV10"

    Then the table has 0 rows
    And I set field "artikel" to "BG1"
    And I set field "mgr" to "BOHREREI"

    # input:
    And I set field "mzeit" to "2"
    And I set field "varkost" to "3"

    # Fertigartikelzeile / Zugangszeile
    And I create a new row at the end of the table    
    And I set field "artikel" to "BG1" in row !lastRow
    And I set field "gutmge" to "4" in row !lastRow
    And I set field "verlustmge" to "0" in row !lastRow

    # Entnahmezeile
    And I create a new row at the end of the table    
    And I set field "artikel" to "E1" in row !lastRow
    And I set field "mge" to "5" in row !lastRow

    Then field "kstelle" has value "10"
    Then field "mgkstl" has value "101"
    Then field "makstl" has value "101"
    Then field "makstl2" has value "101"
    Then field "makstl3" has value "101"
    Then field "makstl4" has value "101"
    Then field "makstl5" has value "101"

	# feldplausis:   kstelle wird im speichern geprüft
    And setting field "mgkstl" to "KV10" throws the exception "3602"
    
    And setting field "makstl2" to "KV10" throws the exception "3602"
    And setting field "makstl2" to "KV10" throws the exception "3602"
    And setting field "makstl3" to "KV10" throws the exception "3602"
    And setting field "makstl4" to "KV10" throws the exception "3602"
    And setting field "makstl5" to "KV10" throws the exception "3602"

    
    # ergebnisse der sperrbedingungen:  siehe Examplestabelle
    # Bedingung kontensperredeaktiviert gilt auch für alle Kostenobjektfelder der Fertigungsleistung (Zeiten)
    Then field "kontensperredeaktiviert" has value "nein"
    
    # Kostenstellensperre deaktiv bei schreibgeschütztem Feld kstelle. siehe Examplestabelle (immer deaktiv)
	# Bedingung kstellesperredeaktiviert gilt ausschließlich für das Kopffeld kstelle
	# und nicht für andere Kostenobjektfelder! 
    Then field "kstellesperredeaktiviert" has value "nein"

	# meldung muss sich auf kostenverteiler beziehen!
	# nr 3602!
    Then saving the current editor throws the exception "3602"
    And I close the current editor

	Given I open an editor "Kstelle1-wieder-entsperren" from table "(Account):(CostCenter)" with command "UPDATE" for record "211"
	And I set field "sperrkonfigurationneu" to ""
	And I save the current editor

	Given I open an editor "Kostenstelle-absichern" from table "(Account):(CostCenter)" with command "VIEW" for record "211"
    Then field "sperrkonfigurationneu" has value ""
	And I close the current editor





Scenario Outline: 02 Pruefen Sperrbed.felder mit Haupterfassungsfeldern
# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung1" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RM001"

    # ist-zustand der rückmeldung
    Then field "typa279" has value "<typ>"
    Then the table has 1 rows
    Then field "artikel" has value "BG1" in row 1
    Then field "mge" has value "10" in row 1

    # input:
    And I set field "sofort" to "<sofort>"

    And I set field "bzeit" to "<bzeit>"
    And I set field "bsatz" to "<bsatz>"

    And I set field "mzeit" to "<mzeit>"
    And I set field "fixkost" to "<fixkost>"
    And I set field "varkost" to "<varkost>"

    And I set field "gutmge" to "<gutmge>" in row 1
    And I set field "verlustmge" to "<verlustmge>" in row 1

    # ergebnisse der sperrbedingungen:  siehe Examplestabelle
    # Bedingung kontensperredeaktiviert gilt auch für alle Kostenobjektfelder der Fertigungsleistung (Zeiten)
    Then field "kontensperredeaktiviert" has value "<kontensperredeakt>"

    # Kostenstellensperre deaktiv bei schreibgeschütztem Feld kstelle. siehe Examplestabelle (immer deaktiv)
	Then field "kstelle" is not modifiable
	# Bedingung kstellesperredeaktiviert gilt ausschließlich für das Kopffeld kstelle
	# und nicht für andere Kostenobjektfelder! 
    Then field "kstellesperredeaktiviert" has value "<kstsperredeakt>"

    And I close the current editor

    Examples:
    |idx|sofort|bzeit|bsatz|mzeit|fixkost|varkost|gutmge|verlustmge|kontensperredeakt|kstsperredeakt|typ        |
    | 0 | nein |  0  |  0  |  0  |   0   |   0   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    |   | nein |  0  |  0  |  0  |   0   |   0   |   5  |    5     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  0  |  0  |  0  |   0   |   0   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  0  |  0  |  0  |   0   |   0   |   5  |    0     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  0  |  0  |  0  |   0   |   0   |   5  |    5     |      ja         |      ja      |Rückmeldung|
    | 5 |  ja  |  0  |  0  |  0  |   0   |   0   |   0  |   10     |      ja         |      ja      |Rückmeldung|
    |   | nein |  1  |  0  |  0  |   0   |   0   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    |   | nein |  1  |  0  |  0  |   0   |   0   |   5  |    5     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  1  |  0  |  0  |   0   |   0   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  1  |  0  |  0  |   0   |   0   |   5  |    0     |      ja         |      ja      |Rückmeldung|
    | 10|  ja  |  1  |  0  |  0  |   0   |   0   |   5  |    5     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  1  |  0  |  0  |   0   |   0   |   0  |   10     |      ja         |      ja      |Rückmeldung|
    |   | nein |  0  |  3  |  0  |   0   |   0   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    |   | nein |  0  |  3  |  0  |   0   |   0   |   5  |    5     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  0  |  3  |  0  |   0   |   0   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    | 15|  ja  |  0  |  3  |  0  |   0   |   0   |   5  |    0     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  0  |  3  |  0  |   0   |   0   |   5  |    5     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  0  |  3  |  0  |   0   |   0   |   0  |   10     |      ja         |      ja      |Rückmeldung|
    |   | nein |  1  |  3  |  0  |   0   |   0   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    |   | nein |  1  |  3  |  0  |   0   |   0   |   5  |    5     |      ja         |      ja      |Rückmeldung|
    | 20|  ja  |  1  |  3  |  0  |   0   |   0   |   0  |    0     |     nein        |      ja      |Rückmeldung|
    |   |  ja  |  1  |  3  |  0  |   0   |   0   |   5  |    0     |     nein        |      ja      |Rückmeldung|
    |   |  ja  |  1  |  3  |  0  |   0   |   0   |   5  |    5     |     nein        |      ja      |Rückmeldung|
    |   |  ja  |  1  |  3  |  0  |   0   |   0   |   0  |   10     |     nein        |      ja      |Rückmeldung|
    
    Examples:
    |idx|sofort|bzeit|bsatz|mzeit|fixkost|varkost|gutmge|verlustmge|kontensperredeakt|kstsperredeakt|typ        |
    | 0 | nein |  0  |  0  |  2  |   0   |   0   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    |   | nein |  0  |  0  |  2  |   0   |   0   |   5  |    5     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  0  |  0  |  2  |   0   |   0   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  0  |  0  |  2  |   0   |   0   |   5  |    0     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  0  |  0  |  2  |   0   |   0   |   5  |    5     |      ja         |      ja      |Rückmeldung|
    | 5 |  ja  |  0  |  0  |  2  |   0   |   0   |   0  |   10     |      ja         |      ja      |Rückmeldung|
    |   | nein |  0  |  0  |  0  |   4   |   0   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    |   | nein |  0  |  0  |  0  |   4   |   0   |   5  |    5     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  0  |  0  |  0  |   4   |   0   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  0  |  0  |  0  |   4   |   0   |   5  |    0     |      ja         |      ja      |Rückmeldung|
    | 10|  ja  |  0  |  0  |  0  |   4   |   0   |   5  |    5     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  0  |  0  |  0  |   4   |   0   |   0  |   10     |      ja         |      ja      |Rückmeldung|
    |   | nein |  0  |  0  |  2  |   4   |   0   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    |   | nein |  0  |  0  |  2  |   4   |   0   |   5  |    5     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  0  |  0  |  2  |   4   |   0   |   0  |    0     |     nein        |      ja      |Rückmeldung|
    | 15|  ja  |  0  |  0  |  2  |   4   |   0   |   5  |    0     |     nein        |      ja      |Rückmeldung|
    |   |  ja  |  0  |  0  |  2  |   4   |   0   |   5  |    5     |     nein        |      ja      |Rückmeldung|
    |   |  ja  |  0  |  0  |  2  |   4   |   0   |   0  |   10     |     nein        |      ja      |Rückmeldung|
    
    Examples:
    |idx|sofort|bzeit|bsatz|mzeit|fixkost|varkost|gutmge|verlustmge|kontensperredeakt|kstsperredeakt|typ        |
    | 0 | nein |  0  |  0  |  0  |   0   |   5   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    |   | nein |  0  |  0  |  0  |   0   |   5   |   5  |    5     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  0  |  0  |  0  |   0   |   5   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  0  |  0  |  0  |   0   |   5   |   5  |    0     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  0  |  0  |  0  |   0   |   5   |   5  |    5     |      ja         |      ja      |Rückmeldung|
    | 5 |  ja  |  0  |  0  |  0  |   0   |   5   |   0  |   10     |      ja         |      ja      |Rückmeldung|
    |   | nein |  0  |  0  |  2  |   0   |   5   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    |   | nein |  0  |  0  |  2  |   0   |   5   |   5  |    5     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  0  |  0  |  2  |   0   |   5   |   0  |    0     |     nein        |      ja      |Rückmeldung|
    |   |  ja  |  0  |  0  |  2  |   0   |   5   |   5  |    0     |     nein        |      ja      |Rückmeldung|
    | 10|  ja  |  0  |  0  |  2  |   0   |   5   |   5  |    5     |     nein        |      ja      |Rückmeldung|
    |   |  ja  |  0  |  0  |  2  |   0   |   5   |   0  |   10     |     nein        |      ja      |Rückmeldung|
    |   | nein |  0  |  0  |  2  |   0   |   5   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    
    Examples:
    |idx|sofort|bzeit|bsatz|mzeit|fixkost|varkost|gutmge|verlustmge|kontensperredeakt|kstsperredeakt|typ        |
    |   | nein |  1  |  3  |  2  |   0   |   5   |   5  |    5     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  1  |  3  |  2  |   0   |   5   |   0  |    0     |     nein        |      ja      |Rückmeldung|
    |   |  ja  |  1  |  3  |  2  |   0   |   5   |   5  |    0     |     nein        |      ja      |Rückmeldung|
    |   |  ja  |  1  |  3  |  2  |   0   |   5   |   5  |    5     |     nein        |      ja      |Rückmeldung|
    |  4|  ja  |  1  |  3  |  2  |   0   |   5   |   0  |   10     |     nein        |      ja      |Rückmeldung|

    Examples:
    # über kreuz existieren zeiten und stundensätze, aber ohne effektive arbeits- oder maschinenkosten und
    #  auch keine Materialmenge/kosten. dann müssen beide sperren deaktiviert werden.  
    |idx|sofort|bzeit|bsatz|mzeit|fixkost|varkost|gutmge|verlustmge|kontensperredeakt|kstsperredeakt|typ        |
    |   | nein |  1  |  0  |  0  |   7   |   0   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    |   | nein |  0  |  4  |  2  |   0   |   0   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  1  |  0  |  0  |   7   |   0   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  1  |  0  |  0  |   0   |   5   |   0  |    0     |      ja         |      ja      |Rückmeldung|
    |   |  ja  |  0  |  4  |  2  |   0   |   0   |   0  |    0     |      ja         |      ja      |Rückmeldung|


Scenario Outline: 03 Pruefen Sperrbed.felder mit Zusatzerfassungsfeldern bzeitX
# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung2" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RM001"
    # ist-zustand der rückmeldung
    Then field "typa279" has value "<typ>"
    Then the table has 1 rows
    Then field "artikel" has value "BG1" in row 1
    Then field "mge" has value "10" in row 1

    # input:
    And I set field "sofort" to "<sofort>"
    And I set field "bzeit2" to "<bzeit2>"
    And I set field "bsatz2" to "<bsatz2>"
    And I set field "bzeit3" to "<bzeit3>"
    And I set field "bsatz3" to "<bsatz3>"
    And I set field "bzeit4" to "<bzeit4>"
    And I set field "bsatz4" to "<bsatz4>"
    And I set field "bzeit5" to "<bzeit5>"
    And I set field "bsatz5" to "<bsatz5>"

    # ergebnisse der sperrbedingungen:  siehe Examplestabelle
    # Bedingung kontensperredeaktiviert gilt auch für alle Kostenobjektfelder der Fertigungsleistung (Zeiten)
    Then field "kontensperredeaktiviert" has value "<kontensperredeakt>"
    
    # Kostenstellensperre deaktiv bei schreibgeschütztem Feld kstelle. siehe Examplestabelle (immer deaktiv)
	Then field "kstelle" is not modifiable
	# Bedingung kstellesperredeaktiviert gilt ausschließlich für das Kopffeld kstelle
	# und nicht für andere Kostenobjektfelder! 
    Then field "kstellesperredeaktiviert" has value "<kstsperredeakt>"
    And I close the current editor

    Examples:
    |idx|sofort|bzeit2|bsatz2|bzeit3|bsatz3|bzeit4|bsatz4|bzeit5|bsatz5|kontensperredeakt|kstsperredeakt|typ        |
    |   |  ja  |   0  |   0  |   0  |   0  |   0  |   0  |   0  |   0  |      ja         |      ja      |Rückmeldung|
    |   |  ja  |   1  |   0  |   0  |   0  |   0  |   0  |   0  |   0  |      ja         |      ja      |Rückmeldung|
    |   |  ja  |   0  |   2  |   0  |   0  |   0  |   0  |   0  |   0  |      ja         |      ja      |Rückmeldung|
    |   |  ja  |   1  |   2  |   0  |   0  |   0  |   0  |   0  |   0  |     nein        |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   1  |   0  |   0  |   0  |   0  |   0  |      ja         |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   0  |   3  |   0  |   0  |   0  |   0  |      ja         |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   1  |   3  |   0  |   0  |   0  |   0  |     nein        |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   0  |   0  |   1  |   0  |   0  |   0  |      ja         |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   0  |   0  |   0  |   4  |   0  |   0  |      ja         |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   0  |   0  |   1  |   4  |   0  |   0  |     nein        |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   0  |   0  |   0  |   0  |   1  |   0  |      ja         |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   0  |   0  |   0  |   0  |   0  |   5  |      ja         |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   0  |   0  |   0  |   0  |   1  |   5  |     nein        |      ja      |Rückmeldung|
    |   |  ja  |   1  |   2  |   1  |   3  |   1  |   4  |   1  |   5  |     nein        |      ja      |Rückmeldung|

    |   | nein |   1  |   2  |   0  |   0  |   0  |   0  |   0  |   0  |       ja        |      ja      |Rückmeldung|
    |   | nein |   1  |   2  |   1  |   3  |   1  |   4  |   1  |   5  |       ja        |      ja      |Rückmeldung|


Scenario Outline: 04 Pruefen Sperrbed.felder mit Zusatzerfassungsfeldern mzeitX
# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung3" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RM001"
    # ist-zustand der rückmeldung
    Then field "typa279" has value "<typ>"
    Then the table has 1 rows
    Then field "artikel" has value "BG1" in row 1
    Then field "mge" has value "10" in row 1
    
    # input:
    And I set field "sofort" to "<sofort>"
    And I set field "mzeit2" to "<mzeit2>"
    And I set field "mzeit3" to "<mzeit3>"
    And I set field "mzeit4" to "<mzeit4>"
    And I set field "mzeit5" to "<mzeit5>"
    And I set field "fixkost" to "<fixkost>"
    And I set field "varkost" to "<varkost>"
    
    # And I set field "gutmge" to "<gutmge>" in row 1
    # ergebnisse der sperrbedingungen:  siehe Examplestabelle
    # Bedingung kontensperredeaktiviert gilt auch für alle Kostenobjektfelder der Fertigungsleistung (Zeiten)
    Then field "kontensperredeaktiviert" has value "<kontensperredeakt>"
    
    # Kostenstellensperre deaktiv bei schreibgeschütztem Feld kstelle. siehe Examplestabelle (immer deaktiv)
	Then field "kstelle" is not modifiable
	# Bedingung kstellesperredeaktiviert gilt ausschließlich für das Kopffeld kstelle
	# und nicht für andere Kostenobjektfelder! 
    Then field "kstellesperredeaktiviert" has value "<kstsperredeakt>"
    And I close the current editor

    Examples:
    |idx|sofort|mzeit2|mzeit3|mzeit4|mzeit5|fixkost|varkost|kontensperredeakt|kstsperredeakt|typ        |
    |   |  ja  |   0  |   0  |   0  |  0   |   0   |   0   |      ja         |      ja      |Rückmeldung|
    |   |  ja  |   2  |   0  |   0  |  0   |   0   |   0   |      ja         |      ja      |Rückmeldung|
    |   |  ja  |   2  |   0  |   0  |  0   |   7   |   0   |     nein        |      ja      |Rückmeldung|
    |   |  ja  |   2  |   0  |   0  |  0   |   0   |   8   |     nein        |      ja      |Rückmeldung|
    |   |  ja  |   2  |   0  |   0  |  0   |   7   |   8   |     nein        |      ja      |Rückmeldung|
    |   |  ja  |   0  |   3  |   0  |  0   |   0   |   0   |      ja         |      ja      |Rückmeldung|
    |   |  ja  |   0  |   3  |   0  |  0   |   7   |   0   |     nein        |      ja      |Rückmeldung|
    |   |  ja  |   0  |   3  |   0  |  0   |   0   |   8   |     nein        |      ja      |Rückmeldung|
    |   |  ja  |   0  |   3  |   0  |  0   |   7   |   8   |     nein        |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   4  |  0   |   0   |   0   |      ja         |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   4  |  0   |   7   |   0   |     nein        |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   4  |  0   |   0   |   8   |     nein        |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   4  |  0   |   7   |   8   |     nein        |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   0  |  5   |   0   |   0   |      ja         |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   0  |  5   |   7   |   0   |     nein        |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   0  |  5   |   0   |   8   |     nein        |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   0  |  5   |   7   |   8   |     nein        |      ja      |Rückmeldung|

    |   |  ja  |   0  |   0  |   0  |  0   |   7   |   0   |      ja         |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   0  |  0   |   0   |   8   |      ja         |      ja      |Rückmeldung|
    |   |  ja  |   0  |   0  |   0  |  0   |   7   |   8   |      ja         |      ja      |Rückmeldung|

	# sofort == nein ist entscheidend!
    |   | nein |   2  |   3  |   4  |  5   |   7   |   8   |      ja         |      ja      |Rückmeldung|



Scenario Outline: 05 rm neu ohne fv Pruefen Sperrbed.felder mit Zusatzerfassungsfeldern mzeitX 
# Rückmeldung auf ersten Arbeitsgang
    Given I open an editor "Rückmeldung4" from table "(Workorder):(CompletionConfirmations)" with command "NEW" for record ""
    # ist-zustand der rückmeldung
    Then field "typa279" has value "<typ>"
	Then field "kstelle" is modifiable
	
	# sofort==ja ist bedingung für aktive kostenstellensperre: ist bei <neu> generell erfüllt 
	Then field "sofort" is not modifiable
    Then field "sofort" has value "ja"

    Then the table has 0 rows
    And I set field "artikel" to "BG1"

    # input:
    And I set field "mzeit2" to "<mzeit2>"
    And I set field "mzeit3" to "<mzeit3>"
    And I set field "mzeit4" to "<mzeit4>"
    And I set field "mzeit5" to "<mzeit5>"
    And I set field "fixkost" to "<fixkost>"
    And I set field "varkost" to "<varkost>"

    # Fertigartikelzeile / Zugangszeile
    And I create a new row at the end of the table    
    And I set field "artikel" to "BG1" in row !lastRow
    And I set field "gutmge" to "<gutmge>" in row !lastRow
    And I set field "verlustmge" to "<verlustmge>" in row !lastRow

    # Entnahmezeile
    And I create a new row at the end of the table    
    And I set field "artikel" to "E1" in row !lastRow
    And I set field "mge" to "<mge>" in row !lastRow
    
    # ergebnisse der sperrbedingungen:  siehe Examplestabelle
    # Bedingung kontensperredeaktiviert gilt auch für alle Kostenobjektfelder der Fertigungsleistung (Zeiten)
    Then field "kontensperredeaktiviert" has value "<kontensperredeakt>"
    
    # Kostenstellensperre deaktiv bei schreibgeschütztem Feld kstelle. siehe Examplestabelle (immer deaktiv)
	# Bedingung kstellesperredeaktiviert gilt ausschließlich für das Kopffeld kstelle
	# und nicht für andere Kostenobjektfelder! 
    Then field "kstellesperredeaktiviert" has value "<kstsperredeakt>"
    And I close the current editor

    Examples:
    |idx|mzeit2|mzeit3|mzeit4|mzeit5|fixkost|varkost|mge|gutmge|verlustmge|kontensperredeakt|kstsperredeakt|typ        |
    |   |   0  |   0  |   0  |  0   |   0   |   0   | 0 |  0   |  0       |     ja         |      ja      |Rückmeldung ohne Fertigungsvorschlag|
    |   |   2  |   0  |   0  |  0   |   0   |   0   | 0 |  0   |  0       |     ja         |      ja      |Rückmeldung ohne Fertigungsvorschlag|
    |   |   2  |   0  |   0  |  0   |   7   |   0   | 0 |  0   |  0       |    nein        |     nein     |Rückmeldung ohne Fertigungsvorschlag|
    |   |   2  |   0  |   0  |  0   |   0   |   8   | 0 |  0   |  0       |    nein        |     nein     |Rückmeldung ohne Fertigungsvorschlag|
    |   |   2  |   0  |   0  |  0   |   7   |   8   | 0 |  0   |  0       |    nein        |     nein     |Rückmeldung ohne Fertigungsvorschlag|

	# entnahme-mge allein reicht aus für die kostentellensperre 
    |   |   0  |   0  |   0  |  0   |   0   |   0   | 9 |  0   |  0       |     ja         |     nein     |Rückmeldung ohne Fertigungsvorschlag|

    # gutmge ist in <RM> <neu> komplett irrelevant, für die Sperren (kostentellensperre), weil diese Menge hier niemals gebucht wird
    # man kann sie nur erfassen und es passiert einfach nichts  
    |   |   0  |   0  |   0  |  0   |   0   |   0   | 0 | 10   |  0       |     ja         |      ja      |Rückmeldung ohne Fertigungsvorschlag|

    # verlustmge ist in <RM> <neu> komplett irrelevant, für die Sperren (kostentellensperre), weil diese Menge hier niemals gebucht wird
    # man kann sie nur erfassen und es passiert einfach nichts  
    |   |   0  |   0  |   0  |  0   |   0   |   0   | 0 |  0   |  11      |     ja         |      ja      |Rückmeldung ohne Fertigungsvorschlag|

    

Scenario: 06 Sperre beim Übertragen und im Editor prüfen und am ende RM001 übertragen
    Given I open an editor "Rückmeldung5" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RM001"

    # ist-zustand der rückmeldung
    Then field "typa279" has value "Rückmeldung"
    Then the table has 1 rows
    Then field "artikel" has value "BG1" in row 1
    Then field "mge" has value "10" in row 1

	Then field "sofort" is modifiable
    # input:
	And I set field "sofort" to "nein"

    And I set field "bzeit" to "1"
    And I set field "bsatz" to "20"
    # BEACHTE!!! Erfassung nach zeit (u. satz) weil das Feld sonst überschrieben wird!
    And I set field "lohnkostsoll" to "99800"

    # ergebnisse der sperrbedingungen:  siehe Examplestabelle
    # Bedingung kontensperredeaktiviert gilt auch für alle Kostenobjektfelder der Fertigungsleistung (Zeiten)
    Then field "kontensperredeaktiviert" has value "ja"

	# Bedingung kstellesperredeaktiviert gilt ausschließlich für das Kopffeld kstelle
	# und nicht für andere Kostenobjektfelder! 
    Then field "kstellesperredeaktiviert" has value "ja"
    And I save the current editor


	Given I open an editor "Konto-sperren" from table "(Account):(Account)" with command "UPDATE" for record "99800"
	And I set field "sperrkonfigurationneu" to "Standard-Kontosperre"
	And I save the current editor

    Given I open an editor "RM_uebertragen" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for record "RM001"
    # And I save the current editor
    Then saving the current editor throws the exception "4806"
    And I close the current editor


	# -------- Und die Kontensperre noch im Editor prüfen ---------- 
    Given I open an editor "Rückmeldung6" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "RM001"
    # ist-zustand der rückmeldung
    Then field "typa279" has value "Rückmeldung"
    Then the table has 1 rows
    Then field "artikel" has value "BG1" in row 1
    Then field "mge" has value "10" in row 1

	Then field "sofort" is modifiable
    # input:
	And I set field "sofort" to "ja"

    # ergebnisse der sperrbedingungen:  siehe Examplestabelle
    Then field "kontensperredeaktiviert" has value "nein"
    Then field "kstellesperredeaktiviert" has value "ja"
    
    Then saving the current editor throws the exception "4806"
    And I close the current editor


	Given I open an editor "Konto-entsperren" from table "(Account):(Account)" with command "UPDATE" for record "99800"
	And I set field "sperrkonfigurationneu" to ""
	And I save the current editor

	
	Given I open an editor "Kostenstelle sperren" from table "(Account):(CostCenter)" with command "UPDATE" for record "211"
	And I set field "sperrkonfigurationneu" to "Standard-Kostenstellensperre"
	And I save the current editor

	Given I open an editor "Konto-sperre-absichern" from table "(Account):(Account)" with command "VIEW" for record "99800"
    Then field "sperrkonfigurationneu" has value ""
	And I close the current editor

	
	Given I open an editor "RM_uebertragen" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for record "RM001"
    Then saving the current editor throws the exception "4806"
    And I close the current editor

    
    Given I open an editor "Rückmeldung7" from table "(Workorder):(CompletionConfirmations)" with command "UPDATE" for record "RM001"
    # ist-zustand der rückmeldung
    Then field "typa279" has value "Rückmeldung"
    Then field "artikel" has value "BG1" in row 1
    Then field "mge" has value "10" in row 1

	Then field "sofort" is modifiable
    # input:
	And I set field "sofort" to "nein"

	# fertigungsleistung ausnullen, damit materialmengen gegen sperre geprüft werden können
	And I set field "bzeit" to "0"

    Then the table has 1 rows
	And I set field "gutmge" to "2" in row 1

    # ergebnisse der sperrbedingungen:  siehe Examplestabelle
    # Bedingung kontensperredeaktiviert gilt auch für alle Kostenobjektfelder der Fertigungsleistung (Zeiten)
    Then field "kontensperredeaktiviert" has value "ja"

	# Bedingung kstellesperredeaktiviert gilt ausschließlich für das Kopffeld kstelle
	# und nicht für andere Kostenobjektfelder! 
    Then field "kstellesperredeaktiviert" has value "ja"
    And I save the current editor


	Given I open an editor "Kostenstelle-absichern" from table "(Account):(CostCenter)" with command "VIEW" for record "211"
    Then field "sperrkonfigurationneu" has value "Standard-Kostenstellensperre"
	And I close the current editor

    # RM wird trotz zwischenzeitlich gesperrter kostenstelle 211 übertragen. ist so gewollt
    Given I open an editor "RM_uebertragen" from table "(Workorder):(WorkOrders)" with command "TRANSFER" for record "RM001"
    And I save the current editor

    # RM wird trotz gesperrter kostenstelle 211 storniert. ist so gewollt
    Given I open an editor "RM_stornieren" from table "(Workorder):(CompletionConfirmations)" with command "REVERSAL" for record "+RM001"
    And I save the current editor


Scenario: 07 Sperre beim Rückmelden, im Editor prüfen 
    Given I open an editor "Rückmeldung8" from table "(Workorder):(WorkOrders)" with command "DONE" for record "RM002"

    # ist-zustand der rückmeldung
    Then field "typa279" has value "Rückmeldung"
    Then the table has 1 rows
    Then field "artikel" has value "BG1" in row 1
    Then field "mge" has value "10" in row 1

	Then field "sofort" is modifiable
    # input:
	And I set field "sofort" to "nein"

    And I set field "mzeit" to "1"
    And I set field "fixkost" to "44"

    # ergebnisse der sperrbedingungen: siehe Examplestabelle
    Then field "kontensperredeaktiviert" has value "ja"
    Then field "kstellesperredeaktiviert" has value "ja"

	And I set field "sofort" to "ja"
    # Bedingung kontensperredeaktiviert gilt auch für alle Kostenobjektfelder der Fertigungsleistung (Zeiten)
    Then field "kontensperredeaktiviert" has value "nein"

	# Bedingung kstellesperredeaktiviert gilt ausschließlich für das Kopffeld kstelle
	# und nicht für andere Kostenobjektfelder! 
    Then field "kstellesperredeaktiviert" has value "ja"

    Then saving the current editor throws the exception "4806"
	And I close the current editor
