import { useState, useRef } from 'react';
import type { FeatureInput, WorkPackage, TableDef } from '../../types/gherkin';
import { parseWorkPackageXlsx } from '../../lib/workPackageParser';
import { downloadExampleXlsx } from '../../lib/exampleWorkPackages';
import { downloadFeatureFile } from '../../lib/download';
import { downloadAllAsZip } from '../../lib/zipDownload';
import { isLoggedIn } from '../../lib/myforterroApi';
import { useBulkGeneration } from '../../hooks/useBulkGeneration';
import { useTranslation } from '../../i18n';
import styles from './BulkImport.module.css';

interface BulkImportProps {
  model: string;
  testUser: string;
  tables: TableDef[];
  onLoadToEditor: (feature: FeatureInput) => void;
}

export function BulkImport({ model, testUser, tables, onLoadToEditor }: BulkImportProps) {
  const { t } = useTranslation();
  const [packages, setPackages] = useState<WorkPackage[]>([]);
  const [bulkTestUser, setBulkTestUser] = useState(testUser);
  const fileRef = useRef<HTMLInputElement>(null);

  const { results, isRunning, currentIndex, initResults, startGeneration, cancelGeneration, retryItem, reset } =
    useBulkGeneration();

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    const buffer = await file.arrayBuffer();
    const parsed = parseWorkPackageXlsx(buffer);
    setPackages(parsed);
    initResults(parsed);

    // Reset file input so the same file can be re-uploaded
    if (fileRef.current) fileRef.current.value = '';
  };

  const handleStart = () => {
    if (packages.length === 0 || !isLoggedIn()) return;
    startGeneration(packages, model, bulkTestUser, tables);
  };

  const handleDownloadOne = (index: number) => {
    const r = results[index];
    if (!r || r.status !== 'done') return;
    const name = r.feature?.name || r.workPackage.title || 'feature';
    downloadFeatureFile(r.gherkin, name);
  };

  const handleDownloadAll = async () => {
    await downloadAllAsZip(results);
  };

  const handleClear = () => {
    reset();
    setPackages([]);
  };

  const doneCount = results.filter((r) => r.status === 'done').length;
  const hasResults = results.length > 0;
  const apiKeySet = isLoggedIn();

  // Use results for display if generation has been triggered, otherwise show raw packages
  const displayItems = hasResults ? results : null;

  return (
    <div className={styles.container}>
      {/* Toolbar: Upload + Example */}
      <div className={styles.toolbar}>
        <button
          className={styles.uploadBtn}
          onClick={() => fileRef.current?.click()}
          type="button"
        >
          {t('bulk.uploadXlsx')}
        </button>
        <input
          ref={fileRef}
          className={styles.fileInput}
          type="file"
          accept=".xlsx,.xls"
          onChange={handleFileChange}
        />
        <button
          className={styles.exampleBtn}
          onClick={downloadExampleXlsx}
          type="button"
        >
          {t('bulk.downloadExample')}
        </button>
        {packages.length > 0 && (
          <>
            <span className={styles.info}>
              {packages.length} {t('bulk.packagesLoaded')}
            </span>
            <button className={styles.clearBtn} onClick={handleClear} type="button">
              &times;
            </button>
          </>
        )}
      </div>

      {/* Empty state */}
      {packages.length === 0 && (
        <div className={styles.emptyState}>
          <div className={styles.emptyTitle}>{t('bulk.importTitle')}</div>
          <div className={styles.emptyText}>
            {t('bulk.importDesc')}
            <br />
            {t('bulk.importColumns')}
          </div>
          <button
            className={styles.exampleBtn}
            onClick={downloadExampleXlsx}
            type="button"
          >
            {t('bulk.downloadExampleBtn')}
          </button>
        </div>
      )}

      {/* Controls + Table */}
      {packages.length > 0 && (
        <>
          <div className={styles.controls}>
            <input
              className={styles.testUserInput}
              type="text"
              value={bulkTestUser}
              onChange={(e) => setBulkTestUser(e.target.value)}
              placeholder={t('bulk.testUserPlaceholder')}
            />
            {!isRunning ? (
              <button
                className={styles.startBtn}
                onClick={handleStart}
                disabled={!apiKeySet}
                type="button"
              >
                {t('bulk.generateAll')}
              </button>
            ) : (
              <button className={styles.cancelBtn} onClick={cancelGeneration} type="button">
                {t('bulk.cancel')}
              </button>
            )}
            {isRunning && (
              <span className={styles.progress}>
                {t('bulk.progress', { current: currentIndex + 1, total: packages.length })}
              </span>
            )}
            {doneCount > 0 && (
              <button className={styles.zipBtn} onClick={handleDownloadAll} type="button">
                {t('bulk.downloadZip', { done: doneCount, total: results.length })}
              </button>
            )}
          </div>

          <table className={styles.table}>
            <thead>
              <tr>
                <th className={styles.statusCell}></th>
                <th>{t('bulk.colTitle')}</th>
                <th>{t('bulk.colArea')}</th>
                <th>{t('bulk.colPrio')}</th>
                <th>{t('bulk.colTime')}</th>
                <th>{t('bulk.colActions')}</th>
              </tr>
            </thead>
            <tbody>
              {packages.map((wp, i) => {
                const result = displayItems?.[i];
                const status = result?.status ?? 'pending';

                return (
                  <tr key={wp.id}>
                    <td className={styles.statusCell}>
                      <StatusBadge status={status} error={result?.error ?? null} />
                    </td>
                    <td>
                      <div className={styles.titleCell}>{wp.title}</div>
                      {wp.description && (
                        <div className={styles.descPreview}>{wp.description}</div>
                      )}
                    </td>
                    <td>{wp.area}</td>
                    <td>{wp.priority}</td>
                    <td>{wp.implementationTime}</td>
                    <td>
                      <div className={styles.actionsCell}>
                        {status === 'done' && result?.feature && (
                          <>
                            <button
                              className={styles.actionBtn}
                              onClick={() => handleDownloadOne(i)}
                              type="button"
                            >
                              {t('bulk.download')}
                            </button>
                            <button
                              className={styles.actionBtn}
                              onClick={() => onLoadToEditor(result.feature!)}
                              type="button"
                            >
                              {t('bulk.edit')}
                            </button>
                          </>
                        )}
                        {status === 'pending' && !isRunning && (
                          <button
                            className={styles.generateOneBtn}
                            onClick={() => retryItem(i, model, bulkTestUser, tables)}
                            disabled={!apiKeySet}
                            type="button"
                          >
                            {t('bulk.generate')}
                          </button>
                        )}
                        {status === 'error' && (
                          <button
                            className={styles.retryBtn}
                            onClick={() => retryItem(i, model, bulkTestUser, tables)}
                            type="button"
                          >
                            {t('bulk.retry')}
                          </button>
                        )}
                      </div>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </>
      )}
    </div>
  );
}

function StatusBadge({ status, error }: { status: string; error: string | null }) {
  const { t } = useTranslation();
  switch (status) {
    case 'done':
      return <span className={styles.statusDone} title={t('bulk.done')}>&#10003;</span>;
    case 'generating':
      return <span className={styles.spinner} />;
    case 'error':
      return <span className={styles.statusError} title={error ?? t('bulk.error')}>&#10007;</span>;
    default:
      return <span className={styles.statusPending}>&#9679;</span>;
  }
}
