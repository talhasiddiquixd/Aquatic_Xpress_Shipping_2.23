import 'dart:async';
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:aquatic_xpress_shipping/models/SharedPref.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../../AppTheme.dart';
import '../../../../size_config.dart';

class ShopOrders extends StatefulWidget {
  const ShopOrders({Key? key}) : super(key: key);

  @override
  _ShopOrdersState createState() => _ShopOrdersState();
}

class _ShopOrdersState extends State<ShopOrders> {
  String ?_chosenValue="ASC";
  String ? chosenFieldValue;
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
  
  var    name=p["applicationIdentityUser"]["firstName"].toString().toLowerCase();
       if (name.contains(query)) {
      result.add(p);
      
    }

     name =p["products"]["price"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
      
    }
     name =p["orderDate"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
      
    }
     name =p["deal"]["name"].toString().toLowerCase();
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

  Future? futureUserList;
  late ThemeData themeData;
  bool isConnected = false;
  @override
  void initState() {
    super.initState();
    futureUserList = getUsers();

  }

  
  var data;
  getUsers() async {
    // quickQuote = 0;
    // curl();
    String? token = await getToken();

    String ?link =
        "${getCloudUrl()}/api/Products/getshoporders";
    

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
   
      print(data);
      return data;
    } else {
      print("Exception");
      throw Error;
    }
  }

  changStatus(id, String value) async {
    // quickQuote = 0;
    // curl();
    String? token = await getToken();
    String? actionStatus = "";
    if (value == "Recieved") {
      actionStatus = "Received";
    } else if (value == "Confirmed") {
      actionStatus = "Confirmed";
    } else if (value == "Pending") {
      actionStatus = "Pending";
      print(actionStatus);
    } else if (value == "Shipped") {
      actionStatus = "Shipped";
    }
    var url = Uri.parse(
        "${getCloudUrl()}/api/products/changeorderstatus?id=$id &status=$actionStatus");
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
     var results = json.decode(response.body);
     Flushbar(
       title: "Successfull",
       message: "Status Changed",
       duration: Duration(seconds:3 ) ,
     ).show(context);
     futureUserList=getUsers();
      setState(() {
       
     });
      print(results);
    }
    else{
       Flushbar(
       title: "Un Successfull",
       message: "Status not Changed",
       duration: Duration(seconds:3 ) ,
     ).show(context);
     
    
    }
  }

  String  _value = " ";
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
  
                'Name',
                'Order Date',
                'Price',
                'Deal',
                
  
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
  if(chosenFieldValue=="Name")
  {
jsonData.sort((a, b) => a["applicationIdentityUser"]["firstName"].compareTo(b["applicationIdentityUser"]["firstName"]));
setState(() {
  
});
print(jsonData[0]["userAddress"]["lastName"].toString());
  }
  else if(chosenFieldValue=="Order Date")
  {
    jsonData.sort((a, b) => a["orderDate"].compareTo(b["orderDate"]));
    setState(() {
  
});
  }
  else if(chosenFieldValue=="Price")
  {
jsonData.sort((a, b) => a["products"]["price"].compareTo(b["products"]["price"]));
    setState(() {
  
});

  }
  else if (chosenFieldValue=="Delivery Date")
  {
jsonData.sort((a, b) => a["deal"]["name"].compareTo(b["deal"]["name"]));
setState(() {
  
});

  }
 
}
else if(_chosenValue=="DES")
{
  if(chosenFieldValue=="Name")
  {
jsonData.sort((a, b) => b["applicationIdentityUser"]["firstName"].compareTo(a["applicationIdentityUser"]["firstName"]));
setState(() {
  
});
print(jsonData[0]["userAddress"]["lastName"].toString());
  }
  else if(chosenFieldValue=="Order Date")
  {
    jsonData.sort((a, b) => b["orderDate"].compareTo(a["orderDate"]));
    setState(() {
  
});
  }
  else if(chosenFieldValue=="Price")
  {
jsonData.sort((a, b) => b["products"]["price"].compareTo(a["products"]["price"]));
    setState(() {
  
});

  }
  else if (chosenFieldValue=="Delivery Date")
  {
jsonData.sort((a, b) => b["deal"]["name"].compareTo(a["deal"]["name"]));
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
            child: FutureBuilder(
      future: futureUserList,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: jsonData.length,
                itemBuilder: (BuildContext ctx, index) {
                  if (data.isEmpty) {
                    Center(child: Text("No Data"));
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Card(
                        elevation: 15,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        child: ListTileTheme(
                          contentPadding:
                              EdgeInsets.fromLTRB(MySize.size10, 0, 0, 0),
                          child: ExpansionTile(
                            trailing: SizedBox.shrink(),
                            title: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Order Date:" +
                                          (DateFormat('dd-MM-yy').format(
                                              DateTime.parse(
                                                  jsonData[index]["orderDate"]))),
                                      style: AppTheme.getTextStyle(
                                        themeData.textTheme.bodyText1,
                                        fontWeight: 550,
                                      ),
                                    ),
                                    Text(
                                      "Status:" +
                                          jsonData[index]["status"].toString(),
                                      style: AppTheme.getTextStyle(
                                        themeData.textTheme.bodyText1,
                                        fontWeight: 550,
                                      ),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Deal:" +
                                              jsonData[index]["deal"]["name"]
                                                  .toString(),
                                          style: AppTheme.getTextStyle(
                                            themeData.textTheme.bodyText1,
                                            fontWeight: 550,
                                          ),
                                        ),
                                        Text(
                                          "Qty:" +
                                              jsonData[index]["qty"].toString(),
                                          style: AppTheme.getTextStyle(
                                            themeData.textTheme.bodyText1,
                                            fontWeight: 550,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MySize.size10, right: MySize.size34),
                                child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Name:"),
                                        // Text(widget.data[index]
                                        //             ["applicationIdentityUser"]
                                        //             ["firstName"]
                                        //         .toString() +
                                        //     " " +
                                        jsonData[index]["applicationIdentityUser"]
                                                    .toString() ==
                                                "null"
                                            ? Text("---")
                                            : Text(jsonData[index][
                                                        "applicationIdentityUser"]
                                                    ["firstName"]
                                                .toString())
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Poduct:"),
                                        Text(
                                          jsonData[index]["products"]["name"]
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Details:"),
                                        Text(jsonData[index]["products"]["details"]
                                            .toString())
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Price:"),
                                        Text(
                                          "\$" +
                                              jsonData[index]["products"]["price"]
                                                  .toString(),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(MySize.size10, 0,
                                    MySize.size36, MySize.size10),
                                child: Column(children: [
                                  Column(
                                    children: [
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          canvasColor: Colors.white,
                                        ),
                                        child:        ElevatedButton(
                                               style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Colors.black,
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Colors.amber.shade200,
                                          ),
                                        ),
                                              onPressed: () {
                                               jsonData[index]["status"]=="Shipped"?_value="Shipped":jsonData[index]["status"]=="Recieved"? _value="Recieved":jsonData[index]["status"]=="Confirmed"?_value="Confirmed" :_value="Pending";
                                            
                                            _shippingBottomSheet(context, jsonData[index]["id"]);
                                              //  setState(() {
                                                 
                                              //  });
                                                // showDialog<String>(
                                                //   context: context,
                                                  

                                                //   builder:
                                                //       (BuildContext context) =>
                                                //           AlertDialog(
                                                //     title: const Text(
                                                //         'Change Status'),
                                                //     // content: const Text(
                                                //     //   'AlertDialog description'),
                                                //     actions: <Widget>[
                                                //       Center(
                                                //         child: Container()
                                                        
                                                //         ),
                                                //       // customTextField(
                                                //       //     creditController,
                                                //       //     "",
                                                //       //     "Add Credit"),
                                                //       Row(
                                                //         mainAxisAlignment:
                                                //             MainAxisAlignment
                                                //                 .end,
                                                //         children: [
                                                //           TextButton(
                                                //             onPressed: () =>
                                                //                 Navigator.pop(
                                                //                     context,
                                                //                     'Cancel'),
                                                //             child: const Text(
                                                //                 'Cancel'),
                                                //           ),
                                                //           TextButton(
                                                //             onPressed: () {
                                                              
                                                //               Navigator.pop(
                                                //                   context);
                                                //             },
                                                //             child: const Text(
                                                //                 'OK'),
                                                //           ),
                                                //         ],
                                                //       ),
                                                //     ],
                                                //   ),
                                                // );
                                              
                                              },
                                              
                                              child: Text("Change Status"),
                                            ),
                                     
                                        
                                        
                                     
                                      ),
                                      SizedBox(width: 10),
                                      ],
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Text("data");
                });
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
    )
  
    ),
        ),
      ],
    );
  }

  void _shippingBottomSheet(
    context,
    id,
  ) {
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
                    // margin: EdgeInsets.only(top: 5),
                    //height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16))),
                    child: Padding(
                        padding: EdgeInsets.only(
                          top: 1,
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

                                 Row(
                                   mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                   children: [
                                  SizedBox(width:MySize.size20),
                                    Padding(
                                      padding:  EdgeInsets.only(top:MySize.size20),
                                  child:DropdownButton(
                                                           focusColor:Colors.white,
  
                                              icon: Icon(Icons.edit),
                                        // label: Text("Change Status"),
  dropdownColor:themeData.backgroundColor,
                                            value: _value,
                                            items: [
                                              DropdownMenuItem(
                                                
                                                child: Material(
                                                  child: Text(
                                                    "Recieved",
                                                  ),
                                                ),
                                                value: "Recieved",
                                              ),
                                              DropdownMenuItem(
                                                child: Text("Confirmed"),
                                                value: "Confirmed",
                                              ),
                                              DropdownMenuItem(
                                                child: Text("Pending"),
                                                value: "Pending",
                                              ),
                                              DropdownMenuItem(
                                                child: Text("Shipped"),
                                                value: "Shipped",
                                              )
                                            ],
                                            onChanged: (String? value) {
                                              _value = value!;
modalsetState(() {
  
});                                              
                            

                                            },
                                            hint: Text("Change Status")),
                                                      
                                    ),
                               ElevatedButton(onPressed: (){
                                 changStatus(
                                              id, _value);
                                              Navigator.pop(context);
                               }, child: Text("Submit Changes"))
                                 ],
                                 
                                 ),
                                  SizedBox(width: 10), 
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
