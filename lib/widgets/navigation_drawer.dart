import 'package:finsim/screens/expenditure_sources_screen.dart';
import 'package:finsim/screens/home_screen.dart';
import 'package:finsim/screens/income_sources_screen.dart';
import 'package:finsim/screens/investment_list_screen.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Drawer(
        child: ListView(
          children: [
            Container(
              height: 120,
              child: DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: Image.asset('assets/images/logo_white.png'),
              ),
            ),
            ListTile(
              title: Text('Home'),
              contentPadding: EdgeInsets.only(left: 20),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, HomeScreen.routeName);
              },
            ),
            ListTile(
              title: Text('Income'),
              contentPadding: EdgeInsets.only(left: 20),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, IncomeSourcesScreen.routeName);
              },
            ),
            ListTile(
              title: Text('Expenditure'),
              contentPadding: EdgeInsets.only(left: 20),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                    context, ExpenditureSourcesScreen.routeName);
              },
            ),
            ListTile(
              title: Text('Assets'),
              contentPadding: EdgeInsets.only(left: 20),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, InvestmentListScreen.routeName);
              },
            ),
            ListTile(
              title: Text('Liabilities'),
              contentPadding: EdgeInsets.only(left: 20),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, InvestmentListScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
