import 'package:charts_flutter/flutter.dart' as charts;
import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/screens/add_income_screen.dart';
import 'package:finsim/widgets/finsim_appbar.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  static final routeName = 'dashboard-screen';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var chartData;

  @override
  Widget build(BuildContext context) {
    if (chartData == null) {
      DBHelper.getIncome().then((incomeList) {
        DateTime now = new DateTime.now();
        var currentYear = now.year;

        List<OrdinalData> ordinalDataList = [
          OrdinalData((currentYear + 1).toString(), 0),
          OrdinalData((currentYear + 2).toString(), 0),
          OrdinalData((currentYear + 3).toString(), 0),
          OrdinalData((currentYear + 4).toString(), 0),
          OrdinalData((currentYear + 5).toString(), 0),
        ];

        incomeList.forEach((income) {
          print(
              'Looping for income id ${income.id} with amount ${income.amount}');
          var adjustedIncomeAmount = income.amount;

          for (int i = 0; i < 5; i++) {
            var totalIncomeThisYear = 0;

            if (income.frequency == IncomeFrequency.Monthly) {
              totalIncomeThisYear = adjustedIncomeAmount * 12;
            }
            if (income.frequency == IncomeFrequency.Yearly) {
              totalIncomeThisYear = adjustedIncomeAmount;
            }

            adjustedIncomeAmount = (adjustedIncomeAmount +
                    (adjustedIncomeAmount *
                        income.yearlyAppreciationPercentage /
                        100))
                .toInt();

            print('Year $i income: $totalIncomeThisYear');

            ordinalDataList[i].value += totalIncomeThisYear;
          }
        });

        setState(() {
          chartData = [
            new charts.Series<OrdinalData, String>(
              id: 'Cash Flow',
              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
              domainFn: (OrdinalData data, _) => data.label,
              measureFn: (OrdinalData data, _) => data.value,
              data: ordinalDataList,
            )
          ];
        });
      });
    }

    return Scaffold(
      appBar: FinSimAppBar.appbar(title: 'Finance Simulator'),
      drawer: NavigationDrawer(),
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text('Cash Flow'),
              chartData == null
                  ? Container(
                      height: 250,
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      height: 250,
                      child: charts.BarChart(
                        chartData,
                        animate: true,
                        selectionModels: [
                          new charts.SelectionModelConfig(
                              changedListener: (charts.SelectionModel model) {
                            SnackBar snackBar = SnackBar(
                              content: Text(
                                'Amount: ${model.selectedSeries[0].measureFn(model.selectedDatum[0].index)}',
                                textAlign: TextAlign.center,
                              ),
                              duration: Duration(seconds: 1),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          })
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdinalData {
  String label;
  int value;
  OrdinalData(this.label, this.value);
}
