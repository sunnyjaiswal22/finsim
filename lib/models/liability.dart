import 'package:finsim/models/expenditure.dart';
import 'package:finsim/screens/add_expenditure_screen.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class Liability {
  int id = 0;
  String name = '';
  int amount = 0;
  double rateOfInterest = 0;
  int durationInYears = 0;
  Jiffy startDate = Jiffy().startOf(Units.DAY);
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
      'rateOfInterest': this.rateOfInterest,
      'durationInYears': this.durationInYears,
      'startDate': this.startDate.format(), //ISO 8601 format
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
    l.durationInYears = map['durationInYears'];
    l.startDate = Jiffy(map['startDate']);

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
      o.durationInYears == durationInYears &&
      o.startDate.dateTime == startDate.dateTime &&
      o.emi == emi;

  @override
  int get hashCode => hashValues(
        id,
        name,
        amount,
        rateOfInterest,
        durationInYears,
        startDate.dateTime,
        emi,
      );
}
