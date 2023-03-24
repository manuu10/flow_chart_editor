import 'package:flutter/material.dart';

enum _SpacedWidget {
  col,
  row,
}

class SpacedColumn extends StatelessWidget {
  const SpacedColumn({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return _SpacedInternalWidget(children: children, type: _SpacedWidget.col);
  }
}

class SpacedRow extends StatelessWidget {
  const SpacedRow({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return _SpacedInternalWidget(children: children, type: _SpacedWidget.row);
  }
}

class _SpacedInternalWidget extends StatelessWidget {
  const _SpacedInternalWidget(
      {super.key, required this.children, required this.type});
  final List<Widget> children;
  final _SpacedWidget type;

  @override
  Widget build(BuildContext context) {
    final moddedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      moddedChildren.add(children[i]);
      if (i < children.length - 1) {
        switch (type) {
          case _SpacedWidget.col:
            moddedChildren.add(SizedBox(height: 10));
            break;
          case _SpacedWidget.row:
            moddedChildren.add(SizedBox(width: 10));
            break;
        }
      }
    }
    switch (type) {
      case _SpacedWidget.col:
        return Column(children: moddedChildren);
      case _SpacedWidget.row:
        return Row(children: moddedChildren);
    }
  }
}
