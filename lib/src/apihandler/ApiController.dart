import 'dart:io';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/ApiErrorResponse.dart';
import 'package:restroapp/src/models/BookNowData.dart';
import 'package:restroapp/src/models/CartData.dart';
import 'package:restroapp/src/models/Categories.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/ProfileData.dart';
import 'package:restroapp/src/models/RegisterUserData.dart';
import 'package:restroapp/src/models/StoreAreasData.dart';
import 'package:restroapp/src/models/StoreData.dart';
import 'package:restroapp/src/models/StoreOffersResponse.dart';
import 'package:restroapp/src/models/SubCategories.dart';
import 'package:restroapp/src/models/TaxCalulationResponse.dart';
import 'package:restroapp/src/models/ValidateCouponsResponse.dart';
import 'package:restroapp/src/models/store_list.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:restroapp/src/utils/Constants.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:http/http.dart' as http;

class ApiController{

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
    SharedPrefs.storeSharedValue(AppConstant.LAT, storeData.store.lat);
    SharedPrefs.storeSharedValue(AppConstant.LNG, storeData.store.lng);

    SharedPrefs.storeSharedValue(AppConstant.ABOUT_US, storeData.store.aboutUs);
    print("-------store.success ---${storeData.success}");
    return storeData;
  }

  static Future<List<CategoriesData>> getCategoriesApiRequest(String storeId) async {
    String categoriesUrl = "https://app.restroapp.com/${storeId}/api_v5/getCategories";
    print('$storeId , $categoriesUrl');

    Response response = await Dio().get(categoriesUrl);
    //print(response);
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

  static Future<List<Product>> getSubCategoryProducts(String catId ) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeId = prefs.getString(AppConstant.STORE_ID);
    String deviceId = prefs.getString(AppConstant.DEVICE_ID);

    String versionApi = 'https://app.restroapp.com/${storeId}/api_v5/getSubCategoryProducts/${catId}';
    print('$storeId , $versionApi');

    FormData formData = new FormData.from(
        {"device_id": deviceId, "device_token":"", "user_id":"", "platform":"android"});
    Dio dio = new Dio();
    Response response = await dio.post(versionApi, data: formData,
        options: new Options(
            contentType: ContentType.parse("application/json")));
    //print(response.data.toString());
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
    print(response.data.toString());
    StoreAreaData storeAreaData = StoreAreaData.fromJson(response.data);
    //print("-------store.success ---${storeAreaData.success}");
    areaList = storeAreaData.data;
    return areaList;
  }

  static Future<List<DeliveryAddressData>> deliveryAddressApiRequest() async {
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
    //print(response.data.toString());
    DeliveryAddressResponse deliveryAddressResponse = DeliveryAddressResponse.fromJson(response.data);
    //print("--DeliveryAddressResponse---${deliveryAddressResponse.success}");
    dataList = deliveryAddressResponse.data;
    if(deliveryAddressResponse.success){
      if(deliveryAddressResponse.data.isEmpty){
        Utils.showToast("No address found!", false);
      }
    }else{
      //Utils.showToast("No data found!", false);
    }
    return dataList;
  }

  static Future<String> saveDeliveryAddressApiRequest(String method,
      String zipcode,String address,String area_id,String area_name,String address_id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String storeId = prefs.getString(AppConstant.STORE_ID);
      String userId = prefs.getString(AppConstant.USER_ID);
      String mobile = prefs.getString(AppConstant.USER_PHONE);
      String first_name = prefs.getString(AppConstant.USER_NAME);
      String email = prefs.getString(AppConstant.USER_EMAIL);

      String deliveryAreas = 'https://app.restroapp.com/${storeId}/api_v5/deliveryAddress';
      print('$method , $deliveryAreas');
      FormData formData;
      if(method == AppConstant.EDIT){
        formData = new FormData.from(
            {
              "method": method, "user_id":userId,"address_id":address_id,
              "zipcode": zipcode, "country":"","address": address, "city":"" ,"area_name":area_name,
              "mobile":mobile,"state":"","area_id":area_id,"first_name":first_name,"email":email
            }
        );
      }else{
        formData = new FormData.from(
            {
              "method": method, "user_id":userId,
              "zipcode": zipcode, "country":"","address": address, "city":"" ,"area_name":area_name,
              "mobile":mobile,"state":"","area_id":area_id,"first_name":first_name,"email":email
            }
        );
      }

      //print(formData.toString());
      Dio dio = new Dio();
      Response response = await dio.post(deliveryAreas, data: formData,
              options: new Options( contentType: ContentType.parse("application/json")));
      //print(response.data.toString());

      ApiErrorResponse storeData = ApiErrorResponse.fromJson(response.data);
      Utils.showToast(storeData.message, false);

    } catch (e) {
      print(e);
    }
    return "";
  }

  /*======================================
  https://app.restroapp.com/1/api_v5/deliveryAddress
  device_id=abaf785580c22722&
  method=DELETE&
  user_id=396
  &device_token=e7RIye653Cg%3AAPA91bGiSiG_TK1WYTWpulosswo6KtYU6ghbvjDDAQMt9b94zuWl_OUfTeGqsevVnw6oZmKZxiu2siot-9Sg8y-fuOQfDBc0NCfbjH_f66rAYHoqpwkVIJ0prVXY3-AS1vZX3yzkhFNJ&
  address_id=143&
  platform=android
*/
  static Future<String> deleteDeliveryAddressApiRequest(String address_id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String storeId = prefs.getString(AppConstant.STORE_ID);
      String userId = prefs.getString(AppConstant.USER_ID);
      String device_id = prefs.getString(AppConstant.DEVICE_ID);

      String deliveryAreas = 'https://app.restroapp.com/${storeId}/api_v5/deliveryAddress';
      print('$deliveryAreas , $storeId');

      FormData formData = new FormData.from({"method": "DELETE", "device_id":device_id,
        "user_id": userId, "device_token":"","address_id": address_id,"platform":"android"});

      Dio dio = new Dio();
      Response response = await dio.post(deliveryAreas, data: formData,
          options: new Options( contentType: ContentType.parse("application/json")));
      //print(response.data);

      ApiErrorResponse storeData = ApiErrorResponse.fromJson(response.data);
      Utils.showToast(storeData.message, false);

    } catch (e) {
      print(e);
    }
    return "";
  }

  static Future<List<OffersData>> storeOffersApiRequest(String area_id) async {
    List<OffersData> data = new List();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String storeId = prefs.getString(AppConstant.STORE_ID);
      String userId = prefs.getString(AppConstant.USER_ID);
      //store_id=1&user_id=424&area_id=1&order_facility=Delivery
      String deliveryAreas = 'https://app.restroapp.com/${storeId}/api_v5/storeOffers';
      print('$deliveryAreas , $storeId');

      FormData formData = new FormData.from({"store_id": storeId, "user_id":userId,
        "area_id": area_id,"order_facility": "Delivery"});

      Dio dio = new Dio();
      Response response = await dio.post(deliveryAreas, data: formData,
          options: new Options( contentType: ContentType.parse("application/json")));
      print(response.data);

      StoreOffersResponse storeData = StoreOffersResponse.fromJson(response.data);
      //Utils.showToast(storeData.message, false);
      data = storeData.data;

    } catch (e) {
      print(e);
    }
    return data;
  }

  static Future<ValidateCouponsResponse> validateOfferApiRequest(OffersData offer,int area_id, String json) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String device_id = prefs.getString(AppConstant.DEVICE_ID);
      String userId = prefs.getString(AppConstant.USER_ID);
      String storeId = prefs.getString(AppConstant.STORE_ID);
      String deliveryAreas = 'https://app.restroapp.com/${storeId}/api_v5/validateAllCoupons';
      print('$userId , $deliveryAreas');
      String payment_method="";
      if(area_id == 0){
        payment_method="2";
      }else{
        payment_method="3";
      }

      FormData formData = new FormData.from({"coupon_code": offer.couponCode, "device_id":device_id,
        "user_id": userId,"device_token": "","orders": "${json}",
        "platform": "android","payment_method": payment_method});

      Dio dio = new Dio();
      Response response = await dio.post(deliveryAreas, data: formData,
          options: new Options( contentType: ContentType.parse("application/json")));
      print(response.data);

      ValidateCouponsResponse storeData = ValidateCouponsResponse.fromJson(response.data);
      Utils.showToast(storeData.message, false);
      return storeData;

    } catch (e) {
      print(e);
    }
  }

  static Future<TaxCalulationResponse> multipleTaxCalculationRequest(String fixed_discount_amount,
      String tax, String shipping,String discount,String jsonn) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String device_id = prefs.getString(AppConstant.DEVICE_ID);
      String userId = prefs.getString(AppConstant.USER_ID);
      String storeId = prefs.getString(AppConstant.STORE_ID);
      String deliveryAreas = 'https://app.restroapp.com/${storeId}/api_v5/multiple_tax_calculation';
      print('$userId , $deliveryAreas');

      FormData formData = new FormData.from({"fixed_discount_amount":fixed_discount_amount,
        "device_id":device_id,
        "tax":tax,
        "shipping": shipping,
        "discount":discount,
        "order_detail": '${jsonn.toString()}'});

      Dio dio = new Dio();
      Response response = await dio.post(deliveryAreas, data: formData,
          options: new Options(contentType: ContentType.parse("application/json")));
      //print("-------multiple_tax_calculation--${response.statusCode}-${response.statusMessage}-");
      //print("--headers--${response.headers}");
      //print("--TaxCalculation--${response.data}");
      print("------Json------ ${json.encode(response.data)}");
      TaxCalulationResponse storeData = TaxCalulationResponse.fromJson(response.data);
      //Utils.showToast(storeData.message, false);
      return storeData;
    } catch (e) {
      print("---Exception----multiple_tax_calculation--${e.toString()}--");
      print(e);
    }
  }


  static Future<ProfileData> profileRequest(String full_name,String emailId,String phoneNumber) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeId = prefs.getString(AppConstant.STORE_ID);
    String deviceId = prefs.getString(AppConstant.DEVICE_ID);
    String userId = prefs.getString(AppConstant.USER_ID);
    String versionApi = 'https://app.restroapp.com/${storeId}/api_v5/updateProfile';
    print('$versionApi , $storeId');

    FormData formData = new FormData.from(
        {"full_name": full_name,
          "email":emailId,
          "user_id":userId,
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
      ProfileData profileData = ProfileData.fromJson(response.data);
      print("----updateProfile--- ---${profileData.success}");

      if(profileData != null && profileData.success){
      //  SharedPrefs.storeSharedValue(AppConstant.USER_ID, registerUser.data.id);
        //SharedPrefs.storeSharedValue(AppConstant.USER_NAME, registerUser.data.fullName);
      //  SharedPrefs.storeSharedValue(AppConstant.USER_EMAIL, registerUser.data.email);
       // SharedPrefs.storeSharedValue(AppConstant.Profile_Image, registerUser.data.profileImage);
       // SharedPrefs.storeSharedValue(AppConstant.OTP_VERIFY, registerUser.data.otpVerify);
       // SharedPrefs.storeSharedValue(AppConstant.USER_PHONE, registerUser.data.phone);
      //  SharedPrefs.storeSharedValue(AppConstant.User_Refer_Code, registerUser.data.userReferCode);
        Utils.showToast("Profile Saved Successfully", true);
      }
      return profileData;

    } catch (e) {
      print(e);
      ApiErrorResponse storeData = ApiErrorResponse.fromJson(response.data);
      print("-login-.ApiErrorResponse ---${storeData.success}");
      Utils.showToast(storeData.message, true);
      return null;
    }
    //{success: false, message: User already exist.}
  }

  static Future<List<OffersData>> storeOffersApiRequest_() async {
    List<OffersData> data = new List();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String storeId = prefs.getString(AppConstant.STORE_ID);
      String userId = prefs.getString(AppConstant.USER_ID);
      //store_id=1&user_id=424&area_id=1&order_facility=Delivery
      String deliveryAreas = 'https://app.restroapp.com/${storeId}/api_v5/storeOffers';
      print('$deliveryAreas , $storeId');

      FormData formData = new FormData.from({"store_id": storeId, "user_id":userId,
      "order_facility": "Delivery"});

      Dio dio = new Dio();
      Response response = await dio.post(deliveryAreas, data: formData,
          options: new Options( contentType: ContentType.parse("application/json")));
      print(response.data);

      StoreOffersResponse storeData = StoreOffersResponse.fromJson(response.data);
      //Utils.showToast(storeData.message, false);
      data = storeData.data;

    } catch (e) {
      print(e);
    }
    return data;
  }


  static Future<BookNowData> setStoreQuery(String full_name,String phoneNumber,String city,
      String email,String dateAndTime,String messageText) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeId = prefs.getString(AppConstant.STORE_ID);
    String deviceId = prefs.getString(AppConstant.DEVICE_ID);
    String userId = prefs.getString(AppConstant.USER_ID);
    String versionApi = 'https://app.restroapp.com/${storeId}/api_v5/setStoreQuery';
    print('$versionApi , $storeId');

    FormData formData = new FormData.from(
        {"store_id": full_name,
          "device_id":deviceId,
          "device_token":userId,
          "platform":deviceId,
          "user_id":userId,
          "query":"android"
        }
    );
    Dio dio = new Dio();
    Response response = await dio.post(versionApi, data: formData,
        options: new Options(
            contentType: ContentType.parse("application/json")));
    try {
      print(response.data);
      BookNowData bookData = BookNowData.fromJson(response.data);
      print("----updateProfile--- ---${bookData.success}");

      if(bookData != null && bookData.success){
        //  SharedPrefs.storeSharedValue(AppConstant.USER_ID, registerUser.data.id);
        //SharedPrefs.storeSharedValue(AppConstant.USER_NAME, registerUser.data.fullName);
        //  SharedPrefs.storeSharedValue(AppConstant.USER_EMAIL, registerUser.data.email);
        // SharedPrefs.storeSharedValue(AppConstant.Profile_Image, registerUser.data.profileImage);
        // SharedPrefs.storeSharedValue(AppConstant.OTP_VERIFY, registerUser.data.otpVerify);
        // SharedPrefs.storeSharedValue(AppConstant.USER_PHONE, registerUser.data.phone);
        //  SharedPrefs.storeSharedValue(AppConstant.User_Refer_Code, registerUser.data.userReferCode);
        Utils.showToast("Profile Saved Successfully", true);
      }
      return bookData;

    } catch (e) {
      print(e);
      ApiErrorResponse storeData = ApiErrorResponse.fromJson(response.data);
      print("-login-.ApiErrorResponse ---${storeData.success}");
      Utils.showToast(storeData.message, true);
      return null;
    }
    //{success: false, message: User already exist.}
  }
}