import { describe, it, expect } from 'vitest';
import {
  parseTableIdentificationResponse,
  buildTableIdentificationMessages,
  buildMessagesWithFields,
  lookupRelevantTables,
  extractGherkin,
  extractPromptRating,
  buildRatingMessages,
  parseRatingResponse,
} from './aiPrompt';
import type { TableDef } from '../types/gherkin';

// ── parseTableIdentificationResponse ────────────────────────────

describe('parseTableIdentificationResponse', () => {
  it('parses clean JSON', () => {
    const r = parseTableIdentificationResponse(
      '{"tables": ["Kundenstamm", "Verkaufsauftrag"], "infosystems": ["Umsatzinfo"]}',
    );
    expect(r.tables).toEqual(['Kundenstamm', 'Verkaufsauftrag']);
    expect(r.infosystems).toEqual(['Umsatzinfo']);
  });

  it('strips markdown code fences', () => {
    const r = parseTableIdentificationResponse(
      '```json\n{"tables": ["Artikelstamm"], "infosystems": []}\n```',
    );
    expect(r.tables).toEqual(['Artikelstamm']);
    expect(r.infosystems).toEqual([]);
  });

  it('handles missing infosystems key', () => {
    const r = parseTableIdentificationResponse('{"tables": ["Kundenstamm"]}');
    expect(r.tables).toEqual(['Kundenstamm']);
    expect(r.infosystems).toEqual([]);
  });

  it('handles missing tables key', () => {
    const r = parseTableIdentificationResponse('{"infosystems": ["Info"]}');
    expect(r.tables).toEqual([]);
    expect(r.infosystems).toEqual(['Info']);
  });

  it('returns empty arrays for invalid JSON', () => {
    const r = parseTableIdentificationResponse('This is not JSON at all');
    expect(r.tables).toEqual([]);
    expect(r.infosystems).toEqual([]);
  });

  it('returns empty arrays for empty string', () => {
    const r = parseTableIdentificationResponse('');
    expect(r.tables).toEqual([]);
    expect(r.infosystems).toEqual([]);
  });

  it('filters out non-string values', () => {
    const r = parseTableIdentificationResponse(
      '{"tables": ["Kundenstamm", 42, null, true], "infosystems": []}',
    );
    expect(r.tables).toEqual(['Kundenstamm']);
  });
});

// ── buildTableIdentificationMessages ────────────────────────────

describe('buildTableIdentificationMessages', () => {
  const tables = [
    { name: 'Kundenstamm', tableRef: '0:1', kind: 'database' as const },
    { name: 'Artikelstamm', tableRef: '0:6', kind: 'database' as const },
    { name: 'Umsatzauswertung', tableRef: 'UMSATZINFO', kind: 'infosystem' as const },
  ];

  it('returns system + user message', () => {
    const msgs = buildTableIdentificationMessages('Anforderung', tables);
    expect(msgs).toHaveLength(2);
    expect(msgs[0].role).toBe('system');
    expect(msgs[1].role).toBe('user');
  });

  it('includes all database names', () => {
    const msgs = buildTableIdentificationMessages('Anforderung', tables);
    expect(msgs[1].content).toContain('"Kundenstamm"');
    expect(msgs[1].content).toContain('"Artikelstamm"');
  });

  it('includes infosystem names', () => {
    const msgs = buildTableIdentificationMessages('Anforderung', tables);
    expect(msgs[1].content).toContain('"Umsatzauswertung"');
  });

  it('includes the requirements text', () => {
    const msgs = buildTableIdentificationMessages('Mein Anforderungstext hier', tables);
    expect(msgs[1].content).toContain('Mein Anforderungstext hier');
  });

  it('instructs JSON-only response in system prompt', () => {
    const msgs = buildTableIdentificationMessages('Text', tables);
    expect(msgs[0].content).toContain('JSON');
  });
});

// ── lookupRelevantTables ────────────────────────────────────────

