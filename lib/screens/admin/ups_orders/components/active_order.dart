import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:http/http.dart' as http;
import 'package:aquatic_xpress_shipping/screens/admin/ups_orders/components/listview.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../AppTheme.dart';
import '../../../../size_config.dart';

class ActiveOrders extends StatefulWidget {
  const ActiveOrders({Key? key}) : super(key: key);

  @override
  _ActiveOrdersState createState() => _ActiveOrdersState();
}

class _ActiveOrdersState extends State<ActiveOrders> {
  Future? futureUserList;
  late ThemeData themeData;

  bool isConnected = false;


  String ? chosenFieldValue;
String ?_chosenValue="ASC";
List jsonData=[];
List searchJson=[];
 TextEditingController txtQuery = new TextEditingController();
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
    var name =p["userAddress"]["lastName"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
    name =p["orderDate"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
    name =p["addressBook"]["lastName"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
    name =p["totalPrice"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
    name =p["trackingNumber"].toString().toLowerCase();
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
// var uniqueCount = uniqueIds.length;

 
  jsonData = result;
  setState(() {});
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

  @override
  void initState() {
    super.initState();
    futureUserList = getUsers();
    
  }
  movetoHistory(id)async{
     String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/ShipmentOrder/UpdateProcessStatusUPS?id=$id";
    // "${getCloudUrl()}​/api​/ShipmentOrder​/getfedexorderlist";

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
      jsonData.clear();
      searchJson.clear();
     futureUserList=getUsers();
      setState(() {
      });
     
    } else {
      print("Exception");
      throw Error;
    }
  }

  getUsers() async {
    // quickQuote = 0;
    // curl();
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/ShipmentOrder/getorderlist";
    // "${getCloudUrl()}​/api​/ShipmentOrder​/getfedexorderlist";

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
      jsonData.addAll(data);
      searchJson.addAll(data);
      return data;
    } else {
      print("Exception");
      throw Error;
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return FutureBuilder(
      future: futureUserList,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            // return CustomListView(data: snapshot.data);
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
  
                'Sender',
                'Order Date',
                'Reciever',
                'Price',
                'Tracking'
  
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
  if(chosenFieldValue=="Sender")
  {
jsonData.sort((a, b) => a["userAddress"]["lastName"].compareTo(b["userAddress"]["lastName"]));
setState(() {
  
});
  }
  else if(chosenFieldValue=="Order Date")
  {
    jsonData.sort((a, b) => a["orderDate"].compareTo(b["orderDate"]));
    setState(() {
  
});
  }
  else if(chosenFieldValue=="Reciever")
  {
    jsonData.sort((a, b) => a["addressBook"]["lastName"].compareTo(b["addressBook"]["lastName"]));
    setState(() {
  
});

  }
  else if (chosenFieldValue=="Price")
  {
 jsonData.sort((a, b) => a["totalPrice"].compareTo(b["totalPrice"]));
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
   if(chosenFieldValue=="Sender")
  {
jsonData.sort((a, b) => b["userAddress"]["lastName"].compareTo(a["userAddress"]["lastName"]));
setState(() {
  
});
  }
  else if(chosenFieldValue=="Order Date")
  {
    jsonData.sort((a, b) => b["orderDate"].compareTo(a["orderDate"]));
    setState(() {
  
});
  }
  else if(chosenFieldValue=="Reciever")
  {
    jsonData.sort((a, b) => b["addressBook"]["lastName"].compareTo(a["addressBook"]["lastName"]));
    setState(() {
  
});

  }
  else if (chosenFieldValue=="Price")
  {
 jsonData.sort((a, b) => b["totalPrice"].compareTo(a["totalPrice"]));
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
        itemCount: jsonData.length,
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
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Sender: ",
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.button,
                                  fontWeight: 600,
                                ),
                              ),
                              Text(
                                // widget.data[index]["user"]["recieverName"].toString(),
                                jsonData[index]["userAddress"]["lastName"]
                                    .toString(),
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.button,
                                  fontWeight: 550,
                                ),
                              ),
                         
                            ],
                          ),
                        Row(
                        children: [ 
                          Text("Reciever:", style: AppTheme.getTextStyle(
                                  themeData.textTheme.button,
                                  fontWeight: 600,
                                ),),
                                Text(jsonData[index]["addressBook"]["lastName"].toString(),                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.button,
                                  fontWeight: 550,
),),

                        ],)

                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
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
                                                  : "Recieved",
                                ),
                                // Text(
                                //   "Status: ",
                                //   style: AppTheme.getTextStyle(
                                //     themeData.textTheme.button,
                                //     fontWeight: 600,
                                //   ),
                                // ),
                                // Text(
                                //   widget.data[index]["status"].toString(),
                                //   style: AppTheme.getTextStyle(
                                //     themeData.textTheme.button,
                                //     fontWeight: 550,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                            Row( 
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Price: ",
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.button,
                                  fontWeight: 600,
                                ),
                              ),
                              Text(
                                jsonData[index]["totalPrice"].toStringAsFixed(2).toString(),
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.button,
                                  fontWeight: 550,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              
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
                                     mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                     children: [
                                       Text("Order Date:",style: AppTheme.getTextStyle(
                                                                     themeData.textTheme.button,
                                                                     fontWeight: 600,
                                                                   ),),
                                           Text(
                                                                       DateFormat("yyyy-MM-dd").format(
                                                                         DateTime.parse(jsonData[index]
                                                                                 ["orderDate"]
                                                                             .toString()),
                                                                       ),
                                                                     ),
                                     ],
                                   ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [],
                              // ),
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
                                  Text(jsonData[index]
                              ["daysInTransit"].toString())
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
                                      openURl(
                                          jsonData[index]["trackingNumber"]);
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
                                  // Text(widget.data[index]["daysInTransit"]
                                  //     .toString())
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Text(
                                  //   "Action: ",
                                  //   style: TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  // Text("Move to History")
                                ],
                              ),
                               Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Margin: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(jsonData[index]["margin"].toString())
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
                              //         widget.data[index]["status"].toString() ==
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
                                  // Text(widget.data[index]["emailConfirmed"]
                                  //             .toString() ==
                                  //         "true"
                                  //     ? "Verified"
                                  //     : "Not Verified")
                             Padding(
                               padding:  EdgeInsets.only(left:MySize.size52*2),
                               child: ElevatedButton(
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
                                                onPressed: () {
                                                  movetoHistory(jsonData[index]["id"]);
                                                      jsonData.removeAt(index);
                                                      searchJson.removeAt(index);
                                                      setState(() {
                                                        
                                                      });
                                                },
                                                child: Text("Move to History"),
                                              ),
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
    ),
        ),
      ],
    );
  
          
          } else {
            return Container(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Center(child: Text('No Data Found')),
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
    );
  }
}
