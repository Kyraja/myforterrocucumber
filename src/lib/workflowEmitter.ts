/**
 * @module workflowEmitter
 * Unified emission interface for every AI workflow in the app.
 *
 * Each workflow (FOP analysis, Cucumber generation, prompt rating, agent chat,
 * bulk, FOP→Cucumber) receives a {@link WorkflowEmitter} and calls its methods
 * at every local-logic and AI-call boundary. The emitter writes the resulting
 * {@link WorkflowStep} entries into the `useAgentActivity` run state so the
 * `WorkflowTimeline` UI component can render them as a chat-like history.
 *
 * This module contains **no React** — it is a pure functional layer so it can
 * be unit-tested directly.
 */

import type { WorkflowStep, LocalStep, AiStep, WorkflowStepStatus } from '../types/fop';

/** Init payload for starting a local step — id/timestamp/status are assigned internally. */
export type LocalStepInit = Omit<LocalStep, 'id' | 'timestamp' | 'status' | 'kind'>;

/** Init payload for starting an AI step — id/timestamp/status/rawResponse are assigned internally. */
export type AiStepInit = Omit<AiStep, 'id' | 'timestamp' | 'status' | 'kind' | 'rawResponse'>;

/**
 * The state-mutation interface a WorkflowEmitter needs from the outside world.
 * `useAgentActivity` provides an implementation bound to a specific agent-type slot.
 */
export interface WorkflowEmitterSink {
  pushStep: (step: WorkflowStep) => void;
  updateStep: (id: string, patch: Partial<WorkflowStep>) => void;
}

/**
 * The methods a workflow calls to report progress. Obtained from
 * `useAgentActivity.getEmitter(agentType)`.
 */
export type StartStepInit =
  | (LocalStepInit & { kind: 'local' })
  | (AiStepInit & { kind: 'ai' });

export interface WorkflowEmitter {
  /** Push a new step in status `running`. Returns its id so it can be updated later. */
  startStep: (init: StartStepInit) => string;
  /** Transition an existing step to `done` and optionally fill output fields. */
  completeStep: (id: string, patch?: Partial<WorkflowStep>) => void;
  /** Transition an existing step to `error` with an error message. */
  failStep: (id: string, errorMessage: string) => void;
  /** Convenience: one-shot local step (start + done immediately). Returns id. */
  emitLocal: (init: LocalStepInit) => string;
  /**
   * Convenience wrapper for an AI call: pushes a running step, awaits the call,
   * fills `rawResponse`, marks the step as done (or error) and returns the raw response.
   *
   * @param init - step metadata including system + user prompts
   * @param call - async function that performs the chat completion and returns the raw text
   */
  emitAiCall: (init: AiStepInit, call: () => Promise<string>) => Promise<string>;
}

function now(): number { return Date.now(); }
function newId(): string {
  // crypto.randomUUID is available in browsers and Node >= 16
  if (typeof crypto !== 'undefined' && typeof crypto.randomUUID === 'function') {
    return crypto.randomUUID();
  }
  return `step_${now()}_${Math.random().toString(36).slice(2, 10)}`;
}

/**
 * Build a {@link WorkflowEmitter} bound to a specific sink.
 *
 * The sink is typically supplied by `useAgentActivity` as
 * `{ pushStep: (step) => hook.pushStep(type, step), updateStep: (id, p) => hook.updateStep(type, id, p) }`
 * so every emission lands in the correct agent-type slot.
 */
export function createEmitter(sink: WorkflowEmitterSink): WorkflowEmitter {
  const startStep: WorkflowEmitter['startStep'] = (init) => {
    const id = newId();
    const timestamp = now();
    const status: WorkflowStepStatus = 'running';
    const step = { ...init, id, timestamp, status } as WorkflowStep;
    sink.pushStep(step);
    return id;
  };

  const completeStep: WorkflowEmitter['completeStep'] = (id, patch) => {
    sink.updateStep(id, { ...patch, status: 'done' });
  };

  const failStep: WorkflowEmitter['failStep'] = (id, errorMessage) => {
    sink.updateStep(id, { status: 'error', errorMessage });
  };

  const emitLocal: WorkflowEmitter['emitLocal'] = (init) => {
    const id = newId();
    const timestamp = now();
    const step: LocalStep = {
      ...init,
      id,
      timestamp,
      status: 'done',
      kind: 'local',
      durationMs: 0,
    };
    sink.pushStep(step);
    return id;
  };

  const emitAiCall: WorkflowEmitter['emitAiCall'] = async (init, call) => {
    const id = startStep({ ...init, kind: 'ai' });
    const startedAt = now();
    try {
      const response = await call();
      sink.updateStep(id, {
        status: 'done',
        rawResponse: response,
        durationMs: now() - startedAt,
      } as Partial<AiStep>);
      return response;
    } catch (err) {
      const message = err instanceof Error ? err.message : String(err);
      sink.updateStep(id, {
        status: 'error',
        errorMessage: message,
        durationMs: now() - startedAt,
      });
      throw err;
    }
  };

  return { startStep, completeStep, failStep, emitLocal, emitAiCall };
}

/** A no-op emitter for call sites that don't want to report progress. */
export const NULL_EMITTER: WorkflowEmitter = {
  startStep: () => '',
  completeStep: () => {},
  failStep: () => {},
  emitLocal: () => '',
  emitAiCall: async (_init, call) => call(),
};
