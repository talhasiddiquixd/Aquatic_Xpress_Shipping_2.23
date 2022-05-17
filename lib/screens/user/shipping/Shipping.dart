import 'dart:convert';
import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:aquatic_xpress_shipping/components/custom_widgets/text_field.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/components/custom_widgets/skeleton_container.dart';
import 'package:aquatic_xpress_shipping/models/GeneralProvider.dart';
import 'package:aquatic_xpress_shipping/models/GenericModel.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:http/http.dart' as http;
import 'package:aquatic_xpress_shipping/screens/user/shipping_payment/Payment.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';

class Shipping extends StatefulWidget {
  static String routeName = "/Shipping";
  @override
  _ShippingState createState() => _ShippingState();
}

class _ShippingState extends State<Shipping> {
  String? selectedState;
  String? deliveryService = "";
  String? deliveryServiceCode = "";
  String? deliveryTime = "";
  String? deliveryCost = "";
  String? deliveryInsuranceCost = "";
  String? deliveryTotalCost = "";
  bool savedAddress = true;

  bool saturdayDelivery = false;
  bool shippingFrom = false, shippingTo = false, shippingMethodBool = false;

  var statesList = [
    {"name": "Alabama-AL"},
    {"name": "Alaska-AK"},
    {"name": "Arizona-AZ"},
    {"name": "Arkansas-AR"},
    {"name": "California-CA"},
    {"name": "Colorado-CO"},
    {"name": "Connecticut-CT"},
    {"name": "Delaware-DE"},
    {"name": "District Of Columbia-DC"},
    {"name": "Florida-FL"},
    {"name": "Georgia-GA"},
    {"name": "Hawaii-HI"},
    {"name": "Idaho-ID"},
    {"name": "Illinois-IL"},
    {"name": "Indiana-IN"},
    {"name": "Iowa-IA"},
    {"name": "Kansas-KS"},
    {"name": "Kentucky-KY"},
    {"name": "Louisiana-LA"},
    {"name": "Maine-ME"},
    {"name": "Maryland-MD"},
    {"name": "Massachusetts-MA"},
    {"name": "Michigan-MI"},
    {"name": "Minnesota-MN"},
    {"name": "Mississippi-MS"},
    {"name": "Missouri-MO"},
    {"name": "Montana-MT"},
    {"name": "Nebraska-NE"},
    {"name": "Nevada-NV"},
    {"name": "New Hampshire-NH"},
    {"name": "New Jersey-NJ"},
    {"name": "New Mexico-NM"},
    {"name": "New York-NY"},
    {"name": "North Carolina-NC"},
    {"name": "North Dakota-ND"},
    {"name": "Ohio-OH"},
    {"name": "Oklahoma-OK"},
    {"name": "Oregon-OR"},
    {"name": "Pennsylvania-PA"},
    {"name": "Rhode Island-RI"},
    {"name": "South Carolina-SC"},
    {"name": "South Dakota-SD"},
    {"name": "Tennessee-TN"},
    {"name": "Texas-TX"},
    {"name": "Utah-UT"},
    {"name": "Vermont-VT"},
    {"name": "Virginia-VA"},
    {"name": "Washington-WA"},
    {"name": "West Virginia-WV"},
    {"name": "Wisconsin-WI"},
    {"name": "Wyoming-WY"},
  ];
  var countriesList = [
    {
      "name": "United States",
      "code": "US",
      "icon": "assets/icons/Flag_US.svg",
    },
    // {
    //   "name": "Puerto Rico",
    //   "code": "PR",
    //   "icon": "assets/icons/Flag_PR.svg",
    // },
  ];
  String? fromCountry;
  String? fromState;

  TextEditingController fOrgController = new TextEditingController(),
      fNameController = new TextEditingController(),
      fAddressController = new TextEditingController(),
      fApartController = new TextEditingController(),
      fCityController = new TextEditingController(),
      fZipController = new TextEditingController(),
      fStateController = new TextEditingController(),
      fCountryController = new TextEditingController(),
      fPhoneController = new TextEditingController(),
      fEmailController = new TextEditingController(),
      tOrgController = new TextEditingController(),
      tNameController = new TextEditingController(),
      tAddressController = new TextEditingController(),
      tApartController = new TextEditingController(),
      tCityController = new TextEditingController(),
      tStateController = new TextEditingController(),
      tZipController = new TextEditingController(),
      tCountryController = new TextEditingController(),
      tPhoneController = new TextEditingController(),
      tEmailController = new TextEditingController(),
      heightController = new TextEditingController(),
      widthController = new TextEditingController(),
      lengthController = new TextEditingController(),
      weightController = new TextEditingController(),
      insuraceController = new TextEditingController();
  ShippingModel from = new ShippingModel(city: ""),
      to = new ShippingModel(city: "");

  PackageDimensions packageDimensions = new PackageDimensions(title: "CUST");

  late ThemeData themeData;

  bool fromNewAddress = false, toNewAddress = false, residential = false;

  Future? futurePrefBox;
  late List<String> cartQtyList;
  String? carrier;
  Future? futureToAddress;
  Future? futureFromAddress;
  Future? futureFedexShippingMethod;
  Future? futureUPSShippingMethod;
  int selectedAddress = 0;
  int selectedPayment = 0;

