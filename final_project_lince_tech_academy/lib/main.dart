import 'package:final_project_lince_tech_academy/providers/rentProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/customerProvider.dart';
import 'providers/managerProvider.dart';
import 'providers/vehicleProvider.dart';
import 'screens/homeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => ManagerProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => RentProvider()),


      ],
      child: MaterialApp(
        title: 'SS Automoveis',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}