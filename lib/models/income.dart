import 'package:finsim/screens/add_income_screen.dart';

class Income {
  String name;
  IncomeFrequency? frequency;
  int amount;
  int yearlyAppreciationPercentage;

  Income({
    this.name = '',
    this.frequency = IncomeFrequency.Monthly,
    this.amount = 0,
    this.yearlyAppreciationPercentage = 0,
  });
}