describe('lookupRelevantTables', () => {
  const tables: TableDef[] = [
    { database: '0', group: '1', tableRef: '0:1', name: 'Kundenstamm', fields: [{ name: 'such', description: 'Suchwort' }], kind: 'database' },
    { database: '2', group: '1', tableRef: '2:1', name: 'Verkaufsauftrag', fields: [{ name: 'such', description: 'Suchwort' }], kind: 'database' },
    { database: '', group: '', tableRef: 'UMSATZINFO', name: 'Umsatzauswertung', fields: [{ name: 'filter', description: 'Filter' }], kind: 'infosystem' },
  ];

  it('matches database names case-insensitively', () => {
    const result = lookupRelevantTables({ tables: ['kundenstamm'], infosystems: [] }, tables);
    expect(result).toHaveLength(1);
    expect(result[0].tableRef).toBe('0:1');
  });

  it('matches multiple databases', () => {
    const result = lookupRelevantTables({ tables: ['Kundenstamm', 'Verkaufsauftrag'], infosystems: [] }, tables);
    expect(result).toHaveLength(2);
  });

  it('returns empty array for unmatched names', () => {
    const result = lookupRelevantTables({ tables: ['Unbekannt'], infosystems: [] }, tables);
    expect(result).toHaveLength(0);
  });

  it('matches infosystems', () => {
    const result = lookupRelevantTables({ tables: [], infosystems: ['Umsatzauswertung'] }, tables);
    expect(result).toHaveLength(1);
    expect(result[0].kind).toBe('infosystem');
  });

  it('deduplicates same table appearing twice', () => {
    const result = lookupRelevantTables({ tables: ['Kundenstamm', 'Kundenstamm'], infosystems: [] }, tables);
    expect(result).toHaveLength(1);
  });

  it('combines databases and infosystems', () => {
    const result = lookupRelevantTables(
      { tables: ['Kundenstamm'], infosystems: ['Umsatzauswertung'] },
      tables,
    );
    expect(result).toHaveLength(2);
    expect(result[0].kind).toBe('database');
    expect(result[1].kind).toBe('infosystem');
  });

  // ── Fuzzy / synonym matching ──

  const tablesWithShortNames: TableDef[] = [
    { database: '2', group: '1', tableRef: '2:1', name: 'Artikel', fields: [{ name: 'such', description: 'SW' }], kind: 'database' },
    { database: '2', group: '0', tableRef: '2:0', name: 'Teile', fields: [{ name: 'such', description: 'SW' }], kind: 'database' },
    { database: '0', group: '1', tableRef: '0:1', name: 'Kunde', fields: [{ name: 'such', description: 'SW' }], kind: 'database' },
    { database: '3', group: '1', tableRef: '3:1', name: 'Lieferant', fields: [{ name: 'such', description: 'SW' }], kind: 'database' },
    { database: '4', group: '0', tableRef: '4:0', name: 'Verkaufsauftrag', fields: [{ name: 'such', description: 'SW' }], kind: 'database' },
  ];

  it('matches "Artikelstamm" → "Artikel" via synonym', () => {
    const result = lookupRelevantTables({ tables: ['Artikelstamm'], infosystems: [] }, tablesWithShortNames);
    expect(result).toHaveLength(1);
    expect(result[0].name).toBe('Artikel');
  });

  it('matches "Teilestamm" → "Teile" via synonym', () => {
    const result = lookupRelevantTables({ tables: ['Teilestamm'], infosystems: [] }, tablesWithShortNames);
    expect(result).toHaveLength(1);
    expect(result[0].name).toBe('Teile');
  });

  it('matches "Kundenstamm" → "Kunde" via substring', () => {
    const result = lookupRelevantTables({ tables: ['Kundenstamm'], infosystems: [] }, tablesWithShortNames);
    expect(result).toHaveLength(1);
    expect(result[0].name).toBe('Kunde');
  });

  it('matches "Lieferantenstamm" → "Lieferant" via synonym', () => {
    const result = lookupRelevantTables({ tables: ['Lieferantenstamm'], infosystems: [] }, tablesWithShortNames);
    expect(result).toHaveLength(1);
    expect(result[0].name).toBe('Lieferant');
  });

  it('matches "Auftrag" → "Verkaufsauftrag" via synonym', () => {
    const result = lookupRelevantTables({ tables: ['Auftrag'], infosystems: [] }, tablesWithShortNames);
    expect(result).toHaveLength(1);
    expect(result[0].name).toBe('Verkaufsauftrag');
  });

  it('matches table ref directly (e.g. "2:1")', () => {
    const result = lookupRelevantTables({ tables: ['2:1'], infosystems: [] }, tablesWithShortNames);
    expect(result).toHaveLength(1);
    expect(result[0].name).toBe('Artikel');
  });
});

// ── buildMessagesWithFields ─────────────────────────────────────

