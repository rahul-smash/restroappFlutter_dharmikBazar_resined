import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatSupport extends StatelessWidget{

  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        //print("onWillPop onWillPop");
        return Future(()=>true);
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
            initialUrl: 'https://valueappz.com/',
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
//              if (url.contains("/api/paytmPaymentResult/orderId:") &&
//                  !isPaytmPaymentSuccessed) {
//                isPaytmPaymentSuccessed = true;
//                String txnId =
//                url.substring(url.indexOf("/TxnId:") + "/TxnId:".length);
//                url = url.replaceAll("/TxnId:" + txnId, "");
//                String orderId = url
//                    .substring(url.indexOf("/orderId:") + "/orderId:".length);
//                print(txnId);
//                print(orderId);
//                eventBus.fire(
//                    onPayTMPageFinished(url, orderId = orderId, txnId = txnId));
//                Navigator.pop(context);
//              } else if (url.contains("api/paytmPaymentResult/failure:")) {
//                Navigator.pop(context);
//                Utils.showToast("Payment Failed", false);
//              }
            },
            gestureNavigationEnabled: false,
          );
        }),
      ),
    );
  }

}