import 'package:finsim/models/asset.dart';
import 'package:finsim/models/asset_model.dart';
import 'package:finsim/models/liability.dart';
import 'package:finsim/models/liability_model.dart';
import 'package:finsim/screens/add_asset_screen.dart';
import 'package:finsim/screens/add_liability_screen.dart';
import 'package:finsim/widgets/empty_list_info.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:finsim/widgets/yearly_appreciation_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListLiabilityScreen extends StatefulWidget {
  const ListLiabilityScreen({Key? key}) : super(key: key);
  static final routeName = 'list-liability-screen';

  @override
  _ListLiabilityState createState() => _ListLiabilityState();
}

class _ListLiabilityState extends State<ListLiabilityScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LiabilityModel>(
      builder: (context, liabilityModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('Liabilities'),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AddLiabilityScreen.routeName);
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
          drawer: NavigationDrawer(),
          body: FutureBuilder<List<Liability>>(
              future: liabilityModel.items,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(child: CircularProgressIndicator());
                }
                final _liabilityList = snapshot.data!;
                return _liabilityList.length == 0
                    ? EmptyListInfo()
                    : ListView.builder(
                        itemCount: _liabilityList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var item = _liabilityList[index];
                          return ListTile(
                            key: ValueKey(item.id),
                            leading: Icon(Icons.account_balance),
                            title: Row(
                              children: [
                                Text(item.name),
                                YearlyAppreciationInfo(
                                  percentage: item.rateOfInterest,
                                  label: 'p. a.',
                                )
                              ],
                            ),
                            subtitle: Wrap(
                              children: [
                                Text('${item.startDate.format("MMM yyyy")}'),
                                Text(' - ${item.endDate.format("MMM yyyy")} '),
                                Text('Investment ' +
                                    describeEnum(
                                        item.emi.frequency.toString())),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(item.emi.amount.toString()),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      var selectedAsset = item;
                                      liabilityModel.delete(selectedAsset);
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
      },
    );
  }
}
