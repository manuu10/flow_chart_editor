// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flow_chart_editor/data/flow_node_connection_data.dart';

import 'flow_node_data.dart';

class FlowSketch {
  final String id;
  final String title;
  final List<FlowNodeData> nodes;
  final List<FlowNodeConnection> connections;
  final DateTime created;
  FlowSketch({
    required this.id,
    required this.title,
    required this.nodes,
    required this.connections,
    required this.created,
  });

  FlowSketch copyWith({
    String? id,
    String? title,
    List<FlowNodeData>? nodes,
    List<FlowNodeConnection>? connections,
    DateTime? created,
  }) {
    return FlowSketch(
      id: id ?? this.id,
      title: title ?? this.title,
      nodes: nodes ?? this.nodes,
      connections: connections ?? this.connections,
      created: created ?? this.created,
    );
  }
}
