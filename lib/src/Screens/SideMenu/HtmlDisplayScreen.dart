import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/utils/Utils.dart';

class HtmlDisplayScreen extends StatefulWidget {
  String appScreen;

  HtmlDisplayScreen(this.appScreen);

  @override
  State<StatefulWidget> createState() {
    return _HtmlDisplayScreenState();
  }
}

class _HtmlDisplayScreenState extends State<HtmlDisplayScreen> {
  String htmlData = '';
  bool isLoadingApi = true;

  @override
  void initState() {
    super.initState();
    ApiController.getHtmlForOptions(widget.appScreen).then((value) {
      setState(() {
        isLoadingApi = false;
        if (value != null &&
            value.success &&
            value.data.message != null &&
            value.data.message.isNotEmpty) {
          htmlData = value.data.message;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      return SafeArea(
        child: new Scaffold(
            appBar: AppBar(
              title: new Text(widget.appScreen),
              centerTitle: true,
            ),
            body: isLoadingApi
                ? Container(
                    color: Colors.white,
                    child: Center(child: CircularProgressIndicator()))
                : htmlData.isEmpty
                    ? Center(
                        child: Text("No ${widget.appScreen} Found",
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                            )),
                      )
                    : Container(
                        child: SingleChildScrollView(
                          child: Html(
                            data: htmlData,

                          ),
                        ),
                      )),
      );
    } catch (e, s) {
      print(s);
      return Utils.getEmptyView2("No ${widget.appScreen} Found");
    }
  }
}
