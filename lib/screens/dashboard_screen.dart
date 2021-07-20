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
  var maxYearlyAmount = 0;
  var minYearlyAmount = 0;
  @override
  Widget build(BuildContext context) {
    if (barGroupList.isEmpty) {
      DBHelper.getIncome().then((incomeList) {
        DBHelper.getExpenditure().then((expenditureList) {
          setState(() {
            DateTime now = new DateTime.now();
            var currentYear = now.year;
            for (var year = 1; year <= 5; year++) {
              var totalYearlyAmount = 0;

              incomeList.forEach(
                (income) {
                  totalYearlyAmount += (income.amount *
                          math.pow(
                              (1 + income.yearlyAppreciationPercentage / 100),
                              year))
                      .toInt();
                },
              );

              expenditureList.forEach((expenditure) {
                totalYearlyAmount -= (expenditure.amount *
                        math.pow(
                            (1 +
                                expenditure.yearlyAppreciationPercentage / 100),
                            year))
                    .toInt();
              });

              maxYearlyAmount = maxYearlyAmount < totalYearlyAmount
                  ? totalYearlyAmount
                  : maxYearlyAmount;
              minYearlyAmount = minYearlyAmount > totalYearlyAmount
                  ? totalYearlyAmount
                  : minYearlyAmount;

              var barColor = totalYearlyAmount >= 0 ? Colors.green : Colors.red;

              var barChartGroupData = BarChartGroupData(
                x: currentYear + year,
                barRods: [
                  BarChartRodData(
                    y: totalYearlyAmount.toDouble(),
                    colors: [
                      barColor,
                      barColor,
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(2),
                      topRight: Radius.circular(2),
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
      });
    }

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
              maxY: maxYearlyAmount > 0
                  ? (maxYearlyAmount + minYearlyAmount.abs()) * 1.4
                  : 0,
              minY: minYearlyAmount < 0
                  ? -(maxYearlyAmount + minYearlyAmount.abs()) * 1.4
                  : 0,
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
                border: Border(
                  bottom: BorderSide(),
                ),
              ),
              barGroups: barGroupList,
            ),
          ),
        ),
      ),
    );
  }
}
