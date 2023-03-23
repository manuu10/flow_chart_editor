// ignore_for_file: public_member_api_docs, sort_constructors_first
enum FlowNodeConnectionStroke {
  solid,
  dashed,
  dashedMoving,
}

class FlowNodeConnection {
  final String fromNodeID;
  final String toNodeID;
  final FlowNodeConnectionStroke strokeType;
  FlowNodeConnection({
    required this.fromNodeID,
    required this.toNodeID,
    this.strokeType = FlowNodeConnectionStroke.solid,
  });
}
