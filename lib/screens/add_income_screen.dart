import 'package:finsim/models/Income_model.dart';
import 'package:finsim/models/asset.dart';
import 'package:finsim/models/asset_model.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/screens/add_expenditure_screen.dart';
import 'package:finsim/screens/list_asset_screen.dart';
import 'package:finsim/widgets/finsim_appbar.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

enum IncomeFrequency { Once, Monthly, Yearly }

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({Key? key}) : super(key: key);
  static final routeName = 'add-income-screen';

  @override
  _AddIncomeScreenState createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  Income income = Income();
  late Asset asset;

  @override
  Widget build(BuildContext context) {
    var isBlankStart = false;
    var arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null) {
      arguments = arguments as Map<String, dynamic>;
      if (arguments['isBlankStart'] != null) {
        isBlankStart = arguments['isBlankStart'];
      }
      if (arguments['asset'] != null) {
        asset = arguments['asset'];
        income = asset.income;
        income.name = asset.name;
      }
    }
    final initialDate = Jiffy().startOf(Units.DAY);

    Future<void> _selectStartDate(
      BuildContext context,
    ) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: initialDate.dateTime,
          firstDate: initialDate.clone().subtract(years: 10).dateTime,
          lastDate: initialDate.clone().add(years: 10).dateTime);
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
          initialDate: initialDate.dateTime,
          firstDate: initialDate.clone().subtract(years: 10).dateTime,
          lastDate: initialDate.clone().add(years: 10).dateTime);
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
                  initialValue: income.name,
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
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Start Date '),
                        SizedBox(width: 20),
                        Text('${income.startDate.format("dd-MM-yyyy")}'),
                      ],
                    ),
                    IconButton(
                      onPressed: () => _selectStartDate(context),
                      icon: Icon(Icons.today, size: 30),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                if (income.frequency != IncomeFrequency.Once)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('End Date   '),
                          SizedBox(width: 20),
                          Text('${income.endDate.format("dd-MM-yyyy")}'),
                        ],
                      ),
                      IconButton(
                        onPressed: () => _selectEndDate(context),
                        icon: Icon(Icons.today, size: 30),
                      ),
                    ],
                  ),
                if (income.frequency != IncomeFrequency.Once)
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Yearly Appreciation (%)',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      income.yearlyAppreciationPercentage = double.parse(value);
                    },
                  ),
                SizedBox(height: 20),
                if (isBlankStart)
                  ElevatedButton(
                    child: Text('Continue'),
                    onPressed: () {
                      Provider.of<IncomeModel>(context, listen: false).add(income).then(
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
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                        size: 40,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' Income Saved',
                                      style: TextStyle(color: Colors.black, fontSize: 22),
                                    ),
                                  ]),
                                ),
                                content: Text(
                                    'Income saved successfully. Please tap OK to add expenditure details'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                        context,
                                        AddExpenditureScreen.routeName,
                                        arguments: {'isBlankStart': isBlankStart},
                                      );
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  )
                else if (income.belongsToAsset)
                  ElevatedButton(
                    child: Text('Save Asset'),
                    onPressed: () {
                      Provider.of<AssetModel>(context, listen: false).add(asset).then((_) =>
                          Navigator.popUntil(
                              context, ModalRoute.withName(ListAssetScreen.routeName)));
                    },
                  )
                else
                  ElevatedButton(
                    child: Text('Submit'),
                    onPressed: () {
                      Provider.of<IncomeModel>(context, listen: false)
                          .add(income)
                          .then((_) => Navigator.pop(context));
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
