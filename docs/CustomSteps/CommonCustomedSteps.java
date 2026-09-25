package de.abas.erp.cucumber.common;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Assert;

import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import de.abas.acceptanceTests.stepDefs.GeneralERPStepDefs;
import de.abas.acceptanceTests.support.AssertionHelper;
import de.abas.acceptanceTests.support.ERPTestContext;
import de.abas.acceptanceTests.support.EditorHandler;
import de.abas.ceks.jedp.CantReadFieldPropertyException;
import de.abas.ceks.jedp.CantReadSettingException;
import de.abas.ceks.jedp.EDPEditField;
import de.abas.ceks.jedp.EDPEditFieldList;
import de.abas.ceks.jedp.EDPEditor;
import de.abas.ceks.jedp.EDPException;
import de.abas.ceks.jedp.EDPLockBehavior;
import de.abas.ceks.jedp.EDPQuery;
import de.abas.ceks.jedp.EDPSession;

public class CommonCustomedSteps {

	private static final String NUMMERISCH = "(nummerisch)";
	private ERPTestContext context;
	private static String value;
	private GeneralERPStepDefs mysteps;
	private List<Map<String, String>> rowList;

	public CommonCustomedSteps(ERPTestContext context, EditorHandler handler, AssertionHelper helper) {
		this.context = context;
		mysteps = new GeneralERPStepDefs(context, handler, helper);
		// myqueries = new QueryStepDefs(context, helper);
	}

	/**
	 * Der Step "I enable debugging" ist ein Dummy Step, der hilft vom
	 * Cucumber-Skript in den C-Kern zu debuggen: Man kann ihn an beliebieger
	 * Stelle in der Feature Datei einbauen und dann auf ihm einen Breakpoint
	 * setzen. Fuehrt man anschliessend das Skript im Debug Modus aus, so haelt
	 * Java an diesem Breakpoint an Nun kann man ueber ein Terminalfenster den
	 * epi-Prozess ermitteln und sich an den Prozess anhaengen: ps aux | grep
	 * BENUTERKUERZEL | grep epi gdb epi 5445
	 * <p>
	 * CUCU-96
	 */
	@Given("^I enable debugging$")
	public void i_enable_debugging() throws Throwable {
		System.out.println("DEBUG ON");
	}

	@Then("opening an editor from table {string} with command {string} for record {string} throws the locked object exception {string}")
	public void opening_an_editor_from_table_with_command_for_record_throws_the_locked_object_exception(
			String tableName, String command, String recordIdno, String exceptionNr) throws CantReadSettingException {
		EDPSession session = this.context.currentSession;
		EDPLockBehavior oldLockBehavior = session.getLockBehavior();
		session.setLockBehavior(EDPLockBehavior.LOCKBEHAVIOR_NOWAIT);
		try {
			mysteps.i_open_an_editor_from_table_with_command_for_record_throws_exception(tableName, command, recordIdno,
					exceptionNr);
		} catch (Throwable e) {
			Assert.fail("Object appears not to be locked, but there are other exceptions from core: " + e.getMessage());
		}
		session.setLockBehavior(oldLockBehavior);
	}

	/**
	 * Zum Debuggen eines in runCucumberTest.sh, also im testbett gestarteten
	 * epi-Prozesses fügst Du dieses Kommando an der gewünschten Stelle, ein.
	 * z.B. unmittelbar nach dem open editor Kommando in das cucu-skript
	 * (feature-datei) ein. Sobald Du den Breakpoint im Debugger gesetzt hast,
	 * musst du die Datei "cucudbg" im Testverzeichnis erzeugen. einfach mit:
	 * touch cucudbg dann wird die schleife verlassen. cucudbg wird auch gleich
	 * wieder von diesem Kommando gelöscht.
	 * 
	 * Einschränkung: Cucu-Einzeiler, wie das Kommando Revalution, können
	 * damit (vermutlich) nicht gestoppt werden, weil es dafür nur eine einzige
	 * Kommandozeile gibt. Für solche Fälle müsste ein anderes Steuerkommando
	 * programiert werden oder solche schritte müssen manuell ausgeführt
	 * werden.
	 */
	@And("^I wait for file cucudbg for debugging$")
	public void i_wait_for_debugging() throws Throwable {
		System.out.println("Waiting for file cucudbg to continue program.");

		File f = new File("cucudbg");
		while (!f.exists()) {
			Thread.sleep(1000);
		}
		// gleich die nächste debug-runde vorbereiten
		if (f.exists())
			f.delete();
	}

	/**
	 * Step: And I save value from field \"([^\"]*)\" in row (\\d+|!lastRow)
	 * Speichert den Wert eines Feldes im geoeffneten Editor. Haengt zusammen
	 * mit dem Step "And I set field \"([^\"]*)\" in row (\\d+|!lastRow) to
	 * saved value", der den gespeicherten Wert in ein Feld einsetzt.
	 * <p>
	 * CUCU- 39
	 */
	@And("^I save value from field \"([^\"]*)\" in row (\\d+|!lastRow)$")
	public void i_save_value_from_field(String fieldName, String row) throws Throwable {
		value = this.context.currentEditor.getFieldVal(getRowFromString(row), fieldName);
		value.trim();
	}

