import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/customer_provider.dart';
import 'providers/manager_provider.dart';
import 'providers/rent_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/vehicle_provider.dart';
import 'repositories/customer_repository.dart';
import 'repositories/vehicle_repository.dart';
import 'screens/customer_form_screen.dart';
import 'screens/customer_list_screen.dart';
import 'screens/home_screen.dart';
import 'screens/manager_form_screen.dart';
import 'screens/manager_list_screen.dart';
import 'screens/rent_form_screen.dart';
import 'screens/rent_list_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/vehicle_form_screen.dart';
import 'screens/vehicle_list_screen.dart';

/// Ponto de entrada da aplicação Flutter.
void main() {
  runApp(const MyApp());
}

/// Widget principal da aplicação que configura os provedores de estado e o tema.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// Repositórios para fornecer aos provedores de estado
    final vehicleRepository = VehicleRepository();
    final customerRepository = CustomerRepository();

    return MultiProvider(
      providers: [
        /// Provedores de estado para gerenciar o estado da aplicação
        ChangeNotifierProvider(create: (_) => CustomerProvider(customerRepository: customerRepository)),
        ChangeNotifierProvider(create: (_) => ManagerProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider(vehicleRepository: vehicleRepository)),
        ChangeNotifierProvider(create: (_) => RentProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            /// Configuração inicial da aplicação com rotas e tema
            initialRoute: '/',
            routes: {
              '/': (context) => const HomeScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/customers': (context) => const CustomerListScreen(),
              '/add_customer': (context) => const CustomerFormScreen(),
              '/managers': (context) => const ManagerListScreen(),
              '/add_manager': (context) => const ManagerFormScreen(),
              '/vehicles': (context) => const VehicleListScreen(),
              '/add_vehicle': (context) => const VehicleFormScreen(),
              '/rents': (context) => const RentListScreen(),
              '/add_rent': (context) => const RentFormScreen(),
            },
            title: 'SS Automóveis', // Título da aplicação
            /// Tema claro da aplicação
            theme: ThemeData.light().copyWith(
              primaryColor: Colors.blue,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blue,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
            /// Tema escuro da aplicação
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
            /// Modo de tema da aplicação (claro, escuro, sistema)
            themeMode: themeProvider.themeMode,
          );
        },
      ),
    );
  }
}
