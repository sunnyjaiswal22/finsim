import 'package:finsim/screens/add_income_screen.dart';

class Income {
  final String name;
  final IncomeFrequency frequency;
  final int amount;

  Income({
    required this.name,
    required this.frequency,
    required this.amount,
  });
}
