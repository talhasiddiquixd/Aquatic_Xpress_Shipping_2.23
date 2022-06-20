import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:aquatic_xpress_shipping/screens/user/profile/components/InProcess_Orders/image.dart';
import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;


class CustomListView extends StatefulWidget {
  final data;
  final value;

  const CustomListView({Key? key, required this.data, this.value}) : super(key: key);

  @override
  _CustomListViewState createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {

  getLabel(trackingId) async {
    // quickQuote = 0;
    // curl();
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/UPS/sendlabel/$trackingId";
    // "${getCloudUrl()}​​/api​/ShipmentOrder​/unpaidOrders";

    var url = Uri.parse(link);
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
//       body: jsonEncode({
//   // "trackingID": trackingId
//   "trackingID":trackingId

// })
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
  }
  
   getVoid(trackingId, id, index) async {
    // quickQuote = 0;
    // curl();
    try {
      
    
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/ups/voidorder/$trackingId";
    // "${getCloudUrl()}​​/api​/ShipmentOrder​/unpaidOrders";

    var url = Uri.parse(link);
    var response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
//       body: jsonEncode({
//   "trackingID": trackingId
//   // "TrackingID":trackingId

// })
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      removeItem(id, index);
      return data;
    } else {
      print("Exception");
      throw Error;
    }
    } catch (e) {
      print (e);
    }
  }
  
  removeItem(id, index) async {
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/ShipmentOrder/Delete/$id";
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
      var dataas = json.decode(response.body);

      Flushbar(
        title: "Success",
        message: "Item removed successfuly",
        duration: Duration(seconds: 3),
      )..show(context);

jsonData.removeAt(index);
    
      setState(() {});

      return dataas;
    } else {
      print("Exception");
      throw Error;
    }
  }
