import 'package:finsim/models/ExpenditureModel.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/screens/add_expenditure_screen.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:finsim/widgets/yearly_appreciation_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenditureSourcesScreen extends StatefulWidget {
  const ExpenditureSourcesScreen({Key? key}) : super(key: key);
  static final routeName = 'expenditure-sources-screen';

  @override
  _ExpenditureSourcesScreenState createState() =>
      _ExpenditureSourcesScreenState();
}

class _ExpenditureSourcesScreenState extends State<ExpenditureSourcesScreen> {
  late Future<List<Expenditure>> futureExpenditureList;
  late ExpenditureModel expenditureModel;
  @override
  void didChangeDependencies() {
    expenditureModel = Provider.of<ExpenditureModel>(context);
    futureExpenditureList = expenditureModel.items;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Current Expenditure Sources'),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AddExpenditureScreen.routeName)
                    .then((value) {
                  setState(() {}); //Calling setState() to refresh screen on pop
                });
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        drawer: NavigationDrawer(),
        body: FutureBuilder<List<Expenditure>>(
            future: futureExpenditureList,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              }
              final _expenditureList = snapshot.data!;
              return ListView.builder(
                itemCount: _expenditureList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    key: ValueKey(_expenditureList[index].id),
                    title: Text(_expenditureList[index].name),
                    subtitle: Row(
                      children: [
                        Text(
                          describeEnum(
                            _expenditureList[index].frequency.toString(),
                          ),
                        ),
                        YearlyAppreciationInfo(
                            percentage: _expenditureList[index]
                                .yearlyAppreciationPercentage),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_expenditureList[index].amount.toString()),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              var selectedExpenditure = _expenditureList[index];
                              expenditureModel.delete(selectedExpenditure.id);
                            });
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              );
            }));
  }
}
