import 'package:restroapp/src/utils/Constants.dart';
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

  static Future<bool> checkUserLogin() async {
    bool checkUserLogin = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(AppConstant.USER_ID);
    if(userId == null || userId.isEmpty){
      checkUserLogin = false;
    }else{
      checkUserLogin = true;
    }
    return checkUserLogin;
  }


}
