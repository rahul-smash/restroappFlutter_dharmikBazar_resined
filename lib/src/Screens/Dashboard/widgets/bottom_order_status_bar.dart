import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:dots_indicator/dots_indicator.dart';
import '../../../apihandler/ApiController.dart';
import '../../../database/SharedPrefs.dart';
import '../../../models/StoreResponseModel.dart';
import '../../../models/home_screen_orders_model.dart';
import '../../../singleton/app_version_singleton.dart';
import '../../../utils/AppConstants.dart';
import '../../Offers/OrderDetailScreenVersion2.dart';

class BottomOrderStatusBar extends StatefulWidget {

  final Function(bool showBottomBar) callback;
  BottomOrderStatusBar({this.callback});

  @override
  _BottomOrderStatusBarState createState() {
    return _BottomOrderStatusBarState();
  }
}

class _BottomOrderStatusBarState extends State<BottomOrderStatusBar> {

  List<HomeOrderData> list = [];
  double currentIndexPage;
  Timer _timer;
  HomeScreenOrdersModel homeScreenOrdersModel;

  @override
  void initState() {
    super.initState();
    currentIndexPage = 0;
    widget.callback(false);
    Utils.isNetworkAvailable().then((isNetworkAvailable){
      if (!isNetworkAvailable) {
        Utils.showToast(AppConstant.noInternet, false);
        return;
      }else{
        getOrdersDataFromApi();
        _checkLoginState();
      }
    });

  }

  @override
  void dispose() {
    super.dispose();
    if(_timer != null){
      _timer.cancel();
    }
  }

  void _checkLoginState() {
    print('--show_order_on_home_screen-=${AppVersionSingleton.instance.appVersion.store.show_order_on_home_screen}');
    int interval = 5;
    var duration = Duration(seconds: interval);
    _timer = new Timer.periodic(
      duration, (Timer timer) {
      if (AppConstant.isLoggedIn) {
        //print('------Timer.periodic------');
        Utils.isNetworkAvailable().then((isNetworkAvailable){
          if (isNetworkAvailable) {
            getOrdersDataFromApi();
          }
        });
      }
    },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Visibility(
      visible: AppConstant.isLoggedIn ?  true : false,
      child: list.isEmpty ? Container(height: 0,width: 0,) : Container(
        height: 60,
        color: Color(0xFFebebeb),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 2,
                  padding: EdgeInsets.only(top: 5),
                  color: Color(0xFFd1d1d1),
                ),
                Container(
                    height: 58,
                    width: Utils.getDeviceWidth(context),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: list.length == 1 ? false : true,
                        onPageChanged: (int index, CarouselPageChangedReason reason){
                          print("index=${index} reason=${reason}");
                          setState(() {
                            currentIndexPage = index.toDouble();
                          });
                        },
                        viewportFraction: 1.0,
                      ),
                      items: list.map((item) {
                        return buildOrderStatusBar(item);
                      }).toList(),
                    )
                ),
              ],
            ),
            list.length == 1 ? Container() : Align(
              alignment: Alignment.bottomCenter,
              child: DotsIndicator(
                dotsCount: list.length,
                position: currentIndexPage,
                decorator: DotsDecorator(
                  size: const Size.square(4.0),
                  activeSize: const Size.square(5.0),
                  color: Color(0xFF878A8D), // Inactive color
                  activeColor: Color(0xFF41474E),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildOrderStatusBar(HomeOrderData homeOrderData){
    return Container(
      width: Utils.getDeviceWidth(context),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white),
            child: Image.asset('images/order_icon.png',width: 30,height: 30,),
            margin: EdgeInsets.only(left: 25),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order id- ${homeOrderData.displayOrderId}",style: TextStyle(fontSize: 13,color: Color(0xFF878A8D)),),
                Text("• ${homeOrderData.status}",style: TextStyle(fontSize: 17,color: Color(0xFF41474E),
                    fontWeight: FontWeight.w600),),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          InkWell(
            onTap: (){
              openOrderDetail(homeOrderData.id);
            },
            child: Container(
              child: Text("VIEW DETAIL",style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.w600,color: appTheme),),
            ),
          ),
          InkWell(
            onTap: (){
              openOrderDetail(homeOrderData.id);
            },
            child: Container(
              margin: EdgeInsets.only(right: 20,left: 5),
              //child: Icon(Icons.arrow_right_alt,color: Color(0xFF41474E))
              child: Image.asset('images/viewmore_arrow.png',width: 22,height: 18,),
            ),
          )

        ],
      ),
    );
  }

  void getOrdersDataFromApi() {
    if(AppVersionSingleton.instance.appVersion.store.show_order_on_home_screen == '1'){
      ApiController.getHomeScreenOrderApiRequest().then((value){
        if(value != null){
          setState(() {
            this.homeScreenOrdersModel = value;
            if(value.success){
              this.list = homeScreenOrdersModel.data;
            }
            if(!value.success){
              list.clear();
              widget.callback(false);
            }
          });
        }else{
          widget.callback(false);
        }
      });
    }
  }


  Future<void> openOrderDetail(String orderID) async {
    StoreModel store = await SharedPrefs.getStore();
    bool isRatingEnable = store.reviewRatingDisplay != null &&
        store.reviewRatingDisplay.compareTo('1') == 0;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OrderDetailScreenVersion2(
            isRatingEnable,
            store,
            orderId: orderID,
          )),
    );
  }

}

