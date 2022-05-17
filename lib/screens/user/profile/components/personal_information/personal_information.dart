import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:aquatic_xpress_shipping/components/custom_widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:aquatic_xpress_shipping/AppTheme.dart';

import 'package:http/http.dart' as http;
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:uiblock/uiblock.dart';

class PersonalInformation extends StatefulWidget {
  @override
  _PersonalInformationState createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  bool isResidetial = true;

  late ThemeData themeData;

  TextEditingController organizationController = new TextEditingController(),
      fNameController = new TextEditingController(),
      lNameController = new TextEditingController(),
      addressController = new TextEditingController(),
      apartController = new TextEditingController(),
      cityController = new TextEditingController(),
      stateController = new TextEditingController(),
      emailController = new TextEditingController(),
      phoneController = new TextEditingController(),
      zipController = new TextEditingController();

  int? statusCode;

  getUserData() async {
    String ?link = '${getCloudUrl()}/api/auth/getuserdata';
    // "${getCloudUrl()}/api/addressbook";
    var url = Uri.parse(link);
    String? token = await getToken();

    var response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    statusCode = response.statusCode;
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var orders = json.decode(response.body);
      organizationController.text = orders['organization'].toString() != "null"
          ? orders['organization'].toString()
          : "";
      fNameController.text = orders['firstName'].toString() != "null"
          ? orders['firstName'].toString()
          : "";
      lNameController.text = orders['lastName'].toString() != "null"
          ? orders['lastName'].toString()
          : "";
      addressController.text = orders['address'].toString() != "null"
          ? orders['address'].toString()
          : "";
      phoneController.text = orders['phoneNumber'].toString() != "null"
          ? orders['phoneNumber'].toString()
          : "";
      emailController.text = orders['email'].toString() != "null"
          ? orders['email'].toString()
          : "";
      cityController.text =
          orders['city'].toString() != "null" ? orders['city'].toString() : "";
      zipController.text = orders['zipcode'].toString() != "null"
          ? orders['zipcode'].toString()
          : "";
    } else {
      print("Exception");
      throw Error;
    }
  }

  saveAddress(context) async {
    UIBlock.blockWithData(
      context,
      loadingTextWidget: Text("Updating Profile"),
    );
    String ?link =
        "${getCloudUrl()}/api/Auth/updateuser";
    var url = Uri.parse(link);
    String? token = await getToken();

    var response = await http.put(
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
          'firstName': fNameController.text,
          'lastName': lNameController.text,
          'organization': organizationController.text,
          'phone': phoneController.text,
          'state': selectedState.toString(),
          // 'country': selectedState.toString(),
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
        title: "Profile Update",
        message: "Your profile data has been updated!",
        duration: Duration(seconds: 3),
      )..show(context);
    } else {
      UIBlock.unblock(context);
      Flushbar(
        title: "Error Occured",
        message: "Your profile data has not been updated!",
        duration: Duration(seconds: 3),
      )..show(context);
      return;
      // print("Exception");
      // throw Error;
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  double height = MySize.size8;

  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    themeData = themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(MdiIcons.chevronLeft),
        ),
        title: Text(
          "Personal Information",
          style: AppTheme.getTextStyle(
            themeData.textTheme.headline6,
            fontWeight: 600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(MySize.size16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Personal Info",
                style: AppTheme.getTextStyle(themeData.textTheme.subtitle1,
                    fontWeight: 600),
              ),
              Space.height(height),
              customTextField(
                context,
                organizationController,
                "",
                "Organization",
                TextInputType.text,
              ),
              Space.height(height),
              customTextField(
                context,
                fNameController,
                "",
                "First Name",
                TextInputType.text,
              ),
              Space.height(height),
              customTextField(
                context,
                lNameController,
                "",
                "Last Name",
                TextInputType.text,
              ),
              Space.height(height),
              Container(
                padding: EdgeInsets.only(
                  top: MySize.size10,
                  bottom: MySize.size10,
                ),
                child: Text(
                  "Contact Info",
                  style: AppTheme.getTextStyle(
                    themeData.textTheme.subtitle1,
                    fontWeight: 600,
                  ),
                ),
              ),
              Space.height(height),
              customTextField(
                context,
                phoneController,
                "",
                "Phone Number",
                TextInputType.phone,
              ),
              Space.height(height),
              customTextField(
                context,
                emailController,
                "",
                "Email Address",
                TextInputType.emailAddress,
              ),
              Space.height(height),
              customTextField(
                context,
                addressController,
                "",
                "Address",
                TextInputType.text,
              ),
              Space.height(height),
              customTextField(
                context,
                cityController,
                "",
                "City",
                TextInputType.text,
              ),
              Space.height(height),
              customTextField(
                context,
                stateController,
                "Short Code like NY, DC",
                "State",
                TextInputType.text,
              ),
              Space.height(height),
              customTextField(
                context,
                zipController,
                "",
                "Zip Code",
                TextInputType.number,
              ),
              Space.height(height),
              Container(
                color: themeData.backgroundColor,
                padding: EdgeInsets.symmetric(vertical: MySize.size2),
                child: DropdownButton(
                  value: country,
                  underline: SizedBox(),
                  items: countriesList.map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem<String>(
                      value: e['name']! + "-" + e['code']!,
                      child: Row(
                        children: [
                          Container(
                            margin:
                                EdgeInsets.symmetric(horizontal: MySize.size10),
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
                      style: TextStyle(
                          // fontSize: 1,
                          ),
                    ),
                  ),
                  dropdownColor: Theme.of(context).backgroundColor,
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
                        saveAddress(context);
                      },
                      child: Text(
                        "SAVE",
                        style: AppTheme.getTextStyle(
                          themeData.textTheme.bodyText2,
                          fontSize: MySize.size18,
                          fontWeight: 600,
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
