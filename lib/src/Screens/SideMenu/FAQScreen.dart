import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/FAQModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/Utils.dart';

class FAQScreen extends StatefulWidget {
  StoreModel store;
  FaqModel faqData;
  List<FAQCategory> faqCategoryList = List();
  String faqSelectedCategory;

  FAQScreen(this.store);

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  bool isLoadingApi = true;

  @override
  void initState() {
    super.initState();
    ApiController.getFAQRequest().then((value) {
      setState(() {
        isLoadingApi = false;
        widget.faqData = value;
        widget.faqSelectedCategory = widget.faqData.data.keysList.first;

        if (value != null &&
            value.success &&
            widget.faqData.data.keysList != null &&
            widget.faqData.data.keysList.isNotEmpty) {
          widget.faqSelectedCategory = widget.faqData.data.keysList.first;
          widget.faqCategoryList =
              widget.faqData.data.faqCategoriesList[widget.faqSelectedCategory];
        } else {
          Utils.showToast("Something went wrong", true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('FAQ'),
        centerTitle: true,
      ),
      body: isLoadingApi
          ? Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()))
          : widget.faqData != null
              ? SafeArea(
                  child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(35, 20, 30, 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
//                              Expanded(child:
                              Text(
                                "Category:",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              /*SizedBox(
                                width: 50,
                              ),*/
//                              ),
                              Flexible(
                                  child: Container(
                                margin: EdgeInsets.only(left: 10),
                                padding: EdgeInsets.only(left: 10),
//                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: grayColor),
                                    borderRadius: BorderRadius.circular(1)),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  elevation: 6,
                                  dropdownColor: Colors.white,
//                                  underline: Utils.showDivider(context),
                                  underline: SizedBox(),
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  value: widget.faqSelectedCategory,
                                  items: widget.faqData.data.keysList
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      widget.faqSelectedCategory = value;
                                      widget.faqCategoryList =
                                          widget.faqData.data.faqCategoriesList[
                                              widget.faqSelectedCategory];
                                    });
                                  },
                                ),
                              ))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${widget
                                              .faqCategoryList[index].question}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Html(
                                          data:
                                              "${widget.faqCategoryList[index].answer}",
                                          padding: EdgeInsets.only(top: 2),
                                          defaultTextStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                /*Card2(widget.faqCategoryList[index])*/
                                itemCount: widget.faqCategoryList.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(
                  color: appThemeLight,
                ),
    );
  }
}
