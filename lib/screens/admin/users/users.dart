import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:aquatic_xpress_shipping/screens/user/shipping/shipping.dart';
// import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';

import 'package:http/http.dart' as http;
import 'package:aquatic_xpress_shipping/screens/admin/users/Label.dart';
import 'package:aquatic_xpress_shipping/screens/admin/users/UserCredit.dart';

import '../../../size_config.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  Future? futureUserList;
  bool isConnected = false;
  @override
  void initState() {
    super.initState();
    futureUserList = getUsers();
    
  }

  List searchJson=[];
List jsonData=[];
String ?_chosenValue="ASC";
String ?chosenFieldValue;
 TextEditingController txtQuery = new TextEditingController();
  late ThemeData themeData;
  
  void search(String query) {
  if (query.isEmpty) {
    // jsonData.clear();
    jsonData = searchJson;
    setState(() {});
    return;
  }

  query = query.toLowerCase();
  print(query);
  List result = [];
  jsonData.forEach((p) {

    var name =p["userName"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }

     name =p["firstName"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
     name =p["lastName"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
    name=p["email"].toString().toLowerCase();
    if( name.contains(query))
    {
      result.add(p);
    }

    name=p["margin"].toString().toLowerCase();
    if( name.contains(query))
    {
      result.add(p);
    }
    name=p["fedexMargin"].toString().toLowerCase();
    if( name.contains(query))
    {
      result.add(p);
    }
  });
 var data = result;
 List orders=[];
orders.addAll(data);
var uniqueData = orders.map((o) => o).toSet();
 result.clear();
result.addAll(uniqueData);
// var uniqueCount = uniqueIds.length;

  jsonData = result;
  setState(() {});
}


  int? _value;
  int? _emailValue;
  var data;

  postCreditData(id, credit) async {
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/credit/addCreditByAdmin";
    var url = Uri.parse(link);
    var response = await http.post(url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"userId": id.toString(), "amount": credit}));

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Flushbar(
        title: "Success",
        message: "Data Added",
        duration: Duration(seconds: 3),
      )..show(context);
      print(response.statusCode);
    } else {
      print("Exception");
      throw Error;
    }
  }

  deleteData(id) async {
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/auth/deleteuser";
    var url = Uri.parse(link);
    var response = await http.post(url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "userId": id.toString(),
        }));

    print(response.statusCode);
    print(response.body);
    Navigator.pop(context);
    if (response.statusCode == 200) {
      Flushbar(
        title: "Success",
        message: "Data Deleted",
        duration: Duration(seconds: 3),
      )..show(context);
      print(response.statusCode);
    } else {
      print("Exception");
      throw Error;
    }
  }

  getUsers() async {
    // quickQuote = 0;
    // curl();
    String? token = await getToken();

    String ?link = "${getCloudUrl()}/api/auth/getuserlist";
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
      data = json.decode(response.body);
       jsonData.clear();
    try {
            for(int i=0; i<data!.length; i++)
            { 
            jsonData.add(data[i]);
            searchJson.add(data[i]);
            print(jsonData);
            } 
              
            } catch (e) {
              print(e);
            }
      return data;
    } else {
      print("Exception");
      throw Error;
    }
  }

  postData(ups, fedex, id) async {
    int? upsDiscount = int.parse(ups);
    int? fedexDiscount = int.parse(fedex);
    String? token = await getToken();
    String ?link =
        "${getCloudUrl()}/api/auth/changeuserstatus";

    var url = Uri.parse(link);
    var response = await http.post(url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "emailConfirm": true,
          "fedexMargin": fedexDiscount,
          "margin": upsDiscount,
          "status": true,
          "userId": id.toString(),
        }));

    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Flushbar(
        title: "Success",
        message: "Data Edited",
        duration: Duration(seconds: 10),
      )..show(context);
    }

    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    MySize().init(context);
    return Scaffold(
      body: Column(
      
      children: [
        Padding(
          padding:  EdgeInsets.only(left: MySize.size10, top:MySize.size10, right:MySize.size10),
          child:
          TextFormField(
  controller: txtQuery,
  onChanged: search,
  decoration: InputDecoration(
  filled: true,
  fillColor: themeData.backgroundColor,
      hintText: "Search",
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: themeData.primaryColor),
      borderRadius: BorderRadius.circular(15.0),
      ),
      prefixIcon: Icon(Icons.search),
      suffixIcon: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          txtQuery.text = '';
          search(txtQuery.text);
        },
      ),
  ),
),
    
              ),
   Padding(
  padding:  EdgeInsets.only(left:MySize.size40),
  child:   Row(
  
    children: [
  
          DropdownButton<String>(
  
      
  
          focusColor:Colors.white,
  
      
  
      dropdownColor:themeData.backgroundColor,
  
      
  
                  value: _chosenValue,
  
      
  
                  //elevation: 5,
  
      
  
                  style: TextStyle(color: Colors.black),
  
      
  
      
  
      
  
                  items: <String>[
  
      
  
                    'ASC',
  
      
  
                    'DES',
  
      
  
                  ].map<DropdownMenuItem<String>>((String value) {
  
      
  
                    return DropdownMenuItem<String>(
  
      
  
                      value: value,
  
      
  
                      child: Text(value),
  
      
  
                    );
  
      
  
                  }).toList(),
  
      
  
                  hint: Text(
  
      
  
                    "Sort",
  
      
  
                    style: TextStyle(
  
      
  
                        color: Colors.black,
  
      
  
                        fontSize: 16,
  
      
  
                        fontWeight: FontWeight.w600),
  
      
  
                  ),
  
      
  
                  onChanged: (String ?value) {
  
      
  
                    setState(() {
  
      
  
                      _chosenValue = value;
  
      
  
                    });
  
      
  
                  }),
  
  
  
                  Padding(
                    padding: EdgeInsets.only(left:MySize.size20),
                    child: DropdownButton<String>(
  
      focusColor:Colors.white,
  
  dropdownColor:themeData.backgroundColor,
  
              value: chosenFieldValue,
  
              //elevation: 5,
  
              style: TextStyle(color: Colors.black),
  
  
  
              items: <String>[
  
                'User',
                'UPS Margin',
                'Fedex Margin',
                'Email',
                
  
              ].map<DropdownMenuItem<String>>((String value) {
  
                return DropdownMenuItem<String>(
  
                    value: value,
  
                    child: Text(value),
  
                );
  
              }).toList(),
  
              hint: Text(
  
                "Choose field to Sort",
  
                style: TextStyle(
  
                      color: Colors.black,
  
                      fontSize: 16,
  
                      fontWeight: FontWeight.w600),
  
              ),
  
              onChanged: (String ?value) {
  
                setState(() {
  
                    chosenFieldValue = value;
  
                });
  
              }),
                  ),
  
  

               Padding(
  padding:  EdgeInsets.only(left:MySize.size10),
  child:   GestureDetector(
    onTap: (){
      if(_chosenValue=="ASC" )
{
  if(chosenFieldValue=="User")
  {
jsonData.sort((a, b) => a["userName"].compareTo(b["userName"]));
setState(() {
  
});
print(jsonData[0]["userAddress"]["lastName"].toString());
  }
  else if(chosenFieldValue=="UPS Margin")
  {
    jsonData.sort((a, b) => a["margin"].compareTo(b["margin"]));
    setState(() {
  
});
  }
  else if(chosenFieldValue=="Fedex Margin")
  {
    jsonData.sort((a, b) => a["fedexMargin"].compareTo(b["fedexMargin"]));
    setState(() {
  
});

  }
  else if (chosenFieldValue=="Email")
  {
    jsonData.sort((a, b) => a["email"].compareTo(b["email"]));

setState(() {
  
});

  }
  
}
else if(_chosenValue=="DES")
{
  if(chosenFieldValue=="User")
  {
jsonData.sort((a, b) => b["userName"].compareTo(a["userName"]));
setState(() {
  
});
print(jsonData[0]["userAddress"]["lastName"].toString());
  }
  else if(chosenFieldValue=="UPS Margin")
  {
    jsonData.sort((a, b) => b["margin"].compareTo(a["margin"]));
    setState(() {
  
});
  }
  else if(chosenFieldValue=="Fedex Margin")
  {
    jsonData.sort((a, b) => b["fedexMargin"].compareTo(a["fedexMargin"]));
    setState(() {
  
});

  }
  else if (chosenFieldValue=="Email")
  {
    jsonData.sort((a, b) => b["email"].compareTo(a["email"]));

setState(() {
  
});

  }
}
    },
    child: Container(
    
                         width:MySize.size60,
    
                         height: MySize.size40,
    
       decoration: BoxDecoration(
    
        color: Colors.grey[400],
    
       borderRadius: BorderRadius.all(Radius.circular(4)
    
      
    
       )
    
       
    
     ),
    
     child: Center(child: Text("Sort"))
    
    ),
  ),
)  
    
    
    
    
    ],
  
  ),
),
          
          
// DropdownButton<String>(
//     focusColor:Colors.white,
// dropdownColor:themeData.backgroundColor,
//             value: _chosenValue,
//             //elevation: 5,
//             style: TextStyle(color: Colors.black),

