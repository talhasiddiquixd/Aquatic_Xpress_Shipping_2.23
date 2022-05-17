import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../AppTheme.dart';
import '../../../size_config.dart';

class Listview extends StatefulWidget {
  const Listview({Key? key, this.datas, this.id}) : super(key: key);
  final datas;
  final id;
  @override
  _ListviewState createState() => _ListviewState();
}

class _ListviewState extends State<Listview> {
  var upsData;
  List profit = [];
  late ThemeData themeData;
  List apiData = [];
  getData() async {
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/shipmentorder/getunpaidorderlist/" +
            widget.id.toString();
    var url = Uri.parse(link);
    var response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      upsData = json.decode(response.body);

      apiData.add(upsData);
      print("???????");
      print(apiData);
      for (int i = 0; i < upsData.length; i++) {
        profit.add(upsData[i]["totalPrice"] - upsData[i]["upsServiceRate"]);
      }
      return upsData;
    } else {
      print("Exception");
      throw Error;
    }
  }

  Future? futureData;
  @override
  void initState() {
    
    super.initState();
    if (widget.datas == 0) {
      futureData = getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    themeData = Theme.of(context);
    return Column(
      children: [
        FutureBuilder(
            future: futureData,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData && apiData[0].isNotEmpty) {
                return Expanded(
                    child: ListView.builder(
                        itemCount: upsData!.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      MySize.size10,
                                      MySize.size2,
                                      MySize.size10,
                                      MySize.size2),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 15,
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(
                                          MySize.size20),
                                    ),
                                    child: ListTileTheme(
                                      // dense: true,

                                      contentPadding: EdgeInsets.fromLTRB(
                                          MySize.size10,
                                          MySize.size10,
                                          MySize.size20,
                                          MySize.size20),
                                      child: ExpansionTile(
                                        trailing: SizedBox.shrink(),
                                        // trailing: Text(''),
                                        leading: Text("Order Date:" +
                                            DateFormat('dd-MM-yy').format(
                                                DateTime.parse(apiData[0][index]
                                                    ["orderDate"]))),

                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: MySize.size10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "Margin:\$" +
                                                          apiData[0][index]
                                                                  ["margin"]
                                                              .toString(),
                                                      style:
                                                          AppTheme.getTextStyle(
                                                        themeData
                                                            .textTheme.button,
                                                        fontWeight: 550,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Profit:\$" +
                                                          profit[index]
                                                              .toString(),
                                                      style:
                                                          AppTheme.getTextStyle(
                                                        themeData
                                                            .textTheme.button,
                                                        fontWeight: 550,
                                                      ),
                                                    ),
                                                    Text(
                                                      "User Paid:\$" +
                                                          apiData[0][index]
                                                                  ["totalPrice"]
                                                              .toString(),
                                                      style:
                                                          AppTheme.getTextStyle(
                                                              themeData
                                                                  .textTheme
                                                                  .button,
                                                              fontWeight: 550,
                                                              color:
                                                                  Colors.green),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                MySize.size10,
                                                0,
                                                MySize.size0,
                                                MySize.size10),
                                            child: Column(children: [
                                              Row(
                                                children: [
                                                  Text("Status:"),
                                                  Text(apiData[0][index]
                                                                  ["status"]
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
                                                        apiData[0][index][
                                                                    "userAddress"]
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
                                                        apiData[0][index][
                                                                    "addressBook"]
                                                                ["lastName"]
                                                            .toString(),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("Tracking Number:"),
                                                  Text(
                                                    apiData[0][index]
                                                            ["trackingNumber"]
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.blue),
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
                          );
                        }));
              }
              {
                return Padding(
                  padding: EdgeInsets.only(top: MySize.size180),
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ],
    );
  }
}
