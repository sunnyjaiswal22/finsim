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
          firstDate: initialDate.clone().subtract(years: 10).dateTime,
          lastDate: initialDate.clone().add(years: 10).dateTime);
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
                  decoration: const InputDecoration(labelText: 'Rate of Interest (%)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    liability.rateOfInterest = double.parse(value);
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Duration (years)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    liability.durationInYears = int.parse(value);
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
                        Provider.of<LiabilityModel>(context, listen: false)
                            .add(liability)
                            .then((_) => Navigator.pop(context));
                      },
                      child: Text('Submit'),
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
