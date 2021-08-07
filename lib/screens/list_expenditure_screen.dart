import 'package:finsim/models/asset_model.dart';
import 'package:finsim/models/expenditure_model.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/screens/add_expenditure_screen.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:finsim/widgets/yearly_appreciation_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListExpenditureScreen extends StatefulWidget {
  const ListExpenditureScreen({Key? key}) : super(key: key);
  static final routeName = 'expenditure-list-screen';

  @override
  _ListExpenditureScreenState createState() => _ListExpenditureScreenState();
}

class _ListExpenditureScreenState extends State<ListExpenditureScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ExpenditureModel, AssetModel>(
      builder: (context, expenditureModel, assetModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('Expenditures'),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AddExpenditureScreen.routeName)
                      .then((value) {
                    setState(
                        () {}); //Calling setState() to refresh screen on pop
                  });
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
          drawer: NavigationDrawer(),
          body: FutureBuilder<List<Expenditure>>(
            future: expenditureModel.items,
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
                              .yearlyAppreciationPercentage,
                          label: 'p. a.',
                          reverseColors: true,
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_expenditureList[index].amount.toString()),
                        if (!_expenditureList[index].belongsToAsset)
                          IconButton(
                            onPressed: () {
                              setState(() {
                                var selectedExpenditure =
                                    _expenditureList[index];
                                expenditureModel.delete(selectedExpenditure.id);
                              });
                            },
                            icon: Icon(Icons.delete),
                          )
                        else
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text(
                                        'This expenditure belongs to an Asset. To delete this expenditure, please delete the corresponding Asset'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: Text('OK'),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.info),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
