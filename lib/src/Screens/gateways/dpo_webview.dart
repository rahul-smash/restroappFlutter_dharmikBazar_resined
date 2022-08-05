import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restroapp/src/models/DPOCreateResponse.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../models/StoreResponseModel.dart';
import '../../utils/Callbacks.dart';
import '../../utils/Utils.dart';

class DPOWedview extends StatelessWidget {
  DpoCreateResponse dpoCreateModel;
  StoreModel storeModel;
  String amount;
  Completer<WebViewController> _controller = Completer<WebViewController>();

  bool isPaytmPaymentSuccessed = false;

  DPOWedview(this.dpoCreateModel, this.storeModel, {this.amount = ''});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(()=>false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false, // Used for removing back buttoon.
          title: Text('Payment'),
          centerTitle: true,
        ),
        body: Builder(builder: (BuildContext context) {
          return WebView(
            initialUrl: '${dpoCreateModel.data}',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            navigationDelegate: (NavigationRequest request) {
              //print('=======NavigationRequest======= $request}');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              //print('======Page started loading======: $url');
            },
            onPageFinished: (String url) {
              print('==2====onLoadStop======: $url');

              // https://stage.grocersapp.com/393/dpo/dpoFinalRes?dpo_status=CAPTURED&charge_id=F9EA66E7-CA8D-496C-A53D-105E7160AA29
              if (url.contains("dpo_status=CAPTURED") &&
                  !isPaytmPaymentSuccessed) {
                isPaytmPaymentSuccessed = true;
                String chargeID =
                url.substring(url.indexOf("charge_id=") + "charge_id=".length);
                url = url.replaceAll("/TxnId:" + chargeID, "");
                String orderId = url
                    .substring(url.indexOf("/orderId:") + "/orderId:".length);
                print(chargeID);
                eventBus.fire(onDPOCreateFinished(
                    url, chargeID = chargeID,
                    amount: amount));
                Navigator.pop(context);
              } else if (url.toLowerCase().contains("failed")) {
                Navigator.pop(context);
                Utils.showToast("Payment Failed", false);
              }
            },
            gestureNavigationEnabled: false,
          );
        }),
      ),
    );
  }
}