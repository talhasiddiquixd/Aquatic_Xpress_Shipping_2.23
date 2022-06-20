import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:aquatic_xpress_shipping/components/custom_widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:aquatic_xpress_shipping/AppTheme.dart';

import 'package:http/http.dart' as http;
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:uiblock/uiblock.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isResidetial = true;

  late ThemeData themeData;

  TextEditingController currPasswordController = new TextEditingController(),
      newPasswordController = new TextEditingController(),
      confPasswordController = new TextEditingController(),
      addressController = new TextEditingController(),
      apartController = new TextEditingController(),
      cityController = new TextEditingController(),
      emailController = new TextEditingController(),
      phoneController = new TextEditingController(),
      zipController = new TextEditingController();

  int? statusCode;

  changePassword(context) async {
    UIBlock.blockWithData(
      context,
      loadingTextWidget: Text("Changing Password"),
    );
    String ?link =
        "${getCloudUrl()}/api/Auth/changepassword";
    var url = Uri.parse(link);
    String? token = await getToken();

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(
        {
          "currentPassword": currPasswordController.text,
          "newPassword": newPasswordController.text,
        },
      ),
    );
    statusCode = response.statusCode;
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      UIBlock.unblock(context);
      Flushbar(
        title: "Updated Password",
        message: "Password Updated Successfully",
        duration: Duration(seconds: 3),
      )..show(context);
    } else if (response.statusCode == 204) {
      UIBlock.unblock(context);
      Flushbar(
        title: "Failed",
        message: "Incorrect Password",
        duration: Duration(seconds: 3),
      )..show(context);
      // return;
      // print("Exception");
      // throw Error;
    } else {
      UIBlock.unblock(context);
      Flushbar(
        title: "Failed",
        message: "Error Occured",
        duration: Duration(seconds: 3),
      )..show(context);
      // return;
      // print("Exception");
      // throw Error;
    }
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(MdiIcons.chevronLeft),
        ),
        title: Text(
          "Change Password",
          style: AppTheme.getTextStyle(
            themeData.textTheme.headline6,
            fontWeight: 600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MySize.size16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            customTextField(
              context,
              currPasswordController,
              "",
              "Current Password",
              TextInputType.text,

            ),
            Space.height(MySize.size10),
            customTextField(
              context,
              newPasswordController,
              "",
              "New Password",
              TextInputType.text,
            ),
            Space.height(MySize.size10),
            customTextField(
              context,
              confPasswordController,
              "",
              "Confirm Password",
              TextInputType.text,
            ),
            Space.height(MySize.size10),
            Container(
              width: MySize.safeWidth,
              height: MySize.size50,
              child: ElevatedButton(
                onPressed: () {
                  if (newPasswordController.text ==
                      confPasswordController.text) {
                    changePassword(context);
                  } else {
                    Flushbar(
                      title: "Invalid",
                      message: "Both Passwords are not save",
                      duration: Duration(seconds: 3),
                    )..show(context);
                  }
                },
                child: Text(
                  "SAVE",
                  style: AppTheme.getTextStyle(
                    themeData.textTheme.bodyText2,
                    fontSize: MySize.size18,
                    fontWeight: 600,
                    // letterSpacing: 0.2,
                    color: themeData.colorScheme.onPrimary,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
