import { useState, useRef, useCallback } from 'react';
import type { WorkPackage, WorkPackageResult, FeatureInput, TableDef } from '../types/gherkin';
import { chatCompletion, isLoggedIn } from '../lib/myforterroApi';
import {
  buildMessages,
  identifyTablesLocally,
  buildTableIdentificationMessages,
  parseTableIdentificationResponse,
  lookupRelevantTables,
  buildMessagesWithFields,
  extractGherkin,
} from '../lib/aiPrompt';
import { parseGherkin } from '../lib/gherkinParser';
import { generateGherkin } from '../lib/generator';
import { resolveTableRefs } from '../lib/resolveTableRefs';

const DELAY_MS = 1_000;

async function generateOne(
  wp: WorkPackage,
  model: string,
  testUser: string,
  tables: TableDef[],
): Promise<{ feature: FeatureInput; gherkin: string }> {
  if (!isLoggedIn()) throw new Error('Nicht eingeloggt. Bitte zuerst anmelden.');

  let messages: { role: 'system' | 'user'; content: string }[];

  // Local table identification first, AI fallback if nothing found
  const tablesWithFields = tables.filter((t) => t.fields.length > 0);

  if (tablesWithFields.length > 0) {
    let relevantTables = identifyTablesLocally(wp.description, tablesWithFields);

    // Fallback: if local matching found nothing, ask AI (handles typos, implicit references)
    if (relevantTables.length === 0) {
      const step1Messages = buildTableIdentificationMessages(wp.description, tables);
      const step1Response = await chatCompletion(step1Messages, model);
      const identified = parseTableIdentificationResponse(step1Response);
      relevantTables = lookupRelevantTables(identified, tablesWithFields);
    }

    if (relevantTables.length > 0) {
      messages = buildMessagesWithFields(wp.description, relevantTables, testUser || undefined);
    } else {
      messages = buildMessages(wp.description, testUser || undefined, tables);
    }
  } else {
    messages = buildMessages(wp.description, testUser || undefined, tables);
  }

  const response = await chatCompletion(messages, model);
  const raw = extractGherkin(response);
  let parsed = parseGherkin(raw);

  // Resolve name-based table refs to numeric refs from loaded Variablentabelle
  if (tables.length > 0) {
    parsed = resolveTableRefs(parsed, tables);
  }

  if (parsed.scenarios.length === 0) {
    throw new Error('Keine Szenarien in der KI-Antwort.');
  }

  const feature: FeatureInput = {
    ...parsed,
    name: parsed.name || wp.title,
    description: wp.description,
    testUser,
  };
  const gherkin = generateGherkin(feature);
  return { feature, gherkin };
}

interface UseBulkGenerationResult {
  results: WorkPackageResult[];
  isRunning: boolean;
  currentIndex: number;
  initResults: (packages: WorkPackage[]) => void;
  startGeneration: (packages: WorkPackage[], model: string, testUser: string, tables: TableDef[]) => void;
  cancelGeneration: () => void;
  retryItem: (index: number, model: string, testUser: string, tables: TableDef[]) => void;
  reset: () => void;
}

export function useBulkGeneration(): UseBulkGenerationResult {
  const [results, setResults] = useState<WorkPackageResult[]>([]);
  const [isRunning, setIsRunning] = useState(false);
  const [currentIndex, setCurrentIndex] = useState(-1);
  const cancelRef = useRef(false);
  const resultsRef = useRef<WorkPackageResult[]>([]);

  const initResults = useCallback((packages: WorkPackage[]) => {
    const initial: WorkPackageResult[] = packages.map((wp) => ({
      workPackage: wp,
      status: 'pending' as const,
      feature: null,
      gherkin: '',
      error: null,
    }));
    setResults(initial);
    resultsRef.current = initial;
  }, []);

  const startGeneration = useCallback(
    async (packages: WorkPackage[], model: string, testUser: string, tables: TableDef[]) => {
      cancelRef.current = false;
      setIsRunning(true);

      const initial: WorkPackageResult[] = packages.map((wp) => ({
        workPackage: wp,
        status: 'pending',
        feature: null,
        gherkin: '',
        error: null,
      }));
      setResults(initial);
      resultsRef.current = initial;

      for (let i = 0; i < packages.length; i++) {
        if (cancelRef.current) break;

        setCurrentIndex(i);
        setResults((prev) => {
          const next = prev.map((r, j) =>
            j === i ? { ...r, status: 'generating' as const } : r,
          );
          resultsRef.current = next;
          return next;
        });

        try {
          const { feature, gherkin } = await generateOne(packages[i], model, testUser, tables);
          setResults((prev) => {
            const next = prev.map((r, j) =>
              j === i ? { ...r, status: 'done' as const, feature, gherkin, error: null } : r,
            );
            resultsRef.current = next;
            return next;
          });
        } catch (err) {
          setResults((prev) => {
            const next = prev.map((r, j) =>
              j === i
                ? { ...r, status: 'error' as const, error: err instanceof Error ? err.message : 'Unbekannter Fehler' }
                : r,
            );
            resultsRef.current = next;
            return next;
          });
        }

        // Delay between calls (except last)
        if (i < packages.length - 1 && !cancelRef.current) {
          await new Promise((resolve) => setTimeout(resolve, DELAY_MS));
        }
      }

      setIsRunning(false);
      setCurrentIndex(-1);
    },
    [],
  );

  const cancelGeneration = useCallback(() => {
    cancelRef.current = true;
  }, []);

  const retryItem = useCallback(
    async (index: number, model: string, testUser: string, tables: TableDef[]) => {
      const wp = resultsRef.current[index]?.workPackage;
      if (!wp) return;

      setResults((prev) => {
        const next = prev.map((r, j) =>
          j === index ? { ...r, status: 'generating' as const, error: null } : r,
        );
        resultsRef.current = next;
        return next;
      });

      try {
        const { feature, gherkin } = await generateOne(wp, model, testUser, tables);
        setResults((prev) => {
          const next = prev.map((r, j) =>
            j === index ? { ...r, status: 'done' as const, feature, gherkin, error: null } : r,
          );
          resultsRef.current = next;
          return next;
        });
      } catch (err) {
        setResults((prev) => {
          const next = prev.map((r, j) =>
            j === index
              ? { ...r, status: 'error' as const, error: err instanceof Error ? err.message : 'Unbekannter Fehler' }
              : r,
          );
          resultsRef.current = next;
          return next;
        });
      }
    },
    [],
  );

  const reset = useCallback(() => {
    cancelRef.current = true;
    setResults([]);
    resultsRef.current = [];
    setIsRunning(false);
    setCurrentIndex(-1);
  }, []);

  return { results, isRunning, currentIndex, initResults, startGeneration, cancelGeneration, retryItem, reset };
}
