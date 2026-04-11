/**
 * @module ProcessDiagram
 * Interactive React Flow diagram that visualises the AI generation pipeline as a workflow graph.
 *
 * Key responsibilities:
 * - Supports two flow layouts: 'cucumber' (table-ID → prompt → Gherkin) and 'fop' (FOP analysis pipeline).
 * - Maps DiagramStep data onto custom React Flow node types (workflow, diamond, start, end).
 * - Colors edges green on completion and pulses active KI nodes to reflect live progress.
 * - Opens a detail dialog (ItemDialog) on node click to inspect input/output data and step descriptions.
 * - Delegates to onAgentClick for live monitoring of active KI nodes.
 * @prop {DiagramFlow | null} flow - The flow definition including step states and item data.
 * @prop {'de' | 'en'} lang - UI language for labels and dialog content.
 * @prop {(agentType: string) => void} [onAgentClick] - Called when an active KI node is clicked.
 */
import { useState, useMemo } from 'react';
import {
  ReactFlow,
  Background,
  Controls,
  Handle,
  Position,
  type NodeTypes,
  type Node,
  type Edge,
} from '@xyflow/react';
import '@xyflow/react/dist/style.css';
import styles from './ProcessDiagram.module.css';

// ── Data model ─────────────────────────────────────────────────

export interface DiagramItem {
  name: string;
  path?: 'local' | 'ki' | 'cached' | 'error';
  detail?: string;
  subItems?: string[];
  /** What was sent (prompt, selection string, etc.) */
  input?: string;
  /** What was received (KI response, matched tables, etc.) */
  output?: string;
  /** Custom label for input section (default: "Gesendet"/"Sent") */
  inputLabel?: string;
  /** Custom label for output section (default: "Empfangen"/"Received") */
  outputLabel?: string;
}

export interface DiagramStep {
  id: string;
  labelDe: string;
  labelEn: string;
  /** Description of what this step does */
  descDe?: string;
  descEn?: string;
  type: 'local' | 'ki' | 'start' | 'end' | 'branch';
  status: 'pending' | 'active' | 'done' | 'error';
  agentType?: 'cucumber' | 'fop-analyst' | 'fop-guidelines';
  items?: DiagramItem[];
  branches?: Record<string, number>;
}

export interface DiagramFlow {
  type: 'cucumber' | 'fop';
  steps: DiagramStep[];
}

// ── Item detail dialog ─────────────────────────────────────────

function ItemRow({ item, lang }: { item: DiagramItem; lang: 'de' | 'en' }) {
  const [showInput, setShowInput] = useState(false);
  const [showOutput, setShowOutput] = useState(false);
  return (
    <li className={`${styles.itemRow} ${item.path ? styles[`item_${item.path}`] : ''}`}>
      <div className={styles.itemHeader}>
        <span className={styles.itemPath}>
          {item.path === 'local' ? '⚙' : item.path === 'ki' ? '🤖' : item.path === 'error' ? '✗' : '○'}
        </span>
        <span className={styles.itemName}>{item.name}</span>
        {item.path && (
          <span className={styles.itemPathBadge}>
            {item.path === 'local' ? (lang === 'de' ? 'Lokal' : 'Local') :
             item.path === 'ki' ? 'KI' :
             item.path === 'cached' ? 'Cache' : 'Fehler'}
          </span>
        )}
      </div>
      {item.detail && <p className={styles.itemDetail}>{item.detail}</p>}
      {item.subItems && item.subItems.length > 0 && (
        <ul className={styles.subItemList}>
          {item.subItems.map((s, j) => <li key={j}>{s}</li>)}
        </ul>
      )}
      {/* Input section */}
      {item.input && (
        <div className={styles.ioSection}>
          <button type="button" className={styles.ioToggle} onClick={() => setShowInput(v => !v)}>
            {showInput ? '▾' : '▸'} {item.inputLabel ?? (lang === 'de' ? 'Gesendet' : 'Sent')}
            <span className={styles.ioChars}>{item.input.length.toLocaleString()} Zeichen</span>
          </button>
          {showInput && <pre className={styles.ioContent}>{item.input}</pre>}
        </div>
      )}
      {/* Output section */}
      {item.output && (
        <div className={styles.ioSection}>
          <button type="button" className={styles.ioToggle} onClick={() => setShowOutput(v => !v)}>
            {showOutput ? '▾' : '▸'} {item.outputLabel ?? (lang === 'de' ? 'Empfangen' : 'Received')}
            <span className={styles.ioChars}>{item.output.length.toLocaleString()} Zeichen</span>
          </button>
          {showOutput && <pre className={styles.ioContent}>{item.output}</pre>}
        </div>
      )}
    </li>
  );
}

