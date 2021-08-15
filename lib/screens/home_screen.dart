import 'package:finsim/models/asset.dart';
import 'package:finsim/models/asset_model.dart';
import 'package:finsim/models/expenditure_model.dart';
import 'package:finsim/models/Income_model.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/models/liability.dart';
import 'package:finsim/models/liability_model.dart';
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
    return Consumer4<IncomeModel, ExpenditureModel, AssetModel, LiabilityModel>(
      builder: (
        context,
        incomeModel,
        expenditureModel,
        assetModel,
        liabilityModel,
        _,
      ) {
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
                future: Future.wait([
                  incomeModel.items,
                  expenditureModel.items,
                  assetModel.items,
                  liabilityModel.items,
                ]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    List<Income> incomeList = snapshot.data![0];
                    List<Expenditure> expenditureList = snapshot.data![1];
                    List<Asset> assetList = snapshot.data![2];
                    List<Liability> liabilityList = snapshot.data![3];
                    final isBlankStart = incomeList.isEmpty &&
                        expenditureList.isEmpty &&
                        assetList.isEmpty &&
                        liabilityList.isEmpty;
                    return isBlankStart ? Welcome() : Dashboard();
                  }
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
