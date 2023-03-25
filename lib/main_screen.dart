import 'package:flow_chart_editor/components/flow_canvas.dart';
import 'package:flow_chart_editor/components/sidebar.dart';
import 'package:flow_chart_editor/data/sketch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'data/flow_node_connection_data.dart';
import 'data/flow_node_data.dart';

final defaultConnections = [
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
  FlowNodeConnection(
    fromNodeID: "E",
    toNodeID: "E",
    fromAnchor: FlowNodeAnchor.bottom,
    toAnchor: FlowNodeAnchor.right,
  ),
];

final defaultNodes = [
  FlowNodeData(id: "A", position: const Offset(82, 444)),
  FlowNodeData(id: "B", position: const Offset(214, 149)),
  FlowNodeData(id: "C", position: const Offset(461, 276)),
  FlowNodeData(id: "D", position: const Offset(153, 774)),
  FlowNodeData(id: "E", position: const Offset(434, 635)),
];

final sketch = FlowSketch(
    id: "asdfas",
    title: "TestSketch",
    nodes: defaultNodes,
    connections: defaultConnections,
    created: DateTime.now());

final sketchProvider = StateProvider((ref) => <FlowSketch>[sketch]);

class MainScreen extends HookConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sketches = ref.watch(sketchProvider);
    final selectedSketchID = useState<String?>(null);
    final selectedSketchIndex =
        sketches.indexWhere((e) => e.id == selectedSketchID.value);
    final selectedSketch =
        selectedSketchIndex != -1 ? sketches[selectedSketchIndex] : null;

    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 300,
            child: AsideNavigation(
              onSelect: (value) => selectedSketchID.value = value.id,
              selectedSketchID: selectedSketchID.value,
            ),
          ),
          if (selectedSketch != null)
            Expanded(
              child: FlowCanvas(
                selectedSketch,
                onConnectionsChanged: (connection) {
                  ref.read(sketchProvider.notifier).state = sketches.map((e) {
                    if (e.id == selectedSketchID.value) {
                      return e.copyWith(connections: connection);
                    }
                    return e;
                  }).toList();
                },
                onNodesChanged: (nodes) {
                  ref.read(sketchProvider.notifier).state = sketches.map((e) {
                    if (e.id == selectedSketchID.value) {
                      return e.copyWith(nodes: nodes);
                    }
                    return e;
                  }).toList();
                },
              ),
            ),
        ],
      ),
    );
  }
}
