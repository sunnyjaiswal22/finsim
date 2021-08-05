import 'package:finsim/models/expenditure.dart';

class Asset {
  int id = 0;
  String name = '';
  int yearlyAppreciationPercentage = 0;
  Expenditure expenditure = Expenditure();

  Map<String, Object> toMap() {
    return {
      //Not passing id in Map so that Sqflite will auto generate new id
      'name': this.name,
      'yearlyAppreciationPercentage': this.yearlyAppreciationPercentage,
      'expenditure_id': expenditure.id,
    };
  }

  static Asset fromMap(Map<String, dynamic> assetMap) {
    var asset = Asset();
    asset.id = assetMap['id'];
    asset.name = assetMap['name'];
    asset.yearlyAppreciationPercentage =
        assetMap['yearlyAppreciationPercentage'];
    //Expenditure already set and mapped
    return asset;
  }
}
