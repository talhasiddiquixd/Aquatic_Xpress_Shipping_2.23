import 'dart:async';
import 'dart:convert';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'custom_list.dart';
class UpsServiceGuarante extends StatefulWidget {
  const UpsServiceGuarante({ Key? key }) : super(key: key);

  @override
  _UpsServiceGuaranteState createState() => _UpsServiceGuaranteState();
}

class _UpsServiceGuaranteState extends State<UpsServiceGuarante> {
  bool isConnected = false;
  var data;
  getData() async {
    String? token = await getToken();
    var url = Uri.parse(
      "${getCloudUrl()}/api/ShipmentOrder/getserviceguatanteeorders");
        // "https://api.aquaticxpressshipping.com/admin/ServiceGuarantee");
    var response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      data = json.decode(response.body);
      print(data);
      return data;
    } else {
      print("why exception");
      throw Error;
    }
  }

  Future? futureData;
  @override
  void initState() {

    super.initState();
    futureData = getData();
    
  }

  

  late ThemeData themeData;
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return FutureBuilder(
      future: futureData,
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
