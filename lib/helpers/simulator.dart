import 'dart:developer';

import 'package:finsim/helpers/cache.dart';
import 'package:finsim/helpers/common_calculator.dart';
import 'package:finsim/helpers/globals.dart';
import 'package:finsim/models/asset.dart';
import 'package:finsim/models/liability.dart';
import 'package:finsim/models/statement_entry.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/screens/add_expenditure_screen.dart' show ExpenditureFrequency;
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
    List<Liability> liabilitiesList,
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
    int yearsToSimulate = Globals.sharedPreferences.getInt('yearsToSimulate')!;
    Jiffy simulationStartDate = Jiffy().startOf(Units.DAY);
    Jiffy simulationEndDate = Jiffy(simulationStartDate).add(years: yearsToSimulate);
    var totalSavings = 0.0;
    var incomeAmountMap = <int, double>{};
    var expenditureAmountMap = <int, double>{};
    var assetInvestmentMap = <int, double>{};
    var liabilityAmountMap = <int, double>{};
    var liabilityExpenditureLastDebitMap = <int, Map<String, double>>{};
    var statementList = <StatementEntry>[];
    List<BarChartGroupData> savingsBarGroupList = [];
    List<BarChartGroupData> assetsBarGroupList = [];
    List<BarChartGroupData> liabilitiesBarGroupList = [];

    //******************** SIMULATION START ********************//
    for (Jiffy date = Jiffy(simulationStartDate);
        date.isSameOrBefore(simulationEndDate);
        date.add(days: 1)) {
      //******************** INCOME ********************//
      incomeList.forEach((income) {
        //Storing amount in another variable so as to not modify the original object
        if (!incomeAmountMap.containsKey(income.id)) {
          incomeAmountMap[income.id] = income.amount.toDouble();
        }
        var onceEvent = income.frequency == IncomeFrequency.Once && date.isSame(income.startDate);
        var monthlyEvent = income.frequency == IncomeFrequency.Monthly &&
            date.date == income.startDate.date &&
            date.isAfter(income.startDate) && //Event doesn't occur on first day itself
            date.isSameOrBefore(income.endDate); //Event should include the last day also
        var yearlyEvent = income.frequency == IncomeFrequency.Yearly &&
            date.date == income.startDate.date &&
            date.month == income.startDate.month &&
            date.isSameOrBefore(income.endDate);

        if (onceEvent || monthlyEvent || yearlyEvent) {
          totalSavings += incomeAmountMap[income.id]!;
          statementList.add(
            StatementEntry(
              date: date.clone(),
              amount: incomeAmountMap[income.id]!.round(),
              transactionType: TransactionType.Credit,
              message: income.name,
              details: describeEnum(income.frequency.toString()),
              balance: totalSavings.round(),
            ),
          );
        }

        //Income year completed
        if (date.isSameOrBefore(income.endDate) &&
            date.date == income.startDate.date &&
            date.month == income.startDate.month &&
            date.year != income.startDate.year &&
            income.yearlyAppreciationPercentage != 0) {
          var yearlyAppreciation =
              (incomeAmountMap[income.id]! * income.yearlyAppreciationPercentage / 100);
          incomeAmountMap[income.id] = incomeAmountMap[income.id]! + yearlyAppreciation;
          statementList.add(StatementEntry(
            date: date.clone(),
            amount: 0,
            transactionType: TransactionType.Credit,
            message: income.name + ': Appreciated by: ' + yearlyAppreciation.round().toString(),
            details: 'Yearly',
            balance: totalSavings.round(),
          ));
        }
      });

      //******************** ASSET ********************//
      assetList.forEach((asset) {
        //Initialize total asset investment if not present
        if (!assetInvestmentMap.containsKey(asset.id)) {
          assetInvestmentMap[asset.id] = 0;
        }
        //Investment in asset
        var onceEvent = asset.investment.frequency == ExpenditureFrequency.Once &&
            date.isSame(asset.investment.startDate);
        var monthlyEvent = asset.investment.frequency == ExpenditureFrequency.Monthly &&
            date.date == asset.investment.startDate.date &&
            date.isAfter(asset.investment.startDate) && //Event doesn't occur on first day itself
            date.isSameOrBefore(asset.investment.endDate); //Event should include the last day also
        var yearlyEvent = asset.investment.frequency == ExpenditureFrequency.Yearly &&
            date.date == asset.investment.startDate.date &&
            date.month == asset.investment.startDate.month &&
            date.isAfter(asset.investment.startDate) && //Event doesn't occur on first day itself
            date.isSameOrBefore(asset.investment.endDate); //Event should include the last day also

        if (onceEvent || monthlyEvent || yearlyEvent) {
          assetInvestmentMap[asset.id] = assetInvestmentMap[asset.id]! + asset.investment.amount;
        }

        //Asset year completed
        if (date.isSameOrBefore(asset.endDate) &&
            date.date == asset.startDate.date &&
            date.month == asset.startDate.month &&
            date.year != asset.startDate.year &&
            asset.yearlyAppreciationPercentage != 0) {
          var yearlyAppreciation =
              (assetInvestmentMap[asset.id]! * asset.yearlyAppreciationPercentage / 100);

          assetInvestmentMap[asset.id] = assetInvestmentMap[asset.id]! + yearlyAppreciation;

          statementList.add(StatementEntry(
            date: date.clone(),
            amount: 0,
            transactionType: TransactionType.Credit,
            message: asset.name + ': Profit: ' + yearlyAppreciation.round().toString(),
            details: 'Yearly',
            balance: totalSavings.round(),
          ));
        }

        //Asset end date reached
        if (date.isSame(asset.endDate)) {
          var assetValue = assetInvestmentMap[asset.id]!;
          totalSavings += assetValue;
          assetInvestmentMap[asset.id] = 0;
          statementList.add(StatementEntry(
            date: date.clone(),
            amount: assetValue.round(),
            transactionType: TransactionType.Credit,
            message: asset.name + ': Diluted',
            details: describeEnum(asset.investment.frequency.toString()),
            balance: totalSavings.round(),
          ));
        }
      });

      //******************** LIABILITY ********************//
      liabilitiesList.forEach((liability) {
        //Initialize total asset investment if not present
        if (!liabilityAmountMap.containsKey(liability.id) &&
            date.isSameOrAfter(liability.emi.startDate)) {
          //Calculating number of months passed, if the loan started from back date
          int afterNumberOfMonths = date.diff(liability.emi.startDate, Units.MONTH).toInt();
          //Calculating remaning loan amount, if the loan started from back date
          liabilityAmountMap[liability.id] = CommonCalculator.calculateRemainingLoan(
            liability.amount,
            liability.emi.amount,
            liability.rateOfInterest,
            afterNumberOfMonths,
          );
          statementList.add(StatementEntry(
            date: date.clone(),
            amount: 0,
            transactionType: TransactionType.Debit,
            message: liability.name + ': Initialised',
            details: 'Remaining loan amount: ${liabilityAmountMap[liability.id]}',
            balance: totalSavings.round(),
          ));
        }

        var monthlyEvent = liability.emi.frequency == ExpenditureFrequency.Monthly &&
            date.date == liability.emi.startDate.date &&
            date.isAfter(liability.emi.startDate) && //Event doesn't occur on first day itself
            date.isSameOrBefore(liability.emi.endDate); //Event should include the last day also

        if (monthlyEvent) {
          var emiInterestAmount =
              liabilityAmountMap[liability.id]! * liability.rateOfInterest / 1200;
          var emiPricipalAmount = liability.emi.amount - emiInterestAmount;
          liabilityAmountMap[liability.id] = liabilityAmountMap[liability.id]! - emiPricipalAmount;

          liabilityExpenditureLastDebitMap[liability.emi.id] = {
            'emiInterestAmount': emiInterestAmount,
            'emiPricipalAmount': emiPricipalAmount,
            'remainingLiability': liabilityAmountMap[liability.id]!,
          };
        }

        //Liability ended
        if (date.isSame(liability.emi.endDate)) {
          //Setting liability amount to 0 to avoid printing very small remaining loan amount
          liabilityAmountMap[liability.id] = 0;
          statementList.add(StatementEntry(
            date: date.clone(),
            amount: 0,
            transactionType: TransactionType.Credit,
            message: liability.name + ': Ended',
            details: describeEnum(liability.emi.frequency.toString()),
            balance: totalSavings.round(),
          ));
        }
      });

      //******************** EXPENDITURE ********************//
      expenditureList.forEach((expenditure) {
        //Storing amount in another variable so as to not modify the original object
        if (!expenditureAmountMap.containsKey(expenditure.id)) {
          expenditureAmountMap[expenditure.id] = expenditure.amount.toDouble();
        }
        var onceEvent = expenditure.frequency == ExpenditureFrequency.Once &&
            date.isSame(expenditure.startDate);
        var monthlyEvent = expenditure.frequency == ExpenditureFrequency.Monthly &&
            date.date == expenditure.startDate.date &&
            date.isAfter(expenditure.startDate) && //Event doesn't occur on first day itself
            date.isSameOrBefore(expenditure.endDate);
        var yearlyEvent = expenditure.frequency == ExpenditureFrequency.Yearly &&
            date.date == expenditure.startDate.date &&
            date.month == expenditure.startDate.month &&
            date.isAfter(expenditure.startDate) && //Event doesn't occur on first day itself
            date.isSameOrBefore(expenditure.endDate);

        if (onceEvent || monthlyEvent || yearlyEvent) {
          totalSavings -= expenditureAmountMap[expenditure.id]!;
          var loanDetails = '';
          if (expenditure.belongsToLiability) {
            loanDetails = ' Interest: ' +
                liabilityExpenditureLastDebitMap[expenditure.id]!['emiInterestAmount']!
                    .round()
                    .toString() +
                ' Principal: ' +
                liabilityExpenditureLastDebitMap[expenditure.id]!['emiPricipalAmount']!
                    .round()
                    .toString() +
                ' Remaining Liability: ' +
                liabilityExpenditureLastDebitMap[expenditure.id]!['remainingLiability']!
                    .round()
                    .toString();
          }
          statementList.add(
            StatementEntry(
              date: date.clone(),
              amount: expenditureAmountMap[expenditure.id]!.round(),
              transactionType: TransactionType.Debit,
              message: expenditure.name,
              details: describeEnum(expenditure.frequency.toString()) + loanDetails,
              balance: totalSavings.round(),
            ),
          );
        }

        //Expenditure year completed
        if (date.isSameOrBefore(expenditure.endDate) &&
            date.date == expenditure.startDate.date &&
            date.month == expenditure.startDate.month &&
            date.year != expenditure.startDate.year &&
            expenditure.yearlyAppreciationPercentage != 0) {
          var yearlyAppreciation = (expenditureAmountMap[expenditure.id]! *
              expenditure.yearlyAppreciationPercentage /
              100);
          expenditureAmountMap[expenditure.id] =
              expenditureAmountMap[expenditure.id]! + yearlyAppreciation;
          statementList.add(StatementEntry(
            date: date.clone(),
            amount: 0,
            transactionType: TransactionType.Debit,
            message:
                expenditure.name + ': Appreciated by: ' + yearlyAppreciation.round().toString(),
            details: 'Yearly',
            balance: totalSavings.round(),
          ));
        }
      });

      //******************** SIMULATION YEAR COMPLETED ********************//
      if (date.date == simulationStartDate.date &&
          date.month == simulationStartDate.month &&
          date.year != simulationStartDate.year) {
        //Calculate total investments by checking current value of each asset
        var totalInvestments = 0.0;
        assetInvestmentMap.forEach((key, value) {
          totalInvestments += value;
        });

        //Calculate total liabilities amount by checking current value of each liability
        var totalLiabilities = 0.0;
        liabilityAmountMap.forEach((key, value) {
          totalLiabilities += value;
        });

        var savingsBarColor = totalSavings >= 0 ? Colors.green : Colors.red;
        var assetsBarColor = totalInvestments >= 0 ? Colors.green : Colors.red;
        var liabilitesBarColor = totalLiabilities >= 0 ? Colors.red : Colors.green;

        double barRodWidth = 180 / yearsToSimulate;

        //Savings bar chart group data
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
              width: barRodWidth,
            )
          ],
          //Not showing tooltip value in case of 0 amount as it overlaps with bottom titles
          showingTooltipIndicators: totalSavings == 0 ? [] : [0],
        );

        //Assets bar chart group data
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
              width: barRodWidth,
            )
          ],
          //Not showing tooltip value in case of 0 amount as it overlaps with bottom titles
          showingTooltipIndicators: totalInvestments == 0 ? [] : [0],
        );

        //Liabilities bar chart group data
        var liabilitiesBarChartGroupData = BarChartGroupData(
          x: date.year,
          barRods: [
            BarChartRodData(
              y: totalLiabilities.toDouble(),
              colors: [
                liabilitesBarColor,
                liabilitesBarColor,
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
              width: barRodWidth,
            )
          ],
          //Not showing tooltip value in case of 0 amount as it overlaps with bottom titles
          showingTooltipIndicators: totalLiabilities == 0 ? [] : [0],
        );

        savingsBarGroupList.add(savingsBarChartGroupData);
        assetsBarGroupList.add(assetsBarChartGroupData);
        liabilitiesBarGroupList.add(liabilitiesBarChartGroupData);
      }
    }

    var result = {
      'savings': savingsBarGroupList,
      'assets': assetsBarGroupList,
      'liabilities': liabilitiesBarGroupList,
      'statementList': statementList,
    };

    //Caching input and result for future, for optimization
    globalCache.addObject('incomeList', incomeList);
    globalCache.addObject('expenditureList', expenditureList);
    globalCache.addObject('assetList', assetList);
    globalCache.addObject('liabilitiesList', liabilitiesList);
    globalCache.addObject('result', result);
    return result;
  }
}