List searchJson=[];
List jsonData=[];
String ?_chosenValue="ASC";
String? chosenFieldValue;
var price;
 TextEditingController txtQuery = new TextEditingController();
  late ThemeData themeData;
  
  void search(String query) {
  if (query.isEmpty) {
    jsonData = searchJson;
    setState(() {});
    return;
  }

  query = query.toLowerCase();
  print(query);
  List result = [];
  jsonData.forEach((p) {
    var name =p["recieverName"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
     name =p["trackingNumber"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
   name =p["price"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
   name =p["est"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
  
   name =p["orderService"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
  
  
  });

  var data = result;
 List orders=[];
orders.addAll(data);
var uniqueData = orders.map((o) => o).toSet();
 result.clear();
result.addAll(uniqueData);


  jsonData = result;
  setState(() {});
}
 
 @override
  void initState() { 
    super.initState();
    jsonData.clear();
    try {

      jsonData.addAll(widget.data);
      searchJson.addAll(widget.data);
      // price=jsonData[0]["price"];
            // for(int i=0; i<jsonData!.length; i++)
            // { 
            // jsonData.add(jsonData[i]);
            // searchJson.add(jsonData[i]);
            // print(jsonData);
            // } 
              
            } catch (e) {
              print(e);
            }
            
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    jsonData;
  }
  openURl(id) async {
    if (await canLaunch(
        "https://wwwapps.ups.com/WebTracking/processInputRequest?sort_by=status&tracknums_displ%20ayed=1&TypeOfInquiryNumber=T&loc=en_US&InquiryNumber1=" +
            id +
            "&track.x=0&track.y=0&requester=ST/trackdetails")) {
      await launch(
          "https://wwwapps.ups.com/WebTracking/processInputRequest?sort_by=status&tracknums_displ%20ayed=1&TypeOfInquiryNumber=T&loc=en_US&InquiryNumber1=" +
              id +
              "&track.x=0&track.y=0&requester=ST/trackdetails");
    } else {
      throw "could not URL";
    }
  }

  openFedex(id) async {
   if (await canLaunch(
        "https://www.fedex.com/fedextrack/system-error?trknbr=" + id)) {
      await launch(
          "https://www.fedex.com/fedextrack/system-error?trknbr=" + id);
    } else {
      throw "could not URL";
    }
  }
 @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Column(
      
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
  
                'Reciever',
                'Price',
                'Service',
                'Tracking',
                'EST',
  
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
  if(chosenFieldValue=="Reciever")
  {
jsonData.sort((a, b) => a["recieverName"].compareTo(b["recieverName"]));
setState(() {
  
});
  }
  else if(chosenFieldValue=="Service")
  {
    jsonData.sort((a, b) => a["orderService"].compareTo(b["orderService"]));
    setState(() {
  
});
  }
  else if(chosenFieldValue=="Price")
  {
    jsonData.sort((a, b) => a["price"].compareTo(b["price"]));
    setState(() {
  
});}
  else if(chosenFieldValue=="EST")
  {
jsonData.sort((a, b) => a["est"].compareTo(b["est"]));
    setState(() {
  
});

  }
  else if (chosenFieldValue=="Tracking")
  {
 jsonData.sort((a, b) => a["trackingNumber"].compareTo(b["trackingNumber"]));
setState(() {
  
});

  }
  
}
else if(_chosenValue=="DES")
{
   if(chosenFieldValue=="Reciever")
  {
jsonData.sort((a, b) => b["recieverName"].compareTo(a["recieverName"]));
setState(() {
  
});
  }
  else if(chosenFieldValue=="Service")
  {
    jsonData.sort((a, b) => b["orderService"].compareTo(a["orderService"]));
    setState(() {
  
});
  }
  else if(chosenFieldValue=="Price")
  {
    jsonData.sort((a, b) => b["price"].compareTo(a["price"]));
    setState(() {
  
});}
  else if(chosenFieldValue=="EST")
  {
jsonData.sort((a, b) => b["est"].compareTo(a["est"]));
    setState(() {
  
});

  }
  else if (chosenFieldValue=="Tracking")
  {
 jsonData.sort((a, b) => b["trackingNumber"].compareTo(a["trackingNumber"]));
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
          
           
        Container(
          // height: MediaQuery.of(context).size.height * 0.8,
          // padding: EdgeInsets.only(bottom: MySize.size40),
          child: Expanded(
            child: ListView.builder(
              itemCount:  jsonData.length,
              // jsonData.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          MySize.size10, MySize.size2, MySize.size10, MySize.size2),
                      child: Card(
                        elevation: 15,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(MySize.size20),
                        ),
                        child: ListTileTheme(
                          // dense: true,
          
                          contentPadding: EdgeInsets.fromLTRB(MySize.size10, 0, 0, 0),
                          child: ExpansionTile(
                            trailing: SizedBox.shrink(),
                            // trailing: Text(''),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                Text(
                                "Reciever: ",
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.button,
                                  fontWeight: 600,
                                ),
                              ),
                               Text(
                                jsonData[index]["recieverName"].toString(),
                                // jsonData[index]["userAddress"]["lastName"]
                                //     .toString(),
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.button,
                                  fontWeight: 550,
                                ),
                              ),
                                  ],
                                ),
                                Row(
                                  children: [
                                     Text(
                                "Price: "+double.parse(
                                                            jsonData[index]["price"]
                                                                .toString()).toStringAsFixed(2),
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.button,
                                  fontWeight: 600,
                                ),
                              ),
                               
                              //   Text(
                              //   double.parse(jsonData[index]["price"].toString()),

                              //   style: AppTheme.getTextStyle(
                              //     themeData.textTheme.button,
                              //     fontWeight: 550,
                              //   ),
                              // ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      " ",
                                      style: AppTheme.getTextStyle(
                                        themeData.textTheme.button,
                                        fontWeight: 600,
                                      ),
                                    ),
                                   Text(
                                "Status: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                jsonData[index]["status"].toString() == 'C'
                                    ? "In Process"
                                    : jsonData[index]["status"].toString() ==
                                            'V'
                                        ? "Canceled"
                                        : jsonData[index]["status"]
                                                    .toString() ==
                                                'I'
                                            ? "Transit"
                                            : jsonData[index]["status"]
                                                        .toString() ==
                                                    'V'
                                                ? "Completed"
                                                : "No Status",
                              ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    // // Text(
                                    // //   "UserName:" +
                                    // //       jsonData[index]["userName"].toString(),
                                    // //   style: AppTheme.getTextStyle(
                                    // //     themeData.textTheme.button,
                                    // //     fontWeight: 550,
                                    // //   ),
                                    // ),
                                  ],
                                )
                              ],
                            ),
                           children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              MySize.size10, 0, MySize.size36, MySize.size10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                    Text(
                                      "EST: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                jsonData[index]["est"].toString().contains("EOD")?Text(jsonData[index]["est"].toString().split(" ")[0] +" 11:59 PM"):Text(jsonData[index]["est"].toString())
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Tracking #: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      widget.value==0?
                                      openURl(
                                          jsonData[index]["trackingNumber"]):openFedex(jsonData[index]["trackingNumber"].toString());
                                    },
                                    child: Text(
                                      jsonData[index]["trackingNumber"]
                                          .toString(),
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Text(
                                  //   "Days in Transit: ",
                                  //   style: TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  // Text(jsonData[index]["daysInTransit"]
                                  //     .toString())
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Service: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  jsonData[index]["orderService"]==null?Container():Text(jsonData[index]["orderService"]
                                      .toString())
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       "Status: ",
                              //       style: TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //     Text(
                              //         jsonData[index]["status"].toString() ==
                              //                 "true"
                              //             ? "Approved"
                              //             : "Not Approved")
                              //   ],
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Text(
                                  //   "Email Confirmed: ",
                                  //   style: TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  // Text(jsonData[index]["emailConfirmed"]
                                  //             .toString() ==
                                  //         "true"
                                  //     ? "Verified"
                                  //     : "Not Verified")
                                ],
                              ),
                            

                         Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           children: [
                             ElevatedButton(style: ButtonStyle(foregroundColor:
                             MaterialStateProperty.all<
                             Color>(
                              Colors.black,),
                              backgroundColor:MaterialStateProperty.all<Color>(Colors.amber.shade400,),),
                              onPressed: (){
                               getLabel( jsonData[index]["trackingNumber"].toString());
                              }  
                             , child: Text("Label")),
                         Padding(
                           padding:  EdgeInsets.only(left:MySize.size10),
                           child: 
                          //  ElevatedButton(onPressed: (){

                          //           ),
                          //         );

                          //  }, child: Text("Print"))
                           ElevatedButton(style: ButtonStyle(foregroundColor:
                           MaterialStateProperty.all<
                           Color>(
                            Colors.black,),
                            backgroundColor:MaterialStateProperty.all<Color>(Colors.orangeAccent.shade400,),),
                            onPressed: (){
                           Navigator.push(context, MaterialPageRoute(
                                      builder: (_) => ImageDisplay(data:jsonData[index]["trackingNumber"].toString()),
                           ));}  
                           , child: Text("Print")),
                         ),

                         
                         Padding(
                           padding:  EdgeInsets.only(left:MySize.size10),
                           child: ElevatedButton(style: ButtonStyle(foregroundColor:
                           MaterialStateProperty.all<
                           Color>(
                            Colors.black,),
                            backgroundColor:MaterialStateProperty.all<Color>(Colors.cyan.shade400,),),
                            onPressed: (){
                              getVoid(jsonData[index]["trackingNumber"],jsonData[index]["id"], index );
                            }  
                           , child: Text("Void")),
                         ),
                         
                           ],
                         ),       
                         
                         
                                              ],

                         
                          ),
                        ),
                      ],),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
         
          ),
         
        ),
      ],
    );
  }

  }
