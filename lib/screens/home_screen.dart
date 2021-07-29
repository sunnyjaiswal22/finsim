import 'package:finsim/models/expenditure_model.dart';
import 'package:finsim/models/Income_source_model.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/income_source.dart';
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
  late Future<List<IncomeSource>> futureIncomeList;
  late Future<List<Expenditure>> futureExpenditureList;
  DateTime currentBackPressTime = DateTime.now();

  @override
  void didChangeDependencies() {
    final incomeModel = Provider.of<IncomeSourceModel>(context);
    futureIncomeList = incomeModel.items;
    final expenditureModel = Provider.of<ExpenditureModel>(context);
    futureExpenditureList = expenditureModel.items;
    super.didChangeDependencies();
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Press back again to exit",
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2),
      ));
      return Future.value(false);
    }
    return Future.value(true);
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
      body: WillPopScope(
        onWillPop: onWillPop,
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: Future.wait([futureIncomeList, futureExpenditureList]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              List<IncomeSource> incomeList = snapshot.data![0];
              List<Expenditure> expenditureList = snapshot.data![1];
              final isBlankStart =
                  incomeList.isEmpty && expenditureList.isEmpty;
              return isBlankStart ? Welcome() : CashFlowChart();
            },
          ),
        ),
      ),
    );
  }
}
