import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomListView extends StatefulWidget {
  final data;
  final value;

  const CustomListView({Key? key, required this.data, this.value}) : super(key: key);

  @override
  _CustomListViewState createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  List searchJson=[];
List jsonData=[];
String ?_chosenValue="ASC";
String? chosenFieldValue;
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
    var name =p["userAddress"]["lastName"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
     name =p["trackingNumber"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
   name =p["totalPrice"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
   name =p["daysInTransit"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
  
   name =p["orderService"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }

     name =p["margin"].toString().toLowerCase();
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
                'Sender',
                'Days In Transit',
                'Margin',
                'Order Date,'
  
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
  else if(chosenFieldValue=="Service")
  {
    jsonData.sort((a, b) => a["orderService"].compareTo(b["orderService"]));
    setState(() {
  
});
  }
  else if(chosenFieldValue=="Price")
  {
    jsonData.sort((a, b) => a["totalPrice"].compareTo(b["totalPrice"]));
    setState(() {
  
});}
  else if(chosenFieldValue=="Reciever")
  {
jsonData.sort((a, b) => a["addressBook"]["lastName"].compareTo(b["addressBook"]["lastName"]));
    setState(() {
  
});

  }
  else if(chosenFieldValue=="Order Date")
  {
jsonData.sort((a, b) => a["orderDate"].compareTo(b["orderDate"]));
    setState(() {
  
});

  }
  else if(chosenFieldValue=="Margin")
  {
jsonData.sort((a, b) => a["margin"].compareTo(b["margin"]));
    setState(() {
  
});

  }

  else if(chosenFieldValue=="Days In Transit")
  {
jsonData.sort((a, b) => a["daysInTransit"].compareTo(b["daysInTransit"]));
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
  else if(chosenFieldValue=="Service")
  {
    jsonData.sort((a, b) => b["orderService"].compareTo(a["orderService"]));
    setState(() {
  
});
  }
  else if(chosenFieldValue=="Price")
  {
    jsonData.sort((a, b) => b["totalPrice"].compareTo(a["totalPrice"]));
    setState(() {
  
});}
  else if(chosenFieldValue=="Reciever")
  {
jsonData.sort((a, b) => b["addressBook"]["lastName"].compareTo(a["addressBook"]["lastName"]));
    setState(() {
  
});

  }
  else if(chosenFieldValue=="Order Date")
  {
jsonData.sort((a, b) => b["orderDate"].compareTo(a["orderDate"]));
    setState(() {
  
});

  }
  else if(chosenFieldValue=="Margin")
  {
jsonData.sort((a, b) => b["margin"].compareTo(a["margin"]));
    setState(() {
  
});

  }

  else if(chosenFieldValue=="Days In Transit")
  {
jsonData.sort((a, b) => b["daysInTransit"].compareTo(a["daysInTransit"]));
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
                                "Sender: ",
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.button,
                                  fontWeight: 600,
                                ),
                              ),
                               Text(
                                jsonData[index]["userAddress"]["lastName"].toString(),
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
                                "Price: ",
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.button,
                                  fontWeight: 600,
                                ),
                              ),
                              Text(
                                jsonData[index]["totalPrice"].toString(),
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.button,
                                  fontWeight: 550,
                                ),
                              ),
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
                                "Reciever: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                jsonData[index]["addressBook"]["lastName"]
                              ),
                                  ],
                                ),
                                Row(
                                  children: [
                                     Text(
                                DateFormat("yyyy-MM-dd").format(
                                  DateTime.parse(jsonData[index]["orderDate"]
                                      .toString()),
                                ),)
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
                                    "Status: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    jsonData[index]["status"].toString() ==
                                            'C'
                                        ? "In Process"
                                        : "Completed",
                                  ),
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
                                          jsonData[index]["trackingNumber"].toString());
                                          // :openFedex(jsonData[index]["trackingNumber"].toString());
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
                                    "Days in Transit: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(jsonData[index]["daysInTransit"]
                                      .toString())
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
                                  Text(jsonData[index]["orderService"]
                                      .toString())
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Email Confirmed: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(jsonData[index]["emailConfirmed"]
                                              .toString() ==
                                          "true"
                                      ? "Verified"
                                      : "Not Verified")
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
                                  Text(
                                    "Status: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                      jsonData[index]["status"].toString() ==
                                              "true"
                                          ? "Approved"
                                          : "Not Approved")
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
