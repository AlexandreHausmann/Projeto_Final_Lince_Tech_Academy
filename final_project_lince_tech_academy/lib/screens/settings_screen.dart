import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Tema'),
            trailing: DropdownButton<ThemeMode>(
              value: Provider.of<ThemeProvider>(context).themeMode,
              items: const [
                DropdownMenuItem(
                  child: Text('Claro'),
                  value: ThemeMode.light,
                ),
                DropdownMenuItem(
                  child: Text('Escuro'),
                  value: ThemeMode.dark,
                ),
                DropdownMenuItem(
                  child: Text('Automático'),
                  value: ThemeMode.system,
                ),
              ],
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false).setTheme(value!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tema alterado para ${value.toString().split('.').last.toLowerCase()}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
