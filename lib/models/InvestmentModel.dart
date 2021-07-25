import 'dart:collection';

import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/models/investment.dart';
import 'package:flutter/material.dart';

class InvestmentModel extends ChangeNotifier {
  Future<void> add(Investment investment) async {
    await DBHelper.insert('investment', investment.toMap());
    notifyListeners();
  }

  Future<void> delete(int investmentId) async {
    DBHelper.deleteInvestment(investmentId);
    notifyListeners();
  }

  Future<List<Investment>> get items async {
    final investmentList = await DBHelper.getInvestment();
    return UnmodifiableListView(investmentList);
  }
}
