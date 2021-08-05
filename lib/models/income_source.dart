import 'package:finsim/screens/add_income_source_screen.dart'
    show IncomeFrequency;
import 'package:jiffy/jiffy.dart';

class IncomeSource {
  int id = 0;
  String name = '';
  IncomeFrequency frequency = IncomeFrequency.Monthly;
  int amount = 0;
  int yearlyAppreciationPercentage = 0;
  Jiffy startDate = Jiffy().startOf(Units.DAY);
  Jiffy endDate = Jiffy({'year': 2099, 'month': 1, 'day': 1});
  bool belongsToAsset = false;

  Map<String, Object> toMap() {
    return {
      //Not passing id in Map so that Sqflite will auto generate new id
      'name': this.name,
      //Storing enum index in database
      'frequency': IncomeFrequency.values.indexOf(this.frequency),
      'amount': this.amount,
      'yearlyAppreciationPercentage': this.yearlyAppreciationPercentage,
      'startDate': this.startDate.format(), //ISO 8601 format
      'endDate': this.endDate.format(), //ISO 8601 format
      'belongsToAsset': belongsToAsset ? 1 : 0,
    };
  }

  static IncomeSource fromMap(Map<String, dynamic> incomeMap) {
    var income = IncomeSource();
    income.id = incomeMap['id'];
    income.name = incomeMap['name'];
    income.frequency = IncomeFrequency.values[incomeMap['frequency']];
    income.amount = incomeMap['amount'];
    income.yearlyAppreciationPercentage =
        incomeMap['yearlyAppreciationPercentage'];
    income.startDate = Jiffy(incomeMap['startDate']);
    income.endDate = Jiffy(incomeMap['endDate']);
    income.belongsToAsset = incomeMap['belongsToAsset'] == 1 ? true : false;

    return income;
  }
}
