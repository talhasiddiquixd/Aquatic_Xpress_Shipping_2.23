import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../AppTheme.dart';
import '../../../size_config.dart';

class ServiceHistory extends StatefulWidget {
  const ServiceHistory({Key? key, this.data}) : super(key: key);
  final data;
  @override
  _ServiceHistoryState createState() => _ServiceHistoryState();
}

class _ServiceHistoryState extends State<ServiceHistory> {

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
  List result=[];

 // ignore: unnecessary_statements
//  result!= jsonData.where((item) => item["userName"].
// contains(searchJson) || item["orderDate"].toLowerCase().contains(searchJson) || item["additionalCharges"].contains(searchJson) || item["previousAmount"].contains(searchJson) || item["shipmentTrackingNumber"].contains(searchJson));
// var data= jsonData.where((item) => item.userName.
// contains(searchJson) || item.orderDate.contains(searchJson) || item.additionalCharges.contains(searchJson) || item.previousAmount.contains(searchJson) || item.shipmentTrackingNumber.contains(searchJson));

  jsonData.forEach((p) {
    var name =p["userName"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
     name =p["orderDate"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
   name =p["additionalCharges"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
   name =p["previousAmount"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
  
   name =p["shipmentTrackingNumber"].toString().toLowerCase();
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

  
  // jsonData.clear();
  jsonData=result;
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
    jsonData.clear();
    try {

      jsonData.addAll(widget.data);
      searchJson.addAll(widget.data);
              
            } catch (e) {
              print(e);
            }
            
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    jsonData;
    searchJson;
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
  
                'User Name',
                'Order Date',
                'Charges',
                'Previous Amount',
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
  if(chosenFieldValue=="User Name")
  {
jsonData.sort((a, b) => a["userName"].compareTo(b["userName"]));
setState(() {
  
});
  }
  else if(chosenFieldValue=="Order Date")
  {
    jsonData.sort((a, b) => a["orderDate"].compareTo(b["orderDate"]));
    setState(() {
  
});
  }
  else if(chosenFieldValue=="Charges")
  {
    jsonData.sort((a, b) => a["additionalCharges"].compareTo(b["additionalCharges"]));
    setState(() {
  
});}
  else if(chosenFieldValue=="Previous Amount")
  {
jsonData.sort((a, b) => a["previousAmount"].compareTo(b["previousAmount"]));
    setState(() {
  
});

  }
  else if (chosenFieldValue=="Tracking")
  {
 jsonData.sort((a, b) => a["shipmentTrackingNumber"].compareTo(b["shipmentTrackingNumber"]));
setState(() {
  
});

  }
  
}
else if(_chosenValue=="DES")
{
   if(chosenFieldValue=="User Name")
  {
jsonData.sort((a, b) => b["userName"].compareTo(a["userName"]));
setState(() {
  
});
  }
  else if(chosenFieldValue=="Order Date")
  {
    jsonData.sort((a, b) => b["orderDate"].compareTo(a["orderDate"]));
    setState(() {
  
});
  }
  else if(chosenFieldValue=="Charges")
  {
    jsonData.sort((a, b) => b["additionalCharges"].compareTo(a["additionalCharges"]));
    setState(() {
  
});}
  else if(chosenFieldValue=="Previous Amount")
  {
jsonData.sort((a, b) => b["previousAmount"].compareTo(a["previousAmount"]));
    setState(() {
  
});

  }
  else if (chosenFieldValue=="Tracking")
  {
 jsonData.sort((a, b) => b["shipmentTrackingNumber"].compareTo(a["shipmentTrackingNumber"]));
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
//             padding: const EdgeInsets.all(8.0),
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
//  child: Center(child: Text("Name"))
// )),

// SizedBox(
//   width: MySize.size10,
// ),
// GestureDetector(

//             onTap: (){
              
           
//   if(_chosenValue=="ASC")
//             {
// jsonData.sort((a, b) => a["orderDate"].compareTo(b["orderDate"]));
//             }
//             else if(_chosenValue=="DES")
//             {
// jsonData.sort((a, b) => b["orderDate"].compareTo(a["orderDate"]));
//             }           
           

// // jsonData;
// setState(() {
  
// });
//           },
//   child:   Container(
  
//                        width:MySize.size80,
  
//                        height: MySize.size40,
  
//      decoration: BoxDecoration(
  
//       color: Colors.grey[400],
  
//      borderRadius: BorderRadius.all(Radius.circular(4)
  
    
  
//      )
  
     
  
//    ),
  
//    child: Center(child: Text("Order Date"))
  
//   ),
// ),

//               SizedBox(
//                 width: MySize.size10,
//               ) ,
//               GestureDetector(
//                           onTap: (){
            
//              if(_chosenValue=="ASC")
//             {
// jsonData.sort((a, b) => a["additionalCharges"].compareTo(b["additionalCharges"]));
//             }
//             else if(_chosenValue=="DES")
//             {
//               jsonData.sort((a, b) => b["additionalCharges"].compareTo(a["additionalCharges"]));

//             }

// // jsonData;
// setState(() {
  
// });
//           },

//                 child: Container(
//                        width:MySize.size60,
//                        height: MySize.size40,
//                  decoration: BoxDecoration(
//                   color: Colors.grey[400],
//                  borderRadius: BorderRadius.all(Radius.circular(4)
                
//                  )
                 
//                ),
//                child: Center(child: Text("Charges"))
//               ),
//               ),
//               SizedBox(
//                 width:MySize.size10
//                 ),
//               GestureDetector(
//                           onTap: (){
//               if(_chosenValue=="ASC")
//             {
// jsonData.sort((a, b) => a["previousAmount"].compareTo(b["previousAmount"]));
//             }
//             else if(_chosenValue=="DES")
//             {
// jsonData.sort((a, b) => b["previousAmount"].compareTo(a["previousAmount"]));
//             }
           

// // jsonData;
// setState(() {
  
// });
//           },
//                 child: Container(
//                        width:MySize.size80,
//                        height: MySize.size40,
//                  decoration: BoxDecoration(
//                   color: Colors.grey[400],
//                  borderRadius: BorderRadius.all(Radius.circular(4)
                
//                  )
                 
//                ),
//                child: Center(child: Text("P Amount"))
//               ),
//               ),
//             SizedBox(width: MySize.size10,),
//             GestureDetector(
//                         onTap: (){
//               if(_chosenValue=="ASC")
//             {
// jsonData.sort((a, b) => a["shipmentTrackingNumber"].compareTo(b["shipmentTrackingNumber"]));
//             }
//             else if(_chosenValue=="DES")
//             {
// jsonData.sort((a, b) => b["shipmentTrackingNumber"].compareTo(a["shipmentTrackingNumber"]));
//             }
           

// // jsonData;

// setState(() {
  
// });
//           },
//               child: Container(
//                        width:MySize.size60,
//                        height: MySize.size40,
//                decoration: BoxDecoration(
//                 color: Colors.grey[400],
//                borderRadius: BorderRadius.all(Radius.circular(4)
              
//                )
               
//              ),
//              child: Center(child: Text("Track ID"))
//             ),
//             )
//               ],
//             ),
//           ),
          
           
        Container(
          // height: MediaQuery.of(context).size.height * 0.8,
          // padding: EdgeInsets.only(bottom: MySize.size40),
          child: Expanded(
            child: ListView.builder(
              itemCount:  jsonData.length,
              // widget.data.length,
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
                                        "Order Date:" +
                                            DateFormat("yyyy-MM-dd").format(
                                              DateTime.parse(jsonData[index]
                                                      ["orderDate"]
                                                  .toString()),
                                            ),
                                        style: AppTheme.getTextStyle(
                                          themeData.textTheme.button,
                                          fontWeight: 600,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Charges:\$",
                                      style: AppTheme.getTextStyle(
                                        themeData.textTheme.button,
                                        fontWeight: 550,
                                      ),
                                    ),
                                    Text(
                                      jsonData[index]["additionalCharges"]
                                          .toString(),
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
                                      "Name:" +
                                          jsonData[index]["userName"].toString(),
                                      style: AppTheme.getTextStyle(
                                        themeData.textTheme.button,
                                        fontWeight: 550,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    // // Text(
                                    // //   "UserName:" +
                                    // //       widget.data[index]["userName"].toString(),
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
                                      children: [
                                        Text(
                                          "order Service: ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(jsonData[index]["orderService"]),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "previousAmount: ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text("\$" +
                                            jsonData[index]["previousAmount"]
                                                .toString())
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
                                            openURl(jsonData[index]
                                                ["shipmentTrackingNumber"]);
                                          },
                                          child: Text(
                                            jsonData[index]
                                                    ["shipmentTrackingNumber"]
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
                                        Text(
                                          "Original Weight: ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(jsonData[index]["originalWeight"]
                                            .toString())
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "correctedWeight ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(jsonData[index]["correctedWeight"]
                                            .toString())
                                      ],
                                    ),
                                      Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Corrected Dimension:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      jsonData[index]["correctedDimensions"]==""? Text("N/A"):Text(jsonData[index]["correctedDimensions"].toString()
                                            .toString())
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Reason: ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                        Text(jsonData[index]["reason"].toString()),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Address: ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                        Text(jsonData[index]["shipmentAddress"]
                                            .toString()),
                                      ],
                                    )
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
  }
}
