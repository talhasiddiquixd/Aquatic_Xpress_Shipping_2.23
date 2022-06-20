import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import 'package:connectivity/connectivity.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late ThemeData themeData;

  late TooltipBehavior _tooltipBehavior;
  late TooltipBehavior _tooltipBehavior1;

  late Future futureData;
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy');
  final String formatted = formatter.format(now);

  int selectedSize = 0;
  var orders = 0;
  List<dynamic> data = [];

  var stats;
  getStats() async {
    String? token = await getToken();
    var url = Uri.parse(
        "${getCloudUrl()}/api/ShipmentOrder/getdailyweeklyyearlyordercount");
    var response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      stats = json.decode(response.body);
      print("monthly " + orders.toString());
    }
    return stats;
  }

  var padding = EdgeInsets.fromLTRB(
    MySize.size14,
    MySize.size14,
    MySize.size14,
    0,
  );
  //String? _selectedCourierService;
  late Future futureChart;
  bool isConnected = true;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _tooltipBehavior1 = TooltipBehavior(enable: true);

    super.initState();
    futureData = getStats();

    futureChart = getProgressData();
    
    //  setState(() {});
  }

  

  var results;
  var profitResults;
  getProgressData() async {
    // quickQuote = 0;
    // curl();
    String? token = await getToken();
    var url = Uri.parse(
        "${getCloudUrl()}/api/shipmentorder/getmonthlyreport/" +
            formatted);
    var response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    var urls = Uri.parse(
        "${getCloudUrl()}/api/ShipmentOrder/getptpsales/" +
            formatted);
    var ptpResponse = await http.get(
      urls,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
print(response.statusCode);
    if (response.statusCode == 200) {
      results = json.decode(response.body);

      print("Progress Report " + results.toString());
      chartData = [
        SalesData("Jan", results!["jan"]),
        SalesData("Feb", results!["feb"]),
        SalesData("Mar", results!["mar"]),
        SalesData("April", results!["apr"]),
        SalesData("May", results!["may"]),
        SalesData("Jun", results!["jun"]),
        SalesData("July", results!["jul"]),
        SalesData("Aug", results!["aug"]),
        SalesData("Sept", results!["sep"]),
        SalesData("Oct", results!["oct"]),
        SalesData("Nov", results!["nov"]),
        SalesData("Dec", results!["dec"]),
      ];
    }
    if (ptpResponse.statusCode == 200) {
      profitResults = json.decode(ptpResponse.body);

      profitData = [
        TotalProfit("Jan", profitResults[2]["Value"][0].toDouble()),
        TotalProfit("Feb", profitResults[2]["Value"][1].toDouble()),
        TotalProfit("Mar", profitResults[2]["Value"][2].toDouble()),
        TotalProfit("Apr", profitResults[2]["Value"][3].toDouble()),
        TotalProfit("May", profitResults[2]["Value"][4].toDouble()),
        TotalProfit("Jun", profitResults[2]["Value"][5].toDouble()),
        TotalProfit("July", profitResults[2]["Value"][6].toDouble()),
        TotalProfit("Aug", profitResults[2]["Value"][7].toDouble()),
        TotalProfit("Sept", profitResults[2]["Value"][8].toDouble()),
        TotalProfit("Oct", profitResults[2]["Value"][9].toDouble()),
        TotalProfit("Nov", profitResults[2]["Value"][10].toDouble()),
        TotalProfit("Dec", profitResults[2]["Value"][11].toDouble()),
      ];

      upsData = [
        TotalProfit("Jan", profitResults[0]["Value"][0].toDouble()),
        TotalProfit("Feb", profitResults[0]["Value"][1].toDouble()),
        TotalProfit("Mar", profitResults[0]["Value"][2].toDouble()),
        TotalProfit("Apr", profitResults[0]["Value"][3].toDouble()),
        TotalProfit("May", profitResults[0]["Value"][4].toDouble()),
        TotalProfit("Jun", profitResults[0]["Value"][5].toDouble()),
        TotalProfit("July", profitResults[0]["Value"][6].toDouble()),
        TotalProfit("Aug", profitResults[0]["Value"][7].toDouble()),
        TotalProfit("Sept", profitResults[0]["Value"][8].toDouble()),
        TotalProfit("Oct", profitResults[0]["Value"][9].toDouble()),
        TotalProfit("Nov", profitResults[0]["Value"][10].toDouble()),
        TotalProfit("Dec", profitResults[0]["Value"][11].toDouble()),
      ];
      // fedexData = [
      //   TotalProfit("Jan", profitResults[1]["Value"][0].toDouble()),
      //   TotalProfit("Feb", profitResults[1]["Value"][1].toDouble()),
      //   TotalProfit("Mar", profitResults[1]["Value"][2].toDouble()),
      //   TotalProfit("Apr", profitResults[1]["Value"][3].toDouble()),
      //   TotalProfit("May", profitResults[1]["Value"][4].toDouble()),
      //   TotalProfit("Jun", profitResults[1]["Value"][5].toDouble()),
      //   TotalProfit("July", profitResults[1]["Value"][6].toDouble()),
      //   TotalProfit("Aug", profitResults[1]["Value"][7].toDouble()),
      //   TotalProfit("Sept", profitResults[1]["Value"][8].toDouble()),
      //   TotalProfit("Oct", profitResults[1]["Value"][9].toDouble()),
      //   TotalProfit("Nov", profitResults[1]["Value"][10].toDouble()),
      //   TotalProfit("Dec", profitResults[1]["Value"][11].toDouble()),
      // ];
    }
  }

  List<TotalProfit> upsData = [];
  List<TotalProfit> fedexData = [];
  List<TotalProfit> profitData = [];
  List<SalesData> chartData = [];
  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    themeData = Theme.of(context);

    return SingleChildScrollView(
        child: Container(
            padding: padding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 15,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                "Orders",
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.caption,
                                  fontSize: MySize.size18,
                                  fontWeight: 700,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedSize = 0;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 12, right: 12, top: 8, bottom: 8),
                                  decoration: BoxDecoration(
                                    color: selectedSize == 0
                                        ? themeData.colorScheme.primary
                                        : Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                        color: themeData.colorScheme.primary,
                                        width: 1),
                                  ),
                                  child: Text(
                                    "This Month",
                                    style: AppTheme.getTextStyle(
                                        themeData.textTheme.caption,
                                        color: selectedSize == 0
                                            ? themeData.colorScheme.onPrimary
                                            : themeData
                                                .colorScheme.onBackground,
                                        fontWeight:
                                            selectedSize == 0 ? 600 : 500,
                                        letterSpacing: 0),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedSize = 1;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 12, right: 12, top: 8, bottom: 8),
                                  decoration: BoxDecoration(
                                    color: selectedSize == 1
                                        ? themeData.colorScheme.primary
                                        : Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                        color: themeData.colorScheme.primary,
                                        width: 1),
                                  ),
                                  child: Text(
                                    "This Week",
                                    style: AppTheme.getTextStyle(
                                        themeData.textTheme.caption,
                                        color: selectedSize == 1
                                            ? themeData.colorScheme.onPrimary
                                            : themeData
                                                .colorScheme.onBackground,
                                        fontWeight:
                                            selectedSize == 1 ? 600 : 500,
                                        letterSpacing: 0),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedSize = 2;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 12, right: 12, top: 8, bottom: 8),
                                  decoration: BoxDecoration(
                                    color: selectedSize == 2
                                        ? themeData.colorScheme.primary
                                        : Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)),
                                    border: Border.all(
                                        color: themeData.colorScheme.primary,
                                        width: 1),
                                  ),
                                  child: Text(
                                    "Today",
                                    style: AppTheme.getTextStyle(
                                      themeData.textTheme.caption,
                                      color: selectedSize == 2
                                          ? themeData.colorScheme.onPrimary
                                          : themeData.colorScheme.onBackground,
                                      fontWeight: selectedSize == 2 ? 600 : 500,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          selectedSize == 0
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FutureBuilder(
                                        future: futureData,
                                        builder:
                                            (BuildContext context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.hasData) {
                                              return stats["monthly"]
                                                      .toString()
                                                      .isEmpty
                                                  ? Text("No Data")
                                                  : Text(
                                                      stats["monthly"]
                                                          .toString(),
                                                      // return data[selectedSize]
                                                      //         .toString()
                                                      //         .isEmpty
                                                      //     ? Text("No Data")
                                                      //     : Text(
                                                      //         (data[selectedSize]
                                                      //             .toString()),
                                                      style:
                                                          AppTheme.getTextStyle(
                                                        themeData.textTheme
                                                            .headline4,
                                                        fontWeight: 600,
                                                      ),
                                                    );
                                            }
                                            {
                                              return Text("No Data");
                                            }
                                          }
                                          {
                                            return CircularProgressIndicator();
                                          }
                                        }),
                                    Text(
                                      "Orders in this Month",
                                      style: AppTheme.getTextStyle(
                                        themeData.textTheme.bodyText2,
                                        color: Colors.grey.shade500,
                                        fontWeight: 500,
                                      ),
                                    ),
                                  ],
                                )
                              : selectedSize == 1
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          FutureBuilder(
                                              future: futureData,
                                              builder: (BuildContext context,
                                                  snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  if (snapshot.hasData) {
                                                    return stats["monthly"]
                                                            .toString()
                                                            .isEmpty
                                                        ? Text("No Data")
                                                        : Text(
                                                            stats["weekly"]
                                                                .toString(),
                                                            style: AppTheme
                                                                .getTextStyle(
                                                              themeData
                                                                  .textTheme
                                                                  .headline4,
                                                              fontWeight: 600,
                                                            ),
                                                          );
                                                  }
                                                  {
                                                    return Text("No Data");
                                                  }
                                                }
                                                {
                                                  return CircularProgressIndicator();
                                                }
                                              }),
                                          Text(
                                            "Orders in this Week",
                                            style: AppTheme.getTextStyle(
                                              themeData.textTheme.bodyText2,
                                              color: Colors.grey.shade500,
                                              fontWeight: 500,
                                            ),
                                          ),
                                        ])
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          FutureBuilder(
                                              future: futureData,
                                              builder: (BuildContext context,
                                                  snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  if (snapshot.hasData) {
                                                    return stats["daily"] ==
                                                            null
                                                        ? Text(
                                                            "Internet Dislodged")
                                                        : Text(
                                                            stats["daily"]
                                                                .toString(),
                                                            style: AppTheme
                                                                .getTextStyle(
                                                              themeData
                                                                  .textTheme
                                                                  .headline4,
                                                              fontWeight: 600,
                                                            ),
                                                          );
                                                  }
                                                  {
                                                    return Text("No Data");
                                                  }
                                                }

                                                {
                                                  return CircularProgressIndicator();
                                                }
                                              }),
                                          Text(
                                            "Orders in this Today",
                                            style: AppTheme.getTextStyle(
                                              themeData.textTheme.bodyText2,
                                              color: Colors.grey.shade500,
                                              fontWeight: 500,
                                            ),
                                          ),
                                        ])
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 15,
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "Progress Report",
                                          style: AppTheme.getTextStyle(
                                            themeData.textTheme.headline6,
                                            fontWeight: 600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 1,
                              ),

                              /////////////////////////////////////
                              Column(
                                children: [
                                  FutureBuilder(
                                    future: futureChart,
                                    builder: (BuildContext context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .23,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          child: SfCartesianChart(
                                              //title: ChartTitle(text: 'Yearly sales analysis'),
                                              legend: Legend(isVisible: true ,position: LegendPosition.bottom),
                                              tooltipBehavior: _tooltipBehavior,
                                              series: <LineSeries>[
                                                LineSeries<SalesData, String>(
                                                  name: 'Prog Report',

                                                  dataSource: chartData,
                                                  xValueMapper:
                                                      (SalesData year, _) =>
                                                          year.year,
                                                  yValueMapper:
                                                      (SalesData sales, _) =>
                                                          sales.sales,
                                                  dataLabelSettings:
                                                      DataLabelSettings(
                                                          isVisible: true),
                                                  enableTooltip: true,
                                                  color: Colors.green,
                                                  width: 2,
                                                  opacity: 1,
                                                  // dashArray: <double>[5,5],
                                                  // splineType: SplineType.cardinal,
                                                  // cardinalSplineTension: 0.9))
                                                )
                                              ],
                                              primaryXAxis: CategoryAxis()
                                              //   edgeLabelPlacement: EdgeLabelPlacement.shift,
                                              // ),
                                              ),
                                        );
                                      }

                                      return LinearProgressIndicator();
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 15,
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          " Profit",
                                          style: AppTheme.getTextStyle(
                                            themeData.textTheme.headline6,
                                            fontWeight: 600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              Column(
                                children: [
                                  FutureBuilder(
                                    future: futureChart,
                                    builder: (BuildContext context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .27,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              2,
                                          child: SfCartesianChart(

                                              //title: ChartTitle(text: 'Yearly sales analysis'),
                                              legend: Legend(isVisible: true,position: LegendPosition.bottom),
                                              
                                              tooltipBehavior:
                                                  _tooltipBehavior1,
                                              series: <
                                                  LineSeries<TotalProfit,
                                                      String>>[
                                                LineSeries<TotalProfit, String>(
                                                  name: 'Total Profit',
                                                  dataSource: profitData,
                                                  xValueMapper:
                                                      (TotalProfit year, _) =>
                                                          year.year,
                                                  yValueMapper:
                                                      (TotalProfit sales, _) =>
                                                          sales.profit,
                                                  dataLabelSettings:
                                                      DataLabelSettings(
                                                          isVisible: true),
                                                  enableTooltip: true,
                                                  color: Colors.green,
                                                  width: 2,
                                                  opacity: 1,
                                                  // dashArray: <double>[5,5],
                                                  // splineType: SplineType.cardinal,
                                                  // cardinalSplineTension: 0.9))
                                                ),
                                                // LineSeries<TotalProfit, String>(
                                                //   name: 'Fedex Profit',
                                                //   dataSource: fedexData,
                                                //   xValueMapper:
                                                //       (TotalProfit year, _) =>
                                                //           year.year,
                                                //   yValueMapper:
                                                //       (TotalProfit sales, _) =>
                                                //           sales.profit,
                                                //   dataLabelSettings:
                                                //       DataLabelSettings(
                                                //           isVisible: true),
                                                //   enableTooltip: true,
                                                //   color: Colors.blue,
                                                //   width: 2,
                                                //   opacity: 1,

                                                //   // dashArray: <double>[5,5],
                                                //   // splineType: SplineType.cardinal,
                                                //   // cardinalSplineTension: 0.9))
                                                // ),
                                                LineSeries<TotalProfit, String>(
                                                  name: 'UPS Profit',
                                                  dataSource: upsData,
                                                  xValueMapper:
                                                      (TotalProfit year, _) =>
                                                          year.year,
                                                  yValueMapper:
                                                      (TotalProfit sales, _) =>
                                                          sales.profit,
                                                  dataLabelSettings:
                                                      DataLabelSettings(
                                                          isVisible: true),
                                                  enableTooltip: true,
                                                  color: Colors.red,
                                                  width: 0.5,
                                                  opacity: 1,
                                                  // dashArray: <double>[5,5],
                                                  // splineType: SplineType.cardinal,
                                                  // cardinalSplineTension: 0.9))
                                                )
                                              ],
                                              primaryXAxis: CategoryAxis()
                                              //   edgeLabelPlacement: EdgeLabelPlacement.shift,
                                              // ),
                                              ),
                                        );
                                      }

                                      return LinearProgressIndicator();
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )));
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final int sales;
}

class TotalProfit {
  TotalProfit(this.year, this.profit);
  final String year;
  final double profit;
}