	/**
	 * Step: And I set field \"([^\"]*)\" in row (\\d+|!lastRow) to saved value
	 * <p>
	 * Speichert den Wert eines Feldes im geoeffneten Editor. Zuvor muss ueber
	 * den Step "And I save value from field \"([^\"]*)\" in row
	 * (\\d+|!lastRow)" (CUCU-39) der Feldwert gespeichert worden sein.
	 * <p>
	 * CUCU- 40
	 */
	@And("^I set field \"([^\"]*)\" in row (\\d+|!lastRow) to saved value$")
	public void i_set_field_to_saved_value(String fieldName, String row) throws Throwable {
		this.context.currentEditor.setFieldVal(getRowFromString(row), fieldName, value);
	}

	/**
	 * Step: Then field \"([^\"]*)\" in row (\\d+|!lastRow) equals saved value
	 * <p>
	 * Prueft, ob der Wert des angegebenen Feldes in der Zeile "row" mit einem
	 * zuvor gespeicherten Wert uebereinstimmt Setzt vorherigen Aufruf des
	 * Steps: "And I save value from field \"([^\"]*)\" in row (d+|!lastRow)"
	 * voraus
	 * <p>
	 * CUCU-42
	 */
	@Then("^field \"([^\"]*)\" in row (\\d+|!lastRow) equals saved value$")
	public void field_in_row_equals_saved_value(String fieldName, String row) throws Throwable {
		if (value.isEmpty()) {
			throw new AssertionError(
					"Saved value is empty. Can not compare to field '" + fieldName + " in row '" + row);
		} else {
			mysteps.field_has_value_in_row(fieldName, value, row);
		}
	}

	/**
	 * Step: Then setting field \"([^\"]*)\" in row (\\d+|!lastRow) to saved
	 * value throws the exception \"([^\"]*)\"
	 * <p>
	 * Prueft ob eine Exception geworfen wird, wenn das angegebene Feld in der
	 * entsprechenden Zeile auf den zuvor gespeicherten Wert gesetzt wird. Setzt
	 * vorherigen Aufruf des Steps: "And I save value from field \"([^\"]*)\" in
	 * row (d+|!lastRow)" vorraus
	 * <p>
	 * CUCU-64
	 */
	@Then("^setting field \"([^\"]*)\" in row (\\d+|!lastRow) to saved value throws the exception \"([^\"]*)\"$")
	public void setting_field_to_saved_value_throws_exception(String fieldName, String row, String exceptionId)
			throws Throwable {
		if (value.isEmpty()) {
			throw new AssertionError("Saved value is empty. Can not set field '" + fieldName + " in row '" + row);
		} else {
			mysteps.setting_field_to_in_row_throws_the_exception(fieldName, value, row, exceptionId);
		}
	}

	/**
	 * Step: "(<Database>):(<Database-Group>)" with the editor id "<EditorID>"
	 * is not filed
	 *
	 * Prueft, ob das Objekt NICHT abgelegt ist, bzw. ob das Ablageflag
	 * (itablage) gesetzt ist.
	 *
	 * @param db_group
	 *            Datenbank und Datenbankgruppe mit den AJO Namen
	 * @param editorid
	 *            Objekt wird identifiziert ueber Editor ID
	 *
	 *            CUCU-101
	 */
	@Then("^\"([^\"]*)\" with the editor id \"([^\"]*)\" is filed$")
	public void with_the_editor_id_is_filed(String db_group, String editorid) throws Throwable {
		with_the_editor_id_is_filed_intern(db_group, editorid, true);
	}

	/**
	 * Step: "(<Database>):(<Database-Group>)" with the editor id "<EditorID>"
	 * is filed
	 *
	 * Prueft, ob das Objekt abgelegt ist, bzw. ob das Ablageflag (itablage)
	 * gesetzt ist.
	 *
	 * @param db_group
	 *            Datenbank und Datenbankgruppe mit den AJO Namen
	 * @param editorid
	 *            Objekt wird identifiziert ueber Editor ID
	 *
	 *            CUCU-102
	 */
	@Then("^\"([^\"]*)\" with the editor id \"([^\"]*)\" is not filed$")
	public void with_the_editor_id_is_not_filed(String db_group, String editorid) throws Throwable {
		with_the_editor_id_is_filed_intern(db_group, editorid, false);
	}

