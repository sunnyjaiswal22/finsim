import 'package:finsim/helpers/globals.dart';
import 'package:finsim/models/Income_model.dart';
import 'package:finsim/widgets/finsim_appbar.dart';
import 'package:flutter/material.dart';

import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static final routeName = 'settings-screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  _saveSettings(int yearsToSimulate) {
    print('Saving settings');
    Globals.sharedPreferences.setInt('yearsToSimulate', yearsToSimulate);
    Provider.of<IncomeModel>(context, listen: false)
        .notifyListenersFromOutside();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    int _yearsToSimulate = Globals.sharedPreferences.getInt('yearsToSimulate')!;
    return Scaffold(
      appBar: FinSimAppBar.appbar(title: 'Settings'),
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
                      labelText: 'Number of years to simulate',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter number of years to simulate";
                      }
                      int intValue = int.parse(value);
                      if (intValue < 5 || intValue > 20) {
                        return "Please enter number of years between 5 and 20";
                      }
                      return null;
                    },
                    initialValue: _yearsToSimulate.toString(),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _yearsToSimulate = int.parse(value);
                      }
                    },
                  ),
                  ElevatedButton(
                    child: Text('Submit'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveSettings(_yearsToSimulate);
                      }
                    },
                  )
                ],
              ),
            )),
      ),
    );
  }
}