describe('buildMessagesWithFields', () => {
  it('includes field names with descriptions', () => {
    const tables: TableDef[] = [{
      database: '0', group: '1', tableRef: '0:1', name: 'Kundenstamm',
      fields: [
        { name: 'such', description: 'Suchwort' },
        { name: 'name', description: 'Firmenname' },
      ],
      kind: 'database',
    }];
    const msgs = buildMessagesWithFields('Anforderung', tables);
    expect(msgs[1].content).toContain('such (Suchwort)');
    expect(msgs[1].content).toContain('name (Firmenname)');
  });

  it('includes table header with tableRef', () => {
    const tables: TableDef[] = [{
      database: '0', group: '1', tableRef: '0:1', name: 'Kundenstamm',
      fields: [{ name: 'such', description: 'SW' }],
      kind: 'database',
    }];
    const msgs = buildMessagesWithFields('Text', tables);
    expect(msgs[1].content).toContain('### Kundenstamm (0:1)');
  });

  it('uses infosystem header format', () => {
    const tables: TableDef[] = [{
      database: '', group: '', tableRef: 'UMSATZINFO', name: 'Umsatzauswertung',
      fields: [{ name: 'filter', description: 'Filter' }],
      kind: 'infosystem',
    }];
    const msgs = buildMessagesWithFields('Text', tables);
    expect(msgs[1].content).toContain('### Umsatzauswertung (Infosystem: UMSATZINFO)');
  });

  it('includes testUser note when provided', () => {
    const tables: TableDef[] = [{
      database: '0', group: '1', tableRef: '0:1', name: 'Kundenstamm',
      fields: [], kind: 'database',
    }];
    const msgs = buildMessagesWithFields('Text', tables, 'TESTUSER');
    expect(msgs[1].content).toContain('TESTUSER');
    expect(msgs[1].content).toContain('Background');
  });

  it('truncates fields beyond limit', () => {
    const manyFields = Array.from({ length: 200 }, (_, i) => ({
      name: `field${i}`,
      description: `Desc ${i}`,
    }));
    const tables: TableDef[] = [{
      database: '0', group: '1', tableRef: '0:1', name: 'Kundenstamm',
      fields: manyFields, kind: 'database',
    }];
    const msgs = buildMessagesWithFields('Text', tables);
    expect(msgs[1].content).toContain('field0');
    expect(msgs[1].content).toContain('field149');
    expect(msgs[1].content).not.toContain('field150');
    expect(msgs[1].content).toContain('und 50 weitere Felder');
  });

  it('includes instruction to use only listed field names', () => {
    const tables: TableDef[] = [{
      database: '0', group: '1', tableRef: '0:1', name: 'Kundenstamm',
      fields: [{ name: 'such', description: 'SW' }],
      kind: 'database',
    }];
    const msgs = buildMessagesWithFields('Text', tables);
    expect(msgs[1].content).toContain('NUR Feldnamen aus der obigen Liste');
  });

  it('handles fields without description', () => {
    const tables: TableDef[] = [{
      database: '0', group: '1', tableRef: '0:1', name: 'Kundenstamm',
      fields: [{ name: 'xyz', description: '' }],
      kind: 'database',
    }];
    const msgs = buildMessagesWithFields('Text', tables);
    // Should just show the field name without parentheses
    expect(msgs[1].content).toMatch(/\bxyz\b/);
    expect(msgs[1].content).not.toContain('xyz ()');
  });
});

// ── extractGherkin ──────────────────────────────────────────────

describe('extractGherkin', () => {
  it('extracts from gherkin code fence', () => {
    const text = '```gherkin\nFeature: Test\n  Scenario: S1\n```';
    expect(extractGherkin(text)).toBe('Feature: Test\n  Scenario: S1');
  });

  it('extracts from plain code fence', () => {
    const text = '```\nFeature: Test\n```';
    expect(extractGherkin(text)).toBe('Feature: Test');
  });

  it('returns trimmed text when no fence', () => {
    expect(extractGherkin('  Feature: Test  ')).toBe('Feature: Test');
  });
});

// ── extractPromptRating ────────────────────────────────────────

