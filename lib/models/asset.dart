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
  Expenditure investment = Expenditure();
  bool generatesIncome = false;
  Income income = Income();

  Asset() {
    this.investment.frequency = ExpenditureFrequency.Once;
    this.investment.belongsToAsset = true;
    this.income.belongsToAsset = true;
  }

  Map<String, Object> toMap() {
    var map = {
      //Not passing id in Map so that Sqflite will auto generate new id
      'name': this.name,
      'startDate': this.startDate.format(), //ISO 8601 format
      'endDate': this.endDate.format(), //ISO 8601 format
      'yearlyAppreciationPercentage': this.yearlyAppreciationPercentage,
      'investment_id': this.investment.id,
      'generatesIncome': this.generatesIncome ? 1 : 0,
      'income_id': this.income.id,
    };

    //Not saving income_id if not available, so as not to break foreign key
    if (map['income_id'] == 0) {
      map.remove('income_id');
    }

    return map;
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
    //Investment and income already set and mapped
    return asset;
  }
}
