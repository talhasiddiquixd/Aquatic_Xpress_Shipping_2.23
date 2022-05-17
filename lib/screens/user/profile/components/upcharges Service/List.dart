import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/screens/Service/Service.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpchargeService extends StatefulWidget {
  final data;
  const UpchargeService({Key? key, this.data}) : super(key: key);

  @override
  _UpchargeServiceState createState() => _UpchargeServiceState();
}

class _UpchargeServiceState extends State<UpchargeService> {
  Service services = new Service();

  late ThemeData themeData;
  List announce = [];
  List<dynamic> myString = [];
  String? timeFormat;
  String? abc;
  @override
  void initState() {
    for (int i = 0; i < widget.data["data"].length; i++) {
      timeFormat = widget.data["data"][i]["dateTime"].split("T")[1];
      abc = timeFormat![0] + timeFormat![1];
      myString.add(abc.toString());
    }
    announce.add(widget.data["data"]);
    // print(announce[1]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Container(
      // height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.only(bottom: MySize.size40),
      child: ListView.builder(
        itemCount: announce[0].length,
        itemBuilder: (BuildContext context, int index) {
          return Column(children: [
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
                                  "Subject: ",
                                  style: AppTheme.getTextStyle(
                                    themeData.textTheme.button,
                                    fontWeight: 600,
                                  ),
                                ),
                                Text(
                                  announce[0][index]["subject"].toString(),
                                  // widget.data["data"][index]["subject"]
                                  //     .toString(),
                                  style: AppTheme.getTextStyle(
                                    themeData.textTheme.button,
                                    fontWeight: 550,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Column(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Date:" +
                                      DateFormat("yyyy-MM-dd").format(
                                        DateTime.parse(announce[0][index]
                                                ["dateTime"]
                                            .toString()),
                                      ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(" "),
                                Text("Time:" +
                                    DateFormat("kk:mm").format(DateTime.parse(
                                        announce[0][index]["dateTime"]
                                            .toString()))),
                                int.parse(myString[index]) > 12
                                    ? Text("PM")
                                    : Text("AM"),
                              ],
                            )
                          ],
                        ),
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                MySize.size10, 0, MySize.size36, MySize.size10),
                            child: Column(
                              //  crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Discription: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Wrap(
                                  children: [
                                    Text(announce[0][index]["discription"]
                                        .toString()),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                   
                                   
                                  ],
                                )
                              ],
                            ),
                          ),
                        ])),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
