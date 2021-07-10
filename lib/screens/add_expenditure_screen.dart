import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/screens/expenditure_sources_screen.dart';
import 'package:finsim/widgets/finsim_appbar.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ExpenditureFrequency { Monthly, Yearly }
final _formKey = GlobalKey<FormState>();
Expenditure expenditure = Expenditure();

class AddExpenditureScreen extends StatefulWidget {
  const AddExpenditureScreen({Key? key}) : super(key: key);
  static final routeName = 'add-expenditure-screen';

  @override
  _AddExpenditureScreenState createState() => _AddExpenditureScreenState();
}

class _AddExpenditureScreenState extends State<AddExpenditureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FinSimAppBar.appbar(title: 'Add Expenditure'),
      drawer: NavigationDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Expenditure Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter name of the expenditure";
                  }
                  return null;
                },
                onChanged: (value) {
                  expenditure.name = value;
                },
              ),
              Row(
                children: [
                  Text('Frequency:'),
                  SizedBox(width: 20),
                  Radio<ExpenditureFrequency>(
                    value: ExpenditureFrequency.Monthly,
                    groupValue: expenditure.frequency,
                    onChanged: (ExpenditureFrequency? value) {
                      setState(() {
                        expenditure.frequency = value!;
                      });
                    },
                  ),
                  Text('Monthly'),
                  SizedBox(width: 20),
                  Radio<ExpenditureFrequency>(
                    value: ExpenditureFrequency.Yearly,
                    groupValue: expenditure.frequency,
                    onChanged: (ExpenditureFrequency? value) {
                      setState(() {
                        expenditure.frequency = value!;
                      });
                    },
                  ),
                  Text('Yearly'),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter amount";
                  }
                },
                onChanged: (value) {
                  expenditure.amount = value.isEmpty ? 0 : int.parse(value);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Yearly Appreciation Percentage',
                    hintText: 'Change per annum (in percentage)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter appreciation percentage";
                  }
                  return null;
                },
                onChanged: (value) {
                  expenditure.yearlyAppreciationPercentage = int.parse(value);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  DBHelper.saveExpenditure(expenditure).then((_) =>
                      Navigator.pushReplacementNamed(
                              context, ExpenditureSourcesScreen.routeName)
                          .then((value) {
                        setState(
                            () {}); //Calling setState() to refresh ExpenditureSourcesScreen
                      }));
                },
                child: Text('Add Expenditure'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
