import 'package:flutter/material.dart';
import 'package:fluttex/browser_ui.dart';

class FluttexApp extends StatelessWidget {
  const FluttexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluttex',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      color: Colors.black,
      home: const BrowserUi(),
    );
  }
}
