import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';

import 'package:aquatic_xpress_shipping/screens/user/profile/components/history_orders/components/fedex_orders.dart';
import 'package:aquatic_xpress_shipping/screens/user/profile/components/history_orders/components/shop_orders.dart';
import 'package:aquatic_xpress_shipping/screens/user/profile/components/history_orders/components/ups_orders.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';

class HistoryOrders extends StatefulWidget {
  @override
  _HistoryOrdersState createState() => _HistoryOrdersState();
}

class _HistoryOrdersState extends State<HistoryOrders>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  late TabController _tabController;

  _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabSelection);
    _tabController.animation!.addListener(() {
      final aniValue = _tabController.animation!.value;
      if (aniValue - _currentIndex > 0.5) {
        setState(() {
          _currentIndex = _currentIndex + 1;
        });
      } else if (aniValue - _currentIndex < -0.5) {
        setState(() {
          _currentIndex = _currentIndex - 1;
        });
      }
    });
    super.initState();
  }

  onTapped(value) {
    setState(() {
      _currentIndex = value;
    });
  }

  dispose() {
    super.dispose();
    _tabController.dispose();
  }

  late ThemeData themeData;

  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          _currentIndex == 0
              ? 'Product Order History'
              : _currentIndex == 1
                  ? "UPS Orders History"
                  : "Service UpCharge History",
        ),
      ),
      // backgroundColor: themeData.backgroundColor,
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: MySize.size1 * 80),
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                ProductOrder(),
                UPSOrders(value:0),
                FedexOrders(value:1),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: Spacing.all(16),
              child: PhysicalModel(
                color: themeData.bottomAppBarColor,
                elevation: 12,
                borderRadius: Shape.circular(8),
                shadowColor: themeData.backgroundColor.withAlpha(140),
                shape: BoxShape.rectangle,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: Shape.circular(MySize.size16),
                  ),
                  padding: Spacing.vertical(MySize.size12),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: <Widget>[
                      Container(
                        child: (_currentIndex == 0)
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    "Product Order",
                                    style: AppTheme.getTextStyle(
                                        themeData.textTheme.bodyText2,
                                        color: const Color(0xff10bb6b),
                                        letterSpacing: 0,
                                        fontWeight: 600),
                                  ),
                                  Container(
                                    margin: Spacing.top(6),
                                    decoration: BoxDecoration(
                                        color: const Color(0xff10bb6b),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2.5))),
                                    height: 5,
                                    width: 5,
                                  )
                                ],
                              )
                            : Icon(
                                Icons.history,
                                size: MySize.size20,
                                color: themeData.colorScheme.onBackground,
                              ),
                      ),
                      Container(
                          child: (_currentIndex == 1)
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "UPS Orders",
                                      style: AppTheme.getTextStyle(
                                          themeData.textTheme.bodyText2,
                                          color: const Color(0xff10bb6b),
                                          letterSpacing: 0,
                                          fontWeight: 600),
                                    ),
                                    Container(
                                      margin: Spacing.top(6),
                                      decoration: BoxDecoration(
                                          color: const Color(0xff10bb6b),
                                          borderRadius: new BorderRadius.all(
                                              Radius.circular(2.5))),
                                      height: 5,
                                      width: 5,
                                    )
                                  ],
                                )
                              : Icon(
                                  Icons.history,
                                  size: MySize.size20,
                                  color: themeData.colorScheme.onBackground,
                                )),
                      Container(
                          child: (_currentIndex == 2)
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "Service Upcharge",
                                      style: AppTheme.getTextStyle(
                                          themeData.textTheme.bodyText2,
                                          color: const Color(0xff10bb6b),
                                          letterSpacing: 0,
                                          fontWeight: 600),
                                    ),
                                    Container(
                                      margin: Spacing.top(6),
                                      decoration: BoxDecoration(
                                          color: const Color(0xff10bb6b),
                                          borderRadius: new BorderRadius.all(
                                              Radius.circular(2.5))),
                                      height: 5,
                                      width: 5,
                                    )
                                  ],
                                )
                              : Icon(
                                  Icons.history,
                                  size: MySize.size20,
                                  color: themeData.colorScheme.onBackground,
                                )),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
