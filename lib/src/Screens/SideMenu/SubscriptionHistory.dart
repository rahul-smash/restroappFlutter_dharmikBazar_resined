import 'package:flutter/material.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
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

  List<String> filtersList = ["\u2715 Clear","Active Orders","Pause Orders","Completed Orders"];
  List<String> menuList = ["item 1","item 2","item 3","item 4","item 5","item 6","item 7"];

  int selectedFilter = -1;


  @override
  void initState() {
    super.initState();
    selectedFilter = -1;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: grayColor,
      appBar: AppBar(
        title: Text("SubScribe"),
        centerTitle: true,
        actions: [
          Icon(Icons.search,color: Colors.white,),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Icon(Icons.filter_list,color: Colors.white,)
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [
                Container(
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
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        selectedFilter = index;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: Center(
                                          child: Text("${filtersList[index]}",
                                            style: TextStyle(
                                                color: selectedFilter== index? blue3: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400),)
                                      ),
                                      height: 40,
                                      color: selectedFilter == index ? Colors.white : Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                  height: 30,
                  color: blue3,
                  child: Text("Results 10",style: TextStyle(color: Colors.white),),
                ),

                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {

                    return showSubScribeView();
                  },
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget showSubScribeView() {

    return Container(
      color: Colors.white,
      //height: 100,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("#12134 (4 Items)",style: TextStyle(fontSize: 18,)),
                Row(
                  children: [
                    Icon(Icons.check_circle_outline,size: 18,),
                    SizedBox(width: 5,),
                    Text("Order Active", style: TextStyle(fontSize: 14,decoration: TextDecoration.underline,),)
                  ],
                )
              ]
          ),
          SizedBox(height: 10,),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today,size: 18,),
                    SizedBox(width: 5,),
                    Text("26 Jan 2021 to 6 Feb 2021", style: TextStyle(fontSize: 16,decoration: TextDecoration.underline,),)
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time,size: 18,),
                    SizedBox(width: 5,),
                    Text("9Am to 10Pm", style: TextStyle(fontSize: 16,decoration: TextDecoration.underline,),)
                  ],
                )
              ]
          ),
          Container(
            height: 1,
            color: Colors.grey[300],
            margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Order items",style: TextStyle(fontSize: 18,)),
                Row(
                  children: [
                    Icon(Icons.check_circle_outline,size: 18,),
                    SizedBox(width: 5,),
                    Text("Alternate", style: TextStyle(fontSize: 14,),)
                  ],
                )
              ]
          ),
          Container(
            height: 50,
            //color: Colors.grey,
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: menuList.length > 3 ? 3 : menuList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Row(
                              children: [
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey[300],
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(5))
                                    ),
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Center(
                                        child: Text("${menuList[index]}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,),)
                                    ),
                                    height: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),

                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Next Delivery Date"),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,size: 18,),
                          SizedBox(width: 5,),
                          Text("28 Jan 2021", style: TextStyle(fontSize: 16,),)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          InkWell(
            onTap: () => _showOrderItemsDialog(),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text("View More",
                style: TextStyle(fontSize: 14,color: appTheme,
                  decoration: TextDecoration.underline,),
              ),
            ),
          ),
          Container(
            height: 1,width: Utils.getDeviceWidth(context)/2,
            color: Colors.grey[300],
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("Total Amount: ",style: TextStyle(fontSize: 18,)),
                    Text("\u20B91275",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Text("Deliver Slots", style: TextStyle(fontSize: 14,color: appTheme,
                      decoration: TextDecoration.underline,),)
                  ],
                )
              ]
          ),
        ],
      ),

    );
  }

  _showOrderItemsDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
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
                ]
            ),
            content: MultiSelectChip(menuList),
          );
        });
  }
}


class MultiSelectChip extends StatefulWidget {

  final List<String> reportList;
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
                borderRadius: BorderRadius.all(Radius.circular(5))
            ),
            child: Text("  ${item}  "),
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