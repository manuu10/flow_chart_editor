import 'dart:math';

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
      FlowNodeData(id: "A", position: const Offset(50, 50)),
      FlowNodeData(id: "B", position: const Offset(200, 50)),
      FlowNodeData(id: "C", position: const Offset(50, 200)),
      FlowNodeData(id: "D", position: const Offset(50, 200)),
      FlowNodeData(id: "E", position: const Offset(50, 200)),
    ]);

    final connections = useState([
      FlowNodeConnection(fromNodeID: "A", toNodeID: "B"),
      FlowNodeConnection(fromNodeID: "A", toNodeID: "C"),
      FlowNodeConnection(fromNodeID: "B", toNodeID: "C"),
      FlowNodeConnection(fromNodeID: "A", toNodeID: "D"),
      FlowNodeConnection(fromNodeID: "C", toNodeID: "E"),
      FlowNodeConnection(fromNodeID: "E", toNodeID: "D"),
    ]);

    return Stack(
      fit: StackFit.expand,
      children: [
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
                onMove: (pos) => nodes.value = nodes.value.map((nd) {
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
