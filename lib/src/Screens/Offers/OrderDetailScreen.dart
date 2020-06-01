import 'package:flutter/material.dart';
import 'package:restroapp/src/models/GetOrderHistory.dart';
import 'package:restroapp/src/utils/AppConstants.dart';

class OrderDetailScreen extends StatelessWidget {

  final OrderData orderHistoryData;

  OrderDetailScreen(this.orderHistoryData);
  var screenWidth;
  var mainContext;

  @override
  Widget build(BuildContext context) {
    screenWidth =  MediaQuery.of(context).size.width;
    mainContext =  context;

    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: new Text('My Orders'),
        centerTitle: true,
      ),
      body:  SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: projectWidget()
              ),
            ],
          ),
      ),
      bottomNavigationBar: Container(
        height: 40,
        color: Color(0xFF74990A),
        child: InkWell(
          onTap: (){
            bottomSheet(mainContext);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15.0,top: 0.0,),
                      child : Text("View Details",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w600),),
                    ),
                    SizedBox(
                        width: 6
                    ),
                    Image.asset("images/topArrow.png",width: 15,height: 15,),
                  ]
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.0,),
                child : Text(" ${AppConstant.currency} ${orderHistoryData.total}",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w700),textAlign: TextAlign.right,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  projectWidget(){
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: orderHistoryData.orderItems.length,
      itemBuilder: (BuildContext ctx, int index){
        final item = orderHistoryData.orderItems[index];
        return Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              firstRow(item) ,
              secondRow(item),
              deviderLine(),
            ],
          ),
        );
      },
    );
  }

  firstRow(OrderItems item){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        LimitedBox(
          maxWidth: screenWidth-100,
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 12.0,top: 20.0,right: 10.0),
                child: Row(
                  children: <Widget>[
                    Text('Product Name : ',style: TextStyle(color: Color(0xFF7D8185),fontSize: 17)),
                    Flexible(
                        child: Text("${item.productName}",style: TextStyle(color: Color(0xFF15282F),fontSize: 16,fontWeight: FontWeight.w500)),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.0,top: 5.0,right: 10.0),
                child: Row(
                  children: <Widget>[
                    Text('Price : ',style: TextStyle(color: Color(0xFF7D8185),fontSize: 17)),
                    Padding(
                      padding: EdgeInsets.only(left: 70.0),
                      child: Text("${AppConstant.currency} ${item.price}",style: TextStyle(color: Color(0xFF15282F),fontSize: 16,fontWeight: FontWeight.w500)),
                    )

                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0,right: 12.0),
          child:  SizedBox(
            width: 80,
            height: 35,
            child: FlatButton(onPressed: (){
            },
              child: Text("${item.quantity} kg",style: TextStyle(color: Color(0xFF15282F),fontSize: 13,),),
              color: Color(0xFFEAEEEF),
              shape:  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
        )
      ],
    );
  }

  secondRow(OrderItems item){
    return  Padding(
        padding: EdgeInsets.only(bottom: 15,top: 20),
        child:  Padding(
          padding: EdgeInsets.only(left: 12.0,top: 5.0,right: 10.0),
          child: Row(
            children: <Widget>[
              Text('Status : ',style: TextStyle(color: Color(0xFF7D8185),fontSize: 17)),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      color: getStatusColor(item.status)
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(getStatus(item.status),style: TextStyle(color: Color(0xFF15282F),fontSize: 16,fontWeight: FontWeight.w500)),
              )
            ],
          ),
        )
    );

  }

  bottomSheet(context){
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        builder: (BuildContext bc){
          return Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Wrap(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth-40 ,top: 5,bottom: 10),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(mainContext);
                      },
                      child: Image.asset('images/close.png'),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Item Price : ',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600)),
                        Text("${AppConstant.currency} ${orderHistoryData.total}",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child:  sheetDeviderLine(),
                  ),
                  Visibility(
                    visible: orderHistoryData.discount == "0.00" ? false :true ,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child:   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Discount : ',style: TextStyle(color: Color(0xFF737879),fontSize: 18)),
                          Text("${AppConstant.currency} ${orderHistoryData.discount}",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: orderHistoryData.shippingCharges == "0.00" ? false :true ,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Delivery Fee: ',style: TextStyle(color: Color(0xFF737879),fontSize: 18)),
                          Text("${AppConstant.currency} ${orderHistoryData.shippingCharges}",style: TextStyle(color: Color(0xFF749A00),fontSize: 18,fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child:  bottomDeviderView(),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child: Text('Delivery Address',
                        style: TextStyle(color: Colors.black,fontSize: 16)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 20),
                    child: Text('${orderHistoryData.address}',
                        style: TextStyle(color: Color(0xFF737879),fontSize: 16)),
                  ),
                  Container(
                    height: 40,
                    color: Color(0xFF74990A),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 15.0,top: 0.0,),
                                child : Text("View Details",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w600),),
                              ),
                              SizedBox(
                                  width: 6
                              ),
                              Image.asset("images/topArrow.png",width: 15,height: 15,),
                            ]
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10.0,),
                          child : Text(" ${AppConstant.currency} ${orderHistoryData.total}",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w700),textAlign: TextAlign.right,),
                        ),
                      ],
                    ),
                  ),
                ]
            ),
          );
        }
    );
  }

  bottomDeviderView() {
    return Container(
      width: MediaQuery.of(mainContext).size.width,
      height: 10,
      color: Color(0xFFDBDCDD),
    );
  }

  deviderLine(){
    return  Divider(
      color: Color(0xFFDBDCDD),
      height: 1,
      thickness: 1,
      indent: 12,
      endIndent: 12,
    );
  }

  sheetDeviderLine(){
    return  Divider(
      color: Color(0xFFDBDCDD),
      height: 1,
      thickness: 1,
      indent: 0,
      endIndent: 0,
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
      return 'Canceled';

    }else {
      return "Waiting";
    }
  }

  Color getStatusColor(status){
    return status == "0" ? Color(0xFFA1BF4C) : status == "1" ? Color(0xFFA0C057) : Color(0xFFCF0000);
  }


}
