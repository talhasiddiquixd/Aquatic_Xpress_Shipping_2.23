import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../AppTheme.dart';
import '../../../size_config.dart';

class CustomListView extends StatefulWidget {
  const CustomListView({Key? key, this.data}) : super(key: key);
  final data;
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
    name =p["userBook"]["lastName"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
    name =p["trackingNumber"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
    name =p["deliveryDate"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
    name =p["expectedDate"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
  });

  jsonData = result;
  setState(() {});
}  openURl(id) async {
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
      searchJson.add(widget.data);

              
            } catch (e) {
              print(e);
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
  
                'Sender Name',
                'Order Date',
                'Reciever Name',
                'Delivery Date',
                'Expected Date'
  
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
  child:   Container(
  
                       width:MySize.size60,
  
                       height: MySize.size40,
  
     decoration: BoxDecoration(
  
      color: Colors.grey[400],
  
     borderRadius: BorderRadius.all(Radius.circular(4)
  
    
  
     )
  
     
  
   ),
  
   child: Center(child: GestureDetector
   (
     onTap: (){
if(_chosenValue=="ASC" )
{
  if(chosenFieldValue=="Sender Name")
  {
jsonData.sort((a, b) => a["userAddress"]["lastName"].compareTo(b["userAddress"]["lastName"]));
print(jsonData[0]["userAddress"]["lastName"].toString());
  }
  else if(chosenFieldValue=="Order Date")
  {
    jsonData.sort((a, b) => a["orderDate"].compareTo(b["orderDate"]));
  }
  else if(chosenFieldValue=="Reciever Name")
  {
    jsonData.sort((a, b) => a["addressBook"]["lastName"].compareTo(b["addressBook"]["lastName"]));

  }
  else if (chosenFieldValue=="Delivery Date")
  {
jsonData.sort((a, b) => a["deliveryDate"].compareTo(b["deliveryDate"]));

  }
  else if (chosenFieldValue=="Expected Date")
  {
    jsonData.sort((a, b) => a["expectedDate"].compareTo(b["expectedDate"]));
  }
}
else if(_chosenValue=="DES")
{
  if(chosenFieldValue=="Sender Name")
  {
jsonData.sort((a, b) => b["userAddress"]["lastName"].compareTo(a["userAddress"]["lastName"]));
  }
  else if(chosenFieldValue=="Order Date")
  {
    jsonData.sort((a, b) => b["orderDate"].compareTo(a["orderDate"]));
  }
  else if(chosenFieldValue=="Reciever Name")
  {
    jsonData.sort((a, b) => b["addressBook"]["lastName"].compareTo(a["addressBook"]["lastName"]));

  }
  else if (chosenFieldValue=="Delivery Date")
  {
jsonData.sort((a, b) => b["deliveryDate"].compareTo(a["deliveryDate"]));

  }
  else if (chosenFieldValue=="Expected Date")
  {
    jsonData.sort((a, b) => b["expectedDate"].compareTo(a["expectedDate"]));
  }
}
     },
     child: Text("Sort")))
  
  ),
)  
    ],
  
  ),
),

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
// jsonData.sort((a, b) => a["userAddress"]["lastName"].compareTo(b["userAddress"]["lastName"]));
//             }
//             else if(_chosenValue=="DES")
//             {
// jsonData.sort((a, b) => b["userAddress"]["lastName"].compareTo(a["userAddress"]["lastName"]));
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
//  child: Center(child: Text("S Name"))
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
// jsonData.sort((a, b) => a["addressBook"]["lastName"].compareTo(b["addressBook"]["lastName"]));
//             }
//             else if(_chosenValue=="DES")
//             {
//               jsonData.sort((a, b) => b["addressBook"]["lastName"].compareTo(a["addressBook"]["lastName"]));

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
//                child: Center(child: Text("R Name"))
//               ),
//               ),
//               SizedBox(
//                 width:MySize.size10
//                 ),
//               GestureDetector(
//                           onTap: (){
//               if(_chosenValue=="ASC")
//             {
// jsonData.sort((a, b) => a["deliveryDate"].compareTo(b["deliveryDate"]));
//             }
//             else if(_chosenValue=="DES")
//             {
// jsonData.sort((a, b) => b["deliveryDate"].compareTo(a["deliveryDate"]));
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
//                child: Center(child: Text("D Date"))
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
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                  "Order Date: " , style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  Text(
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
                          // Row(
                          //   children: [
                          //     Text(
                          //       "Charges:\$",
                          //       style: AppTheme.getTextStyle(
                          //         themeData.textTheme.button,
                          //         fontWeight: 550,
                          //       ),
                          //     ),
                          //     Text(
                          //       widget.data[index]["additionalCharges"]
                          //           .toString(),
                          //       style: AppTheme.getTextStyle(
                          //         themeData.textTheme.button,
                          //         fontWeight: 550,
                          //       ),
                          //     ),
                          //   ],
                          // ),
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
                                "Sender Name: " ,style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),),
                                    Text(jsonData[index]["userAddress"]["lastName"].toString()
                                
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
                                    "Reciever Name: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(jsonData[index]["addressBook"]["lastName"]),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // // Text(
                                  // //   "previousAmount: ",
                                  // //   style: TextStyle(
                                  // //     fontWeight: FontWeight.bold,
                                  // //   ),
                                  // // ),
                                  // Text("\$" +
                                  //     widget.data[index]["previousAmount"]
                                  //         .toString())
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
                                          ["trackingNumber"]);
                                    },
                                    child: Text(
                                      jsonData[index]
                                              ["trackingNumber"]
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
                                    "Delivery Date: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(  DateFormat("yyyy-MM-dd").format(
                                        DateTime.parse(
                                    jsonData[index]["deliveryDate"]
                                      .toString()))),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Expected Delivery ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(   DateFormat("yyyy-MM-dd").format(
                                        DateTime.parse(jsonData[index]["expectedDate"]
                                      .toString()))),
                                ],
                              ),
                                Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Action:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                 jsonData[index]["isAppliedforRefund"]==null? Text("Change Status to Applied"):Text(
                                "Applied")
                                ],
                              ),
                              // Column(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       "Reason: ",
                              //       style: TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // Wrap(
                              //   children: [
                              //     Text(widget.data[index]["reason"].toString()),
                              //   ],
                              // ),
                              // Column(
                              //   children: [
                              //     Text(
                              //       "Address: ",
                              //       style: TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // Wrap(
                              //   children: [
                              //     Text(widget.data[index]["shipmentAddress"]
                              //         .toString()),
                              //   ],
                              // )
                            
                            
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
