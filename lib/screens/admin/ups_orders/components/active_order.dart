import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:http/http.dart' as http;
import 'package:aquatic_xpress_shipping/screens/admin/ups_orders/components/listview.dart';

class ActiveOrders extends StatefulWidget {
  const ActiveOrders({Key? key}) : super(key: key);

  @override
  _ActiveOrdersState createState() => _ActiveOrdersState();
}

class _ActiveOrdersState extends State<ActiveOrders> {
  Future? futureUserList;
  late ThemeData themeData;

  bool isConnected = false;

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
        "${getCloudUrl()}/api/ShipmentOrder/getorderlist";
    // "${getCloudUrl()}​/api​/ShipmentOrder​/getfedexorderlist";

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
            return CustomListView(data: snapshot.data);
          } else {
            return Container(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Center(child: Text('No Data Found')),
            );
          }
        } else {
          return Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}
