import 'dart:io';
import 'package:flutter/src/widgets/framework.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/ApiErrorResponse.dart';
import 'package:restroapp/src/models/Categories.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/RegisterUserData.dart';
import 'package:restroapp/src/models/StoreAreasData.dart';
import 'package:restroapp/src/models/StoreData.dart';
import 'package:restroapp/src/models/SubCategories.dart';
import 'package:restroapp/src/models/store_list.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:restroapp/src/utils/Constants.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:http/http.dart' as http;

class ApiController{


  static Future<List<StoreListModel>> storeListRequest(String url, Map jsonMap) async {
    //print('$url , $jsonMap');
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    //print(reply);
    //print("API response $reply");
    httpClient.close();
    final parsed = json.decode(reply);
    List<StoreListModel> storelist = (parsed["data"] as List).map<StoreListModel>((json) => new StoreListModel.fromJson(json)).toList();
    //print(" storelist ${storelist.length}");
    return storelist;
  }

  static Future<StoreData> versionApiRequest(String storeId, String deviceId) async {
    String versionApi = 'https://app.restroapp.com/${storeId}/api_v5/version';
    print('$versionApi , $storeId');

    FormData formData = new FormData.from(
        {"device_id": deviceId, "device_token":"", "platform":"android"});
    Dio dio = new Dio();
    Response response = await dio.post(versionApi, data: formData,
        options: new Options(
        contentType: ContentType.parse("application/json")));
    print(response.data);
    StoreData storeData = StoreData.fromJson(response.data);
    print("-------store.success ---${storeData.success}");
    return storeData;
  }

  static Future<List<CategoriesData>> getCategoriesApiRequest(String storeId) async {
    String categoriesUrl = "https://app.restroapp.com/${storeId}/api_v5/getCategories";
    print('$storeId , $categoriesUrl');

    Response response = await Dio().get(categoriesUrl);
    print(response);
    Categories categories = Categories.fromJson(response.data);
    print("-------Categories.length ---${categories.data.length}");

    try {
      DatabaseHelper databaseHelper = new DatabaseHelper();
      databaseHelper.getCount(DatabaseHelper.Categories_Table).then((count){
        print("---Categories-getCount------${count}");
        if(count == 0){
          for (int i = 0; i< categories.data.length; i++) {
            databaseHelper.saveCategories(categories.data[i]);
            String cat_id = categories.data[i].id;

            if(categories.data[i].subCategory != null){
              for (int j = 0; j< categories.data[i].subCategory.length; j++) {
                databaseHelper.saveSubCategories(categories.data[i].subCategory[j],cat_id);
              }
            }
          }
        }
      });
    } catch (e) {
      print(e);
    }
    return categories.data;
  }

  static Future<List<Product>> getSubCategoryProducts(String storeId,String catId ) async {
    String versionApi = 'https://app.restroapp.com/${storeId}/api_v5/getSubCategoryProducts/${catId}';
    print('$storeId , $versionApi');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString(AppConstant.DEVICE_ID);

    FormData formData = new FormData.from(
        {"device_id": deviceId, "device_token":"", "user_id":"", "platform":"android"});
    Dio dio = new Dio();
    Response response = await dio.post(versionApi, data: formData,
        options: new Options(
            contentType: ContentType.parse("application/json")));
    print(response.data);
    SubCategories subCategories = SubCategories.fromJson(response.data);
    //print("-------subCategories.length ---${subCategories.data.length}");
    if(subCategories.success){

    }else{
      Utils.showToast("No data found", false);
    }

    List<Product> subProductList = subCategories.data[0].products;
    //print("--1-----ProductList ---${subProductList.length}");

    DatabaseHelper databaseHelper = new DatabaseHelper();
    for(int i = 0; i < subProductList.length; i++){
      //print("-------Product-title ---${subProductList[i].title}");
      databaseHelper.checkProductsExist(DatabaseHelper.Products_Table, subProductList[i].categoryIds).then((count){
        //print("------checkProductsExist-----${count}");
        if(count == 0){
          databaseHelper.saveProducts(subProductList[i],DatabaseHelper.Favorite,
              subProductList[i].variants[0].mrpPrice,
              subProductList[i].variants[0].price, subProductList[i].variants[0].discount
              ,subProductList[i].variants[0].id);
        }
      });
    }
    //print("----2---ProductList ---${subProductList.length}");
    return subProductList;
  }

  static Future<List<Area>> deliveryAreasRequest() async {
    List<Area> areaList = new List();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeId = prefs.getString(AppConstant.STORE_ID);

    String deliveryAreas = 'https://app.restroapp.com/${storeId}/api_v5/deliveryAreas/Area';
    print('$deliveryAreas , $storeId');

    Response response = await Dio().get(deliveryAreas);
    print(response.data);
    StoreAreaData storeAreaData = StoreAreaData.fromJson(response.data);
    print("-------store.success ---${storeAreaData.success}");
    areaList = storeAreaData.data;
    return areaList;
  }

  /*To get the saved deliveryAddress of the logined user:
  POST https://app.restroapp.com/store_-id/api_v5/deliveryAddress
  method=GET & user_id=349*/

