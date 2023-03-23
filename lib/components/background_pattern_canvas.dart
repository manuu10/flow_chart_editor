import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class BackgroundPatternCanvas extends StatelessWidget {
  const BackgroundPatternCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedPatternPainter(),
    );
  }
}

class _DottedPatternPainter extends CustomPainter {
  static const spacing = 30.0;

  @override
  void paint(Canvas canvas, Size size) {
    final xDots = size.width / spacing;
    final yDots = size.height / spacing;
    final p = Paint()..color = Color.fromARGB(255, 72, 72, 72);

    for (int x = 0; x < xDots; x++) {
      for (int y = 0; y < yDots; y++) {
        canvas.drawCircle(Offset(x * spacing, y * spacing), 1, p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
