import 'package:finsim/models/asset_model.dart';
import 'package:finsim/models/expenditure_model.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/liability_model.dart';
import 'package:finsim/screens/add_expenditure_screen.dart';
import 'package:finsim/widgets/empty_list_info.dart';
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
    return Consumer3<ExpenditureModel, AssetModel, LiabilityModel>(
      builder: (context, expenditureModel, assetModel, liabilityModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('Expenditures'),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AddExpenditureScreen.routeName,
                    arguments: {'isBlankStart': false},
                  );
                },
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
              return _expenditureList.length == 0
                  ? EmptyListInfo()
                  : ListView.builder(
                      itemCount: _expenditureList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var item = _expenditureList[index];
                        return ListTile(
                          key: ValueKey(item.id),
                          isThreeLine: true,
                          leading: Icon(Icons.payments, color: Colors.red),
                          title: Text(item.name),
                          subtitle: Wrap(
                            children: [
                              YearlyAppreciationInfo(
                                percentage: item.yearlyAppreciationPercentage,
                                label: 'p. a.',
                                reverseColors: true,
                              ),
                              Text(
                                describeEnum(
                                  item.frequency.toString(),
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(item.amount.toString()),
                              if (!item.belongsToAsset &&
                                  !item.belongsToLiability)
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      var selectedExpenditure = item;
                                      expenditureModel
                                          .delete(selectedExpenditure.id);
                                    });
                                  },
                                )
                              else if (item.belongsToAsset)
                                IconButton(
                                  icon: Icon(Icons.info),
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
                                )
                              else if (item.belongsToLiability)
                                IconButton(
                                  icon: Icon(Icons.info),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text(
                                              'This expenditure belongs to a Liability. To delete this expenditure, please delete the corresponding Liability'),
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
