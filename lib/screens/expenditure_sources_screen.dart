import 'package:finsim/helpers/db_helper.dart';
import 'package:finsim/models/expenditure.dart';
import 'package:finsim/screens/add_expenditure_screen.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ExpenditureSourcesScreen extends StatefulWidget {
  const ExpenditureSourcesScreen({Key? key}) : super(key: key);
  static final routeName = 'expenditure-sources-screen';

  @override
  _ExpenditureSourcesScreenState createState() =>
      _ExpenditureSourcesScreenState();
}

class _ExpenditureSourcesScreenState extends State<ExpenditureSourcesScreen> {
  List<Expenditure> expenditureList = [];
  var _isLoading = true;

  @override
  void initState() {
    DBHelper.getExpenditure().then(
      (data) {
        expenditureList = data;
        setState(() {
          _isLoading = false;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Expenditure Sources'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AddExpenditureScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: NavigationDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: expenditureList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(expenditureList[index].name),
                  subtitle: Text(describeEnum(
                      expenditureList[index].frequency.toString())),
                  trailing: Text(expenditureList[index].amount.toString()),
                );
              },
            ),
    );
  }
}
