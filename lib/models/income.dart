import 'package:finsim/screens/add_income_screen.dart' show IncomeFrequency;

class Income {
  int id;
  String name;
  IncomeFrequency frequency;
  int amount;
  int yearlyAppreciationPercentage;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime(2099, 1, 1);

  Income({
    this.id = 0,
    this.name = '',
    this.frequency = IncomeFrequency.Monthly,
    this.amount = 0,
    this.yearlyAppreciationPercentage = 0,
  });

  Map<String, Object> toMap() {
    return {
      //Not passing id in Map so that Sqflite will auto generate new id
      //'id': this.id,
      'name': this.name,
      //Storing enum index in database
      'frequency': IncomeFrequency.values.indexOf(this.frequency),
      'amount': this.amount,
      'yearlyAppreciationPercentage': this.yearlyAppreciationPercentage,
      'startDate': this.startDate.toIso8601String(),
      'endDate': this.endDate.toIso8601String(),
    };
  }

  static Income fromMap(Map<String, dynamic> incomeMap) {
    var income = Income();
    income.id = incomeMap['id'];
    income.name = incomeMap['name'];
    income.frequency = IncomeFrequency.values[incomeMap['frequency']];
    income.amount = incomeMap['amount'];
    income.yearlyAppreciationPercentage =
        incomeMap['yearlyAppreciationPercentage'];
    income.startDate = DateTime.parse(incomeMap['startDate']);
    income.endDate = DateTime.parse(incomeMap['endDate']);

    return income;
  }
}
