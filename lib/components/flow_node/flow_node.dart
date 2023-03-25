import 'dart:math';

import 'package:context_menus/context_menus.dart';
import 'package:flow_chart_editor/components/flow_node/flow_node_connection_data.dart';
import 'package:flow_chart_editor/components/measure_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef PointChangeCallBack = void Function(Offset newPosition, Offset delta);
typedef SizeChangedCallBack = void Function(Size size);
typedef StartConnectionCallBack = void Function(FlowNodeAnchor startAnchor);

class FlowNode extends HookWidget {
  const FlowNode({
    super.key,
    required this.position,
    required this.child,
    this.onMove,
    this.onMoveEnd,
    this.onMoveStart,
    this.onSizeChange,
    this.onRemove,
    this.onStartConnection,
    this.showConnectionPoints = false,
  });
  final Offset position;
  final Widget child;
  final VoidCallback? onRemove;
  final PointChangeCallBack? onMove;
  final PointChangeCallBack? onMoveEnd;
  final PointChangeCallBack? onMoveStart;
  final SizeChangedCallBack? onSizeChange;
  final StartConnectionCallBack? onStartConnection;
  final bool showConnectionPoints;
  @override
  Widget build(BuildContext context) {
    final pos = useState(position);
    final isDragging = useState(false);
    final isHovered = useState(false);
    final widgetSize = useState(Size.zero);
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
      scale: isDragging.value ? 1.03 : 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDragging.value
                ? Color.fromARGB(255, 176, 74, 74)
                : isHovered.value
                    ? Color.fromARGB(255, 110, 187, 193)
                    : const Color.fromRGBO(62, 62, 62, 1),
          ),
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
      child: MouseRegion(
        onEnter: (event) => isHovered.value = true,
        onExit: (event) => isHovered.value = false,
        cursor: SystemMouseCursors.click,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ContextMenuRegion(
              contextMenu: GenericContextMenu(
                buttonConfigs: [
                  ContextMenuButtonConfig(
                    "Remove",
                    icon: Icon(Icons.delete_forever),
                    onPressed: onRemove,
                  ),
                ],
              ),
              child: GestureDetector(
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
                  onChange: (Size size) {
                    onSizeChange?.call(size);
                    widgetSize.value = size;
                  },
                  child: modChild,
                ),
              ),
            ),
            if ((isHovered.value && !isDragging.value) ||
                showConnectionPoints) ...[
              FlowNodeAnchorInteractable(
                FlowNodeAnchor.bottom,
                (v) => onStartConnection?.call(v),
              ),
              FlowNodeAnchorInteractable(
                FlowNodeAnchor.top,
                (v) => onStartConnection?.call(v),
              ),
              FlowNodeAnchorInteractable(
                FlowNodeAnchor.left,
                (v) => onStartConnection?.call(v),
              ),
              FlowNodeAnchorInteractable(
                FlowNodeAnchor.right,
                (v) => onStartConnection?.call(v),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class FlowNodeAnchorInteractable extends StatelessWidget {
  const FlowNodeAnchorInteractable(this.anchor, this.onClick, {super.key});
  final FlowNodeAnchor anchor;
  final StartConnectionCallBack onClick;
  @override
  Widget build(BuildContext context) {
    var alignment = Alignment.topCenter;
    switch (anchor) {
      case FlowNodeAnchor.top:
        alignment = Alignment.topCenter;
        break;
      case FlowNodeAnchor.bottom:
        alignment = Alignment.bottomCenter;
        break;
      case FlowNodeAnchor.right:
        alignment = Alignment.centerRight;
        break;
      case FlowNodeAnchor.left:
        alignment = Alignment.centerLeft;
        break;
      case FlowNodeAnchor.center:
        break;
    }

    return Positioned.fill(
      // right: anchor == FlowNodeAnchor.right ? -10 : 0,
      // left: anchor == FlowNodeAnchor.left ? -10 : 0,
      // top: anchor == FlowNodeAnchor.top ? -10 : 0,
      // bottom: anchor == FlowNodeAnchor.bottom ? -10 : 0,
      child: Align(
        alignment: alignment,
        child: GestureDetector(
          onTap: () => onClick(anchor),
          child: MouseRegion(
            onHover: (event) {},
            child: const ColoredBox(
              color: Colors.red,
              child: SizedBox(
                width: 10,
                height: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
