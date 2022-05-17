import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/components/custom_widgets/carousel.dart';
import 'package:aquatic_xpress_shipping/screens/auth/pre_sign_in/components/quick_quote.dart';
import 'package:aquatic_xpress_shipping/screens/auth/sign_in/sign_in_screen.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    MySize().init(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Carousel(),
          SizedBox(height: MySize.size10),
          // Container(
          //   padding: EdgeInsets.all(MySize.size12),
          //   child: Card(
          //     elevation: 10,
          //     child: ListTile(
          //       // tileColor: Colors.grey.shade50,
          //       leading: Icon(
          //         Icons.location_pin,
          //       ),
          //       title: Text(
          //         "Quick Quote",
          //         style: AppTheme.getTextStyle(
          //           themeData.textTheme.subtitle2,
          //           fontWeight: 600,
          //           // color: themeData!.colorScheme.primary,
          //         ),
          //       ),
          //       trailing: Icon(Icons.keyboard_arrow_right_outlined),
          //       onTap: () {
          //         Navigator.of(context).push(
          //           MaterialPageRoute(
          //             builder: (context) => QuickQoute(),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),

          QuickQoute(),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: MySize.size10,
              vertical: MySize.size4,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MySize.size14),
              ),
              elevation: 10,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: MySize.size20,
                  vertical: MySize.size0,
                ),
                // tileColor: Colors.grey.shade50,
                leading: Icon(Icons.login),
                title: Text(
                  "Login",
                  style: AppTheme.getTextStyle(
                    themeData.textTheme.bodyText1,
                    fontSize: MySize.size20,
                    fontWeight: 600,
                    // color: themeData!.colorScheme.primary,
                  ),
                ),
                trailing: Icon(Icons.keyboard_arrow_right_outlined),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignInScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
