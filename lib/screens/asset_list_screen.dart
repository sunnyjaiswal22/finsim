import 'package:finsim/models/asset.dart';
import 'package:finsim/models/asset_model.dart';
import 'package:finsim/screens/add_asset_screen.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AssetListScreen extends StatefulWidget {
  const AssetListScreen({Key? key}) : super(key: key);
  static final routeName = 'assets-list-screen';

  @override
  _AssetListState createState() => _AssetListState();
}

class _AssetListState extends State<AssetListScreen> {
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
                  title: Text(_assetList[index].name),
                  subtitle: Column(
                    children: [
                      Text('abc'),
                      Text('xyz'),
                      Text('123'),
                    ],
                  ),
                  // subtitle: Row(
                  //   children: [
                  //     Text(
                  //       describeEnum(_assetList[index].frequency.toString()),
                  //     ),
                  //     YearlyAppreciationInfo(
                  //       percentage:
                  //           _assetList[index].yearlyAppreciationPercentage,
                  //       label: 'p. a.',
                  //     ),
                  //   ],
                  // ),
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
