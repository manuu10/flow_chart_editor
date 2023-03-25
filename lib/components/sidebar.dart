import 'package:flow_chart_editor/data/sketch.dart';
import 'package:flow_chart_editor/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nanoid/nanoid.dart';

class AsideNavigation extends HookConsumerWidget {
  const AsideNavigation({Key? key, this.selectedSketchID, this.onSelect})
      : super(key: key);
  final void Function(FlowSketch value)? onSelect;
  final String? selectedSketchID;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sketches = ref.watch(sketchProvider);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 23, 23, 23),
          Colors.black,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      )),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              final id = nanoid();

              ref.read(sketchProvider.notifier).state = [
                ...sketches,
                FlowSketch(
                    id: id,
                    title: id,
                    nodes: [],
                    connections: [],
                    created: DateTime.now()),
              ];
            },
            child: const Text("Create new Sketch"),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: sketches.length,
              itemBuilder: (context, index) {
                final sketch = sketches[index];
                final selected = sketch.id == selectedSketchID;
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selected
                        ? Color.fromARGB(255, 207, 57, 57)
                        : const Color.fromARGB(148, 44, 44, 44),
                    elevation: 0,
                  ),
                  onPressed: () => onSelect?.call(sketch),
                  child: Text(sketch.title),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
