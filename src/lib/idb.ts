// Shared IndexedDB helper for cucumbergnerator
// Stores: 'tables', 'fileHandles', 'agents', 'kbDocuments', 'kbChunks'

const IDB_NAME = 'cucumbergnerator';
const IDB_VERSION = 6;

export const IDB_TABLES_STORE = 'tables';
export const IDB_FILE_HANDLES_STORE = 'fileHandles';
export const IDB_AGENTS_STORE = 'agents';
export const IDB_KB_DOCS_STORE = 'kbDocuments';
export const IDB_KB_CHUNKS_STORE = 'kbChunks';

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
      if (oldVersion < 4) {
        if (!db.objectStoreNames.contains(IDB_KB_DOCS_STORE)) {
          db.createObjectStore(IDB_KB_DOCS_STORE, { keyPath: 'id' });
        }
      }
      if (oldVersion < 5) {
        if (!db.objectStoreNames.contains(IDB_KB_CHUNKS_STORE)) {
          const store = db.createObjectStore(IDB_KB_CHUNKS_STORE, { keyPath: 'id' });
          store.createIndex('by-docId', 'docId', { unique: false });
        }
      }
      if (oldVersion < 6) {
        // Add keywords multi-entry index for search
        if (db.objectStoreNames.contains(IDB_KB_CHUNKS_STORE)) {
          const tx = (event.target as IDBRequest).transaction!;
          const store = tx.objectStore(IDB_KB_CHUNKS_STORE);
          if (!store.indexNames.contains('by-keyword')) {
            store.createIndex('by-keyword', 'keywords', { unique: false, multiEntry: true });
          }
        }
      }
    };
    req.onsuccess = () => resolve(req.result);
    req.onerror = () => reject(req.error);
  });
}
