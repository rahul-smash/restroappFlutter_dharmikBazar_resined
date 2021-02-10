import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_pull_to_refresh/flutter_pull_to_refresh.dart';
import 'package:intl/intl.dart';
import 'package:restroapp/src/UI/SubscriptionHistoryDetails.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/DeliveryTimeSlotModel.dart';
import 'package:restroapp/src/models/GetOrderHistory.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/SubscriptionDataResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class SubscriptionHistory extends StatefulWidget {
  StoreModel store;

  SubscriptionHistory(this.store);

  @override
  _SubscriptionHistoryState createState() {
    return _SubscriptionHistoryState();
  }
}

class _SubscriptionHistoryState extends State<SubscriptionHistory> {
  List<String> filtersList = [
    "\u2715 Clear",
    "Active Orders",
    "Pause Orders",
    "Completed Orders"
  ];

  int selectedFilter = -1;

  bool isLoading = true;

  List<SubscriptionOrderData> ordersList;

  DeliveryTimeSlotModel deliverySlotModel;
  int selctedTag, selectedTimeSlot;
  List<Timeslot> timeslotList;

  //Store provides instant delivery of the orders.
  bool isInstantDelivery = false;
  bool isDeliveryResponseFalse = false;
  bool isSlotSelected = false;
  String initSelectedTimeSlotString = '';

  @override
  void initState() {
    super.initState();
    selectedFilter = -1;
    getSubscriptionOrderHistory();
    callDeliverySlotsApi();
  }

  void callDeliverySlotsApi() {
    if (widget.store.deliverySlot == "1") {
      ApiController.deliveryTimeSlotApi().then((response) {
        setState(() {
          if (!response.success) {
            isDeliveryResponseFalse = true;
            return;
          }
          deliverySlotModel = response;
          print(
              "deliverySlotModel.data.is24X7Open =${deliverySlotModel.data.is24X7Open}");
          isInstantDelivery = deliverySlotModel.data.is24X7Open == "1";
          for (int i = 0;
              i < deliverySlotModel.data.dateTimeCollection.length;
              i++) {
            timeslotList =
                deliverySlotModel.data.dateTimeCollection[i].timeslot;
            for (int j = 0; j < timeslotList.length; j++) {
              Timeslot timeslot = timeslotList[j];
              if (timeslot.isEnable) {
                selectedTimeSlot = j;
                isSlotSelected = true;
                break;
              }
            }
            if (isSlotSelected) {
              selctedTag = i;
              break;
            }
          }
          if (selectedTimeSlot != null && selctedTag != null) {
            initSelectedTimeSlotString = deliverySlotModel
                .data
                .dateTimeCollection[selctedTag]
                .timeslot[selectedTimeSlot]
                .label;
          }
        });
      });
    }
  }

  Future<Null> getSubscriptionOrderHistory() {
    isLoading = true;
    return ApiController.getSubscriptionOrderHistory().then((respone) {
      if (mounted)
        setState(() {
          isLoading = false;
          ordersList = respone.data;
          if (ordersList.isEmpty) {
            //Utils.showToast("No data found!", false);
          }
        });
    });
  }

  Future<Null> updateSubscriptionStatus(
      String subscriptionOrderId, String status) {
    isLoading = true;
    return ApiController.subscriptionStatusUpdate(subscriptionOrderId, status)
        .then((respone) {
      Utils.hideProgressDialog(context);
      if (respone != null && respone.success) {
        if (mounted)
          setState(() {
            isLoading = false;
            getSubscriptionOrderHistory();
          });
      }
    });
  }

