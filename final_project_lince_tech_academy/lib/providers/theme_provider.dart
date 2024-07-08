import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode _lastThemeMode = ThemeMode.light; // Valor padrão
  Locale _locale = const Locale('pt', 'BR'); // Português como padrão

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  void setThemeMode(ThemeMode themeMode) {
    if (themeMode != ThemeMode.system) {
      _lastThemeMode = themeMode;
    }
    _themeMode = themeMode;
    notifyListeners();
  }

  void restoreLastThemeMode() {
    _themeMode = _lastThemeMode;
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
