import 'package:finsim/models/InvestmentModel.dart';
import 'package:finsim/models/investment.dart';
import 'package:finsim/screens/add_investment_screen.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:finsim/widgets/yearly_appreciation_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvestmentListScreen extends StatefulWidget {
  const InvestmentListScreen({Key? key}) : super(key: key);
  static final routeName = 'investment-list-screen';

  @override
  _InvestmentListScreenState createState() => _InvestmentListScreenState();
}

class _InvestmentListScreenState extends State<InvestmentListScreen> {
  late InvestmentModel investmentModel;
  late Future<List<Investment>> futureInvestmentList;

  @override
  void didChangeDependencies() {
    investmentModel = Provider.of<InvestmentModel>(context);
    futureInvestmentList = investmentModel.items;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Future Investments'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AddInvestmentScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: NavigationDrawer(),
      body: FutureBuilder<List<Investment>>(
          future: futureInvestmentList,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }
            final _investmentList = snapshot.data!;
            return ListView.builder(
              itemCount: _investmentList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  key: ValueKey(_investmentList[index].id),
                  title: Text(_investmentList[index].name),
                  subtitle: Row(
                    children: [
                      YearlyAppreciationInfo(
                        percentage: _investmentList[index].profitPercentage,
                        label: describeEnum(
                            _investmentList[index].frequency.toString()),
                      ),
                      Text(
                          '  ${_investmentList[index].startDate.year} - ${_investmentList[index].endDate.year}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_investmentList[index].amount.toString()),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            var selectedInvestment = _investmentList[index];
                            investmentModel.delete(selectedInvestment.id);
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
