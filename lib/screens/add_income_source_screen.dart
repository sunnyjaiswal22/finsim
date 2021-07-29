import 'dart:developer';

import 'package:finsim/models/Income_source_model.dart';
import 'package:finsim/models/income_source.dart';
import 'package:finsim/screens/add_expenditure_screen.dart';
import 'package:finsim/widgets/finsim_appbar.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

enum IncomeFrequency { Once, Monthly, Yearly }
final _formKey = GlobalKey<FormState>();

class AddIncomeSourceScreen extends StatefulWidget {
  const AddIncomeSourceScreen({Key? key}) : super(key: key);
  static final routeName = 'add-income-screen';

  @override
  _AddIncomeSourceScreenState createState() => _AddIncomeSourceScreenState();
}

class _AddIncomeSourceScreenState extends State<AddIncomeSourceScreen> {
  IncomeSource income = IncomeSource();
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    var isBlankStart = false;
    if (arguments != null) {
      try {
        isBlankStart = arguments as bool;
        print('Setting isBlankStart to $isBlankStart');
      } catch (e) {
        log('Can\'t convert arguments to bool');
      }
    }

    Future<void> _selectStartDate(
      BuildContext context,
    ) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: Jiffy().dateTime,
          firstDate: Jiffy().subtract(years: 10).dateTime,
          lastDate: Jiffy().add(years: 10).dateTime);
      print(picked);
      if (picked != null && !Jiffy(picked).isSame(income.startDate)) {
        setState(() {
          income.startDate = Jiffy(picked);
        });
      }
    }

    Future<void> _selectEndDate(
      BuildContext context,
    ) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: Jiffy().dateTime,
          firstDate: Jiffy().subtract(years: 10).dateTime,
          lastDate: Jiffy().add(years: 10).dateTime);
      if (picked != null && !Jiffy(picked).isSame(income.endDate)) {
        setState(() {
          income.endDate = Jiffy(picked);
        });
      }
    }

    return Scaffold(
      appBar: FinSimAppBar.appbar(title: 'Add Income'),
      drawer: NavigationDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Source of Income',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter source of income";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    income.name = value;
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
                    income.amount = value.isEmpty ? 0 : int.parse(value);
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Frequency:'),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 30,
                      child: Radio<IncomeFrequency>(
                        value: IncomeFrequency.Once,
                        groupValue: income.frequency,
                        onChanged: (IncomeFrequency? value) {
                          setState(() {
                            income.frequency = value!;
                          });
                        },
                      ),
                    ),
                    Text('Once'),
                    SizedBox(width: 15),
                    SizedBox(
                      width: 30,
                      child: Radio<IncomeFrequency>(
                        value: IncomeFrequency.Monthly,
                        groupValue: income.frequency,
                        onChanged: (IncomeFrequency? value) {
                          setState(() {
                            income.frequency = value!;
                          });
                        },
                      ),
                    ),
                    Text('Monthly'),
                    SizedBox(width: 15),
                    SizedBox(
                      width: 30,
                      child: Radio<IncomeFrequency>(
                        value: IncomeFrequency.Yearly,
                        groupValue: income.frequency,
                        onChanged: (IncomeFrequency? value) {
                          setState(() {
                            income.frequency = value!;
                          });
                        },
                      ),
                    ),
                    Text('Yearly'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Start Date '),
                        SizedBox(width: 20),
                        Text('${income.startDate.format("yyyy-MM-dd")}'),
                      ],
                    ),
                    TextButton(
                      onPressed: () => _selectStartDate(context),
                      child: Text('Select date'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('End Date '),
                        SizedBox(width: 20),
                        Text('${income.endDate.format("yyyy-MM-dd")}'),
                      ],
                    ),
                    TextButton(
                      onPressed: () => _selectEndDate(context),
                      child: Text('Select date'),
                    ),
                  ],
                ),
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
                    income.yearlyAppreciationPercentage = int.parse(value);
                  },
                ),
                SizedBox(height: 20),
                isBlankStart
                    ? ElevatedButton(
                        onPressed: () {
                          Provider.of<IncomeSourceModel>(context, listen: false)
                              .add(income)
                              .then((_) => Navigator.pushReplacementNamed(
                                    context,
                                    AddExpenditureScreen.routeName,
                                    arguments: true,
                                  ));
                        },
                        child: Text('Continue'),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Provider.of<IncomeSourceModel>(context, listen: false)
                              .add(income)
                              .then((_) => Navigator.pop(context));
                        },
                        child: Text('Add Income'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}