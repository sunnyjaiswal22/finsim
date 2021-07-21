import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/widgets/finsim_appbar.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum IncomeFrequency { Once, Monthly, Yearly }
final _formKey = GlobalKey<FormState>();
Income income = Income();

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({Key? key}) : super(key: key);
  static final routeName = 'add-income-screen';

  @override
  _AddIncomeScreenState createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FinSimAppBar.appbar(title: 'Add Income'),
      drawer: NavigationDrawer(),
      body: Padding(
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
                  income.yearlyAppreciationPercentage = int.parse(value);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  DBHelper.saveIncome(income);
                  Navigator.pop(context);
                },
                child: Text('Add Income'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