function ItemDialog({ title, items, onClose, lang, onOpenAgent, agentLabel, description }: {
  title: string; items: DiagramItem[]; onClose: () => void; lang: 'de' | 'en';
  onOpenAgent?: () => void; agentLabel?: string; description?: string;
}) {
  const [dialogTab, setDialogTab] = useState<'data' | 'info'>(items.length > 0 ? 'data' : 'info');
  return (
    <div className={styles.overlay} onClick={(e) => e.target === e.currentTarget && onClose()}>
      <div className={styles.dialog}>
        <div className={styles.dialogHeader}>
          <span className={styles.dialogTitle}>{title}</span>
          <span className={styles.dialogCount}>{items.length}</span>
          <button type="button" className={styles.dialogClose} onClick={onClose}>✕</button>
        </div>
        {description && (
          <div className={styles.dialogTabs}>
            <button type="button" className={`${styles.dialogTab} ${dialogTab === 'data' ? styles.dialogTabActive : ''}`} onClick={() => setDialogTab('data')}>
              {lang === 'de' ? 'Daten' : 'Data'}
            </button>
            <button type="button" className={`${styles.dialogTab} ${dialogTab === 'info' ? styles.dialogTabActive : ''}`} onClick={() => setDialogTab('info')}>
              {lang === 'de' ? 'Info' : 'Info'}
            </button>
          </div>
        )}
        <div className={styles.dialogBody}>
          {dialogTab === 'info' && description ? (
            <p className={styles.dialogDesc}>{description}</p>
          ) : items.length === 0 ? (
            <p className={styles.dialogEmpty}>
              {description || (lang === 'de' ? 'Keine Einträge.' : 'No items.')}
            </p>
          ) : (
            <ul className={styles.itemList}>
              {items.map((item, i) => <ItemRow key={i} item={item} lang={lang} />)}
            </ul>
          )}
        </div>
        <div className={styles.dialogFooter}>
          {onOpenAgent && (
            <button type="button" className={styles.dialogAgentBtn} onClick={onOpenAgent}>
              🤖 {agentLabel ?? (lang === 'de' ? 'Agent öffnen' : 'Open agent')}
            </button>
          )}
          <button type="button" className={styles.dialogCloseBtn} onClick={onClose}>
            {lang === 'de' ? 'Schließen' : 'Close'}
          </button>
        </div>
      </div>
    </div>
  );
}

// ── Custom node types ──────────────────────────────────────────

function WorkflowNode({ data }: { data: {
  label: string; status: string; type: string;
  count: number; isKiClickable: boolean; lang: string;
}}) {
  const isKi = data.type === 'ki';
  const s = data.status;
  const isActive = s === 'active';
  const hasItems = data.count > 0;
  const isClickable = data.isKiClickable || hasItems;

  return (
    <div
      className={[
        styles.wfNode,
        styles[`wfNode_${s}`],
        isKi ? styles.wfNodeKi : styles.wfNodeLocal,
        isActive ? styles.wfNodePulse : '',
        isClickable ? styles.wfNodeClickable : '',
      ].filter(Boolean).join(' ')}
      title={isKi ? (data.lang === 'de' ? 'Klicken für Agent-Details' : 'Click for agent details')
        : hasItems ? (data.lang === 'de' ? 'Klicken für Einträge' : 'Click for items')
        : undefined}
    >
      <Handle type="target" position={Position.Left} style={{ opacity: 0, width: 6, height: 6 }} />

      <div className={styles.wfNodeContent}>
        <span className={styles.wfNodeIcon}>
          {s === 'done' ? '✓' : s === 'error' ? '✗' : isKi ? '🤖' : (s === 'active' ? '⟳' : '○')}
        </span>
        <span className={styles.wfNodeLabel}>{data.label}</span>
      </div>

      {data.count > 0 && (
        <span className={`${styles.wfBadge} ${styles[`wfBadge_${s}`]}`}>
          {data.count > 99 ? '99+' : data.count}
        </span>
      )}

      <Handle type="source" position={Position.Right} style={{ opacity: 0, width: 6, height: 6 }} />
    </div>
  );
}

