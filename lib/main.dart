import 'package:finsim/models/expenditure_model.dart';
import 'package:finsim/models/Income_model.dart';
import 'package:finsim/models/asset_model.dart';
import 'package:finsim/screens/add_asset_screen.dart';
import 'package:finsim/screens/add_expenditure_screen.dart';
import 'package:finsim/screens/add_income_screen.dart';
import 'package:finsim/screens/asset_list_screen.dart';
import 'package:finsim/screens/expenditure_list_screen.dart';
import 'package:finsim/screens/home_screen.dart';
import 'package:finsim/screens/income_list_screen.dart';
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
        IncomeListScreen.routeName: (context) => IncomeListScreen(),
        AddExpenditureScreen.routeName: (context) => AddExpenditureScreen(),
        ExpenditureListScreen.routeName: (context) => ExpenditureListScreen(),
        AssetListScreen.routeName: (context) => AssetListScreen(),
        AddAssetScreen.routeName: (context) => AddAssetScreen(),
      },
    );
  }
}
