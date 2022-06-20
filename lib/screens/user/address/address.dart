import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/components/custom_widgets/skeleton_container.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/screens/user/address/components/add_address.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';

class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> with TickerProviderStateMixin {
  static const List<IconData> icons = const [
    MdiIcons.plus,
    MdiIcons.plus,
  ];
  bool internet = true;
  static const List<String> iconsText = const [
    "Add Address",
    "Add My Address",
  ];
  AnimationController? _controller;
bool ?isSwitched;
  late Future futureAddres;
  late ThemeData themeData;
   TextEditingController addressController = TextEditingController(),
      cityController = TextEditingController(),
      emailController = TextEditingController(),
      lastNameController = TextEditingController(),
      organizationController = TextEditingController(),
      phoneNumberController = TextEditingController(),
      placeController = TextEditingController(),
      userIdController=TextEditingController(),
      zipCodeController=TextEditingController(),
      stateController = TextEditingController();
      editList( phoneNumber,
    email,
    org,
    city,
    address,
    state,
    zipCode,
    lastname,
    residential,
    place,
    id )async {
        String? token = await getToken();
        String? name= await getUserName();

    String ?link = "${getCloudUrl()}/api/AddressBook/Edit";
    // "${getCloudUrl()}​/api​/ShipmentOrder​/getfedexorderlist";

    var url = Uri.parse(link);
    var response;
     isSwitched==true? response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(
        {
          
"id": id,
  "organization":organizationController.text,
  "email": emailController.text,
  "firstName": "",
  "lastName": lastNameController.text,
  "address": addressController.text,
  "place": placeController.text,
  "city": cityController.text,
  "state": stateController.text,
  "zipCode": zipCodeController.text,
  "phoneNumber": phoneNumberController.text,
  "isItResidential": true,
  "visible": true,
  "isActive": true,
  "userId": name.toString(),

       
        },
      ),
    ):response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(
        {
          
"id": id,
  "organization":organizationController.text,
  "email": emailController.text,
  "firstName": "",
  "lastName": lastNameController.text,
  "address": addressController.text,
  "place": placeController.text,
  "city": cityController.text,
  "state": stateController.text,
  "zipCode": zipCodeController.text,
  "phoneNumber": phoneNumberController.text,
  "isItResidential": false,
  "visible": true,
  "isActive": true,
  "userId": name.toString(),

       
        },
      ),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
       futureAddres=getAddresses();
     setState(() {
       
     });
      // var data = json.decode(response.body);
      // return data;
    } else {
    
      print("Exception");
      throw Error;
    }
      }

      deleteAddress(id) async{
        try {
      String? token = await getToken();

      String ?link = "${getCloudUrl()}/api/AddressBook/Delete/$id";
      var url = Uri.parse(link);
      var response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        futureAddres=getAddresses();
        setState(() {
          
        });
      } else {
        print("Exception");
        throw Error;
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
    } on SocketException catch (e) {
      internet = false;
      print('Socket Error: $e');
      setState(() {});
    } on Error catch (e) {
      print('General Error: $e');
    }
      }
  getAddresses() async {
    try {
      String? token = await getToken();

      String ?link = "${getCloudUrl()}/api/AddressBook";
      var url = Uri.parse(link);
      var response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      } else {
        print("Exception");
        throw Error;
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
    } on SocketException catch (e) {
      internet = false;
      print('Socket Error: $e');
      setState(() {});
    } on Error catch (e) {
      print('General Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    futureAddres = getAddresses();
  }

  @override
  Widget build(BuildContext context) {
    themeData = themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Address"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          internet
              ? FutureBuilder(
                  future: futureAddres,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return Container(
                          // height: MediaQuery.of(context).size.height * 0.75,
                          child: Expanded(
                            child: ListView.builder(
                              itemCount: (snapshot.data as List).length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(
                                        MySize.size10,
                                        MySize.size2,
                                        MySize.size10,
                                        MySize.size2,
                                      ),
                                      child: Card(
                                        elevation: 15,
                                        clipBehavior: Clip.antiAlias,
                                        // shape: RoundedRectangleBorder(
                                        //   borderRadius: new BorderRadius.circular(
                                        //     MySize.size20,
                                        //   ),
                                        // ),
                                        child: ListTileTheme(
                                          // dense: true,

                                          contentPadding: EdgeInsets.fromLTRB(
                                              MySize.size10, 0, 0, 0),
                                          child: ExpansionTile(
                                            // leading: CircleAvatar(),
                                            trailing: SizedBox.shrink(),
                                            title: Text(
                                              (snapshot.data as List)[index]
                                                      ["lastName"]
                                                  .toString(),
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.bodyText1,
                                                // fontSize: Mysize,
                                                fontWeight: 600,
                                              ),
                                            ),
                                            subtitle: Text(
                                              (snapshot.data as List)[index]
                                                          ["address"]
                                                      .toString() +
                                                  ", " +
                                                  (snapshot.data as List)[index]
                                                          ["city"]
                                                      .toString() +
                                                  ", " +
                                                  (snapshot.data as List)[index]
                                                          ["state"]
                                                      .toString() +
                                                  ", " +
                                                  (snapshot.data as List)[index]
                                                          ["zipCode"]
                                                      .toString(),
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.bodyText1,
                                                // fontSize: Mysize,
                                                fontWeight: 500,
                                              ),
                                            ),
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 15.0,
                                                  bottom: 5,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "City: ",
                                                          style: AppTheme
                                                              .getTextStyle(
                                                            themeData.textTheme
                                                                .bodyText1,
                                                            // fontSize: Mysize,
                                                            fontWeight: 500,
                                                          ),
                                                        ),
                                                        Text(
                                                          (snapshot.data
                                                                      as List)[
                                                                  index]["city"]
                                                              .toString(),
                                                          style: AppTheme
                                                              .getTextStyle(
                                                            themeData.textTheme
                                                                .bodyText1,
                                                            // fontSize: Mysize,
                                                            fontWeight: 500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Organization: ",
                                                          style: AppTheme
                                                              .getTextStyle(
                                                            themeData.textTheme
                                                                .bodyText1,
                                                            // fontSize: Mysize,
                                                            fontWeight: 500,
                                                          ),
                                                        ),
                                                        Text(
                                                          (snapshot.data as List)[
                                                                      index][
                                                                  "organization"]
                                                              .toString(),
                                                          style: AppTheme
                                                              .getTextStyle(
                                                            themeData.textTheme
                                                                .bodyText1,
                                                            // fontSize: Mysize,
                                                            fontWeight: 500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Email: ",
                                                          style: AppTheme
                                                              .getTextStyle(
                                                            themeData.textTheme
                                                                .bodyText1,
                                                            // fontSize: Mysize,
                                                            fontWeight: 500,
                                                          ),
                                                        ),
                                                        Text(
                                                          (snapshot.data
                                                                      as List)[
                                                                  index]["email"]
                                                              .toString(),
                                                          style: AppTheme
                                                              .getTextStyle(
                                                            themeData.textTheme
                                                                .bodyText1,
                                                            // fontSize: Mysize,
                                                            fontWeight: 500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Phone No: ",
                                                          style: AppTheme
                                                              .getTextStyle(
                                                            themeData.textTheme
                                                                .bodyText1,
                                                            // fontSize: Mysize,
                                                            fontWeight: 500,
                                                          ),
                                                        ),
                                                        Text(
                                                          (snapshot.data as List)[
                                                                      index][
                                                                  "phoneNumber"]
                                                              .toString(),
                                                          style: AppTheme
                                                              .getTextStyle(
                                                            themeData.textTheme
                                                                .bodyText1,
                                                            // fontSize: Mysize,
                                                            fontWeight: 500,
                                                          ),
                                                        ),
                                                      ],
                                                 
                                                    ),
                                                    
                                                 Row(
                                                   
                                                   children: [
                                                     
                                                     ElevatedButton(
                                                         style: ButtonStyle(
                                                foregroundColor:
                                                        MaterialStateProperty.all<
                                                            Color>(
                                                      Colors.black,
                                                ),
                                                backgroundColor:
                                                        MaterialStateProperty.all<
                                                            Color>(
                                                      Colors.amber.shade400,
                                                ),
                                              ),
                                                       onPressed: (){
                                                       _editBottomSheet(context,
                                                        (snapshot.data as List)[index]["phoneNumber"].toString(),
                                                        (snapshot.data as List)[index]["email"].toString(),
                                                        (snapshot.data as List)[index]["organization"].toString(),
                                                        (snapshot.data as List)[index]["city"].toString(),
                                                        (snapshot.data as List)[index]["address"].toString(),
                                                        (snapshot.data as List)[index]["state"].toString(),
                                                        (snapshot.data as List)[index]["zipCode"].toString(),
                                                        (snapshot.data as List)[index]["lastName"].toString(),
                                                        (snapshot.data as List)[index]["isItResidential"],
                                                        (snapshot.data as List)[index]["place"].toString(),
                                                        (snapshot.data as List)[index]["id"],
                                                                

                                                       );

                                                     }, child: Text("Edit")),
                                                  SizedBox(width: MySize.size10,),
                                                  ElevatedButton(
                                                         style: ButtonStyle(
                                                foregroundColor:
                                                        MaterialStateProperty.all<
                                                            Color>(
                                                      Colors.black,
                                                ),
                                                backgroundColor:
                                                        MaterialStateProperty.all<
                                                            Color>(
                                                      Colors.red,
                                                ),
                                              ),
                                                       onPressed: (){
                    deleteAddress((snapshot.data as List)[index]["id"]);

                                                     }, child: Text("Delete")),
                                                   ],
                                                 )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: Image.asset(
                              "assets/images/no_data_found.jpg",
                            ),
                          ),
                        );
                      }
                    } else {
                      return listViewWithoutLeadingPictureWithExpandedSkeleton(
                          context);
                    }
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: MySize.size50),
                      Text(
                        "No Internet Connection",
                        style: AppTheme.getTextStyle(
                          themeData.textTheme.headline5,
                          fontWeight: 700,
                          color: themeData.colorScheme.primary,
                        ),
                      ),
                      Container(
                        // height: MediaQuery.of(context).size.height * 0.35,
                        child: Image.asset(
                          "assets/images/no_internet_connection.jpg",
                        ),
                      ),
                      SizedBox(height: MySize.size50),
                      ElevatedButton.icon(
                        onPressed: () {
                          internet = true;
                          setState(() {});
                          futureAddres = getAddresses();
                        },
                        icon: Icon(Icons.history),
                        label: Text("Reload"),
                      )
                    ],
                  ),
                )
        ],
      ),
      floatingActionButton: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: new List.generate(icons.length, (int index) {
          Widget child = new Container(
            height: 70.0,
            width: MediaQuery.of(context).size.width,
            child: new ScaleTransition(
              scale: new CurvedAnimation(
                parent: _controller!,
                curve: new Interval(0.0, 1.0 - index / icons.length / 2.0,
                    curve: Curves.easeOutQuint),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        left: MySize.size8,
                        right: MySize.size8,
                        top: MySize.size4,
                        bottom: MySize.size4),
                    margin: EdgeInsets.only(right: 4),
                    color: themeData.primaryColor,
                    child: Text(iconsText[index],
                        style: AppTheme.getTextStyle(
                            themeData.textTheme.bodyText2,
                            color: themeData.colorScheme.onBackground,
                            fontWeight: 500,
                            letterSpacing: 0.2)),
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    backgroundColor: themeData.primaryColor,
                    mini: true,
                    child: new Icon(icons[index],
                        color: themeData.colorScheme.onSecondary),
                    onPressed: () {
                      index == 0
                          ? Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                              return AddAddress(
                                myAddress: false,
                              );
                            }))
                          : Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                              return AddAddress(
                                myAddress: true,
                              );
                            }));
                      // showSimpleSnackbar();
                    },
                  ),
                ],
              ),
            ),
          );
          return child;
        }).toList()
          ..add(
            new FloatingActionButton(
              heroTag: null,
              backgroundColor: themeData.primaryColor,
              child: new AnimatedBuilder(
                animation: _controller!,
                builder: (BuildContext? context, Widget? child) {
                  return new Transform(
                    transform:
                        new Matrix4.rotationZ(_controller!.value * 0.5 * pi),
                    alignment: FractionalOffset.center,
                    child: new Icon(
                      _controller!.isDismissed ? Icons.add : Icons.close,
                      color: themeData.colorScheme.onPrimary,
                    ),
                  );
                },
              ),
              onPressed: () {
                if (_controller!.isDismissed) {
                  setState(() {});
                  _controller!.forward();
                } else {
                  setState(() {});
                  _controller!.reverse();
                }
              },
            ),
          ),
      ),

      // FloatingActionButton(
      //   backgroundColor: Colors.green,
      //   child: Icon(MdiIcons.plus),
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) {
      //       return AddAddress();
      //     }));
      //   },
      // ),
    );
  }

 void _editBottomSheet(
    context,
    phoneNumber,
    email,
    org,
    city,
    address,
    state,
    zipCode,
    lastname,
    residential, 
    place,
    id
   
  ) {
    phoneNumberController.text=phoneNumber;
    emailController.text=email;
    organizationController.text=org;
    cityController.text=city;
    addressController.text=address;
    stateController.text=state;
    zipCodeController.text=zipCode;
    placeController.text=place;
    lastNameController.text=lastname;
    if(residential)
    {
    isSwitched=true;
    }
    else{
      isSwitched=false;
    } 
    showModalBottomSheet(

        context: context,
        isScrollControlled: true,
        builder: (BuildContext buildContext) {
          return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
          
       return   Scaffold(

         body: Container(
           margin: EdgeInsets.only(top: 20),
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
             child: 
             SingleChildScrollView(
               child: Column(
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(
                         "Edit Address",
                         style: TextStyle(
                             fontWeight: FontWeight.bold, fontSize: 20),
                       ),
                       IconButton(
                         onPressed: () {
                        
             
                           Navigator.pop(context);
                         },
                         icon: Icon(
                           Icons.close,
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
                           addressController, "", "Address", TextInputType.text),
                       customTextField(cityController, "Inches", "city",
                           TextInputType.text),
                       customTextField(emailController, "Inches", "email",
                           TextInputType.emailAddress),
                       customTextField(lastNameController, "Inches", "lastName",
                           TextInputType.text),
                       customTextField(organizationController, "Inches", "Organization",
                           TextInputType.text),
                       customTextField(phoneNumberController, "Inches", "PhoneNumber",
                           TextInputType.number),
                            customTextField(placeController, "Inches", "Place",
                           TextInputType.text),
                            customTextField(stateController, "Inches", "State",
                           TextInputType.text),
             
                            customTextField(zipCodeController, "Inches", "Zip Code",
                           TextInputType.number),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children: [
                               Text("Is it Residential?"),
                               Switch(
                    value: isSwitched!,
                    onChanged: (value) {
                      setState(() {
               isSwitched = value;
               print(isSwitched);
                      });
                    },
                    activeTrackColor: Colors.green,
                    activeColor: Colors.green,
                       ),
                             ],
                           ),
                     
             
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Container(
                               // width: MediaQuery.of(context).size.width,
                               child: ElevatedButton(
                             onPressed: () {
                                editList(
                           phoneNumber,email,org,city,address,state,zipCode,lastname,residential, place,id 
                         );
                               Navigator.pop(context);
                             },
                             child: Text("Save Changes"),
                           )),
                         ],
                       ),
                     ],
                   )
                 ],
               ),
             ),
           ),
         ),
       );
        });
  });
  }

 Widget customTextField(
    controller,
    hintText,
    labelText,
    keyboard,
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
          keyboardType: keyboard,
        ),
        SizedBox(
          height: 7,
        )
      ],
    );
  }
}
