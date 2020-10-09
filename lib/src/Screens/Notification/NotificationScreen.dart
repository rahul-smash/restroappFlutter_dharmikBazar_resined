import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_pull_to_refresh/flutter_pull_to_refresh.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/NotificationResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/Utils.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoadingApi = true;
  NotificationResponseModel resposneModel;

  @override
  void initState() {
    super.initState();
    getNotificationApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text('Notifications'),
          centerTitle: true,
        ),
        backgroundColor: grayLightColor,
        body: PullToRefreshView(
          onRefresh: () {
            return getNotificationApi();
          },
          child: isLoadingApi
              ? Container( color: grayLightColor,
              child: Center(child: CircularProgressIndicator()))
              : resposneModel != null
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                  child: Container(
                    color: grayLightColor,
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                      child: ListView.builder(
                        itemBuilder: (context, index) =>
                            _makeCard(index),
                        itemCount: resposneModel.data.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: false,
                      )))
            ],
          )
              : Utils.getEmptyView2("No Notifications"),
        ));
  }

  _makeCard(int index) {
    var cellbgColor = Colors
        .white /*index % 2 == 0 ? appTheme.withOpacity(.5) : appThemeLight*/;
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: cellbgColor,
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10, top: 5, right: 5, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      resposneModel.data[index].title,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(resposneModel.data[index].description,
                          style: TextStyle(fontSize: 13)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 5, top: 10),
                          child: Text(
                              Utils.convertNotificationDateTime(
                                  resposneModel.data[index].created),
                              style:
                              TextStyle(fontSize: 14, color: Colors.black)),
                        ),
                        Padding(
                            padding:
                            EdgeInsets.only(left: 5, right: 5, top: 10),
                            child: Text(
                                Utils.convertNotificationDateTime(
                                    resposneModel.data[index].created,
                                    onlyTime: true),
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black))),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (resposneModel.data[index].type.toLowerCase().compareTo('order') ==
            0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return NotificationScreen();
            }),
          );
        }
      },
    );
  }

  Future<Null> getNotificationApi() {
    return ApiController.getAllNotifications().then((value) {
      setState(() {
        isLoadingApi = false;
        if (value != null && value.success) {
          resposneModel = value;
        }
      });
    });
  }
}
