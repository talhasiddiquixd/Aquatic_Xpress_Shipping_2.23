import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/components/custom_widgets/carousel.dart';
import 'package:aquatic_xpress_shipping/components/custom_widgets/skeleton_container.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/screens/user/home/components/quick_quote.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late ThemeData themeData;
  var index = 0;
  var orders;
  List<String> today = [], weekly = [], monthly = [], yearly = [];

  Future? futureData;
  sum(int n1, int n2) {
    return n1 + n2;
  }

  avgCostHardCode() {
    var res = {
      "todayCount": 0,
      "weekCount": 0,
      "monthCount": 0,
      "yearCount": 42,
      "todaySum": 0,
      "weekSum": 0,
      "monthSum": 0,
      "yearSum": 2027.2499999999998,
      "todayAverage": 0,
      "weekAverage": 0,
      "monthAverage": 0,
      "yearAverage": 48.27
    };
    return res;
  }

  avgCost() async {
    // quickQuote = 0;
    // curl();
    String? token = await getToken();

    var url = Uri.parse(
        "${getCloudUrl()}/api/ShipmentOrder/totalavgcost");
    var response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      orders = json.decode(response.body);

      today.add(orders["todayCount"].toStringAsFixed(2));
      weekly.add(orders["weekCount"].toStringAsFixed(2));
      monthly.add(orders["monthCount"].toStringAsFixed(2));
      yearly.add(orders["yearSum"].toStringAsFixed(2));

      today.add(orders["todaySum"].toStringAsFixed(2));
      weekly.add(orders["weekSum"].toStringAsFixed(2));
      monthly.add(orders["monthSum"].toStringAsFixed(2));
      yearly.add(orders["yearCount"].toStringAsFixed(2));

      today.add(orders["todayAverage"].toStringAsFixed(2));
      weekly.add(orders["weekAverage"].toStringAsFixed(2));
      monthly.add(orders["monthAverage"].toStringAsFixed(2));
      yearly.add(orders["yearAverage"].toStringAsFixed(2));
      apiFortest();
      // print("monthly " + orders.toString());
      return orders;
    } else {
      // print("Exception");
      throw Error;
    }
  }

  apiFortest() async {
    print("ABC");
    // print(orders["todayCount"]);
    return orders["weekCount"];
  }

  @override
  void initState() {
    super.initState();
    futureData = avgCost();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    MySize().init(context);

    return Container(
      // margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Carousel(),
          SizedBox(height: MySize.size7),
          Container(
            padding: EdgeInsets.all(MySize.size12),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MySize.size14),
              ),
              elevation: 15,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: MySize.size12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            index = 0;

                            setState(() {});
                          },
                          child: Container(
                            width: MySize.size100,
                            padding:
                                EdgeInsets.symmetric(vertical: MySize.size6),
                            decoration: BoxDecoration(
                              color: index == 0
                                  ? themeData.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  MySize.size4,
                                ),
                              ),
                              border: Border.all(
                                color: themeData.primaryColor,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Spendings",
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.caption,
                                  color: index == 0
                                      ? themeData.colorScheme.onPrimary
                                      : themeData.colorScheme.onBackground,
                                  fontWeight: index == 0 ? 600 : 500,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              // futureData = getWeeklyData();
                              index = 1;
                            });
                          },
                          child: Container(
                            width: MySize.size100,
                            padding: EdgeInsets.all(MySize.size6),
                            decoration: BoxDecoration(
                              color: index == 1
                                  ? themeData.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  MySize.size4,
                                ),
                              ),
                              border: Border.all(
                                color: themeData.primaryColor,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Shipments",
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.caption,
                                    color: index == 1
                                        ? themeData.colorScheme.onPrimary
                                        : themeData.colorScheme.onBackground,
                                    fontWeight: index == 1 ? 600 : 500,
                                    letterSpacing: 0),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              // futureData = geTodayData();
                              index = 2;
                            });
                          },
                          child: Container(
                            width: MySize.size100,
                            padding: EdgeInsets.all(MySize.size6),
                            decoration: BoxDecoration(
                              color: index == 2
                                  ? themeData.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  MySize.size2,
                                ),
                              ),
                              border: Border.all(
                                color: themeData.primaryColor,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Avg. Cost",
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.caption,
                                  color: index == 2
                                      ? themeData.colorScheme.onPrimary
                                      : themeData.colorScheme.onBackground,
                                  fontWeight: index == 2 ? 600 : 500,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          FutureBuilder(
            future: futureData,
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                MySize.size12,
                                MySize.size6,
                                MySize.size6,
                                MySize.size6,
                              ),
                              height: MySize.size100,
                              child: Card(
                                elevation: 8,
                                child: Container(
                                  // padding: EdgeInsets.only(top: MySize.size14),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Today',
                                        style: AppTheme.getTextStyle(
                                          themeData.textTheme.caption,
                                          fontSize: MySize.size18,
                                          fontWeight: 700,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            index == 0
                                                ? '\$'
                                                : index == 1
                                                    ? ""
                                                    : "\$",
                                            style: AppTheme.getTextStyle(
                                              themeData.textTheme.caption,
                                              fontSize: MySize.size18,
                                              fontWeight: 600,
                                            ),
                                          ),
                                          Text(
                                            today[index].toString(),
                                            style: AppTheme.getTextStyle(
                                              themeData.textTheme.caption,
                                              fontSize: MySize.size18,
                                              fontWeight: 600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                MySize.size6,
                                MySize.size6,
                                MySize.size12,
                                MySize.size6,
                              ),
                              height: MySize.size100,
                              child: Card(
                                elevation: 8,
                                child: Container(
                                  // padding: EdgeInsets.only(top: MySize.size14),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Weekly',
                                        style: AppTheme.getTextStyle(
                                          themeData.textTheme.caption,
                                          fontSize: MySize.size18,
                                          fontWeight: 700,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            index == 0
                                                ? '\$'
                                                : index == 1
                                                    ? ""
                                                    : "\$",
                                            style: AppTheme.getTextStyle(
                                              themeData.textTheme.caption,
                                              fontSize: MySize.size18,
                                              fontWeight: 600,
                                            ),
                                          ),
                                          Text(
                                            weekly[index].toString(),
                                            style: AppTheme.getTextStyle(
                                              themeData.textTheme.caption,
                                              fontSize: MySize.size18,
                                              fontWeight: 600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                MySize.size12,
                                MySize.size6,
                                MySize.size6,
                                MySize.size6,
                              ),
                              height: MySize.size100,
                              child: Card(
                                elevation: 8,
                                child: Container(
                                  // padding: EdgeInsets.only(top: MySize.size14),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Monthly',
                                        style: AppTheme.getTextStyle(
                                          themeData.textTheme.caption,
                                          fontSize: MySize.size18,
                                          fontWeight: 700,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            index == 0
                                                ? '\$'
                                                : index == 1
                                                    ? ""
                                                    : "\$",
                                            style: AppTheme.getTextStyle(
                                              themeData.textTheme.caption,
                                              fontSize: MySize.size18,
                                              fontWeight: 600,
                                            ),
                                          ),
                                          Text(
                                            monthly[index].toString(),
                                            style: AppTheme.getTextStyle(
                                              themeData.textTheme.caption,
                                              fontSize: MySize.size18,
                                              fontWeight: 600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                MySize.size6,
                                MySize.size6,
                                MySize.size12,
                                MySize.size6,
                              ),
                              height: MySize.size100,
                              child: Card(
                                elevation: 8,
                                child: Container(
                                  // padding: EdgeInsets.only(top: MySize.size14),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Yearly',
                                        style: AppTheme.getTextStyle(
                                          themeData.textTheme.caption,
                                          fontSize: MySize.size18,
                                          fontWeight: 700,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            index == 0
                                                ? '\$'
                                                : index == 1
                                                    ? ""
                                                    : "\$",
                                            style: AppTheme.getTextStyle(
                                              themeData.textTheme.caption,
                                              fontSize: MySize.size18,
                                              fontWeight: 600,
                                            ),
                                          ),
                                          Text(
                                            yearly[index].toString(),
                                            style: AppTheme.getTextStyle(
                                              themeData.textTheme.caption,
                                              fontSize: MySize.size18,
                                              fontWeight: 600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
                    child: Center(
                        child: Image.asset(
                      "assets/images/no_data_found.jpg",
                    )),
                  );
                }
              } else {
                return dashboardSkeleton(context);
              }
            },
          ),

          Container(
            padding: EdgeInsets.all(MySize.size12),
            child: Card(
              elevation: 10,
              child: ListTile(
                // tileColor: Colors.grey.shade50,
                leading: Icon(
                  Icons.location_pin,
                ),
                title: Text(
                  "Quick Quote",
                  style: AppTheme.getTextStyle(
                    themeData.textTheme.button,
                    fontWeight: 600,
                    // color: themeData.primaryColor,
                  ),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right_outlined,
                ),
                onTap: () {
                  setState(
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => QuickQoute(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          // QuickQoute()
        ],
      ),
    );
  }

  Widget buildSkeleton(BuildContext context) => Row(
        children: <Widget>[
          SkeletonContainer.circular(
            width: 70,
            height: 70,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SkeletonContainer.rounded(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 25,
              ),
              const SizedBox(height: 8),
              SkeletonContainer.rounded(
                width: 60,
                height: 13,
              ),
            ],
          ),
        ],
      );

  Widget dashboardSkeleton(BuildContext context) => Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    MySize.size12,
                    MySize.size6,
                    MySize.size6,
                    MySize.size6,
                  ),
                  height: MySize.size100,
                  child: Card(
                    elevation: 8,
                    child: Container(
                      // padding: EdgeInsets.only(top: MySize.size14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Today',
                            style: AppTheme.getTextStyle(
                              themeData.textTheme.subtitle2,
                              fontSize: MySize.size18,
                              fontWeight: 600,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MySize.size60,
                                height: MySize.size1 * 3,
                                child: LinearProgressIndicator(),
                              )
                              // SkeletonContainer.rounded(
                              //   width: MySize.size100,
                              //   height: MySize.size22,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    MySize.size6,
                    MySize.size6,
                    MySize.size12,
                    MySize.size6,
                  ),
                  height: MySize.size100,
                  child: Card(
                    elevation: 8,
                    child: Container(
                      // padding: EdgeInsets.only(top: MySize.size14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Weekly',
                            style: AppTheme.getTextStyle(
                              themeData.textTheme.subtitle2,
                              fontSize: MySize.size18,

                              fontWeight: 600,
                              // color: themeData.primaryColor,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MySize.size60,
                                height: MySize.size1 * 3,
                                child: LinearProgressIndicator(),
                              )
                              // SkeletonContainer.rounded(
                              //   width: MySize.size100,
                              //   height: MySize.size22,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    MySize.size12,
                    MySize.size6,
                    MySize.size6,
                    MySize.size6,
                  ),
                  height: MySize.size100,
                  child: Card(
                    elevation: 8,
                    child: Container(
                      // padding: EdgeInsets.only(top: MySize.size14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Monthly',
                            style: AppTheme.getTextStyle(
                              themeData.textTheme.subtitle2,
                              fontSize: MySize.size18,

                              fontWeight: 600,
                              // color: themeData.primaryColor,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MySize.size60,
                                height: MySize.size1 * 3,
                                child: LinearProgressIndicator(),
                              )
                              // SkeletonContainer.rounded(
                              //   width: MySize.size100,
                              //   height: MySize.size22,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    MySize.size6,
                    MySize.size6,
                    MySize.size12,
                    MySize.size6,
                  ),
                  height: MySize.size100,
                  child: Card(
                    elevation: 8,
                    child: Container(
                      // padding: EdgeInsets.only(top: MySize.size14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Yearly',
                            style: AppTheme.getTextStyle(
                              themeData.textTheme.subtitle2,
                              fontSize: MySize.size18,

                              fontWeight: 600,
                              // color: themeData.colorScheme.primary,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MySize.size60,
                                height: MySize.size1 * 3,
                                child: LinearProgressIndicator(),
                              )
                              // SkeletonContainer.rounded(
                              //   width: MySize.size100,
                              //   height: MySize.size22,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
}