	/**
	 * Prueft, ob ein DB-Objekt abgelegt, bzw. nicht abgelegt ist durch Pruefung
	 * des Ablageflags (itablage). Pruefung laesst sich auf viele Objekte
	 * anwenden, z.B: EK/VK Objekte, Teile usw.
	 *
	 * @param db_group
	 *            Datenbank und Datenbankgruppe mit den AJO Namen
	 * @param editorid
	 *            Objekt wird identifiziert ueber Editor ID
	 * @param check_is_filed
	 *            True = Es wird geprueft, ob Ablageflag gesetzt ist (Objekt ist
	 *            abgelegt) False = Es wird geprueft, ob ablagefleg noch nicht
	 *            gesetzt ist (Objekt ist lebendig)
	 */
	private void with_the_editor_id_is_filed_intern(String db_group, String editorid, boolean check_is_filed)
			throws Throwable {
		mysteps.setUp(context.currentScenario);
		mysteps.i_open_an_editor_from_table_with_command_for_record_from_editor("step_checkfiled", db_group, "VIEW",
				editorid);
		try {
			if (check_is_filed) {
				mysteps.field_has_value("ablagef", "ja");
			} else {
				mysteps.field_has_value("ablagef", "nein");
			}
		} catch (AssertionError e) {
			EDPEditor editor = context.getCurrentEditor();
			String editRef = editor.getEditRef();
			if (check_is_filed) {
				Assert.fail("Database-object '" + db_group + "' " + editRef
						+ " expected:<filed> but was: <is not filed>" + e.getMessage());
			} else {
				Assert.fail("Database-object '" + db_group + "' " + editRef
						+ " expected:<is not filed> but was: <filed>" + e.getMessage());
			}
		}
		mysteps.I_close_the_editor();
	}

	/**
	 * Hilfsfunktion zum Bestimmen der Zeilennummer
	 *
	 * @param row
	 *            Angabe der Zeilennummer oder !lastRow oder eine andere
	 *            interpretierbare Zeilenangabe
	 */
	private int getRowFromString(String row) {
		if (row.equals("!lastRow")) {
			return this.context.currentEditor.getRowCount();
		}

		if (row.equals("")) {
			return 0;
		}

		return Integer.parseInt(row);
	}

	/**
	 * Step: field "" contains value "" in row ""
	 *
	 * Prueft, ob ein Teil der Zeichenkette uebereinstimmt mt dem Feldwert (mit
	 * Zeilenangabe) Es muss also nicht der komplette Feldinhalt
	 * uebereinstimmen, sondern nur ein Teil.
	 *
	 * @param strFieldName
	 *            Feldname
	 * @param strValue
	 *            Wert, der in der Zeichenkette enthalten sein soll
	 * @param strRow
	 *            Zeilennummer, in dem das Feld steht
	 *
	 *            CUCU-104
	 *
	 */
	@Then("^field \"([^\"]*)\" contains value \"([^\"]*)\" in row (\\d+|!lastRow)")
	public void field_contains_value_in_row(String strFieldName, String strValue, String strRow) throws Throwable {
		EDPEditor editor = context.currentEditor;
		String strFieldValue = editor.getFieldVal(getRowFromString(strRow), strFieldName);
		if (!strFieldValue.contains(strValue)) {
			String strErr = "'" + strFieldValue + "' does not contain '" + strValue + "' in field " + strFieldName;
			if (strRow != "0") {
				strErr += " in row " + strRow;
			}
			Assert.fail(strErr);
		}
	}

	/**
	 * Step: field "" contains value ""
	 *
	 * Prueft, ob ein Teil der Zeichenkette uebereinstimmt mt dem Feldwert (mit
	 * Zeilenangabe) Es muss also nicht der komplette Feldinhalt
	 * uebereinstimmen, sondern nur ein Teil. Es werden nur die Kopffelder
	 * geprueft
	 *
	 * @param strFieldName
	 *            Feldname
	 * @param strValue
	 *            Wert, der in der Zeichenkette enthalten sein soll
	 *
	 *            CUCU-104
	 *
	 */
	@Then("^field \"([^\"]*)\" contains value \"([^\"]*)\"$")
	public void field_contains_value(String strFieldName, String strValue) throws Throwable {
		field_contains_value_in_row(strFieldName, strValue, "0");
	}

	/**
	 * Dieser Step wartet entweder {timeUnit} Sekunden oder erhoeht das
	 * gefaelschte Datum um {timeUnit} Stunden. Notwendig fuer Fertigung, da
	 * hier die Anlage von Objekten zeitabhaengig ist. Bei gefaelschtem Datum,
	 * ist auch die Uhrzeit gefaelscht und laeuft normalerweise nicht weiter.
	 * Das verhindert, dass Objekte mit unterschiedlichen Zeitstempeln angelegt
	 * und dann auch basierend darauf gefunden werden koennen. Daher wird hier
	 * explizit um Stunden erhoeht und somit auch das Anlagedatum. Wenn es kein
	 * gefaelschtes Datum gibt, wird stattdessen {timeUnit} Sekunden gewartet.
	 * Da die Anlage der Objekte nur Sekunden-genau arbeitet, ist dies notwendig
	 * um in einer spaeteren Suche nach diesen Objekten einen Unterschied
	 * feststellen zu koennen und das richtige rauszusuchen.
	 *
	 * CUCU-97
	 *
	 * @param timeUnit
	 * @throws InterruptedException
	 */
	@Given("^I wait (\\d+) time units to move the time forward$")
	public void moveTimeForward(int timeUnit) throws InterruptedException {
		if (ERPTestContext.IGNORE_FAKE_DATE) {
			Thread.sleep(1 * 1000);
		} else {
			context.getCurrentSession(context.currentScenario).setFlag(2, true);
			context.getCurrentSession(context.currentScenario).setFlag(459, true);
			context.getCurrentSession(context.currentScenario).setSessionOption("DATE", "+0 +" + timeUnit);
		}
	}

