import 'dart:math';

import 'package:context_menus/context_menus.dart';
import 'package:flow_chart_editor/components/background_pattern_canvas.dart';
import 'package:flow_chart_editor/components/flow_node/flow_node.dart';
import 'package:flow_chart_editor/components/flow_node/flow_node_connection_canvas.dart';
import 'package:flow_chart_editor/data/sketch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../data/flow_node_connection_data.dart';
import '../data/flow_node_data.dart';

class FlowCanvas extends HookWidget {
  const FlowCanvas(
    this.sketch, {
    Key? key,
    this.onNodesChanged,
    this.onConnectionsChanged,
  }) : super(key: key);
  final FlowSketch sketch;
  final void Function(List<FlowNodeData> nodes)? onNodesChanged;
  final void Function(List<FlowNodeConnection> connection)?
      onConnectionsChanged;

  @override
  Widget build(BuildContext context) {
    final nodes = useState(sketch.nodes);
    final connections = useState(sketch.connections);
    final mousePosition = useState(Offset.zero);
    final connectMode =
        connections.value.any((element) => element.goingToMouse);

    useEffect(() {
      nodes.value = sketch.nodes;
      connections.value = sketch.connections;
      return null;
    }, [sketch.id]);

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
                  onNodesChanged?.call(nodes.value);
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
                          onConnectionsChanged?.call(connections.value);
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
                        onNodesChanged?.call(nodes.value);
                      },
                      onSizeChange: (Size size) {
                        nodes.value = nodes.value.map((nd) {
                          if (e != nd) return nd;
                          return nd.copyWith(size: size);
                        }).toList();
                      },
                      onMoveEnd: (newPosition, delta) {
                        onNodesChanged?.call(nodes.value);
                      },
                      onMove: (pos, delta) {
                        nodes.value = nodes.value.map((nd) {
                          if (e != nd) return nd;
                          return nd.copyWith(position: pos);
                        }).toList();
                      },
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
