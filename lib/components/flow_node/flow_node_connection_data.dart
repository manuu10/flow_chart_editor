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
  center,
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
}
