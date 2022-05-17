import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/components/custom_widgets/skeleton_container.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/screens/user/address/components/add_address.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';

class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> with TickerProviderStateMixin {
  static const List<IconData> icons = const [
    MdiIcons.plus,
    MdiIcons.plus,
  ];
  bool internet = true;
  static const List<String> iconsText = const [
    "Add Address",
    "Add My Address",
  ];
  AnimationController? _controller;

  late Future futureAddres;
  late ThemeData themeData;
  getAddresses() async {
    try {
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
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
    } on SocketException catch (e) {
      internet = false;
      print('Socket Error: $e');
      setState(() {});
    } on Error catch (e) {
      print('General Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    futureAddres = getAddresses();
  }

  @override
  Widget build(BuildContext context) {
    themeData = themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Address"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          internet
              ? FutureBuilder(
                  future: futureAddres,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return Container(
                          // height: MediaQuery.of(context).size.height * 0.75,
                          child: Expanded(
                            child: ListView.builder(
                              itemCount: (snapshot.data as List).length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Container(
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
                                        //     MySize.size20,
                                        //   ),
                                        // ),
                                        child: ListTileTheme(
                                          // dense: true,

                                          contentPadding: EdgeInsets.fromLTRB(
                                              MySize.size10, 0, 0, 0),
                                          child: ExpansionTile(
                                            // leading: CircleAvatar(),
                                            trailing: SizedBox.shrink(),
                                            title: Text(
                                              (snapshot.data as List)[index]
                                                      ["lastName"]
                                                  .toString(),
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.bodyText1,
                                                // fontSize: Mysize,
                                                fontWeight: 600,
                                              ),
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
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.bodyText1,
                                                // fontSize: Mysize,
                                                fontWeight: 500,
                                              ),
                                            ),
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 15.0,
                                                  bottom: 5,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "City: ",
                                                          style: AppTheme
                                                              .getTextStyle(
                                                            themeData.textTheme
                                                                .bodyText1,
                                                            // fontSize: Mysize,
                                                            fontWeight: 500,
                                                          ),
                                                        ),
                                                        Text(
                                                          (snapshot.data
                                                                      as List)[
                                                                  index]["city"]
                                                              .toString(),
                                                          style: AppTheme
                                                              .getTextStyle(
                                                            themeData.textTheme
                                                                .bodyText1,
                                                            // fontSize: Mysize,
                                                            fontWeight: 500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Organization: ",
                                                          style: AppTheme
                                                              .getTextStyle(
                                                            themeData.textTheme
                                                                .bodyText1,
                                                            // fontSize: Mysize,
                                                            fontWeight: 500,
                                                          ),
                                                        ),
                                                        Text(
                                                          (snapshot.data as List)[
                                                                      index][
                                                                  "organization"]
                                                              .toString(),
                                                          style: AppTheme
                                                              .getTextStyle(
                                                            themeData.textTheme
                                                                .bodyText1,
                                                            // fontSize: Mysize,
                                                            fontWeight: 500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Email: ",
                                                          style: AppTheme
                                                              .getTextStyle(
                                                            themeData.textTheme
                                                                .bodyText1,
                                                            // fontSize: Mysize,
                                                            fontWeight: 500,
                                                          ),
                                                        ),
                                                        Text(
                                                          (snapshot.data
                                                                      as List)[
                                                                  index]["email"]
                                                              .toString(),
                                                          style: AppTheme
                                                              .getTextStyle(
                                                            themeData.textTheme
                                                                .bodyText1,
                                                            // fontSize: Mysize,
                                                            fontWeight: 500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Phone No: ",
                                                          style: AppTheme
                                                              .getTextStyle(
                                                            themeData.textTheme
                                                                .bodyText1,
                                                            // fontSize: Mysize,
                                                            fontWeight: 500,
                                                          ),
                                                        ),
                                                        Text(
                                                          (snapshot.data as List)[
                                                                      index][
                                                                  "phoneNumber"]
                                                              .toString(),
                                                          style: AppTheme
                                                              .getTextStyle(
                                                            themeData.textTheme
                                                                .bodyText1,
                                                            // fontSize: Mysize,
                                                            fontWeight: 500,
                                                          ),
                                                        ),
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
                                  ],
                                );
                              },
                            ),
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
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: MySize.size50),
                      Text(
                        "No Internet Connection",
                        style: AppTheme.getTextStyle(
                          themeData.textTheme.headline5,
                          fontWeight: 700,
                          color: themeData.colorScheme.primary,
                        ),
                      ),
                      Container(
                        // height: MediaQuery.of(context).size.height * 0.35,
                        child: Image.asset(
                          "assets/images/no_internet_connection.jpg",
                        ),
                      ),
                      SizedBox(height: MySize.size50),
                      ElevatedButton.icon(
                        onPressed: () {
                          internet = true;
                          setState(() {});
                          futureAddres = getAddresses();
                        },
                        icon: Icon(Icons.history),
                        label: Text("Reload"),
                      )
                    ],
                  ),
                )
        ],
      ),
      floatingActionButton: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: new List.generate(icons.length, (int index) {
          Widget child = new Container(
            height: 70.0,
            width: MediaQuery.of(context).size.width,
            child: new ScaleTransition(
              scale: new CurvedAnimation(
                parent: _controller!,
                curve: new Interval(0.0, 1.0 - index / icons.length / 2.0,
                    curve: Curves.easeOutQuint),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        left: MySize.size8,
                        right: MySize.size8,
                        top: MySize.size4,
                        bottom: MySize.size4),
                    margin: EdgeInsets.only(right: 4),
                    color: themeData.primaryColor,
                    child: Text(iconsText[index],
                        style: AppTheme.getTextStyle(
                            themeData.textTheme.bodyText2,
                            color: themeData.colorScheme.onBackground,
                            fontWeight: 500,
                            letterSpacing: 0.2)),
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    backgroundColor: themeData.primaryColor,
                    mini: true,
                    child: new Icon(icons[index],
                        color: themeData.colorScheme.onSecondary),
                    onPressed: () {
                      index == 0
                          ? Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                              return AddAddress(
                                myAddress: false,
                              );
                            }))
                          : Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                              return AddAddress(
                                myAddress: true,
                              );
                            }));
                      // showSimpleSnackbar();
                    },
                  ),
                ],
              ),
            ),
          );
          return child;
        }).toList()
          ..add(
            new FloatingActionButton(
              heroTag: null,
              backgroundColor: themeData.primaryColor,
              child: new AnimatedBuilder(
                animation: _controller!,
                builder: (BuildContext? context, Widget? child) {
                  return new Transform(
                    transform:
                        new Matrix4.rotationZ(_controller!.value * 0.5 * pi),
                    alignment: FractionalOffset.center,
                    child: new Icon(
                      _controller!.isDismissed ? Icons.add : Icons.close,
                      color: themeData.colorScheme.onPrimary,
                    ),
                  );
                },
              ),
              onPressed: () {
                if (_controller!.isDismissed) {
                  setState(() {});
                  _controller!.forward();
                } else {
                  setState(() {});
                  _controller!.reverse();
                }
              },
            ),
          ),
      ),

      // FloatingActionButton(
      //   backgroundColor: Colors.green,
      //   child: Icon(MdiIcons.plus),
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) {
      //       return AddAddress();
      //     }));
      //   },
      // ),
    );
  }
}