//             items: <String>[
//               'ASC',
//               'DES',
//             ].map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//             hint: Text(
//               "Please choose a Sorting Format",
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600),
//             ),
//             onChanged: (String ?value) {
//               setState(() {
//                 _chosenValue = value;
//               });
//             }),

//            Padding(
//         padding:  EdgeInsets.only(left:MySize.size20, bottom: MySize.size20, top:MySize.size10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 // Icon(Icons.sort_by_alpha_sharp),
//                 SizedBox(),
//                 GestureDetector(
//                             onTap: (){
//             if(_chosenValue=="ASC")
//             {
// jsonData.sort((a, b) => a["userName"].compareTo(b["userName"]));
//             }
//             else if(_chosenValue=="DES")
//             {
// jsonData.sort((a, b) => b["userName"].compareTo(a["userName"]));
//             }
           

// // jsonData;
// setState(() {
  
// });
//           },
//                   child: Container(
//                      width:MySize.size60,
//                      height: MySize.size40,
//    decoration: BoxDecoration(
//     color: Colors.grey[400],
//    borderRadius: BorderRadius.all(Radius.circular(4)
  
//    )
   
//  ),
//  child: Center(child: Text("User"))
// )),

// SizedBox(
//   width: MySize.size10,
// ),
// GestureDetector(

