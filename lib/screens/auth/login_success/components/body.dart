import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/components/default_button.dart';
import 'package:aquatic_xpress_shipping/screens/user/home/home_screen.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MySize.screenHeight * 0.04),
        Image.asset(
          "assets/images/success.png",
          height: MySize.screenHeight * 0.4, //40%
        ),
        SizedBox(height: MySize.screenHeight * 0.08),
        Text(
          "Login Success",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(30),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Spacer(),
        SizedBox(
          width: MySize.screenWidth * 0.6,
          child: DefaultButton(
            text: "Back to home",
            press: () {
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
          ),
        ),
        Spacer(),
      ],
    );
  }
}