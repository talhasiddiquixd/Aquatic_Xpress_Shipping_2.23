import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/screens/auth/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/components/custom_surfix_icon.dart';
import 'package:aquatic_xpress_shipping/components/form_error.dart';
import 'package:aquatic_xpress_shipping/constants.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:uiblock/uiblock.dart';


class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? conformPassword;
  bool remember = false;
  
  final List<String> errors = [];
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
      TextEditingController passwordController = TextEditingController();
        TextEditingController confirmPassController = TextEditingController();
        TextEditingController userNameController = TextEditingController();

  bool isLoading = false;
bool internet = true;
void registerUser() async {
    String ?link = "${getCloudUrl()}/api/Auth/register";
    // "https://devapi.aquaticxpressshipping.com/api/Auth/login";
    // "${getCloudUrl()}​/api​/ShipmentOrder​/getfedexorderlist";
    FocusScope.of(context).unfocus();

    if (firstnameController.text.isNotEmpty && lastnameController.text.isNotEmpty && emailController.text.isNotEmpty && confirmPassController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      // print(loginUrl);
      try {
         UIBlock.block(context);
        var response = await http.post(
          Uri.parse(link),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
  //            "firstName": "Rafi",
  // "lastName": "jamel",
  // "userName": "Saaaaq",
  // "email": "rafiq123@gmail.com",
  // "password": "password"
             "firstName": firstnameController.text,
             "lastName": lastnameController.text,
              "userName": userNameController.text,
              "email": emailController.text,
              "password": passwordController.text
                // "password": passwordController.text
          }),
        );

        if (response.statusCode == 200) {
                    UIBlock.unblock(context);

          var jsonresponse = json.decode(response.body);
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignInScreen()));
            Flushbar(
              title: "Successful",
              message: "Please Check your Email",
              duration: Duration(seconds: 3),
            )..show(context);

        } else {
          isLoading = false;

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
              message: "Please Enter Valid Credentials",
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



  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error!);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),

          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildUserNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConformPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          Container(
            width: MySize.size160*2,
            child: ElevatedButton(onPressed: (){
              
registerUser();
            }, child: Text("Continue")),
          )
            // text: "Continue",
            // press: () {
        //      if (firstnameController.text.isNotEmpty && userNameController.text.isNotEmpty && lastnameController.text.isNotEmpty && emailController.text.isNotEmpty && confirmPassController.text.isNotEmpty &&
        // passwordController.text.isNotEmpty) 
        // {
        // }
            // },
        
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      controller: confirmPassController,
      obscureText: true,
      onSaved: (newValue) => conformPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == conformPassword) {
          removeError(error: kMatchPassError);
        }
        conformPassword = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
                    contentPadding:        EdgeInsets.symmetric(vertical: 0, horizontal: MySize.size20),

        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
            contentPadding:        EdgeInsets.symmetric(vertical: 0, horizontal: MySize.size20),

        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }
  TextFormField buildLastNameFormField() {
    return TextFormField(
      scrollPadding: EdgeInsets.zero,

      controller: lastnameController,
      keyboardType: TextInputType.name,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     addError(error: kEmailNullError);
      //     return "";
      //   } else if (!emailValidatorRegExp.hasMatch(value)) {
      //     addError(error: kInvalidEmailError);
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.symmetric(vertical: 0, horizontal: MySize.size20),
        // contentPadding: EdgeInsets.symmetric(horizontal: MySize.size20),
        labelText: "LastName",
        hintText: "Enter your Last Name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        // floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/profile.svg"),
      ),
    );
  }
TextFormField buildFirstNameFormField() {
    return TextFormField(
      scrollPadding: EdgeInsets.zero,

      controller: firstnameController,
      keyboardType: TextInputType.name,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     addError(error: kEmailNullError);
      //     return "";
      //   } else if (!emailValidatorRegExp.hasMatch(value)) {
      //     addError(error: kInvalidEmailError);
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.symmetric(vertical: 0, horizontal: MySize.size20),
        // contentPadding: EdgeInsets.symmetric(horizontal: MySize.size20),
        labelText: "FirstName",
        hintText: "Enter your First Name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        // floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/profile.svg"),
      ),
    );
  }
  TextFormField buildUserNameFormField() {
    return TextFormField(
      scrollPadding: EdgeInsets.zero,

      controller: userNameController,
      keyboardType: TextInputType.name,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     addError(error: kEmailNullError);
      //     return "";
      //   } else if (!emailValidatorRegExp.hasMatch(value)) {
      //     addError(error: kInvalidEmailError);
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.symmetric(vertical: 0, horizontal: MySize.size20),
        // contentPadding: EdgeInsets.symmetric(horizontal: MySize.size20),
        labelText: "UserName",
        hintText: "Enter your User Name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        // floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/profile.svg"),
      ),
    );
  }
TextFormField buildEmailFormField() {
    return TextFormField(
      scrollPadding: EdgeInsets.zero,

      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     addError(error: kEmailNullError);
      //     return "";
      //   } else if (!emailValidatorRegExp.hasMatch(value)) {
      //     addError(error: kInvalidEmailError);
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.symmetric(vertical: 0, horizontal: MySize.size20),
        // contentPadding: EdgeInsets.symmetric(horizontal: MySize.size20),
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        // floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
