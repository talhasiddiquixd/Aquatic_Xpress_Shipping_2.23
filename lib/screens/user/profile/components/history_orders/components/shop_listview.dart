import 'package:aquatic_xpress_shipping/screens/user/Shopping/Shopping.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aquatic_xpress_shipping/AppTheme.dart';
import 'package:aquatic_xpress_shipping/size_config.dart';

class ShopCustomListView extends StatefulWidget {
  final data;

  const ShopCustomListView({Key? key, required this.data}) : super(key: key);

  @override
  _ShopCustomListViewState createState() => _ShopCustomListViewState();
}

class _ShopCustomListViewState extends State<ShopCustomListView> {
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
    var name =p["products"]["name"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
     name =p['deal']["name"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
   name =p["orderDate"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
   name =p['deal']["products"]['details'].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }
  
   name =p["status"].toString().toLowerCase();
    if (name.contains(query)) {
      result.add(p);
    }

  // name =p['deal']['price'] *p["qty"].toString().toLowerCase();
  //   if (name.contains(query)) {
  //     result.add(p);
  //   }

    name =p['deal']["products"]['color'].toString().toLowerCase();
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
// double? price;

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
                'Deal',
                'OrderDate',
                'Details',
                'Status',
                // 'Price',
                'Color',
  
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
jsonData.sort((a, b) => a["products"]["name"].compareTo(b["products"]["name"]));
setState(() {});
  }
  else if(chosenFieldValue=="Deal")
  {
    jsonData.sort((a, b) => a["deal"]["name"].compareTo(b["deal"]["name"]));
    setState(() {});
  }
  else if(chosenFieldValue=="OrderDate")
  {
    jsonData.sort((a, b) => a["orderDate"].compareTo(b["orderDate"]));
    setState(() {});}
  else if(chosenFieldValue=="Details")
  {
jsonData.sort((a, b) => a["deal"]["products"]["details"].compareTo(b["deal"]["products"]["details"]));
    setState(() {}); }
  else if (chosenFieldValue=="Status")
  {
 jsonData.sort((a, b) => a["status"].compareTo(b["status"]));
setState(() {
});
  }
//   else if (chosenFieldValue=="Price")
//   {
//  jsonData.sort((a, b) => a["deal"]["price"]*a["qty"].compareTo(b["deal"]["price"]*b["price"]));
// setState(() {
  
// });}
  else if (chosenFieldValue=="Color")
  {
 jsonData.sort((a, b) => a["deal"]["products"]["Color"].compareTo(b["deal"]["products"]["Color"]));
setState(() {
  
});
}

}
else if(_chosenValue=="DES")
{
    if(chosenFieldValue=="Name")
  {
jsonData.sort((a, b) => b["products"]["name"].compareTo(a["products"]["name"]));
setState(() {
  
});
  }
  else if(chosenFieldValue=="Deal")
  {
    jsonData.sort((a, b) => b["deal"]["name"].compareTo(a["deal"]["name"]));
    setState(() {
  
});
  }
  else if(chosenFieldValue=="OrderDate")
  {
    jsonData.sort((a, b) => b["orderDate"].compareTo(a["orderDate"]));
    setState(() {
  
});}
  else if(chosenFieldValue=="Details")
  {
jsonData.sort((a, b) => b["deal"]["products"]["details"].compareTo(a["deal"]["products"]["details"]));
    setState(() {
  
});

  }
  else if (chosenFieldValue=="Status")
  {
 jsonData.sort((a, b) => b["status"].compareTo(a["status"]));
setState(() {
  
});



  }
//   else if (chosenFieldValue=="Price")
//   {
//  jsonData.sort((a, b) => b["deal"]["price"]*b["qty"].compareTo(a["deal"]["price"]*a["price"]));
// setState(() {
  
// });}
  else if (chosenFieldValue=="Color")
  {
 jsonData.sort((a, b) => b["deal"]["products"]["Color"].compareTo(a["deal"]["products"]["Color"]));
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
                margin: EdgeInsets.symmetric(
                  horizontal: MySize.size16,
                  vertical: MySize.size4,
                ),
                child: Card(
                  elevation: 15,
                  clipBehavior: Clip.antiAlias,
                  child: ListTileTheme(
                    contentPadding: EdgeInsets.fromLTRB(MySize.size10, 0, 0, 0),
                    child: ExpansionTile(
                      trailing: SizedBox.shrink(),
                      // trailing: Text(''),
                      title: Text(
                        jsonData[index]["products"]
                                ["name"]
                            .toString(),
                        style: AppTheme.getTextStyle(
                          themeData.textTheme.button,
                          fontWeight: 550,
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Deal: ",
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.button,
                                  fontWeight: 600,
                                ),
                              ),
                              Text(
                                jsonData[index]
                                        ['deal']["name"]
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
                             
                            ],
                          ),
                          Row(
                            children: [
                               Text(
                                "Date: ",
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.button,
                                  fontWeight: 600,
                                ),
                              ),
                              Text(
                                DateFormat("dd-MM-yyyy").format(
                                  DateTime.parse(widget
                                      .data[index]
                                          ["orderDate"]
                                      .toString()),
                                ),
                              ),
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
                                    "Details: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    jsonData[index]['deal']["products"]
                                            ['details']
                                        .toString(),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [ Text(
                                "Status: ",
                                style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                jsonData[index]
                                        ["status"]
                                    .toString(),
                                style: AppTheme.getTextStyle(
                                  themeData.textTheme.button,
                                  fontWeight: 550,
                                ),
                              ),],),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Price: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                 double.parse(((jsonData[index]['deal']
                                                              ['price'] *
                                                          jsonData[
                                                              index]["qty"]))
                                                      .toString())
                                                  .toStringAsFixed(2),
                                        
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Color: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    jsonData[index]['deal']["products"]
                                            ['color']
                                        .toString(),
                                  )
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
  }
}
