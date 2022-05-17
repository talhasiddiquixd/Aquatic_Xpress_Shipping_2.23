import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomListView extends StatefulWidget {
  final data;
  final value;

  const CustomListView({Key? key,required this.value, required this.data}) : super(key: key);

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

  openFedex(id) async {
   if (await canLaunch(
        "https://www.fedex.com/fedextrack/system-error?trknbr=" + id)) {
      await launch(
          "https://www.fedex.com/fedextrack/system-error?trknbr=" + id);
    } else {
      throw "could not URL";
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return ListView.builder(
      itemCount: widget.data.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: MySize.size16,
            vertical: MySize.size4,
          ),
          child: Card(
            elevation: 15,
            clipBehavior: Clip.antiAlias,
            child: ListTileTheme(
              // dense: true,

              // contentPadding: EdgeInsets.only(right: 0),
              contentPadding: EdgeInsets.fromLTRB(MySize.size10, 0, 0, 0),
              child: ExpansionTile(
                trailing: SizedBox.shrink(),
                // trailing: Text(''),
                title: Column (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //                       "id": 11,
                    // "orderDate": "2020-12-18T09:45:53",
                    // "recieverName": "Creative Things",
                    // "orderService": "UPS 2nd Day Air",
                    // "trackingNumber": "1ZW20R440208280979",
                    // "status": "V",
                    // "est": "12/22/2020 TUE EOD",
                    // "price": "16.16"
                    Row(
                      children: [
                        Text(
                          "Receiver: ",
                          style: AppTheme.getTextStyle(
                            themeData.textTheme.button,
                            fontWeight: 600,
                          ),
                        ),
                        Text(
                          widget.data[index]["recieverName"].toString(),
                          style: AppTheme.getTextStyle(
                            themeData.textTheme.button,
                            fontWeight: 550,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Price: \$",
                          style: AppTheme.getTextStyle(
                            themeData.textTheme.button,
                            fontWeight: 600,
                          ),
                        ),
                        Text(
                          widget.data[index]["price"].toString(),
                          style: AppTheme.getTextStyle(
                            themeData.textTheme.button,
                            fontWeight: 550,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Status: ",
                          style: AppTheme.getTextStyle(
                            themeData.textTheme.button,
                            fontWeight: 600,
                          ),
                        ),
                        Text(
                          widget.data[index]["status"].toString(),
                          style: AppTheme.getTextStyle(
                            themeData.textTheme.button,
                            fontWeight: 550,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat("yyyy-MM-dd").format(
                            DateTime.parse(
                                widget.data[index]["orderDate"].toString()),
                          ),
                        ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Tracking #: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                 widget.value==0?
                                      openURl(
                                          widget.data[index]["trackingNumber"]):openFedex(widget.data[index]["trackingNumber"].toString());
                                    
                              },
                              child: Text(
                                widget.data[index]["trackingNumber"].toString(),
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Days in Transit: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(widget.data[index]["est"].toString())
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Service: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(widget.data[index]["orderService"].toString())
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
