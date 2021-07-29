import 'package:finsim/models/Income_source_model.dart';
import 'package:finsim/models/income_source.dart';
import 'package:finsim/screens/add_income_source_screen.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:finsim/widgets/yearly_appreciation_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncomeSourceListScreen extends StatefulWidget {
  const IncomeSourceListScreen({Key? key}) : super(key: key);
  static final routeName = 'income-sources-screen';

  @override
  _IncomeSourcesState createState() => _IncomeSourcesState();
}

class _IncomeSourcesState extends State<IncomeSourceListScreen> {
  late IncomeSourceModel incomeSourceModel;
  late Future<List<IncomeSource>> futureIncomeList;

  @override
  void didChangeDependencies() {
    incomeSourceModel = Provider.of<IncomeSourceModel>(context);
    futureIncomeList = incomeSourceModel.items;
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
              Navigator.pushNamed(context, AddIncomeSourceScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: NavigationDrawer(),
      body: FutureBuilder<List<IncomeSource>>(
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
                            _incomeList[index].yearlyAppreciationPercentage,
                        label: 'p. a.',
                      ),
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
                            incomeSourceModel.delete(selectedIncome.id);
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
