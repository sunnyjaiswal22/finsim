import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/screens/add_expenditure_screen.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class Asset {
  int id = 0;
  String name = '';
  Jiffy startDate = Jiffy().startOf(Units.MONTH);
  Jiffy endDate = Jiffy().startOf(Units.MONTH).add(years: 1);
  int yearlyAppreciationPercentage = 0;
  Expenditure investment = Expenditure();
  bool generatesIncome = false;
  Income income = Income();

  Asset() {
    this.investment.frequency = ExpenditureFrequency.Once;
    this.investment.belongsToAsset = true;
    this.income.belongsToAsset = true;
  }

  Map<String, Object> toMap() {
    var map = {
      //Not passing id in Map so that Sqflite will auto generate new id
      'name': this.name,
      'startDate': this.startDate.format(), //ISO 8601 format
      'endDate': this.endDate.format(), //ISO 8601 format
      'yearlyAppreciationPercentage': this.yearlyAppreciationPercentage,
      'investment_id': this.investment.id,
      'generatesIncome': this.generatesIncome ? 1 : 0,
      'income_id': this.income.id,
    };

    //Not saving income_id if not available, so as not to break foreign key
    if (map['income_id'] == 0) {
      map.remove('income_id');
    }

    return map;
  }

  static Asset fromMap(Map<String, dynamic> map) {
    var a = Asset();
    a.id = map['id'];
    a.name = map['name'];
    a.startDate = Jiffy(map['startDate']);
    a.endDate = Jiffy(map['endDate']);
    a.yearlyAppreciationPercentage = map['yearlyAppreciationPercentage'];
    a.generatesIncome = map['generatesIncome'] == 1 ? true : false;
    //Investment and income already set and mapped
    return a;
  }

  @override
  operator ==(o) =>
      o is Asset &&
      o.id == id &&
      o.name == name &&
      o.startDate.dateTime == startDate.dateTime &&
      o.endDate.dateTime == endDate.dateTime &&
      o.yearlyAppreciationPercentage == yearlyAppreciationPercentage &&
      o.generatesIncome == generatesIncome &&
      o.investment == investment &&
      o.income == income;

  @override
  int get hashCode => hashValues(
        id,
        name,
        startDate.dateTime,
        endDate.dateTime,
        yearlyAppreciationPercentage,
        generatesIncome,
        investment,
        income,
      );
}
