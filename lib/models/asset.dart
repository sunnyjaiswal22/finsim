import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/income.dart';

class Asset {
  int id = 0;
  String name = '';
  int yearlyAppreciationPercentage = 0;
  Expenditure expenditure = Expenditure();
  Income income = Income();

  Map<String, Object> toMap() {
    return {
      //Not passing id in Map so that Sqflite will auto generate new id
      'name': this.name,
      'yearlyAppreciationPercentage': this.yearlyAppreciationPercentage,
      'expenditure_id': expenditure.id,
      'income_id': income.id,
    };
  }

  static Asset fromMap(Map<String, dynamic> assetMap) {
    var asset = Asset();
    asset.id = assetMap['id'];
    asset.name = assetMap['name'];
    asset.yearlyAppreciationPercentage =
        assetMap['yearlyAppreciationPercentage'];
    //Expenditure and income already set and mapped
    return asset;
  }
}
