import { useMemo } from 'react';
import {
  ReactFlow,
  Background,
  Controls,
  type Node,
  type Edge,
} from '@xyflow/react';
import { useTranslation } from '../../i18n';
import '@xyflow/react/dist/style.css';
import styles from './ConceptRelationGraph.module.css';

export type ConceptNodeType = 'chapter' | 'package' | 'cluster';

export interface ConceptRelationNode {
  id: string;
  label: string;
  type: ConceptNodeType;
  chapter?: string;
}

export interface ConceptRelationEdge {
  from: string;
  to: string;
  relation: string;
  confidence?: number;
  evidence?: string;
}

export interface ConceptRelationGap {
  severity: 'low' | 'medium' | 'high';
  message: string;
  related?: string[];
}

interface ConceptRelationGraphProps {
  nodes: ConceptRelationNode[];
  edges: ConceptRelationEdge[];
  gaps: ConceptRelationGap[];
  selectedNodeId?: string | null;
  onNodeSelect?: (nodeId: string) => void;
}

function nodeStyleByType(type: ConceptNodeType, selected: boolean): React.CSSProperties {
  const border = selected ? '2px solid #1d4ed8' : '1px solid #cbd5e1';
  if (type === 'chapter') {
    return {
      border,
      borderRadius: 10,
      background: '#eef2ff',
      padding: '8px 10px',
      fontSize: 12,
      minWidth: 140,
      color: '#1e293b',
      fontWeight: 600,
      textAlign: 'center',
    };
  }
  if (type === 'cluster') {
    return {
      border,
      borderRadius: 10,
      background: '#ecfeff',
      padding: '8px 10px',
      fontSize: 12,
      minWidth: 170,
      color: '#0f172a',
      fontWeight: 600,
      textAlign: 'center',
    };
  }
  return {
    border,
    borderRadius: 8,
    background: '#ffffff',
    padding: '7px 9px',
    fontSize: 12,
    minWidth: 210,
    color: '#0f172a',
    textAlign: 'left',
    boxShadow: '0 1px 2px rgba(15, 23, 42, 0.08)',
  };
}

export function ConceptRelationGraph({
  nodes,
  edges,
  gaps,
  selectedNodeId,
  onNodeSelect,
}: ConceptRelationGraphProps) {
  const { t } = useTranslation();
  const flowNodes = useMemo<Node[]>(() => {
    const chapterNodes = nodes.filter((n) => n.type === 'chapter').sort((a, b) => a.label.localeCompare(b.label));
    const packageNodes = nodes.filter((n) => n.type === 'package').sort((a, b) => (a.chapter || '').localeCompare(b.chapter || '') || a.label.localeCompare(b.label));
    const clusterNodes = nodes.filter((n) => n.type === 'cluster').sort((a, b) => a.label.localeCompare(b.label));

    const toNode = (n: ConceptRelationNode, x: number, y: number): Node => ({
      id: n.id,
      position: { x, y },
      data: { label: n.label },
      style: nodeStyleByType(n.type, selectedNodeId === n.id),
      draggable: false,
    });

    const chapterFlowNodes = chapterNodes.map((n, i) => toNode(n, 10, i * 85));
    const packageFlowNodes = packageNodes.map((n, i) => toNode(n, 300, i * 85));
    const clusterFlowNodes = clusterNodes.map((n, i) => toNode(n, 650, i * 85));

    return [...chapterFlowNodes, ...packageFlowNodes, ...clusterFlowNodes];
  }, [nodes, selectedNodeId]);

  const flowEdges = useMemo<Edge[]>(() => {
    return edges.map((e, idx) => ({
      id: `edge-${idx}`,
      source: e.from,
      target: e.to,
      label: e.relation,
      type: 'smoothstep',
      animated: e.relation.includes('abhaeng') || e.relation.includes('depends'),
      style: {
        stroke: '#64748b',
        strokeWidth: Math.max(1, Math.min(3, (e.confidence ?? 0.6) * 3)),
      },
      labelStyle: {
        fontSize: 11,
        fill: '#334155',
      },
    }));
  }, [edges]);

  return (
    <div className={styles.wrapper}>
      <div className={styles.header}>
        <span>{t('concept.title')}</span>
        <span className={styles.stats}>
          {t('concept.stats', { nodes: nodes.length, edges: edges.length })}
        </span>
      </div>
      <div className={styles.canvas}>
        <ReactFlow
          nodes={flowNodes}
          edges={flowEdges}
          fitView
          nodesDraggable={false}
          nodesConnectable={false}
          elementsSelectable
          onNodeClick={(_, n) => onNodeSelect?.(n.id)}
          minZoom={0.3}
          maxZoom={1.5}
          proOptions={{ hideAttribution: true }}
        >
          <Background gap={16} color="#e2e8f0" />
          <Controls showInteractive={false} />
        </ReactFlow>
      </div>
      {gaps.length > 0 && (
        <div className={styles.gaps}>
          <div className={styles.gapTitle}>{t('concept.gapsTitle')}</div>
          <ul>
            {gaps.slice(0, 8).map((g, i) => (
              <li key={i} className={styles[`sev_${g.severity}`]}>
                [{g.severity.toUpperCase()}] {g.message}
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}
