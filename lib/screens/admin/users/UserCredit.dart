import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
// import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import '../../../AppTheme.dart';
import '../../../size_config.dart';

class Usercredit extends StatefulWidget {
  const Usercredit({Key? key, this.id}) : super(key: key);
  final id;
  @override
  _UsercreditState createState() => _UsercreditState();
}

class _UsercreditState extends State<Usercredit> {
  var data;
  getData() async {
    String? token = await getToken();
    var url = Uri.parse(
        "${getCloudUrl()}/api/Credit/getCreditByAdmin/" +
            widget.id.toString());
    var response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      data = json.decode(response.body);
      print(data);
      return data;
    } else {
      print("Exception");
      throw Error;
    }
  }

  postCreditData(id, credit) async {
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/credit/updateCredit";
    var url = Uri.parse(link);
    var response = await http.put(url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"userId": id.toString(), "amount": credit}));

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      futureData = getData();
      setState(() {});
      print(response.statusCode);
    } else {
      print("Exception");
      throw Error;
    }
  }

  deleteData(id) async {
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/credit/deleteCreditByAdmin/" +
            id.toString();
    var url = Uri.parse(link);
    var response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      futureData = getData();
      setState(() {});
      print(response.statusCode);
    } else {
      print("Exception");
      throw Error;
    }
  }

  Future? futureData;
  bool isConnected = false;
  @override
  void initState() {
    super.initState();
    futureData = getData();
    
  }

  

  late ThemeData themeData;
  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Scaffold(
      body: 
      FutureBuilder(
        future: futureData,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (data.isEmpty) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Center(child: Text('No Data Found')),
              ); 
              } else {
              return Padding(
                padding: EdgeInsets.only(top: MySize.size20),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  padding: EdgeInsets.only(bottom: MySize.size40),
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(MySize.size10,
                                MySize.size2, MySize.size10, MySize.size2),
                            child: Card(
                              elevation: 15,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    new BorderRadius.circular(MySize.size20),
                              ),
                              child: ListTileTheme(
                                // dense: true,

                                contentPadding:
                                    EdgeInsets.fromLTRB(MySize.size10, 0, 0, 0),
                                child: ExpansionTile(
                                  trailing: SizedBox.shrink(),
                                  // trailing: Text(''),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                              "Credit Date:" +
                                                  DateFormat("yyyy-MM-dd")
                                                      .format(
                                                    DateTime.parse(data[index]
                                                            ["orderDate"]
                                                        .toString()),
                                                  ),
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.button,
                                                fontWeight: 600,
                                              )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            " User Credit:\$",
                                            style: AppTheme.getTextStyle(
                                              themeData.textTheme.button,
                                              fontWeight: 550,
                                            ),
                                          ),
                                          Text(
                                            data[index]["totalPrice"]
                                                .toString(),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "User Paid\$:" +
                                                  data[index]["paid"]
                                                      .toString(),
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.button,
                                                fontWeight: 550,
                                              ),
                                            )
                                          ],
                                        ),
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
                                            MySize.size10,
                                            0,
                                            MySize.size36,
                                            MySize.size10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [],
                                            ),
                                            ElevatedButton.icon(
                                              style: ButtonStyle(
                                                foregroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(
                                                  Colors.black,
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(
                                                  Colors.amber.shade200,
                                                ),
                                              ),
                                              onPressed: () {
                                                TextEditingController
                                                    creditController =
                                                    TextEditingController();
                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: const Text(
                                                        'Add Credit'),
                                                    // content: const Text(
                                                    //   'AlertDialog description'),
                                                    actions: <Widget>[
                                                      customTextField(
                                                          creditController,
                                                          "",
                                                          "Add Credit"),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    'Cancel'),
                                                            child: const Text(
                                                                'Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              if (creditController
                                                                      .text ==
                                                                  "") {
                                                                Navigator.pop(
                                                                    context);
                                                                Flushbar(
                                                                  title:
                                                                      "Invalid",
                                                                  message:
                                                                      "Please Add Date",
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              3),
                                                                )..show(
                                                                    context);
                                                              }

                                                              if (creditController
                                                                  .text
                                                                  .isNotEmpty) {
                                                                postCreditData(
                                                                    data[index][
                                                                            "voidId"]
                                                                        .toString(),
                                                                    creditController
                                                                        .text);
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            },
                                                            child: const Text(
                                                                'OK'),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              icon: Icon(Icons.edit),
                                              label: Text("Edit "),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: MySize.size10),
                                              child: ElevatedButton.icon(
                                                style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    Colors.black,
                                                  ),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(
                                                    Colors.red.shade200,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  deleteData(
                                                    data[index]["voidId"]
                                                        .toString(),
                                                  );
                                                },
                                                icon: Icon(Icons.delete),
                                                label: Text("Delete"),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
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
      ),
    );
  }

  Widget customTextField(
    controller,
    hintText,
    labelText,
  ) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            //  fillColor: themeData.colorScheme.background,
            hintStyle: TextStyle(
                //  color: themeData.colorScheme.onBackground,
                ),
            filled: true,
            hintText: hintText,
            labelText: labelText,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            // prefixIcon: Icon(Icons.person),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 7,
        )
      ],
    );
  }
}
