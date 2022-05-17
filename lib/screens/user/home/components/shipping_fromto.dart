import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aquatic_xpress_shipping/models/GenericModel.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';

class ShippingFromTo extends StatefulWidget {
  final fromTo;

  const ShippingFromTo({Key? key, this.fromTo}) : super(key: key);

  @override
  _ShippingFromToState createState() => _ShippingFromToState();
}

class _ShippingFromToState extends State<ShippingFromTo> {
  bool shipFrom = false, shipTo = false;
  ShippingModel from = new ShippingModel(city: "1", zipCode: ""),
      to = new ShippingModel(city: "1", zipCode: "");
  late ThemeData themeData;
  TextEditingController fromController = new TextEditingController(),
      toController = new TextEditingController();
  String? fromCountry, toCountry, fromCountryIcon, toCountryIcon;
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

  @override
  void initState() {
    super.initState();

    if (widget.fromTo != null) {
      fromController.text = widget.fromTo['fromZipCode'];
      toController.text = widget.fromTo['toZipCode'];

      // if (widget.fromTo['fromCountry'] == 'US') {
      //   fromCountry = countriesList[0]['name'].toString() +
      //       countriesList[0]['code'].toString();
      //   fromCountryIcon = countriesList[0]['name'].toString();
      // } else if (widget.fromTo['fromCountry'] == 'PR') {
      //   fromCountry = countriesList[1]['name'].toString() +
      //       countriesList[1]['code'].toString();
      //   fromCountryIcon = countriesList[0]['name'].toString();
      // } else {}

      // if (widget.fromTo['toCountry'] == 'US') {
      //   toCountry = countriesList[0]['name'].toString() +
      //       countriesList[0]['code'].toString();
      //   toCountryIcon = countriesList[0]['name'].toString();
      // } else if (widget.fromTo['toCountry'] == 'PR') {
      //   toCountry = countriesList[1]['name'].toString() +
      //       countriesList[1]['code'].toString();
      //   toCountryIcon = countriesList[0]['name'].toString();
      // } else {}

    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    MySize().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: MySize.size10,
                vertical: MySize.size10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text("From",
                        style: AppTheme.getTextStyle(
                            themeData.textTheme.subtitle1,
                            fontWeight: 600)),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.white,
                    ),
                    child: Container(
                      margin:
                          EdgeInsets.fromLTRB(0, MySize.size5, 0, MySize.size5),
                      color: themeData.colorScheme.background,
                      child: DropdownButton(
                        value: fromCountry,
                        underline: SizedBox(),
                        items: countriesList.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem<String>(
                            value: e['name']! + "-" + e['code']!,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: MySize.size10),
                              child: Row(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(right: MySize.size5),
                                    child: SvgPicture.asset(
                                      e["icon"].toString(),
                                      height: MySize.size20,
                                      width: MySize.size20,
                                      matchTextDirection: true,
                                    ),
                                  ),
                                  SizedBox(width: MySize.size10),
                                  Text(
                                    e["name"].toString(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        hint: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: MySize.size5,
                          ),
                          child: Text(
                            "Select Country",
                          ),
                        ),
                        dropdownColor: Theme.of(context).backgroundColor,
                        onChanged: (dynamic value) {
                          setState(() {
                            fromCountry = value;
                          });
                        },
                      ),
                    ),
                  ),
                  customTextField(fromController, "", "Zip Code"),
                ],
              ),
            ),
            divider(),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: MySize.size10,
                vertical: MySize.size10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // padding: EdgeInsets.only(top: MySize.size10, bottom: MySize.size10),
                    child: Text("To",
                        style: AppTheme.getTextStyle(
                            themeData.textTheme.subtitle1,
                            fontWeight: 600)),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.white,
                    ),
                    child: Container(
                      margin:
                          EdgeInsets.fromLTRB(0, MySize.size5, 0, MySize.size5),
                      color: themeData.colorScheme.background,
                      child: DropdownButton(
                        value: toCountry,
                        underline: SizedBox(),
                        items: countriesList.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem<String>(
                            value: e['name']! + "-" + e['code']!,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: MySize.size10),
                              child: Row(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(right: MySize.size5),
                                    child: SvgPicture.asset(
                                      e["icon"].toString(),
                                      height: MySize.size20,
                                      width: MySize.size20,
                                      matchTextDirection: true,
                                    ),
                                  ),
                                  SizedBox(width: MySize.size10),
                                  Text(
                                    e["name"].toString(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        hint: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: MySize.size5,
                          ),
                          child: Text(
                            "Select Country",
                          ),
                        ),
                        dropdownColor: Theme.of(context).backgroundColor,
                        onChanged: (dynamic value) {
                          setState(() {
                            toCountry = value;
                          });
                        },
                      ),
                    ),
                  ),
                  customTextField(toController, "", "Zip Code"),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: MySize.size10),
              width: MySize.safeWidth,
              margin: EdgeInsets.only(top: MySize.size16),
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(MySize.size8)),
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
                      Map fromTo = {
                        'fromCountry': fromCountry!.split("-")[1],
                        'fromZipCode': fromController.text,
                        'fromCity': "2",
                        'toCountry': toCountry!.split("-")[1],
                        'toZipCode': toController.text,
                        'toCity': '2',
                        'shipFrom': true,
                        'shipTo': true,
                      };

                      Navigator.pop(context, fromTo);
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
    );
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

  Widget divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: MySize.size2),
      child: Divider(
        height: MySize.size20,
        thickness: 1,
      ),
    );
  }
}
