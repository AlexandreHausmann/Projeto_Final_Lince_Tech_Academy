import 'package:flutter/material.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SS Automóveis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/logoFundo.jpg',
              fit: BoxFit.cover,
              color: isDarkMode
                  ? Colors.black.withOpacity(0.6)
                  : Colors.white.withOpacity(0.6),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/customers');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: isDarkMode
                        ? Colors.white
                        : const Color.fromARGB(255, 109, 96, 96),
                    backgroundColor: isDarkMode
                        ? Colors.grey
                        : const Color.fromARGB(255, 112, 137, 165),
                  ),
                  child: const Text('Clientes'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/managers');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: isDarkMode
                        ? Colors.white
                        : const Color.fromARGB(255, 109, 96, 96),
                    backgroundColor: isDarkMode
                        ? Colors.grey
                        : const Color.fromARGB(255, 112, 137, 165),
                  ),
                  child: const Text('Gerentes'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/vehicles');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: isDarkMode
                        ? Colors.white
                        : const Color.fromARGB(255, 109, 96, 96),
                    backgroundColor: isDarkMode
                        ? Colors.grey
                        : const Color.fromARGB(255, 112, 137, 165),
                  ),
                  child: const Text('Veículos'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/rents');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: isDarkMode
                        ? Colors.white
                        : const Color.fromARGB(255, 109, 96, 96),
                    backgroundColor: isDarkMode
                        ? Colors.grey
                        : const Color.fromARGB(255, 112, 137, 165),
                  ),
                  child: const Text('Aluguéis'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}