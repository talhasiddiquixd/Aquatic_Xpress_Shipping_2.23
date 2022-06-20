import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/screens/auth/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/components/custom_surfix_icon.dart';
import 'package:aquatic_xpress_shipping/components/form_error.dart';
import 'package:aquatic_xpress_shipping/components/no_account_text.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:http/http.dart' as http;

import 'package:aquatic_xpress_shipping/constants.dart';
import 'package:uiblock/uiblock.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: MySize.screenHeight * 0.04),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Please enter your email and we will send \nyou a link to return to your account",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MySize.screenHeight * 0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? email;
  
  bool isLoading = false;
bool internet = true;
TextEditingController emailController=new TextEditingController();
 void resetPassword() async {
    String ?link = "${getCloudUrl()}/api/Auth/forgotpassword";
    // "https://devapi.aquaticxpressshipping.com/api/Auth/login";
    // "${getCloudUrl()}​/api​/ShipmentOrder​/getfedexorderlist";
    FocusScope.of(context).unfocus();

    if (emailController.text.isNotEmpty) {
      // print(loginUrl);
      try {
         UIBlock.block(context);
        var response = await http.post(
          Uri.parse(link),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
 
             "email": emailController.text,
          }),
        );

        if (response.statusCode == 200) {
                    UIBlock.unblock(context);

          // var jsonresponse = json.decode(response.body);
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignInScreen()));
            Flushbar(
              title: "Successful",
              message: "Please Check your Email",
              duration: Duration(seconds: 3),
            )..show(context);

        } else {

          UIBlock.unblock(context);
          if (response.statusCode == 502) {
            Flushbar(
              title: "Invalid URL",
              message: "Bad Gateaway",
              duration: Duration(seconds: 3),
            )..show(context);
          } else {
            //var responseJson = json.decode(response.body);
            Flushbar(
              title: "Incorrect Credentials",
              message: "Please Enter Valid Email",
              duration: Duration(seconds: 3),
            )..show(context);
          }
        }
      } on TimeoutException {
        isLoading = false;

        // UIBlock.unblock(context);

        Flushbar(
          title: "Request Timeout",
          message: "Server does not respond, Please Try Again!",
          duration: Duration(seconds: 3),
        )..show(context);
      } on SocketException catch (e) {
        // UIBlock.unblock(context);
        isLoading = false;

        internet = false;
        print('Socket Error: $e');
        setState(() {});
      } catch (e) {
        isLoading = false;

        // UIBlock.unblock(context);

        Flushbar(
          title: "Incorrect URL",
          message: "Error" + e.toString(),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    } else {
      Flushbar(
        title: "Empty Fields",
        message: "Email and Password is required",
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:  EdgeInsets.only(top:MySize.size120),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (newValue) => email = newValue,
                  onChanged: (value) {
                    if (value.isNotEmpty && errors.contains(kEmailNullError)) {
                      setState(() {
                        errors.remove(kEmailNullError);
                      });
                    } else if (emailValidatorRegExp.hasMatch(value) &&
                        errors.contains(kInvalidEmailError)) {
                      setState(() {
                        errors.remove(kInvalidEmailError);
                      });
                    }
                    return null;
                  },
                  validator: (value) {
                    if (value!.isEmpty && !errors.contains(kEmailNullError)) {
                      setState(() {
                        errors.add(kEmailNullError);
                      });
                    } else if (!emailValidatorRegExp.hasMatch(value) &&
                        !errors.contains(kInvalidEmailError)) {
                      setState(() {
                        errors.add(kInvalidEmailError);
                      });
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                contentPadding: 
                  EdgeInsets.symmetric(vertical: 0, horizontal: MySize.size20),
                    labelText: "Email",
                    hintText: "Enter your email",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                FormError(errors: errors),
                // SizedBox(height: MySize.screenHeight * 0.1),
               Container(
                 width: MySize.size160*2,
                 child: ElevatedButton(onPressed: (){resetPassword();}, child: Text("Continue"))),
                SizedBox(height: MySize.screenHeight * 0.01),
                NoAccountText(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