function DiamondNode({ data }: { data: { label?: string } }) {
  return (
    <div className={styles.wfDiamond} title={data.label}>
      <Handle type="target" position={Position.Left} style={{ left: 0, top: '50%', opacity: 0 }} />
      <Handle type="source" id="top" position={Position.Top} style={{ top: 0, left: '50%', opacity: 0 }} />
      <Handle type="source" id="bottom" position={Position.Bottom} style={{ bottom: 0, left: '50%', opacity: 0 }} />
      <Handle type="source" id="right" position={Position.Right} style={{ right: 0, top: '50%', opacity: 0 }} />
    </div>
  );
}

function StartNode() {
  return (
    <div className={styles.wfStart}>
      <Handle type="source" position={Position.Right} style={{ right: 0, top: '50%', opacity: 0 }} />
    </div>
  );
}

function EndNode() {
  return (
    <div className={styles.wfEnd}>
      <Handle type="target" position={Position.Left} style={{ left: 0, top: '50%', opacity: 0 }} />
    </div>
  );
}

const NODE_TYPES: NodeTypes = {
  workflow: WorkflowNode,
  diamond: DiamondNode,
  start: StartNode,
  end: EndNode,
};

// ── Flow layout definitions ────────────────────────────────────

const CUCUMBER_LAYOUT = {
  // Mittelachse Y=70, Branch ±55px, Gap=45px zwischen Elementen
  //   Start(20)→[45]→AP(140)→[45]→◇(28)→[45]→Tables(155)→[45]→Prompt(155)→[45]→Gherkin(170)→[45]→◇(28)→[45]→Result(120)→[45]→End(20)
  //   x:  0       65       250  278      368       568       768         983 1011      1101       1266
  nodes: [
    { id: 'start',          type: 'start',    position: { x: 0,    y: 56  } },
    { id: 'read-ap',        type: 'workflow', position: { x: 73,   y: 53  }, w: 140 },
    { id: 'branch-tables',  type: 'diamond',  position: { x: 258,  y: 52  } },
    { id: 'local-tables',   type: 'workflow', position: { x: 339,  y: 0   }, w: 155 },
    { id: 'ki-tables',      type: 'workflow', position: { x: 339,  y: 106 }, w: 155 },
    { id: 'build-prompt',   type: 'workflow', position: { x: 539,  y: 53  }, w: 155 },
    { id: 'gen-gherkin',    type: 'workflow', position: { x: 739,  y: 53  }, w: 170 },
    { id: 'branch-result',  type: 'diamond',  position: { x: 954,  y: 52  } },
    { id: 'result-ok',      type: 'workflow', position: { x: 1035, y: 0   }, w: 120 },
    { id: 'result-err',     type: 'workflow', position: { x: 1035, y: 106 }, w: 120 },
    { id: 'end',            type: 'end',      position: { x: 1200, y: 56  } },
  ],
  edges: [
    { id: 'e1', source: 'start', target: 'read-ap', edgeType: 'straight' },
    { id: 'e2', source: 'read-ap', target: 'branch-tables', edgeType: 'straight' },
    { id: 'e3', source: 'branch-tables', target: 'local-tables', label: 'Lokal', sourceHandle: 'top', edgeType: 'smoothstep' },
    { id: 'e4', source: 'branch-tables', target: 'ki-tables', label: 'KI', sourceHandle: 'bottom', edgeType: 'smoothstep' },
    { id: 'e5', source: 'local-tables', target: 'build-prompt', edgeType: 'smoothstep' },
    { id: 'e6', source: 'ki-tables', target: 'build-prompt', edgeType: 'smoothstep' },
    { id: 'e7', source: 'build-prompt', target: 'gen-gherkin', edgeType: 'straight' },
    { id: 'e8', source: 'gen-gherkin', target: 'branch-result', edgeType: 'straight' },
    { id: 'e9', source: 'branch-result', target: 'result-ok', label: '✓', sourceHandle: 'top', edgeType: 'smoothstep' },
    { id: 'e10', source: 'branch-result', target: 'result-err', label: '✗', sourceHandle: 'bottom', edgeType: 'smoothstep' },
    { id: 'e11', source: 'result-ok', target: 'end', edgeType: 'smoothstep' },
    { id: 'e12', source: 'result-err', target: 'end', edgeType: 'smoothstep' },
  ],
};

