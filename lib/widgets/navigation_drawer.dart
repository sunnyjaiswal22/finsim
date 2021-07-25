import 'package:finsim/screens/expenditure_sources_screen.dart';
import 'package:finsim/screens/home_screen.dart';
import 'package:finsim/screens/income_sources_screen.dart';
import 'package:finsim/screens/investment_list_screen.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Image.asset('assets/images/logo_white.png'),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
          ),
          ListTile(
            title: Text('Current Income Sources'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, IncomeSourcesScreen.routeName);
            },
          ),
          ListTile(
            title: Text('Current Expenditure Sources'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, ExpenditureSourcesScreen.routeName);
            },
          ),
          ListTile(
            title: Text('Investments'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, InvestmentListScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
