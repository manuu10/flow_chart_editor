import 'package:flow_chart_editor/components/flow_canvas.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 100,
            child: Container(
              color: Color.fromARGB(255, 32, 6, 5),
            ),
          ),
          Expanded(child: FlowCanvas()),
        ],
      ),
    );
  }
}
