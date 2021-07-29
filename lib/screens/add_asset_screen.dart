import 'package:finsim/models/asset.dart';
import 'package:finsim/models/assetModel.dart';
import 'package:finsim/widgets/finsim_appbar.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AssetFrequency { Once, Monthly, Yearly }
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
    // Future<void> _selectStartDate(
    //   BuildContext context,
    // ) async {
    //   final DateTime? picked = await showDatePicker(
    //       context: context,
    //       initialDate: Jiffy().dateTime,
    //       firstDate: Jiffy().subtract(years: 10).dateTime,
    //       lastDate: Jiffy().add(years: 10).dateTime);
    //   print(picked);
    //   if (picked != null && !Jiffy(picked).isSame(asset.startDate)) {
    //     setState(() {
    //       asset.startDate = Jiffy(picked);
    //     });
    //   }
    // }

    // Future<void> _selectEndDate(
    //   BuildContext context,
    // ) async {
    //   final DateTime? picked = await showDatePicker(
    //       context: context,
    //       initialDate: Jiffy().dateTime,
    //       firstDate: Jiffy().subtract(years: 10).dateTime,
    //       lastDate: Jiffy().add(years: 10).dateTime);
    //   if (picked != null && !Jiffy(picked).isSame(asset.endDate)) {
    //     setState(() {
    //       asset.endDate = Jiffy(picked);
    //     });
    //   }
    // }

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
                  },
                ),
                // TextFormField(
                //   decoration: const InputDecoration(
                //     labelText: 'Amount',
                //   ),
                //   keyboardType: TextInputType.number,
                //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return "Please enter amount";
                //     }
                //   },
                //   onChanged: (value) {
                //     asset.amount = value.isEmpty ? 0 : int.parse(value);
                //   },
                // ),
                // SizedBox(height: 20),
                // Row(
                //   children: [
                //     Text('Frequency:'),
                //     SizedBox(width: 10),
                //     SizedBox(
                //       width: 30,
                //       child: Radio<AssetFrequency>(
                //         value: AssetFrequency.Once,
                //         groupValue: asset.frequency,
                //         onChanged: (AssetFrequency? value) {
                //           setState(() {
                //             asset.frequency = value!;
                //           });
                //         },
                //       ),
                //     ),
                //     Text('Once'),
                //     SizedBox(width: 15),
                //     SizedBox(
                //       width: 30,
                //       child: Radio<AssetFrequency>(
                //         value: AssetFrequency.Monthly,
                //         groupValue: asset.frequency,
                //         onChanged: (AssetFrequency? value) {
                //           setState(() {
                //             asset.frequency = value!;
                //           });
                //         },
                //       ),
                //     ),
                //     Text('Monthly'),
                //     SizedBox(width: 15),
                //     SizedBox(
                //       width: 30,
                //       child: Radio<AssetFrequency>(
                //         value: AssetFrequency.Yearly,
                //         groupValue: asset.frequency,
                //         onChanged: (AssetFrequency? value) {
                //           setState(() {
                //             asset.frequency = value!;
                //           });
                //         },
                //       ),
                //     ),
                //     Text('Yearly'),
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Row(
                //       children: [
                //         Text('Start Date '),
                //         SizedBox(width: 20),
                //         Text('${asset.startDate.format("yyyy-MM-dd")}'),
                //       ],
                //     ),
                //     TextButton(
                //       onPressed: () => _selectStartDate(context),
                //       child: Text('Select date'),
                //     ),
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Row(
                //       children: [
                //         Text('End Date '),
                //         SizedBox(width: 20),
                //         Text('${asset.endDate.format("yyyy-MM-dd")}'),
                //       ],
                //     ),
                //     TextButton(
                //       onPressed: () => _selectEndDate(context),
                //       child: Text('Select date'),
                //     ),
                //   ],
                // ),
                // TextFormField(
                //   decoration: const InputDecoration(
                //       labelText: 'Yearly Appreciation Percentage',
                //       hintText: 'Change per annum (%)'),
                //   keyboardType: TextInputType.number,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return "Please enter appreciation percentage";
                //     }
                //     return null;
                //   },
                //   onChanged: (value) {
                //     asset.yearlyAppreciationPercentage = int.parse(value);
                //   },
                // ),
                // SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<AssetModel>(context, listen: false)
                        .add(asset)
                        .then((_) => Navigator.pop(context));
                  },
                  child: Text('Add Asset'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