	/**
	 * Step: execute FOP "<FOP-Datei> and throws the exeception ""
	 *
	 * Fuehrt ein FOP aus, das eine bestimmte Ausnahme wirft, auf die geprueft
	 * werden kann
	 *
	 * @param fopCommand
	 *            FOP-Kommando
	 * @param errorMessage
	 *            Die Fehlermeldung, auf die abgeprueft wird.
	 *
	 *            CUCU-101
	 *
	 */
	@Given("^I execute FOP \"([^\"]*)\" and throws the exception \\\"([^\\\"]*)\\\"$")
	public void i_execute_EFOP_and_throws_exception(String fopCommand, String errorMessage) throws Throwable {
		mysteps.setUp(context.currentScenario);
		try {
			mysteps.i_execute_EFOP(fopCommand);
			if (errorMessage != null && !errorMessage.isEmpty()) {
				StringBuilder msg = new StringBuilder("No exception thrown, but exception expected:\n'")
						.append(errorMessage).append("'\n");
				Assert.fail(msg.toString());
			}
		} catch (EDPException e) {
			checkEFOPException(errorMessage, e);
		}
	}

	/**
	 * Fuehrt ein beliebiges Shell Kommando im Testverzeichnis aus, z.B. ls -l >
	 * dir.txt oder Aufruf eines Shell Skripts oder eines Standalone Programms.
	 * Laesst sich das Kommando nicht ausfuehren, so scheitert der Step mit der
	 * Fehlermeldung der Konsole.
	 *
	 * @param strShellCommand
	 *            Das Shell Kommando z.B. cat err.out > my_ref.ref
	 * @param strDirectory
	 *            Verzeichnis, in dem die geforderte Anwendung zu finden ist.
	 *            Meist /sh/bin/
	 */
	@Given("I execute shell command {string} in directory {string}")
	public void i_execute_shell_command_in_directory(String strShellCommand, String strDirectory) {
		try {
			mysteps.setUp(context.currentScenario);
			String[] cmd_orig = { strDirectory, "-c", strShellCommand };
			String[] cmd;
			if (strDirectory.isEmpty()) {
				cmd = Arrays.copyOfRange(cmd_orig, 2, cmd_orig.length);
			} else {
				cmd = Arrays.copyOfRange(cmd_orig, 0, cmd_orig.length);
			}

			String cmd_full = String.join(" ", cmd);
			String str_wd = System.getenv("EDP_CLIENT");
			System.out.print("Test-Dir : '" + str_wd + "'\n");
			System.out.print("PATH : '" + System.getenv("PATH") + "'\n");

			// Environment Variablen lesen und in String Array konvertieren
			Map<String, String> envs = System.getenv();
			String[] env = new String[envs.size()];
			int idx = 0;
			String env_var = "";
			for (Map.Entry<String, String> entry : envs.entrySet()) {
				env_var = (entry.getKey() + "=" + entry.getValue());
				System.out.print(env_var + "\n");
				env[idx] = env_var;
				idx++;
			}

			File wd = new File(str_wd);

			// Starten des Prozesses. Aktuelle Umgebungsvariablen werden
			// uebergeben
			Process proc = Runtime.getRuntime().exec(cmd, env, wd);
			proc.waitFor();
			try (BufferedReader reader = new BufferedReader(new InputStreamReader(proc.getErrorStream()))) {
				String strRet = "";
				String s = null;
				while ((s = reader.readLine()) != null) {
					strRet += s;
				}

				System.out.print("Excecuting : '" + cmd_full + "' : " + strRet + "\n");
				if (proc.exitValue() != 0) {
					Assert.fail("Failed excecuting : '" + cmd_full + "' : " + strRet);
				}
				reader.close();
			}
		} catch (IOException e) {
			Assert.fail("IOException: " + e.getMessage());

		} catch (Exception ex) {
			Assert.fail(ex.getMessage());
		}
	}

	/**
	 * Fuerht ein beliebiges Shell Kommando im Testverzeichnis aus, z.B. ls -l >
	 * dir.txt oder Aufruf eines Shell Skripts oder eines Standalone Programms.
	 * Laesst sich das Kommando nicht ausfuehren, so scheitert der Step mit der
	 * Fehlermeldung der Konsole.
	 *
	 * @param strShellCommand
	 *            Das Shell Kommando z.B. cat err.out > my_ref.ref
	 */
	@Given("I execute shell command {string}")
	public void i_execute_shell_command(String strShellCommand) {
		String strDirectory = "/bin/sh";
		i_execute_shell_command_in_directory(strShellCommand, strDirectory);
	}

