import 'dart:io';
import 'package:restroapp/src/models/Categories.dart';
import 'package:restroapp/src/models/StoreData.dart';
import 'package:restroapp/src/models/store_list.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
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

    return categories.data;
  }

  static Future<String> getSubCategoryProducts(String storeId,String catId ,String deviceId) async {
    String versionApi = 'https://app.restroapp.com/${storeId}/api_v5/getSubCategoryProducts/${catId}';
    print('$versionApi , $storeId');

    FormData formData = new FormData.from(
        {"device_id": deviceId, "device_token":"", "user_id":"", "platform":"android"});
    Dio dio = new Dio();
    Response response = await dio.post(versionApi, data: formData,
        options: new Options(
            contentType: ContentType.parse("application/json")));
    print(response.data);
    //StoreData storeData = StoreData.fromJson(response.data);
    //print("-------store.success ---${storeData.success}");
    return "";
  }



}