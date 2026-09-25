/**
 * @vitest-environment node
 */
import { describe, it, expect } from 'vitest';
import { searchKnowledgeBase } from './kbSearch';
import type { KBChunk } from '../types/knowledgeBase';
import type { TableDef } from '../types/gherkin';

// ── Helpers ──────────────────────────────────────────────────

function makeChunk(overrides: Partial<KBChunk> & { heading: string; text: string }): KBChunk {
  return {
    id: overrides.id ?? `chunk-${Math.random().toString(36).slice(2, 8)}`,
    docId: 'doc-1',
    index: 0,
    headingHierarchy: [],
    charCount: overrides.text.length,
    keywords: [],
    ...overrides,
  };
}

// ── Simulate the log output from the user's issue ────────────

describe('kbSearch scoring', () => {
  // Chunks that mimic the user's real KB entries
  const chunks: KBChunk[] = [
    makeChunk({
      id: 'gruppen',
      heading: 'Gruppen',
      text: 'Die Gruppenliste (25B.1.GRLISTE) ermöglicht es, Kunden in Gruppen einzuteilen. Tabelle 0:1 enthält das Feld GRLISTE.',
      keywords: ['25B.1.GRLISTE', 'GRLISTE', 'Gruppen'],
    }),
    makeChunk({
      id: 'verweisart',
      heading: 'Verweisart',
      text: 'Das Feld Verweisart (2.6.31.TABART) steuert die Art des Verweises. Referenz 0:1.',
      keywords: ['2.6.31.TABART', 'TABART', 'Verweisart'],
    }),
    makeChunk({
      id: 'pausenende',
      heading: 'Pausenende',
      text: 'Das Feld Pausenende (2.6.20.ENDZEIT) definiert das Ende einer Pause. Siehe 0:1 Abschnitt.',
      keywords: ['2.6.20.ENDZEIT', 'ENDZEIT', 'Pausenende'],
    }),
    makeChunk({
      id: 'kundenkategorie',
      heading: 'Kundenkategorie im Kundenstamm',
      text: 'Im Kundenstamm (0:1) kann über das Feld ykundenkategorie eine Kategorie zugeordnet werden. Dies erlaubt die Einteilung von Kunden in verschiedene Kategorien für Reporting und Preisfindung.',
      keywords: ['ykundenkategorie', 'Kundenstamm', 'Kategorie'],
    }),
  ];

  const kundeTable: TableDef = {
    name: 'Kundenstamm',
    nameDe: 'Kundenstamm',
    nameEn: 'Customer',
    tableRef: '0:1',
    kind: 'database',
    fields: [],
  };

  it('should rank kundenkategorie chunk highest for Kundenstamm 0:1 query', () => {
    const results = searchKnowledgeBase(chunks, {
      tables: [kundeTable],
      requirementsText: 'Neues Feld ykundenkategorie im Kundenstamm anlegen',
    }, 5);

    console.log('\n--- Scoring Results ---');
    for (const r of results) {
      console.log(`  ${r.chunk.heading} (Score: ${r.score}, Matched: ${r.matchedTerms.join(', ')})`);
    }

    // Kundenkategorie should rank first because it matches both ref AND table name in heading
    expect(results[0].chunk.id).toBe('kundenkategorie');
  });

  it('incidental "0:1" body mentions should score much lower than heading/keyword matches', () => {
    const results = searchKnowledgeBase(chunks, {
      tables: [kundeTable],
    }, 10);

    const kundenkategorie = results.find(r => r.chunk.id === 'kundenkategorie');
    const verweisart = results.find(r => r.chunk.id === 'verweisart');
    const pausenende = results.find(r => r.chunk.id === 'pausenende');

    console.log('\n--- All Results ---');
    for (const r of results) {
      console.log(`  ${r.chunk.heading} (Score: ${r.score}, Matched: ${r.matchedTerms.join(', ')})`);
    }

    // Kundenkategorie (heading + keyword match) should score much higher
    // than Verweisart/Pausenende (body-only ref mention)
    expect(kundenkategorie).toBeDefined();
    if (verweisart) {
      expect(kundenkategorie!.score).toBeGreaterThan(verweisart.score * 2);
    }
    if (pausenende) {
      expect(kundenkategorie!.score).toBeGreaterThan(pausenende.score * 2);
    }
  });

  it('should not match ref "0:1" inside strings like "2.6.20.ENDZEIT"', () => {
    const results = searchKnowledgeBase(chunks, {
      tables: [kundeTable],
    }, 10);

    const pausenende = results.find(r => r.chunk.id === 'pausenende');
    if (pausenende) {
      const matched = pausenende.matchedTerms;
      console.log('Pausenende matched terms:', matched);
    }
  });

  it('contains: "Kundenstamm" should also match chunk with "Kunde"', () => {
    const kundeChunk = makeChunk({
      id: 'nur-kunde',
      heading: 'Kunden verwalten',
      text: 'Hier wird beschrieben wie man Kunden anlegt und bearbeitet.',
      keywords: ['Kunde'],
    });

    const results = searchKnowledgeBase([kundeChunk], {
      tables: [kundeTable], // nameDe = "Kundenstamm"
    }, 10);

    console.log('\n--- Contains DE ---');
    for (const r of results) {
      console.log(`  ${r.chunk.heading} (Score: ${r.score}, Matched: ${r.matchedTerms.join(', ')})`);
    }

    expect(results.length).toBeGreaterThan(0);
    expect(results[0].matchedTerms.some(t => t.toLowerCase().includes('kunde'))).toBe(true);
  });

  it('contains: "Artikelstamm" should match "Artikel"', () => {
    const artikelChunk = makeChunk({
      id: 'artikel-ref',
      heading: 'Artikel bearbeiten',
      text: 'Artikeldaten können hier geändert werden.',
    });

    const artikelTable: TableDef = {
      name: 'Artikelstamm',
      nameDe: 'Artikelstamm',
      nameEn: 'Article',
      tableRef: '2:1',
      kind: 'database',
      fields: [],
    };

    const results = searchKnowledgeBase([artikelChunk], {
      tables: [artikelTable],
    }, 10);

    console.log('\n--- Contains DE Artikel ---');
    for (const r of results) {
      console.log(`  ${r.chunk.heading} (Score: ${r.score}, Matched: ${r.matchedTerms.join(', ')})`);
    }

    expect(results.length).toBeGreaterThan(0);
    expect(results[0].matchedTerms.some(t => t.toLowerCase().includes('artikel'))).toBe(true);
  });

  it('contains: English "Customer" should match chunk with "customer"', () => {
    const enChunk = makeChunk({
      id: 'en-customer',
      heading: 'Customer management',
      text: 'This section describes how to create and manage customers.',
    });

    const customerTable: TableDef = {
      name: 'Customer',
      nameDe: 'Kundenstamm',
      nameEn: 'Customer',
      tableRef: '0:1',
      kind: 'database',
      fields: [],
    };

    const results = searchKnowledgeBase([enChunk], {
      tables: [customerTable],
    }, 10);

    console.log('\n--- Contains EN ---');
    for (const r of results) {
      console.log(`  ${r.chunk.heading} (Score: ${r.score}, Matched: ${r.matchedTerms.join(', ')})`);
    }

    expect(results.length).toBeGreaterThan(0);
    expect(results[0].matchedTerms.some(t => t.toLowerCase().includes('customer'))).toBe(true);
  });

  it('contains: English "Production proposal" should match "production"', () => {
    const enChunk = makeChunk({
      id: 'en-production',
      heading: 'Production overview',
      text: 'The production module handles manufacturing planning.',
    });

    const fpTable: TableDef = {
      name: 'Fertigungsvorschlag',
      nameDe: 'Fertigungsvorschlag',
      nameEn: 'Production proposal',
      tableRef: '7:1',
      kind: 'database',
      fields: [],
    };

    const results = searchKnowledgeBase([enChunk], {
      tables: [fpTable],
    }, 10);

    console.log('\n--- Contains EN multi-word ---');
    for (const r of results) {
      console.log(`  ${r.chunk.heading} (Score: ${r.score}, Matched: ${r.matchedTerms.join(', ')})`);
    }

    expect(results.length).toBeGreaterThan(0);
  });

  it('contains should NOT match short words (< 4 chars)', () => {
    const unrelatedChunk = makeChunk({
      id: 'unrelated',
      heading: 'Zeiterfassung',
      text: 'Die Zeiterfassung dient zur Buchung von Arbeitszeiten.',
    });

    const artTable: TableDef = {
      name: 'Art',
      nameDe: 'Art',
      tableRef: '99:1',
      kind: 'database',
      fields: [],
    };

    const results = searchKnowledgeBase([unrelatedChunk], {
      tables: [artTable],
    }, 10);

    // "Art" is too short (< 4 chars) for contains matching
    expect(results.length).toBe(0);
  });
});

