import 'package:flutter/foundation.dart';

enum TransactionType { Credit, Debit }

class Log {
  DateTime date;
  int amount;
  TransactionType transactionType;
  String message;
  int balance;

  Log({
    required this.date,
    required this.amount,
    required this.transactionType,
    required this.message,
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
            this.balance.toString());
  }
}
