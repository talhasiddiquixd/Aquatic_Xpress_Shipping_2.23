import 'dart:convert';

import 'package:aquatic_xpress_shipping/helper/theme.dart';
import 'package:aquatic_xpress_shipping/screens/user/profile/components/InProcess_Orders/InProcess_orders.dart';
import 'package:aquatic_xpress_shipping/screens/user/profile/components/upcharges%20Service/announcements.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/models/GeneralProvider.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/screens/auth/sign_in/sign_in_screen.dart';
import 'package:aquatic_xpress_shipping/screens/user/profile/components/box_preferences/box_preferences_screen.dart';
import 'package:aquatic_xpress_shipping/screens/user/profile/components/change_password/change_password.dart';
import 'package:aquatic_xpress_shipping/screens/user/profile/components/history_orders/history_orders_screen.dart';
import 'package:aquatic_xpress_shipping/screens/user/profile/components/personal_information/personal_information.dart';
import 'package:aquatic_xpress_shipping/screens/user/profile/components/unpaid_orders/unpaid_orders_screen.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';

import 'profile_menu.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late ThemeData themeData;
  String? user;
  getData() async {
    user = await getName();
    setState(() {});
  }

  getBalance() async {
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/Debit/checkbalance";
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
      var balance = json.decode(response.body);

      print(balance);

      return balance;
    } else {
      print("Exception");
      throw Error;
    }
  }

  late Future futureBalance;
  @override
  void initState() {
    super.initState();
    futureBalance = getBalance();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    themeData = themeData = Theme.of(context);
    

    print(Provider.of<GeneralProvider>(context, listen: false).paymentId);
    MySize().init(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: MySize.size20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(MySize.size12),
            child: Card(
              color: themeData.colorScheme.background,
              elevation: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MySize.size16),
              ),
              child: Container(
                padding: EdgeInsets.all(MySize.size12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome ",
                          style: AppTheme.getTextStyle(
                            themeData.textTheme.headline6,
                            fontWeight: 600,
                          ),
                        ),
                        Text(
                          user.toString(),
                          style: AppTheme.getTextStyle(
                            themeData.textTheme.headline6,
                            fontWeight: 600,
                            color: themeData.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MySize.size10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Balance: ",
                          style: AppTheme.getTextStyle(
                            themeData.textTheme.caption,
                            muted: true,
                            fontSize: MySize.size16,
                            fontWeight: 800,
                          ),
                        ),
                        FutureBuilder(
                            future: futureBalance,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return Text(
                                    "\$" + snapshot.data.toString(),
                                    style: AppTheme.getTextStyle(
                                      themeData.textTheme.caption,
                                      muted: true,
                                      fontSize: MySize.size16,
                                      fontWeight: 600,
                                    ),
                                  );
                                }
                              }
                              return Text(
                                "loading",
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.caption,
                                  muted: true,
                                  fontSize: MySize.size16,
                                  fontWeight: 600,
                                ),
                              );
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          ProfileMenu(
            text: "Personal Information",
            icon: Icon(
              MdiIcons.bagPersonal,
            ),
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PersonalInformation(),
                ),
              );
            },
          ),
          ProfileMenu(
            text: "Change Password",
            icon: Icon(
              MdiIcons.keyChange,
            ),
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChangePassword(),
                ),
              );
            },
          ),
          ProfileMenu(
            text: "Box Preferences",
            icon: Icon(
              MdiIcons.boxShadow,
            ),
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BoxPreferences(),
                ),
              );
            },
          ),
          ProfileMenu(
            text: "InProcess Orders",
            icon: Icon(
              MdiIcons.cash,
            ),
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => InProcess(),
                ),
              );
            },
          ),
          ProfileMenu(
            text: "Unpaid Orders",
            icon: Icon(
              MdiIcons.cash,
            ),
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UnpaidOrders(),
                ),
              );
            },
          ),
          ProfileMenu(
            text: "Service Upcharge",
            icon: Icon(Icons.announcement_outlined),
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Announcements()),
              );
            },
          ),
          ProfileMenu(
            text: "History",
            icon: Icon(
              MdiIcons.history,
            ),
            press: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HistoryOrders(),
                ),
              );
            },
          ),
          ProfileMenu(
            text: "Log Out",
            icon: Icon(
              MdiIcons.logout,
            ),
            press: () {
              logoutCleaner();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SignInScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: MySize.size12,
              vertical: MySize.size4,
            ),
            child: ListTile(
              tileColor: themeData.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              leading: Icon(MdiIcons.themeLightDark),
              title: Text(
                "Dark Mode",
                style: AppTheme.getTextStyle(
                  themeData.textTheme.subtitle2,
                ),
              ),
              trailing: Consumer<ThemeNotifier>(
                builder: (context, notifier, child) => Switch(
                  onChanged: (val) {
                    notifier.toggleChangeTheme();
                  },
                  value: notifier.darkMode,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
