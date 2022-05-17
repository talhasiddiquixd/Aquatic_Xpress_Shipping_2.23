import 'dart:convert';
import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/components/custom_widgets/skeleton_container.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:uiblock/uiblock.dart';

import 'cart.dart';

class Shopping extends StatefulWidget {
  static String routeName = "/Shipping";
  @override
  _ShoppingState createState() => _ShoppingState();
}

var productData;
var details;
String? dropdownvalue;
List<dynamic> cartData = [];
double? price;

class _ShoppingState extends State<Shopping> {
  var name;

  List<dynamic> qemat = [];
  List? getDeals = [];

  getProducts() async {
    String? token = await getToken();

    var url =
        Uri.parse("${getCloudUrl()}/api/Products");
    var response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      productData = json.decode(response.body);
      for (int i = 0; i < productData.length; i++) {
        qemat.add(productData[i]["price"]);
      }
      print(productData);

      return productData;
    } else {
      print("Exception");
      throw Error;
    }
  }

  addToCart(id, qty) async {
    UIBlock.blockWithData(
      context,
      loadingTextWidget: Text("Adding to Cart"),
    );
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/Products/addtoMobilecart?id=$id&Qty=$qty";
    var url = Uri.parse(link);
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      UIBlock.unblock(context);
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Success",
        message: "Added to Cart Successfully",
        duration: Duration(seconds: 3),
      )..show(context);
      var data = json.decode(response.body);
      return data;
    } else {
      UIBlock.unblock(context);
      Flushbar(
        title: "Failed",
        message: "Error Occured",
        duration: Duration(seconds: 3),
      )..show(context);

      print("Exception");
      throw Error;
    }
  }

  getDealByProductID(id) async {
    String ?link = "${getCloudUrl()}/api/Products/getDeals/$id";
    var url = Uri.parse(link);
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      getDeals!.clear();
      getDeals = data;
      return data;
    } else {
      print("Exception");
      throw Error;
    }
  }

  late Future futureProducts;
  late Future futureDeals;
  @override
  void initState() {
    super.initState();
    futureProducts = getProducts();
    name = getName();
    setState(() {});
  }

  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    themeData = themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Shop"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Cart(),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart,
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: MySize.size160,
            width: MySize.size140,
            child: SvgPicture.asset("assets/icons/store.svg"),
          ),
          Container(
            child: FutureBuilder(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: (snapshot.data as List).length,
                          itemBuilder: (BuildContext ctx, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                vertical: MySize.size4,
                                horizontal: MySize.size10,
                              ),
                              child: Card(
                                child: ListTile(
                                  // tileColor: Colors.grey.shade100,
                                  onTap: () {
                                    futureDeals = getDealByProductID(
                                      (snapshot.data as List)[index]['id'],
                                    );

                                    _onButtonPressed(
                                      context,
                                      (snapshot.data as List)[index],
                                      cartData,
                                    );
                                  },
                                  leading: Image.memory(
                                    base64Decode(
                                      (snapshot.data as List)[index]["image"],
                                    ),
                                    height: MySize.size100,
                                    width: MySize.size100,
                                  ),
                                  title: Text(
                                    (snapshot.data as List)[index]['name']
                                        .toString()
                                        .split(' (')[0],
                                    style: AppTheme.getTextStyle(
                                      themeData.textTheme.bodyText1,
                                      // fontSize: Mysize,
                                      fontWeight: 600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Color: " +
                                        (snapshot.data as List)[index]["color"]
                                            .toString(),
                                    style: AppTheme.getTextStyle(
                                      themeData.textTheme.bodyText1,
                                      // fontSize: Mysize,
                                      fontWeight: 500,
                                    ),
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "\$" + qemat[index].toString(),
                                        style: AppTheme.getTextStyle(
                                          themeData.textTheme.bodyText1,
                                          color: themeData.primaryColor,
                                          fontWeight: 600,
                                        ),
                                      ),
                                      Text(
                                        "Stock: " +
                                            (snapshot.data as List)[index]
                                                    ["stock"]
                                                .toString(),
                                        style: AppTheme.getTextStyle(
                                          themeData.textTheme.bodyText1,
                                          fontWeight: 500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  }
                }

                return listViewWithLeadingPictureWithExpandedSkeleton(context);
              },
            ),
          ),
          //////////Expanded startup
        ],
      ),
    );
  }

  bool isLoading = false;

  _onButtonPressed(context, data, List<dynamic> cartData) {
    String? dealValue;

    var unitPrice;

    int id = 1;
    int qty = 1;
    data["price"] = 0.00;

    showModalBottomSheet(
        enableDrag: true,
        isDismissible: true,
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: themeData.scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(MySize.size10),
                topRight: Radius.circular(MySize.size10),
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(
                right: MySize.size10,
                left: MySize.size10,
                 top: MySize.size5,
                bottom: MySize.size50,
              ),
              // height: MySize.size1 * 600,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        child: Image.memory(
                          base64Decode(data["image"]),
                        ),
                      ),
                    ),
                    StatefulBuilder(builder: (BuildContext context,
                        StateSetter modalsetState /*You can rename this!*/) {
                      {
                        return Container(
                          padding: EdgeInsets.only(top: MySize.size10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'].toString(),
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.bodyText1,
                                  fontWeight: 700,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Stock: " + data["stock"].toString(),
                                    style: AppTheme.getTextStyle(
                                      themeData.textTheme.bodyText1,
                                    ),
                                  ),
                                  FutureBuilder(
                                      future: futureDeals,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.hasData) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                canvasColor: Colors.white,
                                              ),
                                              child: Container(
                                                width: MySize.size1 * 200,
                                                child: DropdownButton(
                                                  value: dealValue,
                                                  // underline: SizedBox(),
                                                  items: getDeals!.map<
                                                      DropdownMenuItem<
                                                          String>>((e) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: e['name']
                                                              .toString() +
                                                          "-" +
                                                          e['price']
                                                              .toString() +
                                                          "-" +
                                                          e['id'].toString(),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          e["name"].toString(),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  isExpanded: true,
                                                  icon: Icon(
                                                      Icons.arrow_drop_down),
                                                  hint: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: MySize.size16,
                                                    ),
                                                    child: Text(
                                                      "Select Deal",
                                                      // style: TextStyle(
                                                      //   fontSize:
                                                      //       MySize.size14,
                                                      // ),
                                                    ),
                                                  ),
                                                  dropdownColor:
                                                      Theme.of(context)
                                                          .backgroundColor,
                                                  onChanged: (dynamic value) {
                                                    modalsetState(() {
                                                      dealValue = value;
                                                      data["price"] =
                                                          value.split('-')[1];
                                                      id = int.parse(
                                                          value.split('-')[2]);
                                                      unitPrice = double.parse(
                                                          value.split('-')[1]);
                                                      qty = 1;
                                                    });
                                                  },
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                        return Container(
                                          // width: MySize.size60,
                                          height: MySize.size34,
                                          child: Text("Loading Deals"),
                                        );
                                      }),
                                ],
                              ),
                              data["price"] != 0.00
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  if(qty>1)
                                                  {
qty--;

                                                  data['price'] = (double.parse(
                                                              data['price']) -
                                                          unitPrice)
                                                      .toString();

                                                  modalsetState(() {});
                                                  }
                                                  
                                                },
                                                icon: Icon(
                                                  Icons.do_disturb_on,
                                                  color: themeData
                                                      .colorScheme.primary,
                                                )),
                                            Text(
                                              qty.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  qty++;
                                                  data['price'] = (double.parse(
                                                              data['price']) +
                                                          unitPrice)
                                                      .toString();

                                                  modalsetState(() {});
                                                },
                                                icon: Icon(
                                                  Icons.add_circle,
                                                  color: themeData
                                                      .colorScheme.primary,
                                                )),
                                          ],
                                        ),
                                        Text(
                                          data["price"] != 0.00
                                              ? "\$" +
                                                  double.parse(data["price"]
                                                          .toString())
                                                      .toStringAsFixed(
                                                    2,
                                                  )
                                              : '',
                                          style: TextStyle(
                                            color:
                                                themeData.colorScheme.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: MySize.size22,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            setState() {
                                              isLoading = true;
                                            }

                                            await addToCart(id, qty);
                                            isLoading = false;

                                            Navigator.pop(context);
                                          },
                                          child: !isLoading
                                              ? Text(
                                                  "Add to Cart",
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CircularProgressIndicator(
                                                        color: Colors.white),
                                                    SizedBox(
                                                        width: MySize.size20),
                                                    Text(
                                                      "Add to Cart",
                                                      style: TextStyle(
                                                        fontSize: MySize.size22,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        )
                                      ],
                                    )
                                  : Container()
                            ],
                          ),
                        );
                      }
                    })
                  ]),
            ),
          );
        });
  }
}
