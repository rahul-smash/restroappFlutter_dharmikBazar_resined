import 'package:restroapp/src/models/store_list.dart';

class StoreListData {

  bool success;
  List<StoreListModel> data;

  StoreListData({this.success, this.data});

  factory StoreListData.fromJson(Map<String, dynamic> parsedJson){

    return StoreListData(
        success: parsedJson['success'],
        data: parsedJson['data'],
    );
  }
}
