import 'package:finsim/widgets/asset_chart.dart';
import 'package:finsim/widgets/cashflow_chart.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CashFlowChart(),
          AssetChart(),
        ],
      ),
    );
  }
}
