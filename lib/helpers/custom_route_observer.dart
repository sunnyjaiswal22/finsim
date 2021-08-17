import 'package:finsim/helpers/constants.dart';
import 'package:finsim/helpers/globals.dart';
import 'package:finsim/screens/home_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CustomRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  _setOrientationForDashboard(String? routeName) {
    if (HomeScreen.routeName == routeName) {
      print('Observed home route');
      int yearsToSimulate = Globals.sharedPreferences.getInt('yearsToSimulate')!;
      print('yearsToSimulate: $yearsToSimulate');
      if (yearsToSimulate > Constants.maxChartBarsInPortrait) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _setOrientationForDashboard(route.settings.name);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _setOrientationForDashboard(newRoute.settings.name);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _setOrientationForDashboard(previousRoute.settings.name);
    }
  }
}