	/**
	 * Hilfsfunktion, die eine EFOP Errormessage auswertet und einen sprechenden
	 * Fehlertext ausgibt
	 */
	private void checkEFOPException(String errorMessage, EDPException edpException) {
		if (errorMessage != null && !errorMessage.isEmpty()) {
			// Fehlermeldung "Der Vorgang konnte nicht oder nur unvollstaendig
			// ausgefuehrt werden."

			if (!edpException.getMessage().matches(errorMessage)) {

				StringBuilder msg = new StringBuilder("The expected exception '").append(errorMessage).append("'\n")
						.append(" was not found in the exception message from the server:\n")
						.append(edpException.getMessage());

				Assert.fail(msg.toString());
			}
		}
	}

	/**
	 * Datenexport im CSV-Foramt mit Headerzeile. Trenner ist fix die Pipe | Der
	 * Schreibmodus ist immer erweitern (append)
	 * 
	 * @param fields
	 *            Feldliste, kommagetrennt
	 * @param tableName
	 *            Tabellenname der abas-DB (z.B. (Sales):(DeliveryNote))
	 * @param searchCriteria
	 *            Kriterien und Optionen gemaess abas-Selektionssyntax, das $,,
	 *            am Anfang kann oder muss fehlen.
	 * @param fileName
	 *            Dateiname die Datei wird fest im relativen unterverzeichnis
	 *            cucumber/refs/ gespeichert.
	 *
	 *            CUCU-98
	 *
	 */
	@SuppressWarnings("deprecation")
	@And("^I export \"([^\"]*)\" from table \"([^\"]*)\" where \"([^\"]*)\" to output file \"([^\"]*)\"$")
	public void i_export_from_table_where_to_file(String fields, String tableName, String searchCriteria,
			String fileName) throws Throwable {
		// Das Alternativ ging leider nicht:
		// myqueries.i_query_from_table_where(fields, tableName,
		// searchCriteria);
		// rowList ist leider dort private membervariable.
		// Deshalb sehe ich nur die Moeglichkeit von copy & paste um die fkt.
		// abzubilden.

		// kopie aus QueryStepDefs.java - bis auf das "this"
		String[] fieldNames = fields.split(",");
		EDPQuery query = context.getCurrentSession(context.currentScenario).createQuery();
		query.startQuery(tableName, null, searchCriteria, fieldNames);
		this.rowList = new ArrayList<Map<String, String>>();
		while (query.getNextRecord()) {
			Map<String, String> fieldMap = new HashMap<String, String>();
			for (String fieldName : fieldNames) {
				fieldMap.put(fieldName.trim(), query.getField(fieldName));
			}
			this.rowList.add(fieldMap);
		}
		// -- ende kopie
		export_value_table_to_file(fieldNames, this.rowList, fileName);
	}

	/**
	 * Schreibt die Daten einer List-Map als CSV auf Datei.
	 *
	 * @param fieldNames
	 *            Bestimmt die Spaltenreihenfolge
	 * @param table
	 *            die Daten (Feldname, Wert)
	 * @param fileName
	 *            Dateiname die Datei wird fest im relativen Unterverzeichnis
	 *            cucumber/refs/ gespeichert.
	 *
	 *            Hinweis: erstmal "quick" geschrieben, sicher schoener machbar,
	 *            tut aber schon mal was sie soll
	 */
	private void export_value_table_to_file(String[] fieldNames, List<Map<String, String>> table, String fileName)
			throws Throwable {
		String line = "";
		String sep = "|";
		Map<String, Integer> width = new HashMap<String, Integer>();

		// Laengenanalyse
		for (int j = 0; j < fieldNames.length; j++) {
			String trimmedFieldname = fieldNames[j].trim();
			width.put(trimmedFieldname, trimmedFieldname.length());
		}

		for (Map<String, String> rowMap : table) {
			for (int j = 0; j < fieldNames.length; j++) {
				String trimmedFieldname = fieldNames[j].trim();
				String trimmedFieldValue = rowMap.get(trimmedFieldname).trim();
				if (width.get(trimmedFieldname) < trimmedFieldValue.length()) {
					width.put(trimmedFieldname, trimmedFieldValue.length());
				}
			}
		}

		// output header
		boolean first = true;
		for (int j = 0; j < fieldNames.length; j++) {
			String trimmedFieldname = fieldNames[j].trim();
			int length = width.get(trimmedFieldname);
			String strtoadd = padRight(trimmedFieldname, length);
			if (first) {
				line = strtoadd;
				first = false;
			} else {
				line = line + sep + strtoadd;
			}
		}
		line = sep + line + sep + "\n";
		writeFile(line, fileName);

		// output data-table
		for (Map<String, String> rowMap : table) {
			line = "";
			first = true;
			for (int j = 0; j < fieldNames.length; j++) {
				String trimmedFieldname = fieldNames[j].trim();
				String trimmedFieldValue = rowMap.get(trimmedFieldname).trim();
				int length = width.get(trimmedFieldname);
				String strtoadd = padLeft(trimmedFieldValue, length);
				if (first) {
					first = false;
					line = strtoadd;
				} else {
					line = line + sep + strtoadd;
				}
			}
			line = sep + line + sep + "\n";
			writeFile(line, fileName);
		}
	}

