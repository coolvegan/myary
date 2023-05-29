import 'package:flutter/material.dart';

class TodoTheme extends StatelessWidget {
  const TodoTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

ThemeData getTheme() {
  return ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.light,

    colorSchemeSeed: Colors.green[100],
    // Define the default font family.
    fontFamily: 'Avenir',

    // Define the default `TextTheme`. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  );
}
