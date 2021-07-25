import 'package:finsim/models/investment.dart';
import 'package:finsim/widgets/finsim_appbar.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum ReturnFrequency { Quarterly, Yearly, OnTermination }
final _formKey = GlobalKey<FormState>();

Investment investment = Investment();

class AddInvestmentScreen extends StatefulWidget {
  const AddInvestmentScreen({Key? key}) : super(key: key);
  static final routeName = 'add-investment-screen';

  @override
  _AddInvestmentScreenState createState() => _AddInvestmentScreenState();
}

class _AddInvestmentScreenState extends State<AddInvestmentScreen> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(selectedDate.year - 10),
        lastDate: DateTime(selectedDate.year + 10));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FinSimAppBar.appbar(title: 'Add Investment'),
      drawer: NavigationDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Start Date '),
                      SizedBox(width: 20),
                      Text('${selectedDate.toLocal()}'.split(" ")[0]),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select date'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('End Date   '),
                      SizedBox(width: 20),
                      Text('${selectedDate.toLocal()}'.split(" ")[0]),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select date'),
                  ),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name of Investment',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter name of Investment";
                  }
                  return null;
                },
                onChanged: (value) {
                  investment.name = value;
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
                  investment.amount = value.isEmpty ? 0 : int.parse(value);
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Profit Percentage'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter profit percentage";
                  }
                  return null;
                },
                onChanged: (value) {
                  investment.profitPercentage = int.parse(value);
                },
              ),
              Row(
                children: [
                  Text('Return Frequency:'),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Radio<ReturnFrequency>(
                              value: ReturnFrequency.Quarterly,
                              groupValue: investment.frequency,
                              onChanged: (ReturnFrequency? value) {
                                setState(() {
                                  investment.frequency = value!;
                                });
                              },
                            ),
                          ),
                          Text('Quarterly'),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Radio<ReturnFrequency>(
                              value: ReturnFrequency.Yearly,
                              groupValue: investment.frequency,
                              onChanged: (ReturnFrequency? value) {
                                setState(() {
                                  investment.frequency = value!;
                                });
                              },
                            ),
                          ),
                          Text('Yearly'),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Radio<ReturnFrequency>(
                              value: ReturnFrequency.OnTermination,
                              groupValue: investment.frequency,
                              onChanged: (ReturnFrequency? value) {
                                setState(() {
                                  investment.frequency = value!;
                                });
                              },
                            ),
                          ),
                          Text('On Termination'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Provider.of<IncomeModel>(context, listen: false)
                  //     .add(investment)
                  //     .then((_) => Navigator.pop(context));
                },
                child: Text('Add Investment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
