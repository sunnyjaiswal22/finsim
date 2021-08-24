import 'package:finsim/models/asset.dart';
import 'package:finsim/models/asset_model.dart';
import 'package:finsim/screens/add_expenditure_screen.dart' show ExpenditureFrequency;
import 'package:finsim/screens/add_income_screen.dart';
import 'package:finsim/screens/list_asset_screen.dart';
import 'package:finsim/widgets/finsim_appbar.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class AddInvestmentScreen extends StatefulWidget {
  const AddInvestmentScreen({Key? key}) : super(key: key);
  static final routeName = 'add-investment-screen';

  @override
  _AddInvestmentScreenState createState() => _AddInvestmentScreenState();
}

class _AddInvestmentScreenState extends State<AddInvestmentScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments;
    arguments = arguments as Map<String, dynamic>;
    Asset asset = arguments['asset'];

    asset.investment.startDate = asset.startDate.clone();
    asset.investment.endDate = asset.endDate.clone();

    Future<void> _selectStartDate(
      BuildContext context,
    ) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: asset.startDate.dateTime,
          firstDate: asset.startDate.clone().subtract(years: 10).dateTime,
          lastDate: asset.startDate.clone().add(years: 10).dateTime);
      if (picked != null && !Jiffy(picked).isSame(asset.investment.endDate)) {
        setState(() {
          asset.investment.startDate = Jiffy(picked);
        });
      }
    }

    Future<void> _selectEndDate(
      BuildContext context,
    ) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: asset.endDate.dateTime,
          firstDate: asset.endDate.clone().subtract(years: 10).dateTime,
          lastDate: asset.endDate.clone().add(years: 10).dateTime);
      if (picked != null && !Jiffy(picked).isSame(asset.investment.endDate)) {
        setState(() {
          asset.investment.endDate = Jiffy(picked);
        });
      }
    }

    return Scaffold(
      appBar: FinSimAppBar.appbar(title: 'Add Investment'),
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
                    labelText: 'Investment Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter investment name";
                    }
                    return null;
                  },
                  initialValue: asset.investment.name,
                  onChanged: (value) {
                    asset.investment.name = value;
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
                    asset.investment.amount = value.isEmpty ? 0 : int.parse(value);
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
                        groupValue: asset.investment.frequency,
                        onChanged: (ExpenditureFrequency? value) {
                          setState(() {
                            asset.investment.frequency = value!;
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
                        groupValue: asset.investment.frequency,
                        onChanged: (ExpenditureFrequency? value) {
                          setState(() {
                            asset.investment.frequency = value!;
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
                        groupValue: asset.investment.frequency,
                        onChanged: (ExpenditureFrequency? value) {
                          setState(() {
                            asset.investment.frequency = value!;
                          });
                        },
                      ),
                    ),
                    Text('Yearly'),
                  ],
                ),
                if (asset.investment.frequency != ExpenditureFrequency.Once)
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Yearly Appreciation (%)',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      asset.investment.yearlyAppreciationPercentage = double.parse(value);
                    },
                  ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Start Date '),
                        SizedBox(width: 20),
                        Text('${asset.investment.startDate.format("dd-MM-yyyy")}'),
                      ],
                    ),
                    IconButton(
                      onPressed: () => _selectStartDate(context),
                      icon: Icon(Icons.today, size: 30),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                if (asset.investment.frequency != ExpenditureFrequency.Once)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('End Date   '),
                          SizedBox(width: 20),
                          Text('${asset.investment.endDate.format("dd-MM-yyyy")}'),
                        ],
                      ),
                      IconButton(
                        onPressed: () => _selectEndDate(context),
                        icon: Icon(Icons.today, size: 30),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                if (asset.generatesIncome)
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushNamed(context, AddIncomeScreen.routeName,
                            arguments: {'asset': asset});
                      }
                    },
                    child: Text('Proceed to Add Income'),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<AssetModel>(context, listen: false).add(asset).then((_) =>
                            Navigator.popUntil(
                                context, ModalRoute.withName(ListAssetScreen.routeName)));
                      }
                    },
                    child: Text('Submit'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
