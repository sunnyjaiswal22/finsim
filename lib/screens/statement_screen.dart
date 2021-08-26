import 'package:finsim/helpers/simulator.dart';
import 'package:finsim/models/Income_model.dart';
import 'package:finsim/models/asset.dart';
import 'package:finsim/models/asset_model.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/models/expenditure_model.dart';
import 'package:finsim/models/income.dart';
import 'package:finsim/models/liability.dart';
import 'package:finsim/models/liability_model.dart';
import 'package:finsim/models/statement_entry.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatementScreen extends StatelessWidget {
  const StatementScreen({Key? key}) : super(key: key);
  static final routeName = 'statement-screen';

  @override
  Widget build(BuildContext context) {
    return Consumer4<IncomeModel, ExpenditureModel, AssetModel, LiabilityModel>(
      builder: (context, incomeModel, expenditureModel, assetModel, liabilityModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: const Text('Statement'),
            ),
          ),
          drawer: NavigationDrawer(),
          body: FutureBuilder(
            future: Future.wait([
              incomeModel.items,
              expenditureModel.items,
              assetModel.items,
              liabilityModel.items,
            ]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              }
              List<Income> incomeList = snapshot.data![0];
              List<Expenditure> expenditureList = snapshot.data![1];
              List<Asset> assetList = snapshot.data![2];
              List<Liability> liabilityList = snapshot.data![3];
              final statementList = Simulator.simulate(
                incomeList,
                expenditureList,
                assetList,
                liabilityList,
              )['statementList'] as List<StatementEntry>;
              return statementList.isEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 50,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('No transactions yet ...',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        ListTile(
                          leading: const Text('Date          '),
                          title: const Text('Transaction'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Amount'),
                              SizedBox(
                                width: 20,
                              ),
                              const Text('Balance'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: statementList.length,
                            itemBuilder: (BuildContext context, int i) {
                              var item = statementList[i];
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Text('${item.date.format("dd-MM-yyyy")}'),
                                    title: Text(
                                      '${item.message}',
                                      style: TextStyle(
                                        color: item.transactionType == TransactionType.Credit
                                            ? Colors.green.shade900
                                            : Colors.red.shade900,
                                      ),
                                    ),
                                    subtitle: Text(
                                        '${describeEnum(item.transactionType)} ${item.details}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('${item.amount}'),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text('${item.balance}'),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    );
            },
          ),
        );
      },
    );
  }
}
