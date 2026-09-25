/**
 * IndexedDB CRUD for Knowledge Base documents and chunks.
 */

import { openDb, IDB_KB_DOCS_STORE, IDB_KB_CHUNKS_STORE } from './idb';
import type { KBDocument, KBChunk } from '../types/knowledgeBase';

export async function saveKBDocument(doc: KBDocument): Promise<void> {
  const db = await openDb();
  return new Promise((resolve, reject) => {
    const tx = db.transaction(IDB_KB_DOCS_STORE, 'readwrite');
    tx.objectStore(IDB_KB_DOCS_STORE).put(doc);
    tx.oncomplete = () => { db.close(); resolve(); };
    tx.onerror = () => { db.close(); reject(tx.error); };
  });
}

export async function saveKBChunks(chunks: KBChunk[]): Promise<void> {
  const db = await openDb();
  return new Promise((resolve, reject) => {
    const tx = db.transaction(IDB_KB_CHUNKS_STORE, 'readwrite');
    const store = tx.objectStore(IDB_KB_CHUNKS_STORE);
    for (const chunk of chunks) store.put(chunk);
    tx.oncomplete = () => { db.close(); resolve(); };
    tx.onerror = () => { db.close(); reject(tx.error); };
  });
}

export async function loadKBDocuments(): Promise<KBDocument[]> {
  const db = await openDb();
  return new Promise((resolve) => {
    const tx = db.transaction(IDB_KB_DOCS_STORE, 'readonly');
    const req = tx.objectStore(IDB_KB_DOCS_STORE).getAll();
    req.onsuccess = () => { db.close(); resolve(req.result ?? []); };
    req.onerror = () => { db.close(); resolve([]); };
  });
}

export async function loadAllKBChunks(): Promise<KBChunk[]> {
  const db = await openDb();
  return new Promise((resolve) => {
    const tx = db.transaction(IDB_KB_CHUNKS_STORE, 'readonly');
    const req = tx.objectStore(IDB_KB_CHUNKS_STORE).getAll();
    req.onsuccess = () => { db.close(); resolve(req.result ?? []); };
    req.onerror = () => { db.close(); resolve([]); };
  });
}

export async function loadKBChunksByDocId(docId: string): Promise<KBChunk[]> {
  const db = await openDb();
  return new Promise((resolve) => {
    const tx = db.transaction(IDB_KB_CHUNKS_STORE, 'readonly');
    const index = tx.objectStore(IDB_KB_CHUNKS_STORE).index('by-docId');
    const req = index.getAll(docId);
    req.onsuccess = () => { db.close(); resolve(req.result ?? []); };
    req.onerror = () => { db.close(); resolve([]); };
  });
}

export async function clearAllKBDocuments(): Promise<void> {
  const db = await openDb();
  return new Promise((resolve, reject) => {
    const tx = db.transaction([IDB_KB_DOCS_STORE, IDB_KB_CHUNKS_STORE], 'readwrite');
    tx.objectStore(IDB_KB_DOCS_STORE).clear();
    tx.objectStore(IDB_KB_CHUNKS_STORE).clear();
    tx.oncomplete = () => { db.close(); resolve(); };
    tx.onerror = () => { db.close(); reject(tx.error); };
  });
}

export async function deleteKBDocument(docId: string): Promise<void> {
  const db = await openDb();
  return new Promise((resolve, reject) => {
    const tx = db.transaction([IDB_KB_DOCS_STORE, IDB_KB_CHUNKS_STORE], 'readwrite');
    // Delete the document
    tx.objectStore(IDB_KB_DOCS_STORE).delete(docId);
    // Delete all chunks for this document
    const chunkStore = tx.objectStore(IDB_KB_CHUNKS_STORE);
    const index = chunkStore.index('by-docId');
    const cursorReq = index.openCursor(docId);
    cursorReq.onsuccess = () => {
      const cursor = cursorReq.result;
      if (cursor) {
        cursor.delete();
        cursor.continue();
      }
    };
    tx.oncomplete = () => { db.close(); resolve(); };
    tx.onerror = () => { db.close(); reject(tx.error); };
  });
}

export async function updateKBChunk(chunk: KBChunk): Promise<void> {
  const db = await openDb();
  return new Promise((resolve, reject) => {
    const tx = db.transaction(IDB_KB_CHUNKS_STORE, 'readwrite');
    tx.objectStore(IDB_KB_CHUNKS_STORE).put(chunk);
    tx.oncomplete = () => { db.close(); resolve(); };
    tx.onerror = () => { db.close(); reject(tx.error); };
  });
}
