import 'package:finsim/helpers/globals.dart';
import 'package:finsim/widgets/asset_chart.dart';
import 'package:finsim/widgets/cashflow_chart.dart';
import 'package:finsim/widgets/liability_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    int yearsToSimulate = Globals.sharedPreferences.getInt('yearsToSimulate')!;
    if (yearsToSimulate > 7 && ModalRoute.of(context)!.isCurrent) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          CashFlowChart(),
          AssetChart(),
          LiabilityChart(),
        ],
      ),
    );
  }
}
