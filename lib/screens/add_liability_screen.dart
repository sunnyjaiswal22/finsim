import 'package:finsim/models/liability.dart';
import 'package:finsim/models/liability_model.dart';
import 'package:finsim/widgets/finsim_appbar.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class AddLiabilityScreen extends StatefulWidget {
  const AddLiabilityScreen({Key? key}) : super(key: key);
  static final routeName = 'add-liability-screen';

  @override
  _AddLiabilityScreenState createState() => _AddLiabilityScreenState();
}

class _AddLiabilityScreenState extends State<AddLiabilityScreen> {
  final _formKey = GlobalKey<FormState>();
  Liability liability = Liability();

  @override
  Widget build(BuildContext context) {
    final initialDate = Jiffy().startOf(Units.DAY);

    Future<void> _selectStartDate(
      BuildContext context,
    ) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: initialDate.dateTime,
          firstDate: initialDate.clone().subtract(years: 100).dateTime,
          lastDate: initialDate.clone().add(years: 100).dateTime);
      if (picked != null && !Jiffy(picked).isSame(liability.startDate)) {
        setState(() {
          liability.startDate = Jiffy(picked);
          liability.emi.startDate = Jiffy(picked);
        });
      }
    }

    return Scaffold(
      appBar: FinSimAppBar.appbar(title: 'Add Liability'),
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
                    labelText: 'Name of Liability',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter name of Liability";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    liability.name = value;
                    liability.emi.name = 'EMI: ' + value;
                  },
                ),
                SizedBox(height: 10),
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
                  onChanged: (value) {
                    liability.amount = value.isEmpty ? 0 : int.parse(value);
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Rate of Interest (% per annum)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter rate of interest";
                    }
                    var doubleValue = double.parse(value);
                    if (doubleValue == 0.0) {
                      return "Please enter a non zero value";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    liability.rateOfInterest = double.parse(value);
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Duration (years)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter duration";
                    }
                    var intValue = int.tryParse(value);
                    if (intValue == null) {
                      return "Please enter an integer value";
                    }
                    if (intValue == 0) {
                      return "Please enter a non zero value";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (int.tryParse(value) != null) {
                      liability.durationInYears = int.parse(value);
                    }
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
                        Text('${liability.startDate.format("dd-MM-yyyy")}'),
                      ],
                    ),
                    IconButton(
                      onPressed: () => _selectStartDate(context),
                      icon: Icon(Icons.today, size: 30),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Provider.of<LiabilityModel>(context, listen: false)
                              .add(liability)
                              .then((_) => Navigator.pop(context));
                        }
                      },
                      child: const Text('Submit'),
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
