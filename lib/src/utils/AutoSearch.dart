import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:restroapp/src/utils/AppColor.dart';

const kGoogleApiKey = "AIzaSyCJFo82HR55bnLYFb2GUA8-d-E-o8uBpos";
// to get places detail (lat/lng) AIzaSyD-8uwiLIZNzkxEu0rNDA8cLOpsM3qRpWc
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

// custom scaffold that handle search
// basically your widget need to extends [GooglePlacesAutocompleteWidget]
// and your state [GooglePlacesAutocompleteState]
class CustomSearchScaffold extends PlacesAutocompleteWidget {
  CustomSearchScaffold()
      : super(
            apiKey: kGoogleApiKey,
            types: [],
            strictbounds: false,
            components: []);

  @override
  CustomSearchScaffoldState createState() => CustomSearchScaffoldState();
}

class CustomSearchScaffoldState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: AppBarPlacesAutoCompleteTextField());

    final body = PlacesAutocompleteResult(
      onTap: (prediction) {
        print("onTap = ${prediction}");
        displayPrediction(prediction);
      },
      logo: Row(
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );

    return AnnotatedRegion(
    value: SystemUiOverlayStyle.light.copyWith(
      statusBarColor: whiteColor,
      statusBarIconBrightness: Brightness.dark
    ),
       child: SafeArea(
        child: Scaffold(
          backgroundColor: whiteColor,
//        appBar: appBar,
            body: Container(
                padding: EdgeInsets.only(top: 16, left: 5, right: 5, bottom: 16),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
                          child: Icon(
                            Icons.cancel,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                      child: Text(
                        'Search',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 0),
                        //padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: searchGrayColor,
                            borderRadius: BorderRadius.all(Radius.circular(7.0)),
                            border: Border.all(
                              color: searchGrayColor,
                            )),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Center(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(3, 3, 10, 3),
                                      child: Image.asset('images/searchicon.png',
                                          width: 20,
                                          fit: BoxFit.scaleDown,
                                          color: Colors.grey)),
                                  Expanded(
                                    child: AppBarPlacesAutoCompleteTextField(
                                      textDecoration: _defaultDecoration('Search'),
                                    ),
                                  )
                                ]),
                          ),
                        )),
                    Expanded(child: body)
                  ],
                ))),
      ),
    );
  }

  InputDecoration _defaultDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: false,
      fillColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white30
          : Colors.black38,
      hintStyle: TextStyle(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black38
            : Colors.white30,
        fontSize: 16.0,
      ),
      border: InputBorder.none,
    );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;
      print("location = ${lat},${lng}");
      //var address = await Geocoder.local.findAddressesFromQuery(p.description);
//      Navigator.pop(context, detail);
      Navigator.pop(context, LatLng(lat, lng));
    }
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    print("onResponseError=${response.errorMessage}");
    /*searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );*/
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response != null && response.predictions.isNotEmpty) {
      print("response=${response.predictions}");
      /*searchScaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Got answer")),
      );*/
    }
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}

