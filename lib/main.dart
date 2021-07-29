import 'package:finsim/models/expenditure_model.dart';
import 'package:finsim/models/Income_source_model.dart';
import 'package:finsim/models/asset_model.dart';
import 'package:finsim/screens/add_asset_screen.dart';
import 'package:finsim/screens/add_expenditure_screen.dart';
import 'package:finsim/screens/add_income_source_screen.dart';
import 'package:finsim/screens/asset_list_screen.dart';
import 'package:finsim/screens/expenditure_list_screen.dart';
import 'package:finsim/screens/home_screen.dart';
import 'package:finsim/screens/income_source_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => IncomeSourceModel(),
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
        AddIncomeSourceScreen.routeName: (context) => AddIncomeSourceScreen(),
        IncomeSourceListScreen.routeName: (context) => IncomeSourceListScreen(),
        AddExpenditureScreen.routeName: (context) => AddExpenditureScreen(),
        ExpenditureListScreen.routeName: (context) => ExpenditureListScreen(),
        AssetListScreen.routeName: (context) => AssetListScreen(),
        AddAssetScreen.routeName: (context) => AddAssetScreen(),
      },
    );
  }
}
