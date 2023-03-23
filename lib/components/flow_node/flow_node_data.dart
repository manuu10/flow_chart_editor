// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'dart:ui';

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

  Offset get center =>
      Offset(position.dx + size.width / 2, position.dy + size.height / 2);

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
