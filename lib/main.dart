import 'package:flow_chart_editor/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.dark();
    return MaterialApp(
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: baseTheme.textTheme.apply(
          bodyColor: Color.fromARGB(255, 147, 154, 153),
          displayColor: Color.fromARGB(255, 147, 154, 153),
        ),
      ),
      home: const MainScreen(),
    );
  }
}