  static Future<List<DeliveryAddressData>> deliveryAddressApiRequest(BuildContext context) async {
    List<DeliveryAddressData> dataList = new List();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeId = prefs.getString(AppConstant.STORE_ID);
    String userId = prefs.getString(AppConstant.USER_ID);
    String deliveryAreas = 'https://app.restroapp.com/${storeId}/api_v5/deliveryAddress';
    print('$deliveryAreas , $storeId');

    FormData formData = new FormData.from({"method": "GET", "user_id":userId});
    Dio dio = new Dio();
    Response response = await dio.post(deliveryAreas, data: formData,
        options: new Options( contentType: ContentType.parse("application/json")));
    print(response.data);
    DeliveryAddressResponse deliveryAddressResponse = DeliveryAddressResponse.fromJson(response.data);
    //print("--DeliveryAddressResponse---${deliveryAddressResponse.success}");
    dataList = deliveryAddressResponse.data;
    if(deliveryAddressResponse.success){
      if(deliveryAddressResponse.data.isEmpty){
        //Utils.showToast("No data found!", false);
      }
    }else{
      //Utils.showToast("No data found!", false);
    }
    return dataList;
  }

  static Future<RegisterUser> registerApiRequest(String full_name,String password,String phone,String email) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeId = prefs.getString(AppConstant.STORE_ID);
    String deviceId = prefs.getString(AppConstant.DEVICE_ID);

    String versionApi = 'https://app.restroapp.com/${storeId}/api_v5/userSignup';
    print('$versionApi , $storeId');

    FormData formData = new FormData.from(
        {"full_name": full_name,
        "password":password,
        "device_id":deviceId,
        "device_token":"",
        "phone":phone,
        "email":email,
        "platform":"android"
        }
          );
    Dio dio = new Dio();
    Response response = await dio.post(versionApi, data: formData,
        options: new Options(
            contentType: ContentType.parse("application/json")));
    try {
      print(response.data);
      RegisterUser registerUser = RegisterUser.fromJson(response.data);
      print("-------store.success ---${registerUser.success}");

      if(registerUser != null && registerUser.success){
        SharedPrefs.storeSharedValue(AppConstant.USER_ID, registerUser.data.id);
        SharedPrefs.storeSharedValue(AppConstant.USER_NAME, registerUser.data.fullName);
        SharedPrefs.storeSharedValue(AppConstant.USER_EMAIL, registerUser.data.email);
        SharedPrefs.storeSharedValue(AppConstant.Profile_Image, registerUser.data.profileImage);
        SharedPrefs.storeSharedValue(AppConstant.OTP_VERIFY, registerUser.data.otpVerify);
        SharedPrefs.storeSharedValue(AppConstant.USER_PHONE, registerUser.data.phone);
        SharedPrefs.storeSharedValue(AppConstant.User_Refer_Code, registerUser.data.userReferCode);
        Utils.showToast(registerUser.message, true);
      }
      return registerUser;

    } catch (e) {
      print(e);
      ApiErrorResponse storeData = ApiErrorResponse.fromJson(response.data);
      print("--.ApiErrorResponse ---${storeData.success}");
      Utils.showToast(storeData.message, true);
      return null;
    }
    //{success: false, message: User already exist.}
  }

  static Future<RegisterUser> loginApiRequest(String full_name,String password) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeId = prefs.getString(AppConstant.STORE_ID);
    String deviceId = prefs.getString(AppConstant.DEVICE_ID);

    String versionApi = 'https://app.restroapp.com/${storeId}/api_v5/userLogin';
    print('$versionApi , $storeId');

    FormData formData = new FormData.from(
        {"email": full_name,
          "password":password,
          "device_id":deviceId,
          "device_token":"",
          "platform":"android"
        }
    );
    Dio dio = new Dio();
    Response response = await dio.post(versionApi, data: formData,
        options: new Options(
            contentType: ContentType.parse("application/json")));
    try {
      print(response.data);
      RegisterUser registerUser = RegisterUser.fromJson(response.data);
      print("----login---store.success ---${registerUser.success}");

      if(registerUser != null && registerUser.success){
        SharedPrefs.storeSharedValue(AppConstant.USER_ID, registerUser.data.id);
        SharedPrefs.storeSharedValue(AppConstant.USER_NAME, registerUser.data.fullName);
        SharedPrefs.storeSharedValue(AppConstant.USER_EMAIL, registerUser.data.email);
        SharedPrefs.storeSharedValue(AppConstant.Profile_Image, registerUser.data.profileImage);
        SharedPrefs.storeSharedValue(AppConstant.OTP_VERIFY, registerUser.data.otpVerify);
        SharedPrefs.storeSharedValue(AppConstant.USER_PHONE, registerUser.data.phone);
        SharedPrefs.storeSharedValue(AppConstant.User_Refer_Code, registerUser.data.userReferCode);
        Utils.showToast("You have log in successfully", true);
      }
      return registerUser;

    } catch (e) {
      print(e);
      ApiErrorResponse storeData = ApiErrorResponse.fromJson(response.data);
      print("-login-.ApiErrorResponse ---${storeData.success}");
      Utils.showToast(storeData.message, true);
      return null;
    }
    //{success: false, message: User already exist.}
  }

/*
  https://app.restroapp.com/49/api_v5/userSignup
  password:Test@123
  full_name:29August
  device_id:abaf785580c22722
  &phone=2132123212
  device_token:fkUCpZLs08Q%3AAPA91bFWngo1c3UP5iOA8NGty3UO1G4loOuSpuOgTJsXiwG1dk0qsMndyvFvOAFpVK7O_xLGzy3Ut5pkkjhlcgHiaZilvdZQEnco_FZ4p7mLie24V6TyPashe8vQPuWzkvepDXwKQNY5type:
  email:assaaaa@signitysolutions.in
  platform:android

  To get the saved deliveryAddress of the logined user:
  POST https://app.restroapp.com/store_-id/api_v5/deliveryAddress
  method=GET & user_id=349

  when we click pn Area Filed then api hit - to get the area of the store
  https://app.restroapp.com/1/api_v5/deliveryAreas/Area

*/

}