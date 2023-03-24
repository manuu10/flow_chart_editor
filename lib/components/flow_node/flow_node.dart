import 'dart:math';

import 'package:flow_chart_editor/components/measure_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef PointChangeCallBack = void Function(Offset newPosition, Offset delta);
typedef SizeChangedCallBack = void Function(Size size);

class FlowNode extends HookWidget {
  const FlowNode({
    super.key,
    required this.position,
    required this.child,
    this.onMove,
    this.onMoveEnd,
    this.onMoveStart,
    this.onSizeChange,
  });
  final Offset position;
  final Widget child;
  final PointChangeCallBack? onMove;
  final PointChangeCallBack? onMoveEnd;
  final PointChangeCallBack? onMoveStart;
  final SizeChangedCallBack? onSizeChange;
  @override
  Widget build(BuildContext context) {
    final pos = useState(position);
    final isDragging = useState(false);
    // final menuOpen = useState(false);
    useEffect(
      () {
        if (isDragging.value) return;
        pos.value = position;
        return null;
      },
      [position],
    );

    final modChild = AnimatedScale(
      duration: const Duration(milliseconds: 150),
      scale: isDragging.value ? 1.15 : 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isDragging.value
                  ? Color.fromARGB(255, 176, 74, 74)
                  : const Color.fromRGBO(62, 62, 62, 1)),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 57, 57, 57),
              Color.fromARGB(255, 0, 0, 0)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );

    return Positioned(
      left: pos.value.dx,
      top: pos.value.dy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onPanStart: (details) {
              isDragging.value = true;
              onMoveStart?.call(pos.value, Offset.zero);
            },
            onPanEnd: (details) {
              isDragging.value = false;
              onMoveEnd?.call(pos.value, Offset.zero);
            },
            onPanUpdate: (details) {
              if (isDragging.value) {
                final newPos = pos.value + details.delta;
                pos.value = newPos;
                onMove?.call(newPos, details.delta);
              }
            },
            child: MeasureSize(
              onChange: (Size size) => onSizeChange?.call(size),
              child: modChild,
            ),
          ),
        ],
      ),
    );
  }
}
