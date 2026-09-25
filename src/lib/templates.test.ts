import { beforeEach, describe, expect, it, vi } from 'vitest';
import type { Scenario } from '../types/gherkin';
import {
  exportCustomTemplates,
  loadCustomTemplates,
  reorderCustomTemplates,
  saveOrUpdateCustomTemplate,
} from './templates';

const makeScenario = (name: string): Scenario => ({
  id: `${name}-id`,
  name,
  steps: [
    {
      id: `${name}-step`,
      keyword: 'Given',
      text: `${name} text`,
      action: { type: 'freetext' },
    },
  ],
});

beforeEach(() => {
  localStorage.clear();
});

describe('saveOrUpdateCustomTemplate', () => {
  it('creates a new custom template when no templateId is provided', () => {
    const saved = saveOrUpdateCustomTemplate(makeScenario('Alpha'));

    expect(saved.id.startsWith('custom_')).toBe(true);
    expect(saved.label).toBe('Alpha');
    expect(loadCustomTemplates()).toHaveLength(1);
  });

  it('updates an existing custom template in place when templateId matches', () => {
    const first = saveOrUpdateCustomTemplate(makeScenario('Alpha'));
    const updated = saveOrUpdateCustomTemplate(makeScenario('Beta'), {
      templateId: first.id,
      label: 'Beta Custom',
    });

    const templates = loadCustomTemplates();
    expect(templates).toHaveLength(1);
    expect(updated.id).toBe(first.id);
    expect(templates[0].id).toBe(first.id);
    expect(templates[0].label).toBe('Beta Custom');
    expect(templates[0].steps[0].action).toEqual({ type: 'freetext' });
  });

  it('reorders custom templates and persists the order', () => {
    const first = saveOrUpdateCustomTemplate(makeScenario('Alpha'));
    const second = saveOrUpdateCustomTemplate(makeScenario('Beta'));
    const third = saveOrUpdateCustomTemplate(makeScenario('Gamma'));

    const reordered = reorderCustomTemplates([third.id, first.id]);

    expect(reordered.map((t) => t.id)).toEqual([third.id, first.id, second.id]);
    expect(loadCustomTemplates().map((t) => t.id)).toEqual([third.id, first.id, second.id]);
  });

  it('exports only selected template ids in persisted order', async () => {
    const first = saveOrUpdateCustomTemplate(makeScenario('Alpha'));
    const second = saveOrUpdateCustomTemplate(makeScenario('Beta'));
    const third = saveOrUpdateCustomTemplate(makeScenario('Gamma'));
    reorderCustomTemplates([second.id, third.id, first.id]);

    let exportedBlob: Blob | null = null;
    const createObjectURLSpy = vi.spyOn(URL, 'createObjectURL').mockImplementation((blob: Blob | MediaSource) => {
      if (blob instanceof Blob) {
        exportedBlob = blob;
      }
      return 'blob:mock';
    });
    const revokeSpy = vi.spyOn(URL, 'revokeObjectURL').mockImplementation(() => {});
    const clickSpy = vi.spyOn(HTMLAnchorElement.prototype, 'click').mockImplementation(() => {});

    exportCustomTemplates([third.id, first.id]);
    expect(exportedBlob).not.toBeNull();
    const capturedJson = await exportedBlob!.text();

    const parsed = JSON.parse(capturedJson) as Array<{ id: string }>;
    expect(parsed.map((t) => t.id)).toEqual([third.id, first.id]);

    createObjectURLSpy.mockRestore();
    revokeSpy.mockRestore();
    clickSpy.mockRestore();
  });
});