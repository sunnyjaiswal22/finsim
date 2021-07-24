import 'dart:collection';

import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:flutter/material.dart';

class ExpenditureModel extends ChangeNotifier {
  Future<void> add(Expenditure expenditure) async {
    await DBHelper.insert('expenditure', expenditure.toMap());
    notifyListeners();
  }

  Future<void> delete(int expenditureId) async {
    DBHelper.deleteExpenditure(expenditureId);
    notifyListeners();
  }

  Future<List<Expenditure>> get items async {
    final expenditureList = await DBHelper.getExpenditure();
    return UnmodifiableListView(expenditureList);
  }
}