  Future<Null> updateSubscriptionOrderDeliverySlots(
      String subscriptionOrderId, String deliverySlot) {
    isLoading = true;
    return ApiController.subscriptionOrderUpdate(subscriptionOrderId, deliverySlot)
        .then((respone) {
      Utils.hideProgressDialog(context);
      if (respone != null && respone.success) {
        if (mounted)
          setState(() {
            isLoading = false;
            getSubscriptionOrderHistory();
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayColor,
      appBar: AppBar(
        title: Text("Subscribe"),
        centerTitle: true,
        actions: [
          Icon(
            Icons.search,
            color: Colors.white,
          ),
          Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Icon(
                Icons.filter_list,
                color: Colors.white,
              )),
        ],
      ),
      body: PullToRefreshView(
          onRefresh: () {
            return getSubscriptionOrderHistory();
          },
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : ordersList == null
                  ? SingleChildScrollView(
                      child: Center(child: Text("Something went wrong!")))
                  : Container(
                      color: grayColor,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              children: [
                                Visibility(
                                  visible: false,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    height: 80,
                                    color: blue3,
                                    child: Center(
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: filtersList.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5, 0, 5, 0),
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedFilter =
                                                              index;
                                                        });
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 10, 0),
                                                        child: Center(
                                                            child: Text(
                                                          "${filtersList[index]}",
                                                          style: TextStyle(
                                                              color:
                                                                  selectedFilter ==
                                                                          index
                                                                      ? blue3
                                                                      : Colors
                                                                          .white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        )),
                                                        height: 40,
                                                        color: selectedFilter ==
                                                                index
                                                            ? Colors.white
                                                            : Colors.white
                                                                .withOpacity(
                                                                    0.3),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: false,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                    height: 30,
                                    color: blue3,
                                    child: Text(
                                      "Results 10",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: ordersList.length,
                                  itemBuilder: (context, index) {
                                    return showSubScribeView(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
    );
  }

  Widget showSubScribeView(int index) {
    List<String> choices = List();
    switch (ordersList[index].status) {
      case '0':
      case '2':
      case '5':
      case '6':
      case '10':
        choices.add('View Details');
        break;
      case '1':
        choices.add('Order Stop');
        choices.add('Pause');
        choices.add('Change Delivery Slots');
        break;
      case '9':
        choices.add('Order Stop');
        choices.add('Active');
        choices.add('Change Delivery Slots');
        break;
    }
    return InkWell(
      onTap: (){ Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubscriptionHistoryDetails(
            ordersList[index], false
            ,deliverySlotModel,
            selctedTag,
            selectedTimeSlot,
            timeslotList,
            isInstantDelivery,
            isDeliveryResponseFalse,
            isSlotSelected,
            initSelectedTimeSlotString,),
        ),
      );},
      child: Container(
        color: Colors.white,
        //height: 100,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                  "#${ordersList[index].displaySubscriptionId} (${ordersList[index].orderItems.length} ${ordersList[index].orderItems.length > 1 ? 'Items' : 'Item'})",
                  style: TextStyle(
                    fontSize: 18,
                  )),
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 18,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Order ${_getSubscriptionStatus(ordersList[index])}",
                    style: TextStyle(
                      fontSize: 14,
                      color: _getSubscriptionStatusColor(ordersList[index]),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  PopupMenuButton(
                    elevation: 1.2,
                    onSelected: (choice) {
                      if (choice == 'View Details') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubscriptionHistoryDetails(
                                ordersList[index], false
                            ,deliverySlotModel,
                              selctedTag,
                              selectedTimeSlot,
                              timeslotList,
                              isInstantDelivery,
                              isDeliveryResponseFalse,
                              isSlotSelected,
                              initSelectedTimeSlotString,),
                          ),
                        );
                        return;
                      } else if (choice == 'Change Delivery Slots') {
                        deliverySlotBottomSheet(context, ordersList[index],true);
                        return;
                      }

                      String status = '1';
                      switch (choice) {
                        case 'Order Stop':
                          status = '6';
                          break;
                        case 'Pause':
                          status = '9';
                          break;
                        case 'Active':
                          status = '1';
                          break;
                      }
                      //hit api
                      Utils.showProgressDialog(context);
                      updateSubscriptionStatus(
                          ordersList[index].subscriptionOrderId, status);
                    },
                    onCanceled: () {
                      print('You have not chossed anything');
                    },
                    itemBuilder: (BuildContext context) {
                      return choices.map((String choice) {
                        return PopupMenuItem(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  )
                ],
              )
            ]),
            SizedBox(
              height: 10,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 18,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            "${_getDateFormated(ordersList[index].startDate)} to ${_getDateFormated(ordersList[index].endDate)}",
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${ordersList[index].deliveryTimeSlot}",
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      )
                    ],
                  )
                ]),
            Container(
              height: 1,
              color: Colors.grey[300],
              margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                  "Order ${ordersList[index].orderItems.length > 1 ? 'items' : 'item'}",
                  style: TextStyle(
                    fontSize: 18,
                  )),
              Visibility(
                visible: false,
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 18,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      _getDeliveryType(index),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              )
            ]),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              //color: Colors.grey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: ordersList[index].orderItems.length > 3
                            ? 3
                            : ordersList[index].orderItems.length,
                        itemBuilder: (context, itemIndex) {
                          return Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Wrap(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey[300],
                                        ),
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(5))),
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Center(
                                      child: Text(
                                        "${ordersList[index].orderItems[itemIndex].productName}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  Visibility(
                    visible: false,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Next Delivery Date"),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "28 Jan 2021",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: ordersList[index].orderItems.length > 3,
              child: InkWell(
                onTap: () => _showOrderItemsDialog(ordersList[index]),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text(
                    "View More",
                    style: TextStyle(
                      fontSize: 14,
                      color: appTheme,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 1,
              width: Utils.getDeviceWidth(context) / 2,
              color: Colors.grey[300],
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                children: [
                  Text("Total Amount: ",
                      style: TextStyle(
                        fontSize: 18,
                      )),
                  Text("${AppConstant.currency}${ordersList[index].total}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: (){
                      deliverySlotBottomSheet(context, ordersList[index],false);
                    },
                    child: Text(
                      "Delivery Slots",
                      style: TextStyle(
                        fontSize: 14,
                        color: appTheme,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              )
            ]),
          ],
        ),
      ),
    );
  }

  _showOrderItemsDialog(SubscriptionOrderData data) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we wifll build the content of the dialog
          return AlertDialog(
            //title: Text("Order Items"),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order Items'),
                  CloseButton(
                      color: Color(0xFFD5D3D3),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ]),
            content: MultiSelectChip(data.orderItems),
          );
        });
  }

  String _getSubscriptionStatus(SubscriptionOrderData cardOrderHistoryItems) {
//    0 -> Due
//    1-> Active
//    2-> Reject
//    5-> Completed
//    6-> Cancel by customer
//    9->Pause by customer
//    10-> Pause by store Admin
    String title = "Due";
    switch (cardOrderHistoryItems.status) {
      case '0':
        title = 'Due';
        break;
      case '1':
        title = 'Active';
        break;
      case '2':
        title = 'Rejected';
        break;
      case '5':
        title = 'Completed';
        break;
      case '6':
        title = 'Cancelled';
        break;
      case '9':
      case '10':
        title = 'Paused';
        break;
    }
    return title;
  }

  Color _getSubscriptionStatusColor(
      SubscriptionOrderData cardOrderHistoryItems) {
//    0 -> Due
//    1-> Active
//    2-> Reject
//    5-> Completed
//    6-> Cancel by customer
//    9->Pause by customer
//    10-> Pause by store Admin
    Color statusColor = Colors.black;
    switch (cardOrderHistoryItems.status) {
      case '0':
      case '1':
      case '5':
        statusColor = Colors.green;
        break;
      case '2':
      case '6':
        statusColor = Colors.red;
        break;
      case '9':
      case '10':
        statusColor = Colors.yellow;
        break;
    }
    return statusColor;
  }

  String _getDeliveryType(int index) {
    return '';
//    ordersList[index].ke
//    Alternate
  }

  _getDateFormated(DateTime event) {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(event);
    return formatted;
  }

  deliverySlotBottomSheet(
      context, SubscriptionOrderData cardOrderHistoryItems,bool isEnable) async {
    String _selectedTimeSlotString = initSelectedTimeSlotString;
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SafeArea(
                  child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Wrap(children: <Widget>[
                    Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                              child: Image.asset(
                                'images/cancelicon.png',
                                fit: BoxFit.scaleDown,
                                height: 15,
                                width: 15,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 15),
                          child: Text(
                            "Delivery Slots",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        deliverySlotModel == null
                            ? Container()
                            :
                            //print("--length = ${deliverySlotModel.data.dateTimeCollection.length}----");
                            deliverySlotModel.data != null &&
                                    deliverySlotModel.data.dateTimeCollection !=
                                        null &&
                                    deliverySlotModel
                                        .data.dateTimeCollection.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              //margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                              height: 50.0,
                                              child: ListView.builder(
                                                itemCount: timeslotList.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  Timeslot slotsObject =
                                                      timeslotList[index];
                                                  //print("----${slotsObject.label}-and ${selctedTag}--");
                                                  //selectedTimeSlot
                                                  Color textColor;
                                                  if (!slotsObject.isEnable) {
                                                    textColor =
                                                        Color(0xFFBDBDBD);
                                                  } else {
                                                    textColor =
                                                        Color(0xFF000000);
                                                  }
                                                  if (selectedTimeSlot ==
                                                          index &&
                                                      (slotsObject.isEnable)) {
                                                    textColor =
                                                        Color(0xFFff4600);
                                                  }

                                                  return Container(
                                                    //color: selectedSlotColor,
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 0, 10, 0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        print(
                                                            "${slotsObject.label}");
                                                        if (slotsObject
                                                            .isEnable) {
                                                          setState(() {
                                                            selectedTimeSlot =
                                                                index;
                                                            if (selectedTimeSlot !=
                                                                    null &&
                                                                selctedTag !=
                                                                    null) {
                                                              _selectedTimeSlotString =
                                                                  deliverySlotModel
                                                                      .data
                                                                      .dateTimeCollection[
                                                                          selctedTag]
                                                                      .timeslot[
                                                                          selectedTimeSlot]
                                                                      .label;
                                                            }
                                                          });
                                                        } else {
                                                          Utils.showToast(
                                                              slotsObject
                                                                  .innerText,
                                                              false);
                                                        }
                                                      },
                                                      child: Container(
                                                        child: Center(
                                                          child: Text(
                                                              '${slotsObject.isEnable == true ? slotsObject.label : "${slotsObject.label}(${slotsObject.innerText})"}',
                                                              style: TextStyle(
                                                                  color:
                                                                      textColor)),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                        Visibility(
                          visible: isEnable,
                          child: Container(
                            decoration: new BoxDecoration(
                              borderRadius:
                                  new BorderRadius.all(new Radius.circular(5.0)),
                            ),
                            child: FlatButton(
                              child: Text(
                                'Save',
                                style: TextStyle(fontSize: 17),
                              ),
                              color: orangeColor,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pop(context);
                                updateSubscriptionOrderDeliverySlots(
                                    cardOrderHistoryItems.subscriptionOrderId,
                                    _selectedTimeSlotString);
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
              ));
            },
          );
        });
  }

  Widget showDeliverySlot() {}
}

class MultiSelectChip extends StatefulWidget {
  final List<OrderItem> reportList;

  MultiSelectChip(this.reportList);

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  String selectedChoice = "";

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }

  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Container(
        color: Colors.white,
        padding: EdgeInsets.all(2.0),
        child: ChoiceChip(
          backgroundColor: Colors.white,
          //label: Text(item),
          label: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[500],
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Text("  ${item.productName}  "),
            //padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          ),
          selected: selectedChoice == item,
          onSelected: (selected) {
            /*setState(() {
              selectedChoice = item;
            });*/
          },
        ),
      ));
    });
    return choices;
  }
}
