import 'package:finsim/widgets/finsim_appbar.dart';
import 'package:finsim/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);
  static final routeName = 'loading-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FinSimAppBar.appbar(title: 'Finance Simulator'),
      drawer: NavigationDrawer(),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
