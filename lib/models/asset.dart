import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/screens/add_expenditure_screen.dart';
import 'package:jiffy/jiffy.dart';

class Asset {
  int id = 0;
  String name = '';
  Jiffy startDate = Jiffy().startOf(Units.DAY);
  Jiffy endDate = Jiffy({'year': 2099, 'month': 1, 'day': 1});
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
      'startDate': this.startDate.format(), //ISO 8601 format
      'endDate': this.endDate.format(), //ISO 8601 format
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
    asset.startDate = Jiffy(assetMap['startDate']);
    asset.endDate = Jiffy(assetMap['endDate']);
    asset.yearlyAppreciationPercentage =
        assetMap['yearlyAppreciationPercentage'];
    asset.generatesIncome = assetMap['generatesIncome'] == 1 ? true : false;
    //Expenditure and income already set and mapped
    return asset;
  }
}
