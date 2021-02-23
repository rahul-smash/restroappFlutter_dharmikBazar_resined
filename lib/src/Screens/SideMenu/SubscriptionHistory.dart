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
  String clear = "\u2715 Clear";
  List<String> filtersList = [
    "\u2715 Clear",
    "Active Orders",
    "Pause Orders",
    "Completed Orders",
    "Due Orders",
  ];

  String selectedFilter = '';
  String searchedText = '';

  bool isLoading = true;

  List<SubscriptionOrderData> ordersList;
  List<SubscriptionOrderData> filteredList = List();

  DeliveryTimeSlotModel deliverySlotModel;
  int selctedTag, selectedTimeSlot;
  List<Timeslot> timeslotList;

  //Store provides instant delivery of the orders.
  bool isInstantDelivery = false;
  bool isDeliveryResponseFalse = false;
  bool isSlotSelected = false;
  String initSelectedTimeSlotString = '';

  Icon actionIcon = Icon(Icons.search);

  Widget appBarTitle = Text("Subscription");

  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    selectedFilter = '';
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
              "deliverySlotModel.data.is24X7Open =${deliverySlotModel.data
                  .is24X7Open}");
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

  Future<Null> updateSubscriptionStatus(String subscriptionOrderId,
      String status) {
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

  Future<Null> updateSubscriptionOrderDeliverySlots(String subscriptionOrderId,
      String deliverySlot) {
    isLoading = true;
    return ApiController.subscriptionOrderUpdate(
        subscriptionOrderId, deliverySlot)
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

  CycleType _checkSubscriptionKey(String subscriptionType) {
    CycleType label = widget.store.subscription.cycleType.first;
    for (CycleType cycleType in widget.store.subscription.cycleType) {
      if (cycleType.key == subscriptionType) {
        label = cycleType;
        break;
      }
    }
    return label;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grayColor,
      appBar: AppBar(
        title: appBarTitle,
        centerTitle: true,
        actions: [
          new IconButton(
            icon: actionIcon,
            onPressed: () {
              _showFilters = false;
              selectedFilter = '';
              searchedText = '';
              selectedFilter = '';
              filteredList.clear();
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = new Icon(Icons.close);
                  this.appBarTitle = new TextField(
                    onChanged: (value) {
                      searchedText = value;
                    },
                    onSubmitted: (value) {
                      print("search");
                      searchedText = value;
                      findSearchList();
                    },
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                    decoration: new InputDecoration(
                        hintText: "Search...",
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintStyle: new TextStyle(color: Colors.white)),
                  );
                } else {
                  this.actionIcon = new Icon(Icons.search);
                  this.appBarTitle = Text("Subscription");
                }
              });
            },
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              setState(() {
                this.actionIcon = new Icon(Icons.search);
                this.appBarTitle = Text("Subscription");
                _showFilters = !_showFilters;
                selectedFilter = '';
                searchedText = '';
                filteredList.clear();
              });
            },
            icon: Icon(
              !_showFilters ? Icons.filter_list : Icons.close,
              color: Colors.white,
            ),
          ),
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
                      visible: _showFilters,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: appTheme,
                        alignment: Alignment.center,
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: filtersList.map((filter) {
                                return Container(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        5, 0, 5, 0),
                                    child: Wrap(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if ((selectedFilter !=
                                                  '' &&
                                                  filter ==
                                                      clear) ||
                                                  filter == clear) {
                                                selectedFilter = '';
                                                filteredList.clear();
                                                setState(() {
                                                  //refreshList
                                                });
                                                return;
                                              }
                                              selectedFilter = filter;
                                              findfiltedList();
                                            });
                                          },
                                          child: Container(
                                            padding:
                                            EdgeInsets.all(10),
                                            child: Center(
                                                child: Text(
                                                  "${filter}",
                                                  style: TextStyle(
                                                      color:
                                                      selectedFilter ==
                                                          filter
                                                          ? appTheme
                                                          : Colors
                                                          .white,
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight
                                                          .w400),
                                                )),
                                            color: selectedFilter ==
                                                filter
                                                ? Colors.white
                                                : Colors.white
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(growable: true),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: (searchedText.isNotEmpty) ||
                          (_showFilters && selectedFilter.isNotEmpty),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                        color: appTheme,
                        child: Text(
                          searchedText.isNotEmpty ||
                              selectedFilter.isNotEmpty
                              ? "${filteredList
                              .length} from Results ${ordersList.length}"
                              : '',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    (searchedText.isNotEmpty &&
                        filteredList.isEmpty) ||
                        (selectedFilter.isNotEmpty &&
                            filteredList.isEmpty)
                        ? Container(
                        height:
                        Utils.getDeviceHeight(context) - 165,
                        child: Center(
                            child: Text(
                              '${searchedText.isNotEmpty
                                  ? searchedText + ' is '
                                  : selectedFilter + ' are '}not Found!',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 20),
                            )))
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: filteredList.isNotEmpty
                          ? filteredList.length
                          : ordersList.length,
                      itemBuilder: (context, index) {
                        return showSubScribeView(index);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showSubScribeView(int index) {
    SubscriptionOrderData data =
    filteredList.isNotEmpty ? filteredList[index] : ordersList[index];
    List<String> choices = List();
    switch (data.status) {
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
        if (!data.orderFacility.toLowerCase().contains('pick'))
          choices.add('Change Delivery Slots');
        break;
      case '9':
        choices.add('Order Stop');
        choices.add('Active');
        if (!data.orderFacility.toLowerCase().contains('pick'))
          choices.add('Change Delivery Slots');
        break;
    }
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SubscriptionHistoryDetails(
                    orderHistoryData: data,
                    isRatingEnable: false,
                    deliverySlotModel: deliverySlotModel,
                    selctedTag: selctedTag,
                    selectedTimeSlot: selectedTimeSlot,
                    timeslotList: timeslotList,
                    isInstantDelivery: isInstantDelivery,
                    isDeliveryResponseFalse: isDeliveryResponseFalse,
                    isSlotSelected: isSlotSelected,
                    initSelectedTimeSlotString: initSelectedTimeSlotString,
                    store: widget.store),
          ),
        );
      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
                "#${data.displaySubscriptionId} (${data.orderItems
                    .length} ${data.orderItems.length > 1 ? 'Items' : 'Item'})",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(
              width: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: _getSubscriptionStatusColor(data),
                ),
                SizedBox(
                  width: 3,
                ),
                Text(
                  "Order ${_getSubscriptionStatus(data)}",
                  style: TextStyle(
                    fontSize: 14,
                    color: _getSubscriptionStatusColor(data),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Visibility(
                  visible: data.status!='2',
                  child: PopupMenuButton(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      Icons.more_vert,
                    ),
                    elevation: 0,
                    onSelected: (choice) {
                      if (choice == 'View Details') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SubscriptionHistoryDetails(
                                    orderHistoryData: data,
                                    isRatingEnable: false,
                                    deliverySlotModel: deliverySlotModel,
                                    selctedTag: selctedTag,
                                    selectedTimeSlot: selectedTimeSlot,
                                    timeslotList: timeslotList,
                                    isInstantDelivery: isInstantDelivery,
                                    isDeliveryResponseFalse:
                                    isDeliveryResponseFalse,
                                    isSlotSelected: isSlotSelected,
                                    initSelectedTimeSlotString:
                                    initSelectedTimeSlotString,
                                    store: widget.store),
                          ),
                        );
                        return;
                      } else if (choice == 'Change Delivery Slots') {
                        deliverySlotBottomSheet(context, data, true);
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
                          data.subscriptionOrderId, status);
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
                  ),
                )
              ],
            )
          ]),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/calendargreyicon.png',
                  fit: BoxFit.scaleDown,
                  height: 14,
                  color: Color(0xFFBDBDBF),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    "${_getDateFormated(data.startDate)} to ${_getDateFormated(
                        data.endDate)}",
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
          ),
          !data.orderFacility.toLowerCase().contains('pick') ?
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'images/timegreyicon.png',
                fit: BoxFit.scaleDown,
                height: 14,
                color: Color(0xFFBDBDBF),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "${data.deliveryTimeSlot.replaceAll(':00', '')}",
                maxLines: 2,
                style: TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          ) : Container(),
          ]),
      Container(
        height: 1,
        color: Color(0xffEBECED),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text("Order ${data.orderItems.length > 1 ? 'items' : 'item'}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF807D8C),
            )),
        Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 14,
              color: Color(0xFF807D8C),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              _checkSubscriptionKey(data.subscriptionType).label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: Color(0xFF807D8C),
              ),
            )
          ],
        )
      ]),
      Container(
        padding: EdgeInsets.fromLTRB(5, 2, 5, 0),
        //color: Colors.grey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 80,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: data.orderItems.length > 3
                        ? 3
                        : data.orderItems.length,
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
                                      color: Color(0xFFBDBDBF),
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5))),
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "${data.orderItems[itemIndex].productName}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
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
            ),
            Visibility(
              visible: checkstatus(data),
              child: Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Next Delivery Date',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF807D8C),
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'images/calendargreyicon.png',
                          fit: BoxFit.scaleDown,
                          height: 14,
                          color: Color(0xFFBDBDBF),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          _checkNextDeliveryDate(data),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      Visibility(
        visible: data.orderItems.length > 3,
//              visible: true,
        child: InkWell(
          onTap: () => _showOrderItemsDialog(data),
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
        color: Color(0xFFBDBDBF),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Wrap(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 6.0),
                  child: Text("Total Amount: ",
                      style: TextStyle(
                        color: Color(0xffA3A5A8),
                        fontSize: 16,
                      ))),
              Padding(
                padding: EdgeInsets.only(top: 6.0),
                child: Text("${AppConstant.currency}${data.total}",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Visibility(
                visible: data.paymentMethod != null &&
                    data.paymentMethod
                        .trim()
                        .isNotEmpty,
                child: Container(
                    margin: EdgeInsets.only(left: 6),
                    padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE6E6E6)),
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: Text(
                        '${data.paymentMethod.trim().toUpperCase()}',
                        style: TextStyle(
                            color: Color(0xFF39444D), fontSize: 10))),
              ),
            ],
          ),
        ),
        Visibility(
          visible: data.status=='0',
          child: Text(
            "View Order",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xff799A3F),
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ]),
      ],
    ),)
    ,
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
        title = 'Paused';
        break;
      case '10':
        title = 'Paused by Admin';
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
        statusColor = Color(0xff799A3F);
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

  _getDateFormated(DateTime event) {
    var formatter = new DateFormat('dd-MMM-yyyy');
    String formatted = formatter.format(event);
    return formatted;
  }

  deliverySlotBottomSheet(context, SubscriptionOrderData cardOrderHistoryItems,
      bool isEnable) async {
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
                        bottom: MediaQuery
                            .of(context)
                            .viewInsets
                            .bottom),
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
                                                        '${slotsObject
                                                            .isEnable == true
                                                            ? slotsObject.label
                                                            : "${slotsObject
                                                            .label}(${slotsObject
                                                            .innerText})"}',
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
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(5.0)),
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
                                        cardOrderHistoryItems
                                            .subscriptionOrderId,
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

  String _checkNextDeliveryDate(SubscriptionOrderData data) {
    List<DateTime> getDatesInBeteween =
    Utils.getDatesInBeteween(data.startDate, data.endDate);
    DateTime deliveryDate = DateTime.now();
    for (DateTime day in getDatesInBeteween) {
      if (day.isAfter(deliveryDate)) {
        deliveryDate = day;
        break;
      }
    }

    String formatted = '';
    try {
      DateFormat formatter = new DateFormat('dd MMM, yyyy');
      formatted = formatter.format(deliveryDate.toLocal());
    } catch (e) {
      print(e);
    }
    return formatted;
  }

  bool checkstatus(SubscriptionOrderData data) {
    return data.status == '1';
  }

  Widget showDeliverySlot() {}

  void findfiltedList() {
    filteredList.clear();
    if (ordersList != null && ordersList.isNotEmpty) {
      for (int i = 0; i < ordersList.length; i++) {
        String type = '';
        switch (selectedFilter) {
          case "Active Orders":
            type = '1';
            break;
          case "Pause Orders":
            type = '9';
            break;
          case "Completed Orders":
            type = '5';
            break;
          case "Due Orders":
            type = '0';
            break;
        }
        if (type == ordersList[i].status) filteredList.add(ordersList[i]);
      }
      setState(() {});
    }
  }

  void findSearchList() {
    filteredList.clear();
    if (ordersList != null && ordersList.isNotEmpty) {
      for (int i = 0; i < ordersList.length; i++) {
        if (ordersList[i].displaySubscriptionId.contains(searchedText)) {
          filteredList.add(ordersList[i]);
        } else {
          for (int j = 0; j < ordersList[i].orderItems.length; j++) {
            print(ordersList[i].orderItems[j].productName);
            print(
                ordersList[i].orderItems[j].productName.contains(searchedText));
            if (ordersList[i]
                .orderItems[j]
                .productName
                .toLowerCase()
                .contains(searchedText.toLowerCase())) {
              filteredList.add(ordersList[i]);
              break;
            }
          }
        }
      }
      setState(() {});
    }
  }
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