const FOP_LAYOUT = {
  // Linearer Ablauf: Parse → Buffer → Felder → Lokal-Check → KI-Analyse → Richtlinien → Speichern
  nodes: [
    { id: 'start',           type: 'start',    position: { x: 0,    y: 56  } },
    { id: 'fop-parse',       type: 'workflow', position: { x: 73,   y: 53  }, w: 130 },
    { id: 'fop-buffers',     type: 'workflow', position: { x: 248,  y: 53  }, w: 150 },
    { id: 'fop-fields',      type: 'workflow', position: { x: 443,  y: 53  }, w: 150 },
    { id: 'fop-local-chk',   type: 'workflow', position: { x: 638,  y: 53  }, w: 140 },
    { id: 'fop-analyst',     type: 'workflow', position: { x: 823,  y: 53  }, w: 140 },
    { id: 'fop-guidelines',  type: 'workflow', position: { x: 1008, y: 53  }, w: 170 },
    { id: 'fop-save',        type: 'workflow', position: { x: 1223, y: 53  }, w: 120 },
    { id: 'end',             type: 'end',      position: { x: 1388, y: 56  } },
  ],
  edges: [
    { id: 'fe1',  source: 'start',          target: 'fop-parse',      edgeType: 'straight' },
    { id: 'fe2',  source: 'fop-parse',      target: 'fop-buffers',    edgeType: 'straight' },
    { id: 'fe3',  source: 'fop-buffers',    target: 'fop-fields',     edgeType: 'straight' },
    { id: 'fe4',  source: 'fop-fields',     target: 'fop-local-chk',  edgeType: 'straight' },
    { id: 'fe5',  source: 'fop-local-chk',  target: 'fop-analyst',    edgeType: 'straight' },
    { id: 'fe6',  source: 'fop-analyst',    target: 'fop-guidelines', edgeType: 'straight' },
    { id: 'fe7',  source: 'fop-guidelines', target: 'fop-save',       edgeType: 'straight' },
    { id: 'fe8',  source: 'fop-save',       target: 'end',            edgeType: 'straight' },
  ],
};

// ── Main component ─────────────────────────────────────────────

interface ProcessDiagramProps {
  flow: DiagramFlow | null;
  onAgentClick?: (agentType: string) => void;
  lang: 'de' | 'en';
}

