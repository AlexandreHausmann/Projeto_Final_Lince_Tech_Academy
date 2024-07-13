import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

/// Tela de configurações que permite ao usuário alterar o idioma e o tema do aplicativo.
class SettingsScreen extends StatelessWidget {
  /// key é uma chave opcional para identificar de forma única o widget.
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _showLanguageDialog(context, themeProvider);
              },
              child: const Text('Idiomas'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showThemeDialog(context, themeProvider);
              },
              child: const Text('Tema'),
            ),
          ],
        ),
      ),
    );
  }

  /// Exibe um diálogo para seleção de idioma.
  void _showLanguageDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecione o Idioma'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Português'),
                onTap: () {
                  themeProvider.setLocale(const Locale('pt', 'BR'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Inglês'),
                onTap: () {
                  themeProvider.setLocale(const Locale('en', 'US'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Exibe um diálogo para seleção de tema (claro, escuro ou automático).
  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecione o Tema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Claro'),
                onTap: () {
                  themeProvider.setThemeMode(ThemeMode.light);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Escuro'),
                onTap: () {
                  themeProvider.setThemeMode(ThemeMode.dark);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Automático'),
                onTap: () {
                  themeProvider.restoreLastThemeMode();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
