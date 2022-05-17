import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../AppTheme.dart';
import '../../../size_config.dart';

class Upfedlist extends StatefulWidget {
  const Upfedlist({Key? key, this.data, this.profit}) : super(key: key);
  final data;
  final profit;
  @override
  _UpfedlistState createState() => _UpfedlistState();
}

class _UpfedlistState extends State<Upfedlist> {
  late ThemeData themeData;
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    themeData = Theme.of(context);
    return Scaffold(
        body: ListView.builder(
            itemCount: widget.data!.length,
            itemBuilder: (BuildContext ctx, index) {
              return Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.only(top: MySize.size10),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(MySize.size10,
                            MySize.size2, MySize.size20, MySize.size2),
                        child: Card(
                          color: Colors.white,
                          elevation: 15,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                new BorderRadius.circular(MySize.size20),
                          ),
                          child: ListTileTheme(
                            // dense: true,

                            contentPadding: EdgeInsets.fromLTRB(
                                MySize.size20, MySize.size10, 0, MySize.size20),
                            child: ExpansionTile(
                              trailing: SizedBox.shrink(),
                              // trailing: Text(''),
                              leading: Text("Order Date:" +
                                  DateFormat('dd-MM-yy').format(DateTime.parse(
                                      widget.data[index]["orderDate"]))),

                              title: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: MySize.size10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Margin:\$" +
                                                widget.data[index]["margin"]
                                                    .toString(),
                                            style: AppTheme.getTextStyle(
                                              themeData.textTheme.button,
                                              fontWeight: 550,
                                            ),
                                          ),
                                          Text(
                                            "Profit:\$" +
                                                widget.profit[index].toString(),
                                            style: AppTheme.getTextStyle(
                                              themeData.textTheme.button,
                                              fontWeight: 550,
                                            ),
                                          ),
                                          Text(
                                            "User Paid:\$" +
                                                widget.data[index]["totalPrice"]
                                                    .toString(),
                                            style: AppTheme.getTextStyle(
                                                themeData.textTheme.button,
                                                fontWeight: 550,
                                                color: Colors.green),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(MySize.size10, 0,
                                      MySize.size0, MySize.size10),
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        Text("Status:"),
                                        Text(widget.data[index]["status"]
                                                    .toString() ==
                                                'C'
                                            ? "In Progress"
                                            : "Recieved")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Sender Name:" +
                                              widget.data[index]["userAddress"]
                                                      ["lastName"]
                                                  .toString(),
                                        ),
                                        SizedBox(width: 10),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Reciever Name:" +
                                              widget.data[index]["addressBook"]
                                                      ["lastName"]
                                                  .toString(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Tracking Number:"),
                                        Text(
                                          widget.data[index]["trackingNumber"]
                                              .toString(),
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ],
                                    )
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }));
  }
}
