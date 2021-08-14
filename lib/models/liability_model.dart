import 'dart:collection';

import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/models/liability.dart';
import 'package:finsim/models/expenditure_model.dart';
import 'package:flutter/material.dart';

class LiabilityModel extends ChangeNotifier {
  Future<void> add(Liability liability) async {
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
