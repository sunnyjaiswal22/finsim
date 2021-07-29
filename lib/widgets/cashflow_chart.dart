import 'package:finsim/helpers/simulator.dart';
import 'package:finsim/models/expenditure_model.dart';
import 'package:finsim/models/Income_source_model.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/income_source.dart';
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
  late Future<List<IncomeSource>> futureIncomeList;
  late Future<List<Expenditure>> futureExpenditureList;
  DateTime now = new DateTime.now();

  @override
  void didChangeDependencies() {
    final incomeModel = Provider.of<IncomeSourceModel>(context);
    futureIncomeList = incomeModel.items;
    final expenditureModel = Provider.of<ExpenditureModel>(context);
    futureExpenditureList = expenditureModel.items;
    super.didChangeDependencies();
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
          return AspectRatio(
            aspectRatio: 1.618,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        List<IncomeSource> incomeList = snapshot.data![0];
        List<Expenditure> expenditureList = snapshot.data![1];
        final barChartGroupDataList = Simulator.simulate(
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
                        titleText: 'Time',
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
