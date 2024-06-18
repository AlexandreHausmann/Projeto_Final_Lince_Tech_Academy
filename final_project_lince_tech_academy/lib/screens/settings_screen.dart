import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLightTheme = themeProvider.themeMode == ThemeMode.light;

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
                themeProvider.setThemeMode(ThemeMode.light);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                 backgroundColor: Colors.blue,
              ),
              child: const Text('Claro'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                themeProvider.setThemeMode(ThemeMode.dark);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: isLightTheme ? Colors.grey : Colors.blue,
              ),
              child: const Text('Escuro'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                themeProvider.setThemeMode(ThemeMode.system);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                 backgroundColor: isLightTheme ? Colors.grey : Colors.blue,
              ),
              child: const Text('Automático'),
            ),
          ],
        ),
      ),
    );
  }
}