	/**
	 * Loescht Datei outputFile
	 *
	 * CUCU-99
	 * 
	 * @param Filename
	 *            Dateiname, der zu loeschenden Datei
	 */
	@And("^I delete file \"([^\"]*)\" in cucu_refs_dir$")
	public void i_delete_file(String Filename) throws Exception {
		deleteFileIfExistsInCucuRefDir(Filename);
	}

	/**
	 * Erweitert Datei outputFile um Text (Zeile).
	 *
	 * CUCU-100
	 *
	 */
	@And("^I append \"([^\"]*)\" to output file \"([^\"]*)\" in cucu_refs_dir$")
	public void i_append_the_following(String text, String outputFile) throws Exception {
		writeFile(text + "\n", outputFile);
	}

	/**
	 * Schreibt Text (Zeile) in eine die angegebene Textdatei, im appendmodus.
	 * Achtung! bisher festes rel. Ausgabeverzeichnis "cucumber/refs"
	 */
	private void writeFile(String text, String outputFile) throws IOException {
		Path outputPath = prepareOutput(outputFile);
		Files.write(outputPath, text.getBytes(), StandardOpenOption.APPEND);
	}

	private Path prepareOutput(String outputFile) throws IOException {
		Path outputPath = Paths.get(ERPTestContext.BUILD_DIR, outputFile);
		Files.createDirectories(outputPath.getParent());

		// delete only if it's the first write to that file in this feature!
		if (!ERPTestContext.fileList.contains(outputFile)) {
			// fileList is emptied in every feature run.
			// if the fileList therefor does not contain the path, it should be
			// deleted first and then added
			Files.deleteIfExists(outputPath);
			ERPTestContext.fileList.add(outputFile);
		}
		if (Files.notExists(outputPath)) {
			Files.createFile(outputPath);
		}
		return outputPath;
	}

	private void deleteFileIfExistsInCucuRefDir(String outputFile) throws IOException {
		Path outputPath = Paths.get(ERPTestContext.BUILD_DIR, outputFile);
		Files.deleteIfExists(outputPath);
	}

	/**
	 * Exportiert den Inhalt einer Tabelle in eine Ausgabedatei in aehnlichem Format wie edpexport.sh.
	 * Der Tabelleninhalt kann aus einem Infosystem, wie aus einem Objekt z.B. Bestellung kommen.
	 * Kann fuer die Ausgabe in eine REF Datei verwendet werden.
	 *
	 * @param fieldList
	 *            Bestimmt die Spaltenreihenfolge
	 * @param fileName
	 *            Ausgabedatei: Ohne Pfad = Testverzeichnis/Mandantenverzeichnis. Auch absolute Pfade moeglich
	 */
	@And("^I export fields \"([^\"]*)\" from table content to output file \"([^\"]*)\"")
	public void i_export_table_content_to_output_file(String fieldList, String fileName) throws Throwable {
		int rows = context.currentEditor.getRowCount();
		if (rows == 0) {
			File tmp = new File(fileName);
			if (!tmp.exists()) {
				Files.createFile(Paths.get(fileName));
			}
			return;
		}
		ArrayList<ArrayList<String>> arrColumns = new ArrayList<ArrayList<String>>();
		getTableValues(fieldList, 1, rows, arrColumns);
		formatColumns(arrColumns);
		writeArrayListToFile(arrColumns, fileName, rows, false);
	}

	/**
	 * Exportiert den Inhalt einiger Kopffelderin eine Ausgabedatei (vertikale Darstellung).
	 * Kann fuer die Ausgabe in eine REF Datei verwendet werden.
	 * Es sollen nur berechnete Werte, die sich leicht aendern koennen, ausgegeben werden,
	 * wie z.B. Summenfelder in Infosystemen.
	 * Fuer die herkoemmliche Feldwertpruefung ist >>Then the field "xy" has value "y"<< vorzuziehen!!!
	 *
	 * @param fieldList
	 *            Namen der Ausgabefelder
	 * @param fileName
	 *            Ausgabedatei: Ohne Pfad = Testverzeichnis/Mandantenverzeichnis. Auch absolute Pfade moeglich
	 */
	@Given("I export fields {string} from calculated header content to output file {string}")
	public void i_export_fields_from_calculated_header_content_to_output_file(String fieldList, String fileName) throws Throwable {
		ArrayList<ArrayList<String>> arrHeaderValues = new ArrayList<ArrayList<String>>();
		getTableValues(fieldList, 0, 0, arrHeaderValues);
		arrHeaderValues = transformToHeaderColumn(arrHeaderValues);
		formatHeaderFieldColumns(arrHeaderValues);
		writeArrayListToFile(arrHeaderValues, fileName, 0, true);
		i_append_text_to_output_file("", fileName);
	}

