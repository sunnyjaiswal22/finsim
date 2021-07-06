import 'package:flutter/material.dart';

class AddIncomeScreen extends StatelessWidget {
  const AddIncomeScreen({Key? key}) : super(key: key);
  static final routeName = 'add-income-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('FinSim - Add Income'),
        ),
      ),
      body: null,
    );
  }
}
