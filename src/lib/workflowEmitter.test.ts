import { describe, it, expect, vi } from 'vitest';
import { createEmitter, NULL_EMITTER } from './workflowEmitter';
import type { WorkflowStep, AiStep, LocalStep } from '../types/fop';

function makeSink() {
  const steps: WorkflowStep[] = [];
  return {
    steps,
    pushStep: (s: WorkflowStep) => { steps.push(s); },
    updateStep: (id: string, patch: Partial<WorkflowStep>) => {
      const idx = steps.findIndex(s => s.id === id);
      if (idx >= 0) steps[idx] = { ...steps[idx], ...patch } as WorkflowStep;
    },
  };
}

describe('workflowEmitter', () => {
  it('emitLocal pushes a done LocalStep with duration 0', () => {
    const sink = makeSink();
    const emitter = createEmitter(sink);
    const id = emitter.emitLocal({
      phase: 'fop-buffers',
      label: 'Buffer-Tracking',
      summary: '12 Buffer-Operationen',
      outputText: 'H|1 ← db3',
    });
    expect(sink.steps).toHaveLength(1);
    const step = sink.steps[0] as LocalStep;
    expect(step.id).toBe(id);
    expect(step.kind).toBe('local');
    expect(step.status).toBe('done');
    expect(step.summary).toBe('12 Buffer-Operationen');
    expect(step.phase).toBe('fop-buffers');
  });

  it('startStep pushes a running step and completeStep transitions it to done', () => {
    const sink = makeSink();
    const emitter = createEmitter(sink);
    const id = emitter.startStep({
      kind: 'local',
      phase: 'fop-parsing',
      label: 'Parsing',
      summary: 'running...',
    });
    expect(sink.steps[0].status).toBe('running');
    emitter.completeStep(id, { summary: 'done.' } as Partial<LocalStep>);
    expect(sink.steps[0].status).toBe('done');
    expect((sink.steps[0] as LocalStep).summary).toBe('done.');
  });

  it('failStep sets status=error and keeps errorMessage', () => {
    const sink = makeSink();
    const emitter = createEmitter(sink);
    const id = emitter.startStep({
      kind: 'ai',
      phase: 'fop-analyst',
      label: 'Analyst',
      agent: 'fop-analyst',
      systemPrompt: 'sys',
      userPrompt: 'ctx',
    });
    emitter.failStep(id, 'network down');
    expect(sink.steps[0].status).toBe('error');
    expect(sink.steps[0].errorMessage).toBe('network down');
  });

  it('emitAiCall resolves with the response and records it on the step', async () => {
    const sink = makeSink();
    const emitter = createEmitter(sink);
    const call = vi.fn().mockResolvedValue('{"result":42}');
    const out = await emitter.emitAiCall(
      {
        phase: 'fop-analyst',
        label: 'Analyst',
        agent: 'fop-analyst',
        systemPrompt: 'S',
        userPrompt: 'U',
        model: 'gpt-4o-mini',
      },
      call,
    );
    expect(out).toBe('{"result":42}');
    expect(sink.steps).toHaveLength(1);
    const step = sink.steps[0] as AiStep;
    expect(step.kind).toBe('ai');
    expect(step.status).toBe('done');
    expect(step.rawResponse).toBe('{"result":42}');
    expect(step.systemPrompt).toBe('S');
    expect(step.userPrompt).toBe('U');
    expect(step.model).toBe('gpt-4o-mini');
    expect(step.durationMs).toBeGreaterThanOrEqual(0);
  });

  it('emitAiCall marks the step as error and re-throws when the call fails', async () => {
    const sink = makeSink();
    const emitter = createEmitter(sink);
    const err = new Error('boom');
    const call = vi.fn().mockRejectedValue(err);
    await expect(
      emitter.emitAiCall(
        {
          phase: 'rating-call',
          label: 'Rating',
          agent: 'rating',
          systemPrompt: '',
          userPrompt: '',
        },
        call,
      ),
    ).rejects.toBe(err);
    expect(sink.steps[0].status).toBe('error');
    expect(sink.steps[0].errorMessage).toBe('boom');
  });

  it('NULL_EMITTER runs the call without touching any sink', async () => {
    const call = vi.fn().mockResolvedValue('ok');
    const out = await NULL_EMITTER.emitAiCall(
      {
        phase: 'cuc-generate',
        label: 'Generate',
        agent: 'cucumber',
        systemPrompt: '',
        userPrompt: '',
      },
      call,
    );
    expect(out).toBe('ok');
    expect(call).toHaveBeenCalled();
  });
});
