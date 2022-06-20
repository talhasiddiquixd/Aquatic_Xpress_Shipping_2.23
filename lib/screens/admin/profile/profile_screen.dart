import 'dart:async';
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:http/http.dart' as http;

import '../../../size_config.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var results;
  bool isConnected = false;
  getData() async {
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/Auth/getuserdata";
    var url = Uri.parse(link);
    var response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      results = json.decode(response.body);
      print(response.body);
      print(response.statusCode);
      return results;
    } else {
      print("Exception");
      throw Error;
    }
  }

  postData() async {
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/admin/ChangeAccountInfo";
    var url = Uri.parse(link);
    var response = await http.put(url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "firstName": nameController.text,
          "lastName": lastNameController.text,
          "email": emailController.text,
          "phone": phoneController.text
        }));

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      futureData = getData();
      setState(() {});
      print(response.statusCode);
      Navigator.pop(context);
    } else {
      print("Exception");
      throw Error;
    }
  }

  changePassword() async {
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/Auth/changepassword";
    var url = Uri.parse(link);
    var response = await http.post(url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "currentPassword": currentPasswordController.text,
          "newPassword": passwordController.text,
        }));

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode);
      Navigator.pop(context);
      Flushbar(
        title: "Success ",
        message: "Password Changes",
        duration: Duration(seconds: 3),
      )..show(context);
    } else {
      print("Exception");
      throw Error;
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  late ThemeData themeData;
  Future? futureData;
  @override
  void initState() {
    super.initState();
    futureData = getData();
    
  }

  

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
        body: Container(

      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: MySize.size20, bottom: MySize.size50),
            child: Container(
              height: MySize.size100 * 2,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 15,
                child: Container(
                  padding: EdgeInsets.only(top: 10, left: 10, bottom: 0),
                  child: Padding(
                    padding: EdgeInsets.only(top: MySize.size30),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Personal Information"),
                          ],
                        ),
                        FutureBuilder(
                            future: futureData,
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: MySize.size30),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/tag.svg",
                                              height: MySize.size60,
                                            ),
                                            Text(results["firstName"]
                                                    .toString() +
                                                " " +
                                                results["lastName"].toString())
                                          ],
                                        ),
                                      ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Padding(
                                      //       padding: EdgeInsets.only(
                                      //           left: MySize.size10,
                                      //           bottom: MySize.size10),
                                      //       child: SvgPicture.asset(
                                      //         "assets/images/phone.svg",
                                      //         height: MySize.size60,
                                      //       ),
                                      //     ),
                                      //     Padding(
                                      //       padding: EdgeInsets.only(
                                      //           right: MySize.size30),
                                      //       child: Text(results["phoneNumber"]
                                      //           .toString()),
                                      //     )
                                      //   ],
                                      // ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: MySize.size10),
                                            child: SvgPicture.asset(
                                              "assets/images/Envelope-closed.svg",
                                              height: MySize.size40,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: MySize.size30),
                                            child: Text(
                                                results["userName"].toString()),
                                          )
                                        ],
                                      ),
                                    ],
                                  );
                                }
                              }

                              return Center(child: Padding(
                                padding: const EdgeInsets.only(top:40),
                                child: CircularProgressIndicator(),
                              ));
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: MySize.size80,
            child: Card(
              elevation: 15,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: SvgPicture.asset(
                      "assets/images/profile.svg",
                      width: 30,
                    ),
                  ),
                  Text("Change Information"),
                  InkWell(
                      child: Container(
                        width: MySize.size80,
                        //height: MySize.,
                        // color: Colors.green,
                        child: SvgPicture.asset(
                          "assets/images/enter.svg",
                          width: 17,
                          height: 20,
                        ),
                      ),
                      onTap: () {
                        _shippingBottomSheet(
                            results["lastName"].toString(),
                            results["firstName"].toString(),
                            results["phoneNumber"].toString(),
                            results["email"].toString(),
                            context);
                      }),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            height: MySize.size80,
            child: Card(
              elevation: 15,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 40,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: SvgPicture.asset("assets/images/lock.svg"),
                      )),
                  Text("Change Password"),
                  InkWell(
                      child: Container(
                        width: MySize.size80,
                        //height: MySize.,
                        // color: Colors.green,
                        child: SvgPicture.asset(
                          "assets/images/enter.svg",
                          width: 17,
                          height: 20,
                        ),
                      ),
                      onTap: () {
                        password(context);
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void password(
    context,
    // bool edit,
    // String name,
    // String detail,
    // String price,
    // String color,
    // String stock,
  ) {
    passwordController.text = "";
    newPasswordController.text = "";
    currentPasswordController.text = "";
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext buildContext) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 70),
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: themeData.backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 24,
                  right: 24,
                  // bottom: 300,
                ),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: ,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      // indent: 10,
                      // endIndent: 10,
                    ),
                    Column(
                      children: [
                        customTextField(
                          currentPasswordController,
                          "",
                          "Current Password",
                        ),
                        customTextField(
                          passwordController,
                          "",
                          "New Password",
                        ),
                        customTextField(
                          newPasswordController,
                          "",
                          "Confirm Password",
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                // width: MediaQuery.of(context).size.width,
                                child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                                SizedBox(width: MySize.size10),
                                ElevatedButton(
                                  onPressed: () {
                                    if (passwordController.text ==
                                        newPasswordController.text) {
                                      changePassword();
                                    } else if (passwordController.text !=
                                        newPasswordController.text) {
                                      Navigator.pop(context);
                                      Flushbar(
                                        title: "Error",
                                        message: "Password does not Match",
                                        duration: Duration(seconds: 3),
                                      )..show(context);
                                    }
                                  },
                                  child: Text("Save "),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _shippingBottomSheet(
    // bool edit,
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
    context,
    // String stock,
  ) {
    // nameController.text = name;
    // lastNameController.text = detail;
    // phoneController.text = price;
    // emailController.text = color;

    nameController.text = firstName;
    lastNameController.text = lastName;
    phoneController.text = phoneNumber;
    emailController.text = email;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext buildContext) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 70),
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: themeData.backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 24,
                  right: 24,
                  // bottom: 300,
                ),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: ,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      // indent: 10,
                      // endIndent: 10,
                    ),
                    Column(
                      children: [
                        Text("Update Information"),
                        customTextField(
                          nameController,
                          "",
                          "Name",
                        ),
                        customTextField(
                          lastNameController,
                          "",
                          "LastName",
                        ),
                        customTextField(
                          phoneController,
                          "",
                          "Phone",
                        ),
                        customTextField(
                          emailController,
                          "",
                          "Email",
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                // width: MediaQuery.of(context).size.width,
                                child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                                SizedBox(width: MySize.size10),
                                ElevatedButton(
                                  onPressed: () {
                                    postData();
                                  },
                                  child: Text("Save "),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget customTextField(
    controller,
    hintText,
    labelText,
  ) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            fillColor: themeData.colorScheme.background,
            hintStyle: TextStyle(
              color: themeData.colorScheme.onBackground,
            ),
            filled: true,
            hintText: hintText,
            labelText: labelText,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            // prefixIcon: Icon(Icons.person),
          ),
          keyboardType: TextInputType.text,
        ),
        SizedBox(
          height: 7,
        )
      ],
    );
  }
}
