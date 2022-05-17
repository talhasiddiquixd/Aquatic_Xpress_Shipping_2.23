import 'dart:convert';

import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:http/http.dart' as http;

class List extends StatefulWidget {
  const List({Key? key, this.data, this.id}) : super(key: key);
  final data;
  final id;

  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List> {
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
      print(response.statusCode);
    } else {
      print("Exception");
      throw Error;
    }
  }

  late ThemeData themeData;
  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      // height: MediaQuery.of(context).size.height * 0.8,
      // padding: EdgeInsets.only(bottom: MySize.size40),
      // height: MediaQuery.of(context).size.height * 0.8,
      // padding: EdgeInsets.only(bottom: MySize.size40),
      body: Padding(
        padding: EdgeInsets.only(top: MySize.size20),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.only(bottom: MySize.size40),
          child: ListView.builder(
            itemCount: widget.data.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(MySize.size10, MySize.size2,
                        MySize.size10, MySize.size2),
                    child: Card(
                      elevation: 15,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(MySize.size20),
                      ),
                      child: ListTileTheme(
                        // dense: true,

                        contentPadding:
                            EdgeInsets.fromLTRB(MySize.size10, 0, 0, 0),
                        child: ExpansionTile(
                          trailing: SizedBox.shrink(),
                          // trailing: Text(''),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                      "Credit Date:" +
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
                                    widget.data[index]["totalPrice"].toString(),
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
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "User Paid\$:" +
                                          widget.data[index]["paid"].toString(),
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
                                margin: EdgeInsets.fromLTRB(MySize.size10, 0,
                                    MySize.size36, MySize.size10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [],
                                    ),
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
                                        TextEditingController creditController =
                                            TextEditingController();
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text('Add Credit'),
                                            // content: const Text(
                                            //   'AlertDialog description'),
                                            actions: <Widget>[
                                              customTextField(creditController,
                                                  "", "Add Credit"),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Cancel'),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      postCreditData(
                                                          widget.data[index]
                                                                  ["voidId"]
                                                              .toString(),
                                                          creditController
                                                              .text);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('OK'),
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
                                      padding:
                                          EdgeInsets.only(left: MySize.size10),
                                      child: ElevatedButton.icon(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Colors.black,
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Colors.red.shade200,
                                          ),
                                        ),
                                        onPressed: () {
                                          deleteData(
                                            widget.data[index]["voidId"]
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
