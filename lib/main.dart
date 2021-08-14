import 'package:finsim/models/expenditure_model.dart';
import 'package:finsim/models/Income_model.dart';
import 'package:finsim/models/asset_model.dart';
import 'package:finsim/screens/add_asset_screen.dart';
import 'package:finsim/screens/add_expenditure_screen.dart';
import 'package:finsim/screens/add_income_screen.dart';
import 'package:finsim/screens/add_investment_screen.dart';
import 'package:finsim/screens/add_liability_screen.dart';
import 'package:finsim/screens/list_asset_screen.dart';
import 'package:finsim/screens/list_expenditure_screen.dart';
import 'package:finsim/screens/home_screen.dart';
import 'package:finsim/screens/list_income_screen.dart';
import 'package:finsim/screens/list_liability_screen.dart';
import 'package:finsim/screens/statement_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => IncomeModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ExpenditureModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AssetModel(),
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
        ListIncomeScreen.routeName: (context) => ListIncomeScreen(),
        AddExpenditureScreen.routeName: (context) => AddExpenditureScreen(),
        ListExpenditureScreen.routeName: (context) => ListExpenditureScreen(),
        ListAssetScreen.routeName: (context) => ListAssetScreen(),
        ListLiabilityScreen.routeName: (context) => ListLiabilityScreen(),
        AddAssetScreen.routeName: (context) => AddAssetScreen(),
        AddInvestmentScreen.routeName: (context) => AddInvestmentScreen(),
        AddLiabilityScreen.routeName: (context) => AddLiabilityScreen(),
        StatementScreen.routeName: (context) => StatementScreen(),
      },
    );
  }
}
