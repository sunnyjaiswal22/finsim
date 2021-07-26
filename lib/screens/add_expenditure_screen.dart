import 'dart:developer';

import 'package:finsim/models/ExpenditureModel.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/screens/home_screen.dart';
import 'package:finsim/widgets/finsim_appbar.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum ExpenditureFrequency { Once, Monthly, Yearly }
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
    final arguments = ModalRoute.of(context)!.settings.arguments;
    var isBlankStart = false;
    if (arguments != null) {
      try {
        isBlankStart = arguments as bool;
      } catch (e) {
        log('Can\'t convert arguments to bool');
      }
    }
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
                  labelText: 'Expenditure On',
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
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Frequency:'),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 30,
                    child: Radio<ExpenditureFrequency>(
                      value: ExpenditureFrequency.Once,
                      groupValue: expenditure.frequency,
                      onChanged: (ExpenditureFrequency? value) {
                        setState(() {
                          expenditure.frequency = value!;
                        });
                      },
                    ),
                  ),
                  Text('Once'),
                  SizedBox(width: 15),
                  SizedBox(
                    width: 30,
                    child: Radio<ExpenditureFrequency>(
                      value: ExpenditureFrequency.Monthly,
                      groupValue: expenditure.frequency,
                      onChanged: (ExpenditureFrequency? value) {
                        setState(() {
                          expenditure.frequency = value!;
                        });
                      },
                    ),
                  ),
                  Text('Monthly'),
                  SizedBox(width: 15),
                  SizedBox(
                    width: 30,
                    child: Radio<ExpenditureFrequency>(
                      value: ExpenditureFrequency.Yearly,
                      groupValue: expenditure.frequency,
                      onChanged: (ExpenditureFrequency? value) {
                        setState(() {
                          expenditure.frequency = value!;
                        });
                      },
                    ),
                  ),
                  Text('Yearly'),
                ],
              ),
              if (expenditure.frequency != ExpenditureFrequency.Once)
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Yearly Appreciation Percentage',
                      hintText: 'Change per annum (%)'),
                  keyboardType: TextInputType.number,
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
              isBlankStart
                  ? ElevatedButton(
                      onPressed: () {
                        Provider.of<ExpenditureModel>(context, listen: false)
                            .add(expenditure)
                            .then((_) => Navigator.pushReplacementNamed(
                                  context,
                                  HomeScreen.routeName,
                                ));
                      },
                      child: Text('Continue'),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        Provider.of<ExpenditureModel>(context, listen: false)
                            .add(expenditure)
                            .then((_) => Navigator.pop(context));
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
