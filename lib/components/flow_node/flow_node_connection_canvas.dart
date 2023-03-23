import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'flow_node_connection_data.dart';
import 'flow_node_data.dart';

class FlowNodeConnectionCanvas extends HookWidget {
  const FlowNodeConnectionCanvas(this.nodes, this.connections, {Key? key})
      : super(key: key);
  final List<FlowNodeData> nodes;
  final List<FlowNodeConnection> connections;
  @override
  Widget build(BuildContext context) {
    final animController = useAnimationController(
      duration: Duration(seconds: 3),
    );
    useEffect(() {
      animController.addListener(() {
        if (animController.isCompleted) {
          animController.repeat();
        }
      });
      animController.forward();
      return null;
    }, []);

    return CustomPaint(
      painter: FlowEdgesPainter(nodes, connections, animController),
    );
  }
}

class FlowEdgesPainter extends CustomPainter {
  final List<FlowNodeData> nodes;
  final List<FlowNodeConnection> connections;
  final Animation anim;

  FlowEdgesPainter(this.nodes, this.connections, this.anim)
      : super(repaint: anim);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Color.fromARGB(255, 0, 115, 130)
      ..strokeWidth = 2;
    final cp = Paint()
      ..color = Color.fromARGB(255, 255, 128, 119)
      ..strokeWidth = 2;

    for (final conn in connections) {
      Offset? centerFrom;
      Offset? centerTo;

      for (final node in nodes) {
        if (node.id == conn.fromNodeID) {
          centerFrom = node.center;
        } else if (node.id == conn.toNodeID) {
          centerTo = node.center;
        }

        if (centerTo != null && centerFrom != null) break;
      }
      if (centerFrom == null || centerTo == null) return;

      canvas.drawLine(centerFrom, centerTo, p);
      final animPoint = anim.drive(Tween(begin: centerFrom, end: centerTo));
      canvas.drawCircle(animPoint.value, 4, cp);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
