import 'package:flutter/material.dart';

import 'package:finsim/screens/add_income_source_screen.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);
  static final routeName = '/';

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
          child: Column(
            children: [
              Container(
                height: 320,
                child: Image.asset('assets/images/pig.png'),
              ),
              SizedBox(height: 30),
              Text(
                'Welcome to Personal Finance Simulator. Please add your major income and expenditure details to get started',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AddIncomeSourceScreen.routeName,
                    arguments: true,
                  );
                },
                child: Text('Continue'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
