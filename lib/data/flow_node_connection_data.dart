// ignore_for_file: public_member_api_docs, sort_constructors_first
enum FlowNodeConnectionStroke {
  solid,
  dashed,
  dashedMoving,
}

enum FlowNodeAnchor {
  top,
  bottom,
  right,
  left,
  center;

  bool get isVertical =>
      this == FlowNodeAnchor.top || this == FlowNodeAnchor.bottom;
  bool get isHorizontal =>
      this == FlowNodeAnchor.left || this == FlowNodeAnchor.right;
}

class FlowNodeConnection {
  final String fromNodeID;
  final String toNodeID;
  final FlowNodeConnectionStroke strokeType;
  final FlowNodeAnchor fromAnchor;
  final FlowNodeAnchor toAnchor;
  FlowNodeConnection({
    required this.fromNodeID,
    required this.toNodeID,
    this.strokeType = FlowNodeConnectionStroke.solid,
    this.fromAnchor = FlowNodeAnchor.center,
    this.toAnchor = FlowNodeAnchor.center,
  });

  static const mouseID = "mouse";

  factory FlowNodeConnection.createToMouse(
      String fromID, FlowNodeAnchor fromAnchor) {
    return FlowNodeConnection(
        fromNodeID: fromID, toNodeID: mouseID, fromAnchor: fromAnchor);
  }

  bool get goingToMouse => toNodeID == mouseID;

  FlowNodeConnection copyWith({
    String? fromNodeID,
    String? toNodeID,
    FlowNodeConnectionStroke? strokeType,
    FlowNodeAnchor? fromAnchor,
    FlowNodeAnchor? toAnchor,
  }) {
    return FlowNodeConnection(
      fromNodeID: fromNodeID ?? this.fromNodeID,
      toNodeID: toNodeID ?? this.toNodeID,
      strokeType: strokeType ?? this.strokeType,
      fromAnchor: fromAnchor ?? this.fromAnchor,
      toAnchor: toAnchor ?? this.toAnchor,
    );
  }
}
