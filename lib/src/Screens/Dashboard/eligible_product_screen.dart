import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/EligibleProductResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/Utils.dart';

class EligibleProductScreen extends StatefulWidget {
  final String offerId;

  EligibleProductScreen({this.offerId = '81'});

  @override
  State<StatefulWidget> createState() {
    return _EligibleProductState();
  }
}

class _EligibleProductState extends State<EligibleProductScreen> {
  Map<String, List<Data>> productMap = {};

  bool isLoading = true;

  @override
  initState() {
    super.initState();
    getProductDetail(widget.offerId);
  }

  void getProductDetail(String offerId) async {
    ApiController.getEligibleProductDetail(offerId).then((value) {
      for (Data data in value.data) {
        List<Data> list = [];
        if (productMap.containsKey(data.parentCategory)) {
          list.addAll(productMap[data.parentCategory]);
        }
        list.add(data);
        if (!productMap.containsKey(data.parentCategory))
          productMap.putIfAbsent(data.parentCategory, () => list);
        else
          productMap[data.parentCategory] = list;
      }

      setState(() {
        isLoading  = false;
      });
    });
  }

  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            getCouponView(),
          ],
        ),
      ),
    );
  }

// add Product Details top view 

  Widget getCouponView() {
    return isLoading ? Container(
      height: 300,
        child: Utils.showSpinner()
    ) : Container(
      margin: EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0, right: 10),
      width: Utils.getDeviceWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text("Eligible Products",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: productMap.length,
            itemBuilder: (context, index) {
              String key = productMap.keys.elementAt(index);
              return productDetails(key);
            },
          ),
        ],
      ),
    );
  }

  Widget productDetails(String key) {
    List<Data> list = productMap[key];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(key, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(
          height: 10,
        ),

        ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("• ", style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(list[index].title),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 16),
                ],
              ),
            );
          },
          itemCount: list.length,
          separatorBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Colors.grey,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget addDividerView() {
    return Container(
      height: 1,
      width: MediaQuery.of(context).size.width,
      color: grayColor,
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0, left: 20, right: 20),
    );
  }
}
