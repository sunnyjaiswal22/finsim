import 'package:finsim/helpers/constants.dart';
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

class AddExpenditureScreen extends StatefulWidget {
  const AddExpenditureScreen({Key? key}) : super(key: key);
  static final routeName = 'add-expenditure-screen';

  @override
  _AddExpenditureScreenState createState() => _AddExpenditureScreenState();
}

class _AddExpenditureScreenState extends State<AddExpenditureScreen> {
  final _formKey = GlobalKey<FormState>();
  var expenditure = Expenditure();

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments;
    arguments = arguments as Map<String, dynamic>;
    var isBlankStart = arguments['isBlankStart'];

    final initialDate = Jiffy().startOf(Units.DAY);

    Future<void> _selectStartDate(
      BuildContext context,
    ) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: initialDate.dateTime,
          firstDate: initialDate.clone().subtract(years: 100).dateTime,
          lastDate: initialDate.clone().add(years: 100).dateTime);
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
          initialDate: initialDate.dateTime,
          firstDate: initialDate.clone().subtract(years: 100).dateTime,
          lastDate: initialDate.clone().add(years: 100).dateTime);
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
                  initialValue: expenditure.name,
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
                    const Text('Frequency:'),
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
                    const Text('Once'),
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
                    const Text('Monthly'),
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
                    const Text('Yearly'),
                  ],
                ),
                if (expenditure.frequency != ExpenditureFrequency.Once)
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Yearly Appreciation (%)',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      expenditure.yearlyAppreciationPercentage =
                          double.parse(value);
                    },
                  ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('Start Date '),
                        SizedBox(width: 20),
                        Text('${expenditure.startDate.format("dd-MM-yyyy")}'),
                      ],
                    ),
                    IconButton(
                      onPressed: () => _selectStartDate(context),
                      icon: Icon(Icons.today, size: 30),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                if (expenditure.frequency != ExpenditureFrequency.Once)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('End Date   '),
                          SizedBox(width: 20),
                          if (!expenditure.endDate
                              .isSame(Constants.maxDateTime))
                            Text('${expenditure.endDate.format("dd-MM-yyyy")}'),
                        ],
                      ),
                      IconButton(
                        onPressed: () => _selectEndDate(context),
                        icon: Icon(Icons.today, size: 30),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                if (isBlankStart)
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<ExpenditureModel>(context, listen: false)
                            .add(expenditure)
                            .then(
                          (_) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: RichText(
                                    text: TextSpan(children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 40,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' Thanks',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 22),
                                      ),
                                    ]),
                                  ),
                                  content: const Text(
                                      'Expenditure details saved. Please add more details like assets and liabilities to get more realistic results. Tap OK to view simulation result.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.popUntil(
                                          context,
                                          ModalRoute.withName(
                                              HomeScreen.routeName),
                                        );
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                    child: const Text('Continue'),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<ExpenditureModel>(context, listen: false)
                            .add(expenditure)
                            .then((_) => Navigator.pop(context));
                      }
                    },
                    child: const Text('Submit'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
