import 'package:aquatic_xpress_shipping/helper/theme.dart';
import 'package:aquatic_xpress_shipping/screens/admin/Announcements/heybaby.dart';
import 'package:aquatic_xpress_shipping/screens/admin/Ups%20Service%20Guarantee/ups_service_guarante.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/screens/admin/Service/Service.dart';
import 'package:aquatic_xpress_shipping/screens/admin/dashboard/dashboard.dart';
import 'package:aquatic_xpress_shipping/screens/admin/fedex_orders/fedex_orders_screen.dart';
import 'package:aquatic_xpress_shipping/screens/admin/profile/profile_screen.dart';
import 'package:aquatic_xpress_shipping/screens/admin/shop/shop_screen.dart';
import 'package:aquatic_xpress_shipping/screens/admin/ups_orders/ups_orders_screen.dart';
import 'package:aquatic_xpress_shipping/screens/admin/users/users.dart';
import 'package:aquatic_xpress_shipping/screens/auth/sign_in/sign_in_screen.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:provider/provider.dart';

class Admin extends StatefulWidget {
  Admin({Key? key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  int _selectedPage = 0;
  late ThemeData themeData;

  final List<Widget> _fragmentView = [
    Dashboard(),
    Profile(),
    Serive(),
    FedexOrders(),
    UPSOrders(),
    Shop(),
    Users(),
    Heybaby(),
    UpsServiceGuarante(),

  ];

  final List<String> _fragmentTitle = [
    "Dashboard",
    "Account",
    "Service",
    "Fedex Orders",
    "UPS Orders",
    "Shop",
    "Users",
    "Announcements",
    "UPS Service Guarante"
  ];

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    //You will need to initialize MySize class for responsive spaces.
    MySize().init(context);
    themeData = Theme.of(context);

    return Scaffold(
      key: _drawerKey,
      backgroundColor: themeData.colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          _fragmentTitle[_selectedPage],
        ),
      ),
      body: _fragmentView[_selectedPage],
      drawer: Drawer(
        child: Container(
          //  height: MediaQuery.of(context).size.height * 1.1,
          color: themeData.backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SafeArea(
                child: Container(
                  // padding: Spacing.only(left: 16, bottom: 24, top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage("assets/icons/logo.png"),
                        height: 202,
                        width: 202,
                      ),
                      // Space.height(16),
                      Container(
                        padding: Spacing.fromLTRB(12, 4, 12, 4),
                        decoration: BoxDecoration(
                            color: themeData.colorScheme.primary.withAlpha(40),
                            borderRadius: Shape.circular(16)),
                        child: Text(
                          "v. 1.0.0",
                          style: AppTheme.getTextStyle(
                            themeData.textTheme.caption,
                            color: themeData.colorScheme.primary,
                            fontWeight: 600,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(MdiIcons.viewDashboard,
                              color: _selectedPage == 0
                                  ? themeData.colorScheme.primary
                                  : themeData.colorScheme.onBackground),
                          title: Text("Dashboard",
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.subtitle2,
                                  fontWeight: _selectedPage == 0 ? 700 : 600,
                                  color: _selectedPage == 0
                                      ? themeData.colorScheme.primary
                                      : themeData.colorScheme.onBackground)),
                          onTap: () {
                            setState(() {
                              _selectedPage = 0;
                              _drawerKey.currentState!.openEndDrawer();
                            });
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.manage_accounts_sharp,
                              color: _selectedPage == 1
                                  ? themeData.colorScheme.primary
                                  : themeData.colorScheme.onBackground),
                          title: Text("Profile",
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.subtitle2,
                                  fontWeight: _selectedPage == 1 ? 700 : 600,
                                  color: _selectedPage == 1
                                      ? themeData.colorScheme.primary
                                      : themeData.colorScheme.onBackground)),
                          onTap: () {
                            setState(() {
                              _selectedPage = 1;
                              _drawerKey.currentState!.openEndDrawer();
                            });
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.miscellaneous_services_outlined,
                            color: _selectedPage == 2
                                ? themeData.colorScheme.primary
                                : themeData.colorScheme.onBackground,
                            size: 24,
                          ),
                          title: Text("Service",
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.subtitle2,
                                  fontWeight: _selectedPage == 2 ? 700 : 600,
                                  color: _selectedPage == 2
                                      ? themeData.colorScheme.primary
                                      : themeData.colorScheme.onBackground)),
                          onTap: () {
                            setState(() {
                              _selectedPage = 2;
                              _drawerKey.currentState!.openEndDrawer();
                            });
                          },
                        ),
                        // ListTile(
                        //   leading: Icon(
                        //     Icons.view_list,
                        //     color: _selectedPage == 3
                        //         ? themeData.colorScheme.primary
                        //         : themeData.colorScheme.onBackground,
                        //     size: 24,
                        //   ),
                        //   title: Text("Fedex Orders",
                        //       style: AppTheme.getTextStyle(
                        //           themeData.textTheme.subtitle2,
                        //           fontWeight: _selectedPage == 3 ? 700 : 600,
                        //           color: _selectedPage == 3
                        //               ? themeData.colorScheme.primary
                        //               : themeData.colorScheme.onBackground)),
                        //   onTap: () {
                        //     setState(() {
                        //       _selectedPage = 3;
                        //       _drawerKey.currentState!.openEndDrawer();
                        //     });
                        //   },
                        // ),
                        ListTile(
                          leading: Icon(Icons.view_list,
                              color: _selectedPage == 4
                                  ? themeData.colorScheme.primary
                                  : themeData.colorScheme.onBackground),
                          title: Text("Ups Orders",
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.subtitle2,
                                  fontWeight: _selectedPage == 4 ? 700 : 600,
                                  color: _selectedPage == 4
                                      ? themeData.colorScheme.primary
                                      : themeData.colorScheme.onBackground)),
                          onTap: () {
                            setState(() {
                              _selectedPage = 4;
                              _drawerKey.currentState!.openEndDrawer();
                            });
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.shop,
                            color: _selectedPage == 5
                                ? themeData.colorScheme.primary
                                : themeData.colorScheme.onBackground,
                          ),
                          title: Text(
                            "Shop",
                            style: AppTheme.getTextStyle(
                              themeData.textTheme.subtitle2,
                              fontWeight: _selectedPage == 5 ? 700 : 600,
                              color: _selectedPage == 5
                                  ? themeData.colorScheme.primary
                                  : themeData.colorScheme.onBackground,
                            ),
                          ),
                          onTap: () {
                            setState(
                              () {
                                _selectedPage = 5;
                                _drawerKey.currentState!.openEndDrawer();
                              },
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.verified_user,
                            color: _selectedPage == 6
                                ? themeData.colorScheme.primary
                                : themeData.colorScheme.onBackground,
                          ),
                          title: Text(
                            "Users",
                            style: AppTheme.getTextStyle(
                              themeData.textTheme.subtitle2,
                              fontWeight: _selectedPage == 6 ? 700 : 600,
                              color: _selectedPage == 6
                                  ? themeData.colorScheme.primary
                                  : themeData.colorScheme.onBackground,
                            ),
                          ),
                          onTap: () {
                            setState(
                              () {
                                _selectedPage = 6;
                                _drawerKey.currentState!.openEndDrawer();
                              },
                            );
                          },
                        ),
                        // ListTile(
                        //   leading: Icon(
                        //     Icons.ring_volume_outlined,
                        //     color: _selectedPage == 7
                        //         ? themeData.colorScheme.primary
                        //         : themeData.colorScheme.onBackground,
                        //   ),
                        //   title: Text(
                        //     "Alert",
                        //     style: AppTheme.getTextStyle(
                        //       themeData.textTheme.subtitle2,
                        //       fontWeight: _selectedPage == 7 ? 700 : 600,
                        //       color: _selectedPage == 7
                        //           ? themeData.colorScheme.primary
                        //           : themeData.colorScheme.onBackground,
                        //     ),
                        //   ),
                        //   onTap: () {
                        //     setState(
                        //       () {
                        //         _selectedPage = 7;
                        //         _drawerKey.currentState!.openEndDrawer();
                        //       },
                        //     );
                        //   },
                        // ),
                          ListTile(
                          leading: Icon(
                            Icons.announcement_rounded,
                            color: _selectedPage == 8
                                ? themeData.colorScheme.primary
                                : themeData.colorScheme.onBackground,
                          ),
                          title: Text(
                            "Ups Service Guarantee",
                            style: AppTheme.getTextStyle(
                              themeData.textTheme.subtitle2,
                              fontWeight: _selectedPage == 8 ? 700 : 600,
                              color: _selectedPage == 8
                                  ? themeData.colorScheme.primary
                                  : themeData.colorScheme.onBackground,
                            ),
                          ),
                          onTap: () {
                            setState(
                              () {
                                _selectedPage = 8;
                                _drawerKey.currentState!.openEndDrawer();
                              },
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.logout,
                            color: _selectedPage == 9
                                ? themeData.colorScheme.primary
                                : themeData.colorScheme.onBackground,
                          ),
                          title: Text(
                            "Logout",
                            style: AppTheme.getTextStyle(
                              themeData.textTheme.subtitle2,
                              fontWeight: _selectedPage == 9 ? 700 : 600,
                              color: _selectedPage == 9
                                  ? themeData.colorScheme.primary
                                  : themeData.colorScheme.onBackground,
                            ),
                          ),
                          onTap: () {
                            setState(
                              () {
                                logoutCleaner();
                                // _selectedPage = 5;
                                _drawerKey.currentState!.openEndDrawer();
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => SignInScreen()),
                                  (Route<dynamic> route) => false,
                                );
                              },
                            );
                          },
                        ),
                        ListTile(
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
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