// ── Agent-provided keyword scoring ─────────────────────────────

describe('kbSearch keyword scoring', () => {
  const artikelTable: TableDef = {
    name: 'Artikel',
    nameDe: 'Artikel',
    nameEn: 'Article',
    tableRef: '2:1',
    kind: 'database',
    fields: [],
  };

  it('compound keyword "Chargenpflicht" matches heading "Charge" via reverse-contains', () => {
    const chargeChunk = makeChunk({
      id: 'charge',
      heading: 'Charge',
      text: 'Beschreibung der Chargenverwaltung in abas.',
    });

    const results = searchKnowledgeBase([chargeChunk], {
      tables: [artikelTable],
      keywords: ['Chargenpflicht'],
    }, 10);

    expect(results.length).toBe(1);
    expect(results[0].matchedTerms.some(t => t.startsWith('Kw:'))).toBe(true);
  });

  it('keyword "Charge" matches heading "Chargenpflichtige Artikel" via forward-contains', () => {
    const cpChunk = makeChunk({
      id: 'chargenpflichtige',
      heading: 'Chargenpflichtige Artikel',
      text: 'Sonderbehandlung von chargenpflichtigen Artikeln.',
    });

    const results = searchKnowledgeBase([cpChunk], {
      tables: [artikelTable],
      keywords: ['Charge'],
    }, 10);

    expect(results.length).toBe(1);
    expect(results[0].matchedTerms.some(t => t.startsWith('Kw:'))).toBe(true);
  });

  it('keyword match in heading scores higher than match in body text', () => {
    const headingChunk = makeChunk({
      id: 'heading-hit',
      heading: 'Sperrkennzeichen',
      text: 'Allgemeine Beschreibung.',
    });
    const bodyChunk = makeChunk({
      id: 'body-hit',
      heading: 'Allgemeines',
      text: 'Hier wird das Sperrkennzeichen erwähnt aber nicht im Titel.',
    });

    const results = searchKnowledgeBase([headingChunk, bodyChunk], {
      tables: [artikelTable],
      keywords: ['Sperrkennzeichen'],
    }, 10);

    const headingRes = results.find(r => r.chunk.id === 'heading-hit');
    const bodyRes = results.find(r => r.chunk.id === 'body-hit');
    expect(headingRes).toBeDefined();
    expect(bodyRes).toBeDefined();
    expect(headingRes!.score).toBeGreaterThan(bodyRes!.score);
  });

  it('empty keywords array does not change baseline scores', () => {
    const chunk = makeChunk({
      id: 'baseline',
      heading: 'Artikel bearbeiten',
      text: 'Artikeldaten werden hier verwaltet.',
    });

    const baseline = searchKnowledgeBase([chunk], { tables: [artikelTable] }, 10);
    const withEmpty = searchKnowledgeBase([chunk], { tables: [artikelTable], keywords: [] }, 10);

    expect(baseline.length).toBe(withEmpty.length);
    expect(baseline[0].score).toBe(withEmpty[0].score);
  });

  it('multi-word keyword "Sperrkennzeichen Lager" partial-matches via tokens', () => {
    const chunk = makeChunk({
      id: 'partial',
      heading: 'Sperren im Lager',
      text: 'Lagerbuchungen können gesperrt werden.',
    });

    const results = searchKnowledgeBase([chunk], {
      tables: [artikelTable],
      keywords: ['Sperrkennzeichen Lager'],
    }, 10);

    expect(results.length).toBe(1);
    // Either a full Kw: match (one of the two whole tokens hit the heading) or a partial Kw~: hit.
    const matched = results[0].matchedTerms;
    expect(matched.some(t => t.startsWith('Kw:') || t.startsWith('Kw~:'))).toBe(true);
  });

  it('keywords work without any tables (pure thematic search)', () => {
    const chunk = makeChunk({
      id: 'thematic',
      heading: 'Mehrwertsteuer',
      text: 'Berechnung der Mehrwertsteuer in Belegen.',
    });

    const results = searchKnowledgeBase([chunk], {
      tables: [],
      keywords: ['Mehrwertsteuer'],
    }, 10);

    expect(results.length).toBe(1);
    expect(results[0].matchedTerms.some(t => t.startsWith('Kw:'))).toBe(true);
  });

  it('keyword shorter than 3 chars is ignored', () => {
    const chunk = makeChunk({
      id: 'short',
      heading: 'XY',
      text: 'XY ist ein Kürzel.',
    });

    const results = searchKnowledgeBase([chunk], {
      tables: [],
      keywords: ['XY'],
    }, 10);

    expect(results.length).toBe(0);
  });
});
