import 'package:finsim/models/asset.dart';
import 'package:finsim/models/asset_model.dart';
import 'package:finsim/screens/add_asset_screen.dart';
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
    return Consumer<AssetModel>(
      builder: (context, assetModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('Liabilities'),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AddAssetScreen.routeName);
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
          drawer: NavigationDrawer(),
          body: FutureBuilder<List<Asset>>(
              future: assetModel.items,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(child: CircularProgressIndicator());
                }
                final _assetList = snapshot.data!;
                return _assetList.length == 0
                    ? EmptyListInfo()
                    : ListView.builder(
                        itemCount: _assetList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var item = _assetList[index];
                          return ListTile(
                            key: ValueKey(item.id),
                            leading: Icon(Icons.account_balance),
                            title: Row(
                              children: [
                                Text(item.name),
                                YearlyAppreciationInfo(
                                  percentage: item.yearlyAppreciationPercentage,
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
                                        item.investment.frequency.toString()) +
                                    (item.generatesIncome ? '' : '')),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(item.investment.amount.toString()),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      var selectedAsset = item;
                                      assetModel.delete(selectedAsset);
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