describe('extractPromptRating', () => {
  it('extracts score, reason and suggestions', () => {
    const text = `Feature: Test
  Scenario: S1
    Given step

PROMPT_RATING:75
Prozess gut beschrieben, aber Feldnamen fehlen.
EMPFEHLUNG:Konkrete Feldnamen angeben
EMPFEHLUNG:Erwartete Werte spezifizieren`;

    const { cleaned, rating } = extractPromptRating(text);
    expect(rating).not.toBeNull();
    expect(rating!.score).toBe(75);
    expect(rating!.reason).toBe('Prozess gut beschrieben, aber Feldnamen fehlen.');
    expect(rating!.suggestions).toEqual([
      'Konkrete Feldnamen angeben',
      'Erwartete Werte spezifizieren',
    ]);
    expect(cleaned).toContain('Feature: Test');
    expect(cleaned).not.toContain('PROMPT_RATING');
  });

  it('returns null when no rating present', () => {
    const { cleaned, rating } = extractPromptRating('Feature: Test\n  Scenario: S1');
    expect(rating).toBeNull();
    expect(cleaned).toBe('Feature: Test\n  Scenario: S1');
  });

  it('clamps score to 0-100', () => {
    const { rating } = extractPromptRating('PROMPT_RATING:150\nGut.');
    expect(rating!.score).toBe(100);
  });

  it('handles rating with no suggestions', () => {
    const { rating } = extractPromptRating('Feature: X\n\nPROMPT_RATING:90\nSehr gute Beschreibung.');
    expect(rating!.score).toBe(90);
    expect(rating!.suggestions).toEqual([]);
    expect(rating!.reason).toBe('Sehr gute Beschreibung.');
  });
});

// ── buildRatingMessages ────────────────────────────────────────

describe('buildRatingMessages', () => {
  it('returns system + user message', () => {
    const msgs = buildRatingMessages('Anforderungstext');
    expect(msgs).toHaveLength(2);
    expect(msgs[0].role).toBe('system');
    expect(msgs[1].role).toBe('user');
  });

  it('includes the description text in user message', () => {
    const msgs = buildRatingMessages('Mein Text hier');
    expect(msgs[1].content).toContain('Mein Text hier');
  });

  it('includes table context when provided', () => {
    const tables = [
      { name: 'Kundenstamm', tableRef: '0:1', kind: 'database' as const },
    ];
    const msgs = buildRatingMessages('Text', tables);
    expect(msgs[1].content).toContain('Kundenstamm');
    expect(msgs[1].content).toContain('0:1');
  });

  it('includes infosystems when provided', () => {
    const tables = [
      { name: 'Lagerjournal', tableRef: 'LJ', kind: 'infosystem' as const },
    ];
    const msgs = buildRatingMessages('Text', tables);
    expect(msgs[1].content).toContain('Lagerjournal');
    expect(msgs[1].content).toContain('Infosysteme');
  });

  it('requests JSON response in system prompt', () => {
    const msgs = buildRatingMessages('Text');
    expect(msgs[0].content).toContain('JSON');
  });
});

// ── parseRatingResponse ────────────────────────────────────────

describe('parseRatingResponse', () => {
  it('parses valid JSON', () => {
    const r = parseRatingResponse('{"score": 72, "reason": "Gut.", "suggestions": ["Mehr Details"], "inconsistencies": []}');
    expect(r).not.toBeNull();
    expect(r!.score).toBe(72);
    expect(r!.reason).toBe('Gut.');
    expect(r!.suggestions).toEqual(['Mehr Details']);
    expect(r!.inconsistencies).toEqual([]);
  });

  it('strips markdown code fences', () => {
    const r = parseRatingResponse('```json\n{"score": 80, "reason": "OK", "suggestions": []}\n```');
    expect(r).not.toBeNull();
    expect(r!.score).toBe(80);
  });

  it('clamps score to 0-100', () => {
    const r = parseRatingResponse('{"score": 150, "reason": "X", "suggestions": []}');
    expect(r!.score).toBe(100);
  });

  it('returns null for invalid JSON', () => {
    expect(parseRatingResponse('This is not JSON')).toBeNull();
  });

  it('returns null for missing score', () => {
    expect(parseRatingResponse('{"reason": "X", "suggestions": []}')).toBeNull();
  });

  it('handles missing inconsistencies field', () => {
    const r = parseRatingResponse('{"score": 60, "reason": "OK", "suggestions": ["A"]}');
    expect(r).not.toBeNull();
    expect(r!.inconsistencies).toEqual([]);
  });

  it('extracts JSON from surrounding text', () => {
    const r = parseRatingResponse('Here is my analysis:\n{"score": 55, "reason": "Vage", "suggestions": ["Details"]}');
    expect(r).not.toBeNull();
    expect(r!.score).toBe(55);
  });

  it('handles inconsistencies with content', () => {
    const r = parseRatingResponse('{"score": 40, "reason": "Probleme", "suggestions": ["Fix"], "inconsistencies": ["Feld X widerspricht Y"]}');
    expect(r!.inconsistencies).toEqual(['Feld X widerspricht Y']);
  });
});
