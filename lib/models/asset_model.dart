import 'dart:collection';

import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/models/asset.dart';
import 'package:flutter/material.dart';

class AssetModel extends ChangeNotifier {
  Future<void> add(Asset asset) async {
    await DBHelper.saveAsset(asset);
    notifyListeners();
  }

  Future<void> delete(Asset asset) async {
    DBHelper.deleteAsset(asset);
    notifyListeners();
  }

  Future<List<Asset>> get items async {
    final assetList = await DBHelper.getAssets();
    return UnmodifiableListView(assetList);
  }
}
