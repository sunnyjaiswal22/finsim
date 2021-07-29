import 'package:finsim/screens/add_income_source_screen.dart'
    show IncomeFrequency;
import 'package:jiffy/jiffy.dart';

class IncomeSource {
  int id;
  String name;
  IncomeFrequency frequency;
  int amount;
  int yearlyAppreciationPercentage;
  Jiffy startDate = Jiffy();
  Jiffy endDate = Jiffy({'year': 2099, 'month': 1, 'day': 1});

  IncomeSource({
    this.id = 0,
    this.name = '',
    this.frequency = IncomeFrequency.Monthly,
    this.amount = 0,
    this.yearlyAppreciationPercentage = 0,
  });

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

    return income;
  }
}
