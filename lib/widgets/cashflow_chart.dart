import 'dart:math' as math;
import 'dart:ui';
import 'package:finsim/models/ExpenditureModel.dart';
import 'package:finsim/models/IncomeModel.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/screens/add_expenditure_screen.dart'
    show ExpenditureFrequency;
import 'package:finsim/screens/add_income_screen.dart' show IncomeFrequency;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CashFlowChart extends StatefulWidget {
  const CashFlowChart({Key? key}) : super(key: key);

  @override
  _CashFlowChartState createState() => _CashFlowChartState();
}

class _CashFlowChartState extends State<CashFlowChart> {
  var currencyFormat = new NumberFormat("#,##,##,###", "en_IN");
  late Future<List<Income>> futureIncomeList;
  late Future<List<Expenditure>> futureExpenditureList;
  DateTime now = new DateTime.now();

  @override
  void didChangeDependencies() {
    final incomeModel = Provider.of<IncomeModel>(context);
    futureIncomeList = incomeModel.items;
    final expenditureModel = Provider.of<ExpenditureModel>(context);
    futureExpenditureList = expenditureModel.items;
    super.didChangeDependencies();
  }

  List<BarChartGroupData> generateBarChartGroupData(
      List<Income> incomeList, List<Expenditure> expenditureList) {
    List<BarChartGroupData> barGroupList = [];

    var currentYear = now.year;
    var totalYearlyAmount = 0;
    for (var year = 0; year < 5; year++) {
      incomeList.forEach(
        (income) {
          if (income.frequency == IncomeFrequency.Once && year == 1) {
            totalYearlyAmount += income.amount;
          } else if (income.frequency == IncomeFrequency.Monthly) {
            var yearlyAmount = income.amount * 12;
            totalYearlyAmount += (yearlyAmount *
                    math.pow(
                        (1 + income.yearlyAppreciationPercentage / 100), year))
                .toInt();
          } else if (income.frequency == IncomeFrequency.Yearly) {
            totalYearlyAmount += (income.amount *
                    math.pow(
                        (1 + income.yearlyAppreciationPercentage / 100), year))
                .toInt();
          }
        },
      );

      expenditureList.forEach(
        (expenditure) {
          if (expenditure.frequency == ExpenditureFrequency.Once && year == 1) {
            totalYearlyAmount -= expenditure.amount;
          } else if (expenditure.frequency == ExpenditureFrequency.Monthly) {
            var yearlyAmount = expenditure.amount * 12;
            totalYearlyAmount -= (yearlyAmount *
                    math.pow(
                        (1 + expenditure.yearlyAppreciationPercentage / 100),
                        year))
                .toInt();
          } else if (expenditure.frequency == ExpenditureFrequency.Yearly) {
            totalYearlyAmount += (expenditure.amount *
                    math.pow(
                        (1 + expenditure.yearlyAppreciationPercentage / 100),
                        year))
                .toInt();
          }
        },
      );

      var barColor = totalYearlyAmount >= 0 ? Colors.green : Colors.red;

      var barChartGroupData = BarChartGroupData(
        x: currentYear + year + 1,
        barRods: [
          BarChartRodData(
            y: totalYearlyAmount.toDouble(),
            colors: [
              barColor,
              barColor,
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
            width: 30,
          )
        ],
        //Not showing tooltip value in case of 0 amount as it overlaps with bottom titles
        showingTooltipIndicators: totalYearlyAmount == 0 ? [] : [0],
      );

      barGroupList.add(barChartGroupData);
    }
    return barGroupList;
  }

  double getHorizontalGridInterval(
      List<BarChartGroupData> barChartGroupDataList) {
    double horizontalGridInterval = 0;
    double minAmount = 0, maxAmount = 0;
    barChartGroupDataList.forEach((barChartGroupData) {
      var y = barChartGroupData.barRods[0].y;
      minAmount = minAmount < y ? minAmount : y;
      maxAmount = maxAmount > y ? maxAmount : y;
    });
    horizontalGridInterval = (maxAmount - minAmount) / 5;
    return horizontalGridInterval != 0 ? horizontalGridInterval : 5;
  }

  double getMaxY(
    List<BarChartGroupData> barChartGroupDataList,
    double horizontalGridInterval,
  ) {
    double maxAmount = 0, maxY = 0;
    barChartGroupDataList.forEach((barChartGroupData) {
      var y = barChartGroupData.barRods[0].y;
      maxAmount = maxAmount > y ? maxAmount : y;
    });
    maxY =
        maxAmount > 0 ? (maxAmount + horizontalGridInterval * 1.5) : maxAmount;
    return maxY;
  }

  double getMinY(
    List<BarChartGroupData> barChartGroupDataList,
    double horizontalGridInterval,
  ) {
    double minAmount = 0, minY = 0;
    barChartGroupDataList.forEach((barChartGroupData) {
      var y = barChartGroupData.barRods[0].y;
      minAmount = minAmount < y ? minAmount : y;
    });
    minY =
        minAmount < 0 ? (minAmount - horizontalGridInterval * 1.5) : minAmount;
    return minY;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([futureIncomeList, futureExpenditureList]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        List<Income> incomeList = snapshot.data![0];
        List<Expenditure> expenditureList = snapshot.data![1];
        final barChartGroupDataList = generateBarChartGroupData(
          incomeList,
          expenditureList,
        );
        final horizontalGridInterval =
            getHorizontalGridInterval(barChartGroupDataList);
        return Container(
          padding: const EdgeInsets.all(5),
          margin: EdgeInsets.only(top: 15),
          child: AspectRatio(
            aspectRatio: 1.618,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              color: Colors.white,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: getMaxY(barChartGroupDataList, horizontalGridInterval),
                  minY: getMinY(barChartGroupDataList, horizontalGridInterval),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (double value) {
                        return DateFormat('MMM').format(now) +
                            ' ' +
                            value.toInt().toString();
                      },
                    ),
                    leftTitles: SideTitles(showTitles: false),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(),
                      left: BorderSide(),
                    ),
                  ),
                  axisTitleData: FlAxisTitleData(
                      bottomTitle: AxisTitle(
                        showTitle: true,
                        titleText: 'Year',
                        margin: 0,
                      ),
                      leftTitle: AxisTitle(
                        showTitle: true,
                        titleText: 'Amount',
                      ),
                      topTitle: AxisTitle(
                        showTitle: true,
                        titleText: 'Commulative Cash Flow',
                        margin: 15,
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      )),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: horizontalGridInterval,
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipMargin: 2,
                      tooltipPadding: EdgeInsets.all(0),
                      getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                      ) {
                        return BarTooltipItem(
                          currencyFormat.format(rod.y),
                          TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  barGroups: barChartGroupDataList,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
