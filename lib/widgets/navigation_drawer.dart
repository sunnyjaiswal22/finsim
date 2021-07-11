import 'package:finsim/screens/expenditure_sources_screen.dart';
import 'package:finsim/screens/home_screen.dart';
import 'package:finsim/screens/income_sources_screen.dart';
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
              Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.routeName, (route) => false);
            },
          ),
          ListTile(
            title: Text('Income Sources'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, IncomeSourcesScreen.routeName, (route) => false);
            },
          ),
          ListTile(
            title: Text('Expenditure Sources'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context,
                  ExpenditureSourcesScreen.routeName, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
