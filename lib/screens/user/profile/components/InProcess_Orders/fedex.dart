import 'dart:convert';
import 'package:aquatic_xpress_shipping/screens/user/profile/components/InProcess_Orders/List.dart';
import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/components/custom_widgets/skeleton_container.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';

import 'package:http/http.dart' as http;

class InProcessFedexOrders extends StatefulWidget {
  final value;
  const InProcessFedexOrders({Key? key, required this.value}) : super(key: key);

  @override
  _InProcessFedexOrdersState createState() => _InProcessFedexOrdersState();
}

class _InProcessFedexOrdersState extends State<InProcessFedexOrders> {
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
    "${getCloudUrl()}/api/Credit/getUserUpChargeHistory";
        // "https://devapi.aquaticxpressshipping.com/api/ShipmentOrder/fedexunpaidOrders";
    // "${getCloudUrl()}​/api/ShipmentOrder/fedexunpaidOrders";

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
