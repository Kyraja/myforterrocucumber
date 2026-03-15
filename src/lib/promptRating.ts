/**
 * Heuristic rating of requirement text quality for AI scenario generation.
 * Criteria and examples are written from the perspective of abas ERP consultants
 * describing customization processes (Anforderungstexte), not test procedures.
 */

export interface PromptSuggestion {
  text: string;
  exampleBad: string;
  exampleGood: string;
}

export interface PromptRating {
  score: number;
  suggestions: PromptSuggestion[];
}

interface RatingCriterion {
  points: number;
  test: (text: string, hasDb: boolean) => boolean;
  suggestionDe: string;
  suggestionEn: string;
  exampleBadDe: string;
  exampleBadEn: string;
  exampleGoodDe: string;
  exampleGoodEn: string;
}

const criteria: RatingCriterion[] = [
  // --- Laenge & Struktur ---
  {
    points: 10,
    test: (t) => t.trim().length >= 30,
    suggestionDe: 'Beschreibung ist zu kurz — den Prozess etwas ausfuehrlicher beschreiben',
    suggestionEn: 'Description is too short — describe the process in more detail',
    exampleBadDe: 'Neues Feld im Kundenstamm',
    exampleBadEn: 'New field in customer master',
    exampleGoodDe: 'Im Kundenstamm wird ein neues Feld "Kundengruppe" (ykdgruppe) vom Typ Auswahl ergaenzt. Beim Anlegen eines Kunden muss dieses Feld befuellt werden.',
    exampleGoodEn: 'A new field "Customer group" (ykdgruppe) of type selection is added to the customer master. When creating a customer, this field must be filled.',
  },
  {
    points: 10,
    test: (t) => t.trim().length >= 100,
    suggestionDe: 'Mehr Details zum Ablauf: Was passiert Schritt fuer Schritt?',
    suggestionEn: 'More process details: What happens step by step?',
    exampleBadDe: 'Neues Feld im Kundenstamm fuer Kundengruppe',
    exampleBadEn: 'New field in customer master for customer group',
    exampleGoodDe: 'Im Kundenstamm wird ein neues Feld ykdgruppe ergaenzt. Beim Anlegen muss die Kundengruppe aus einer Auswahl gewaehlt werden. Nach dem Speichern soll das Feld nicht mehr aenderbar sein. Beim Aendern eines bestehenden Kunden bleibt das Feld sichtbar aber gesperrt.',
    exampleGoodEn: 'A new field ykdgruppe is added to customer master. When creating, the customer group must be selected. After saving it should be read-only. When editing an existing customer the field stays visible but locked.',
  },
  {
    points: 5,
    test: (t) => t.split(/\n/).filter((l) => l.trim()).length >= 3,
    suggestionDe: 'Text strukturieren — z.B. Schritte nummerieren oder Absaetze verwenden',
    suggestionEn: 'Structure text — e.g. number steps or use paragraphs',
    exampleBadDe: 'Im Kundenstamm gibt es ein neues Feld ykdgruppe das muss beim Anlegen gesetzt werden und nach dem Speichern gesperrt sein',
    exampleBadEn: 'Customer master has a new field ykdgruppe it must be set when creating and locked after saving',
    exampleGoodDe: 'Im Kundenstamm wird ein neues Feld ykdgruppe ergaenzt.\nBeim Anlegen muss die Kundengruppe gewaehlt werden.\nNach dem Speichern ist das Feld gesperrt.',
    exampleGoodEn: 'A new field ykdgruppe is added to customer master.\nWhen creating the customer group must be selected.\nAfter saving the field is locked.',
  },

  // --- Fachliche Inhalte ---
  {
    points: 10,
    test: (t) => /feld|field|spalte|column|y[a-z]/i.test(t),
    suggestionDe: 'Felder benennen — welche Felder sind betroffen? (z.B. Feldname oder y-Feld)',
    suggestionEn: 'Name the fields — which fields are affected? (e.g. field name or y-field)',
    exampleBadDe: 'Es gibt eine neue Eingabe fuer die Kategorie',
    exampleBadEn: 'There is a new input for the category',
    exampleGoodDe: 'Neues Feld "ytkategorie" vom Typ Freitext im Kopfbereich',
    exampleGoodEn: 'New field "ytkategorie" of type free text in the header area',
  },
  {
    points: 10,
    test: (t) => /typ|type|auswahl|selection|freitext|freetext|lieferant|supplier|kunde|customer|artikel|article|datum|date|zahl|number|referenz|reference/i.test(t),
    suggestionDe: 'Feldtyp oder Bezug beschreiben — z.B. "vom Typ Lieferant", "Freitext", "Referenz auf Artikel"',
    suggestionEn: 'Describe field type or reference — e.g. "of type supplier", "free text", "reference to article"',
    exampleBadDe: 'Neues Feld ylieferant',
    exampleBadEn: 'New field ylieferant',
    exampleGoodDe: 'Neues Feld ylieferant vom Typ Lieferant — es muss ein gueltiger Lieferant eingetragen werden',
    exampleGoodEn: 'New field ylieferant of type supplier — a valid supplier must be entered',
  },
  {
    points: 10,
    test: (t) => /maske|editor|screen|stamm|master|kopf|header|tabelle|table|datenbank|database|infosystem|position/i.test(t),
    suggestionDe: 'Wo findet die Aenderung statt? Maske, Stammdaten, Kopf-/Tabellenbereich?',
    suggestionEn: 'Where does the change take place? Screen, master data, header/table area?',
    exampleBadDe: 'Ein neues Feld wird hinzugefuegt',
    exampleBadEn: 'A new field is added',
    exampleGoodDe: 'Im Kundenstamm im Kopfbereich wird ein neues Feld ergaenzt',
    exampleGoodEn: 'A new field is added in the customer master header area',
  },
  {
    points: 10,
    test: (t) => /anlegen|erstell|neu|create|new|aender|change|modify|update|loeschen|delet|oeffnen|open|buchen|post|liefern|deliver/i.test(t),
    suggestionDe: 'Welcher Vorgang ist betroffen? Anlegen, Aendern, Buchen, Liefern?',
    suggestionEn: 'Which process is affected? Creating, modifying, posting, delivering?',
    exampleBadDe: 'Kundenstamm mit neuem Feld',
    exampleBadEn: 'Customer master with new field',
    exampleGoodDe: 'Beim Anlegen eines neuen Kunden muss das Feld ykdgruppe befuellt werden',
    exampleGoodEn: 'When creating a new customer the field ykdgruppe must be filled',
  },
  {
    points: 10,
    test: (t) => /soll|should|muss|must|darf|may|kann|can|pflicht|mandatory|optional|gesperrt|locked|sichtbar|visible|aenderbar|editable|nicht leer|not empty|gueltig|valid/i.test(t),
    suggestionDe: 'Verhalten beschreiben — was soll/muss/darf passieren? Pflichtfeld? Gesperrt?',
    suggestionEn: 'Describe behavior — what should/must/may happen? Mandatory? Locked?',
    exampleBadDe: 'Neues Feld ykdgruppe im Kundenstamm',
    exampleBadEn: 'New field ykdgruppe in customer master',
    exampleGoodDe: 'Das Feld ykdgruppe muss beim Anlegen befuellt werden (Pflichtfeld). Nach dem Speichern soll es gesperrt sein.',
    exampleGoodEn: 'Field ykdgruppe must be filled when creating (mandatory). After saving it should be locked.',
  },
  {
    points: 5,
    test: (t) => /speicher|save|buchen|post|freig|release|abschluss|schliess|close|danach|anschließend|anschliessend|afterwards|then|ergebnis|result/i.test(t),
    suggestionDe: 'Folgeaktion oder Ergebnis beschreiben — was passiert danach? (z.B. speichern, buchen, Feld wird gesperrt)',
    suggestionEn: 'Describe follow-up action or result — what happens next? (e.g. save, post, field becomes locked)',
    exampleBadDe: 'Neues Feld ykdgruppe im Kundenstamm',
    exampleBadEn: 'New field ykdgruppe in customer master',
    exampleGoodDe: 'Neues Feld ykdgruppe im Kundenstamm. Nach dem Speichern ist das Feld gesperrt.',
    exampleGoodEn: 'New field ykdgruppe in customer master. After saving the field is locked.',
  },

  // --- Variablentabelle ---
  {
    points: 15,
    test: (_t, hasDb) => hasDb,
    suggestionDe: 'Variablentabelle hochladen — dann kennt die KI alle Felder und Datenbanken',
    suggestionEn: 'Upload variable table — then the AI knows all fields and databases',
    exampleBadDe: '(keine Variablentabelle geladen — KI muss Feldnamen raten)',
    exampleBadEn: '(no variable table loaded — AI must guess field names)',
    exampleGoodDe: 'CSV hochgeladen → KI verwendet exakte Feldnamen wie ytkategorie, ykdgruppe',
    exampleGoodEn: 'CSV uploaded → AI uses exact field names like ytkategorie, ykdgruppe',
  },

  // --- Konkretheit ---
  {
    points: 5,
    test: (t) => /"[^"]+"|'[^']+'/.test(t),
    suggestionDe: 'Konkrete Werte oder Namen in Anfuehrungszeichen — hilft der KI bei Testwerten',
    suggestionEn: 'Concrete values or names in quotes — helps AI with test values',
    exampleBadDe: 'Im Suchwort steht ein Testwert',
    exampleBadEn: 'Search word contains a test value',
    exampleGoodDe: 'Suchwort ist z.B. "T001KUNDE" oder allgemein ein Kundensuchwort',
    exampleGoodEn: 'Search word is e.g. "T001KUNDE" or a general customer search word',
  },
];

const MAX_SCORE = criteria.reduce((sum, c) => sum + c.points, 0);

export function ratePrompt(text: string, hasDatabase: boolean, lang: 'de' | 'en'): PromptRating {
  let earned = 0;
  const suggestions: PromptSuggestion[] = [];

  for (const c of criteria) {
    if (c.test(text, hasDatabase)) {
      earned += c.points;
    } else {
      suggestions.push({
        text: lang === 'de' ? c.suggestionDe : c.suggestionEn,
        exampleBad: lang === 'de' ? c.exampleBadDe : c.exampleBadEn,
        exampleGood: lang === 'de' ? c.exampleGoodDe : c.exampleGoodEn,
      });
    }
  }

  const score = Math.round((earned / MAX_SCORE) * 100);
  return { score, suggestions };
}

export function ratingColor(score: number): string {
  if (score >= 80) return 'var(--color-success, #16a34a)';
  if (score >= 60) return 'var(--color-warning, #d97706)';
  if (score >= 40) return '#ea580c'; // orange
  return 'var(--color-danger, #dc2626)';
}
