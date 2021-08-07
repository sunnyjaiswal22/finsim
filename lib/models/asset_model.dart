import 'dart:collection';

import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/models/Income_model.dart';
import 'package:finsim/models/asset.dart';
import 'package:finsim/models/expenditure_model.dart';
import 'package:flutter/material.dart';

class AssetModel extends ChangeNotifier {
  Future<void> add(Asset asset) async {
    await DBHelper.saveAsset(asset);
    //Notifying Income and Expenditure listeners also we changed their data also
    IncomeModel().notifyListeners();
    ExpenditureModel().notifyListeners();
    notifyListeners();
  }

  Future<void> delete(Asset asset) async {
    await DBHelper.deleteAsset(asset);
    //Notifying Income and Expenditure listeners also we changed their data also
    IncomeModel().notifyListeners();
    ExpenditureModel().notifyListeners();
    notifyListeners();
  }

  Future<List<Asset>> get items async {
    final assetList = await DBHelper.getAssets();
    return UnmodifiableListView(assetList);
  }
}
