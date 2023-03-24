import 'dart:math';

import 'package:flow_chart_editor/components/background_pattern_canvas.dart';
import 'package:flow_chart_editor/components/flow_node/flow_node.dart';
import 'package:flow_chart_editor/components/flow_node/flow_node_connection_canvas.dart';
import 'package:flow_chart_editor/components/flow_node/flow_node_connection_data.dart';
import 'package:flow_chart_editor/components/flow_node/flow_node_data.dart';
import 'package:flow_chart_editor/components/measure_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FlowCanvas extends HookWidget {
  const FlowCanvas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nodes = useState([
      FlowNodeData(id: "A", position: const Offset(82, 444)),
      FlowNodeData(id: "B", position: const Offset(214, 149)),
      FlowNodeData(id: "C", position: const Offset(461, 276)),
      FlowNodeData(id: "D", position: const Offset(153, 774)),
      FlowNodeData(id: "E", position: const Offset(434, 635)),
    ]);

    final connections = useState([
      FlowNodeConnection(
        fromNodeID: "A",
        toNodeID: "B",
        fromAnchor: FlowNodeAnchor.top,
        toAnchor: FlowNodeAnchor.left,
      ),
      FlowNodeConnection(
        fromNodeID: "A",
        toNodeID: "C",
        fromAnchor: FlowNodeAnchor.right,
        toAnchor: FlowNodeAnchor.left,
      ),
      FlowNodeConnection(
        fromNodeID: "B",
        toNodeID: "C",
        fromAnchor: FlowNodeAnchor.right,
        toAnchor: FlowNodeAnchor.left,
      ),
      FlowNodeConnection(
        fromNodeID: "A",
        toNodeID: "D",
        fromAnchor: FlowNodeAnchor.bottom,
        toAnchor: FlowNodeAnchor.left,
      ),
      FlowNodeConnection(
        fromNodeID: "C",
        toNodeID: "E",
        fromAnchor: FlowNodeAnchor.bottom,
        toAnchor: FlowNodeAnchor.top,
      ),
      FlowNodeConnection(
        fromNodeID: "E",
        toNodeID: "D",
        fromAnchor: FlowNodeAnchor.bottom,
        toAnchor: FlowNodeAnchor.right,
      ),
    ]);

    return Stack(
      fit: StackFit.expand,
      children: [
        BackgroundPatternCanvas(),
        FlowNodeConnectionCanvas(nodes.value, connections.value),
        ...nodes.value
            .map(
              (e) => FlowNode(
                onSizeChange: (Size size) {
                  nodes.value = nodes.value.map((nd) {
                    if (e != nd) return nd;
                    return nd.copyWith(size: size);
                  }).toList();
                },
                onMove: (pos, delta) => nodes.value = nodes.value.map((nd) {
                  if (e != nd) return nd;
                  return nd.copyWith(position: pos);
                }).toList(),
                position: e.position,
                child: Text(
                  "${e.id}\n${e.position}\n${e.size}",
                ),
              ),
            )
            .toList()
      ],
    );
  }
}
