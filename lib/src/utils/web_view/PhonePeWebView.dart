import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiConstants.dart';
import 'package:restroapp/src/models/PhonePeResponse.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PhonePeWebView extends StatelessWidget {
  PhonePeResponse responseModel;
  Completer<WebViewController> _controller = Completer<WebViewController>();
  String storeID;
  bool isUrlLoadFinished = false;
  String amount;

  PhonePeWebView(this.responseModel, this.storeID, {this.amount = ''});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        //print("onWillPop onWillPop");
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),
          automaticallyImplyLeading: false, // Used for removing back buttoon.
          title: Text('Payment'),
          centerTitle: true,
        ),
        body: Builder(builder: (BuildContext context) {
          return WebView(
            initialUrl: '${responseModel.data.data.redirectUrl}',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            navigationDelegate: (NavigationRequest request) {
              //print('=======NavigationRequest======= $request}');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('======Page started loading======: $url');
            },
            onPageFinished: (String url) {
              print('==2====onLoadStop======: $url');
              //https://devmarketplace.restroapp.com/2/v1/5/phonepe/phonepeResUrl?payment_request_id=TXN_phonepe_456911632473278&TransId=T2109241419501796650551&Status=PAYMENT_SUCCESS

              if (url.contains("Status=PAYMENT_SUCCESS")) {
                if (!isUrlLoadFinished) {
                  isUrlLoadFinished = true;
                  String status = url
                      .substring(url.indexOf("&Status=") + "&Status=".length);
                  url = url.replaceAll("&Status=" + status, "");

                  String transId = url
                      .substring(url.indexOf("&TransId=") + "&TransId=".length);
                  url = url.replaceAll("&TransId=" + transId, "");

                  String payment_request_id = url.substring(
                      url.indexOf("?payment_request_id=") +
                          "?payment_request_id=".length);

                  eventBus.fire(onPhonePeFinished(payment_request_id, transId,amount:amount));
                  Navigator.pop(context);
                }
              } else if (url.toLowerCase().contains("failure") ||
                  url.toLowerCase().contains("error")) {
                Utils.showToast("Payment Failed", false);
                Navigator.pop(context,false);
              }
            },
            gestureNavigationEnabled: false,
          );
        }),
      ),
    );
  }
}
