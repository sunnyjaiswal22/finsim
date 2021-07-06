import 'package:flutter/material.dart';

enum IncomeFrequency { Monthly, Yearly }

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({Key? key}) : super(key: key);
  static final routeName = 'add-income-screen';

  @override
  _AddIncomeScreenState createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  IncomeFrequency? _selectedIncomeFrequency = IncomeFrequency.Monthly;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('FinSim - Add Income'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Income Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter name of the income";
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Text('Frequency:'),
                  SizedBox(width: 20),
                  Radio<IncomeFrequency>(
                    value: IncomeFrequency.Monthly,
                    groupValue: _selectedIncomeFrequency,
                    onChanged: (IncomeFrequency? value) {
                      setState(() {
                        _selectedIncomeFrequency = value;
                      });
                    },
                  ),
                  Text('Monthly'),
                  SizedBox(width: 20),
                  Radio<IncomeFrequency>(
                    value: IncomeFrequency.Yearly,
                    groupValue: _selectedIncomeFrequency,
                    onChanged: (IncomeFrequency? value) {
                      setState(() {
                        _selectedIncomeFrequency = value;
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter amount";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text('Add Income'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