//             onTap: (){
           
           
//   if(_chosenValue=="ASC")
//             {
// jsonData.sort((a, b) => a["margin"].compareTo(b["margin"]));
//             }
//             else if(_chosenValue=="DES")
//             {
// jsonData.sort((a, b) => b["margin"].compareTo(a["margin"]));
//             }           
           

// // jsonData;
// setState(() {
  
// });
//           },
//   child:   Container(
  
//                        width:MySize.size90,
  
//                        height: MySize.size40,
  
//      decoration: BoxDecoration(
  
//       color: Colors.grey[400],
  
//      borderRadius: BorderRadius.all(Radius.circular(4)
  
    
  
//      )
  
     
  
//    ),
  
//    child: Center(child: Text("Ups Margin"))
  
//   ),
// ),

//               SizedBox(
//                 width: MySize.size10,
//               ) ,
//               GestureDetector(
//              onTap: () {
//             if(_chosenValue=="ASC")
//             {
//               jsonData.sort((a, b) => a["fedexMargin"].compareTo(b["fedexMargin"]));
//             }
//             else if(_chosenValue=="DES")
//             {
//               jsonData.sort((a, b) => b["fedexMargin"].compareTo(a["fedexMargin"]));

//             }
//              setState(() {});
//           },

//                 child: Container(
//                        width:MySize.size8=90,
//                        height: MySize.size40,
//                  decoration: BoxDecoration(
//                   color: Colors.grey[400],
//                  borderRadius: BorderRadius.all(Radius.circular(4)
                
//                  )
                 
//                ),
//                child: Center(child: Text("Fedex Margin"))
//               ),
//               ),
//               SizedBox(
//                 width:MySize.size10
//                 ),
//               GestureDetector(
//                           onTap: (){
//               if(_chosenValue=="ASC")
//             {
//              jsonData.sort((a, b) => a["email"].compareTo(b["email"]));
//             }
//             else if(_chosenValue=="DES")
//             {
//              jsonData.sort((a, b) => b["email"].compareTo(a["email"]));
//             }
// // jsonData;
//               setState(() {});
//           },
//                 child: Container(
//                        width:MySize.size60,
//                        height: MySize.size40,
//                  decoration: BoxDecoration(
//                   color: Colors.grey[400],
//                  borderRadius: BorderRadius.all(Radius.circular(4)
                
