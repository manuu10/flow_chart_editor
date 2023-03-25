// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'flow_node_connection_data.dart';

enum FlowNodeType {
  standard,
}

class FlowNodeData {
  final String id;
  final Offset position;
  final Size size;
  final FlowNodeType nodeType;
  FlowNodeData({
    required this.id,
    required this.position,
    this.nodeType = FlowNodeType.standard,
    this.size = Size.zero,
  });

  Offset pointFromAnchor(FlowNodeAnchor anchor) {
    switch (anchor) {
      case FlowNodeAnchor.top:
        return topCenter;
      case FlowNodeAnchor.bottom:
        return bottomCenter;
      case FlowNodeAnchor.right:
        return rightCenter;
      case FlowNodeAnchor.left:
        return leftCenter;
      case FlowNodeAnchor.center:
        return center;
    }
  }

  Offset offsetFromAnchor(FlowNodeAnchor anchor, [double offset = 20]) {
    switch (anchor) {
      case FlowNodeAnchor.top:
        return Offset(0, -offset);
      case FlowNodeAnchor.bottom:
        return Offset(0, offset);
      case FlowNodeAnchor.right:
        return Offset(offset, 0);
      case FlowNodeAnchor.left:
        return Offset(-offset, 0);
      case FlowNodeAnchor.center:
        return center;
    }
  }

  Offset get center => Offset(
        position.dx + size.width / 2,
        position.dy + size.height / 2,
      );
  Offset get leftCenter => Offset(
        position.dx,
        position.dy + size.height / 2,
      );
  Offset get topCenter => Offset(
        position.dx + size.width / 2,
        position.dy,
      );
  Offset get rightCenter => Offset(
        position.dx + size.width,
        position.dy + size.height / 2,
      );
  Offset get bottomCenter => Offset(
        position.dx + size.width / 2,
        position.dy + size.height,
      );

  FlowNodeData copyWith({
    String? id,
    Offset? position,
    Size? size,
    FlowNodeType? nodeType,
  }) {
    return FlowNodeData(
      id: id ?? this.id,
      position: position ?? this.position,
      size: size ?? this.size,
      nodeType: nodeType ?? this.nodeType,
    );
  }
}
