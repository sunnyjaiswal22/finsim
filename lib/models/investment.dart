import 'package:finsim/screens/add_investment_screen.dart' show ReturnFrequency;

class Investment {
  int id;
  DateTime? startDate;
  DateTime? endDate;
  String name;
  ReturnFrequency frequency;
  int amount;
  int profitPercentage;

  Investment({
    this.id = 0,
    this.startDate,
    this.endDate,
    this.name = '',
    this.frequency = ReturnFrequency.OnTermination,
    this.amount = 0,
    this.profitPercentage = 0,
  });

  Map<String, Object> toMap() {
    return {
      //Not passing id in Map so that Sqflite will auto generate new id
      //'id': this.id,
      'startDate': this.startDate!.toIso8601String(),
      'endDate': this.endDate!.toIso8601String(),
      'name': this.name,
      //Storing enum index in database
      'frequency': ReturnFrequency.values.indexOf(this.frequency),
      'amount': this.amount,
      'profitPercentage': this.profitPercentage,
    };
  }

  static Investment fromMap(Map<String, dynamic> investmentMap) {
    var investment = Investment();
    investment.id = investmentMap['id'];
    investment.startDate = DateTime.tryParse(investmentMap['startDate']);
    investment.endDate = DateTime.tryParse(investmentMap['endDate']);
    investment.name = investmentMap['name'];
    investment.frequency = ReturnFrequency.values[investmentMap['frequency']];
    investment.amount = investmentMap['amount'];
    investment.profitPercentage = investmentMap['profitPercentage'];

    return investment;
  }
}
