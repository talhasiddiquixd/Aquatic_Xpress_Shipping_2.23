import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/screens/admin/users/Upfed.dart';

class Label extends StatefulWidget {
  const Label({Key? key, this.id}) : super(key: key);
  final id;
  @override
  _LabelState createState() => _LabelState();
}

class _LabelState extends State<Label> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  late TabController _tabController;

  _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  void initState() {
    _tabController = new TabController(length: 1, vsync: this, initialIndex: 0);
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
            children: <Widget>[
              Upfed(id: widget.id, indexValue: 0),
              // Upfed(id: widget.id, indexValue: 1),
              // ActiveOrders(),
              //HistoryOrders(),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: Spacing.all(16),
              child: PhysicalModel(
                color: themeData.backgroundColor,
                elevation: 12,
                borderRadius: Shape.circular(8),
                shadowColor: themeData.backgroundColor.withAlpha(140),
                shape: BoxShape.rectangle,
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.backgroundColor,
                    borderRadius: Shape.circular(16),
                  ),
                  padding: Spacing.vertical(12),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: themeData.backgroundColor,
                    tabs: <Widget>[
                      Container(
                        child: (_currentIndex == 0)
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    "UPS",
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
                      // Container(
                      //     child: (_currentIndex == 1)
                      //         ? Column(
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: <Widget>[
                      //               Text(
                      //                 "Fedex",
                      //                 style: AppTheme.getTextStyle(
                      //                     themeData.textTheme.bodyText2,
                      //                     color: const Color(0xff10bb6b),
                      //                     letterSpacing: 0,
                      //                     fontWeight: 600),
                      //               ),
                      //               Container(
                      //                 margin: Spacing.top(6),
                      //                 decoration: BoxDecoration(
                      //                     color: const Color(0xff10bb6b),
                      //                     borderRadius: new BorderRadius.all(
                      //                         Radius.circular(2.5))),
                      //                 height: 5,
                      //                 width: 5,
                      //               )
                      //             ],
                      //           )
                      //         : Icon(
                      //             Icons.history,
                      //             size: MySize.size20,
                      //             color: themeData.colorScheme.onBackground,
                      //           )),
                   
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
