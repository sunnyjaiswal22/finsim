import 'package:finsim/models/asset.dart';
import 'package:finsim/models/asset_model.dart';
import 'package:finsim/screens/add_asset_screen.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:finsim/widgets/yearly_appreciation_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListAssetScreen extends StatefulWidget {
  const ListAssetScreen({Key? key}) : super(key: key);
  static final routeName = 'list-asset-screen';

  @override
  _ListAssetState createState() => _ListAssetState();
}

class _ListAssetState extends State<ListAssetScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AssetModel>(
      builder: (context, assetModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('Assets'),
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
                return ListView.builder(
                  itemCount: _assetList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      key: ValueKey(_assetList[index].id),
                      leading: Icon(Icons.account_balance),
                      title: Row(
                        children: [
                          Text(_assetList[index].name),
                          YearlyAppreciationInfo(
                            percentage:
                                _assetList[index].yearlyAppreciationPercentage,
                            label: 'p. a.',
                          )
                        ],
                      ),
                      subtitle: Wrap(
                        children: [
                          Text('Investment ' +
                              describeEnum(_assetList[index]
                                  .investment
                                  .frequency
                                  .toString()) +
                              (_assetList[index].generatesIncome ? '' : '')),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_assetList[index].investment.amount.toString()),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                var selectedAsset = _assetList[index];
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
