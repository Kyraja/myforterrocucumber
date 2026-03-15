import { useState, useCallback, useEffect, useRef } from 'react';

interface UndoRedoState<T> {
  past: T[];
  present: T;
  future: T[];
}

const MAX_HISTORY = 50;

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
    // Immediately update present for UI responsiveness, but don't push to past yet
    setState((s) => {
      const newValue = typeof valueOrUpdater === 'function'
        ? (valueOrUpdater as (prev: T) => T)(s.present)
        : valueOrUpdater;
      pendingRef.current = newValue;
      timerRef.current = setTimeout(flushPending, 400);
      return { ...s, present: newValue };
    });
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