export default function ProcessDiagram({ flow, onAgentClick, lang }: ProcessDiagramProps) {
  const [detailStep, setDetailStep] = useState<string | null>(null);

  const layout = flow?.type === 'cucumber' ? CUCUMBER_LAYOUT : FOP_LAYOUT;

  const nodes: Node[] = useMemo(() => {
    if (!flow) return [];
    return layout.nodes.map(n => {
      const step = flow.steps.find(s => s.id === n.id);
      if (n.type === 'start' || n.type === 'end') {
        return { id: n.id, type: n.type, position: n.position, data: {} };
      }
      if (n.type === 'diamond') {
        return { id: n.id, type: 'diamond', position: n.position, data: { label: step?.labelDe ?? '' } };
      }
      if (!step) return { id: n.id, type: 'workflow', position: n.position, data: { label: n.id, status: 'pending', type: 'local', count: 0, isKiClickable: false, lang } };
      const lbl = lang === 'de' ? step.labelDe : step.labelEn;
      return {
        id: n.id,
        type: 'workflow',
        position: n.position,
        style: { width: (n as { w?: number }).w ?? 120 },
        data: {
          label: lbl,
          status: step.status,
          type: step.type,
          count: step.items?.length ?? 0,
          // Clickable if: has description (info tab), has items (data tab), or is active KI node (agent modal)
          isKiClickable: !!(step.descDe || step.descEn) ||
            (step.items?.length ?? 0) > 0 ||
            !!(step.type === 'ki' && step.agentType && onAgentClick && step.status === 'active'),
          lang,
        },
      };
    });
  }, [flow, lang, onAgentClick, layout]);

  const edges: Edge[] = useMemo(() => {
    if (!flow) return [];
    return layout.edges.map(e => {
      const srcStep = flow.steps.find(s => s.id === e.source);
      const isDone = srcStep?.status === 'done';
      return {
        id: e.id,
        source: e.source,
        target: e.target,
        sourceHandle: (e as { sourceHandle?: string }).sourceHandle,
        label: (e as { label?: string }).label,
        type: (e as { edgeType?: string }).edgeType || 'smoothstep',
        style: isDone ? { stroke: 'var(--color-success)', strokeWidth: 2 } : { stroke: '#d1d5db', strokeWidth: 1.5 },
        markerEnd: { type: 'arrowclosed' as const, color: isDone ? 'var(--color-success)' : '#d1d5db' },
        labelStyle: { fontSize: 10, fill: '#999', fontWeight: 500 },
        labelBgStyle: { fill: 'var(--color-bg)', fillOpacity: 0.9 },
      };
    });
  }, [flow, layout]);

  const detailStepData = detailStep ? flow?.steps.find(s => s.id === detailStep) : null;

  if (!flow) return null;

  return (
    <div className={styles.rfContainer} style={{ height: 220, width: '100%' }}>
      <ReactFlow
        nodes={nodes}
        edges={edges}
        nodeTypes={NODE_TYPES}
        fitView
        fitViewOptions={{ padding: 0.25 }}
        minZoom={0.3}
        maxZoom={1.5}
        panOnScroll
        zoomOnScroll={false}
        nodesDraggable={false}
        nodesConnectable={false}
        selectNodesOnDrag={false}
        proOptions={{ hideAttribution: true }}
        onNodeClick={(_evt, node) => {
          const step = flow?.steps.find(s => s.id === node.id);
          console.log('[ProcessDiagram] click:', node.id, '| step:', step?.id, '| descDe:', step?.descDe?.slice(0, 30), '| items:', step?.items?.length);
          if (!step) return;
          const hasItems = (step.items?.length ?? 0) > 0;
          const hasDesc = !!(step.descDe || step.descEn);
          // Nodes with items or description → show dialog
          if (hasItems || hasDesc) {
            setDetailStep(node.id);
            return;
          }
          // KI node currently active → open agent modal for live monitoring
          if (step.type === 'ki' && step.agentType && onAgentClick && step.status === 'active') {
            onAgentClick(step.agentType);
          }
        }}
      >
        <Background gap={20} color="#f0f0f0" />
        <Controls showInteractive={false} position="bottom-right" />
      </ReactFlow>

      {detailStepData && ((detailStepData.items?.length ?? 0) > 0 || detailStepData.descDe || detailStepData.descEn) && (
        <ItemDialog
          title={lang === 'de' ? detailStepData.labelDe : detailStepData.labelEn}
          items={detailStepData.items ?? []}
          onClose={() => setDetailStep(null)}
          lang={lang}
          onOpenAgent={
            detailStepData.type === 'ki' && detailStepData.agentType && onAgentClick
              ? () => { setDetailStep(null); onAgentClick(detailStepData.agentType!); }
              : undefined
          }
          agentLabel={detailStepData.type === 'ki'
            ? (lang === 'de' ? 'Live-Monitoring öffnen' : 'Open live monitoring')
            : undefined}
          description={lang === 'de' ? detailStepData.descDe : detailStepData.descEn}
        />
      )}
    </div>
  );
}
