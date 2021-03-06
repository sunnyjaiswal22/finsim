import 'package:flutter/foundation.dart';
import 'package:jiffy/jiffy.dart';

enum TransactionType { Credit, Debit }

class StatementEntry {
  Jiffy date;
  int amount;
  TransactionType transactionType;
  String message;
  String details;
  int balance;

  StatementEntry({
    required this.date,
    required this.amount,
    required this.transactionType,
    required this.message,
    required this.details,
    required this.balance,
  });

  @override
  String toString() {
    return this.date.toString() +
        ' - ' +
        this.amount.toString() +
        ' - ' +
        describeEnum(this.transactionType.toString() +
            ' - ' +
            this.message +
            ' - ' +
            this.details +
            ' - ' +
            this.balance.toString());
  }
}
