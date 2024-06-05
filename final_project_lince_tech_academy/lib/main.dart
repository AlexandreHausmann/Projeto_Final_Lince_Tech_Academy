import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/customerProvider.dart';
import 'screens/homeScreen.dart';
import 'providers/managerProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => ManagerProvider()), // Adicione o ManagerProvider aqui
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