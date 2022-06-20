import 'dart:convert';
import 'package:aquatic_xpress_shipping/screens/user/profile/components/InProcess_Orders/InProcess_orders.dart';
import 'package:aquatic_xpress_shipping/screens/user/shipping_payment/print.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
// import 'package:aquatic_xpress_shipping/components/user_bottom_nav_bar.dart';
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
      resizeToAvoidBottomInset: false,
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
                      SizedBox(height: MySize.size5),
                      buildImage(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [

                            ],
                          ),

                          Container(
                            width: MySize.safeWidth * 0.7,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InProcess(),
                                  ),
                                );
                              },
                              child: Text("InProcess Orders"),
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
        height: MySize.size100 * 5,
        width: MySize.size100 * 5,
      ),
    );
  }

  setShip() async {

   var serviceCode= widget.receiptData['serviceCode'];
          var shipperName= widget.receiptData['shipperName'];
          var shipperAddress= widget.receiptData['shipperAddress'];
          var shipperPlace= widget.receiptData['shipperPlace'];
          var shipperCity= widget.receiptData['shipperCity'];
          var shipperPostalCode =widget.receiptData['shipperPostalCode'];
        var   shipperStateCode= widget.receiptData['shipperStateCode'];
          var shipperAttentionName= widget.receiptData['shipperAttentionName'];
          var shipperPhoneNumber= widget.receiptData['shipperPhoneNumber'];
          var shipToName=widget.receiptData["shipToName"];
          var shipToAttentionName= widget.receiptData["shipToAttentionName"];
          var shipToPhoneNumber= widget.receiptData["shipToPhoneNumber"];
          var shipToEmail= widget.receiptData['shipToEmail'];
          var shipToAddress= widget.receiptData['shipToAddress'];
          var shipToPlace= widget.receiptData['shipToPlace'];
          var shipToCity=  widget.receiptData['shipToCity'];
          var shipToPostalCode= widget.receiptData['shipToPostalCode'];
          var shipToStateCode= widget.receiptData['shipToStateCode'];
          var packageType=widget.receiptData['packageType'];
          var packageWeight= widget.receiptData['packageWeight'];
          bool resident= true;
          var packageLength = widget.receiptData['packageLength'];
          var packageWidth= widget.receiptData['packageWidth'];
          var packageHeight= widget.receiptData['packageHeight'];
          var declaredValue= widget.receiptData['declaredValue'];
          bool saturdaycheck= false;
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
          // "serviceCode": serviceCode.toString(),
          // 'shipperName': shipperName.toString(),
          // 'shipperAddress': shipperAddress.toString(),
          // 'shipperPlace': shipperPlace.toString(),
          // 'shipperCity': shipperCity.toString(),
          // 'shipperPostalCode': shipperPostalCode.toString(),
          // 'shipperStateCode': shipperStateCode.toString(),
          // 'shipperAttentionName': shipToAttentionName.toString(),
          // 'shipperPhoneNumber': shipperPhoneNumber.toString(),
          // "shipToName": shipToName.toString(),
          // "shipToAttentionName": shipToAttentionName.toString(),
          // "shipToPhoneNumber": shipToPhoneNumber.toString(),
          // 'shipToEmail': shipToEmail.toString(),
          // 'shipToAddress':shipToAddress.toString(),
          // 'shipToPlace': shipToPlace.toString(),
          // 'shipToCity': shipToCity.toString(),
          // 'shipToPostalCode': shipToPostalCode.toString(),
          // 'shipToStateCode': shipToStateCode.toString(),
          // "packageType": packageType.toString(),
          // "packageWeight": packageWeight.toString(),
          // "resident": true,
          // "packageLength": packageLength.toString(),
          // "packageWidth": packageWidth.toString(),
          // "packageHeight": packageHeight.toString(),
          // "declaredValue": declaredValue.toString(),
          // "saturdaycheck": false,

          // "serviceCode": widget.receiptData['serviceCode'],
          // 'shipperName': widget.receiptData['shipperName'],
          // 'shipperAddress': widget.receiptData['shipperAddress'],
          // 'shipperPlace': widget.receiptData['shipperPlace'],
          // 'shipperCity': widget.receiptData['shipperCity'],
          // 'shipperPostalCode': widget.receiptData['shipperPostalCode'],
          // 'shipperStateCode': widget.receiptData['shipperStateCode'],
          // 'shipperAttentionName': widget.receiptData['shipperName'],
          // 'shipperPhoneNumber': widget.receiptData['shipperPhoneNumber'],
          // "shipToName": widget.receiptData["shipToName"],
          // "shipToAttentionName": widget.receiptData["shipToAttentionName"],
          // "shipToPhoneNumber": widget.receiptData["shipToPhoneNumber"],
          // 'shipToEmail': widget.receiptData['shipToEmail'],
          // 'shipToAddress': widget.receiptData['shipToAddress'],
          // 'shipToPlace': widget.receiptData['shipToPlace'],
          // 'shipToCity': widget.receiptData['shipToCity'],
          // 'shipToPostalCode': widget.receiptData['shipToPostalCode'],
          // 'shipToStateCode': widget.receiptData['shipToStateCode'],
          // "packageType": widget.receiptData['packageType'],
          // "packageWeight": widget.receiptData['packageWeight'],
          // "resident": true,
          // "packageLength": widget.receiptData['packageLength'].toString(),
          // "packageWidth": widget.receiptData['packageWidth'].toString(),
          // "packageHeight": widget.receiptData['packageHeight'].toString(),
          // "declaredValue": widget.receiptData['declaredValue'].toString(),
          // "saturdaycheck": false,
          // widget.receiptData['saturdaycheck']

        "serviceCode": serviceCode,
        "shipperAddress": shipperAddress,
        "shipperPlace": shipperPlace,
        "shipperCity": shipperPostalCode,
        "shipperPostalCode": shipperPostalCode,
        "shipperStateCode": shipperStateCode,
        "shipperName": shipperName,
        "shipperAttentionName": shipperAttentionName,
        "shipperPhoneNumber": shipperAddress,
        "shipToAddress": shipToAddress,
        "shipToPlace":shipToPlace,
        "shipToCity": shipToCity,
        "shipToEmail": shipToEmail,
        "shipToPostalCode": shipToPostalCode,
        "shipToStateCode": shipToStateCode,
        "shipToName": shipToName,
        "shipToAttentionName": shipToAttentionName,
        "shipToPhoneNumber": shipToPhoneNumber,
        "packageType": "CUST",
        "packageWeight": packageWeight,
        "resident": resident,
        "packageLength": packageLength,
        "packageWidth": packageWidth,
        "packageHeight": packageHeight,
        "declaredValue": declaredValue,
        "saturdaycheck": saturdaycheck,
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
    String? id=await getUserName();

    String ?link = "${getCloudUrl()}/api/shipmentorder";
    var url = Uri.parse(link);
    DateTime now = DateTime.now();
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
         
        "Authorization": "Bearer $token",
        
      },
      body: jsonEncode({

"senderId": int.parse(widget.receiptData["senderId"]),
 "recipientId":int.parse(widget.receiptData["recipientId"]),
 "orderService": widget.receiptData["serviceCode"],
 "daysInTransit": widget.receiptData["daysInTransit"],
  "totalPrice": double.parse(widget.receiptData["totalAmount"]),
  "labelSlip": widget.receiptData["labelSlip"],
  "trackingNumber": widget.receiptData["trackingNumber"],
  "service": widget.receiptData["serviceName"],
  "serviceCode": widget.receiptData["serviceCode"],
  "shipperPostalCode": widget.receiptData["shipperPostalCode"],
  "shipperState": widget.receiptData["shipperStateCode"],
  "shippingToPostalCode": widget.receiptData["shipToPostalCode"],
  "shippingToState": widget.receiptData["shipToStateCode"],
 " weight": widget.receiptData["packageWeight"],
 "packageType": "CUST",
 "fromAddress": widget.receiptData["shipperAddress"],
 "toAddress": widget.receiptData["shipToAddress"],
 "upsServiceCharge": double.parse(widget.receiptData["totalAmount"]),
 "bill": "paid",
//  "margin": 0,
"status": widget.receiptData["status"],


 //////////////////////////////////////////
 
        // "senderId": int.parse(widget.receiptData['senderId']),
        // "recipientId": int.parse(widget.receiptData['recipientId']),
        // "orderService": widget.receiptData['orderService'],
        // "daysInTransit": widget.receiptData['daysInTransit'],
        // "totalPrice": double.parse(widget.receiptData['totalAmount']),
        // "labelSlip": widget.receiptData['labelSlip'],
        // "trackingNumber": widget.receiptData['trackingNumber'],
        // 'carrier': widget.receiptData['carrier'],
        // "serviceCode": widget.receiptData['serviceCode'],
        // 'serviceName': widget.receiptData['serviceName'],
        // "shipperState": widget.receiptData['shipperStateCode'],
        // "shipperPostalCode":widget.receiptData["shipperPostalCode"],
        // "shippingToPostalCode": widget.receiptData['shipToPostalCode'],
        // "shippingToState": widget.receiptData['shipToStateCode'],
        // "weight": widget.receiptData['packageWeight'],
        // "packageType": "CUST",
        // "fromAddress": widget.receiptData['shipperAddress'],
        // "toAddress": widget.receiptData['shipToAddress'],
        // "upsServiceCharge": double.parse(widget.receiptData['totalAmount']),
        // "bill": "paid"

        // 0312 2222005
        // Ans Ramay

      }),
    );
    print(response.statusCode);
    print(response.request);
    print("//////////////////////////////////////////////////////   "+ response.statusCode.toString()+'/////////////////////////////////////');
    if (response. statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      print("Exception");
      throw Error;
    }
  }
}
