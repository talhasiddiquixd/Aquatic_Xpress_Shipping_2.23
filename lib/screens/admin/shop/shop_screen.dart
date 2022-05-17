import 'dart:convert';
import 'dart:io';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/screens/admin/shop/components/my_products.dart';
import 'package:aquatic_xpress_shipping/screens/admin/shop/components/shop_orders.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:http/http.dart' as http;



class Shop extends StatefulWidget {
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;
  File? imagess;

  _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabSelection);
    _tabController.animation!.addListener(() {
      final aniValue = _tabController.animation!.value;
      if (aniValue - _currentIndex > 0.5) {
        setState(() {
          _currentIndex = _currentIndex + 1;
        });
      } else if (aniValue - _currentIndex < -0.5) {
        setState(() {
          _currentIndex = _currentIndex - 1;
        });
      }
    });
    super.initState();
  }

  onTapped(value) {
    setState(() {
      _currentIndex = value;
    });
  }

  dispose() {
    super.dispose();
    _tabController.dispose();
  }

  late ThemeData themeData;
  getUsers() async {
    String? token = await getToken();

    String ?link = "${getCloudUrl()}/api/Products";
    // "${getCloudUrl()}​/api​/ShipmentOrder​/getfedexorderlist";

    var url = Uri.parse(link);
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(
        {
          "id": 0,
          "name": "string",
          "details": "string",
          "price": 0,
          "color": "string",
          "stock": 0,
          "image": "string",
          "isDeleted": true
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

  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: <Widget>[
              ShopOrders(),
              MyProducts(),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: Spacing.all(16),
              child: PhysicalModel(
                color: themeData.backgroundColor,
                elevation: 12,
                borderRadius: Shape.circular(8),
                shadowColor: themeData.backgroundColor.withAlpha(140),
                shape: BoxShape.rectangle,
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.backgroundColor,
                    borderRadius: Shape.circular(16),
                  ),
                  padding: Spacing.vertical(12),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: themeData.backgroundColor,
                    tabs: <Widget>[
                      Container(
                        child: (_currentIndex == 0)
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    "Shop Orders",
                                    style: AppTheme.getTextStyle(
                                      themeData.textTheme.bodyText2,
                                      color: const Color(0xff10bb6b),
                                      letterSpacing: 0,
                                      fontWeight: 600,
                                    ),
                                  ),
                                  Container(
                                    margin: Spacing.top(6),
                                    decoration: BoxDecoration(
                                        color: const Color(0xff10bb6b),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2.5))),
                                    height: 5,
                                    width: 5,
                                  )
                                ],
                              )
                            : Icon(
                                Icons.running_with_errors,
                                size: MySize.size20,
                                color: themeData.colorScheme.onBackground,
                              ),
                      ),
                      Container(
                        child: (_currentIndex == 1)
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: MySize.size40),
                                    child: Text(
                                      "My Products",
                                      style: AppTheme.getTextStyle(
                                          themeData.textTheme.bodyText2,
                                          color: const Color(0xff10bb6b),
                                          letterSpacing: 0,
                                          fontWeight: 600),
                                    ),
                                  ),
                                  Container(
                                    margin: Spacing.top(6),
                                    decoration: BoxDecoration(
                                        color: const Color(0xff10bb6b),
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(2.5))),
                                    height: 5,
                                    width: 5,
                                  )
                                ],
                              )
                            : Icon(
                                Icons.history,
                                size: MySize.size20,
                                color: themeData.colorScheme.onBackground,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      // floatingActionButton: _currentIndex == 1
      //     ? Padding(
      //         padding: EdgeInsets.only(
      //           bottom: MySize.size20,
      //           left: MySize.size60,
      //         ),
      //         child: FloatingActionButton(
      //           backgroundColor: Colors.green,
      //           child: Icon(Icons.add),
      //           onPressed: () {
      //             Navigator.push(
      //                 context, MaterialPageRoute(builder: (context) => Add()));
      //             // _shippingBottomSheet(
      //             //   context,
      //             //   false,
      //             //   "",
      //             //   "",
      //             //   "",
      //             //   "",
      //             //   "",
      //             // );
      //           },
      //         ),
      //       )
      //     : Container(),
    );
  }

  TextEditingController nameController = TextEditingController(),
      detailController = TextEditingController(),
      priceController = TextEditingController(),
      colorController = TextEditingController(),
      stockController = TextEditingController();

  Widget customTextField(
    controller,
    hintText,
    labelText,
  ) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            fillColor: themeData.colorScheme.background,
            hintStyle: TextStyle(
              color: themeData.colorScheme.onBackground,
            ),
            filled: true,
            hintText: hintText,
            labelText: labelText,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            // prefixIcon: Icon(Icons.person),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 7,
        )
      ],
    );
  }

  final picker = ImagePicker();
  void takePicture() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        imagess = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void takePictureFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imagess = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
