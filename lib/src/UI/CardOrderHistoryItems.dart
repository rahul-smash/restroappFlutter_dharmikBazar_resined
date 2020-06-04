import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/GetOrderHistory.dart';
import 'package:restroapp/src/Screens/Offers/OrderDetailScreen.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/Utils.dart';
class CardOrderHistoryItems extends StatefulWidget {

  final OrderData orderHistoryData;
  CardOrderHistoryItems(this.orderHistoryData);

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

  CardOrderHistoryState(this.cardOrderHistoryItems);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          firstRow(),
          deviderLine(),
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
          visible: showCancelButton(cardOrderHistoryItems.status),
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, right: 12.0),
            child: SizedBox(
              width: 70,
              height: 30,
              child: FlatButton(
                onPressed: () async {
                  Utils.showProgressDialog(context);
                  await ApiController.orderCancelApi(cardOrderHistoryItems.orderId);
                  Utils.hideProgressDialog(context);
                  eventBus.fire(refreshOrderHistory());
                },

                child: Text("Cancel",
                  style: TextStyle(color: Color(0xFF525A5F), fontSize: 11,),),
                color: Color(0xFFEAEEEF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  secondRow() {
    return  Padding(
      padding: EdgeInsets.only(bottom: 15,top: 10),
      child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 12.0,top: 5.0,right: 10.0),
                  child: Row(
                    children: <Widget>[
                      Text('Total Price : ',style: TextStyle(color: Color(0xFF39444D),fontSize: 14)),
                      Text("${AppConstant.currency} ${cardOrderHistoryItems.total}",style: TextStyle(color: Colors.black,fontSize: 13))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0,top: 4.0,right: 10.0),
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

                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text(getStatus(cardOrderHistoryItems.status),style: TextStyle(color: Color(0xFF39444D),fontSize: 14)),
                      )
                    ],
                  ),
                ),

              ],
            ),

            Padding(
              padding: EdgeInsets.only(right: 12.0,top: 15),
              child:  SizedBox(
                width: 90,
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
                  child: Text("View Order",style: TextStyle(color: Colors.white,fontSize: 11),),
                  color: Color(0xFFFD5401),
                  shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
              ),
            ),
          ]
      ),
    );
  }

  bottomDeviderView() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 10,
      color: Color(0xFFDBDCDD),
    );
  }

  deviderLine() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, top: 5.0, right: 10.0, bottom: 0),
      child: Divider(
        color: Color(0xFFDBDCDD),
        height: 1,
        thickness: 1,
        indent: 0,
        endIndent: MediaQuery
            .of(context)
            .size
            .width / 2 + 20,
      ),
    );
  }


  String getStatus(status) {
    if (status == "0") {

      return 'Pending';

    } else if (status == "1") {

      return 'Order';

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
    if(status == "1" || status == "4" || status == "0"){
      showCancelButton = true;
    }else{
      showCancelButton = false;
    }
    return showCancelButton;
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

