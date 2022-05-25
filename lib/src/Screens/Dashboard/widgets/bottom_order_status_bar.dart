import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:dots_indicator/dots_indicator.dart';

import '../../../apihandler/ApiController.dart';

class BottomOrderStatusBar extends StatefulWidget {
  BottomOrderStatusBar({Key key}) : super(key: key);

  @override
  _BottomOrderStatusBarState createState() {
    return _BottomOrderStatusBarState();
  }
}

class _BottomOrderStatusBarState extends State<BottomOrderStatusBar> {

  List<int> list = [1, 2, 3, 4, 5];
  double currentIndexPage;

  @override
  void initState() {
    super.initState();
    currentIndexPage = 0;
    getOrdersDataFromApi();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
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
                      autoPlay: true,
                      onPageChanged: (int index, CarouselPageChangedReason reason){
                        print("index=${index} reason=${reason}");
                        setState(() {
                          currentIndexPage = index.toDouble();
                        });
                      },
                      viewportFraction: 1.0,
                    ),
                    items: list.map((item) {
                      return buildOrderStatusBar();
                    }).toList(),
                  )
              ),
            ],
          ),
          Align(
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
    );
  }

  Widget buildOrderStatusBar(){
    return Container(
      width: Utils.getDeviceWidth(context),
      child: Row(
        children: [
          Container(
            child: Image.asset('images/about_image.png',width: 30,height: 30,),
            margin: EdgeInsets.only(left: 25),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order id- #12422",style: TextStyle(fontSize: 13,color: Color(0xFF878A8D)),),
                Text("• Active",style: TextStyle(fontSize: 17,color: Color(0xFF41474E),
                    fontWeight: FontWeight.w600),),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            child: Text("VIEW DETAIL",style: TextStyle(fontSize: 16,
                fontWeight: FontWeight.w600,color: appTheme),),
          ),
          Container(
              margin: EdgeInsets.only(right: 20),
            child: Icon(Icons.arrow_right_alt,color: Color(0xFF41474E))
          ),
        ],
      ),
    );
  }

  void getOrdersDataFromApi() {
    ApiController.getHomeScreenOrderApiRequest().then((value){

    });
  }


}

