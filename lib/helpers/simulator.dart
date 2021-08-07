import 'package:finsim/models/asset.dart';
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
  static Map<String, List<BarChartGroupData>> simulate(
    List<Income> incomeList,
    List<Expenditure> expenditureList,
    List<Asset> assetList,
  ) {
    Jiffy simulationStartDate = Jiffy().startOf(Units.DAY);
    Jiffy simulationEndDate = Jiffy(simulationStartDate).add(years: 5);
    var totalSavings = 0;
    var totalInvestments = 0;
    var assetInvestmentMap = <int, int>{};
    var statement = <Log>[];
    List<BarChartGroupData> savingsBarGroupList = [];
    List<BarChartGroupData> assetsBarGroupList = [];

    //******************** SIMULATION START ********************//
    for (Jiffy date = Jiffy(simulationStartDate);
        date.isSameOrBefore(simulationEndDate);
        date.add(days: 1)) {
      //******************** INCOME ********************//
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
          totalSavings += income.amount;
          statement.add(
            Log(
              date: date.dateTime,
              amount: income.amount,
              transactionType: TransactionType.Credit,
              message:
                  income.name + '-' + describeEnum(income.frequency.toString()),
              balance: totalSavings,
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
            balance: totalSavings,
          ));
        }
      });

      //******************** EXPENDITURE ********************//
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
          totalSavings -= expenditure.amount;
          statement.add(
            Log(
              date: date.dateTime,
              amount: expenditure.amount,
              transactionType: TransactionType.Debit,
              message: expenditure.name +
                  '-' +
                  describeEnum(expenditure.frequency.toString()),
              balance: totalSavings,
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
            balance: totalSavings,
          ));
        }
      });

      //******************** ASSET ********************//
      assetList.forEach((asset) {
        var onceEvent =
            asset.investment.frequency == ExpenditureFrequency.Once &&
                date.isSame(asset.investment.startDate);
        var monthlyEvent =
            asset.investment.frequency == ExpenditureFrequency.Monthly &&
                date.date == asset.investment.startDate.date &&
                date.isSameOrBefore(asset.investment.endDate);
        var yearlyEvent =
            asset.investment.frequency == ExpenditureFrequency.Yearly &&
                date.date == asset.investment.startDate.date &&
                date.month == asset.investment.startDate.month &&
                date.isSameOrBefore(asset.investment.endDate);

        if (onceEvent || monthlyEvent || yearlyEvent) {
          totalInvestments += asset.investment.amount;
          if (!assetInvestmentMap.containsKey(asset.id)) {
            assetInvestmentMap[asset.id] = 0;
          }
          assetInvestmentMap[asset.id] =
              assetInvestmentMap[asset.id]! + asset.investment.amount;
          statement.add(
            Log(
              date: date.dateTime,
              amount: asset.investment.amount,
              transactionType: TransactionType.Debit,
              message: asset.investment.name +
                  '-' +
                  describeEnum(asset.investment.frequency.toString()),
              balance: totalInvestments,
            ),
          );
        }

        //Asset Investment year completed
        if (date.isBetween(
                asset.investment.startDate, asset.investment.endDate) &&
            date.date == asset.investment.startDate.date &&
            date.month == asset.investment.startDate.month &&
            date.year != asset.investment.startDate.year &&
            asset.investment.yearlyAppreciationPercentage != 0) {
          int yearlyAppreciation = (asset.investment.amount *
              asset.investment.yearlyAppreciationPercentage ~/
              100);
          asset.investment.amount += yearlyAppreciation;
          statement.add(Log(
            date: date.dateTime,
            amount: 0,
            transactionType: TransactionType.Debit,
            message: describeEnum(asset.investment.frequency.toString()) +
                '-' +
                asset.investment.name +
                ': Appreciated by: ' +
                yearlyAppreciation.toString(),
            balance: totalInvestments,
          ));
        }

        //Asset end date reached
        if (date.isSame(asset.endDate)) {
          if (assetInvestmentMap.containsKey(asset.id)) {
            totalSavings += assetInvestmentMap[asset.id]!;
            totalInvestments -= assetInvestmentMap[asset.id]!;
            assetInvestmentMap[asset.id] = 0;
          }
        }
      });

      //Simulation year completed
      if (date.date == simulationStartDate.date &&
          date.month == simulationStartDate.month &&
          date.year != simulationStartDate.year) {
        var savingsBarColor = totalSavings >= 0 ? Colors.green : Colors.red;
        var assetsBarColor = totalInvestments >= 0 ? Colors.green : Colors.red;

        var savingsBarChartGroupData = BarChartGroupData(
          x: date.year,
          barRods: [
            BarChartRodData(
              y: totalSavings.toDouble(),
              colors: [
                savingsBarColor,
                savingsBarColor,
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
              width: 30,
            )
          ],
          //Not showing tooltip value in case of 0 amount as it overlaps with bottom titles
          showingTooltipIndicators: totalSavings == 0 ? [] : [0],
        );
        var assetsBarChartGroupData = BarChartGroupData(
          x: date.year,
          barRods: [
            BarChartRodData(
              y: totalInvestments.toDouble(),
              colors: [
                assetsBarColor,
                assetsBarColor,
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
              width: 30,
            )
          ],
          //Not showing tooltip value in case of 0 amount as it overlaps with bottom titles
          showingTooltipIndicators: totalInvestments == 0 ? [] : [0],
        );

        savingsBarGroupList.add(savingsBarChartGroupData);
        assetsBarGroupList.add(assetsBarChartGroupData);
      }
    }
    // statement.forEach((log) {
    //   print(log);
    // });
    return {'savings': savingsBarGroupList, 'assets': assetsBarGroupList};
  }
}
