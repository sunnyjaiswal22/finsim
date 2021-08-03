import 'package:finsim/models/asset.dart';
import 'package:finsim/models/asset_model.dart';
import 'package:finsim/screens/add_expenditure_screen.dart'
    show ExpenditureFrequency;
import 'package:finsim/widgets/finsim_appbar.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

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
    //Setting flag on expenditure so as not to show the delete button on expenditure list
    asset.expenditure.belongsToAsset = true;
    Future<void> _selectStartDate(
      BuildContext context,
    ) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: Jiffy().dateTime,
          firstDate: Jiffy().subtract(years: 10).dateTime,
          lastDate: Jiffy().add(years: 10).dateTime);
      print(picked);
      if (picked != null &&
          !Jiffy(picked).isSame(asset.expenditure.startDate)) {
        setState(() {
          print('Setting date');
          asset.expenditure.startDate = Jiffy(picked);
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
      if (picked != null && !Jiffy(picked).isSame(asset.expenditure.endDate)) {
        setState(() {
          asset.expenditure.endDate = Jiffy(picked);
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
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red.shade800),
                      onPressed: () {
                        Provider.of<AssetModel>(context, listen: false)
                            .add(asset)
                            .then((_) => Navigator.pop(context));
                      },
                      child: Text('Add Expenditure'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green.shade800),
                      onPressed: () {
                        Provider.of<AssetModel>(context, listen: false)
                            .add(asset)
                            .then((_) => Navigator.pop(context));
                      },
                      child: Text('Add Income'),
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
