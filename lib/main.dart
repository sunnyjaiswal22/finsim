import 'package:finsim/screens/add_income_screen.dart';
import 'package:finsim/screens/home_screen.dart';
import 'package:finsim/screens/income_sources_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial Simulator',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        AddIncomeScreen.routeName: (context) => AddIncomeScreen(),
        IncomeSourcesScreen.routeName: (context) => IncomeSourcesScreen(),
      },
    );
  }
}
