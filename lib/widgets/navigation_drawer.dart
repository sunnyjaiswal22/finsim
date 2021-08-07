import 'package:finsim/screens/list_asset_screen.dart';
import 'package:finsim/screens/list_expenditure_screen.dart';
import 'package:finsim/screens/home_screen.dart';
import 'package:finsim/screens/list_income_screen.dart';
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
              onTap: () {
                Navigator.popUntil(
                    context, ModalRoute.withName(HomeScreen.routeName));
              },
            ),
            ListTile(
              title: Text('Income Sources'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, ListIncomeScreen.routeName);
              },
            ),
            ListTile(
              title: Text('Expenditures'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, ListExpenditureScreen.routeName);
              },
            ),
            ListTile(
              title: Text('Assets'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, ListAssetScreen.routeName);
              },
            ),
            ListTile(
              title: Text('Liabilities'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, HomeScreen.routeName);
              },
            ),
            ListTile(
              title: Text('Statement'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, HomeScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
