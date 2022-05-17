import 'dart:ui';
import 'package:aquatic_xpress_shipping/screens/admin/Announcements/announcements.dart';
import 'package:aquatic_xpress_shipping/screens/admin/Announcements/get_announcement.dart';
import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';

class Heybaby extends StatefulWidget {
  @override
  _HeybabyState createState() => _HeybabyState();
}

class _HeybabyState extends State<Heybaby> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  late TabController _tabController;

  _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 0);
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
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: <Widget>[Getannouncement(), Announcements()],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: Spacing.all(16),
              child: PhysicalModel(
                color: themeData.colorScheme.background,
                elevation: 12,
                borderRadius: Shape.circular(8),
                shadowColor: themeData.colorScheme.background.withAlpha(140),
                shape: BoxShape.rectangle,
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.colorScheme.background,
                    borderRadius: Shape.circular(16),
                  ),
                  padding: Spacing.vertical(12),
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
                                    "Get Announcements",
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
                                Icons.running_with_errors,
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
                                      "Add Announcement",
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
