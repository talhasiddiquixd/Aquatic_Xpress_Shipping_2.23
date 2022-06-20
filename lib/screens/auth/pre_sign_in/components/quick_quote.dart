import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/components/custom_widgets/skeleton_container.dart';
import 'package:aquatic_xpress_shipping/models/GenericModel.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/screens/user/home/components/shipping_fromto.dart';
import 'package:aquatic_xpress_shipping/screens/user/shipping/shipping.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';

class QuickQoute extends StatefulWidget {
  QuickQoute({Key? key}) : super(key: key);

  @override
  _QuickQouteState createState() => _QuickQouteState();
}

class _QuickQouteState extends State<QuickQoute> with TickerProviderStateMixin {
  TextEditingController fromController = new TextEditingController(),
      toController = new TextEditingController(),
      weightController = new TextEditingController(),
      lengthController = new TextEditingController(),
      heightController = new TextEditingController(),
      declaredValueController = new TextEditingController(),
      widthController = new TextEditingController();

  bool shipFrom = false,
      shipTo = false,
      length = false,
      width = false,
      height = false,
      weight = false,
      couriorService = false;
  @override
  void initState() {
    super.initState();
  }

  getFedexQuickRoute() async {
    // quickQuote = 0;
    // curl();
    String ?link = "${getCloudUrl()}/api/Fedex/quickquote";
    var url = Uri.parse(link);
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          // "shipperPostalCode": "89119",
          // "shippingToPostalCode": "10001",
          // "weight": "12",
          // "packageLength": "12",
          // "packageWidth": "12",
          // "packageHeight": "12",
          // "fromCountry": "US",
          // "toCountry": "US"
          "shipperPostalCode": from.zipCode,
          "shippingToPostalCode": to.zipCode,
          "weight": weightController.text,
          "packageLength": lengthController.text,
          "packageWidth": widthController.text,
          "packageHeight": heightController.text,
          "fromCountry": from.country,
          "toCountry": to.country
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

  getUPSQuickRoute() async {
    // quickQuote = 1;

    String ?link = "${getCloudUrl()}/api/UPS/quickquote";
    var url = Uri.parse(link);
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          // "shipperPostalCode": "89119",
          // "shippingToPostalCode": "10001",
          // "weight": "12",
          // "packageLength": "12",
          // "packageWidth": "12",
          // "packageHeight": "12",
          // "fromCountry": "US",
          // "toCountry": "US"
          "shipperPostalCode": from.zipCode,
          "shippingToPostalCode": to.zipCode,
          "weight": weightController.text,
          "packageLength": lengthController.text,
          "packageWidth": widthController.text,
          "packageHeight": heightController.text,
          "fromCountry": from.country,
          "toCountry": to.country
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

  late Future futureList;
  bool flag = false;
  double? imgHeight = 30;
  double? imgWidth = MySize.size40;

  double? fieldHeight = MySize.size40;
  double? fieldWidth = 130;

  double? widthSizedBox = MySize.size5;
  double? heightSizedBox = MySize.size5;
  bool dutySwitch = false;
  String? _selectedCourierService="UPS";

  ShippingModel from = new ShippingModel(
        city: "1",
        zipCode: "",
        country: '',
      ),
      to = new ShippingModel(
        city: "1",
        zipCode: "",
        country: '',
      );

  PackageDimensions packageDimensions = new PackageDimensions(title: "1");

  late ThemeData themeData;

  // bool _switch = true;
  Widget divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: MySize.size2),
      child: Divider(
        height: MySize.size20,
        thickness: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    themeData = Theme.of(context);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: MySize.size10,
              vertical: MySize.size4,
            ),
            child: GestureDetector(
              onTap: () async {
                Map fromTo = {
                  'fromCountry': from.country,
                  'fromZipCode': from.zipCode,
                  'toCountry': to.country,
                  'toZipCode': to.zipCode,
                };
                var shipFromTo = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShippingFromTo(fromTo: fromTo),
                  ),
                );
                if (shipFromTo != null) {
                  from.country = shipFromTo['fromCountry'];
                  from.zipCode = shipFromTo['fromZipCode'];
                  from.city = shipFromTo['fromCity'];

                  to.country = shipFromTo['toCountry'];
                  to.zipCode = shipFromTo['toZipCode'];
                  to.city = shipFromTo['toCity'];

                  shipFrom = shipFromTo['shipFrom'];
                  shipTo = shipFromTo['shipTo'];
                }
                setState(() {});
                // _shippingFromBottomSheet(context);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MySize.size14),
                ),
                elevation: MySize.size16,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MySize.size20,
                    vertical: MySize.size20,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          svgPicLoader("assets/icons/ShippingFrom.svg"),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Shipping from",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              from.city! == "1"
                                  ? Container()
                                  // Text(
                                  //     "", // "Tap here to set origin",
                                  //     style: TextStyle(fontSize:MySize.size19),
                                  //   )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          from.zipCode! + ", " + from.country!,
                                          style: TextStyle(
                                            fontSize: MySize.size18,
                                          ),
                                        ),
                                      ],
                                    )
                            ],
                          ),
                        ],
                      ),
                      divider(),
                      Row(
                        children: [
                          svgPicLoader("assets/icons/ShippingTo.svg"),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Shipping to",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              to.city! == "1"
                                  ? Container()

                                  // Text(
                                  //     "Tap here to set destination",
                                  //     style: TextStyle(fontSize:MySize.size19),
                                  //   )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          to.zipCode! + ", " + to.country!,
                                          style: TextStyle(
                                            fontSize: MySize.size18,
                                          ),
                                        ),
                                      ],
                                    )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: MySize.size10,
              vertical: MySize.size4,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MySize.size14),
              ),
              elevation: MySize.size16,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MySize.size10,
                  vertical: MySize.size10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: customerTextFieldNumericc(
                              lengthController, "Inch", "Length"),
                        ),
                        SizedBox(width: MySize.size5),
                        Expanded(
                          child: customerTextFieldNumericc(
                              widthController, "Inch", "Width"),
                        ),
                        SizedBox(width: MySize.size5),
                        Expanded(
                          child: customerTextFieldNumericc(
                              heightController, "Inch", "Height"),
                        ),
                        SizedBox(width: MySize.size5),
                        Expanded(
                          child: customerTextFieldNumericc(
                              weightController, "lb", "Weight"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: MySize.size10,
              vertical: MySize.size4,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MySize.size14),
              ),
              elevation: MySize.size16,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MySize.size10,
                  vertical: MySize.size4,
                ),
                child: DropdownButton(
                  value: _selectedCourierService,
                  underline: SizedBox(),
                  items: courierServiceList.map<DropdownMenuItem<String>>(
                    (e) {
                      return DropdownMenuItem<String>(
                        value: e['name']!,
                        child: Row(
                          children: [
                            Container(
                              height: MySize.size40,
                              width: MySize.size50,
                              margin: EdgeInsets.only(right: MySize.size5),
                              child: SvgPicture.asset(
                                e["icon"].toString(),
                                matchTextDirection: true,
                              ),
                            ),
                            SizedBox(width: MySize.size10),
                            Text(
                              e["name"].toString(),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down),
                  hint: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MySize.size5,
                    ),
                    child: Text(
                      "Select Courier Service",
                      style: TextStyle(
                          // fontSize: MySize.size14,
                          ),
                    ),
                  ),
                  dropdownColor: Theme.of(context).backgroundColor,
                  onChanged: (dynamic value) {
                    setState(() {
                      couriorService = true;
                      _selectedCourierService = value;
                    });
                  },
                ),
              ),
            ),
          ),
          shipFrom && shipTo && couriorService
              ? Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MySize.size10,
                    vertical: MySize.size4,
                  ),
                  child: InkWell(
                    onTap: () {
                      futureList = _selectedCourierService == "FedEx"
                          ? getFedexQuickRoute()
                          : getUPSQuickRoute();
                      _quickQouteBottomSheet(context);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(MySize.size14),
                      ),
                      elevation: MySize.size16,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(MySize.size20,
                            MySize.size10, MySize.size20, MySize.size10),
                        // height:MySize.size100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Quick Quote",
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
                              "Tap here to get",
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
        ]);
  }

  Widget customTextField(controller, hintText, labelText) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: MySize.size10),
            fillColor: themeData.colorScheme.background,
            hintStyle: TextStyle(
              color: themeData.colorScheme.onBackground,
            ),
            filled: true,
            hintText: hintText,
            labelText: labelText,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MySize.size10),
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            // prefixIcon: Icon(Icons.person),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: MySize.size7,
        )
      ],
    );
  }

  Widget customNumericField(controller, hintText, labelText) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: MySize.size10),
            fillColor: themeData.colorScheme.background,
            hintStyle: TextStyle(
              color: themeData.colorScheme.onBackground,
            ),
            filled: true,
            hintText: hintText,
            labelText: labelText,

            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            // prefixIcon: Icon(Icons.person),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: MySize.size7,
        )
      ],
    );
  }

  Widget customerTextFieldNumeric(controller, hintText, labelText) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: MySize.size10),
          fillColor: themeData.colorScheme.background,
          hintStyle: TextStyle(
            color: themeData.colorScheme.onBackground,
          ),
          filled: true,
          hintText: hintText,
          labelText: labelText,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(MySize.size10),
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          // prefixIcon: Icon(Icons.person),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget customerTextFieldNumericc(controller, hintText, labelText) {
    return TextFormField(
      controller: controller,
      onChanged: (value) {},
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: MySize.size10),
        fillColor: themeData.colorScheme.background,
        hintStyle: TextStyle(
          color: themeData.colorScheme.onBackground,
        ),
        filled: true,
        hintText: hintText,
        labelText: labelText,

        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(MySize.size10),
        // ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        // prefixIcon: Icon(Icons.person),
      ),
      keyboardType: TextInputType.number,
    );
  }

  var countriesList = [
    {
      "name": "United States",
      "code": "US",
      "icon": "assets/icons/Flag_US.svg",
    },
    {
      "name": "Puerto Rico",
      "code": "PR",
      "icon": "assets/icons/Flag_PR.svg",
    },
  ];

  var courierServiceList = [
    {
      "name": "UPS",
      "icon": "assets/icons/logo_ups.svg",
    },
    // {
    //   "name": "FedEx",
    //   "icon": "assets/icons/logo_fedex.svg",
    // },
  ];

  String dropdownValue = 'One';
  _quickQouteBottomSheet(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      elevation: MySize.size10,
      context: context,
      isDismissible: true,
      // shape: ,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return Container(
            margin: EdgeInsets.only(top: MySize.size72),
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
                top: MySize.size5,
                left: MySize.size5,
                right: MySize.size5,
                // bottom: 300,
              ),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: ,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: MySize.size20),
                        child: Text(
                          "Quick Quote",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MySize.size20),
                        ),
                      ),
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
                    height: MySize.size20,
                    thickness: MySize.size2,
                    // indent: MySize.size10,
                    // endIndent: MySize.size10,
                  ),
                  // Text(
                  //   "Your selection",
                  //   style: AppTheme.getTextStyle(
                  //     themeData.textTheme.subtitle1,
                  //     fontWeight: 600,
                  //     letterSpacing: 0,
                  //   ),
                  // ),
                  // Text(
                  //   packageDimensions.title!,
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: MySize.size20,
                  //   ),
                  // ),
                  // Divider(
                  //   height: MySize.size20,
                  //   thickness: MySize.size2,
                  //   // indent: MySize.size10,
                  //   // endIndent: MySize.size10,
                  // ),

                  FutureBuilder(
                    future: futureList,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return (snapshot.data as List).length != 0
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  child: ListView.builder(
                                    itemCount: (snapshot.data as List).length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          Container(
                                            padding:
                                                EdgeInsets.all(MySize.size5),
                                            child: Card(
                                              elevation: 3,
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    MySize.size5),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Cost: \$' +
                                                              (snapshot.data as List)[
                                                                          index]
                                                                      [
                                                                      'yourCost']
                                                                  .toString(),
                                                          style: TextStyle(
                                                            // color:
                                                            //     Colors.amber.shade900,
                                                            // fontSize:MySize.size16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Retail: \$' +
                                                              (snapshot.data as List)[
                                                                          index]
                                                                      [
                                                                      'retailPrice']
                                                                  .toString(),
                                                          style: TextStyle(
                                                            // color:
                                                            //     Colors.amber.shade900,
                                                            // fontSize:MySize.size16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Savings: \$' +
                                                              (snapshot.data as List)[
                                                                          index]
                                                                      [
                                                                      'youSave']
                                                                  .toString(),
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Transit Time: ',
                                                          style: TextStyle(
                                                            // color:
                                                            //     Colors.amber.shade900,
                                                            // // fontSize:MySize.size16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        _selectedCourierService ==
                                                                "FedEx"
                                                            ? Text(
                                                                (snapshot.data as List)[index]
                                                                            [
                                                                            'day']
                                                                        .toString() +
                                                                    " " +
                                                                    (snapshot.data
                                                                                as List)[index]
                                                                            [
                                                                            'daysInTransit']
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    // color:
                                                                    //     Colors.amber.shade900,
                                                                    // fontSize:MySize.size16,
                                                                    // fontWeight:
                                                                    //     FontWeight.bold,
                                                                    ),
                                                              )
                                                            : Text(
                                                                (snapshot.data
                                                                                as List)[index]
                                                                            [
                                                                            'day']
                                                                        .toString() +
                                                                    " " +
                                                                    (snapshot.data
                                                                                as List)[index]
                                                                            [
                                                                            'transitTime']
                                                                        .toString() +
                                                                    " " +
                                                                    (snapshot.data
                                                                                as List)[index]
                                                                            [
                                                                            'daysInTransit']
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    // color:
                                                                    //     Colors.amber.shade900,
                                                                    // fontSize:MySize.size16,
                                                                    // fontWeight:
                                                                    //     FontWeight.bold,
                                                                    ),
                                                              ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Shipping Method: ',
                                                          style: TextStyle(
                                                            // color:
                                                            //     Colors.amber.shade900,
                                                            // fontSize:MySize.size16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          (snapshot.data as List)[
                                                                      index][
                                                                  'shippingMethod']
                                                              .toString(),
                                                          style: TextStyle(
                                                              // color:
                                                              //     Colors.amber.shade900,
                                                              // fontSize:MySize.size16,
                                                              // fontWeight:
                                                              //     FontWeight.bold,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.35,
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
                        return listViewWithoutLeadingPictureWithExpandedSkeleton(
                            context);
                      }
                    },
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
