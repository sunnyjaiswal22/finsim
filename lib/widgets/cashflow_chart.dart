import 'package:finsim/helpers/globals.dart';
import 'package:finsim/helpers/simulator.dart';
import 'package:finsim/models/asset.dart';
import 'package:finsim/models/asset_model.dart';
import 'package:finsim/models/expenditure_model.dart';
import 'package:finsim/models/Income_model.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/models/liability.dart';
import 'package:finsim/models/liability_model.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CashFlowChart extends StatefulWidget {
  const CashFlowChart({Key? key}) : super(key: key);
  static final routeName = 'cashflow-chart';

  @override
  _CashFlowChartState createState() => _CashFlowChartState();
}

class _CashFlowChartState extends State<CashFlowChart> {
  var currencyFormat = new NumberFormat("#,##,##,###", "en_IN");
  DateTime now = new DateTime.now();

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
    double aspectRatio;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      aspectRatio = 1.618;
    } else {
      aspectRatio = 2.5;
    }
    int yearsToSimulate = Globals.sharedPreferences.getInt('yearsToSimulate')!;
    return Consumer4<IncomeModel, ExpenditureModel, AssetModel, LiabilityModel>(
      builder: (context, incomeModel, expenditureModel, assetModel,
          liabilityModel, _) {
        return FutureBuilder(
          future: Future.wait([
            incomeModel.items,
            expenditureModel.items,
            assetModel.items,
            liabilityModel.items,
          ]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return AspectRatio(
                aspectRatio: aspectRatio,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            List<Income> incomeList = snapshot.data![0];
            List<Expenditure> expenditureList = snapshot.data![1];
            List<Asset> assetList = snapshot.data![2];
            List<Liability> liabilityList = snapshot.data![3];
            if (incomeList.isEmpty && expenditureList.isEmpty) {
              return Container();
            }
            final barChartGroupDataList = Simulator.simulate(
              incomeList,
              expenditureList,
              assetList,
              liabilityList,
            )['savings']!;
            final horizontalGridInterval = getHorizontalGridInterval(
                barChartGroupDataList as List<BarChartGroupData>);
            return Container(
              padding: const EdgeInsets.all(5),
              margin: EdgeInsets.only(top: 15),
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  color: Colors.white,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: getMaxY(
                          barChartGroupDataList, horizontalGridInterval),
                      minY: getMinY(
                          barChartGroupDataList, horizontalGridInterval),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTitles: (double value) {
                            if (yearsToSimulate <= 10) {
                              return DateFormat('MMM').format(now) +
                                  ' ' +
                                  value.toInt().toString();
                            } else {
                              return value.toInt().toString();
                            }
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
                            titleText: 'Time',
                            margin: 0,
                          ),
                          leftTitle: AxisTitle(
                            showTitle: true,
                            titleText: 'Amount',
                          ),
                          topTitle: AxisTitle(
                            showTitle: true,
                            titleText: 'Savings',
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
                                fontSize: (12 - (yearsToSimulate / 5 - 1)),
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
      },
    );
  }
}
