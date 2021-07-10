import 'package:finsim/screens/add_expenditure_screen.dart';

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
}
