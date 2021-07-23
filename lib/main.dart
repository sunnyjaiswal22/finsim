import 'package:finsim/models/IncomeModel.dart';
import 'package:finsim/screens/add_expenditure_screen.dart';
import 'package:finsim/screens/add_income_screen.dart';
import 'package:finsim/screens/expenditure_sources_screen.dart';
import 'package:finsim/screens/home_screen.dart';
import 'package:finsim/screens/income_sources_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => IncomeModel(),
        ),
      ],
      child: MyApp(),
    ),
  );
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
        AddExpenditureScreen.routeName: (context) => AddExpenditureScreen(),
        ExpenditureSourcesScreen.routeName: (context) =>
            ExpenditureSourcesScreen(),
      },
    );
  }
}
