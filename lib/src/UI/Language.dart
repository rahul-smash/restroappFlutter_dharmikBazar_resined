import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/utils/AppConstants.dart';

class Language{

  Language();

  static Map<String, String> localizedValues;
  Future<void> changeLanguage() async {

    String selectedLangauge = await SharedPrefs.getStoreSharedValue(AppConstant.SelectedLanguage);

    String jsonResult =  await loadAsset(selectedLangauge);
    Map<String, dynamic> mappedJson = json.decode(jsonResult);

    //print(mappedJson);

    localizedValues = mappedJson.map((key, value) {
      return MapEntry(key, value.toString());
    });

    //print("localizedValues = ${localizedValues['EMAIL']}");

  }

  String getTranslated(String key) {
    return localizedValues[key];
  }

  Future<String> loadAsset(String selectedLangauge) async {
    //print("\nselectedLangauge = ${selectedLangauge}");
    if(selectedLangauge != null && selectedLangauge == AppConstant.Malay){
      AppConstant.isEnglishSelected = false;
      return await rootBundle.loadString('assets/de.json');
    }else{
      AppConstant.isEnglishSelected = true;
      return await rootBundle.loadString('assets/en.json');
    }
  }

}