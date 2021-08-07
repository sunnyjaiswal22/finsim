import 'package:finsim/models/asset.dart';
import 'package:finsim/screens/add_investment_screen.dart';
import 'package:finsim/widgets/finsim_appbar.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

final _formKey = GlobalKey<FormState>();

class AddAssetScreen extends StatefulWidget {
  const AddAssetScreen({Key? key}) : super(key: key);
  static final routeName = 'add-asset-screen';

  @override
  _AddAssetScreenState createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends State<AddAssetScreen> {
  Asset asset = Asset();
  @override
  Widget build(BuildContext context) {
    final currentDate = Jiffy().startOf(Units.DAY);

    Future<void> _selectStartDate(
      BuildContext context,
    ) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: currentDate.dateTime,
          firstDate: currentDate.clone().subtract(years: 10).dateTime,
          lastDate: currentDate.clone().add(years: 10).dateTime);
      if (picked != null && !Jiffy(picked).isSame(asset.startDate)) {
        setState(() {
          asset.startDate = Jiffy(picked);
          asset.expenditure.startDate = Jiffy(picked);
          asset.income.startDate = Jiffy(picked);
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
      if (picked != null && !Jiffy(picked).isSame(asset.endDate)) {
        setState(() {
          asset.endDate = Jiffy(picked);
          asset.expenditure.endDate = Jiffy(picked);
          asset.income.endDate = Jiffy(picked);
        });
      }
    }

    return Scaffold(
      appBar: FinSimAppBar.appbar(title: 'Add Asset'),
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
                    labelText: 'Name of Asset',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter name of asset";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    asset.name = value;
                    asset.expenditure.name = 'Asset: ' + value;
                    asset.income.name = 'Asset: ' + value;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Start Date '),
                        SizedBox(width: 20),
                        Text('${asset.startDate.format("yyyy-MM-dd")}'),
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
                        Text('End Date   '),
                        SizedBox(width: 20),
                        Text('${asset.endDate.format("yyyy-MM-dd")}'),
                      ],
                    ),
                    TextButton(
                      onPressed: () => _selectEndDate(context),
                      child: Text('Select date'),
                    ),
                  ],
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Yearly Profit (%)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    asset.yearlyAppreciationPercentage = int.parse(value);
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Generates regular income '),
                    SizedBox(width: 15),
                    SizedBox(
                      width: 30,
                      child: Radio<bool>(
                        value: true,
                        groupValue: asset.generatesIncome,
                        onChanged: (bool? value) {
                          setState(() {
                            asset.generatesIncome = value!;
                          });
                        },
                      ),
                    ),
                    Text('Yes'),
                    SizedBox(width: 15),
                    SizedBox(
                      width: 30,
                      child: Radio<bool>(
                        value: false,
                        groupValue: asset.generatesIncome,
                        onChanged: (bool? value) {
                          setState(() {
                            asset.generatesIncome = value!;
                          });
                        },
                      ),
                    ),
                    Text('No'),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AddInvestmentScreen.routeName,
                          arguments: {'asset': asset},
                        );
                      },
                      child: Text('Proceed to add Investment'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
