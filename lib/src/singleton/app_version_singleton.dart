
import '../models/StoreResponseModel.dart';

class AppVersionSingleton{

  static AppVersionSingleton _instance;
  StoreResponse appVersion;

  AppVersionSingleton._();

  static AppVersionSingleton get instance {
    return _instance ??= AppVersionSingleton._();
  }

}