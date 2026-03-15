// Shared IndexedDB helper for cucumbergnerator
// Stores: 'tables' (TableDef[]), 'fileHandles' (FileSystemDirectoryHandle), 'agents' (Agent[])

const IDB_NAME = 'cucumbergnerator';
const IDB_VERSION = 3;

export const IDB_TABLES_STORE = 'tables';
export const IDB_FILE_HANDLES_STORE = 'fileHandles';
export const IDB_AGENTS_STORE = 'agents';

export function openDb(): Promise<IDBDatabase> {
  return new Promise((resolve, reject) => {
    const req = indexedDB.open(IDB_NAME, IDB_VERSION);
    req.onupgradeneeded = (event) => {
      const db = req.result;
      const oldVersion = (event as IDBVersionChangeEvent).oldVersion ?? 0;
      if (oldVersion < 1) {
        if (!db.objectStoreNames.contains(IDB_TABLES_STORE)) {
          db.createObjectStore(IDB_TABLES_STORE);
        }
      }
      if (oldVersion < 2) {
        if (!db.objectStoreNames.contains(IDB_FILE_HANDLES_STORE)) {
          db.createObjectStore(IDB_FILE_HANDLES_STORE);
        }
      }
      if (oldVersion < 3) {
        if (!db.objectStoreNames.contains(IDB_AGENTS_STORE)) {
          db.createObjectStore(IDB_AGENTS_STORE);
        }
      }
    };
    req.onsuccess = () => resolve(req.result);
    req.onerror = () => reject(req.error);
  });
}
