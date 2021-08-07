import 'package:finsim/models/Income_model.dart';
import 'package:finsim/models/asset_model.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/screens/add_income_screen.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:finsim/widgets/yearly_appreciation_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListIncomeScreen extends StatefulWidget {
  const ListIncomeScreen({Key? key}) : super(key: key);
  static final routeName = 'income-list-screen';

  @override
  _ListIncomeState createState() => _ListIncomeState();
}

class _ListIncomeState extends State<ListIncomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<IncomeModel, AssetModel>(
      builder: (context, incomeModel, assetModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('Income Sources'),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AddIncomeScreen.routeName,
                    arguments: {'isBlankStart': false},
                  );
                },
              ),
            ],
          ),
          drawer: NavigationDrawer(),
          body: FutureBuilder<List<Income>>(
            future: incomeModel.items,
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
            },
          ),
        );
      },
    );
  }
}