	/**
	 * Hilfsfunktion: Transformiert die Feldnamen/Feldwertliste zu einer zweispaltigen
	 * Liste zur Anzeige von Kopffeldern mit
	 *     Feldname : Feldwert
	 * @param arrColumns
	 * @return Die umgestaltete Liste
	 */
	public ArrayList<ArrayList<String>> transformToHeaderColumn(ArrayList<ArrayList<String>> arrColumns)
	{
		ArrayList<ArrayList<String>> tparrColumns = new ArrayList<ArrayList<String>>();
		ArrayList<String> fieldNames = new ArrayList<String>();
		ArrayList<String> fieldValues = new ArrayList<String>();

		for (int i = 0; i < arrColumns.size(); i++) {
			fieldNames.add(arrColumns.get(i).get(0));
			fieldValues.add(arrColumns.get(i).get(1));
		}
		tparrColumns.add(fieldNames);
		tparrColumns.add(fieldValues);
		return tparrColumns;
	}

	/**
	 * Hilfsfunktion zur formatierten Tabellenausgabe in eine Ausgabedatei
	 * @param arrColumns
	 * 		Array mit Spaltenwerten
	 * @param fileName
	 * 		Ausgabedatei
	 * @param rows
	 * 		Anzahl der Ausgabezeilen
	 */
	private void writeArrayListToFile(ArrayList<ArrayList<String>> arrColumns, String fileName, int rows, boolean vertical) {
		StringBuilder sb = new StringBuilder();
		StringBuilder sbrow = new StringBuilder();
		String  linie = "-";
		for (int i = 0; i < arrColumns.get(0).size(); i++) {
			sbrow.setLength(0);
			for (int k = 0; k < arrColumns.size(); k++) {
				ArrayList<String> arrFields = arrColumns.get(k);
				sbrow.append(arrFields.get(i));
				if(!vertical) {
					sbrow.append(" | ");
				}
				else if(k==0){
					sbrow.append(" : ");
				}
			}

			sbrow.append('\n');
			if( i == 0 && !vertical) {
				// Unterstrichzeile anfuegen
				sbrow.append(String.join("", Collections.nCopies(sbrow.length()-2, linie)));
				sbrow.append('\n');
			}
			sb.append(sbrow);
		}
		try {
			File tmp = new File(fileName);
			if (!tmp.exists()) {
				Files.createFile(Paths.get(fileName));
			}
			Files.write(Paths.get(fileName), sb.toString().getBytes(), StandardOpenOption.APPEND);
		} catch (IOException e) {
			Assert.fail("IOException: " + e.getMessage());
		}
	}

	/**
	 * Hilfsfunktion liest die Tabellenwerte an Hand der Feldliste aus und speichert sie im arrFields.
	 * Bei Angabe eines ungueltigen Feldnamens wird eine Assertion geworfen.
	 *
	 * @param fieldList
	 * 		Die Feldnamen mit Komma getrennt
	 * @param rows
	 * 		Anzahl der Zeilen
	 * @param arrColumns
	 * 		Der zweidim. Array, der die Tabellenwerte aufnimmt
	 * @throws CantReadFieldPropertyException
	 */
	private void getTableValues(final String fieldList, int startrow, int rows, ArrayList<ArrayList<String>> arrColumns)
			throws CantReadFieldPropertyException {
		String[] inputFields = fieldList.replace(" ", "").split(",");
		for (int row = startrow; row <= rows; row++) {
			EDPEditFieldList fldList = context.currentEditor.getEditFieldList(row, inputFields);
			ArrayList<String> arrFields = null;
			for (int col = 0; col < fldList.getFieldCount(); col++) {
				arrFields = getArrFields(arrColumns, col);
				EDPEditField field = fldList.getField(col + 1);
				if( field.getLength() == 0) {
					Assert.fail("Ungültiger Feldname '" + field.getName() + "'");
				}
				if (arrFields.size() == 0) {
					// Feldnamen in der ersten Zeile
					String ist_nummer = "";
					String edpType = field.getEDPType();
					if( edpType.contains("N") ) {
						ist_nummer = NUMMERISCH;
					}
					arrFields.add(field.getName().trim() + ist_nummer);
				}
				arrFields.add(field.getValue().trim());
			}
		}
	}


	/**
	 * Formatiert die Feldwerte und richtet sie aus (Padding)
	 * .
	 * @param arrColumns
	 */
	private void formatColumns(ArrayList<ArrayList<String>> arrColumns) {
		arrColumns.forEach(arrFields -> {
			int maxLen = 0;
			for (String field : arrFields) {
				maxLen = Math.max(maxLen, field.length());
			}
			String value = "";
			boolean isNumeric = false;
			for (int i = 0; i < arrFields.size(); i++) {
				if( i == 0) {
					String FieldName = arrFields.get(i);
					if(FieldName.contains(NUMMERISCH)) {
						isNumeric = true;
						FieldName = FieldName.replace(NUMMERISCH, "");
					}
					value = padRight(FieldName, maxLen);
				} else {
					if(isNumeric) {
						value = padLeft(arrFields.get(i), maxLen);
					}
					else {
						value = padRight(arrFields.get(i), maxLen);
					}
				}
				arrFields.set(i, value);
			}
		});
	}

