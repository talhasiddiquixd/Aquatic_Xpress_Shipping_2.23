import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/components/custom_widgets/skeleton_container.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';

import 'package:http/http.dart' as http;
import 'package:aquatic_xpress_shipping/screens/user/profile/components/history_orders/components/listview.dart';

class UPSOrders extends StatefulWidget {
  final value;
  const UPSOrders({Key? key, required this.value}) : super(key: key);

  @override
  _UPSOrdersState createState() => _UPSOrdersState();
}

class _UPSOrdersState extends State<UPSOrders> {
  Future? futureUserList;
  late ThemeData themeData;

  @override
  void initState() {
    super.initState();
    futureUserList = getUsers();
  }

  getUsers() async {
    // quickQuote = 0;
    // curl();
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/ShipmentOrder/history";
    // "${getCloudUrl()}​​/api​/ShipmentOrder​/unpaidOrders";

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

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return FutureBuilder(
      future: futureUserList,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return (snapshot.data as List).length != 0
                ? CustomListView(data: snapshot.data, value:widget.value)
                : Center(
                    child: Image.asset(
                      "assets/images/no_data_found.jpg",
                    ),
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
          return listViewWithoutLeadingPictureWithoutExpandedSkeleton(context);
        }
      },
    );
  }
}
