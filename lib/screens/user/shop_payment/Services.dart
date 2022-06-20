import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http_auth/http_auth.dart';

class Services {
  // String domain = "https://api.sandbox.paypal.com"; // for sandbox mode
 String domain = "https://api.paypal.com"; // for production mode

  // change clientId and secret with your own, provided by paypal
   String clientId =
   'AVcLWf7DXavg2BwcyziY0orEEF-DzqF0pkXGMm1JI33Ryf26-P3etv31_aZ5G9z8Z-B0LPFsQ4ctlWPL';
      // 'AUedUnHVJFup2E2r-JEBQmUMqOv_isN6i1JRr5AumAAVHx53-AVKYtjMjxZ-pzKjoOE94LBQdcrQrM1i';
  String secret =
  'ECVvQAzeQ_D7fT8Tg5A4VUZ854_lvXkvMyFYuZPEf9A_5NwTP-MU7uY_O244vDB_l2n5e80KB75mOhX8';
      // 'EFPD5SIVIui95gdZCWsPlxYZiX8XDtuYLEs4b5gjoLa3vGmSdC8qgrKP8aEpsadJ_YAuNPB7zZwDxaNM';


  // for getting the access token from Paypal
  Future<String?> getAccessToken() async {
    try {
      String ?link = '$domain/v1/oauth2/token?grant_type=client_credentials';
      var url = Uri.parse(link);

      var client = BasicAuthClient(clientId, secret);
      var response = await client.post(url);
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return body["access_token"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // for creating the payment request with Paypal
  Future<Map<String, String>?> createPaypalPayment(
    transactions,
    accessToken,
  ) async {
    try {
      String ?link = '$domain/v1/payments/payment';
      var url = Uri.parse(link);

      var response = await http.post(
        url,
        body: convert.jsonEncode(transactions),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer ' + accessToken
        },
      );

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  // for executing the payment transaction
  executePayment(url, payerId, accessToken, context) async {
    try {
      var response = await http.post(
        Uri.parse(url),
        body: convert.jsonEncode({"payer_id": payerId}),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer ' + accessToken
        },
      );

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return body;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
