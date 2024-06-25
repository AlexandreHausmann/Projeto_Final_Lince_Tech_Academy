import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/customer_provider.dart';
import 'providers/manager_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/vehicle_provider.dart';
import 'providers/rent_provider.dart';
import 'screens/customer_list_screen.dart';
import 'screens/home_screen.dart';
import 'screens/manager_list_screen.dart';
import 'screens/rent_list_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/vehicle_list_screen.dart';
import 'screens/customer_form_screen.dart';
import 'screens/manager_form_screen.dart';
import 'screens/vehicle_form_screen.dart';
import 'screens/rent_form_screen.dart';
import 'repositories/vehicle_repository.dart';
import 'repositories/customer_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicleRepository = VehicleRepository();
    final customerRepository = CustomerRepository();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomerProvider(customerRepository: customerRepository)),
        ChangeNotifierProvider(create: (_) => ManagerProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider(vehicleRepository: vehicleRepository)),
        ChangeNotifierProvider(create: (_) => RentProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
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
            title: 'SS Automóveis',
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
            locale: themeProvider.locale,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('pt', 'BR'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
