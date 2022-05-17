/*
* File : Personal Information Form
* Version : 1.0.0
* */

import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:aquatic_xpress_shipping/AppTheme.dart';

import 'package:http/http.dart' as http;
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:uiblock/uiblock.dart';

class AddAddress extends StatefulWidget {
  final myAddress;

  const AddAddress({Key? key, this.myAddress}) : super(key: key);
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  bool isResidetial = true;

  late ThemeData themeData;

  TextEditingController organizationController = new TextEditingController(),
      fNameController = new TextEditingController(),
      lNameController = new TextEditingController(),
      addressController = new TextEditingController(),
      apartController = new TextEditingController(),
      cityController = new TextEditingController(),
      emailController = new TextEditingController(),
      phoneController = new TextEditingController(),
      zipController = new TextEditingController();

  int? statusCode;

  saveAddress(context) async {
    UIBlock.blockWithData(
      context,
      loadingTextWidget: Text("Validating Address"),
    );
    String ?link = "${getCloudUrl()}/api/addressbook";
    var url = Uri.parse(link);
    String? token = await getToken();
    String? username = await getUserName();

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(
        {
          'address': addressController.text,
          'city': cityController.text,
          'email': emailController.text,
          'isItResidential': isResidetial,
          'lastName': lNameController.text,
          'organization': organizationController.text,
          'phoneNumber': phoneController.text,
          'place': apartController.text,
          'state': selectedState.toString(),
          // 'country': selectedState.toString(),
          'userId': username,
          'visible': true,
          'zipCode': zipController.text,
        },
      ),
    );
    statusCode = response.statusCode;
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      UIBlock.unblock(context);
      Flushbar(
        title: "Saved Address",
        message: "Address Saved",
        duration: Duration(seconds: 3),
      )..show(context);
    } else {
      UIBlock.unblock(context);
      Flushbar(
        title: "Invalid Address",
        message: "Address is not valid",
        duration: Duration(seconds: 3),
      )..show(context);
      return;
      // print("Exception");
      // throw Error;
    }
  }

  saveMyAddress(context) async {
    UIBlock.blockWithData(
      context,
      loadingTextWidget: Text("Validating Address"),
    );
    String ?link = "${getCloudUrl()}/api​/UserAddress";
    var url = Uri.parse(link);
    String? token = await getToken();
    String? username = await getUserName();

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(
        {
          'address': addressController.text,
          'city': cityController.text,
          // 'email': emailController.text,
          'isItResidential': isResidetial,
          'lastName': lNameController.text,
          'organization': organizationController.text,
          'phoneNumber': phoneController.text,
          'place': apartController.text,
          'state': selectedState.toString(),
          // 'country': selectedState.toString(),
          'userId': username,
          'visible': true,
          'zipCode': zipController.text,
        },
      ),
    );
    statusCode = response.statusCode;
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      UIBlock.unblock(context);
      Flushbar(
        title: "Saved Address",
        message: "Address Saved",
        duration: Duration(seconds: 3),
      )..show(context);
    } else {
      UIBlock.unblock(context);
      Flushbar(
        title: "Invalid Address",
        message: "Address is not valid",
        duration: Duration(seconds: 3),
      )..show(context);
      return;
      // print("Exception");
      // throw Error;
    }
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    themeData = themeData = Theme.of(context);
    

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            MdiIcons.chevronLeft,
            color: themeData.colorScheme.onBackground,
          ),
        ),
        title: Text(
          widget.myAddress ? "Add My Address" : "Add Address",
          style: AppTheme.getTextStyle(
            themeData.textTheme.headline6,
            fontWeight: 600,
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(MySize.size16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    left: 0,
                    right: MySize.size16,
                    top: 0,
                    bottom: MySize.size12,
                  ),
                  child: Text("Personal",
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.subtitle1,
                          fontWeight: 600)),
                ),
                customTextField(
                  organizationController,
                  "",
                  "Organization",
                  TextInputType.text,
                ),
                customTextField(
                  lNameController,
                  "",
                  "Name",
                  TextInputType.text,
                ),
                widget.myAddress
                    ? Container()
                    : customTextField(
                        emailController,
                        "",
                        "Email Address",
                        TextInputType.emailAddress,
                      ),
                customTextField(
                  phoneController,
                  "",
                  "Phone Number",
                  TextInputType.phone,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: MySize.size10,
                    bottom: MySize.size10,
                  ),
                  child: Text(
                    "Address",
                    style: AppTheme.getTextStyle(
                      themeData.textTheme.subtitle1,
                      fontWeight: 600,
                    ),
                  ),
                ),
                customTextField(
                  addressController,
                  "",
                  "Address",
                  TextInputType.text,
                ),
                customTextField(
                  apartController,
                  "",
                  "Apart/Building",
                  TextInputType.text,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: MySize.size2),
                  child: widget.myAddress
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Is this residential?",
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.headline6,
                                  fontWeight: 500,
                                  letterSpacing: 0),
                            ),
                            Switch(
                              onChanged: (bool value) {
                                setState(() {
                                  isResidetial = value;
                                });
                              },
                              value: isResidetial,
                              activeColor: themeData.colorScheme.primary,
                            ),
                          ],
                        ),
                ),
                customTextField(
                  cityController,
                  "",
                  "City",
                  TextInputType.text,
                ),
                Container(
                  color: themeData.colorScheme.background,
                  padding: EdgeInsets.symmetric(vertical: MySize.size2),
                  child: DropdownButton(
                    value: selectedState,
                    underline: SizedBox(),
                    items: statesList.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem<String>(
                        value: e['name'],
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Text(
                              e["name"].toString(),
                              style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText1,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    hint: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MySize.size10,
                      ),
                      child: Text(
                        "Select State",
                        style: AppTheme.getTextStyle(
                          themeData.textTheme.bodyText1,
                          // fontSize: Mysize,
                          fontWeight: 500,
                        ),
                      ),
                    ),
                    dropdownColor:Colors.white,
                    onChanged: (dynamic value) {
                      setState(() {
                        selectedState = value;
                      });
                    },
                  ),
                ),
                customTextField(
                  lNameController,
                  "",
                  "Zip Code",
                  TextInputType.number,
                ),
                Container(
                  color: themeData.colorScheme.background,
                  padding: EdgeInsets.symmetric(vertical: MySize.size2),
                  child: DropdownButton(
                    dropdownColor:Colors.white,
                    value: country,
                    underline: SizedBox(),
                    items: countriesList.map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem<String>(
                        value: e['name']! + "-" + e['code']!,
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: MySize.size5),
                              child: SvgPicture.asset(
                                e["icon"].toString(),
                                height: 20,
                                width: 20,
                                matchTextDirection: true,
                              ),
                            ),
                            SizedBox(width: MySize.size10),
                            Text(
                              e["name"].toString(),
                              style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText1,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    hint: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MySize.size10,
                      ),
                      child: Text(
                        "Select Country",
                        style: AppTheme.getTextStyle(
                          themeData.textTheme.bodyText1,
                        ),
                      ),
                    ),
                    // dropdownColor: Theme.of(context).backgroundColor,
                    onChanged: (dynamic value) {
                      setState(() {
                        country = value;
                      });
                    },
                  ),
                ),
                Container(
                  width: MySize.safeWidth,
                  margin: EdgeInsets.only(top: MySize.size16),
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(MySize.size8)),
                      boxShadow: [
                        BoxShadow(
                          color: themeData.colorScheme.primary.withAlpha(28),
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
                          if (widget.myAddress) {
                            saveMyAddress(context);
                          } else {
                            saveAddress(context);
                          }
                          if (statusCode == 200) {
                            Navigator.pop(context);
                          }
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
          ),
        ),
      ),
    );
  }

  Widget customTextField(controller, hintText, labelText, keyboardType) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: MySize.size2),
      child: TextFormField(
        style: AppTheme.getTextStyle(
          themeData.textTheme.bodyText1,
        ),
        controller: controller,
        onChanged: (value) {},
        decoration: InputDecoration(
          focusColor: themeData.colorScheme.onBackground,
          contentPadding: EdgeInsets.symmetric(horizontal: MySize.size10),
          fillColor: themeData.colorScheme.background,
          hintStyle: TextStyle(
            color: themeData.colorScheme.onBackground,
          ),
          labelStyle: TextStyle(
            color: themeData.colorScheme.onBackground,
          ),
          filled: true,
          hintText: hintText,
          labelText: labelText,
          enabledBorder: InputBorder.none,
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  String? country;
  String? selectedState;

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
    {
      "name": "Puerto Rico",
      "code": "PR",
      "icon": "assets/icons/Flag_PR.svg",
    },
  ];
}
