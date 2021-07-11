import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/screens/add_income_screen.dart';
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
  List<Income> _incomeList = [];
  var _isLoading = true;

  @override
  Widget build(BuildContext context) {
    DBHelper.getIncome().then(
      (data) {
        _incomeList = data;
        setState(() {
          _isLoading = false;
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Income Sources'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AddIncomeScreen.routeName)
                  .then((value) {
                print("\n\nThen called\n\n");
                setState(() {}); //Calling setState() to refresh screen on pop
              });
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
              itemCount: _incomeList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  key: ValueKey(_incomeList[index].id),
                  title: Text(_incomeList[index].name),
                  subtitle: Text(
                      describeEnum(_incomeList[index].frequency.toString())),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_incomeList[index].amount.toString()),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            var selectedIncome = _incomeList[index];
                            _incomeList.removeAt(index);
                            DBHelper.deleteIncome(selectedIncome.id);
                          });
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
