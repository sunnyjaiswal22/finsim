import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/screens/add_income_screen.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/logo_white.png',
            fit: BoxFit.contain,
            height: 32,
          ),
        ),
      ),
      drawer: NavigationDrawer(),
      body: Wrap(
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
                      AddIncomeScreen.routeName,
                    );
                  },
                  child: Text('Continue'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
