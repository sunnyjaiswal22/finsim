import 'package:finsim/models/expenditure.dart';
import 'package:finsim/screens/add_expenditure_screen.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class Liability {
  int id = 0;
  String name = '';
  int amount = 0;
  int rateOfInterest = 0;
  Jiffy startDate = Jiffy().startOf(Units.DAY);
  Jiffy endDate = Jiffy().startOf(Units.DAY).add(years: 5);
  Expenditure emi = Expenditure();

  Liability() {
    this.emi.frequency = ExpenditureFrequency.Monthly;
    this.emi.belongsToLiability = true;
  }

  Map<String, Object> toMap() {
    var map = {
      //Not passing id in Map so that Sqflite will auto generate new id
      'name': this.name,
      'amount': this.amount,
      'interestRate': this.rateOfInterest,
      'startDate': this.startDate.format(), //ISO 8601 format
      'endDate': this.endDate.format(), //ISO 8601 format
      'emi_id': this.emi.id,
    };

    return map;
  }

  static Liability fromMap(Map<String, dynamic> map) {
    var l = Liability();
    l.id = map['id'];
    l.name = map['name'];
    l.amount = map['amount'];
    l.rateOfInterest = map['rateOfInterest'];
    l.startDate = Jiffy(map['startDate']);
    l.endDate = Jiffy(map['endDate']);

    //EMI (expenditure) already set and mapped
    return l;
  }

  @override
  operator ==(o) =>
      o is Liability &&
      o.id == id &&
      o.name == name &&
      o.amount == amount &&
      o.rateOfInterest == rateOfInterest &&
      o.startDate.dateTime == startDate.dateTime &&
      o.endDate.dateTime == endDate.dateTime &&
      o.emi == emi;

  @override
  int get hashCode => hashValues(
        id,
        name,
        amount,
        rateOfInterest,
        startDate.dateTime,
        endDate.dateTime,
        emi,
      );
}
