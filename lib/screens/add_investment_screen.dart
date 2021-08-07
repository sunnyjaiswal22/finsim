import 'package:finsim/models/asset.dart';
import 'package:finsim/models/asset_model.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/screens/add_expenditure_screen.dart'
    show ExpenditureFrequency;
import 'package:finsim/screens/add_income_screen.dart';
import 'package:finsim/screens/list_asset_screen.dart';
import 'package:finsim/widgets/finsim_appbar.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

final _formKey = GlobalKey<FormState>();

class AddInvestmentScreen extends StatefulWidget {
  const AddInvestmentScreen({Key? key}) : super(key: key);
  static final routeName = 'add-investment-screen';

  @override
  _AddInvestmentScreenState createState() => _AddInvestmentScreenState();
}

class _AddInvestmentScreenState extends State<AddInvestmentScreen> {
  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments;
    arguments = arguments as Map<String, dynamic>;
    Asset asset = arguments['asset'];
    asset.expenditure.belongsToAsset = true;

    final currentDate = Jiffy().startOf(Units.DAY);

    Future<void> _selectStartDate(
      BuildContext context,
    ) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: currentDate.dateTime,
          firstDate: currentDate.clone().subtract(years: 10).dateTime,
          lastDate: currentDate.clone().add(years: 10).dateTime);
      if (picked != null && !Jiffy(picked).isSame(asset.expenditure.endDate)) {
        setState(() {
          asset.expenditure.startDate = Jiffy(picked);
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
      if (picked != null && !Jiffy(picked).isSame(asset.expenditure.endDate)) {
        setState(() {
          asset.expenditure.endDate = Jiffy(picked);
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
                  initialValue: asset.expenditure.name,
                  onChanged: (value) {
                    asset.expenditure.name = value;
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
                    asset.expenditure.amount =
                        value.isEmpty ? 0 : int.parse(value);
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
                        groupValue: asset.expenditure.frequency,
                        onChanged: (ExpenditureFrequency? value) {
                          setState(() {
                            asset.expenditure.frequency = value!;
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
                        groupValue: asset.expenditure.frequency,
                        onChanged: (ExpenditureFrequency? value) {
                          print('Inside $value');
                          setState(() {
                            print('Before: ${asset.expenditure.frequency}');
                            asset.expenditure.frequency = value!;
                            print('After: ${asset.expenditure.frequency}');
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
                        groupValue: asset.expenditure.frequency,
                        onChanged: (ExpenditureFrequency? value) {
                          setState(() {
                            asset.expenditure.frequency = value!;
                          });
                        },
                      ),
                    ),
                    Text('Yearly'),
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Yearly Appreciation (%)',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    asset.expenditure.yearlyAppreciationPercentage =
                        int.parse(value);
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
                        Text(
                            '${asset.expenditure.startDate.format("yyyy-MM-dd")}'),
                      ],
                    ),
                    TextButton(
                      onPressed: () => _selectStartDate(context),
                      child: Text('Select date'),
                    ),
                  ],
                ),
                if (asset.expenditure.frequency != ExpenditureFrequency.Once)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('End Date '),
                          SizedBox(width: 20),
                          Text(
                              '${asset.expenditure.endDate.format("yyyy-MM-dd")}'),
                        ],
                      ),
                      TextButton(
                        onPressed: () => _selectEndDate(context),
                        child: Text('Select date'),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                if (asset.generatesIncome)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AddIncomeScreen.routeName,
                          arguments: {'asset': asset});
                    },
                    child: Text('Proceed to Add Income'),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<AssetModel>(context, listen: false)
                          .add(asset)
                          .then((_) => Navigator.popUntil(context,
                              ModalRoute.withName(ListAssetScreen.routeName)));
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
