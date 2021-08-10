import 'dart:developer';

import 'package:finsim/helpers/cache.dart';
import 'package:finsim/models/asset.dart';
import 'package:finsim/models/statement_entry.dart';
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
  static var globalCache = Cache();

  static Map<String, Object> simulate(
    List<Income> incomeList,
    List<Expenditure> expenditureList,
    List<Asset> assetList,
  ) {
    //Check if result exists in cache for the given input, return if present
    // if (listEquals(incomeList, globalCache.getObject('incomeList')) &&
    //     listEquals(expenditureList, globalCache.getObject('expenditureList')) &&
    //     listEquals(assetList, globalCache.getObject('assetList')) &&
    //     globalCache.getObject('result') != null) {
    //   log("Simulation result returned from cache");
    //   return globalCache.getObject('result');
    // }

    log("Simulating ...");
    Jiffy simulationStartDate = Jiffy().startOf(Units.DAY);
    Jiffy simulationEndDate = Jiffy(simulationStartDate).add(years: 5);
    var totalSavings = 0;
    var incomeAmountMap = <int, int>{};
    var expenditureAmountMap = <int, int>{};
    var assetTotalInvestmentMap = <int, int>{};
    var statementList = <StatementEntry>[];
    List<BarChartGroupData> savingsBarGroupList = [];
    List<BarChartGroupData> assetsBarGroupList = [];

    //******************** SIMULATION START ********************//
    for (Jiffy date = Jiffy(simulationStartDate);
        date.isSameOrBefore(simulationEndDate);
        date.add(days: 1)) {
      //******************** INCOME ********************//
      incomeList.forEach((income) {
        //Storing amount in another variable so as to not modify the original object
        if (!incomeAmountMap.containsKey(income.id)) {
          incomeAmountMap[income.id] = income.amount;
        }
        var onceEvent = income.frequency == IncomeFrequency.Once &&
            date.isSame(income.startDate);
        var monthlyEvent = income.frequency == IncomeFrequency.Monthly &&
            date.date == income.startDate.date &&
            date.isBefore(income.endDate);
        var yearlyEvent = income.frequency == IncomeFrequency.Yearly &&
            date.date == income.startDate.date &&
            date.month == income.startDate.month &&
            date.isBefore(income.endDate);

        if (onceEvent || monthlyEvent || yearlyEvent) {
          totalSavings += incomeAmountMap[income.id]!;
          statementList.add(
            StatementEntry(
              date: date.clone(),
              amount: incomeAmountMap[income.id]!,
              transactionType: TransactionType.Credit,
              message: income.name,
              details: describeEnum(income.frequency.toString()),
              balance: totalSavings,
            ),
          );
        }

        //Income year completed
        if (date.isSameOrBefore(income.endDate) &&
            date.date == income.startDate.date &&
            date.month == income.startDate.month &&
            date.year != income.startDate.year &&
            income.yearlyAppreciationPercentage != 0) {
          int yearlyAppreciation = (incomeAmountMap[income.id]! *
              income.yearlyAppreciationPercentage ~/
              100);
          incomeAmountMap[income.id] =
              incomeAmountMap[income.id]! + yearlyAppreciation;
          statementList.add(StatementEntry(
            date: date.clone(),
            amount: 0,
            transactionType: TransactionType.Credit,
            message: income.name +
                ': Appreciated by: ' +
                yearlyAppreciation.toString(),
            details: 'Yearly',
            balance: totalSavings,
          ));
        }
      });

      //******************** EXPENDITURE ********************//
      expenditureList.forEach((expenditure) {
        //Storing amount in another variable so as to not modify the original object
        if (!expenditureAmountMap.containsKey(expenditure.id)) {
          expenditureAmountMap[expenditure.id] = expenditure.amount;
        }
        var onceEvent = expenditure.frequency == ExpenditureFrequency.Once &&
            date.isSame(expenditure.startDate);
        var monthlyEvent =
            expenditure.frequency == ExpenditureFrequency.Monthly &&
                date.date == expenditure.startDate.date &&
                date.isBefore(expenditure.endDate);
        var yearlyEvent =
            expenditure.frequency == ExpenditureFrequency.Yearly &&
                date.date == expenditure.startDate.date &&
                date.month == expenditure.startDate.month &&
                date.isBefore(expenditure.endDate);

        if (onceEvent || monthlyEvent || yearlyEvent) {
          totalSavings -= expenditureAmountMap[expenditure.id]!;
          statementList.add(
            StatementEntry(
              date: date.clone(),
              amount: expenditureAmountMap[expenditure.id]!,
              transactionType: TransactionType.Debit,
              message: expenditure.name,
              details: describeEnum(expenditure.frequency.toString()),
              balance: totalSavings,
            ),
          );
        }

        //Expenditure year completed
        if (date.isSameOrBefore(expenditure.endDate) &&
            date.date == expenditure.startDate.date &&
            date.month == expenditure.startDate.month &&
            date.year != expenditure.startDate.year &&
            expenditure.yearlyAppreciationPercentage != 0) {
          int yearlyAppreciation = (expenditureAmountMap[expenditure.id]! *
              expenditure.yearlyAppreciationPercentage ~/
              100);
          expenditureAmountMap[expenditure.id] =
              expenditureAmountMap[expenditure.id]! + yearlyAppreciation;
          statementList.add(StatementEntry(
            date: date.clone(),
            amount: 0,
            transactionType: TransactionType.Debit,
            message: expenditure.name +
                ': Appreciated by: ' +
                yearlyAppreciation.toString(),
            details: 'Yearly',
            balance: totalSavings,
          ));
        }
      });

      //******************** ASSET ********************//
      assetList.forEach((asset) {
        //Initialize total asset investment if not present
        if (!assetTotalInvestmentMap.containsKey(asset.id)) {
          assetTotalInvestmentMap[asset.id] = 0;
        }
        //Investment in asset
        var onceEvent =
            asset.investment.frequency == ExpenditureFrequency.Once &&
                date.isSame(asset.investment.startDate);
        var monthlyEvent =
            asset.investment.frequency == ExpenditureFrequency.Monthly &&
                date.date == asset.investment.startDate.date &&
                date.isBefore(asset.investment.endDate);
        var yearlyEvent =
            asset.investment.frequency == ExpenditureFrequency.Yearly &&
                date.date == asset.investment.startDate.date &&
                date.month == asset.investment.startDate.month &&
                date.isBefore(asset.investment.endDate);

        if (onceEvent || monthlyEvent || yearlyEvent) {
          assetTotalInvestmentMap[asset.id] =
              assetTotalInvestmentMap[asset.id]! + asset.investment.amount;
        }

        //Asset year completed
        if (date.isSameOrBefore(asset.endDate) &&
            date.date == asset.startDate.date &&
            date.month == asset.startDate.month &&
            date.year != asset.startDate.year &&
            asset.yearlyAppreciationPercentage != 0) {
          int yearlyAppreciation = (assetTotalInvestmentMap[asset.id]! *
              asset.yearlyAppreciationPercentage ~/
              100);

          assetTotalInvestmentMap[asset.id] =
              assetTotalInvestmentMap[asset.id]! + yearlyAppreciation;

          statementList.add(StatementEntry(
            date: date.clone(),
            amount: 0,
            transactionType: TransactionType.Credit,
            message: asset.name + ': Profit: ' + yearlyAppreciation.toString(),
            details: 'Yearly',
            balance: totalSavings,
          ));
        }

        //Asset end date reached
        if (date.isSame(asset.endDate)) {
          var assetValue = assetTotalInvestmentMap[asset.id]!;
          totalSavings += assetValue;
          assetTotalInvestmentMap[asset.id] = 0;
          statementList.add(StatementEntry(
            date: date.clone(),
            amount: assetValue,
            transactionType: TransactionType.Credit,
            message: asset.name + ': Diluted',
            details: describeEnum(asset.investment.frequency.toString()),
            balance: totalSavings,
          ));
        }
      });

      //Simulation year completed
      if (date.date == simulationStartDate.date &&
          date.month == simulationStartDate.month &&
          date.year != simulationStartDate.year) {
        //Calculate total investments by checking current value of each asset
        var totalInvestments = 0;
        assetTotalInvestmentMap.forEach((key, value) {
          totalInvestments += value;
        });
        print('totalInvestments: $totalInvestments');
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
    var result = {
      'savings': savingsBarGroupList,
      'assets': assetsBarGroupList,
      'statementList': statementList,
    };

    //Caching input and result for future, for optimization
    globalCache.addObject('incomeList', incomeList);
    globalCache.addObject('expenditureList', expenditureList);
    globalCache.addObject('assetList', assetList);
    globalCache.addObject('result', result);
    return result;
  }
}
