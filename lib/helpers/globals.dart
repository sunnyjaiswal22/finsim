import 'package:shared_preferences/shared_preferences.dart';

class Globals {
  static late SharedPreferences sharedPreferences;
  static Future initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('yearsToSimulate', 5);
  }
}
