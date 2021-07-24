import 'dart:developer';

import 'package:finsim/models/ExpenditureModel.dart';
import 'package:finsim/models/IncomeModel.dart';
import 'package:finsim/widgets/cashflow_chart.dart';
import 'package:finsim/widgets/welcome.dart';
import 'package:flutter/material.dart';

import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static final routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isBlankStart = true;
  var _isLoading = true;

  @override
  void initState() {
    //log("HomeScreen: Init state");
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      //log('HomeScreen: InitState callback, loading data ...');
      final incomeModel = Provider.of<IncomeModel>(context, listen: false);
      final futureIncomeList = incomeModel.items;

      final expenditureModel =
          Provider.of<ExpenditureModel>(context, listen: false);
      final futureExpenditureList = expenditureModel.items;

      futureIncomeList.then((incomeList) {
        futureExpenditureList.then((expenditureList) {
          if (incomeList.isNotEmpty || expenditureList.isNotEmpty) {
            setState(() {
              _isBlankStart = false;
            });
          }
          setState(() {
            _isLoading = false;
          });
          //log('HomeScreen: Data loaded, _isBlankStart:$_isBlankStart, _isLoading: $_isLoading');
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
