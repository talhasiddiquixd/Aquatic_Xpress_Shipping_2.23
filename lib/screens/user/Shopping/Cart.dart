import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:aquatic_xpress_shipping/components/custom_widgets/text_field.dart';

import 'package:flutter/material.dart';

import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/components/custom_widgets/skeleton_container.dart';
import 'package:aquatic_xpress_shipping/models/GenericModel.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:http/http.dart' as http;
import 'package:aquatic_xpress_shipping/screens/user/shipping/shipping.dart';
import 'package:aquatic_xpress_shipping/screens/user/shop_payment/Payment.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key, this.cartData}) : super(key: key);
  final cartData;
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool addressFilled = false;
  var subtotal = 0.0;
  late Future futureAddress;
  late Future futureCart;
  late Future futureTotal;
  @override
  void initState() {
    super.initState();
    // this.function();
    futureCart = getCart();
    futureTotal = getCartTotal();
    futureAddress = getAddresses();
  }

  getCart() async {
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/Products/getcart";
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
      var productData = json.decode(response.body);

      print(productData);

      return productData;
    } else {
      print("Exception");
      throw Error;
    }
  }

  getCartTotal() async {
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/Products/getcarttotal";
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
      var productData = json.decode(response.body);

      print(productData);
      subtotal = double.parse(productData.toString());

      return productData;
    } else {
      print("Exception");
      throw Error;
    }
  }

  removeItem(id) async {
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/Products/removefromcart?id=$id";
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
      var productData = json.decode(response.body);

      Flushbar(
        title: "Success",
        message: "Item removed successfuly",
        duration: Duration(seconds: 3),
      )..show(context);

      futureCart = getCart();
      futureTotal = getCartTotal();
      setState(() {});

      return productData;
    } else {
      print("Exception");
      throw Error;
    }
  }

  getAddresses() async {
    String? token = await getToken();

    String ?link = "${getCloudUrl()}/api/AddressBook";
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
      var data = json.decode(response.body);
      return data;
    } else {
      print("Exception");
      throw Error;
    }
  }

  TextEditingController fOrgController = new TextEditingController(),
      fNameController = new TextEditingController(),
      fAddressController = new TextEditingController(),
      fApartController = new TextEditingController(),
      fCityController = new TextEditingController(),
      fZipController = new TextEditingController(),
      fStateController = new TextEditingController(),
      fPhoneController = new TextEditingController();

  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    MySize().init(context);

    print(widget.cartData);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart "),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: futureCart,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: (snapshot.data as List).length,
                        itemBuilder: (BuildContext ctx, index) {
                          return Dismissible(
                              key: UniqueKey(),
                              background: Container(color: Colors.red),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: MySize.size4,
                                  horizontal: MySize.size10,
                                ),
                                child: Card(
                                  child: ListTile(
                                    // tileColor: Colors.grey.shade100,

                                    leading: Image.memory(
                                      base64Decode(
                                        (snapshot.data as List)[index]
                                            ['products']["image"],
                                      ),
                                      height: MySize.size100,
                                      width: MySize.size100,
                                    ),
                                    title: Text(
                                      (snapshot.data as List)[index]['products']
                                              ['name']
                                          .toString(),
                                      // style: TextStyle(
                                      //   fontSize: MySize.size18,
                                      //   fontWeight: FontWeight.w500,
                                      // ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Text(
                                        //   "Color: " +
                                        //       (snapshot.data as List)[index]
                                        //           ['products']["color"],
                                        // ),
                                        Text(
                                          "Deal: " +
                                              (snapshot.data as List)[index]
                                                  ['deal']["name"],
                                        ),
                                      ],
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Qty: " +
                                              (snapshot.data as List)[index]
                                                      ["qty"]
                                                  .toString(),
                                        ),
                                        Text(
                                          "\$" +
                                              double.parse((((snapshot.data
                                                                      as List)[
                                                                  index]['deal']
                                                              ['price'] *
                                                          (snapshot.data
                                                                  as List)[
                                                              index]["qty"]))
                                                      .toString())
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                            color:
                                                themeData.colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              onDismissed: (direction) {
                                removeItem(
                                  (snapshot.data as List)[index]['id'],
                                );
                                subtotal -= double.parse(double.parse(
                                        (((snapshot.data as List)[index]['deal']
                                                    ['price'] *
                                                (snapshot.data as List)[index]
                                                    ["qty"]))
                                            .toString())
                                    .toStringAsFixed(2));
                                (snapshot.data as List).removeAt(index);

                                // Remove the item from the data source.

                                setState(() {});
                              });
                        }),
                  );
                }
              }

              return listViewWithLeadingPictureWithExpandedSkeleton(context);
            },
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: MySize.size10),
            child: InkWell(
              onTap: () {
                _shippingBottomSheet(context, "to");
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MySize.size14),
                ),
                elevation: 10,
                child: Container(
                  padding: EdgeInsets.all(MySize.size10),
                  child: Row(
                    children: [
                      svgPicLoader("assets/icons/ShippingTo.svg"),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          from.city! == ""
                              ? Text(
                                  "Shipping to",
                                  style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText1,
                                    fontWeight: 600,
                                  ),
                                )
                              : Container(),
                          from.city! == ""
                              ? Text(
                                  "Tap here to set Destination",
                                  style: AppTheme.getTextStyle(
                                    themeData.textTheme.subtitle2,
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      from.name!,
                                      style: TextStyle(fontSize: MySize.size18),
                                    ),
                                    Text(
                                      from.address! + " " + from.city!,
                                      style: TextStyle(fontSize: MySize.size16),
                                      softWrap: true,
                                    ),
                                    Text(
                                      from.state! + " " + from.zipCode!,
                                      style: TextStyle(
                                        fontSize: MySize.size16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(MySize.size10),
            // height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width * 1,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MySize.size14),
              ),
              child: Container(
                height: MySize.size60,
                padding: EdgeInsets.all(MySize.size10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total: \$",
                          style: AppTheme.getTextStyle(
                            themeData.textTheme.headline6,
                            fontWeight: 600,
                          ),
                        ),
                        FutureBuilder(
                          future: futureTotal,
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                return Text(
                                  subtotal.toStringAsFixed(2),
                                  style: AppTheme.getTextStyle(
                                    themeData.textTheme.headline6,
                                    fontWeight: 600,
                                  ),
                                );
                              } else {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.35,
                                  child: Image.asset(
                                    "assets/images/no_data_found.jpg",
                                  ),
                                );
                              }
                            } else {
                              return Text(
                                "loading",
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.headline6,
                                  fontWeight: 600,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    // Container(
                    //   height: MySize.size140,
                    //   width: MySize.size120,
                    //   child: SvgPicture.asset(
                    //     "assets/icons/ShoppingCart.svg",
                    //   ),
                    // ),
                    from.city! != ""
                        ? Row(
                            children: [
                              Space.width(MySize.size10),
                              ElevatedButton(
                                onPressed: () {
                                  Map receiptData = {
                                    'senderId': from.id,
                                    'shipperName': from.name,
                                    'shipperAddress': from.address,
                                    'shipperPlace': from.apart,
                                    'shipperCity': from.city,
                                    'shipperPostalCode': from.zipCode,
                                    'shipperStateCode': from.state,
                                    'shipperAttentionName': from.name,
                                    'shipperPhoneNumber': from.phone,
                                    'recipientId': to.id,
                                    "shipToName": to.name,
                                    "shipToAttentionName": to.name,
                                    "shipToPhoneNumber": to.phone,
                                    'shipToEmail': to.email,
                                    'shipToAddress': to.address,
                                    'shipToPlace': to.apart,
                                    'shipToCity': to.city,
                                    'shipToPostalCode': to.zipCode,
                                    'shipToStateCode': to.state,
                                    'merchantName': ' John Doe',
                                    'amount': subtotal,
                                    'email': '',
                                    'Status': '',
                                    'credit': '',
                                    'createdTime': '',
                                    'transectionType': '',
                                    'authorizationStatus': '',
                                    'referenceId': '',
                                    'currencyCode': 'USD',
                                    // 'totalAmount': deliveryTotalCost,
                                    // 'totalCharged': deliveryTotalCost,
                                    // 'balance': '',
                                    // 'serviceName': deliveryService,
                                    // 'carrier': deliveryService!
                                    //     .split(' ')[0]
                                    //     .toUpperCase(),
                                    // "packageType": packageDimensions.title,
                                    // "packageWeight": weightController.text,
                                    // "resident": residential,
                                    // "packageLength": lengthController.text,
                                    // "packageWidth": widthController.text,
                                    // "packageHeight": heightController.text,
                                    // "declaredValue": insuraceController.text,
                                    // "saturdaycheck": saturdayDelivery,
                                    // "orderService": deliveryService,
                                    // "serviceCode": deliveryServiceCode,
                                    // 'daysInTransit': deliveryTime,
                                    "labelSlip": '',
                                    "trackingNumber": '',
                                  };

                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Payment(
                                            receiptData: receiptData,
                                            onFinish: (number) async {},
                                            transactionParams: getOrderParams(),
                                          ),
                                        ),
                                      )
                                      .then((value) => print(value));
                                },
                                child: Text("Checkout"),
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ),
          Space.height(MySize.size10),
        ],
      ),
    );
  }

  void _shippingBottomSheet(context, String shipping) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext buildContext) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 70),
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: themeData.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MySize.size16,
                  vertical: MySize.size16,
                  // bottom: 300,
                ),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: ,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Shipping to",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MySize.size20),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: MySize.size20,
                      thickness: 1,
                      // indent:MySize.size10,
                      // endIndent:MySize.size10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Add Address"),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _shippingAddressBottomSheet(context, shipping);
                            });
                          },
                          child: Text("Saved Address"),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Space.height(MySize.size8),
                        customTextField(
                          context,
                          fOrgController,
                          "",
                          "Organization",
                          TextInputType.name,
                        ),
                        Space.height(MySize.size8),
                        customTextField(
                          context,
                          fNameController,
                          "",
                          "Name",
                          TextInputType.name,
                        ),
                        Space.height(MySize.size8),
                        customTextField(
                          context,
                          fAddressController,
                          "",
                          "Address",
                          TextInputType.text,
                        ),
                        Space.height(MySize.size8),
                        customTextField(
                          context,
                          fApartController,
                          "",
                          "Apart/Building",
                          TextInputType.text,
                        ),
                        Space.height(MySize.size8),
                        customTextField(
                          context,
                          fCityController,
                          "",
                          "City",
                          TextInputType.text,
                        ),
                        Space.height(MySize.size8),
                        customTextField(
                          context,
                          fStateController,
                          "Short name i.e DC, NY, FL",
                          "State",
                          TextInputType.name,
                        ),
                        Space.height(MySize.size8),
                        customTextField(
                          context,
                          fZipController,
                          "",
                          "Zip Code",
                          TextInputType.number,
                        ),
                        Space.height(MySize.size8),
                        customTextField(
                          context,
                          fPhoneController,
                          "",
                          "Phone",
                          TextInputType.phone,
                        ),
                        Container(
                          width: MySize.safeWidth,
                          margin: EdgeInsets.only(top: MySize.size16),
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(MySize.size8)),
                              boxShadow: [
                                BoxShadow(
                                  color: themeData.colorScheme.primary
                                      .withAlpha(28),
                                  blurRadius: MySize.size4,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Container(
                              width: MySize.safeWidth,
                              height: MySize.size50,
                              child: ElevatedButton(
                                onPressed: () {
                                  from.organization = fOrgController.text;
                                  from.name = fNameController.text;
                                  from.address = fAddressController.text;
                                  from.apart = fApartController.text;
                                  from.city = fCityController.text;
                                  from.zipCode = fZipController.text;
                                  from.state = fStateController.text;
                                  from.phone = fPhoneController.text;

                                  setState(() {});

                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "SAVE",
                                  style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText2,
                                    fontSize: MySize.size18,
                                    fontWeight: 600,
                                    // letterSpacing: 0.2,
                                    color: themeData.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  ShippingModel from = new ShippingModel(city: ""),
      to = new ShippingModel(city: "");
  void _shippingAddressBottomSheet(context, String shipping) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext buildContext) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 70),
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: themeData.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: ,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MySize.size16,
                      vertical: MySize.size8,
                      // bottom: 300,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Shipping to",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MySize.size20),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    // indent:MySize.size10,
                    // endIndent:MySize.size10,
                  ),
                  Column(
                    children: [
                      FutureBuilder(
                        future: futureAddress,
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: ListView.builder(
                                  itemCount: (snapshot.data as List).length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: MySize.size6,
                                            vertical: MySize.size2,
                                          ),
                                          margin: EdgeInsets.symmetric(
                                            horizontal: MySize.size6,
                                            vertical: MySize.size2,
                                          ),
                                          child: Card(
                                            child: ListTile(
                                              onTap: () {
                                                from.id = (snapshot.data
                                                        as List)[index]["id"]
                                                    .toString();
                                                from.email = (snapshot.data
                                                        as List)[index]["email"]
                                                    .toString();

                                                fNameController.text =
                                                    (snapshot.data
                                                                as List)[index]
                                                            ["lastName"]
                                                        .toString();
                                                fOrgController.text =
                                                    (snapshot.data
                                                                as List)[index]
                                                            ["organization"]
                                                        .toString();
                                                fAddressController.text =
                                                    (snapshot.data
                                                                as List)[index]
                                                            ["address"]
                                                        .toString();
                                                fApartController.text =
                                                    (snapshot.data
                                                                as List)[index]
                                                            ["place"]
                                                        .toString();
                                                fCityController.text = (snapshot
                                                            .data
                                                        as List)[index]["city"]
                                                    .toString();
                                                fStateController.text =
                                                    (snapshot.data
                                                                as List)[index]
                                                            ["state"]
                                                        .toString();
                                                fZipController.text =
                                                    (snapshot.data
                                                                as List)[index]
                                                            ["zipCode"]
                                                        .toString();
                                                fPhoneController.text =
                                                    (snapshot.data
                                                                as List)[index]
                                                            ["phoneNumber"]
                                                        .toString();

                                                Navigator.pop(context);
                                              },
                                              // leading: CircleAvatar(),
                                              trailing: SizedBox.shrink(),
                                              title: Text(
                                                  (snapshot.data as List)[index]
                                                          ["lastName"]
                                                      .toString()),
                                              subtitle: Text((snapshot.data
                                                              as List)[index]
                                                          ["address"]
                                                      .toString() +
                                                  ", " +
                                                  (snapshot.data as List)[index]
                                                          ["city"]
                                                      .toString() +
                                                  ", " +
                                                  (snapshot.data as List)[index]
                                                          ["state"]
                                                      .toString() +
                                                  ", " +
                                                  (snapshot.data as List)[index]
                                                          ["zipCode"]
                                                      .toString()),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                child: Image.asset(
                                  "assets/images/no_data_found.jpg",
                                ),
                              );
                            }
                          } else {
                            return listViewSkeleton(context);
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget listViewSkeleton(BuildContext context) =>
      // ListView.builder(
      //       itemBuilder: (context, index) {
      //         return
      Container(
        padding: EdgeInsets.symmetric(
          vertical: MySize.size4,
          // horizontal: MySize.size10,
        ),
        child: ListTile(
          // tileColor: Colors.grey.shade100,
          leading: SkeletonContainer.square(
            height: MySize.size100,
            width: MySize.size100,
          ),
          title: SkeletonContainer.rounded(
            height: MySize.size22,
            width: MySize.size1 * 300,
          ),
          subtitle: SkeletonContainer.rounded(
            height: MySize.size18,
            width: MySize.size1 * 200,
          ),
        ),
      );

  Map<String, dynamic> getOrderParams() {
    String returnURL = 'return.example.com';
    String cancelURL = 'cancel.example.com';

    Map<dynamic, dynamic> defaultCurrency = {
      "symbol": "USD ",
      "decimalDigits": 2,
      "symbolBeforeTheNumber": true,
      "currency": "USD"
    };

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": subtotal.toStringAsFixed(2),
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subtotal.toStringAsFixed(2),
              // "shipping": shippingCost,
              // "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          // "item_list": {
          //   // "items": items,
          //   if (isEnableShipping && isEnableAddress)
          //     "shipping_address": {
          //       "recipient_name": userFirstName + " " + userLastName,
          //       "line1": addressStreet,
          //       "line2": "",
          //       "city": addressCity,
          //       "country_code": addressCountry,
          //       "postal_code": addressZipCode,
          //       "phone": addressPhoneNumber,
          //       "state": addressState
          //     },

          // }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }
}
