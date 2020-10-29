import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/CancelOrderModel.dart';
import 'package:restroapp/src/models/GetOrderHistory.dart';
import 'package:restroapp/src/Screens/Offers/OrderDetailScreen.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';
class CardOrderHistoryItems extends StatefulWidget {

  final OrderData orderHistoryData;
  StoreModel store;
  CardOrderHistoryItems(this.orderHistoryData, this.store);

  @override
  State<StatefulWidget> createState() {
    return CardOrderHistoryState(orderHistoryData);
  }
}

class CardOrderHistoryState extends State<CardOrderHistoryItems> {
  OrderData cardOrderHistoryItems;
  String renderUrl;
  String status = "";
  OrderItems orderItems;
  bool showOrderType;

  CardOrderHistoryState(this.cardOrderHistoryItems);

  @override
  void initState() {
    super.initState();
    if(widget.store.pickupFacility == "1" && widget.store.deliveryFacility == "1"){
      showOrderType = true;
    }else{
      showOrderType = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            color: Color(0xFFEBECEE),
            padding: EdgeInsets.only(left: 12.0, top: 8.0, right: 10.0,bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text("Total Items - ${cardOrderHistoryItems.orderItems.length}"),
                ),

                Container(
                  child: Visibility(
                    visible: showCancelButton(cardOrderHistoryItems.status),
                    child: InkWell(
                      onTap: () async {
                        var results = await DialogUtils.displayDialog(context,"Cancel Order?",AppConstant.cancelOrder,
                            "Cancel","OK");
                        if(results == true){
                          Utils.showProgressDialog(context);
                          CancelOrderModel cancelOrder = await ApiController.orderCancelApi(cardOrderHistoryItems.orderId);
                          try {
                            Utils.showToast("${cancelOrder.data}", false);
                          } catch (e) {
                            print(e);
                          }
                          Utils.hideProgressDialog(context);
                          eventBus.fire(refreshOrderHistory());
                        }
                      },
                      child: Text("Cancel"),
                    ),
                  ),
                )
              ],
            ),
          ),
          firstRow(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 1,
                margin: EdgeInsets.fromLTRB(12, 5, 5, 15),
                color: Color(0xFFDBDCDD),
              ),
            ],
          ),
          secondRow(),
          bottomDeviderView()
        ],
      ),
    );
  }


  firstRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 12.0, top: 15.0, right: 10.0),
              child: Row(
                children: <Widget>[
                  Text('Order Number : ',
                      style: TextStyle(color: Color(0xFF39444D), fontSize: 14)),
                  Text(cardOrderHistoryItems.displayOrderId,
                      style: TextStyle(color: Color(0xFF858B8F), fontSize: 13))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.0, top: 4.0, right: 10.0),
              child: Text(Utils.convertOrderDateTime(cardOrderHistoryItems.orderDate),
                  style: TextStyle(color: Color(0xFF858B8F), fontSize: 13)),
            ),
          ],
        ),
        Visibility(
          visible: showOrderType,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 5, 12, 0),
            padding: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0)),
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5.0,right: 5),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: getOrderTypeColor(cardOrderHistoryItems.orderFacility)
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.0,right: 5),
                  child: Text('${cardOrderHistoryItems.orderFacility}',
                      style: TextStyle(color: Color(0xFF39444D),fontSize: 14)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  secondRow() {
    return  Padding(
      padding: EdgeInsets.only(bottom: 10,top: 0),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 12.0,top: 0.0,right: 10.0),
            child: Row(
              children: <Widget>[
                Text('Total Price : ',style: TextStyle(color: Color(0xFF39444D),fontSize: 14)),
                Text("${AppConstant.currency} ${cardOrderHistoryItems.total}",
                    style: TextStyle(color: Colors.black,fontSize: 14,
                        fontWeight: FontWeight.w600))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0,top: 0.0,right: 10.0),
            child: Row(
              children: <Widget>[
                Text('Status : ',style: TextStyle(color: Color(0xFF39444D),fontSize: 14)),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: getStatusColor(cardOrderHistoryItems.status)
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text(getStatus(cardOrderHistoryItems.status),
                        style: TextStyle(color: Color(0xFF39444D),fontSize: 14,
                        fontWeight: FontWeight.w600)),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(right: 0.0,top: 0),
                  child:  SizedBox(
                    width: 110,
                    height: 30,
                    child: FlatButton(
                      onPressed: (){
                        print("OrderDetailScreen");
                        Navigator.push( context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailScreen(cardOrderHistoryItems),
                          ),
                        );
                      },
                      child: Text("View Order",style: TextStyle(color: Colors.white),),
                      color: Color(0xFFFD5401),
                      shape:  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  bottomDeviderView() {
    return Container(
      width: MediaQuery .of(context).size.width,
      height: 8,
      color: Color(0xFFDBDCDD),
    );
  }

  deviderLine() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, top: 8.0, right: 10.0, bottom: 0),
      child: Divider(
        color: Color(0xFFDBDCDD),
        height: 1,
        thickness: 1,
        indent: 0,
        endIndent: MediaQuery.of(context).size.width / 2 + 20,
      ),
    );
  }

// 0 => 'pending' ,  1 =>'processing', 2 =>'rejected',
  // 4 =>'shipped', 5 =>'delivered', 6 => 'cancel'
  String getStatus(status) {
    if (status == "0") {
      return 'Pending';

    } else if (status == "1") {
      return 'Processing';

    }if (status == "2") {
      return 'Rejected';

    }if (status == "4") {
      return 'Shipped';

    }if (status == "5") {
      return 'Delivered';

    } if (status == "6") {
      return 'Cancelled';

    }else {
      return "Waiting";
    }
  }

  bool showCancelButton(status) {
    bool showCancelButton;
    // 0 => 'pending' ,  1 =>'processing', 2 =>'rejected',
// 4 =>'shipped', 5 =>'delivered', 6 => 'cancel'
    //Remove cancel button on processing status
    if(/*status == "1" || status == "4" ||*/ status == "0"){
      showCancelButton = true;
    }else{
      showCancelButton = false;
    }
    return showCancelButton;
  }

  Color getOrderTypeColor(status){
    if (status == "Pickup") {
      return appThemeSecondary;
    } else {
      return Color(0xFFA0C057) ;
    }
  }

   Color getStatusColor(status){
     // 0 => 'pending' ,  1 =>'processing', 2 =>'rejected',
     // 4 =>'shipped', 5 =>'delivered', 6 => 'cancel'
     // status 1, 4, 0     =>show cancel btn
     if (status == "0") {
       return Color(0xFFA1BF4C);
     } else {
       return status == "1" ? Color(0xFFA0C057) : Color(0xFFCF0000);
     }
   }



}

