import 'package:flutter/material.dart';

import '../constants/taskflow_palette.dart';

class TaskFlowTheme {
  const TaskFlowTheme._();

  static ThemeData light() {
    return _base(
      brightness: Brightness.light,
      scaffold: TaskFlowPalette.mist,
      surface: TaskFlowPalette.cloud,
      text: TaskFlowPalette.ink,
    );
  }

  static ThemeData dark() {
    return _base(
      brightness: Brightness.dark,
      scaffold: const Color(0xFF101820),
      surface: const Color(0xFF182431),
      text: const Color(0xFFEAF0F6),
    );
  }

  static ThemeData _base({
    required Brightness brightness,
    required Color scaffold,
    required Color surface,
    required Color text,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: TaskFlowPalette.aurora,
      brightness: brightness,
      primary: TaskFlowPalette.aurora,
      secondary: TaskFlowPalette.violet,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarThemeData(
        elevation: 0,
        centerTitle: false,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: brightness == Brightness.light ? Colors.white : const Color(0xFF223141),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: TaskFlowPalette.aurora, width: 1.4),
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(fontWeight: FontWeight.w800, color: text),
        titleLarge: TextStyle(fontWeight: FontWeight.w800, color: text),
        titleMedium: TextStyle(fontWeight: FontWeight.w700, color: text),
        bodyLarge: TextStyle(color: text),
        bodyMedium: TextStyle(color: text.withOpacity(0.78)),
      ),
    );
  }
}
