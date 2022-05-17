import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:http/http.dart' as http;
import 'package:aquatic_xpress_shipping/screens/admin/Service/CustomListView.dart';


class Upcharge extends StatefulWidget {
  const Upcharge({Key? key}) : super(key: key);

  @override
  _UpchargeState createState() => _UpchargeState();
}

class _UpchargeState extends State<Upcharge> {
  bool isConnected = false;
  var data;
  getData() async {
    String? token = await getToken();
    var url = Uri.parse(
        "${getCloudUrl()}/api/Credit/getadminpastduedata");
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
      print("Exception");
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
