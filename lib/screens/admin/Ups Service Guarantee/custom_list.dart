import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../AppTheme.dart';
import '../../../size_config.dart';

class CustomListView extends StatefulWidget {
  const CustomListView({Key? key, this.data}) : super(key: key);
  final data;
  @override
  _CustomListViewState createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  late ThemeData themeData;
  openURl(id) async {
    if (await canLaunch(
        "https://wwwapps.ups.com/WebTracking/processInputRequest?sort_by=status&tracknums_displ%20ayed=1&TypeOfInquiryNumber=T&loc=en_US&InquiryNumber1=" +
            id +
            "&track.x=0&track.y=0&requester=ST/trackdetails")) {
      await launch(
          "https://wwwapps.ups.com/WebTracking/processInputRequest?sort_by=status&tracknums_displ%20ayed=1&TypeOfInquiryNumber=T&loc=en_US&InquiryNumber1=" +
              id +
              "&track.x=0&track.y=0&requester=ST/trackdetails");
    } else {
      throw "could not URL";
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Container(
      // height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.only(bottom: MySize.size40),
      child: ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                    MySize.size10, MySize.size2, MySize.size10, MySize.size2),
                child: Card(
                  elevation: 15,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(MySize.size20),
                  ),
                  child: ListTileTheme(
                    // dense: true,

                    contentPadding: EdgeInsets.fromLTRB(MySize.size10, 0, 0, 0),
                    child: ExpansionTile(
                      trailing: SizedBox.shrink(),
                      // trailing: Text(''),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                  "Order Date: " , style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  Text(
                                      DateFormat("yyyy-MM-dd").format(
                                        DateTime.parse(widget.data[index]
                                                ["orderDate"]
                                            .toString()),
                                      ),
                                  style: AppTheme.getTextStyle(
                                    themeData.textTheme.button,
                                    fontWeight: 600,
                                  )),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     Text(
                          //       "Charges:\$",
                          //       style: AppTheme.getTextStyle(
                          //         themeData.textTheme.button,
                          //         fontWeight: 550,
                          //       ),
                          //     ),
                          //     Text(
                          //       widget.data[index]["additionalCharges"]
                          //           .toString(),
                          //       style: AppTheme.getTextStyle(
                          //         themeData.textTheme.button,
                          //         fontWeight: 550,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                " ",
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.button,
                                  fontWeight: 600,
                                ),
                              ),
                              Text(
                                "Sender Name: " ,style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),),
                                    Text(widget.data[index]["userAddress"]["lastName"].toString()
                                
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // // Text(
                              // //   "UserName:" +
                              // //       widget.data[index]["userName"].toString(),
                              // //   style: AppTheme.getTextStyle(
                              // //     themeData.textTheme.button,
                              // //     fontWeight: 550,
                              // //   ),
                              // ),
                            ],
                          )
                        ],
                      ),
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              MySize.size10, 0, MySize.size36, MySize.size10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Reciever Name: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(widget.data[index]["addressBook"]["lastName"]),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // // Text(
                                  // //   "previousAmount: ",
                                  // //   style: TextStyle(
                                  // //     fontWeight: FontWeight.bold,
                                  // //   ),
                                  // // ),
                                  // Text("\$" +
                                  //     widget.data[index]["previousAmount"]
                                  //         .toString())
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Tracking #: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      openURl(widget.data[index]
                                          ["trackingNumber"]);
                                    },
                                    child: Text(
                                      widget.data[index]
                                              ["trackingNumber"]
                                          .toString(),
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Delivery Date: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(  DateFormat("yyyy-MM-dd").format(
                                        DateTime.parse(
                                    widget.data[index]["deliveryDate"]
                                      .toString()))),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Expected Delivery ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(   DateFormat("yyyy-MM-dd").format(
                                        DateTime.parse(widget.data[index]["expectedDate"]
                                      .toString()))),
                                ],
                              ),
                                Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Action:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                 widget.data[index]["isAppliedforRefund"]==null? Text("Change Status to Applied"):Text(
                                "Applied")
                                ],
                              ),
                              // Column(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       "Reason: ",
                              //       style: TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // Wrap(
                              //   children: [
                              //     Text(widget.data[index]["reason"].toString()),
                              //   ],
                              // ),
                              // Column(
                              //   children: [
                              //     Text(
                              //       "Address: ",
                              //       style: TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // Wrap(
                              //   children: [
                              //     Text(widget.data[index]["shipmentAddress"]
                              //         .toString()),
                              //   ],
                              // )
                            
                            
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
