import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aquatic_xpress_shipping/components/SplashScreen.dart';
import 'package:aquatic_xpress_shipping/components/user_bottom_nav_bar.dart';
import 'package:aquatic_xpress_shipping/screens/admin/admin.dart';
import 'package:aquatic_xpress_shipping/screens/auth/pre_sign_in/pre_sign_in_screen.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';

class SplashScreenView extends StatelessWidget {
  Future<dynamic> loadFromFuture(context) async {
    // <fetch data from server. ex. login>
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 3), () {
      if (prefs.getString("role").toString() == "Admin") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Admin()));
      } else if (prefs.getString("role").toString() == "User") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => User()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => PreSignInScreen()));
      }
    });

    // var response = await Future.delayed(Duration(seconds: 3), () {
    //   return Future.value("/dashboard");
    // });
    // return response;
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    return new SplashScreen(
      navigateAfterFuture: loadFromFuture(context),
      title: new Text(
        'Aquatic Xpress Shipping',
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: MySize.size26,
          color: Colors.green.shade600,
        ),
      ),
      image: new Image.asset('assets/icons/logo.png'),
      // backgroundColor: ThemeData().colorScheme.background,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: MySize.size100,
      // loaderColor: Colors.green,
    );
  }
}
