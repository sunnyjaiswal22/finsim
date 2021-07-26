import 'package:finsim/models/Log.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/screens/add_expenditure_screen.dart'
    show ExpenditureFrequency;
import 'package:finsim/screens/add_income_screen.dart' show IncomeFrequency;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'custom_extensions.dart';

class Simulator {
  static List<BarChartGroupData> simulate(
      List<Income> incomeList, List<Expenditure> expenditureList) {
    DateTime now = DateTime.now();
    DateTime simulationStartDate = DateTime(now.year, now.month, now.day);
    DateTime simulationEndDate = simulationStartDate.add(
      Duration(days: 5 * 365 + 2), //Adding 2 to componsate for leap years
    );
    var totalAmount = 0;
    var statement = <Log>[];
    List<BarChartGroupData> barGroupList = [];
    for (DateTime date = simulationStartDate;
        date.isBefore(simulationEndDate);
        date = date.add(Duration(days: 1))) {
      incomeList.forEach((income) {
        var onceEvent = income.frequency == IncomeFrequency.Once &&
            income.startDate.isSameDate(date);
        var monthlyEvent = income.frequency == IncomeFrequency.Monthly &&
            date.day == income.startDate.day &&
            income.startDate.isBefore(date) &&
            income.endDate.isAfter(date);
        var yearlyEvent = income.frequency == IncomeFrequency.Monthly &&
            date.day == income.startDate.day &&
            date.month == income.startDate.month &&
            income.startDate.isBefore(date) &&
            income.endDate.isAfter(date);

        if (onceEvent || monthlyEvent || yearlyEvent) {
          totalAmount += income.amount;
          statement.add(
            Log(
              date: date,
              amount: income.amount,
              transactionType: TransactionType.Credit,
              message:
                  income.name + '-' + describeEnum(income.frequency.toString()),
              balance: totalAmount,
            ),
          );
        }

        //Income year completed
        if (income.startDate.difference(date).inDays % 365 == 0 &&
            income.yearlyAppreciationPercentage != 0) {
          int yearlyAppreciation =
              (income.amount * income.yearlyAppreciationPercentage ~/ 100);
          income.amount += yearlyAppreciation;
          statement.add(Log(
            date: date,
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
            expenditure.startDate.isSameDate(date);
        var monthlyEvent =
            expenditure.frequency == ExpenditureFrequency.Monthly &&
                date.day == expenditure.startDate.day &&
                expenditure.startDate.isBefore(date) &&
                expenditure.endDate.isAfter(date);
        var yearlyEvent =
            expenditure.frequency == ExpenditureFrequency.Monthly &&
                date.day == expenditure.startDate.day &&
                date.month == expenditure.startDate.month &&
                expenditure.startDate.isBefore(date) &&
                expenditure.endDate.isAfter(date);

        if (onceEvent || monthlyEvent || yearlyEvent) {
          totalAmount -= expenditure.amount;
          statement.add(
            Log(
              date: date,
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
        if (expenditure.startDate.difference(date).inDays % 365 == 0 &&
            expenditure.yearlyAppreciationPercentage != 0) {
          int yearlyAppreciation = (expenditure.amount *
              expenditure.yearlyAppreciationPercentage ~/
              100);
          expenditure.amount += yearlyAppreciation;
          statement.add(Log(
            date: date,
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
      if (simulationStartDate.difference(date).inDays % 365 == 0 &&
          !simulationStartDate.isSameDate(date)) {
        var barColor = totalAmount >= 0 ? Colors.green : Colors.red;

        var barChartGroupData = BarChartGroupData(
          x: date.year + 1,
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
    statement.forEach((log) {
      print(log);
    });
    return barGroupList;
  }
}
