import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/screens/add_income_screen.dart';
import 'package:finsim/widgets/finsim_appbar.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IncomeSourcesScreen extends StatefulWidget {
  const IncomeSourcesScreen({Key? key}) : super(key: key);
  static final routeName = 'income-sources-screen';

  @override
  _IncomeSourcesState createState() => _IncomeSourcesState();
}

class _IncomeSourcesState extends State<IncomeSourcesScreen> {
  List<Income> incomeList = [];
  var _isLoading = true;

  @override
  void initState() {
    DBHelper.getIncome().then(
      (data) {
        incomeList = data;
        setState(() {
          _isLoading = false;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('FinSim - Income Sources'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AddIncomeScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: NavigationDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: incomeList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(incomeList[index].name),
                  subtitle: Text(
                      describeEnum(incomeList[index].frequency.toString())),
                  trailing: Text(incomeList[index].amount.toString()),
                );
              },
            ),
    );
  }
}
