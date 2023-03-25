import 'dart:math';

import 'package:context_menus/context_menus.dart';
import 'package:flow_chart_editor/components/background_pattern_canvas.dart';
import 'package:flow_chart_editor/components/flow_node/flow_node.dart';
import 'package:flow_chart_editor/components/flow_node/flow_node_connection_canvas.dart';
import 'package:flow_chart_editor/components/flow_node/flow_node_connection_data.dart';
import 'package:flow_chart_editor/components/flow_node/flow_node_data.dart';
import 'package:flow_chart_editor/components/measure_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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

class FlowCanvas extends HookWidget {
  const FlowCanvas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nodes = useState(defaultNodes);
    final connections = useState(defaultConnections);
    final mousePosition = useState(Offset.zero);
    final connectMode =
        connections.value.any((element) => element.goingToMouse);
    return GestureDetector(
      onTap: () {
        connections.value = connections.value
            .where((element) => !element.goingToMouse)
            .toList();
      },
      child: MouseRegion(
        onHover: (event) {
          mousePosition.value = event.localPosition;
        },
        child: ContextMenuRegion(
          contextMenu: GenericContextMenu(
            buttonConfigs: [
              ContextMenuButtonConfig(
                "Create New Node",
                onPressed: () {
                  final id = Random().nextInt(3000).toString();
                  nodes.value = [
                    ...nodes.value,
                    FlowNodeData(id: id, position: mousePosition.value),
                  ];
                },
                icon: const Icon(Icons.add),
              ),
              ContextMenuButtonConfig(
                "Close",
                onPressed: () {},
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              BackgroundPatternCanvas(),
              FlowNodeConnectionCanvas(
                  nodes.value, connections.value, mousePosition.value),
              ...nodes.value
                  .map(
                    (e) => FlowNode(
                      showConnectionPoints: connectMode,
                      onStartConnection: (startAnchor) {
                        //currently in connect mode
                        if (connectMode) {
                          connections.value = connections.value.map((conn) {
                            if (conn.toNodeID == "mouse") {
                              return conn.copyWith(
                                toNodeID: e.id,
                                toAnchor: startAnchor,
                              );
                            }
                            return conn;
                          }).toList();
                          return;
                        }

                        connections.value = [
                          ...connections.value,
                          FlowNodeConnection.createToMouse(e.id, startAnchor)
                        ];
                      },
                      onRemove: () {
                        nodes.value = nodes.value
                            .where((element) => element.id != e.id)
                            .toList();
                      },
                      onSizeChange: (Size size) {
                        nodes.value = nodes.value.map((nd) {
                          if (e != nd) return nd;
                          return nd.copyWith(size: size);
                        }).toList();
                      },
                      onMove: (pos, delta) =>
                          nodes.value = nodes.value.map((nd) {
                        if (e != nd) return nd;
                        return nd.copyWith(position: pos);
                      }).toList(),
                      position: e.position,
                      child: Text(
                        "${e.id}\n${e.position}\n${e.size}",
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
