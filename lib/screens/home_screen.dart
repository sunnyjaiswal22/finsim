import 'package:finsim/models/ExpenditureModel.dart';
import 'package:finsim/models/IncomeModel.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/income.dart';
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
  late Future<List<Income>> futureIncomeList;
  late Future<List<Expenditure>> futureExpenditureList;

  @override
  void didChangeDependencies() {
    final incomeModel = Provider.of<IncomeModel>(context);
    futureIncomeList = incomeModel.items;
    final expenditureModel = Provider.of<ExpenditureModel>(context);
    futureExpenditureList = expenditureModel.items;
    super.didChangeDependencies();
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
      body: FutureBuilder(
        future: Future.wait([futureIncomeList, futureExpenditureList]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          List<Income> incomeList = snapshot.data![0];
          List<Expenditure> expenditureList = snapshot.data![1];
          final isBlankStart = incomeList.isEmpty && expenditureList.isEmpty;
          return isBlankStart ? Welcome() : CashFlowChart();
        },
      ),
    );
  }
}
