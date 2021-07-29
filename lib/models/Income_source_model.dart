import 'dart:collection';

import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/models/income_source.dart';
import 'package:flutter/material.dart';

class IncomeSourceModel extends ChangeNotifier {
  Future<void> add(IncomeSource income) async {
    await DBHelper.saveIncomeSource(income);
    notifyListeners();
  }

  Future<void> delete(int incomeId) async {
    DBHelper.deleteIncomeSource(incomeId);
    notifyListeners();
  }

  Future<List<IncomeSource>> get items async {
    final incomeList = await DBHelper.getIncomeSources();
    return UnmodifiableListView(incomeList);
  }
}
