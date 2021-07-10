import 'package:finsim/screens/add_income_screen.dart' show IncomeFrequency;

class Income {
  String name;
  IncomeFrequency frequency;
  int amount;
  int yearlyAppreciationPercentage;

  Income({
    this.name = '',
    this.frequency = IncomeFrequency.Monthly,
    this.amount = 0,
    this.yearlyAppreciationPercentage = 0,
  });

  Map<String, Object> toMap() {
    return {
      'name': this.name,
      //Storing enum index in database
      'frequency': IncomeFrequency.values.indexOf(this.frequency),
      'amount': this.amount,
      'yearlyAppreciationPercentage': this.yearlyAppreciationPercentage,
    };
  }

  static Income fromMap(Map<String, dynamic> incomeMap) {
    var income = Income();
    income.name = incomeMap['name'];
    income.frequency = IncomeFrequency.values[incomeMap['frequency']];
    income.amount = incomeMap['amount'];
    income.yearlyAppreciationPercentage =
        incomeMap['yearlyAppreciationPercentage'];

    return income;
  }
}
