import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:aquatic_xpress_shipping/components/user_bottom_nav_bar.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';

class GetReceipt extends StatefulWidget {
  final receiptData;

  const GetReceipt({Key? key, this.receiptData}) : super(key: key);

  @override
  _GetReceiptState createState() => _GetReceiptState();
}

class _GetReceiptState extends State<GetReceipt> {
  final controller = ScreenshotController();
  late Future futureReceipt;
  @override
  void initState() {
    super.initState();
    futureReceipt = setShip();
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Receipt"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(MySize.size20),
          child: FutureBuilder(
            future: futureReceipt,
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      SizedBox(height: MySize.size10),
                      buildImage(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: MySize.safeWidth * 0.7,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => User(),
                                  ),
                                );
                              },
                              child: Text("Dashboard"),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(MySize.size18),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Image.asset(
                      "assets/images/no_data_found.jpg",
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
        ),
      ),
    );
  }

  // Future<String> saveImage(Uint8List bytes) async {
  //   await [Permission.storage].request();
  //   // final time = DateTime.now()
  //   //     .toIso8601String()
  //   //     .replaceAll('.', '-')
  //   //     .replaceAll(':', '-');
  //   //     final File image = base64Decode(bytes);
  //   //     var

  //   // final result = await ImageGallerySaver.saveImage(Uint8List.fromList(bytes),
  //   //  quality: 60,
  //   // name: "hello");
  //   // String name = "Aquatic Xpress Shipping $time";
  //   // final directory = await getApplicationDocumentsDirectory();
  //   // final File newImage = await bytes.copy('$path/image1.png');
  //   // final image = File(directory:directory.path,name:name);
  //   // final result = await ImageGallerySaver.saveImage(bytes, name: name);
  //   // return result['filePath'];
  // }

  Widget buildImage() {
    return RotatedBox(
      quarterTurns: 1,
      child: Image.memory(
        base64Decode(widget.receiptData["labelSlip"]),
        height: MySize.size120 * 10,
        width: MySize.size120 * 5,
      ),
    );
  }

  setShip() async {
    String? token = await getToken();
    String ?link = "${getCloudUrl()}/api/ups/ship";
    var url = Uri.parse(link);
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(
        {
          "serviceCode": widget.receiptData['serviceCode'],
          'shipperName': widget.receiptData['shipperName'],
          'shipperAddress': widget.receiptData['shipperAddress'],
          'shipperPlace': widget.receiptData['shipperPlace'],
          'shipperCity': widget.receiptData['shipperCity'],
          'shipperPostalCode': widget.receiptData['shipperPostalCode'],
          'shipperStateCode': widget.receiptData['shipperStateCode'],
          'shipperAttentionName': widget.receiptData['shipperName'],
          'shipperPhoneNumber': widget.receiptData['shipperPhoneNumber'],
          "shipToName": widget.receiptData["shipToName"],
          "shipToAttentionName": widget.receiptData["shipToName"],
          "shipToPhoneNumber": widget.receiptData["shipToPhoneNumber"],
          'shipToEmail': widget.receiptData['shipToEmail'],
          'shipToAddress': widget.receiptData['shipToAddress'],
          'shipToPlace': widget.receiptData['shipToPlace'],
          'shipToCity': widget.receiptData['shipToCity'],
          'shipToPostalCode': widget.receiptData['shipToPostalCode'],
          'shipToStateCode': widget.receiptData['shipToStateCode'],
          "packageType": widget.receiptData['packageType'],
          "packageWeight": widget.receiptData['packageWeight'],
          "resident": widget.receiptData['resident'],
          "packageLength": widget.receiptData['packageLength'],
          "packageWidth": widget.receiptData['packageWidth'],
          "packageHeight": widget.receiptData['packageHeight'],
          "declaredValue": widget.receiptData['declaredValue'],
          "saturdaycheck": widget.receiptData['saturdaycheck'],

//  "serviceCode": "01",
//         "shipperAddress": "2805 W AGUA FRIA FWY",
//         "shipperPlace": "",
//         "shipperCity": "PHOENIX",
//         "shipperPostalCode": "85027",
//         "shipperStateCode": "AZ",
//         "shipperName": "Organization",
//         "shipperAttentionName": "Last Name",
//         "shipperPhoneNumber": "03023554482",
//         "shipToAddress": "10040 S 53RD AVE",
//         "shipToPlace": "",
//         "shipToCity": "OAK LAWN",
//         "shipToEmail": "",
//         "shipToPostalCode": "60453",
//         "shipToStateCode": "IL",
//         "shipToName": "J4 Flowerhorns, LLC",
//         "shipToAttentionName": "J4 Flowerhorns, LLC",
//         "shipToPhoneNumber": "7089546814",
//         "packageType": "4",
//         "packageWeight": "98",
//         "resident": true,
//         "packageLength": "11",
//         "packageWidth": "11",
//         "packageHeight": "11",
//         "declaredValue": "123",
//         "saturdaycheck": false,
        },
      ),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      widget.receiptData['labelSlip'] = data['labelimage'];
      widget.receiptData['trackingNumber'] = data['trackingNumber'];
      placeOrder();
      return data;
    } else {
      print("Exception");
      throw Error;
    }
  }

  placeOrder() async {
    String? token = await getToken();

    String ?link = "${getCloudUrl()}/api/shipmentorder";
    var url = Uri.parse(link);
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "senderId": int.parse(widget.receiptData['senderId']),
        "recipientId": int.parse(widget.receiptData['recipientId']),
        "orderService": widget.receiptData['orderService'],
        "daysInTransit": widget.receiptData['daysInTransit'],
        "totalPrice": double.parse(widget.receiptData['totalAmount']),
        "labelSlip": widget.receiptData['labelSlip'],
        "trackingNumber": widget.receiptData['trackingNumber'],
        'carrier': widget.receiptData['carrier'],
        "serviceCode": widget.receiptData['serviceCode'],
        'serviceName': widget.receiptData['serviceName'],
        "shipperState": widget.receiptData['shipperStateCode'],
        "shippingToPostalCode": widget.receiptData['shipToPostalCode'],
        "shippingToState": widget.receiptData['shipToStateCode'],
        "weight": widget.receiptData['packageWeight'],
        "packageType": widget.receiptData['packageType'],
        "fromAddress": widget.receiptData['shipperAddress'],
        "toAddress": widget.receiptData['shipToAddress'],
        "upsServiceCharge": double.parse(widget.receiptData['totalAmount']),
        "bill": "paid"

        // 0312 2222005
        // Ans Ramay
      }),
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
}
