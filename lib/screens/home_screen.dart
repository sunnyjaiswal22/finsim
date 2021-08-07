import 'package:finsim/models/asset_model.dart';
import 'package:finsim/models/expenditure_model.dart';
import 'package:finsim/models/Income_model.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/widgets/cashflow_chart.dart';
import 'package:finsim/widgets/dashboard.dart';
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
  DateTime currentBackPressTime = DateTime.now();

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
    return Consumer3<IncomeModel, ExpenditureModel, AssetModel>(
      builder: (context, incomeModel, expenditureModel, assetModel, _) {
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
                future:
                    Future.wait([incomeModel.items, expenditureModel.items]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  List<Income> incomeList = snapshot.data![0];
                  List<Expenditure> expenditureList = snapshot.data![1];
                  final isBlankStart =
                      incomeList.isEmpty && expenditureList.isEmpty;
                  return isBlankStart ? Welcome() : Dashboard();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
