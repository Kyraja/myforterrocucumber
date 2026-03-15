import * as XLSX from 'xlsx';

interface ExampleRow {
  Ueberschrift: string;
  Beschreibung: string;
  Umsetzungszeit: string;
  'QS-Zeit': string;
  Prioritaet: number;
  Bereich: string;
}

const EXAMPLES: ExampleRow[] = [
  {
    Ueberschrift: 'Kundenklassifizierung erweitern',
    Beschreibung:
      'Im Kundenstamm (Datenbank 0:1) soll ein neues Feld "ykundenkategorie" angelegt werden. ' +
      'Das Feld ist vom Typ Aufzaehlung mit den Werten: A-Kunde, B-Kunde, C-Kunde. ' +
      'Bei Neuanlage (NEW) eines Kunden wird automatisch "C-Kunde" vorbelegt. ' +
      'Das Feld muss in der Kundenmaske sichtbar und aenderbar sein. ' +
      'Beim Speichern soll geprueft werden, dass das Feld nicht leer ist (Exception "KATEGORIE_LEER"). ' +
      'Wird ein ungueltiger Wert eingetragen, soll direkt am Feld die Exception "KATEGORIE_UNGUELTIG" geworfen werden.',
    Umsetzungszeit: '4h',
    'QS-Zeit': '1h',
    Prioritaet: 1,
    Bereich: 'Vertrieb',
  },
  {
    Ueberschrift: 'Artikelgewichtsklasse',
    Beschreibung:
      'Im Artikelstamm (Datenbank 2:1) wird ein neues Feld "ygewichtsklasse" benoetigt. ' +
      'Moegliche Werte: Leicht (bis 5kg), Mittel (5-25kg), Schwer (ueber 25kg). ' +
      'Das Feld wird beim Speichern automatisch anhand des Bruttogewichts berechnet. ' +
      'Es darf nicht manuell aenderbar sein (nur Anzeige, gesperrt). ' +
      'Bei einem bestehenden Artikel (UPDATE) muss die Gewichtsklasse korrekt angezeigt werden.',
    Umsetzungszeit: '2h',
    'QS-Zeit': '1h',
    Prioritaet: 2,
    Bereich: 'Lager',
  },
  {
    Ueberschrift: 'Rabattvalidierung im Verkaufsauftrag',
    Beschreibung:
      'Im Verkaufsauftrag (Datenbank 2:5) soll eine Validierung eingefuehrt werden: ' +
      'Der Gesamtrabatt pro Position darf maximal 15% betragen. ' +
      'Wird ein hoeherer Rabatt in einer Tabellenzeile eingetragen, soll eine Exception geworfen werden mit der ID "MAX_RABATT". ' +
      'Dazu muss eine neue Zeile angelegt, der Artikel und die Menge gesetzt und dann der Rabatt geprueft werden. ' +
      'Ausnahme: A-Kunden (ykundenkategorie = "A-Kunde") duerfen bis zu 25% Rabatt erhalten.',
    Umsetzungszeit: '8h',
    'QS-Zeit': '2h',
    Prioritaet: 1,
    Bereich: 'Vertrieb',
  },
  {
    Ueberschrift: 'Lieferantenbewertung automatisch berechnen',
    Beschreibung:
      'Im Lieferantenstamm (Datenbank 5:1) soll ein neues Feld "yliefbewertung" (Aufzaehlung: Gut/Mittel/Schlecht) ' +
      'angelegt werden. Die Bewertung wird automatisch berechnet basierend auf Liefertreue und Reklamationsquote. ' +
      'Das Feld ist nicht manuell aenderbar. Ein Button "ybewertung" loest die Neuberechnung aus. ' +
      'Nach dem Druecken des Buttons soll ein Dialog mit der ID "DLG_BEWERTUNG" erscheinen, ' +
      'der mit "Ja" beantwortet wird. Danach ist das Feld "yliefbewertung" nicht mehr leer.',
    Umsetzungszeit: '6h',
    'QS-Zeit': '2h',
    Prioritaet: 2,
    Bereich: 'Einkauf',
  },
  {
    Ueberschrift: 'SLA-Feld im Serviceauftrag',
    Beschreibung:
      'Im Serviceauftrag soll ein neues Pflichtfeld "ysla_kategorie" angelegt werden. ' +
      'Werte: Standard (72h), Premium (24h), Express (4h). ' +
      'Das Feld muss bei Neuanlage gesetzt werden — Speichern ohne Auswahl wird mit Exception "SLA_PFLICHT" verhindert. ' +
      'Das Feld soll nach dem Speichern nicht mehr aenderbar sein (gesperrt). ' +
      'Einen bestehenden Serviceauftrag per Suche oeffnen und pruefen, dass das SLA-Feld gesperrt ist.',
    Umsetzungszeit: '3h',
    'QS-Zeit': '1h',
    Prioritaet: 1,
    Bereich: 'Service',
  },
  {
    Ueberschrift: 'Umsatzauswertung Infosystem',
    Beschreibung:
      'Es soll ein neues Infosystem "UMSATZAUSWERTUNG" (Suchwort) erstellt werden. ' +
      'Eingabefelder: Kunde (Suchfeld), Zeitraum von/bis. ' +
      'Ausgabe in der Tabelle: Auftragsnummer, Datum, Nettobetrag, Waehrung. ' +
      'Test: Infosystem per Suchwort oeffnen, Kunde eingeben, pruefen dass Zeilen angezeigt werden ' +
      'und die Werte in der ersten Zeile korrekt sind. Das Feld "nettobetrag" darf nicht leer sein.',
    Umsetzungszeit: '12h',
    'QS-Zeit': '3h',
    Prioritaet: 3,
    Bereich: 'Controlling',
  },
  {
    Ueberschrift: 'Betriebsauftrag Prioritaetsfeld',
    Beschreibung:
      'Im Betriebsauftrag soll ein neues Feld "yfertigungsprio" eingefuehrt werden. ' +
      'Werte: Normal, Eilauftrag, Nacharbeit. ' +
      'Bei "Eilauftrag" soll automatisch das Feld "Bemerkung" mit "EILAUFTRAG - Bevorzugte Fertigung" vorbelegt werden. ' +
      'Das Prioritaetsfeld ist aenderbar solange der Betriebsauftrag nicht freigegeben ist. ' +
      'Nach der Freigabe per Button "freig" soll das Feld gesperrt sein.',
    Umsetzungszeit: '4h',
    'QS-Zeit': '1h',
    Prioritaet: 2,
    Bereich: 'Fertigung',
  },
  {
    Ueberschrift: 'Rechnungstoleranzen im Einkauf',
    Beschreibung:
      'Bei der Rechnungspruefung im Einkauf soll ein Toleranzfeld "yrechtoleranz" (in Prozent) eingefuehrt werden. ' +
      'Standardwert: 2%. Wenn die Rechnungssumme um mehr als die Toleranz von der Bestellsumme abweicht, ' +
      'soll eine Exception "RECHNUNG_TOLERANZ" geworfen werden. ' +
      'Das Toleranzfeld kann pro Lieferant individuell im Lieferantenstamm hinterlegt werden.',
    Umsetzungszeit: '5h',
    'QS-Zeit': '2h',
    Prioritaet: 1,
    Bereich: 'Einkauf',
  },
  {
    Ueberschrift: 'Verkaufsauftrag Positionsdetails (Subeditor)',
    Beschreibung:
      'Im Verkaufsauftrag (Datenbank 2:5) soll in den Positionen ein Subeditor fuer Positionsdetails ' +
      'ueber den Button "yposdetails" geoeffnet werden koennen. Im Subeditor "Positionsdetails" gibt es ' +
      'die Felder "ylieferhinweis" und "yverpackungsart". ' +
      'Test: Verkaufsauftrag oeffnen, neue Zeile anlegen, Artikel setzen, ' +
      'Subeditor in Zeile 1 ueber Button "yposdetails" oeffnen, Felder pruefen und setzen, ' +
      'Subeditor schliessen und Auftrag speichern.',
    Umsetzungszeit: '6h',
    'QS-Zeit': '2h',
    Prioritaet: 2,
    Bereich: 'Vertrieb',
  },
  {
    Ueberschrift: 'Ansprechpartner zum Kunden wechseln',
    Beschreibung:
      'Aus dem Kundenstamm (Datenbank 0:1) soll per Editor-Wechsel zum Ansprechpartner-Editor navigiert werden. ' +
      'Test: Kundenstamm im VIEW-Modus oeffnen, dann zum Editor "Ansprechpartner" wechseln. ' +
      'Im Ansprechpartner-Editor pruefen, dass das Feld "name" nicht leer ist ' +
      'und das Feld "telefon" vorhanden und aenderbar ist. Danach den Editor schliessen.',
    Umsetzungszeit: '2h',
    'QS-Zeit': '1h',
    Prioritaet: 3,
    Bereich: 'Vertrieb',
  },
  {
    Ueberschrift: 'Auftragskopie per Menueauswahl',
    Beschreibung:
      'Im Verkaufsauftrag (Datenbank 2:5) soll ein bestehender Auftrag per Menueauswahl "Kopie-Standard" ' +
      'kopiert werden koennen. Der neue Auftrag erhaelt automatisch ein neues Suchwort. ' +
      'Test: Editor oeffnen mit Kommando NEW, Datensatz des Quellauftrags angeben, ' +
      'Menueauswahl "Kopie-Standard" treffen. Dann pruefen, dass die kopierten Felder korrekt uebernommen wurden ' +
      'und der neue Auftrag gespeichert werden kann.',
    Umsetzungszeit: '3h',
    'QS-Zeit': '1h',
    Prioritaet: 2,
    Bereich: 'Vertrieb',
  },
  {
    Ueberschrift: 'Kundensuche und Datenabgleich',
    Beschreibung:
      'Im Kundenstamm (Datenbank 0:1) soll ein bestehender Kunde per Suchkriterium gefunden werden koennen. ' +
      'Test: Editor oeffnen mit Kommando VIEW und Suchkriterium "ykundenkategorie=A*". ' +
      'Pruefen, dass der gefundene Datensatz die Kundenkategorie "A-Kunde" hat, ' +
      'dass das Feld "name" nicht leer ist und dass das Feld "such" nicht aenderbar (gesperrt) ist.',
    Umsetzungszeit: '2h',
    'QS-Zeit': '1h',
    Prioritaet: 3,
    Bereich: 'Vertrieb',
  },
];

export function downloadExampleXlsx(): void {
  const ws = XLSX.utils.json_to_sheet(EXAMPLES);
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws, 'Arbeitspakete');

  ws['!cols'] = [
    { wch: 40 }, // Ueberschrift
    { wch: 90 }, // Beschreibung
    { wch: 16 }, // Umsetzungszeit
    { wch: 10 }, // QS-Zeit
    { wch: 12 }, // Prioritaet
    { wch: 15 }, // Bereich
  ];

  const buffer = XLSX.write(wb, { bookType: 'xlsx', type: 'array' });
  const blob = new Blob([buffer], {
    type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = 'Arbeitspakete_Beispiel.xlsx';
  a.click();
  URL.revokeObjectURL(url);
}
