import 'dart:collection';

import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/models/income.dart';
import 'package:flutter/material.dart';

class IncomeModel extends ChangeNotifier {
  Future<void> add(Income income) async {
    await DBHelper.saveIncomeSource(income);
    notifyListeners();
  }

  Future<void> delete(int incomeId) async {
    DBHelper.deleteIncomeSource(incomeId);
    notifyListeners();
  }

  Future<List<Income>> get items async {
    final incomeList = await DBHelper.getIncomeSources();
    return UnmodifiableListView(incomeList);
  }
}
