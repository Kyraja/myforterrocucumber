import { useState } from 'react';
import { createPortal } from 'react-dom';
import type { TableDef } from '../../types/gherkin';
import type { FopBinding } from '../../types/fop';
import type { IsBinding } from '../../lib/isBindingsParser';
import type { KBDocument } from '../../types/knowledgeBase';
import styles from './WorkspaceSwitchModal.module.css';

export interface WorkspaceSwitchPayload {
  fromName: string;
  toName: string;
  tables: TableDef[];
  fopBindings: FopBinding[];
  isBindings: IsBinding[];
  kbDocuments: KBDocument[];
  learnings: number;
  hasSettings: boolean;
}

export interface WorkspaceSwitchSelection {
  tables: boolean;
  fopBindings: boolean;
  isBindings: boolean;
  kbDocuments: boolean;
  learnings: boolean;
  settings: boolean;
}

interface Props {
  payload: WorkspaceSwitchPayload;
  onConfirm: (sel: WorkspaceSwitchSelection) => void;
  onClear: () => void;
}

export function WorkspaceSwitchModal({ payload, onConfirm, onClear }: Props) {
  const { fromName, toName, tables, fopBindings, isBindings, kbDocuments } = payload;
  const [sel, setSel] = useState<WorkspaceSwitchSelection>({
    tables: tables.length > 0,
    fopBindings: fopBindings.length > 0,
    isBindings: isBindings.length > 0,
    kbDocuments: kbDocuments.length > 0,
    learnings: payload.learnings > 0,
    settings: payload.hasSettings,
  });

  const toggle = (key: keyof WorkspaceSwitchSelection) =>
    setSel((prev) => ({ ...prev, [key]: !prev[key] }));

  const hasAny = sel.tables || sel.fopBindings || sel.isBindings || sel.kbDocuments || sel.learnings || sel.settings;

  const rows: Array<{ key: keyof WorkspaceSwitchSelection; label: string; count: number; sub?: string }> = [
    { key: 'tables', label: 'Variablentabellen', count: tables.length, sub: `${tables.filter(t => t.kind === 'database').length} DB · ${tables.filter(t => t.kind === 'infosystem').length} IS` },
    { key: 'fopBindings', label: 'FOP-Bindings', count: fopBindings.length },
    { key: 'isBindings', label: 'IS-Anbindungen', count: isBindings.length },
    { key: 'kbDocuments', label: 'Wissensdatenbank', count: kbDocuments.length, sub: `${kbDocuments.length} Docs` },
    { key: 'learnings', label: 'Learnings', count: payload.learnings, sub: `${payload.learnings} Einträge` },
    { key: 'settings', label: 'Einstellungen', count: payload.hasSettings ? 1 : 0, sub: 'Modell, Prompts, Optionen' },
  ].filter(r => r.count > 0);

  return createPortal(
    <div className={styles.overlay} onClick={onClear}>
      <div className={styles.dialog} onClick={(e) => e.stopPropagation()}>
        <div className={styles.header}>
          <span className={styles.title}>📂 Neuer Workspace</span>
        </div>
        <div className={styles.body}>
          <p className={styles.message}>
            <strong>{toName}</strong> hat noch keine Daten.
            Sollen Daten aus <strong>{fromName}</strong> übernommen werden?
          </p>
          <div className={styles.checklist}>
            {rows.map(({ key, label, count, sub }) => (
              <label key={key} className={styles.checkRow}>
                <input
                  type="checkbox"
                  checked={sel[key]}
                  onChange={() => toggle(key)}
                />
                <span className={styles.checkLabel}>{label}</span>
                <span className={styles.checkCount}>{sub ?? `${count}`}</span>
              </label>
            ))}
          </div>
        </div>
        <div className={styles.footer}>
          <button className={styles.clearBtn} type="button" onClick={onClear}>
            Leer starten
          </button>
          <button
            className={styles.confirmBtn}
            type="button"
            disabled={!hasAny}
            onClick={() => onConfirm(sel)}
            autoFocus
          >
            Übernehmen
          </button>
        </div>
      </div>
    </div>,
    document.body,
  );
}
