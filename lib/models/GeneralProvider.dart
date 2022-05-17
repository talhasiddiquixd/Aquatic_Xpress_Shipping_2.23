import 'package:flutter/material.dart';

class GeneralProvider with ChangeNotifier {
  String? name;
  String? userName;
  double? balance;
  String? paymentId;
  dynamic receiptData;
  Function? updateShopItemList;
  int? themeVal;
}
