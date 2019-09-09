import 'dart:io';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/Categories.dart';
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
    print("-------ProductList ---${subProductList.length}");

    DatabaseHelper databaseHelper = new DatabaseHelper();
    for(int i = 0; i < subProductList.length; i++){
      //print("-------Product-title ---${subProductList[i].title}");
      databaseHelper.checkProductsExist(DatabaseHelper.Products_Table, subProductList[i].categoryIds).then((count){
        print("------checkProductsExist-----${count}");
        if(count == 0){
          databaseHelper.saveProducts(subProductList[i],
              DatabaseHelper.Favorite, subProductList[i].variants[0].mrpPrice,
              subProductList[i].variants[0].price, subProductList[i].variants[0].discount
              , subProductList[i].variants[0].id);
        }
      });
    }

    return subProductList;
  }



}