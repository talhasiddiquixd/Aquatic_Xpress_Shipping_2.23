import 'dart:convert';

import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/screens/user/home/components/model.dart';
import 'package:http/http.dart';

class NewsApi {
  Client client = Client();
  Future fetchAlbum() async {
    // String? token = await getToken();
    final response = await client.get(
      Uri.parse(
          '${getCloudUrl()}/api/ShipmentOrder/totalavgcost'),
      headers: {
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjMyZTJmYTZmLTdlNTEtNGQ4ZC1iNTQ3LTA3YzE5ZGRmYWZiOCIsInJvbGUiOiJVc2VyIiwibmJmIjoxNjM1NzUwMTI3LCJleHAiOjE2MzYzNTQ5MjcsImlhdCI6MTYzNTc1MDEyN30.MvLCoKoS_opJ4TQbzYPQTSjan4rh4WVUdb1Ia2IBtSY",
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  var orders;
  Future avgCost() async {
    String? token = await getToken();

    var url = Uri.parse(
        "${getCloudUrl()}/api/ShipmentOrder/totalavgcost");
    var response = await client.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      orders = json.decode(response.body);
      return orders;
    } else {
      // print("Exception");
      throw Error;
    }
  }
}
