import 'package:finsim/models/expenditure_model.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/screens/home_screen.dart';
import 'package:finsim/widgets/finsim_appbar.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

enum ExpenditureFrequency { Once, Monthly, Yearly }
final _formKey = GlobalKey<FormState>();

class AddExpenditureScreen extends StatefulWidget {
  const AddExpenditureScreen({Key? key}) : super(key: key);
  static final routeName = 'add-expenditure-screen';

  @override
  _AddExpenditureScreenState createState() => _AddExpenditureScreenState();
}

class _AddExpenditureScreenState extends State<AddExpenditureScreen> {
  Expenditure expenditure = Expenditure();

  @override
  Widget build(BuildContext context) {
    var isBlankStart = false;
    var arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null) {
      arguments = arguments as Map<String, dynamic>;
      if (arguments['isBlankStart'] != null) {
        isBlankStart = arguments['isBlankStart'];
      }
    }
    final currentDate = Jiffy().startOf(Units.DAY);

    Future<void> _selectStartDate(
      BuildContext context,
    ) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: currentDate.dateTime,
          firstDate: currentDate.clone().subtract(years: 10).dateTime,
          lastDate: currentDate.clone().add(years: 10).dateTime);
      if (picked != null && !Jiffy(picked).isSame(expenditure.endDate)) {
        setState(() {
          expenditure.startDate = Jiffy(picked);
        });
      }
    }

    Future<void> _selectEndDate(
      BuildContext context,
    ) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: currentDate.dateTime,
          firstDate: currentDate.clone().subtract(years: 10).dateTime,
          lastDate: currentDate.clone().add(years: 10).dateTime);
      if (picked != null && !Jiffy(picked).isSame(expenditure.endDate)) {
        setState(() {
          expenditure.endDate = Jiffy(picked);
        });
      }
    }

    return Scaffold(
      appBar: FinSimAppBar.appbar(title: 'Add Expenditure'),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Start Date '),
                        SizedBox(width: 20),
                        Text('${expenditure.startDate.format("yyyy-MM-dd")}'),
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
                        Text('${expenditure.endDate.format("yyyy-MM-dd")}'),
                      ],
                    ),
                    TextButton(
                      onPressed: () => _selectEndDate(context),
                      child: Text('Select date'),
                    ),
                  ],
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
      ),
    );
  }
}
