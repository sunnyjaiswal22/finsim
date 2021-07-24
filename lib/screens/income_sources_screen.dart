import 'package:finsim/models/IncomeModel.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/screens/add_income_screen.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:finsim/widgets/yearly_appreciation_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncomeSourcesScreen extends StatefulWidget {
  const IncomeSourcesScreen({Key? key}) : super(key: key);
  static final routeName = 'income-sources-screen';

  @override
  _IncomeSourcesState createState() => _IncomeSourcesState();
}

class _IncomeSourcesState extends State<IncomeSourcesScreen> {
  late IncomeModel incomeModel;
  late Future<List<Income>> futureIncomeList;

  @override
  void didChangeDependencies() {
    incomeModel = Provider.of<IncomeModel>(context);
    futureIncomeList = incomeModel.items;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Current Income Sources'),
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
      body: FutureBuilder<List<Income>>(
          future: futureIncomeList,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }
            final _incomeList = snapshot.data!;
            return ListView.builder(
              itemCount: _incomeList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  key: ValueKey(_incomeList[index].id),
                  title: Text(_incomeList[index].name),
                  subtitle: Row(
                    children: [
                      Text(
                        describeEnum(_incomeList[index].frequency.toString()),
                      ),
                      YearlyAppreciationInfo(
                          percentage:
                              _incomeList[index].yearlyAppreciationPercentage),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_incomeList[index].amount.toString()),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            var selectedIncome = _incomeList[index];
                            incomeModel.delete(selectedIncome.id);
                          });
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
