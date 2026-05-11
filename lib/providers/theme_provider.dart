import 'package:flutter/material.dart';

class TaskFlowThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool useDarkMode) {
    _themeMode = useDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
