import 'package:flow_chart_editor/utils/path_utils.dart';
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
      duration: const Duration(seconds: 3),
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

  static final p = Paint()
    ..color = const Color.fromARGB(255, 0, 115, 130)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  static final pDimmed = Paint()
    ..color = Color.fromARGB(255, 61, 61, 61)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;
  static final cp = Paint()
    ..color = const Color.fromARGB(255, 255, 128, 119)
    ..strokeWidth = 2;

  static final cpa = Paint()
    ..color = const Color.fromARGB(255, 40, 216, 239)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;
  static final cpab = Paint()
    ..color = const Color.fromARGB(255, 0, 0, 0)
    ..strokeWidth = 3;

  static const anchorRadius = 4.0;
  @override
  void paint(Canvas canvas, Size size) {
    for (final conn in connections) {
      Offset? fromPoint;
      Offset? fromPointOffset;
      Offset? toPoint;
      Offset? toPointOffset;

      for (final node in nodes) {
        if (node.id == conn.fromNodeID) {
          fromPoint = node.pointFromAnchor(conn.fromAnchor);
          fromPointOffset =
              fromPoint + node.offsetFromAnchor(conn.fromAnchor, 100);
        } else if (node.id == conn.toNodeID) {
          toPoint = node.pointFromAnchor(conn.toAnchor);
          toPointOffset = toPoint + node.offsetFromAnchor(conn.toAnchor, 100);
        }

        if (toPoint != null &&
            fromPoint != null &&
            fromPointOffset != null &&
            toPointOffset != null) break;
      }
      if (fromPoint == null ||
          toPoint == null ||
          fromPointOffset == null ||
          toPointOffset == null) return;

      final path = Path()
        ..moveTo(fromPoint.dx, fromPoint.dy)
        ..cubicTo(
          fromPointOffset.dx,
          fromPointOffset.dy,
          toPointOffset.dx,
          toPointOffset.dy,
          toPoint.dx,
          toPoint.dy,
        );

      canvas.drawPath(path, pDimmed);
      final animatedPath = PathUtils.createAnimatedPath(path, anim.value);
      canvas.drawPath(animatedPath, p);
      // final animPoint = anim.drive(Tween(begin: fromPoint, end: toPoint));
      final animPoint = PathUtils.getAnimatedPointInPath(path, anim.value);

      canvas.drawCircle(animPoint, 4, cp);
      canvas.drawCircle(fromPoint, anchorRadius, cpab);
      canvas.drawCircle(toPoint, anchorRadius, cpab);
      canvas.drawCircle(fromPoint, anchorRadius, cpa);
      canvas.drawCircle(toPoint, anchorRadius, cpa);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
