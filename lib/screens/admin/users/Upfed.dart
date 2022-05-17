import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';

import 'package:http/http.dart' as http;
import 'package:aquatic_xpress_shipping/screens/admin/users/Upfedlist.dart';

class Upfed extends StatefulWidget {
  const Upfed({Key? key, this.id, this.indexValue}) : super(key: key);
  final id;
  final indexValue;

  @override
  _UpfedState createState() => _UpfedState();
}

class _UpfedState extends State<Upfed> {
  var upsData;
  List profit = [];
  late ThemeData themeData;

  List data = [];
  int? selectedValue;
  getData() async {
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/shipmentorder/getunpaidorderlist/0fca154e-6ad3-4d13-bf0d-55739d8c1c68 "+
            widget.id.toString();
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
      upsData = json.decode(response.body);
      data.add(upsData);
      print("???????");

      for (int i = 0; i < upsData.length; i++) {
        profit.add(upsData[i]["totalPrice"] - upsData[i]["upsServiceRate"]);
      }
      print(data);
      return upsData;
    } else {
      print("Exception");
      throw Error;
    }
  }

  var fedexData;

  getFedexData() async {
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/ShipmentOrder/adminfedexunpaidactiveShipment/" +
            widget.id.toString();
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
      fedexData = json.decode(response.body);
      data.add(fedexData);
      print("???????");

      for (int i = 0; i < fedexData.length; i++) {
        profit.add(fedexData[i]["totalPrice"] - fedexData[i]["upsServiceRate"]);
        data.add(fedexData);
      }
      return fedexData;
    } else {
      print("Exception");
      throw Error;
    }
  }

  Future? futureData;
  Future? futurefedex;
  bool isConnected = false;
  @override
  void initState() {
    super.initState();
    if (widget.indexValue == 0) {
      futureData = getData();
    }
    if (widget.indexValue == 1) {
      futureData = getFedexData();
    }
    
  }

  

  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return FutureBuilder(
      future: futureData,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (data[0].isEmpty) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Center(child: Text('No Data Found')),
            );
          } else {
            return  Upfedlist(
              data: data[0],
              profit: profit,
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
