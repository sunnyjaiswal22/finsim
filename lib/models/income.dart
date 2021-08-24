import 'package:finsim/helpers/constants.dart';
import 'package:finsim/screens/add_income_screen.dart' show IncomeFrequency;
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class Income {
  int id = 0;
  String name = '';
  IncomeFrequency frequency = IncomeFrequency.Monthly;
  int amount = 0;
  double yearlyAppreciationPercentage = 0;
  Jiffy startDate = Jiffy().startOf(Units.DAY);
  Jiffy endDate = Constants.maxDateTime.clone();
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

  static Income fromMap(Map<String, dynamic> map) {
    var i = Income();
    i.id = map['id'];
    i.name = map['name'];
    i.frequency = IncomeFrequency.values[map['frequency']];
    i.amount = map['amount'];
    i.yearlyAppreciationPercentage = map['yearlyAppreciationPercentage'];
    i.startDate = Jiffy(map['startDate']);
    i.endDate = Jiffy(map['endDate']);
    i.belongsToAsset = map['belongsToAsset'] == 1 ? true : false;

    return i;
  }

  @override
  operator ==(o) =>
      o is Income &&
      o.id == id &&
      o.name == name &&
      o.frequency == frequency &&
      o.amount == amount &&
      o.yearlyAppreciationPercentage == yearlyAppreciationPercentage &&
      o.startDate.dateTime == startDate.dateTime &&
      o.endDate.dateTime == endDate.dateTime &&
      o.belongsToAsset == belongsToAsset;

  @override
  int get hashCode => hashValues(
        id,
        name,
        frequency,
        amount,
        yearlyAppreciationPercentage,
        startDate.dateTime,
        endDate.dateTime,
        belongsToAsset,
      );
}
