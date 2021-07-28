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
      width: MediaQuery.of(context).size.width * 0.4,
      child: Drawer(
        child: Container(
          decoration:
              new BoxDecoration(color: Theme.of(context).primaryColorDark),
          child: ListView(
            children: [
              Container(
                height: 80,
                child: DrawerHeader(
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColorDark),
                  child: Image.asset('assets/images/logo_white.png'),
                ),
              ),
              ListTile(
                title: Text('Home', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, HomeScreen.routeName);
                },
              ),
              ListTile(
                title: Text('Income', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, IncomeSourcesScreen.routeName);
                },
              ),
              ListTile(
                title:
                    Text('Expenditure', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                      context, ExpenditureSourcesScreen.routeName);
                },
              ),
              ListTile(
                title: Text('Assets', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, InvestmentListScreen.routeName);
                },
              ),
              ListTile(
                title:
                    Text('Liabilities', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, InvestmentListScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