//                  )
                 
//                ),
//                child: Center(child: Text("Email"))
//               ),
//               ),
            
//               ],
//             ),
//           ),
          
           
        Container(
          // height: MediaQuery.of(context).size.height * 0.8,
          // padding: EdgeInsets.only(bottom: MySize.size40),
          child: Expanded(
            child: FutureBuilder(
        future: futureUserList,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Container(
              
                child: ListView.builder(
                  itemCount: jsonData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 3),
                          child: Card(
                            elevation: 15,
                            shadowColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              padding: EdgeInsets.zero,
                              child: ExpansionTile(
                                trailing: SizedBox.shrink(),
                                title: Text(jsonData[index]
                                            ["firstName"]
                                        .toString() +
                                    " " +
                                    jsonData[index]["lastName"]
                                        .toString()),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("UPS Margin: "),
                                        Text(jsonData[index]
                                                ["margin"]
                                            .toString()),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                         Text(
                                              "Status: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(jsonData[index]
                                                            ["status"]
                                                        .toString() ==
                                                    "true"
                                                ? "Approved"
                                                : "Not Approved")
                                        // Text("Fedex Margin: "),
                                        // Text(jsonData[index]
                                        //         ["fedexMargin"]
                                        //     .toString()),
                                      ],
                                    )
                                  ],
                                ),
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Email: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(jsonData[index]
                                                    ["email"]
                                                .toString())
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Username: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(jsonData[index]
                                                    ["userName"]
                                                .toString())
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Phone Number: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            jsonData[index]["phoneNumber"]==null?Text("N/A"):Text(jsonData[index]["phoneNumber"].toString())
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            // Text(
                                            //   "Status: ",
                                            //   style: TextStyle(
                                            //     fontWeight: FontWeight.bold,
                                            //   ),
                                            // ),
                                            // Text(jsonData[index]
                                            //                 ["status"]
                                            //             .toString() ==
                                            //         "true"
                                            //     ? "Approved"
                                            //     : "Not Approved")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Email Confirmed: ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(jsonData[index]
                                                            ["emailConfirmed"]
                                                        .toString() ==
                                                    "true"
                                                ? "Verified"
                                                : "Not Verified")
                                          ],
                                        ),
                                        Wrap(
                                          children: [
                                            // Text(
                                            //   "Actions: ",
                                            //   style: TextStyle(
                                            //     fontWeight: FontWeight.bold,
                                            //   ),
                                            // ),
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
                                                  Colors.orange.shade400,
                                                ),
                                              ),
                                              onPressed: () {
                                                if (jsonData[index]
                                                            ["status"]
                                                        .toString() ==
                                                    "true") {
                                                  _value = 1;
                                                } else if (jsonData[index]
                                                            ["status"]
                                                        .toString() ==
                                                    "false") {
                                                  _value = 0;
                                                }
                                                if (jsonData[index]
                                                            ["emailConfirmed"]
                                                        .toString() ==
                                                    "true") {
                                                  _emailValue = 1;
                                                } else if (jsonData[index]
                                                            ["emailConfirmed"]
                                                        .toString() ==
                                                    "false") {
                                                  _emailValue = 0;
                                                }

                                                _shippingBottomSheet(
                                                    jsonData[index]
                                                            ["fedexMargin"]
                                                        .toString(),
                                                    jsonData[index]
                                                            ["margin"]
                                                        .toString(),
                                                    _value,
                                                    _emailValue,
                                                    jsonData[index]
                                                            ["id"]
                                                        .toString(),
                                                    context);
                                              },
                                              child: Text("Actions"),
                                            ),
                                            SizedBox(width: 10),
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
                                                  Colors.cyan.shade200,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Shipping(),
                                                    ));
                                              },
                                              child: Text("Create Label"),
                                            ),
                                            SizedBox(width: 10),

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
                                                  Colors.indigo.shade100,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Label(
                                                        id: jsonData[
                                                                index]["id"]
                                                            .toString(),
                                                      ),
                                                    ));
                                              },
                                              child: Text("Labels"),
                                            ),
                                            SizedBox(width: 10),
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
                                                  Colors.red.shade100,
                                                ),
                                              ),
                                              onPressed: () {
                                                TextEditingController
                                                    creditController =
                                                    TextEditingController();
                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: const Text(
                                                        'Add Credit'),
                                                    // content: const Text(
                                                    //   'AlertDialog description'),
                                                    actions: <Widget>[
                                                      customTextField(
                                                          creditController,
                                                          "",
                                                          "Add Credit"),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    'Cancel'),
                                                            child: const Text(
                                                                'Cancel'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              if (creditController
                                                                      .text ==
                                                                  "") {
                                                                Navigator.pop(
                                                                    context);
                                                                Flushbar(
                                                                  title:
                                                                      "Invalid",
                                                                  message:
                                                                      "Please Add Date",
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              3),
                                                                )..show(
                                                                    context);
                                                              }
                                                              if (creditController
                                                                  .text
                                                                  .isNotEmpty)
                                                                postCreditData(
                                                                    jsonData[index]
                                                                            [
                                                                            "id"]
                                                                        .toString(),
                                                                    creditController
                                                                        .text);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'OK'),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              child: Text("Add Credits"),
                                            ),
                                            SizedBox(width: 10),
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
                                                  Colors.grey.shade400,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                Usercredit(
                                                                  id: jsonData[index]
                                                                          ["id"]
                                                                      .toString(),
                                                                )));
                                              },
                                              child: Text("User Credits"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              );
            } else {
              return Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Text('No Data Found'),
              );
            }
          } else {
            return Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        },
      ),
    ),
        ),
      ],
    )
  );
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
            //  fillColor: themeData.colorScheme.background,
            hintStyle: TextStyle(
                //  color: themeData.colorScheme.onBackground,
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

  void _shippingBottomSheet(
    item,
    price,
    _value,
    emailConfirm,
    id,
    context,
  ) {
    //TextEditingController nameController = TextEditingController();
    TextEditingController upsController = TextEditingController();
    TextEditingController fedexController = TextEditingController();

//  nameController.text = name;
    upsController.text = item;
    fedexController.text = price;
    showModalBottomSheet(
        isScrollControlled: true,
          backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext buildContext) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter modalsetState /*You can rename this!*/) {
            return Container(
              child: SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.only(top: 30),
                    //height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(""),
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
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(child: Text("Actions")),
                                  Row(
                                    children: [
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          canvasColor: Colors.white,
                                        ),
                                        child: DropdownButton(
                                          value: _value,
                                          items: [
                                            DropdownMenuItem(
                                              child: Material(
                                                child: Text(
                                                  "Approve",
                                                ),
                                              ),
                                              value: 1,
                                            ),
                                            DropdownMenuItem(
                                              child: Text("Block"),
                                              value: 0,
                                            ),
                                          ],
                                          onChanged: (value) {
                                            _value = value!;
                                            modalsetState(() {});
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MySize.size30),
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            canvasColor: Colors.white,
                                          ),
                                          child: DropdownButton(
                                              value: emailConfirm,
                                              items: [
                                                DropdownMenuItem(
                                                  child: Material(
                                                    child: Text(
                                                      "Verified",
                                                    ),
                                                  ),
                                                  value: 1,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text("Not Verified"),
                                                  value: 0,
                                                ),
                                              ],
                                              onChanged: (value) {
                                                emailConfirm = value!;
                                                modalsetState(() {});
                                              },
                                              hint: Text("Email Confirmed")),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  //customTextField(
                                  Divider(),

                                  //),
                                  // customTextField(
                                  //   nameController,
                                  //   "",
                                  //   "Name",
                                  // ),

                                  customTextField(
                                    upsController,
                                    "",
                                    "UPS Discount",
                                  ),
                                  customTextField(
                                    fedexController,
                                    "",
                                    "Fedex Discount",
                                  ),

                                  // customTextField(
                                  //   stockController,
                                  //   "",
                                  //   "Stock",
                                  // ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: MySize.size80),
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            deleteData(id);
                                          },
                                          child: Text("Delete"),
                                        ),
                                        SizedBox(width: MySize.size10),
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              postData(upsController.text,
                                                  fedexController.text, id);
                                            },
                                            child: Text("Save"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ))),
              ),
            );
          });
        });
  }
}
