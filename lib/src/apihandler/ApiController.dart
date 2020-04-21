
import 'package:restroapp/src/Screens/LoginSignUp/ForgotPasswordScreen.dart';
import 'package:restroapp/src/Screens/LoginSignUp/LoginMobileScreen.dart';
import 'package:restroapp/src/Screens/LoginSignUp/OtpScreen.dart';
import 'package:restroapp/src/Screens/LoginSignUp/RegisterScreen.dart';
import 'package:restroapp/src/apihandler/ApiConstants.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/CategoryResponseModel.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/MobileVerified.dart';
import 'package:restroapp/src/models/OTPVerified.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/models/StoreDeliveryAreasResponse.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/StoreOffersResponse.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/models/TaxCalulationResponse.dart';
import 'package:restroapp/src/models/ValidateCouponsResponse.dart';
import 'package:restroapp/src/models/GetOrderHistory.dart';
import 'package:restroapp/src/models/forgotPassword/GetForgotPwdData.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';


class ApiController {
  static Future<StoreResponse> versionApiRequest(String storeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString(AppConstant.deviceId);
    String deviceToken = prefs.getString(AppConstant.deviceToken);
    var url = ApiConstants.baseUrl.replaceAll("storeId", storeId) +
        ApiConstants.version;

    var request = new http.MultipartRequest("POST", Uri.parse(url));
    try {
      request.fields.addAll({
        "device_id": deviceId,
        "device_token": deviceToken,
        "platform": Platform.isIOS ? "IOS" : "Android"
      });

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      final parsed = json.decode(respStr);
      StoreResponse storeData = StoreResponse.fromJson(parsed);
      SharedPrefs.saveStore(storeData.store);
      return storeData;
    } catch (e) {
      Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<UserResponse> registerApiRequest(UserData user) async {
    StoreModel store = await SharedPrefs.getStore();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString(AppConstant.deviceId);
    String deviceToken = prefs.getString(AppConstant.deviceToken);
    var url = ApiConstants.baseUrl.replaceAll("storeId", store.id) +
        ApiConstants.signUp;
    var request = new http.MultipartRequest("POST", Uri.parse(url));

    try {
      request.fields.addAll({
        "full_name": user.name,
        "phone": user.phone,
        "email": user.email,
        "password": user.password,
        "device_id": deviceId,
        "device_token": deviceToken,
        "platform": Platform.isIOS ? "IOS" : "Android"
      });

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      final parsed = json.decode(respStr);
      UserResponse userResponse = UserResponse.fromJson(parsed);
      if (userResponse.success) {
        SharedPrefs.setUserLoggedIn(true);
        SharedPrefs.saveUser(userResponse.user);
      }
      Utils.showToast(userResponse.message, true);
      return userResponse;
    } catch (e) {
      Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<UserResponse> loginApiRequest(
      String username, String password) async {
    StoreModel store = await SharedPrefs.getStore();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString(AppConstant.deviceId);
    String deviceToken = prefs.getString(AppConstant.deviceToken);
    var url = ApiConstants.baseUrl.replaceAll("storeId", store.id) +
        ApiConstants.login;
    var request = new http.MultipartRequest("POST", Uri.parse(url));

    try {
      request.fields.addAll({
        "email": username,
        "password": password,
        "device_id": deviceId,
        "device_token": deviceToken,
        "platform": Platform.isIOS ? "IOS" : "Android"
      });

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      final parsed = json.decode(respStr);
      print(parsed);
      UserResponse userResponse = UserResponse.fromJson(parsed);
      if (userResponse.success) {
        SharedPrefs.setUserLoggedIn(true);
        SharedPrefs.saveUser(userResponse.user);
      }
      //Utils.showToast(userResponse.message ?? "User loggedin successfully", true);
      return userResponse;
    } catch (e) {
      //Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<GetForgotPwdData> forgotPasswordApiRequest(ForgotPasswordData forgotPasswordData) async {
    StoreModel store = await SharedPrefs.getStore();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString(AppConstant.deviceId);

    var url = ApiConstants.baseUrl.replaceAll("storeId", store.id) +
        ApiConstants.forgetPassword;
    var request = new http.MultipartRequest("POST", Uri.parse(url));

    try {
      request.fields.addAll({
        "email_id": forgotPasswordData.email,
   /*     "device_id": deviceId,
        "device_token": "",
        "platform": Platform.isIOS ? "IOS" : "Android"*/
      });

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      final parsed = json.decode(respStr);
      GetForgotPwdData userResponse = GetForgotPwdData.fromJson(parsed);
      //Utils.showToast(userResponse.message, true);
      return userResponse;
    } catch (e) {
      //Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<CategoryResponse> getCategoriesApiRequest(
      String storeId) async {
    var url = ApiConstants.baseUrl.replaceAll("storeId", storeId) +
        ApiConstants.getCategories;
    var request = new http.MultipartRequest("GET", Uri.parse(url));

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    final parsed = json.decode(respStr);
    CategoryResponse categoryResponse = CategoryResponse.fromJson(parsed);
    try {
      DatabaseHelper databaseHelper = new DatabaseHelper();
      databaseHelper.getCount(DatabaseHelper.Categories_Table).then((count) {
        if (count == 0) {
          for (int i = 0; i < categoryResponse.categories.length; i++) {
            CategoryModel model = categoryResponse.categories[i];
            databaseHelper.saveCategories(model);
            if (model.subCategory != null) {
              for (int j = 0; j < model.subCategory.length; j++) {
                databaseHelper.saveSubCategories(
                    model.subCategory[j], model.id);
              }
            }
          }
        }
      });
    } catch (e) {
      print(e);
    }
    return categoryResponse;
  }

  static Future<SubCategoryResponse> getSubCategoryProducts(
      String subCategoryId) async {
    StoreModel store = await SharedPrefs.getStore();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString(AppConstant.deviceId);
    String deviceToken = prefs.getString(AppConstant.deviceToken);
    var url = ApiConstants.baseUrl.replaceAll("storeId", store.id) +
        ApiConstants.getProducts +
        subCategoryId;
    var request = new http.MultipartRequest("POST", Uri.parse(url));
    try {
      request.fields.addAll({
        "user_id": "",
        "device_id": deviceId,
        "device_token": deviceToken,
        "platform": Platform.isIOS ? "IOS" : "Android"
      });

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      final parsed = json.decode(respStr);
      SubCategoryResponse subCategoryResponse =
          SubCategoryResponse.fromJson(parsed);
      return subCategoryResponse;
    } catch (e) {
      Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<DeliveryAddressResponse> getAddressApiRequest() async {
    StoreModel store = await SharedPrefs.getStore();
    UserModel user = await SharedPrefs.getUser();

    var url = ApiConstants.baseUrl.replaceAll("storeId", store.id) +
        ApiConstants.getAddress;

    var request = new http.MultipartRequest("POST", Uri.parse(url));
    try {
      request.fields.addAll({
        "user_id": user.id,
        "method": "GET",
      });

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      print("----respStr---${respStr}");
      final parsed = json.decode(respStr);
      DeliveryAddressResponse deliveryAddressResponse =
      DeliveryAddressResponse.fromJson(parsed);
      //print("----respStr---${deliveryAddressResponse.success}");
      return deliveryAddressResponse;

    } catch (e) {
      print("----catch---${e.toString()}");
      //Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<StoreDeliveryAreasResponse> getDeliveryArea() async {
    StoreModel store = await SharedPrefs.getStore();
    var url = ApiConstants.baseUrl.replaceAll("storeId", store.id) +
        ApiConstants.getAddressArea;

    var request = new http.MultipartRequest("GET", Uri.parse(url));
    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final parsed = json.decode(respStr);
      StoreDeliveryAreasResponse storeArea =
          StoreDeliveryAreasResponse.fromJson(parsed);
      return storeArea;
    } catch (e) {
      Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<DeliveryAddressResponse> saveDeliveryAddressApiRequest(
      String method,
      String zipCode,
      String address,
      String areaId,
      String areaName,
      String addressId,
      String fullname) async {
    StoreModel store = await SharedPrefs.getStore();
    UserModel user = await SharedPrefs.getUser();

    var url = ApiConstants.baseUrl.replaceAll("storeId", store.id) +
        ApiConstants.getAddress;
    var request = new http.MultipartRequest("POST", Uri.parse(url));

    try {
      request.fields.addAll({
        "method": method,
        "user_id": user.id,
        "zipcode": zipCode,
        "country": "",
        "address": address,
        "city": "",
        "area_name": areaName,
        "mobile": user.phone,
        "state": "",
        "area_id": areaId,
        "first_name": fullname,
        //  "first_name": "abc",

        "email": user.email
      });

      if (addressId != null) {
        request.fields["address_id"] = addressId;
      }
      print(
          '@@saveDeliveryAddressApiRequest' + url + request.fields.toString());

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final parsed = json.decode(respStr);

      DeliveryAddressResponse res = DeliveryAddressResponse.fromJson(parsed);
      return res;
    } catch (e) {
      Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<DeliveryAddressResponse> deleteDeliveryAddressApiRequest(
      String addressId) async {
    StoreModel store = await SharedPrefs.getStore();
    UserModel user = await SharedPrefs.getUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString(AppConstant.deviceId);
    String deviceToken = prefs.getString(AppConstant.deviceToken);
    var url = ApiConstants.baseUrl.replaceAll("storeId", store.id) +
        ApiConstants.getAddress;
    var request = new http.MultipartRequest("POST", Uri.parse(url));

    try {
      request.fields.addAll({
        "method": "DELETE",
        "device_id": deviceId,
        "user_id": user.id,
        "address_id": addressId,
        "device_token": deviceToken,
        "platform": Platform.isIOS ? "IOS" : "Android"
      });

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final parsed = json.decode(respStr);

      DeliveryAddressResponse res = DeliveryAddressResponse.fromJson(parsed);
      return res;
    } catch (e) {
      Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<StoreOffersResponse> storeOffersApiRequest(
      String areaId) async {
    StoreModel store = await SharedPrefs.getStore();
    UserModel user = await SharedPrefs.getUser();

    var url = ApiConstants.baseUrl.replaceAll("storeId", store.id) +
        ApiConstants.storeOffers;
    var request = new http.MultipartRequest("POST", Uri.parse(url));

    try {
      request.fields.addAll({
        "store_id": store.id,
        "user_id": user.id,
        "order_facility": "Delivery"
      });

      if (areaId != null) {
        request.fields["area_id"] = areaId;
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final parsed = json.decode(respStr);

      StoreOffersResponse res = StoreOffersResponse.fromJson(parsed);
      return res;
    } catch (e) {
      Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<ValidateCouponResponse> validateOfferApiRequest(
      String couponCode, String paymentMode, String orderJson) async {
    StoreModel store = await SharedPrefs.getStore();
    UserModel user = await SharedPrefs.getUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString(AppConstant.deviceId);
    String deviceToken = prefs.getString(AppConstant.deviceToken);
    var url = ApiConstants.baseUrl.replaceAll("storeId", store.id) +
        ApiConstants.validateCoupon;
    var request = new http.MultipartRequest("POST", Uri.parse(url));

    try {
      request.fields.addAll({
        "coupon_code": couponCode,
        "device_id": deviceId,
        "user_id": user.id,
        "device_token": deviceToken,
        "orders": "$orderJson",
        "payment_method": paymentMode,
        "platform": Platform.isIOS ? "IOS" : "Android"
      });

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final parsed = json.decode(respStr);
      ValidateCouponResponse model = ValidateCouponResponse.fromJson(parsed);
      return model;
    } catch (e) {
      Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<TaxCalculationResponse> multipleTaxCalculationRequest(
      String couponCode,
      String discount,
      String shipping,
      String orderJson) async {
    StoreModel store = await SharedPrefs.getStore();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString(AppConstant.deviceId);

    var url = ApiConstants.baseUrl.replaceAll("storeId", store.id) +
        ApiConstants.multipleTaxCalculation;
    var request = new http.MultipartRequest("POST", Uri.parse(url));

    try {
      request.fields.addAll({
        "fixed_discount_amount": "0",
        "tax": "0",
        "discount": discount,
        "shipping": shipping,
        "order_detail": orderJson,
        "device_id": deviceId,
      });

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final parsed = json.decode(respStr);

      TaxCalculationResponse model =
          TaxCalculationResponse.fromJson(couponCode, parsed);
      return model;
    } catch (e) {
      Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<ResponseModel> placeOrderRequest(
      String note,
      String totalPrice,
      String paymentMethod,
      TaxCalculationModel taxModel,
      DeliveryAddressData address,
      String orderJson) async {
    StoreModel store = await SharedPrefs.getStore();
    UserModel user = await SharedPrefs.getUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString(AppConstant.deviceId);
    String deviceToken = prefs.getString(AppConstant.deviceToken);
    var url = ApiConstants.baseUrl.replaceAll("storeId", store.id) +
        ApiConstants.placeOrder;
    var request = new http.MultipartRequest("POST", Uri.parse(url));

    try {
      request.fields.addAll({
        "shipping_charges": "0",
        "note": note,
        "calculated_tax_detail": "",
        "coupon_code": taxModel == null ? "" : taxModel.couponCode,
        "device_id": deviceId,
        "user_address": address.address,
        "store_fixed_tax_detail": "",
        "tax": taxModel == null ? "0" : taxModel.tax,
        "store_tax_rate_detail": "",
        "platform": Platform.isIOS ? "IOS" : "Android",
        "tax_rate": "0",
        "total": taxModel == null ? totalPrice : taxModel.total,
        "user_id": user.id,
        "device_token": deviceToken,
        "user_address_id": address.id,
        "orders": orderJson,
        "checkout": totalPrice,
        "payment_method": paymentMethod == "2" ? "COD" : "Online Payment",
        "discount": taxModel == null ? "" : taxModel.discount,
      });

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final parsed = json.decode(respStr);

      ResponseModel model = ResponseModel.fromJson(parsed);
      return model;
    } catch (e) {
      Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<UserResponse> updateProfileRequest(
      String fullName, String emailId, String phoneNumber) async {
    StoreModel store = await SharedPrefs.getStore();
    UserModel user = await SharedPrefs.getUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString(AppConstant.deviceId);
    String deviceToken = prefs.getString(AppConstant.deviceToken);
    var url = ApiConstants.baseUrl.replaceAll("storeId", store.id) +
        ApiConstants.updateProfile;
    var request = new http.MultipartRequest("POST", Uri.parse(url));

    try {
      request.fields.addAll({
        "full_name": fullName,
        "email": emailId,
        "user_id": user.id,
        "device_id": deviceId,
        "device_token": deviceToken,
        "platform": Platform.isIOS ? "IOS" : "Android"
      });

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final parsed = json.decode(respStr);

      UserResponse model = UserResponse.fromJson(parsed);
      return model;
    } catch (e) {
      Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<ResponseModel> setStoreQuery(String queryString) async {
    StoreModel store = await SharedPrefs.getStore();
    UserModel user = await SharedPrefs.getUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString(AppConstant.deviceId);
    String deviceToken = prefs.getString(AppConstant.deviceToken);
    var url = ApiConstants.baseUrl.replaceAll("storeId", store.id) +
        ApiConstants.setStoreQuery;
    var request = new http.MultipartRequest("POST", Uri.parse(url));

    try {
      request.fields.addAll({
        "store_id": store.id,
        "device_id": deviceId,
        "device_token": deviceToken,
        "platform": Platform.isIOS ? "IOS" : "Android",
        "user_id": user.id,
        "query": queryString
      });

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final parsed = json.decode(respStr);

      ResponseModel resModel = ResponseModel.fromJson(parsed);
      return resModel;
    } catch (e) {
      Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<GetOrderHistory> getOrderHistory() async {
    StoreModel store = await SharedPrefs.getStore();
    UserModel user = await SharedPrefs.getUser();

    var url = ApiConstants.baseUrl.replaceAll("storeId", store.id) +
        ApiConstants.orderHistory;
    var request = new http.MultipartRequest("POST", Uri.parse(url));

    try {
      request.fields.addAll({
        "user_id": user.id,
      });

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final parsed = json.decode(respStr);

      GetOrderHistory getOrderHistory = GetOrderHistory.fromJson(parsed);
      return getOrderHistory;
    } catch (e) {
      Utils.showToast(e.toString(), true);
      return null;
    }
  }

  static Future<MobileVerified> mobileVerification(LoginMobile loginData ) async {
    StoreModel store = await SharedPrefs.getStore();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString(AppConstant.deviceId);
    String deviceToken = prefs.getString(AppConstant.deviceToken);
    var url = ApiConstants.baseUrl.replaceAll("storeId", store.id) +
        ApiConstants.mobileVerification;
    var request = new http.MultipartRequest("POST", Uri.parse(url));

    try {
      request.fields.addAll({
        "phone": loginData.phone,
        "device_id": deviceId,
        "device_token": deviceToken,
        "platform": Platform.isIOS ? "IOS" : "Android"
      });
      print('@@mobileVerification' + url + request.fields.toString());

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final parsed = json.decode(respStr);
      print('--response===  $parsed');
      MobileVerified userResponse = MobileVerified.fromJson(parsed);
      if (userResponse.success) {
        SharedPrefs.setUserLoggedIn(true);
        SharedPrefs.saveUserMobile(userResponse.user);
      }
      return userResponse;
    } catch (e) {
      //Utils.showToast(e.toString(), true);
      print('catch'+e.toString());
      return null;
    }
  }

  static Future<OtpVerified> otpVerified(OTPData otpData) async {
    UserModelMobile userMobile = await SharedPrefs.getUserMobile();
    StoreModel store = await SharedPrefs.getStore();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString(AppConstant.deviceId);
    String deviceToken = prefs.getString(AppConstant.deviceToken);
    var url = ApiConstants.baseUrl.replaceAll("storeId", store.id) +
        ApiConstants.otp;
    var request = new http.MultipartRequest("POST", Uri.parse(url));


    try {
      request.fields.addAll({
        "phone": userMobile.phone,
        "otp": otpData.otp,
        "device_id": deviceId,
        "device_token": deviceToken,
        "platform": Platform.isIOS ? "IOS" : "android"
      });
      print('@@url' + url);
      print('@@fields' +request.fields.toString());
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      print('response'+respStr);
      final parsed = json.decode(respStr);

      OtpVerified userResponse = OtpVerified.fromJson(parsed);
      if (userResponse.success) {
        SharedPrefs.setUserLoggedIn(true);
        SharedPrefs.saveUserOTP(userResponse);
      }
      return userResponse;
    } catch (e) {
      //Utils.showToast(e.toString(), true);
      print('catch'+e.toString());
      return null;
    }
  }



}
