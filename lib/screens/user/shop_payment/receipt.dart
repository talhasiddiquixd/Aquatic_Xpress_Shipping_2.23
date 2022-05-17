import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/screens/user/profile/components/history_orders/components/shop_orders.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';

class GetReceipt extends StatefulWidget {
  final receiptData;

  const GetReceipt({Key? key, this.receiptData}) : super(key: key);

  @override
  _GetReceiptState createState() => _GetReceiptState();
}

class _GetReceiptState extends State<GetReceipt> {
  final controller = ScreenshotController();
  late Future futurePlaceOrder;
  var themeData;

  @override
  void initState() {
    super.initState();
    futurePlaceOrder = placeOrder(widget.receiptData['senderId']);
  }

  @override
  Widget build(BuildContext context) {
    themeData = AppTheme.getThemeFromThemeMode(1);

    MySize().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop Order"),
      ),
      body: FutureBuilder(
        future: futurePlaceOrder,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ProductOrder();
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
                  child: Column(
                    children: [
                      Text(
                        "Placing Order",
                        style: AppTheme.getTextStyle(
                          themeData!.textTheme.caption,
                          color: themeData!.colorScheme.onPrimary,
                          fontWeight: 600,
                          letterSpacing: 0,
                        ),
                      ),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            );
          }
        },
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

  //   final result = await ImageGallerySaver.saveImage(Uint8List.fromList(bytes),
  //       //  quality: 60,
  //       name: "hello");
  //   // String name = "Aquatic Xpress Shipping $time";
  //   // final directory = await getApplicationDocumentsDirectory();
  //   // final File newImage = await bytes.copy('$path/image1.png');
  //   // final image = File(directory:directory.path,name:name);
  //   // final result = await ImageGallerySaver.saveImage(bytes, name: name);
  //   return result['filePath'];
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

  placeOrder(id) async {
    String? token = await getToken();
    String ?link =
        "${getCloudUrl()}/products/placeorder?id=$id";
    var url = Uri.parse(link);
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => HistoryOrders()));
      // // placeShipmentOrder();
      return data;
    } else {
      print("Exception");
      throw Error;
    }
  }

  placeShipmentOrder() async {
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
