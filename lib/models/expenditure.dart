import 'package:finsim/screens/add_expenditure_screen.dart'
    show ExpenditureFrequency;

class Expenditure {
  String name;
  ExpenditureFrequency frequency;
  int amount;
  int yearlyAppreciationPercentage;

  Expenditure({
    this.name = '',
    this.frequency = ExpenditureFrequency.Monthly,
    this.amount = 0,
    this.yearlyAppreciationPercentage = 0,
  });

  Map<String, Object> toMap() {
    return {
      'name': this.name,
      //Storing enum index in database
      'frequency': ExpenditureFrequency.values.indexOf(this.frequency),
      'amount': this.amount,
      'yearlyAppreciationPercentage': this.yearlyAppreciationPercentage,
    };
  }

  static Expenditure fromMap(Map<String, dynamic> expenditureMap) {
    var expenditure = Expenditure();
    expenditure.name = expenditureMap['name'];
    expenditure.frequency =
        ExpenditureFrequency.values[expenditureMap['frequency']];
    expenditure.amount = expenditureMap['amount'];
    expenditure.yearlyAppreciationPercentage =
        expenditureMap['yearlyAppreciationPercentage'];

    return expenditure;
  }
}
