import 'package:flutter_bloc_base/src/data/local/pref/pref_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs extends PrefHelper {
  static const String firstRun = 'firstRun';

  @override
  Future<bool> isFirstRun() async {
    var _preferences = await SharedPreferences.getInstance();
    return _preferences.getBool(firstRun) ?? true;
  }
}
