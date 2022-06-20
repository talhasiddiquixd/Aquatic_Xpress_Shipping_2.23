import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:http/http.dart' as http;

import '../../../../AppTheme.dart';
import '../../../../size_config.dart';

class Deals extends StatefulWidget {
  const Deals({Key? key, this.data}) : super(key: key);
  final data;
  @override
  _DealsState createState() => _DealsState();
}

class _DealsState extends State<Deals> {
  TextEditingController nameController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  var deal;
  int? id;
  postData() async {
    id = int.parse(widget.data["id"].toString());

    String? token = await getToken();
    String ?link =
        "${getCloudUrl()}/api/Products/addDeals";

    var url = Uri.parse(link);
    var response = await http.post(url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "Description": 0,
          "name": nameController.text,
          "ProductId": id,
          "productQty": int.parse(itemController.text),
          "price": double.parse(priceController.text)
        }));
    print(widget.data["id"].toString());
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Flushbar(
        title: "Success ",
        message: "Deals Added",
        duration: Duration(seconds: 3),
      )..show(context);
      futureData = dealData();
      setState(() {});
      nameController.text = "";
      itemController.text = "";
      priceController.text = "";
    }

    print(response.body);
  }

  updateDeal(name, item, price) async {
    id = int.parse(widget.data["id"].toString());

    String? token = await getToken();
    String ?link =
        "${getCloudUrl()}/api/Products/updateDeals";

    var url = Uri.parse(link);
    var response = await http.post(url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "Description": 0,
          "name": name.toString(),
          "ProductId": id,
          "productQty": int.parse(item),
          "price": double.parse(price),
        }));
    print(widget.data["id"].toString());
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Flushbar(
        title: "Success ",
        message: "Deals Added",
        duration: Duration(seconds: 3),
      )..show(context);
      futureData = dealData();
      setState(() {});
      nameController.text = "";
      itemController.text = "";
      priceController.text = "";
    }

    print(response.body);
  }

  deleteData(id) async {
    String? token = await getToken();
    String ?link =
        "${getCloudUrl()}/api/products/deleteDeal/$id";
            // id.toString();
    var url = Uri.parse(link);
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) futureData = dealData();
    setState(() {});
    print(response.statusCode);
    print(response.body);
  }

  dealData() async {
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/Products/getDeals/" +
            widget.data["id"].toString();
    // "${getCloudUrl()}​/api​/ShipmentOrder​/getfedexorderlist";

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
      deal = json.decode(response.body);

      print("Hey data" + deal.toString());
      return deal;
    } else {
      print("Exception");
      throw Error;
    }
  }

  late ThemeData themeData;

  Future? futureData;
  @override
  void initState() {
    futureData = dealData();
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    themeData = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        Padding(
          padding: EdgeInsets.only(top: MySize.size60),
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: 65,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name:" + widget.data["name"].toString(),
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text("Details:" + widget.data["details"].toString()),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Color:" + widget.data["color"].toString()),
                            Text("Stock:" + widget.data["stock"].toString()),
                            Text(
                              "\$" + widget.data["price"].toString(),
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Divider(),
        Text("Add New Deal"),
        _body(),
        Column(
          //mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty ||
                      itemController.text.isEmpty ||
                      priceController.text.isEmpty) {
                    Flushbar(
                      title: "Invalid ",
                      message: "Enter Required Fields:",
                      duration: Duration(seconds: 3),
                    )..show(context);
                  } else {
                    postData();
                  }
                },
                child: Text("Add New Deal")),
          ],
        ),
        Text("List of Deals"),
        _list(),
      ]),
    );
  }

  _list() {
    return FutureBuilder(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Expanded(
                  child: ListView.builder(
                      itemCount: deal.length,
                      itemBuilder: (BuildContext ctx, index) {
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

                                  contentPadding: EdgeInsets.fromLTRB(
                                      MySize.size10, 0, 0, 0),
                                  child: ExpansionTile(
                                    trailing: SizedBox.shrink(),
                                    // trailing: Text(''),
                                    leading: Text(
                                      "Name:" + deal[index]["name"].toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

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
                                                  "Qty:" +
                                                      deal[index]["productQty"]
                                                          .toString(),
                                                  style: AppTheme.getTextStyle(
                                                    themeData.textTheme.button,
                                                    fontWeight: 550,
                                                  ),
                                                ),
                                                Text(
                                                  "\$" +
                                                      deal[index]["price"]
                                                          .toString(),
                                                  style: AppTheme.getTextStyle(
                                                      themeData
                                                          .textTheme.button,
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
                                        margin: EdgeInsets.fromLTRB(
                                            MySize.size60,
                                            0,
                                            MySize.size20,
                                            MySize.size10),
                                        child: Column(children: [
                                          Row(
                                            // mainAxisAlignment:
                                            //   MainAxisAlignment.spaceBetween,
                                            children: [
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
                                                  _shippingBottomSheet(
                                                      deal[index]["name"]
                                                          .toString(),
                                                      deal[index]["productQty"]
                                                          .toString(),
                                                      deal[index]["price"]
                                                          .toString(),
                                                      context);
                                                },
                                                icon: Icon(Icons.edit),
                                                label: Text("Edit"),
                                              ),
                                              SizedBox(width: 10),
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
                                                    Colors.redAccent.shade100,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  deleteData(deal[index]["id"]);
                                                },
                                                icon: Icon(Icons.delete),
                                                label: Text("Delete"),
                                              ),
                                              SizedBox(width: 10),
                                            ],
                                          ),
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }));
            }
          }
          {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  _body() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        children: [
          customTextField(nameController, "", "Name"),
          customTextField(itemController, "", "Item Quantity"),
          customTextField(priceController, "", "Price"),
        ],
      ),
    );
  }

  void _shippingBottomSheet(
    name,
    item,
    price,
    context,
  ) {
    TextEditingController nameController = TextEditingController();
    TextEditingController itemController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    nameController.text = name;
    itemController.text = item;
    priceController.text = price;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext buildContext) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter modalsetState /*You can rename this!*/) {
            return Container(
              child: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.only(top: 30),
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16))),
                    child: Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                          left: 24,
                          right: 24,
                          // bottom: 300,
                        ),
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: ,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(""),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              height: 20,
                              thickness: 1,
                              // indent: 10,
                              // endIndent: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //customTextField(

                                //),
                                customTextField(
                                  nameController,
                                  "",
                                  "Name",
                                ),

                                customTextField(
                                  itemController,
                                  "",
                                  "item",
                                ),
                                customTextField(
                                  priceController,
                                  "",
                                  "Price",
                                ),

                                // customTextField(
                                //   stockController,
                                //   "",
                                //   "Stock",
                                // ),

                                SizedBox(width: MySize.size10),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      updateDeal(
                                          nameController.text,
                                          itemController.text,
                                          priceController.text);
                                    },
                                    child: Text("Save Changes"),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ))),
              ),
            );
          });
        });
  }
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
        keyboardType: TextInputType.text,
      ),
      SizedBox(
        height: 7,
      )
    ],
  );
}
