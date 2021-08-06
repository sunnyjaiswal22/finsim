import 'package:finsim/models/log.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/screens/add_expenditure_screen.dart'
    show ExpenditureFrequency;
import 'package:finsim/screens/add_income_screen.dart' show IncomeFrequency;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class Simulator {
  static List<BarChartGroupData> simulate(
      List<Income> incomeList, List<Expenditure> expenditureList) {
    Jiffy simulationStartDate = Jiffy().startOf(Units.DAY);
    Jiffy simulationEndDate = Jiffy(simulationStartDate).add(years: 5);
    var totalAmount = 0;
    var statement = <Log>[];
    List<BarChartGroupData> barGroupList = [];
    for (Jiffy date = Jiffy(simulationStartDate);
        date.isSameOrBefore(simulationEndDate);
        date.add(days: 1)) {
      incomeList.forEach((income) {
        var onceEvent = income.frequency == IncomeFrequency.Once &&
            date.isSame(income.startDate);
        var monthlyEvent = income.frequency == IncomeFrequency.Monthly &&
            date.date == income.startDate.date &&
            date.isSameOrBefore(income.endDate);
        var yearlyEvent = income.frequency == IncomeFrequency.Yearly &&
            date.date == income.startDate.date &&
            date.month == income.startDate.month &&
            date.isSameOrBefore(income.endDate);

        if (onceEvent || monthlyEvent || yearlyEvent) {
          totalAmount += income.amount;
          statement.add(
            Log(
              date: date.dateTime,
              amount: income.amount,
              transactionType: TransactionType.Credit,
              message:
                  income.name + '-' + describeEnum(income.frequency.toString()),
              balance: totalAmount,
            ),
          );
        }

        //Income year completed
        if (date.isBetween(income.startDate, income.endDate) &&
            date.date == income.startDate.date &&
            date.month == income.startDate.month &&
            date.year != income.startDate.year &&
            income.yearlyAppreciationPercentage != 0) {
          int yearlyAppreciation =
              (income.amount * income.yearlyAppreciationPercentage ~/ 100);
          income.amount += yearlyAppreciation;
          statement.add(Log(
            date: date.dateTime,
            amount: 0,
            transactionType: TransactionType.Credit,
            message: describeEnum(income.frequency.toString()) +
                '-' +
                income.name +
                ': Appreciated by: ' +
                yearlyAppreciation.toString(),
            balance: totalAmount,
          ));
        }
      });

      expenditureList.forEach((expenditure) {
        var onceEvent = expenditure.frequency == ExpenditureFrequency.Once &&
            date.isSame(expenditure.startDate);
        var monthlyEvent =
            expenditure.frequency == ExpenditureFrequency.Monthly &&
                date.date == expenditure.startDate.date &&
                date.isSameOrBefore(expenditure.endDate);
        var yearlyEvent =
            expenditure.frequency == ExpenditureFrequency.Yearly &&
                date.date == expenditure.startDate.date &&
                date.month == expenditure.startDate.month &&
                date.isSameOrBefore(expenditure.endDate);

        if (onceEvent || monthlyEvent || yearlyEvent) {
          totalAmount -= expenditure.amount;
          statement.add(
            Log(
              date: date.dateTime,
              amount: expenditure.amount,
              transactionType: TransactionType.Debit,
              message: expenditure.name +
                  '-' +
                  describeEnum(expenditure.frequency.toString()),
              balance: totalAmount,
            ),
          );
        }

        //Expenditure year completed
        if (date.isBetween(expenditure.startDate, expenditure.endDate) &&
            date.date == expenditure.startDate.date &&
            date.month == expenditure.startDate.month &&
            date.year != expenditure.startDate.year &&
            expenditure.yearlyAppreciationPercentage != 0) {
          int yearlyAppreciation = (expenditure.amount *
              expenditure.yearlyAppreciationPercentage ~/
              100);
          expenditure.amount += yearlyAppreciation;
          statement.add(Log(
            date: date.dateTime,
            amount: 0,
            transactionType: TransactionType.Debit,
            message: describeEnum(expenditure.frequency.toString()) +
                '-' +
                expenditure.name +
                ': Appreciated by: ' +
                yearlyAppreciation.toString(),
            balance: totalAmount,
          ));
        }
      });

      //Simulation year completed
      if (date.date == simulationStartDate.date &&
          date.month == simulationStartDate.month &&
          date.year != simulationStartDate.year) {
        var barColor = totalAmount >= 0 ? Colors.green : Colors.red;

        var barChartGroupData = BarChartGroupData(
          x: date.year,
          barRods: [
            BarChartRodData(
              y: totalAmount.toDouble(),
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
          showingTooltipIndicators: totalAmount == 0 ? [] : [0],
        );

        barGroupList.add(barChartGroupData);
      }
    }
    // statement.forEach((log) {
    //   print(log);
    // });
    return barGroupList;
  }
}
