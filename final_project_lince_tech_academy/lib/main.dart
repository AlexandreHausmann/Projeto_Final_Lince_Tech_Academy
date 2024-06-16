import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/customer_provider.dart';
import 'providers/manager_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/vehicle_provider.dart';
import 'providers/rent_provider.dart';
import 'screens/customer_list_screen.dart';
import 'screens/home_screen.dart';
import 'screens/manager_list_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/vehicle_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => ManagerProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => RentProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'SS Automóveis',
            theme: ThemeData.light().copyWith(
              primaryColor: Colors.blue,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blue,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 63, 63, 63),
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: const Color.fromARGB(255, 63, 63, 63),
              scaffoldBackgroundColor: const Color.fromARGB(255, 63, 63, 63),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color.fromARGB(255, 63, 63, 63),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey,
                ),
              ),
            ),
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const HomeScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/customers': (context) => const CustomerListScreen(),
              '/managers': (context) => const ManagerListScreen(),
              '/vehicles': (context) => const VehicleListScreen(),
              '/rents': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
