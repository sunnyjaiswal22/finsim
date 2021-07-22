import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/widgets/cashflow_chart.dart';
import 'package:finsim/widgets/welcome.dart';
import 'package:flutter/material.dart';

import 'package:finsim/widgets/navigation_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static final routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isLoading = true;
  var _isBlankStart = true;
  @override
  Widget build(BuildContext context) {
    DBHelper.getIncome().then((incomeList) {
      DBHelper.getExpenditure().then((expenditureList) {
        if (incomeList.isNotEmpty || expenditureList.isNotEmpty) {
          _isBlankStart = false;
        }
        setState(() {
          _isLoading = false;
        });
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/logo_white.png',
            fit: BoxFit.contain,
            height: 32,
          ),
        ),
      ),
      drawer: NavigationDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _isBlankStart
              ? Welcome()
              : CashFlowChart(),
    );
  }
}
