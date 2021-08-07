import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/screens/add_expenditure_screen.dart';

class Asset {
  int id = 0;
  String name = '';
  int yearlyAppreciationPercentage = 0;
  Expenditure expenditure = Expenditure();
  bool generatesIncome = false;
  Income income = Income();

  Asset() {
    this.expenditure.frequency = ExpenditureFrequency.Once;
  }

  Map<String, Object> toMap() {
    return {
      //Not passing id in Map so that Sqflite will auto generate new id
      'name': this.name,
      'yearlyAppreciationPercentage': this.yearlyAppreciationPercentage,
      'expenditure_id': this.expenditure.id,
      'generatesIncome': this.generatesIncome ? 1 : 0,
      'income_id': this.income.id,
    };
  }

  static Asset fromMap(Map<String, dynamic> assetMap) {
    var asset = Asset();
    asset.id = assetMap['id'];
    asset.name = assetMap['name'];
    asset.yearlyAppreciationPercentage =
        assetMap['yearlyAppreciationPercentage'];
    asset.generatesIncome = assetMap['generatesIncome'] == 1 ? true : false;
    //Expenditure and income already set and mapped
    return asset;
  }
}
