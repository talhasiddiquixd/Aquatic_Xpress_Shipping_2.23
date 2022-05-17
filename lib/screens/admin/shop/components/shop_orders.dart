import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../../AppTheme.dart';
import '../../../../size_config.dart';

class ShopOrders extends StatefulWidget {
  const ShopOrders({Key? key}) : super(key: key);

  @override
  _ShopOrdersState createState() => _ShopOrdersState();
}

class _ShopOrdersState extends State<ShopOrders> {
  Future? futureUserList;
  late ThemeData themeData;
  bool isConnected = false;
  @override
  void initState() {
    super.initState();
    futureUserList = getUsers();
   
  }

  
  var data;
  getUsers() async {
    // quickQuote = 0;
    // curl();
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/Products/getshoporders";
    

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
      data = json.decode(response.body);
      print(data);
      return data;
    } else {
      print("Exception");
      throw Error;
    }
  }

  changStatus(id, int value) async {
    // quickQuote = 0;
    // curl();
    String? token = await getToken();
    String? actionStatus = "";
    if (value == 1) {
      actionStatus = "Received";
    } else if (value == 2) {
      actionStatus = "Confirmed";
    } else if (value == 3) {
      actionStatus = "Processing";
      print(actionStatus);
    } else if (value == 4) {
      actionStatus = "Shipped";
    }
    var url = Uri.parse(
        "${getCloudUrl()}/api/products/changeorderstatus?id=" +
            id.toString() +
            "&status=" +
            actionStatus);
    var response = await http.put(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var results = json.decode(response.body);
      print(results);
    }
  }

  int _value = 3;
  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return FutureBuilder(
      future: futureUserList,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext ctx, index) {
                  if (data.isEmpty) {
                    Center(child: Text("No Data"));
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Card(
                        elevation: 15,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        child: ListTileTheme(
                          contentPadding:
                              EdgeInsets.fromLTRB(MySize.size10, 0, 0, 0),
                          child: ExpansionTile(
                            trailing: SizedBox.shrink(),
                            title: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Order Date:" +
                                          (DateFormat('dd-MM-yy').format(
                                              DateTime.parse(
                                                  data[index]["orderDate"]))),
                                      style: AppTheme.getTextStyle(
                                        themeData.textTheme.bodyText1,
                                        fontWeight: 550,
                                      ),
                                    ),
                                    Text(
                                      "Status:" +
                                          data[index]["status"].toString(),
                                      style: AppTheme.getTextStyle(
                                        themeData.textTheme.bodyText1,
                                        fontWeight: 550,
                                      ),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Deal:" +
                                              data[index]["deal"]["name"]
                                                  .toString(),
                                          style: AppTheme.getTextStyle(
                                            themeData.textTheme.bodyText1,
                                            fontWeight: 550,
                                          ),
                                        ),
                                        Text(
                                          "Qty:" +
                                              data[index]["qty"].toString(),
                                          style: AppTheme.getTextStyle(
                                            themeData.textTheme.bodyText1,
                                            fontWeight: 550,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MySize.size10, right: MySize.size34),
                                child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Name:"),
                                        // Text(widget.data[index]
                                        //             ["applicationIdentityUser"]
                                        //             ["firstName"]
                                        //         .toString() +
                                        //     " " +
                                        data[index]["applicationIdentityUser"]
                                                    .toString() ==
                                                "null"
                                            ? Text("---")
                                            : Text(data[index][
                                                        "applicationIdentityUser"]
                                                    ["firstName"]
                                                .toString())
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Poduct:"),
                                        Text(
                                          data[index]["products"]["name"]
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Details:"),
                                        Text(data[index]["products"]["details"]
                                            .toString())
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Price:"),
                                        Text(
                                          "\$" +
                                              data[index]["products"]["price"]
                                                  .toString(),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(MySize.size10, 0,
                                    MySize.size36, MySize.size10),
                                child: Column(children: [
                                  Wrap(
                                    children: [
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          canvasColor: Colors.white,
                                        ),
                                        child: DropdownButton(
                                            value: _value,
                                            items: [
                                              DropdownMenuItem(
                                                child: Material(
                                                  child: Text(
                                                    "Recieved",
                                                  ),
                                                ),
                                                value: 1,
                                              ),
                                              DropdownMenuItem(
                                                child: Text("Confirmed"),
                                                value: 2,
                                              ),
                                              DropdownMenuItem(
                                                child: Text("Processing"),
                                                value: 3,
                                              ),
                                              DropdownMenuItem(
                                                child: Text("Shipped"),
                                                value: 4,
                                              )
                                            ],
                                            onChanged: (int? value) {
                                              _value = value!;
                                              setState(() {});
                                            },
                                            hint: Text("Change Status")),
                                      ),
                                      SizedBox(width: 10),
                                      ElevatedButton.icon(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Colors.black,
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Colors.amber.shade200,
                                          ),
                                        ),
                                        onPressed: () {
                                          changStatus(
                                              data[index]["id"], _value);
                                        },
                                        icon: Icon(Icons.edit),
                                        label: Text("Change Status"),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Text("data");
                });
          } else {
            return Container(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Center(child: Text('No Data Found')),
            );
          }
        } else {
          return Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}
