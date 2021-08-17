import 'dart:collection';

import 'package:finsim/helpers/common_calculator.dart';
import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/models/liability.dart';
import 'package:finsim/models/expenditure_model.dart';
import 'package:flutter/material.dart';

class LiabilityModel extends ChangeNotifier {
  Future<void> add(Liability liability) async {
    //Calculating and setting EMI amount
    liability.emi.amount = CommonCalculator.calculateEMI(
      liability.amount,
      liability.durationInYears * 12,
      liability.rateOfInterest,
    );

    //Setting EMI end date
    liability.emi.endDate =
        liability.emi.startDate.clone().add(years: liability.durationInYears);

    //Saving
    await DBHelper.saveLiability(liability);

    //Notifying Expenditure listeners also since that was also changed
    ExpenditureModel().notifyListeners();
    notifyListeners();
  }

  Future<void> delete(Liability liability) async {
    await DBHelper.deleteLiability(liability);
    //Notifying Expenditure listeners also since that was also changed
    ExpenditureModel().notifyListeners();
    notifyListeners();
  }

  Future<List<Liability>> get items async {
    final liabilityList = await DBHelper.getLiabilities();
    return UnmodifiableListView(liabilityList);
  }
}
