import 'dart:collection';

import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/models/income.dart';
import 'package:flutter/material.dart';

class IncomeModel extends ChangeNotifier {
  Future<void> add(Income income) async {
    await DBHelper.saveIncome(income);
    notifyListeners();
  }

  Future<void> delete(int incomeId) async {
    DBHelper.deleteIncome(incomeId);
    notifyListeners();
  }

  Future<List<Income>> get items async {
    final incomeList = await DBHelper.getIncomes();
    return UnmodifiableListView(incomeList);
  }

  void notifyListenersFromOutside() {
    notifyListeners();
  }
}