	/**
	 * Formatiert die Feldwerte und richtet sie aus (Padding).
	 * Fuer die Kopffelder (vertikale Darstellung)
	 *
	 * @param arrColumns
	 */
	private void formatHeaderFieldColumns(ArrayList<ArrayList<String>> arrColumns) {
		arrColumns.forEach(arrFields -> {
			int maxLen = 0;
			for (String field : arrFields) {
				maxLen = Math.max(maxLen, field.length());
			}
			String value = "";
			for (int i = 0; i < arrFields.size(); i++) {
				value = padRight(arrFields.get(i).trim(), maxLen);
				arrFields.set(i, value);
			}
		});
	}

	/**
	 * Fuellt einen String auf der linken Seite mit Leerzeichen auf bis die gewuenschte
	 * Zeichenkettenlaenge erreicht ist.
	 *
	 * @param input
	 *            Die aufzufuellende Zeichenkette
	 * @param length
	 *            Die Zeichenkettenlaenge auf die aufgefuellt werden soll
	 */
	private String padLeft(final String input, int length) {
		return String.format("%"+Integer.toString(length)+"s",input);
	}

	/**
	 * Fuellt einen String auf der rechten Seite mit Leerzeichen auf bis die gewuenschte
	 * Zeichenkettenlaenge erreicht ist.
	 *
	 * @param input
	 *            Die aufzufuellende Zeichenkette
	 * @param length
	 *            Die Zeichenkettenlaenge auf die aufgefuellt werden soll
	 */
	private String padRight(final String input, int length) {
		return String.format("%-"+Integer.toString(length)+"s",input);
	}

	/**
	 * Hilfsfunktion zum Zugriff auf eine Felderliste
	 */
	private ArrayList<String> getArrFields(ArrayList<ArrayList<String>> arrColumns, int j) {
		if (arrColumns.size() <= j) {
			ArrayList<String> arrFields = new ArrayList<String>();
			arrColumns.add(arrFields);
		}
		return arrColumns.get(j);
	}

	/**
	 * Fuegt einen Ueberschriftenblock mit *-Linien und Zeilenumbruechen an eine Ausgabedatei an.
	 * Kann fuer das Schreiben in eine REF Datei genutzt werden.
	 *
	 * @param headline
	 *            Text der Ueberschrift
	 * @param fileName
	 *            Ausgabedatei: Ohne Pfad = Testverzeichnis/Mandantenverzeichnis. Auch absolute Pfade moeglich
	 */
	@Given("I append headline {string} to output file {string}")
	public void i_append_headline_to_output_file(String headline, String fileName) {
		StringBuilder sb = new StringBuilder();
		sb.append("\n");
		sb.append("*******************************************************************************\n");
		sb.append(headline);
		sb.append("\n");
		sb.append("*******************************************************************************\n");
		sb.append("\n");
		try {
			File tmp = new File(fileName);
			if (!tmp.exists()) {
				Files.createFile(Paths.get(fileName));
			}
			Files.write(Paths.get(fileName), sb.toString().getBytes(), StandardOpenOption.APPEND);
		} catch (IOException e) {
			Assert.fail("IOException: " + e.getMessage());
		}
	}

	/**
	 * Fuegt einen Ueberschriftenblock mit Scenarioname als Ueberschriftentext
	 * + *-Linien und Zeilenumbruechen an eine Ausgabedatei an.
	 * Kann fuer das Schreiben in eine REF Datei genutzt werden.
	 *
	 * @param fileName
	 *            Ausgabedatei: Ohne Pfad = Testverzeichnis/Mandantenverzeichnis. Auch absolute Pfade moeglich
	 */
	@Given("I append ScenarioHeadline to output file {string}")
	public void i_append_ScenarioHeadline_to_output_file(String fileName) {
	    String ScenarioName = context.currentScenario.getName();
	    i_append_headline_to_output_file(ScenarioName, fileName);
	}

	/**
	 * Fuegt einen Text an eine Ausgabedatei an.
	 *
	 *@param appendText
	 *            Text, der angefuegt werden soll
	 * @param fileName
	 *            Ausgabedatei: Ohne Pfad = Testverzeichnis/Mandantenverzeichnis. Auch absolute Pfade moeglich
	 */
	@Given("I append text {string} to output file {string}")
	public void i_append_text_to_output_file(String appendText, String fileName) {
		StringBuilder sb = new StringBuilder();
		//sb.append("\n");
		sb.append(appendText);
		sb.append("\n");
		try {
			File tmp = new File(fileName);
			if (!tmp.exists()) {
				Files.createFile(Paths.get(fileName));
			}
			Files.write(Paths.get(fileName), sb.toString().getBytes(), StandardOpenOption.APPEND);
		} catch (IOException e) {
			Assert.fail("IOException: " + e.getMessage());
		}
	}

}

