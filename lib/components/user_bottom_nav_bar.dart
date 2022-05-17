import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:aquatic_xpress_shipping/components/CustomBottomNavigation.dart';
import 'package:aquatic_xpress_shipping/screens/user/Shopping/Shopping.dart';
import 'package:aquatic_xpress_shipping/screens/user/address/address.dart';
import 'package:aquatic_xpress_shipping/screens/user/home/home_screen.dart';
import 'package:aquatic_xpress_shipping/screens/user/profile/profile_screen.dart';
import 'package:aquatic_xpress_shipping/screens/user/shipping/shipping.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  int _currentIndex = 0;
  ThemeData? themeData;
  PageController? _pageController;

  var navigationBarTheme;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    // navigationBarTheme = AppTheme.getNavigationThemeFromMode(2);
    navigationBarTheme = themeData!.bottomNavigationBarTheme;

    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            HomeScreen(),
            Shipping(),
            Address(),
            Shopping(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        animationDuration: Duration(milliseconds: 350),
        // selectedItemOverlayColor: navigationBarTheme!.selectedOverlayColor,
        backgroundColor: navigationBarTheme!.backgroundColor,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController!.jumpToPage(index);
        },
        items: <CustomBottomNavigationBarItem>[
          CustomBottomNavigationBarItem(
              title: "Home",
              icon: Icon(MdiIcons.storeOutline, size: 22),
              activeIcon: Icon(MdiIcons.store, size: 22),
              activeColor: navigationBarTheme!.selectedItemColor,
              inactiveColor: navigationBarTheme!.unselectedItemColor),
          CustomBottomNavigationBarItem(
              title: "Shipping",
              icon: Icon(MdiIcons.truckOutline, size: 22),
              activeIcon: Icon(MdiIcons.truck, size: 22),
              activeColor: navigationBarTheme!.selectedItemColor,
              inactiveColor: navigationBarTheme!.unselectedItemColor),
          CustomBottomNavigationBarItem(
              title: "Address",
              icon: Icon(MdiIcons.viewListOutline, size: 22),
              activeIcon: Icon(MdiIcons.viewList, size: 22),
              activeColor: navigationBarTheme!.selectedItemColor,
              inactiveColor: navigationBarTheme!.unselectedItemColor),
          CustomBottomNavigationBarItem(
              title: "Products",
              icon: Icon(Icons.shop_2_outlined, size: 22),
              activeIcon: Icon(Icons.shop_2, size: 22),
              activeColor: navigationBarTheme!.selectedItemColor,
              inactiveColor: navigationBarTheme!.unselectedItemColor),
          CustomBottomNavigationBarItem(
              title: "Profile",
              icon: Icon(MdiIcons.accountOutline, size: 22),
              activeIcon: Icon(MdiIcons.account, size: 22),
              activeColor: navigationBarTheme!.selectedItemColor,
              inactiveColor: navigationBarTheme!.unselectedItemColor),
        ],
      ),
    );
  }

  onTapped(value) {
    setState(() {
      _currentIndex = value;
    });
  }
}
