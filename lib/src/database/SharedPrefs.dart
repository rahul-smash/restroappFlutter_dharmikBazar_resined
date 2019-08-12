import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

  static Future storeSharedValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future clearSharedPrefsValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }


}
