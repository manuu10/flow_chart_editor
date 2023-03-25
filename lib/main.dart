import 'package:context_menus/context_menus.dart';
import 'package:flow_chart_editor/components/spaced_row_column.dart';
import 'package:flow_chart_editor/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.dark();
    return ProviderScope(
      child: MaterialApp(
        theme: baseTheme.copyWith(
          scaffoldBackgroundColor: Colors.black,
          textTheme: baseTheme.textTheme.apply(
            bodyColor: Color.fromARGB(255, 147, 154, 153),
            displayColor: Color.fromARGB(255, 147, 154, 153),
          ),
          tooltipTheme: baseTheme.tooltipTheme.copyWith(
            textStyle: TextStyle(color: Color.fromARGB(255, 158, 171, 248)),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 0),
              border: Border(
                left: BorderSide(color: Colors.indigo, width: 3),
                right: BorderSide(color: Colors.indigo, width: 3),
              ),
            ),
          ),
        ),
        home: ContextMenuOverlay(
          buttonBuilder: (context, config, [_]) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Color.fromARGB(132, 129, 129, 129),
                  foregroundColor: Color.fromARGB(255, 84, 184, 179)),
              onPressed: config.onPressed,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (config.icon != null) config.icon!,
                  if (config.icon != null) SizedBox(width: 10),
                  Text(
                    config.label,
                  ),
                ],
              ),
            );
          },
          cardBuilder: (context, children) {
            return Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Color.fromARGB(255, 113, 113, 113)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SpacedColumn(
                  children: children,
                ),
              ),
            );
          },
          child: const MainScreen(),
        ),
      ),
    );
  }
}
