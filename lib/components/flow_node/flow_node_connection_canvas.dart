import 'package:flow_chart_editor/utils/path_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../data/flow_node_connection_data.dart';
import '../../data/flow_node_data.dart';

class FlowNodeConnectionCanvas extends HookWidget {
  const FlowNodeConnectionCanvas(
      this.nodes, this.connections, this.currentMousePosition,
      {Key? key})
      : super(key: key);
  final List<FlowNodeData> nodes;
  final List<FlowNodeConnection> connections;
  final Offset currentMousePosition;
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
      painter: FlowEdgesPainter(
        nodes,
        connections,
        animController,
        currentMousePosition,
      ),
    );
  }
}

class FlowEdgesPainter extends CustomPainter {
  final List<FlowNodeData> nodes;
  final List<FlowNodeConnection> connections;
  final Animation anim;
  final Offset mousePosition;
  FlowEdgesPainter(this.nodes, this.connections, this.anim, this.mousePosition)
      : super(repaint: anim);

  static final mainPathPaint = Paint()
    ..color = const Color.fromARGB(255, 0, 115, 130)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  static final mainPathDimmed = Paint()
    ..color = Color.fromARGB(255, 61, 61, 61)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;
  static final movingCirclePaint = Paint()
    ..color = const Color.fromARGB(255, 255, 128, 119)
    ..strokeWidth = 2;

  static final anchorPaint = Paint()
    ..color = const Color.fromARGB(255, 40, 216, 239)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;
  static final anchorPaintBG = Paint()
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
        }
        if (node.id == conn.toNodeID) {
          toPoint = node.pointFromAnchor(conn.toAnchor);
          toPointOffset = toPoint + node.offsetFromAnchor(conn.toAnchor, 100);
        }
        if (conn.goingToMouse) {
          toPoint = mousePosition;
          toPointOffset = mousePosition;
        }

        if (toPoint != null &&
            fromPoint != null &&
            fromPointOffset != null &&
            toPointOffset != null) break;
      }
      if (fromPoint == null ||
          toPoint == null ||
          fromPointOffset == null ||
          toPointOffset == null) continue;

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

      canvas.drawPath(path, mainPathDimmed);
      final animatedPath = PathUtils.createAnimatedPath(path, anim.value);
      canvas.drawPath(animatedPath, mainPathPaint);
      // final animPoint = anim.drive(Tween(begin: fromPoint, end: toPoint));
      final animPoint = PathUtils.getAnimatedPointInPath(path, anim.value);

      canvas.drawCircle(animPoint, 4, movingCirclePaint);
      canvas.drawCircle(fromPoint, anchorRadius, anchorPaintBG);
      canvas.drawCircle(toPoint, anchorRadius, anchorPaintBG);
      canvas.drawCircle(fromPoint, anchorRadius, anchorPaint);
      canvas.drawCircle(toPoint, anchorRadius, anchorPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
