import 'package:finsim/models/asset.dart';
import 'package:finsim/models/asset_model.dart';
import 'package:finsim/screens/add_asset_screen.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListAssetScreen extends StatefulWidget {
  const ListAssetScreen({Key? key}) : super(key: key);
  static final routeName = 'assets-list-screen';

  @override
  _ListAssetState createState() => _ListAssetState();
}

class _ListAssetState extends State<ListAssetScreen> {
  late AssetModel assetModel;
  late Future<List<Asset>> futureAssetList;

  @override
  void didChangeDependencies() {
    assetModel = Provider.of<AssetModel>(context);
    futureAssetList = assetModel.items;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
          future: futureAssetList,
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
                  isThreeLine: true,
                  leading: Icon(Icons.account_balance),
                  title: Text(_assetList[index].name),
                  subtitle: Text(
                      'Investment: ${_assetList[index].expenditure.amount} Income: ${_assetList[index].income.amount} Yearly Appreciation: ${_assetList[index].yearlyAppreciationPercentage}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_assetList[index].expenditure.amount.toString()),
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
  }
}
