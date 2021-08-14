import 'dart:collection';
import 'dart:math';

import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/models/liability.dart';
import 'package:finsim/models/expenditure_model.dart';
import 'package:flutter/material.dart';

class LiabilityModel extends ChangeNotifier {
  Future<void> add(Liability liability) async {
    //Calculating EMI = P × r × (1 + r)^n/((1 + r)^n - 1)
    var l = liability;
    var durationInMonths = l.durationInYears * 12;
    var monthlyRateOfInterest = l.rateOfInterest / (12 * 100);
    var onePlusRToPowerN = pow((1 + monthlyRateOfInterest), durationInMonths);
    var ratio = onePlusRToPowerN / (onePlusRToPowerN - 1);
    l.emi.amount = (l.amount * monthlyRateOfInterest * ratio).toInt();

    //Setting EMI end date
    l.emi.endDate = l.emi.startDate.clone().add(years: l.durationInYears);

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
