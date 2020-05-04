import 'package:restroapp/src/models/MobileVerified.dart';
import 'package:restroapp/src/models/OTPVerified.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPrefs {

  static void saveStore(StoreModel model) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    dynamic storeResponse = model.toJson();
    String jsonString = jsonEncode(storeResponse);
    sharedUser.setString('store', jsonString);
  }

  static Future<StoreModel> getStore() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    Map<String, dynamic> storeMap = json.decode(sharedUser.getString('store'));
    var user = StoreModel.fromJson(storeMap);
    return user;
  }

  static void saveUser(UserModel model) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    dynamic userResponse = model.toJson();
    String jsonString = jsonEncode(userResponse);
    sharedUser.setString('user', jsonString);
  }

  static Future<UserModel> getUser() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    Map<String, dynamic> userMap = json.decode(sharedUser.getString('user'));
    var user = UserModel.fromJson(userMap);
    return user;
  }

  static void removeUser() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    sharedUser.remove('user');
  }

  static void setUserLoggedIn(bool loggedIn) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    sharedUser.setBool('isLoggedIn', loggedIn);
    AppConstant.isLoggedIn = loggedIn;
  }

  static Future<bool> isUserLoggedIn() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    return sharedUser.getBool('isLoggedIn') ?? false;
  }


  static Future storeSharedValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> getStoreSharedValue(String key) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    return sharedUser.getString(key);
  }


  static void saveUserMobile(UserModelMobile model) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    dynamic userResponse = model.toJson();
    String jsonString = jsonEncode(userResponse);
    sharedUser.setString('user', jsonString);
  }

  static Future<UserModelMobile> getUserMobile() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    Map<String, dynamic> userMap = json.decode(sharedUser.getString('user'));
    var user = UserModelMobile.fromJson(userMap);
    return user;
  }
  static void saveUserOTP(OtpVerified model) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    dynamic userResponse = model.toJson();
    String jsonString = jsonEncode(userResponse);
    sharedUser.setString('data', jsonString);
  }

  static Future<OtpVerified> getUserOTP() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    Map<String, dynamic> userMap = json.decode(sharedUser.getString('data'));
    var user = OtpVerified.fromJson(userMap);
    return user;
  }
}