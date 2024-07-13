import 'package:flutter/material.dart';

/// Provider responsável por gerenciar o tema e a localização da aplicação.
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode _lastThemeMode = ThemeMode.light; 
  Locale _locale = const Locale('pt', 'BR'); 

  /// Retorna o modo de tema atual.
  ThemeMode get themeMode => _themeMode;

  /// Retorna a localização atual da aplicação.
  Locale get locale => _locale;

  /// Define o modo de tema da aplicação e notifica os ouvintes sobre a mudança.
  void setThemeMode(ThemeMode themeMode) {
    if (themeMode != ThemeMode.system) {
      _lastThemeMode = themeMode;
    }
    _themeMode = themeMode;
    notifyListeners();
  }

  /// Restaura o último modo de tema utilizado antes da mudança para o modo de sistema e notifica os ouvintes.
  void restoreLastThemeMode() {
    _themeMode = _lastThemeMode;
    notifyListeners();
  }

  /// Define a localização da aplicação e notifica os ouvintes sobre a mudança.
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
