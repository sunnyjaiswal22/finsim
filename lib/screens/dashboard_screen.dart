import 'dart:developer';
import 'dart:math' as math;

import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/widgets/finsim_appbar.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  static final routeName = 'dashboard-screen';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<BarChartGroupData> barGroupList = [];
  var maxYearlyIncome = 0;

  @override
  Widget build(BuildContext context) {
    log("barGroupList.isEmpty: ${barGroupList.isEmpty}");
    if (barGroupList.isEmpty) {
      DBHelper.getIncome().then((incomeList) {
        setState(() {
          DateTime now = new DateTime.now();
          var currentYear = now.year;

          for (var year = 1; year <= 5; year++) {
            log("Computing income for year: $year");
            var totalYearlyIncome = 0;
            incomeList.forEach(
              (income) {
                log("Adding income ${income.amount}");
                totalYearlyIncome += (income.amount *
                        math.pow(
                            (1 + income.yearlyAppreciationPercentage / 100),
                            year))
                    .toInt();
                maxYearlyIncome = maxYearlyIncome < totalYearlyIncome
                    ? totalYearlyIncome
                    : maxYearlyIncome;
                log("totalYearlyIncome $totalYearlyIncome");
              },
            );
            var barChartGroupData = BarChartGroupData(
              x: currentYear + year,
              barRods: [
                BarChartRodData(
                  y: totalYearlyIncome.toDouble(),
                  colors: [
                    Theme.of(context).primaryColorDark,
                    Theme.of(context).primaryColorDark,
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  width: 30,
                )
              ],
              showingTooltipIndicators: [0],
            );

            barGroupList.add(barChartGroupData);
          }
        });
      });
    }

    log("maxYAxisValue: $maxYearlyIncome");

    return Scaffold(
      appBar: FinSimAppBar.appbar(title: 'Finance Simulator'),
      drawer: NavigationDrawer(),
      body: AspectRatio(
        aspectRatio: 1.618,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: Colors.white,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxYearlyIncome + maxYearlyIncome / 2.5,
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTitles: (double value) {
                    return value.toInt().toString();
                  },
                ),
                leftTitles: SideTitles(showTitles: false),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(bottom: BorderSide()),
              ),
              barGroups: barGroupList,
            ),
          ),
        ),
      ),
    );
  }
}
