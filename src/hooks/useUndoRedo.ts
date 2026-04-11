/**
 * @module useUndoRedo
 * Generic undo/redo state manager with debounced history recording and
 * global keyboard shortcut support (Ctrl+Z / Ctrl+Y / Ctrl+Shift+Z).
 *
 * Designed to wrap the entire FeatureInput state so that every structural
 * change (add/remove scenario, reorder steps, etc.) is undoable without
 * flooding the history with every individual keystroke.
 */

import { useState, useCallback, useEffect, useRef } from 'react';

/** Internal three-stack representation used by the hook. */
interface UndoRedoState<T> {
  past: T[];
  present: T;
  future: T[];
}

/** Maximum number of undo steps retained in each direction. */
const MAX_HISTORY = 50;

/**
 * Generic undo/redo state hook with 400 ms debounce.
 *
 * Rapid changes (e.g. typing) are batched: the UI is updated immediately for
 * responsiveness, but the previous state is only pushed onto the history stack
 * after the user pauses for 400 ms. This prevents every character from
 * consuming an undo step.
 *
 * Keyboard shortcuts (Ctrl+Z, Ctrl+Y, Ctrl+Shift+Z) are registered globally
 * on `window` and cleaned up automatically on unmount.
 *
 * @param initial - The initial value to start with.
 * @returns An object exposing `value`, `set`, `undo`, `redo`, `canUndo`, `canRedo`.
 */
export function useUndoRedo<T>(initial: T) {
  const [state, setState] = useState<UndoRedoState<T>>({
    past: [],
    present: initial,
    future: [],
  });

  // Debounce: batch rapid changes (typing) into one undo step
  const timerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const pendingRef = useRef<T | null>(null);

  const flushPending = useCallback(() => {
    if (pendingRef.current === null) return;
    const pending = pendingRef.current;
    pendingRef.current = null;
    setState((s) => ({
      past: [...s.past, s.present].slice(-MAX_HISTORY),
      present: pending,
      future: [],
    }));
  }, []);

  const set = useCallback((valueOrUpdater: T | ((prev: T) => T)) => {
    if (timerRef.current) clearTimeout(timerRef.current);
    // Immediately update present for UI responsiveness, but don't push to past yet.
    // Side effects (setTimeout) are kept outside the updater to be safe in Strict Mode.
    setState((s) => {
      const newValue = typeof valueOrUpdater === 'function'
        ? (valueOrUpdater as (prev: T) => T)(s.present)
        : valueOrUpdater;
      pendingRef.current = newValue;
      return { ...s, present: newValue };
    });
    timerRef.current = setTimeout(flushPending, 400);
  }, [flushPending]);

  const undo = useCallback(() => {
    // Flush any pending debounced change first
    if (timerRef.current) {
      clearTimeout(timerRef.current);
      timerRef.current = null;
    }
    if (pendingRef.current !== null) {
      pendingRef.current = null;
    }
    setState((s) => {
      if (s.past.length === 0) return s;
      const prev = s.past[s.past.length - 1];
      return {
        past: s.past.slice(0, -1),
        present: prev,
        future: [s.present, ...s.future].slice(0, MAX_HISTORY),
      };
    });
  }, []);

  const redo = useCallback(() => {
    setState((s) => {
      if (s.future.length === 0) return s;
      const next = s.future[0];
      return {
        past: [...s.past, s.present].slice(-MAX_HISTORY),
        present: next,
        future: s.future.slice(1),
      };
    });
  }, []);

  const canUndo = state.past.length > 0;
  const canRedo = state.future.length > 0;

  // Keyboard shortcuts: Ctrl+Z / Ctrl+Y
  useEffect(() => {
    const handler = (e: KeyboardEvent) => {
      if ((e.ctrlKey || e.metaKey) && e.key === 'z' && !e.shiftKey) {
        e.preventDefault();
        undo();
      }
      if ((e.ctrlKey || e.metaKey) && (e.key === 'y' || (e.key === 'z' && e.shiftKey))) {
        e.preventDefault();
        redo();
      }
    };
    window.addEventListener('keydown', handler);
    return () => window.removeEventListener('keydown', handler);
  }, [undo, redo]);

  return { value: state.present, set, undo, redo, canUndo, canRedo };
}