  Widget getTabContent(String text) {
    return Scaffold(
      body: Center(
        child: Text(
          text,
          style: AppTheme.getTextStyle(themeData.textTheme.subtitle1,
              fontWeight: 600),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void initState() {
    super.initState();
    futureToAddress = getToAddresses();
    futureFromAddress = getFromAddresses();
    futurePrefBox = getPrefBox();
    fCountryController.text = "US";
    tCountryController.text = "US";

    cartQtyList = ['Custom', 'Text Book'];
  }

  Widget divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: MySize.size2),
      child: Divider(
        height: MySize.size20,
        thickness: 1,
      ),
    );
  }

  getFedexShipping() async {
    String ?link = "${getCloudUrl()}/api/Fedex";
    var url = Uri.parse(link);
    String? token = await getToken();

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(
        {
          'declaredValue': insuraceController.text,
          'fromAddress': from.address,
          'fromCountry': to.country,
          'packageHeight': heightController.text,
          'packageLength': lengthController.text,
          'packageType': packageDimensions.title,
          'packageWidth': widthController.text,
          'saturdaycheck': saturdayDelivery,
          'shipperCity': from.city,
          'shipperPostalCode': from.zipCode,
          'shipperState': from.state,
          'shippingToCity': to.city,
          'shippingToPostalCode': to.zipCode,
          'shippingToState': to.state,
          'toAddress': to.address,
          'toCountry': to.country,
          'weight': weightController.text
        },
      ),
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

  getPrefBox() async {
    String ?link = "${getCloudUrl()}/api/BoxPref";
    var url = Uri.parse(link);
    String? token = await getToken();

    var response = await http.get(
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
      return data;
    } else {
      print("Exception");
      throw Error;
    }
  }

  getUPSShipping() async {
    String ?link ="${getCloudUrl()}/api/ups" ;
    // "${getCloudUrl()}/api/ups/";
    var url = Uri.parse(link);
    String? token = await getToken();

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(
        {

//           "declaredValue": "101",
// "fromAddress": "5381 LINDERO PL",
// "fromCountry": "US",
// "packageHeight": "10",
// "packageLength": "10",
// "packageType": "CUST",
// "packageWidth": "10",
// "saturdaycheck": false,
// "shipperCity": "LAS VEGAS",
// "shipperPostalCode": "89119",
// "shipperState": "NV",
// "shippingToCity": "OAK LAWN",
// "shippingToPostalCode": "60453",
// "shippingToState": "IL",
// "toAddress": "10040 S 53RD AVE",
// "toCountry": "US",
// "weight": "10"
          "declaredValue": insuraceController.text.toString(),
          'fromAddress': from.address.toString(),
          'fromCountry': from.country.toString(),
          'packageHeight': heightController.text.toString(),
          'packageLength': lengthController.text.toString(),
          'packageType': "CUST",
          // packageDimensions.title.toString(),
          'packageWidth': widthController.text.toString(),
          'saturdaycheck': saturdayDelivery,
          'shipperCity': from.city.toString(),
          'shipperPostalCode': from.zipCode.toString(),
          'shipperState': from.state.toString(),
          'shippingToCity': to.city.toString(),
          'shippingToPostalCode': to.zipCode.toString(),
          'shippingToState': to.state.toString(),
          'toAddress': to.address.toString(),
          'toCountry': to.country.toString(),
          'weight': weightController.text.toString(),
        },
      ),
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

  @override
  Widget build(BuildContext context) {
    themeData = themeData = Theme.of(context);
    

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Shipping'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: MySize.size10,
            left: MySize.size16,
            right: MySize.size16,
            bottom: MySize.size10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MySize.size14),
                  ),
                  elevation: MySize.size16,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MySize.size20,
                      vertical: MySize.size10,
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          // splashColor:
                          // Color.lerp(Colors.greenAccent, Colors.grey, 11),
                          onTap: () {
                            _shippingBottomSheet(context, "from");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              svgPicLoader("assets/icons/ShippingFrom.svg"),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  from.city! == ""
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Shipping from",
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.bodyText1,
                                                // fontSize: Mysize,
                                                fontWeight: 600,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  from.city! == ""
                                      ? Text(
                                          "Tap here to set origin",
                                          style: AppTheme.getTextStyle(
                                            themeData.textTheme.subtitle2,
                                          ),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              from.name!,
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.bodyText1,
                                                fontSize: MySize.size16,
                                                fontWeight: 600,
                                              ),
                                            ),
                                            Text(
                                              from.address! + " " + from.city!,
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.bodyText1,
                                                // fontSize: Mysize,
                                                fontWeight: 400,
                                              ),
                                              softWrap: true,
                                            ),
                                            Text(
                                              from.state! + " " + from.zipCode!,
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.bodyText1,
                                                fontWeight: 400,
                                              ),
                                            ),
                                          ],
                                        )
                                ],
                              ),
                            ],
                          ),
                        ),
                        divider(),
                        InkWell(
                          onTap: () {
                            _shippingBottomSheet(context, "to");
                          },
                          child: Row(
                            children: [
                              svgPicLoader("assets/icons/ShippingTo.svg"),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  to.city! == ""
                                      ? Text(
                                          "Shipping to",
                                          style: AppTheme.getTextStyle(
                                            themeData.textTheme.bodyText1,
                                            fontWeight: 600,
                                          ),
                                        )
                                      : Container(),
                                  to.city! == ""
                                      ? Text(
                                          "Tap here to set Destination",
                                          style: AppTheme.getTextStyle(
                                            themeData.textTheme.subtitle2,
                                          ),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              to.name!,
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.bodyText1,
                                                fontSize: MySize.size16,
                                                fontWeight: 600,
                                              ),
                                            ),
                                            Text(
                                              to.address! + " " + to.city!,
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.bodyText1,
                                                fontWeight: 400,
                                              ),
                                              softWrap: true,
                                            ),
                                            Text(
                                              to.state! + " " + to.zipCode!,
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.bodyText1,
                                                fontWeight: 400,
                                              ),
                                            ),
                                          ],
                                        )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // divider(),
              Container(
                padding: EdgeInsets.only(
                  top: MySize.size10,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MySize.size14),
                  ),
                  elevation: MySize.size16,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MySize.size20,
                      vertical: MySize.size10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pref Box",
                              style: AppTheme.getTextStyle(
                                themeData.textTheme.headline6,
                                fontWeight: 600,
                                letterSpacing: 0,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _boxBottomSheet(context);
                              },
                              icon: Icon(
                                Icons.list,
                              ),
                            )
                          ],
                        ),
                        packageDimensions.title! != "CUST"
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: MySize.size5,
                                ),
                                child: Text(
                                  packageDimensions.title!,
                                  style: AppTheme.getTextStyle(
                                    themeData.textTheme.subtitle1,
                                  ),
                                ),
                              )
                            : Container(),

                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: customTextField(
                                context,
                                heightController,
                                "Inch",
                                "Height",
                                TextInputType.number,
                              ),
                            ),
                            SizedBox(width: MySize.size5),
                            Expanded(
                              child: customTextField(
                                context,
                                widthController,
                                "Inch",
                                "Width",
                                TextInputType.number,
                              ),
                            ),
                            SizedBox(width: MySize.size5),
                            Expanded(
                              child: customTextField(
                                context,
                                lengthController,
                                "Inch",
                                "Length",
                                TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: MySize.size5),
                        Row(
                          children: [
                            // Expanded(
                            //   child: customerTextFieldNumericc(
                            //       heightController, "", "Height (inch)"),
                            // ),
                            // SizedBox(width: MySize.size5),
                            Expanded(
                              child: customTextField(
                                context,
                                weightController,
                                "lb",
                                "Weight",
                                TextInputType.number,
                              ),
                            ),
                            SizedBox(width: MySize.size5),
                            Expanded(
                              child: customTextField(
                                context,
                                insuraceController,
                                "Min \$101 Value",
                                "Insurance",
                                TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        divider(),
                        InkWell(
                          onTap: () {
                            setState(() {
                              saturdayDelivery =
                                  saturdayDelivery == true ? false : true;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Saturday Delivery On?",
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.subtitle2,
                                    fontWeight: 600,
                                    letterSpacing: 0),
                              ),
                              Switch(
                                onChanged: (bool value) {
                                  setState(() {
                                    saturdayDelivery = value;
                                  });
                                },
                                value: saturdayDelivery,
                                activeColor: themeData.colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                        // Text(
                        //   "Live Arrival Insurance",
                        //   style: AppTheme.getTextStyle(
                        //     themeData.textTheme.headline6,
                        //     fontWeight: 600,
                        //     letterSpacing: 0,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: MySize.size5,
                        // ),
                        // Row(
                        //   // crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Expanded(
                        //       child: customerTextFieldNumericc(
                        //         insuraceController,
                        //         "Minimum \$101 Value",
                        //         "Declared Value",
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              shippingTo & shippingFrom
                  ? Container(
                      padding: EdgeInsets.only(top: MySize.size10),
                      child: InkWell(
                        onTap: () {
                          if (heightController.text != '' &&
                              widthController.text != '' &&
                              lengthController.text != '' &&
                              weightController.text != '') {
                            // futureFedexShippingMethod = getFedexShipping();
                            futureUPSShippingMethod = getUPSShipping();
                            _shippingMethodBottomSheet(context);
                          } else {
                            Flushbar(
                              title: "Emptry Fields",
                              message:
                                  "Please enter height, width, length and weight of Box",
                              duration: Duration(seconds: 3),
                            )..show(context);
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(MySize.size14),
                          ),
                          elevation: MySize.size16,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: MySize.size20,
                              vertical: MySize.size10,
                            ),
                            // height:MySize.size100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Shipping Method",
                                      style: AppTheme.getTextStyle(
                                        themeData.textTheme.headline6,
                                        fontWeight: 600,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    deliveryService != ""
                                        ? Text(
                                            deliveryService.toString(),
                                            style: AppTheme.getTextStyle(
                                              themeData.textTheme.headline6,
                                              fontWeight: 500,
                                              letterSpacing: 0,
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                                SizedBox(
                                  height: MySize.size10,
                                ),
                                deliveryCost != ""
                                    ? Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Insurance Charges",
                                                style: AppTheme.getTextStyle(
                                                  themeData.textTheme.subtitle2,
                                                  fontWeight: 600,
                                                ),
                                              ),
                                              Text(
                                                "\$" +
                                                    double.parse(
                                                            deliveryInsuranceCost
                                                                .toString())
                                                        .toStringAsFixed(2),
                                                style: AppTheme.getTextStyle(
                                                  themeData.textTheme.subtitle2,
                                                  fontWeight: 600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Shipping Charges",
                                                style: AppTheme.getTextStyle(
                                                  themeData.textTheme.subtitle2,
                                                  fontWeight: 600,
                                                ),
                                              ),
                                              Text(
                                                "\$" +
                                                    double.parse(deliveryCost
                                                            .toString())
                                                        .toStringAsFixed(2),
                                                style: AppTheme.getTextStyle(
                                                  themeData.textTheme.subtitle2,
                                                  fontWeight: 600,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Total Amount",
                                                style: AppTheme.getTextStyle(
                                                  themeData.textTheme.subtitle2,
                                                  fontWeight: 600,
                                                ),
                                              ),
                                              Text(
                                                "\$" +
                                                    double.parse(
                                                            deliveryTotalCost
                                                                .toString())
                                                        .toStringAsFixed(2),
                                                style: AppTheme.getTextStyle(
                                                  themeData.textTheme.subtitle2,
                                                  fontWeight: 600,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Text(
                                        "Tap here to set",
                                        style: AppTheme.getTextStyle(
                                          themeData.textTheme.subtitle2,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              shippingMethodBool
                  ? Container(
                      padding: EdgeInsets.only(top: MySize.size10),
                      child: InkWell(
                        onTap: () async {
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
                            'amount': deliveryTotalCost,
                            'email': '',
                            'Status': '',
                            'credit': '',
                            'createdTime': '',
                            'transectionType': '',
                            'authorizationStatus': '',
                            'referenceId': '',
                            'currencyCode': 'USD',
                            'totalAmount': deliveryTotalCost,
                            'totalCharged': deliveryTotalCost,
                            'balance': '',
                            'serviceName': deliveryService,
                            'carrier':
                                deliveryService!.split(' ')[0].toUpperCase(),
                            "packageType": packageDimensions.title,
                            "packageWeight": weightController.text,
                            "resident": residential,
                            "packageLength": lengthController.text,
                            "packageWidth": widthController.text,
                            "packageHeight": heightController.text,
                            "declaredValue": insuraceController.text,
                            "saturdaycheck": saturdayDelivery,
                            "orderService": deliveryService,
                            "serviceCode": deliveryServiceCode,
                            'daysInTransit': deliveryTime,
                            "labelSlip": '',
                            "trackingNumber": '',
                          };

                          Provider.of<GeneralProvider>(context, listen: false)
                              .receiptData = receiptData;

                          await Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => Payment(
                                    receiptData: receiptData,
                                    onFinish: (number) async {},
                                    transactionParams: getOrderParams(),
                                  ),
                                ),
                              )
                              .then((value) => print(value));

                          // var request = BraintreeDropInRequest();

                          // _paymentMethodBottomSheet(context);
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) {
                          //   return makePayment();
                          // }));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(MySize.size14),
                          ),
                          elevation: MySize.size16,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: MySize.size20,
                              vertical: MySize.size10,
                            ),
                            // height:MySize.size100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Payment Details",
                                      style: AppTheme.getTextStyle(
                                        themeData.textTheme.headline6,
                                        fontWeight: 600,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: MySize.size10,
                                ),
                                Text(
                                  "Tap here to set",
                                  style: AppTheme.getTextStyle(
                                    themeData.textTheme.subtitle2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.shipping),
    );
  }

  void _shippingBottomSheet(context, String shipping) {
    double height = MySize.size6;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext buildContext) {
        return StatefulBuilder(builder: (
          BuildContext context,
          StateSetter modalSetState,
        ) {
          return Container(
            margin: EdgeInsets.only(top: MySize.size40),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: themeData.colorScheme.background,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(MySize.size16),
                    topRight: Radius.circular(MySize.size16))),
            child: Padding(
              padding: EdgeInsets.only(
                top: MySize.size10,
                left: MySize.size20,
                right: MySize.size20,
                // bottom: 300,
              ),
              child: ListView(
                // mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: ,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        shipping == "from" ? "Shipping from" : "Shipping to",
                        style: AppTheme.getTextStyle(
                          themeData.textTheme.bodyText1,
                          fontSize: MySize.size20,
                          fontWeight: 700,
                        ),
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
                  Divider(thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Add Address"),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(MySize.size18),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          modalSetState(() {
                            _shippingAddressBottomSheet(context, shipping);
                          });
                        },
                        child: Text("Saved Address"),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(MySize.size18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        customTextField(
                          context,
                          shipping == "from" ? fOrgController : tOrgController,
                          "",
                          "Organization",
                          TextInputType.name,
                        ),
                        Space.height(height),
                        customTextField(
                          context,
                          shipping == "from"
                              ? fNameController
                              : tNameController,
                          "",
                          "Name",
                          TextInputType.name,
                        ),
                        Space.height(height),
                        customTextField(
                          context,
                          shipping == "from"
                              ? fAddressController
                              : tAddressController,
                          "",
                          "Address",
                          TextInputType.streetAddress,
                        ),
                        Space.height(height),
                        customTextField(
                          context,
                          shipping == "from"
                              ? fApartController
                              : tApartController,
                          "",
                          "Apart/Building",
                          TextInputType.streetAddress,
                        ),
                        Space.height(height),
                        customTextField(
                            context,
                            shipping == "from"
                                ? fCityController
                                : tCityController,
                            "",
                            "City",
                            TextInputType.streetAddress),
                        Space.height(height),
                        customTextField(
                          context,
                          shipping == "from"
                              ? fStateController
                              : tStateController,
                          "Short name i.e DC, NY, FL",
                          "State",
                          TextInputType.streetAddress,
                        ),
                        Space.height(height),
                        customTextField(
                            context,
                            shipping == "from"
                                ? fZipController
                                : tZipController,
                            "",
                            "Zip Code",
                            TextInputType.number),
                        Space.height(height),
                        customTextField(
                          context,
                          shipping == "from"
                              ? fCountryController
                              : tCountryController,
                          "US or PR",
                          "Country",
                          TextInputType.text,
                        ),
                        Space.height(height),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'New Address?',
                                  style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText1,
                                  ),
                                ),
                                Switch(
                                  onChanged: (bool value) {
                                    modalSetState(() {
                                      fromNewAddress = value;
                                    });
                                  },
                                  value: fromNewAddress,
                                  activeColor: themeData.colorScheme.primary,
                                ),
                              ],
                            ),
                            shipping == "to"
                                ? Row(
                                    children: [
                                      Text('Residential?'),
                                      Switch(
                                        onChanged: (bool value) {
                                          modalSetState(() {
                                            residential = value;
                                          });
                                        },
                                        value: residential,
                                        activeColor:
                                            themeData.colorScheme.primary,
                                      ),
                                    ],
                                  )
                                : Container()

                            // ElevatedButton(
                            //   onPressed: () {},
                            //   child: Text("Get Weather"),
                            //   style: ButtonStyle(
                            //     shape: MaterialStateProperty.all<
                            //         RoundedRectangleBorder>(
                            //       RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(18.0),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        Space.height(height),
                        customTextField(
                            context,
                            shipping == "from"
                                ? fPhoneController
                                : tPhoneController,
                            "",
                            "Phone",
                            TextInputType.phone),
                        Space.height(height),
                        shipping == "to"
                            ? customTextField(
                                context,
                                tEmailController,
                                "",
                                "Email",
                                TextInputType.emailAddress,
                              )
                            : Container(),
                        Space.height(height),
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
                                  if (shipping == "from") {
                                    shippingFrom = true;
                                    from.organization = fOrgController.text;
                                    from.name = fNameController.text;
                                    from.address = fAddressController.text;
                                    from.apart = fApartController.text;
                                    from.city = fCityController.text;
                                    from.zipCode = fZipController.text;
                                    from.state = fStateController.text;
                                    from.country = fCountryController.text;
                                    from.phone = fPhoneController.text;

                                    // f.email = tEmailController.text;
                                  } else {
                                    shippingTo = true;
                                    to.organization = tOrgController.text;
                                    to.name = tNameController.text;
                                    to.address = tAddressController.text;
                                    to.apart = tApartController.text;
                                    to.city = tCityController.text;
                                    to.zipCode = tZipController.text;
                                    to.state = tStateController.text;
                                    to.country = tCountryController.text;

                                    to.phone = tPhoneController.text;
                                    to.email = tEmailController.text;
                                  }
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
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

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
                  color: themeData.backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: ,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: MySize.size10,
                      left: MySize.size24,
                      right: MySize.size24,
                      // bottom: 300,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          shipping == "from" ? "Shipping from" : "Shipping to",
                          style: AppTheme.getTextStyle(
                            themeData.textTheme.bodyText1,
                            fontWeight: 700,
                            fontSize: MySize.size20,
                          ),
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
                    height: MySize.size20,
                    thickness: 1,
                    // indent:MySize.size10,
                    // endIndent:MySize.size10,
                  ),
                  FutureBuilder(
                    future: shipping == "from"
                        ? futureFromAddress
                        : futureToAddress,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: ListView.builder(
                              itemCount: (snapshot.data as List).length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: EdgeInsets.fromLTRB(
                                    MySize.size10,
                                    MySize.size2,
                                    MySize.size10,
                                    MySize.size2,
                                  ),
                                  child: Card(
                                    elevation: 15,
                                    clipBehavior: Clip.antiAlias,
                                    // shape: RoundedRectangleBorder(
                                    //   borderRadius: new BorderRadius.circular(
                                    //       MySize.size20),
                                    // ),
                                    child: ListTile(
                                      onTap: () {
                                        if (shipping == "from") {
                                          from.id = (snapshot.data
                                                  as List)[index]["id"]
                                              .toString();
                                          from.email = (snapshot.data
                                                  as List)[index]["email"]
                                              .toString();

                                          fNameController.text = (snapshot.data
                                                  as List)[index]["lastName"]
                                              .toString();
                                          fOrgController.text =
                                              (snapshot.data as List)[index]
                                                      ["organization"]
                                                  .toString();
                                          fAddressController.text =
                                              (snapshot.data as List)[index]
                                                      ["address"]
                                                  .toString();
                                          fApartController.text = (snapshot.data
                                                  as List)[index]["place"]
                                              .toString();
                                          fCityController.text = (snapshot.data
                                                  as List)[index]["city"]
                                              .toString();
                                          fStateController.text = (snapshot.data
                                                  as List)[index]["state"]
                                              .toString();
                                          // fCountryController.text =
                                          //     (snapshot.data as List)[index]
                                          //             ["country"]
                                          //         .toString();
                                          fZipController.text = (snapshot.data
                                                  as List)[index]["zipCode"]
                                              .toString();
                                          fPhoneController.text = (snapshot.data
                                                  as List)[index]["phoneNumber"]
                                              .toString();
                                        } else {
                                          to.id = (snapshot.data as List)[index]
                                                  ["id"]
                                              .toString();
                                          to.email = (snapshot.data
                                                  as List)[index]["email"]
                                              .toString();
                                          tEmailController.text = (snapshot.data
                                                  as List)[index]["email"]
                                              .toString();
                                          tNameController.text = (snapshot.data
                                                  as List)[index]["lastName"]
                                              .toString();
                                          tOrgController.text =
                                              (snapshot.data as List)[index]
                                                      ["organization"]
                                                  .toString();
                                          tAddressController.text =
                                              (snapshot.data as List)[index]
                                                      ["address"]
                                                  .toString();
                                          tApartController.text = (snapshot.data
                                                  as List)[index]["place"]
                                              .toString();
                                          tCityController.text = (snapshot.data
                                                  as List)[index]["city"]
                                              .toString();
                                          tStateController.text = (snapshot.data
                                                  as List)[index]["state"]
                                              .toString();
                                          // tCountryController.text =
                                          //     (snapshot.data as List)[index]
                                          //             ["country"]
                                          //         .toString();
                                          tZipController.text = (snapshot.data
                                                  as List)[index]["zipCode"]
                                              .toString();
                                          tPhoneController.text = (snapshot.data
                                                  as List)[index]["phoneNumber"]
                                              .toString();
                                        }
                                        Navigator.pop(context);
                                      },
                                      // leading: CircleAvatar(),
                                      trailing: SizedBox.shrink(),
                                      title: Text(
                                        (snapshot.data as List)[index]
                                                ["lastName"]
                                            .toString(),
                                        // style: AppTheme.getTextStyle(
                                        //   themeData.textTheme.headline6,
                                        //   fontWeight: 600,
                                        //   letterSpacing: 0,
                                        // ),
                                      ),
                                      subtitle: Text(
                                        (snapshot.data as List)[index]
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
                                                .toString(),
                                        // style: AppTheme.getTextStyle(
                                        //   themeData.textTheme.headline6,
                                        //   fontWeight: 600,
                                        //   letterSpacing: 0,
                                        // ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
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
                        return listViewWithoutLeadingPictureWithExpandedSkeleton(
                            context);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  getToAddresses() async {
    // quickQuote = 0;
    // curl();
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

  getFromAddresses() async {
    // quickQuote = 0;
    // curl();
    String? token = await getToken();

    String ?link = "${getCloudUrl()}/api/UserAddress";
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

  void _boxBottomSheet(context) {
    var packageList = [
      {
        "title": "Card Envelop",
        "length": "35.00",
        "width": "27.50",
        "height": "2.00",
        "weight": "0.50",
        "icon": "assets/icons/Card Envelop.svg",
      },
      {
        "title": "Flyer",
        "length": "40.00",
        "width": "30.50",
        "height": "1.00",
        "weight": "0.10",
        "icon": "assets/icons/Flyer.svg",
      },
      {
        "title": "Box 2 (Shoe Box)",
        "length": "34.00",
        "width": "19.50",
        "height": "11.00",
        "weight": "1.50",
        "icon": "assets/icons/Box2.svg",
      },
      {
        "title": "Box 3",
        "length": "33.70",
        "width": "32.20",
        "height": "20.00",
        "weight": "2.00",
        "icon": "assets/icons/Box3.svg",
      },
      {
        "title": "Box 4",
        "length": "33.70",
        "width": "32.20",
        "height": "18.00",
        "weight": "5.00",
        "icon": "assets/icons/Box4.svg",
      },
      {
        "title": "Box 5",
        "length": "34.00",
        "width": "33.00",
        "height": "35.00",
        "weight": "1.00",
        "icon": "assets/icons/Box5.svg",
      },
      {
        "title": "Box 6",
        "length": "41.70",
        "width": "35.90",
        "height": "36.90",
        "weight": "15.00",
        "icon": "assets/icons/Box6.svg",
      },
      {
        "title": "Box 7",
        "length": "48.10",
        "width": "40.40",
        "height": "38.90",
        "weight": "20.20",
        "icon": "assets/icons/Box7.svg",
      },
      {
        "title": "Box 8",
        "length": "55.00",
        "width": "45.50",
        "height": "41.00",
        "weight": "25.00",
        "icon": "assets/icons/Box8.svg",
      },
      {
        "title": "Tube",
        "length": "97.60",
        "width": "17.60",
        "height": "15.20",
        "weight": "5.00",
        "icon": "assets/icons/Tube.svg",
      },
    ];
    // Map person={'name':'Bijay',"age":20};
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext buildContext) {
          return Container(
            margin: EdgeInsets.only(top: 70),
            padding: EdgeInsets.symmetric(
              horizontal: MySize.size16,
              vertical: MySize.size16,
            ),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: themeData.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(MySize.size16),
                    topRight: Radius.circular(MySize.size16))),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: ,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pref Box",
                      style: AppTheme.getTextStyle(
                        themeData.textTheme.subtitle1,
                        fontSize: MySize.size20,
                        fontWeight: 600,
                        letterSpacing: 0,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: themeData.colorScheme.onBackground,
                      ),
                    )
                  ],
                ),
                Divider(
                  height: MySize.size20,
                  thickness: MySize.size2,
                  // indent:MySize.size10,
                  // endIndent:MySize.size10,
                ),
                FutureBuilder(
                  future: futurePrefBox,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: (snapshot.data as List).length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: MySize.size5),
                                child: GestureDetector(
                                  onTap: () {
                                    //                                         "id": 4,
                                    // "name": "Test Box",
                                    // "length": "11",
                                    // "width": "11",
                                    // "height": "11",
                                    // "code": "02",
                                    // "userId": "32e2fa6f-7e51-4d8d-b547-07c19ddfafb8",
                                    // "user": null
                                    packageDimensions.title =
                                        (snapshot.data as List)[index]['name']
                                            .toString();

                                    packageDimensions.length = double.parse(
                                        (snapshot.data as List)[index]['length']
                                            .toString());

                                    packageDimensions.width = double.parse(
                                        (snapshot.data as List)[index]['width']
                                            .toString());

                                    packageDimensions.height = double.parse(
                                        (snapshot.data as List)[index]['height']
                                            .toString());

                                    widthController.text =
                                        (snapshot.data as List)[index]['width']
                                            .toString();
                                    heightController.text =
                                        (snapshot.data as List)[index]['height']
                                            .toString();
                                    lengthController.text =
                                        (snapshot.data as List)[index]['height']
                                            .toString();

                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  child: Card(
                                    elevation: 3,
                                    child: Container(
                                      padding: EdgeInsets.all(MySize.size10),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                right: MySize.size5),
                                            height: MySize.size60,
                                            width: MySize.size60,
                                            child: svgPicLoader(packageList[5]
                                                    ['icon']
                                                .toString()),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                (snapshot.data as List)[index]
                                                        ['name']
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: MySize.size16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'H' +
                                                    (snapshot.data
                                                                as List)[index]
                                                            ['height']
                                                        .toString() +
                                                    " X " +
                                                    'L' +
                                                    (snapshot.data
                                                                as List)[index]
                                                            ['length']
                                                        .toString() +
                                                    " X " +
                                                    'W' +
                                                    (snapshot.data
                                                                as List)[index]
                                                            ['width']
                                                        .toString() +
                                                    "(Inches)",
                                                style: TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    ),
                                                maxLines: 3,
                                                softWrap: true,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
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
                      return listViewWithLeadingPictureWithExpandedSkeleton(
                          context);
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget shippingMethod(futureShippingMethod) {
    return FutureBuilder(
      future: futureShippingMethod,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return (snapshot.data as List).length != 0
                ? Container(
                    color: themeData.backgroundColor,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                      itemCount: (snapshot.data as List).length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(MySize.size5,
                                  MySize.size2, MySize.size5, MySize.size2),
                              child: InkWell(
                                onTap: () {
                                  shippingMethodBool = true;
                                  deliveryServiceCode = (snapshot.data
                                          as List)[index]['serviceCode']
                                      .toString();
                                  deliveryService = (snapshot.data
                                          as List)[index]['shippingMethod']
                                      .toString();
                                  deliveryCost = (snapshot.data as List)[index]
                                          ['yourCost']
                                      .toString();
                                  deliveryTime = (snapshot.data as List)[index]
                                              ['day']
                                          .toString() +
                                      " " +
                                      (snapshot.data as List)[index]
                                              ['daysInTransit']
                                          .toString();
                                  deliveryInsuranceCost = (snapshot.data
                                          as List)[index]['declaredValue']
                                      .toString();
                                  deliveryTotalCost = (double.parse(
                                              deliveryCost.toString()) +
                                          double.parse(
                                              deliveryInsuranceCost.toString()))
                                      .toString();
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                                child: Card(
                                  color: themeData.colorScheme.background,
                                  elevation: 3,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Cost: \$' +
                                                  (snapshot.data as List)[index]
                                                          ['yourCost']
                                                      .toString(),
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.subtitle2,
                                                fontWeight: 600,
                                                // color: themeData.colorScheme.primary,
                                              ),
                                            ),
                                            Text(
                                              'Retail: \$' +
                                                  (snapshot.data as List)[index]
                                                          ['retailPrice']
                                                      .toString(),
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.subtitle2,
                                                fontWeight: 600,
                                                // color: themeData.colorScheme.primary,
                                              ),
                                            ),
                                            Text(
                                              'Savings: \$' +
                                                  (snapshot.data as List)[index]
                                                          ['youSave']
                                                      .toString(),
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.subtitle2,
                                                fontWeight: 600,
                                                color: themeData
                                                    .colorScheme.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Transit Time: ',
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.subtitle2,
                                                fontWeight: 700,
                                                // color: themeData.colorScheme.primary,
                                              ),
                                            ),
                                            Text(
                                              (snapshot.data as List)[index]
                                                          ['day']
                                                      .toString() +
                                                  " " +
                                                  (snapshot.data as List)[index]
                                                          ['daysInTransit']
                                                      .toString(),
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.subtitle2,
                                                fontWeight: 500,
                                                // color: themeData.colorScheme.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Shipping Method: ',
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.subtitle2,
                                                fontWeight: 600,
                                                // color: themeData.colorScheme.primary,
                                              ),
                                            ),
                                            Text(
                                              (snapshot.data as List)[index]
                                                      ['shippingMethod']
                                                  .toString(),
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.subtitle2,
                                                fontWeight: 500,
                                                // color: themeData.colorScheme.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Image.asset(
                      "assets/images/no_data_found.jpg",
                    ),
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
          return listViewWithoutLeadingPictureWithoutExpandedSkeleton(context);
        }
      },
    );
  }

  void _shippingMethodBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext buildContext) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 70),
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: themeData.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(MySize.size16),
                  topRight: Radius.circular(MySize.size16),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: MySize.size16,
                ),
                child: DefaultTabController(
                  length: 1,
                  initialIndex: 0,
                  child: Scaffold(
                    backgroundColor: themeData.colorScheme.background,
                    appBar: AppBar(
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: themeData.iconTheme.color,
                          ),
                        )
                      ],
                      leading: Container(),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      flexibleSpace: new Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          /*-------------- Build Tabs here ------------------*/
                          new TabBar(
                            isScrollable: true,
                            tabs: [
                              Tab(
                                  child: Text("UPS",
                                      style: AppTheme.getTextStyle(
                                          themeData.textTheme.subtitle1,
                                          fontWeight: 600))),
                              // Tab(
                              //     child: Text("Fedex",
                              //         style: AppTheme.getTextStyle(
                              //             themeData.textTheme.subtitle1,
                              //             fontWeight: 600))),
                            ],
                          )
                        ],
                      ),
                    ),

                    /*--------------- Build Tab body here -------------------*/
                    body: TabBarView(
                      children: <Widget>[
                        shippingMethod(futureUPSShippingMethod),
                        // shippingMethod(futureFedexShippingMethod),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  // void _paymentMethodBottomSheet(context) {
  //   showModalBottomSheet(
  //       context: context,
  //       isDismissible: true,
  //       // isScrollControlled: true,
  //       builder: (BuildContext buildContext) {
  //         return SingleChildScrollView(
  //           child: Container(
  //             margin: EdgeInsets.only(top: 70),
  //             height: MediaQuery.of(context).size.height,
  //             decoration: BoxDecoration(
  //                 color: themeData.backgroundColor,
  //                 borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(MySize.size16),
  //                     topRight: Radius.circular(MySize.size16))),
  //             child: Padding(
  //               padding: EdgeInsets.only(
  //                 top: MySize.size16,
  //                 // left: MySize.size24,
  //                 // right: MySize.size24,
  //                 // bottom: 300,
  //               ),
  //               child: ListView(
  //                 padding: EdgeInsets.fromLTRB(MySize.size24, MySize.size8,
  //                     MySize.size24, MySize.size24),
  //                 children: <Widget>[
  //                   Text(
  //                     "Payment Method",
  //                     style: AppTheme.getTextStyle(
  //                         themeData.textTheme.subtitle2,
  //                         color: themeData.colorScheme.onBackground,
  //                         fontWeight: 600,
  //                         letterSpacing: 0),
  //                   ),
  //                   SizedBox(height: MySize.size16),
  //                   InkWell(
  //                     onTap: () {
  //                       // Navigator.push(context,
  //                       //     MaterialPageRoute(builder: (context) {
  //                       //   return MakePayment();
  //                       // }));
  //                     },
  //                     child: getSinglePayment(
  //                         index: 0,
  //                         method: "Paypal",
  //                         image: 'assets/icons/payment-paypal.svg'),
  //                   ),
  //                   SizedBox(height: MySize.size16),
  //                   getSinglePayment(
  //                       index: 1,
  //                       method: "Debit or Credit Card",
  //                       image: 'assets/icons/payment-debit-card.svg'),
  //                   SizedBox(height: MySize.size16),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  Widget getSinglePayment({int? index, String? image, String? method}) {
    bool isSelected = index == selectedPayment;

    return InkWell(
      onTap: () {
        selectedPayment = index!;
      },
      child: PhysicalModel(
        // borderRadius: Shape.circular(8),
        color: Colors.transparent,
        elevation: isSelected ? 4 : 0,
        shadowColor: Color(0xffeaeaea).withAlpha(40),
        child: Container(
          padding: EdgeInsets.all(MySize.size16),
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xffffffff) : const Color(0xfff8faff),
            // borderRadius: Shape.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MySize.size72,
                height: MySize.size60,
                child: SvgPicture.asset(
                  image!,
                  matchTextDirection: true,
                ),
              ),
              SizedBox(width: MySize.size16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method!,
                      style: AppTheme.getTextStyle(
                        themeData.textTheme.bodyText2,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 600,
                      ),
                    ),
                    SizedBox(height: MySize.size8),
                    Text(
                      "8765  \u2022\u2022\u2022\u2022  \u2022\u2022\u2022\u2022  7983",
                      style: AppTheme.getTextStyle(themeData.textTheme.caption,
                          fontSize: MySize.size12,
                          muted: true,
                          fontWeight: 600,
                          color: themeData.colorScheme.onBackground,
                          letterSpacing: 0),
                    )
                  ],
                ),
              ),
              isSelected
                  ? SizedBox(width: MySize.size16)
                  : SizedBox(width: MySize.size20),
              isSelected
                  ? Container(
                      padding: EdgeInsets.all(MySize.size8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xff10bb6b).withAlpha(40)),
                      child: Icon(
                        Icons.credit_card,
                        color: const Color(0xff10bb6b),
                        size: MySize.size14,
                      ),
                    )
                  : Container(
                      height: MySize.size26,
                      width: MySize.size26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xff10bb6b),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> getOrderParams() {
    Map<dynamic, dynamic> defaultCurrency = {
      "symbol": "USD ",
      "decimalDigits": 2,
      "symbolBeforeTheNumber": true,
      "currency": "USD"
    };
    String returnURL = 'return.example.com';
    String cancelURL = 'cancel.example.com';

    String totalAmount = deliveryTotalCost!;
    // String subTotalAmount = deliveryCost!;
    String shippingCost = deliveryCost!;
    String insuranceCost = deliveryInsuranceCost!;

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": double.parse(totalAmount).toStringAsFixed(2),
            "currency": defaultCurrency["currency"],
            "details": {
              // "subtotal": subTotalAmount,
              "shipping": double.parse(shippingCost).toStringAsFixed(2),
              // "shipping_discount": ((-1.0) * shippingDiscountCost).toString(),

              // "tax": "0.07",
              // "handling_fee": "1.00",
              "insurance": double.parse(insuranceCost).toStringAsFixed(2)
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            // "items": items,
            // if (isEnableShipping && isEnableAddress)
            //   "shipping_address": {
            //     "recipient_name": userFirstName + " " + userLastName,
            //     "line1": addressStreet,
            //     "line2": "",
            //     "city": addressCity,
            //     "country_code": addressCountry,
            //     "postal_code": addressZipCode,
            //     "phone": addressPhoneNumber,
            //     "state": addressState
            //   },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }
}

cmToInch(String? cm) {
  double? inch = double.parse(cm.toString()) * 0.393701;
  inch = double.parse(inch.toStringAsFixed(2));
  return inch;
}

kgToPound(String? kg) {
  double? inch = double.parse(kg.toString()) * 2.20462;
  inch = double.parse(inch.toStringAsFixed(2));
  return inch;
}

Widget svgPicLoader(path) {
  return Container(
    height: MySize.size40,
    width: MySize.size40,
    margin: EdgeInsets.only(right: MySize.size10),
    child: SvgPicture.asset(
      path,
      height: MySize.size40,
      width: MySize.size40,
      matchTextDirection: true,
    ),
  );
}
