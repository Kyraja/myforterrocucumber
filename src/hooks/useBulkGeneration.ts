/**
 * @module useBulkGeneration
 * Hook that drives sequential AI generation for a list of work packages.
 *
 * Work packages are processed one by one (not in parallel) to avoid overwhelming
 * the myForterro API. A configurable inter-call delay ({@link DELAY_MS}) further
 * reduces rate-limit pressure. Individual items can be retried independently
 * after failure without restarting the entire batch.
 */

import { useState, useRef, useCallback } from 'react';
import type { WorkPackage, WorkPackageResult, FeatureInput, TableDef } from '../types/gherkin';
import { generatePackage } from '../lib/generatePackage';
import { generateGherkin } from '../lib/generator';

/** Milliseconds to wait between successive AI calls to avoid rate limiting. */
const DELAY_MS = 1_000;

/**
 * Generate a single work package: calls the AI, merges the result with the
 * work-package metadata, and renders the final Gherkin string.
 *
 * Intentionally kept outside the hook so it has no closure over React state —
 * making it easier to reason about and test in isolation.
 */
async function generateOne(
  wp: WorkPackage,
  model: string,
  testUser: string,
  tables: TableDef[],
  lang: 'de' | 'en' = 'de',
): Promise<{ feature: FeatureInput; gherkin: string }> {
  const result = await generatePackage({
    text: wp.description,
    model,
    tables,
    testUser: testUser || undefined,
    featureName: wp.title,
    lang,
  });

  const feature: FeatureInput = {
    ...result.feature,
    name: result.feature.name || wp.title,
    description: wp.description,
    testUser,
  };
  const gherkin = generateGherkin(feature);
  return { feature, gherkin };
}

/** Return value of {@link useBulkGeneration}. */
interface UseBulkGenerationResult {
  /** Per-package generation results in original order. */
  results: WorkPackageResult[];
  /** True while the sequential generation loop is active. */
  isRunning: boolean;
  /** Index of the package currently being generated, or `-1` when idle. */
  currentIndex: number;
  /** Pre-populate results with `pending` entries before starting generation. */
  initResults: (packages: WorkPackage[]) => void;
  /** Start processing all packages sequentially; resets previous results. */
  startGeneration: (packages: WorkPackage[], model: string, testUser: string, tables: TableDef[], lang?: 'de' | 'en') => void;
  /** Signal the running loop to stop after the current package completes. */
  cancelGeneration: () => void;
  /** Re-run generation for a single failed or pending item by index. */
  retryItem: (index: number, model: string, testUser: string, tables: TableDef[], lang?: 'de' | 'en') => void;
  /** Clear all results and stop any in-progress generation. */
  reset: () => void;
}

/**
 * Hook for batch AI generation of multiple work packages.
 *
 * Uses a `cancelRef` (not state) for cancellation so that a flag flip takes
 * effect immediately without triggering a re-render. A parallel `resultsRef`
 * mirrors the `results` state so that async callbacks always have the latest
 * snapshot without stale closures.
 *
 * @returns {@link UseBulkGenerationResult}
 */
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
    async (packages: WorkPackage[], model: string, testUser: string, tables: TableDef[], lang: 'de' | 'en' = 'de') => {
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
          const { feature, gherkin } = await generateOne(packages[i], model, testUser, tables, lang);
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
    async (index: number, model: string, testUser: string, tables: TableDef[], lang: 'de' | 'en' = 'de') => {
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
        const { feature, gherkin } = await generateOne(wp, model, testUser, tables, lang);
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
